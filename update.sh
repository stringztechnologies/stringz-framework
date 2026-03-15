#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo ""
echo "Updating Stringz Workflow framework..."
echo ""

# Version before pull
OLD_VERSION=$(grep -o 'version: [0-9.]*' "$REPO_DIR/WORKFLOW.md" 2>/dev/null | grep -o '[0-9.]*' || echo "unknown")

# Pull latest
git -C "$REPO_DIR" pull origin main

# Version after pull
NEW_VERSION=$(grep -o 'version: [0-9.]*' "$REPO_DIR/WORKFLOW.md" 2>/dev/null | grep -o '[0-9.]*' || echo "unknown")

if [ "$OLD_VERSION" != "$NEW_VERSION" ]; then
  echo "  Updated from v$OLD_VERSION -> v$NEW_VERSION"
else
  echo "  Already on latest v$NEW_VERSION"
fi

echo ""
echo "Re-linking any new skills..."
mkdir -p "$CLAUDE_DIR/skills"
NEW_SKILLS=0
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  if [ ! -L "$CLAUDE_DIR/skills/$skill_name" ]; then
    ln -s "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
    echo "  NEW skill linked: $skill_name"
    NEW_SKILLS=$((NEW_SKILLS + 1))
  fi
done
if [ "$NEW_SKILLS" -eq 0 ]; then
  echo "  No new skills to link"
fi

echo ""
echo "Re-linking any new agents..."
mkdir -p "$CLAUDE_DIR/agents"
NEW_AGENTS=0
for agent_file in "$REPO_DIR"/agents/*.md; do
  agent_name=$(basename "$agent_file")
  if [ ! -L "$CLAUDE_DIR/agents/$agent_name" ]; then
    ln -s "$agent_file" "$CLAUDE_DIR/agents/$agent_name"
    echo "  NEW agent linked: $agent_name"
    NEW_AGENTS=$((NEW_AGENTS + 1))
  fi
done
if [ "$NEW_AGENTS" -eq 0 ]; then
  echo "  No new agents to link"
fi

echo ""
echo "Syncing STRINGZ.md..."
if [ -f "$CLAUDE_DIR/STRINGZ.md" ]; then
  echo "  ~/.claude/STRINGZ.md exists — not overwriting (your personal config)"
  echo "  Check templates/STRINGZ.md.template for any new sections you may want to add"
else
  cp "$REPO_DIR/templates/STRINGZ.md.template" "$CLAUDE_DIR/STRINGZ.md"
  echo "  STRINGZ.md.template copied to ~/.claude/STRINGZ.md — edit with your details"
fi

TOTAL_SKILLS=$(ls -d "$REPO_DIR"/skills/*/ 2>/dev/null | wc -l | tr -d ' ')
TOTAL_AGENTS=$(ls "$REPO_DIR"/agents/*.md 2>/dev/null | wc -l | tr -d ' ')
TOTAL_TEMPLATES=$(ls "$REPO_DIR"/templates/*.template 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "Framework updated to v$NEW_VERSION"
echo "  Skills: $TOTAL_SKILLS"
echo "  Agents: $TOTAL_AGENTS"
echo "  Templates: $TOTAL_TEMPLATES"
echo ""
