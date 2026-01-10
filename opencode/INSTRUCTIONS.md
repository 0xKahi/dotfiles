# General Instructions 

## Rules

### RFC 2119
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in `RFC 2119`.

## Skill Ussage
<important-skills>
  <important-skill id="exploration">
    <description>skill for cordinating specialized subagents to do exploration task</description>
    <use-cases>
      <case>searching through the codebae for specific patterns</case>
      <case>Contextual grep for codebases</case>
      <case>exloring/searching the internet for code related information</case>
      <case>exloring/searching the internet for generic information</case>
    </use-cases>
    <recommendation level="REQUIRED">Use when trying to explore the codebase or internet for information</recommendation>
  </important-skill>
</important-skills>

## Report Workflow
1. carefully analyze the request
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
