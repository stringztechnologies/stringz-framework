# Stringz Technologies — Global Context

> This file lives at ~/.claude/STRINGZ.md and is loaded into every Claude Code session.
> It tells Claude who you are, how you work, and what to do in any project.

## Who I Am
- **Name:** Oretayo Fatokun
- **Company:** Stringz Technologies
- **Location:** Addis Ababa, Ethiopia
- **Role:** Founder — I design, build, and deliver web applications for clients using AI-assisted development

## How I Work
- I follow the **Stringz Workflow v2** (Level 5: Agent-First Engineering)
- Framework repo: github.com/stringztechnologies/claude-skills
- Every project follows 6 phases: Specify → Architect → Implement → Verify+Deploy → Brand → Deliver
- I use Claude Code (Opus) as the primary builder with Sonnet subagents
- I use AionUI for parallel session orchestration
- I deploy to Coolify (self-hosted) or Vercel

## My Stack
- **Framework:** Next.js 15 (App Router)
- **Database:** Supabase (Postgres + Auth + Storage + RLS)
- **Styling:** Tailwind CSS + shadcn/ui
- **Deployment:** Coolify at self-hosted server, auto-deploy from GitHub
- **Testing:** Vitest + Playwright
- **Linting:** Biome

## Critical Rule
**If CLAUDE.md does not exist in this project, ask me:**
> "This project doesn't have a CLAUDE.md. Should I onboard it to the Stringz Workflow, or start fresh?"

- If I say **onboard**: Analyze the codebase, generate CLAUDE.md, KNOWLEDGE.md, TASKS.md, and REVIEW.md from what exists
- If I say **start fresh**: Begin Phase 1 (Specify) — interview me to build the spec
- If I say **quick and scrappy**: Create minimal CLAUDE.md + KNOWLEDGE.md only, skip the full 6-phase process

## Before Any PR or Push
Always run this verification sequence:
1. `npm run lint` — must pass clean
2. `npm run build` — must pass clean
3. Run architecture-enforcer subagent (if available in .claude/agents/)
4. Run security-auditor subagent for any auth/input/API changes
5. Conventional commit messages: `type(scope): description`

## Skills & Agents
- Global skills at: ~/.claude/skills/
- Global agents at: ~/.claude/agents/
- Check which skills apply to the current project before starting implementation

## Communication Preferences
- Be concise. Skip preamble.
- Show code first, explain after if needed.
- When uncertain, say so — don't hallucinate confidence.
- Don't summarize what you just did — I can read the diff.
- Don't suggest things to "consider" unless I ask.

## Context for Claude Desktop / Web Chat
When I start a conversation on Claude Desktop or web, I may paste:
```
I'm Oretayo from Stringz Technologies. I follow the Stringz Workflow v2
(Level 5 Agent-First Engineering). Framework: github.com/stringztechnologies/claude-skills
```
This means: use the workflow principles even in chat — interview me for specs, think in modules, suggest wave-based implementation.
