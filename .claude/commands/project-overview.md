---
description: Generate comprehensive project structure documentation with directory tree, architecture, tech stack, setup commands, and best practices for any project type
---

You are tasked with creating a comprehensive project structure document for the current project.

## Tasks to Complete:

1. **Analyze Project Type**
   - Detect project type (web app, API, ML/AI, mobile, data pipeline, etc.)
   - Identify primary programming language(s)
   - Detect frameworks and key libraries used

2. **Generate Complete Directory Tree**
   - List all directories and files in the project
   - Provide a brief description of the purpose of each component
   - Exclude: `.venv`, `venv`, `__pycache__`, `.git`, `node_modules`, `*.pyc`, `dist`, `build`
   - Organize by logical grouping (source, tests, configs, data, deployment, docs)

3. **Architecture & Data/Code Flow**
   - Identify main application flow or pipeline stages
   - Document entry points (main files, startup scripts)
   - Show how components interact with each other
   - For ML projects: data processing → training → inference
   - For web apps: frontend → backend → database
   - For APIs: request → routing → processing → response
   - Create ASCII diagram showing component relationships

4. **Technology Stack Overview**
   - Runtime/Language (Python, Node.js, Java, etc.)
   - Frameworks (React, FastAPI, Django, Spring, etc.)
   - Databases (PostgreSQL, MongoDB, Redis, etc.)
   - External services (AWS, APIs, third-party integrations)
   - Development tools (Docker, testing frameworks, linters)
   - Package manager (pip, npm, maven, etc.)

5. **Setup & Quick Start Commands**
   - Environment setup (virtual env, dependency installation)
   - Database setup (if applicable)
   - Configuration steps (env variables, config files)
   - Development server startup
   - Testing commands
   - Build/deployment commands
   - Access URLs and ports

6. **Key Features & Components**
   - List main features or capabilities
   - Important modules/packages and their purposes
   - API endpoints (if applicable)
   - Database schemas (if applicable)
   - Configuration options

7. **Best Practices & Guidelines**
   - Development workflow recommendations
   - Testing practices
   - Code organization principles
   - Deployment considerations
   - Security practices
   - Performance optimization tips

## Output Requirements:

- Create the document at: `docs/project-structure.txt` (create docs/ directory if needed)
- Use clear ASCII formatting with section dividers (===)
- Keep descriptions concise (1-2 lines per item)
- Include actual file paths and commands found in the project
- Auto-detect and adapt to project type
- Format as a reference guide that can be quickly scanned
- Include a table of contents at the top

The document should serve as a comprehensive onboarding guide for new developers joining ANY type of project.
