---
name: exploration
description: >- 
  assist users in exploring the codebase or expolore the internet for code
  documentation, examples, or general information by leveraging specialized
  subagents like @explorer, @librarian, @researcher, to provide accurate searches
---

# Exploration Skill

An intelligent routing skill that analyzes user exploration(codebase/internet) requests and
delegates to specialized subagents based on the nature of the information
needed. Optimizes search quality by matching request type to the most
appropriate search tool.

## Avaialable Subagents

### `@explorer`
**Trigger**: Search through the Codebase to find existing codebase structure, patterns and styles
**Best for prompts like**:
- "Where is X implemented?"
- "Which files contain Y?"
- "Find the code that does Z"

**Use When**:
- Multiple search angles needed
- Unfamiliar module structure
- Cross-layer pattern discovery

**Avoid When**:
- You know exactly what to search
- Single keyword/pattern suffice
- Known file location

### `@librarian`
**Trigger**: Unfamiliar packages / libraries, struggles at weird behaviour (to find existing implementation of opensource)
**Best for prompts like**:
- "How do I use [library]?",
- "What's the best practice for [framework feature]?",
- "Why does [external dependency] behave this way?",
- "Find examples of [library] usage",

**Use When**:
- when needing to search the internet for code related to external libraries/packages
- Working with unfamiliar npm/pip/cargo packages

### `@researcher`
**Trigger**: web searches for generic information, that is non code related
**Use When**:
- General information and encyclopedia-style content
- Current events and news
- Product research and comparisons
- Company information and business intelligence
- Trends, statistics, and market data
- Non-technical documentation and guides
- Fact-checking and verification

## Workflow
### Step 1: Analyze the Request
Examine the user's query to determine:
- **Domain**: Is it exploring current codebase? or online technical/programming-related/general knowledge?
- **Information type**: Documentation, examples, facts, trends, explanations?
- **Specificity**: Narrow technical query vs broad exploratory search?
- **Recency requirements**: Does it need current/real-time information?

### Step 2: Formulate Search Strategy
Based on analysis, determine:
- **Primary subagent**: Which subagent is best suited?
- **Query refinement**: Should the query be rephrased for better results?
- **Applicable**: are any of the subagents applicable?
- **Fallback plan**: What to do if none of the agents are applicable?

### Step 3: Delegate to Subagent
Invoke the selected subagent with:
- Clear, specific instructions on what information to find Context from the user's original request
- Expected format or depth of results
- Any constraints (date ranges, specific sources, etc.)

**Delegation template**:
```
Search for [specific information] related to [user's topic].
Focus on [documentation/examples/explanations/etc.].
Return [code examples/API references/factual summary/etc.].
```

### Step 4: Evaluate Results
When subagent returns:
- **Quality check**: Are results relevant and comprehensive?
- **Completeness**: Does it answer the user's question?
- **Accuracy**: Do results appear credible and current?

### Step 5: Fallback Strategy (if needed)
If none of the subagents are applicable:
- Inform the user that the current skill would not be used for their request with a brief explanation on why.

**Fallback scenarios**:
- when you know exactly what to search in the codbase and dont need `@explorer` agent
- when question is too simple and does not need `@librarian` or `@researcher` agent for online searches

