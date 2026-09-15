# AI Use - DATA 266 Homework 3

Student: Nikhil Kanaparthi  
SID4: 6441

## 1. What I used an assistant for

I used an AI assistant to help organize the notebook, convert the prompt-engineering
requirements into twelve LangChain code examples, draft the from-scratch attention model,
and troubleshoot the deliverable checklist. I personally ran the notebook, reviewed every
generated answer, checked the attention matrices and heatmaps, and verified that the final
files matched the assignment requirements.

## 2. One specific problem in the initial approach

The initial notebook used the model name `gemini-2.5-flash`. When I ran the LangChain
connection cell, the API rejected that model for a new user account. The key part of the
error was:

```text
ClientError: 404 NOT_FOUND: This model models/gemini-2.5-flash is no longer
available to new users.
```

This meant the prompt experiments could not run even though the API key and LangChain setup
were otherwise correct.

## 3. How I found the problem

I found the problem by reading the complete 404 message printed by Step 5. It specifically
identified the retired model name and recommended the replacement model. Because the request
reached the Gemini API and returned a model-specific response, I knew the API key was working.

## 4. What I changed and why it works

I changed `PROMPT_MODEL` from `gemini-2.5-flash` to `gemini-3.6-flash`, the model named in the
API error and current Gemini model documentation. I then reran the connection cell before
running the prompt experiments. This change works because the LangChain code and prompts stay
the same while the request is sent to an available model endpoint.
