---
name: analyze-prompt 
description: analyze the user request and return the characteristics of the request 
---

## WorkFlow 
1. carefully analyze the request: "$ARGUMENTS"
2. determine the request characteristis:   
  - Complexity (simple/medium/complex)
  - Scope (feature/bugfix/research/refactor/explanation/general)
  - Domain (frontend/backend/devops/documentation/generic) 
3. after determining the request characteristics always include its summary at the start of your response in the format below:
```md
┌─────────────────────────────────────────────────────────────┐
│ Complexity: {insert request complexity here}                │
│ Scope: {insert request scope here}                          │
│ Domain: {insert request domain here}                        │
└─────────────────────────────────────────────────────────────┘
```


## When to use me
Use this when you are preparing to respond to user request 
always return the characteristics of the request as specified above
