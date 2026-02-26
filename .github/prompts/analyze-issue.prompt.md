---
name: analyze-issue
description: Analyze an issue and create a structured implementation plan for AI consumption.
model: Raptor mini (Preview) (copilot)
agent: agent
---

You are an expert software architect and AI coding assistant. Your task is to analyze the provided issue and create a detailed, step-by-step implementation plan.

The issue details are provided in the attached file.

**Task:**
1. Read and analyze the provided issue description.
2. Break down the issue into logical, actionable steps.
3. Identify the files that need to be created or modified.
4. Generate a structured implementation plan.

**Output Requirements:**
- Output your response into a new markdown file named `issue-[issue-id]-plan.md` (where `[issue-id]` is the numeric ID extracted from the provided issue file's name).
- The markdown file must be structured specifically to be easily parsed and executed by an AI coding agent in a subsequent step. Use clear headings, bullet points, and exact file paths.

**Required Markdown Structure for the Plan:**

# Implementation Plan: [Issue Title]

## Context
[Brief summary of what needs to be done and why]

## Files to Modify
- `path/to/file1.ext`: [Brief description of changes]
- `path/to/file2.ext`: [Brief description of changes]

## Step-by-Step Implementation

### Step 1: [Actionable Title]
- **Target File:** `path/to/file`
- **Action:** [Create/Modify/Delete]
- **Details:** [Specific code changes, logic to implement, or functions to add. Be precise so an AI can implement it directly.]

### Step 2: [Actionable Title]
...
