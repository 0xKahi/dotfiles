# Base Subagents Guide 

## Global Subagents 

### Exploration Subagents
agents specialized in doing exploration tasks whether it is searching through the codebase or searching the internet for code documentation, examples, or
general information by leveraging specialized subagents to provide accurate searches.

<subagents category="exploration">
  <subagent id="explorer">
    <description>Subagent that specialize in searching through the Codebase to find existing codebase structure, patterns and styles</description>
    <prompt-triggers>
      <trigger>"Where is X implemented?"</trigger>
      <trigger>"Which files contain Y?"</trigger>
      <trigger>"Find the code that does Z"</trigger>
    </prompt-triggers>
    <use-cases>
      <case>Multiple search angles needed</case>
      <case>Unfamiliar module structure</case>
      <case>finding stackoverflow solutions for coding problems</case>
      <case>Cross-layer pattern discovery</case>
    </use-cases>
    <avoid-when>
      <condition>You know exactly what to search</condition>
      <condition>Single keyword/pattern suffice</condition>
      <condition>Known file location</condition>
    </avoid-when>
    <recommendation level="RECOMMENDED">Use when trying to search for content, files, code references etc. in the code base</recommendation>
  </subagent>
  
  <subagent id="librarian">
    <description>
      Specialized codebase understanding agent for multi-repository analysis,
      searching remote codebases, retrieving official documentation, and finding
      implementation examples using GitHub CLI, Context7, and Web Search. 
    </description>
    <prompt-triggers>
      <trigger>"How do I use [library]?"</trigger>
      <trigger>"What's the best practice for [framework feature]?"</trigger>
      <trigger>"Why does [external dependency] behave this way?"</trigger>
    </prompt-triggers>
    <use-cases>
      <case>when needing to search the internet for code related to external libraries/packages</case>
      <case>Working with unfamiliar npm/pip/cargo packages</case>
    </use-cases>
    <recommendation level="REQUIRED">when users ask to look up code in remote repositories, explain library internals, or find usage examples in open source</recommendation>
  </subagent>
  
  <subagent id="researcher">
    <description>subagent equipped with tools for doing web searches for generic information, that is non code related</description>
    <use-cases>
      <case>General information and encyclopedia-style content</case>
      <case>Current events and news</case>
      <case>Product research and comparisons</case>
      <case>Company information and business intelligence</case>
      <case>Trends, statistics, and market data</case>
      <case>Non-technical documentation and guides</case>
      <case>Fact-checking and verification</case>
    </use-cases>
    <recommendation level="SHOULD">Use when unsure about questions that require factual information, documentation, or broad research</recommendation>
  </subagent>
</subagents>

### Specialist Subagents
subagents specialized in handling specific types of requests such as documentation writing, code reviews, and error diagnosicts. 

<subagents category="specialist">
  <subagent id="code-reviewer">
    <description>specialized in doing code reviews for quality, best practices, and maintainability</description>
    <use-cases>
      <case>reviewing code quality and security</case>
      <case>checking best practices</case>
      <case>assessing maintainability</case>
      <case>reviewing newly written or modified code</case>
    </use-cases>
    <recommendation level="REQUIRED">Use when user request includes code review</recommendation>
  </subagent>
  
  <subagent id="document-writer">
    <description>A technical writer who crafts clear, comprehensive documentation. Specializes in README files, API docs, architecture docs, and user guides. MUST BE USED when executing documentation tasks from ai-todo list plans.</description>
    <use-cases>
      <case>when documentation is needed</case>
      <case>updating README docs</case>
    </use-cases>
    <recommendation level="SHOULD">use when creating or updating documentation</recommendation>
  </subagent>
</subagents>

### Utility Subagents

<subagents category="utility">
  <subagent id="multimodal-looker">
    <description>Analyze media files (PDFs, images, diagrams) that require interpretation beyond raw text</description>
    <use-cases>
      <case>Media files the Read tool cannot interpret</case>
      <case>Extracting specific information or summaries from documents</case>
      <case>Describing visual content in images or diagrams</case>
      <case>When analyzed/extracted data is needed, not raw file contents</case>
    </use-cases>
    <avoid-when>
      <condition>Source code or plain text files needing exact contents (use Read)</condition>
      <condition>Files that need editing afterward (need literal content from Read)</condition>
      <condition>Simple file reading where no interpretation is needed</condition>
    </avoid-when>
    <recommendation level="SHOULD">Use when You need to interpret media files that cannot be read as plain text.</recommendation>
  </subagent>
</subagents>
