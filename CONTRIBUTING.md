# Contributing to the Stringz Workflow

## For Team Members

### Getting Access
1. Request collaborator access to this repo from Oretayo
2. Clone: `git clone https://github.com/stringztechnologies/stringz-framework.git`
3. Run setup: `./setup.sh` (macOS/Linux) or `.\setup.ps1` (Windows)
4. Edit `~/.claude/STRINGZ.md` with YOUR personal details

### Adding Skills
When you build a project and discover a reusable pattern:
1. Create a folder in `skills/[skill-name]/`
2. Add `SKILL.md` with the methodology, patterns, and best practices
3. Open a PR with a clear description of what the skill covers
4. After merge, teammates run `./update.sh` to get the new skill

### Adding Agents
1. Create a `.md` file in `agents/[agent-name].md`
2. Include YAML frontmatter (name, description, tools, model)
3. Include the system prompt as markdown body
4. Open a PR
5. After merge, teammates run `./update.sh`

### Updating Templates
Templates affect every new project. Changes should be discussed before merging.
Open a PR and tag Oretayo for review.

### Updating WORKFLOW.md
WORKFLOW.md is the master process. Changes here affect how every project is run.
This requires explicit approval from Oretayo before merging.

## For External Contributors
This is a private repo. If you'd like to use this framework:
1. Fork the repo
2. Run `./setup.sh`
3. Customize `STRINGZ.md.template` with your own company details
4. Build your own skills as you complete projects
