
#include <cuda_runtime.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <vector>

#define CUDA_CHECK(call) do {                                      \
    cudaError_t error = (call);                                    \
    if (error != cudaSuccess) {                                    \
        std::fprintf(                                               \
            stderr,                                                 \
            "CUDA error at %s:%d: %s\n",                           \
            __FILE__,                                               \
            __LINE__,                                               \
            cudaGetErrorString(error)                               \
        );                                                          \
        std::exit(EXIT_FAILURE);                                   \
    }                                                               \
} while (0)

constexpr int TILE_SIZE = 16;


// CUDA tiled matrix-multiplication kernel
__global__ void tiledMatrixMultiply(
    const float* A,
    const float* B,
    float* C,
    int N
) {
    __shared__ float tileA[TILE_SIZE][TILE_SIZE];
    __shared__ float tileB[TILE_SIZE][TILE_SIZE];

    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    float sum = 0.0f;

    int number_of_tiles = (N + TILE_SIZE - 1) / TILE_SIZE;

    for (int tile = 0; tile < number_of_tiles; ++tile) {
        int a_col = tile * TILE_SIZE + threadIdx.x;
        int b_row = tile * TILE_SIZE + threadIdx.y;

        if (row < N && a_col < N) {
            tileA[threadIdx.y][threadIdx.x] =
                A[row * N + a_col];
        } else {
            tileA[threadIdx.y][threadIdx.x] = 0.0f;
        }

        if (b_row < N && col < N) {
            tileB[threadIdx.y][threadIdx.x] =
                B[b_row * N + col];
        } else {
            tileB[threadIdx.y][threadIdx.x] = 0.0f;
        }

        __syncthreads();

        for (int k = 0; k < TILE_SIZE; ++k) {
            sum += (
                tileA[threadIdx.y][k] *
                tileB[k][threadIdx.x]
            );
        }

        __syncthreads();
    }

    if (row < N && col < N) {
        C[row * N + col] = sum;
    }
}


// CPU reference implementation
void cpuMatrixMultiply(
    const float* A,
    const float* B,
    float* C,
    int N
) {
    std::fill(C, C + static_cast<size_t>(N) * N, 0.0f);

    // i-k-j ordering improves CPU cache behavior.
    for (int i = 0; i < N; ++i) {
        for (int k = 0; k < N; ++k) {
            float a_value = A[i * N + k];

            for (int j = 0; j < N; ++j) {
                C[i * N + j] += a_value * B[k * N + j];
            }
        }
    }
}


double median(std::vector<double> values) {
    std::sort(values.begin(), values.end());

    size_t middle = values.size() / 2;

    if (values.size() % 2 == 1) {
        return values[middle];
    }

    return (values[middle - 1] + values[middle]) / 2.0;
}


int main(int argc, char** argv) {
    if (argc < 2) {
        std::fprintf(
            stderr,
            "Usage: %s MATRIX_SIZE [REPEATS]\n",
            argv[0]
        );
        return EXIT_FAILURE;
    }

    int N = std::atoi(argv[1]);
    int repeats = (argc >= 3) ? std::atoi(argv[2]) : 3;

    if (N <= 0 || repeats <= 0) {
        std::fprintf(
            stderr,
            "Matrix size and repetitions must be positive.\n"
        );
        return EXIT_FAILURE;
    }

    size_t element_count = static_cast<size_t>(N) * N;
    size_t bytes = element_count * sizeof(float);

    std::vector<float> A(element_count);
    std::vector<float> B(element_count);
    std::vector<float> C_cpu(element_count);
    std::vector<float> C_gpu(element_count);

    // Deterministic input values
    for (size_t i = 0; i < element_count; ++i) {
        A[i] = static_cast<float>((i * 17) % 100) / 100.0f;
        B[i] = static_cast<float>((i * 29) % 100) / 100.0f;
    }

    std::printf("Matrix size: %d x %d\n", N, N);
    std::printf("Repetitions: %d\n", repeats);
    std::printf(
        "Threads per block: %d x %d = %d\n",
        TILE_SIZE,
        TILE_SIZE,
        TILE_SIZE * TILE_SIZE
    );

    // Small CPU warm-up
    {
        constexpr int warm_size = 64;

        std::vector<float> warm_A(
            warm_size * warm_size,
            1.0f
        );

        std::vector<float> warm_B(
            warm_size * warm_size,
            1.0f
        );

        std::vector<float> warm_C(
            warm_size * warm_size
        );

        cpuMatrixMultiply(
            warm_A.data(),
            warm_B.data(),
            warm_C.data(),
            warm_size
        );
    }

    // Measure CPU baseline
    std::vector<double> cpu_times;

    for (int repeat = 0; repeat < repeats; ++repeat) {
        auto cpu_start =
            std::chrono::high_resolution_clock::now();

        cpuMatrixMultiply(
            A.data(),
            B.data(),
            C_cpu.data(),
            N
        );

        auto cpu_stop =
            std::chrono::high_resolution_clock::now();

        double cpu_ms =
            std::chrono::duration<double, std::milli>(
                cpu_stop - cpu_start
            ).count();

        cpu_times.push_back(cpu_ms);
    }

    // Allocate GPU memory
    float* d_A = nullptr;
    float* d_B = nullptr;
    float* d_C = nullptr;

    CUDA_CHECK(cudaMalloc(&d_A, bytes));
    CUDA_CHECK(cudaMalloc(&d_B, bytes));
    CUDA_CHECK(cudaMalloc(&d_C, bytes));

    dim3 threads_per_block(TILE_SIZE, TILE_SIZE);

    dim3 blocks_per_grid(
        (N + TILE_SIZE - 1) / TILE_SIZE,
        (N + TILE_SIZE - 1) / TILE_SIZE
    );

    // Full GPU warm-up
    CUDA_CHECK(
        cudaMemcpy(
            d_A,
            A.data(),
            bytes,
            cudaMemcpyHostToDevice
        )
    );

    CUDA_CHECK(
        cudaMemcpy(
            d_B,
            B.data(),
            bytes,
            cudaMemcpyHostToDevice
        )
    );

    tiledMatrixMultiply<<<
        blocks_per_grid,
        threads_per_block
    >>>(
        d_A,
        d_B,
        d_C,
        N
    );

    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(
        cudaMemcpy(
            C_gpu.data(),
            d_C,
            bytes,
            cudaMemcpyDeviceToHost
        )
    );

    cudaEvent_t event_start;
    cudaEvent_t event_stop;

    CUDA_CHECK(cudaEventCreate(&event_start));
    CUDA_CHECK(cudaEventCreate(&event_stop));

    std::vector<double> kernel_times;
    std::vector<double> transfer_times;
    std::vector<double> end_to_end_times;

    for (int repeat = 0; repeat < repeats; ++repeat) {
        float h2d_ms = 0.0f;
        float kernel_ms = 0.0f;
        float d2h_ms = 0.0f;

        // Measure two host-to-device transfers
        CUDA_CHECK(cudaEventRecord(event_start));

        CUDA_CHECK(
            cudaMemcpy(
                d_A,
                A.data(),
                bytes,
                cudaMemcpyHostToDevice
            )
        );

        CUDA_CHECK(
            cudaMemcpy(
                d_B,
                B.data(),
                bytes,
                cudaMemcpyHostToDevice
            )
        );

        CUDA_CHECK(cudaEventRecord(event_stop));
        CUDA_CHECK(cudaEventSynchronize(event_stop));

        CUDA_CHECK(
            cudaEventElapsedTime(
                &h2d_ms,
                event_start,
                event_stop
            )
        );

        // Measure kernel only
        CUDA_CHECK(cudaEventRecord(event_start));

        tiledMatrixMultiply<<<
            blocks_per_grid,
            threads_per_block
        >>>(
            d_A,
            d_B,
            d_C,
            N
        );

        CUDA_CHECK(cudaGetLastError());
        CUDA_CHECK(cudaEventRecord(event_stop));
        CUDA_CHECK(cudaEventSynchronize(event_stop));

        CUDA_CHECK(
            cudaEventElapsedTime(
                &kernel_ms,
                event_start,
                event_stop
            )
        );

        // Measure device-to-host transfer
        CUDA_CHECK(cudaEventRecord(event_start));

        CUDA_CHECK(
            cudaMemcpy(
                C_gpu.data(),
                d_C,
                bytes,
                cudaMemcpyDeviceToHost
            )
        );

        CUDA_CHECK(cudaEventRecord(event_stop));
        CUDA_CHECK(cudaEventSynchronize(event_stop));

        CUDA_CHECK(
            cudaEventElapsedTime(
                &d2h_ms,
                event_start,
                event_stop
            )
        );

        double combined_transfer_ms = h2d_ms + d2h_ms;
        double combined_end_to_end_ms =
            combined_transfer_ms + kernel_ms;

        kernel_times.push_back(kernel_ms);
        transfer_times.push_back(combined_transfer_ms);
        end_to_end_times.push_back(combined_end_to_end_ms);
    }

    // Compare CPU and GPU results
    double max_absolute_error = 0.0;
    double max_relative_error = 0.0;

    for (size_t i = 0; i < element_count; ++i) {
        double absolute_error = std::fabs(
            static_cast<double>(C_cpu[i]) -
            static_cast<double>(C_gpu[i])
        );

        double denominator = std::max(
            1.0e-6,
            std::fabs(static_cast<double>(C_cpu[i]))
        );

        double relative_error = absolute_error / denominator;

        max_absolute_error = std::max(
            max_absolute_error,
            absolute_error
        );

        max_relative_error = std::max(
            max_relative_error,
            relative_error
        );
    }

    bool correct = max_relative_error < 1.0e-3;

    double cpu_median_ms = median(cpu_times);
    double kernel_median_ms = median(kernel_times);
    double transfer_median_ms = median(transfer_times);
    double end_to_end_median_ms = median(end_to_end_times);

    double speedup = cpu_median_ms / end_to_end_median_ms;

    std::printf("\nMedian CPU time (ms): %.6f\n", cpu_median_ms);
    std::printf(
        "Median GPU kernel time (ms): %.6f\n",
        kernel_median_ms
    );
    std::printf(
        "Median H2D+D2H time (ms): %.6f\n",
        transfer_median_ms
    );
    std::printf(
        "Median GPU end-to-end time (ms): %.6f\n",
        end_to_end_median_ms
    );
    std::printf("End-to-end speedup: %.6fx\n", speedup);
    std::printf(
        "Maximum absolute error: %.8f\n",
        max_absolute_error
    );
    std::printf(
        "Maximum relative error: %.8f\n",
        max_relative_error
    );
    std::printf(
        "Correctness: %s\n",
        correct ? "PASS" : "FAIL"
    );

    // Machine-readable output for the notebook
    std::printf(
        "RESULT,%d,%.6f,%.6f,%.6f,%.6f,%.6f,%.8f,%.8f,%s\n",
        N,
        cpu_median_ms,
        kernel_median_ms,
        transfer_median_ms,
        end_to_end_median_ms,
        speedup,
        max_absolute_error,
        max_relative_error,
        correct ? "PASS" : "FAIL"
    );

    CUDA_CHECK(cudaEventDestroy(event_start));
    CUDA_CHECK(cudaEventDestroy(event_stop));

    CUDA_CHECK(cudaFree(d_A));
    CUDA_CHECK(cudaFree(d_B));
    CUDA_CHECK(cudaFree(d_C));

    return correct ? EXIT_SUCCESS : EXIT_FAILURE;
}
