---
name: web-search 
description: effeciently and effectively search the web for information, documentation, code-examples 
---

## When to use me
Use this when you are preparing to search the web for information 

## SubAgents Available To you

- `@code-researcher`: equipped with the `exa` and `context7` mcp tool to help 
    - retrieving documentation
    - searching github repositories and stackoverflow post for code examples and context about coding related questions
- `@web-researcher`: specialized in doing broad and generic searches the web for more answers, fact-tracking etc..

## WorkFlow 
1. Analyze the user request and determine the nature of the information needed
2. determine the appopriate subagent to handle the request
3. for documentation retrvieval, or searching up code examples use `@code-researcher` subagent
4. for generic web searches use `@web-researcher` subagent

## Instructions
- if subagent response is unsatisfactory consider fallingback to `@web-researcher` subagent for more generic results

## Report
- summarize the actions taken by each subagent
- compile the results into a final response for the user
- keep it concise and focused on addressing the user's original request


