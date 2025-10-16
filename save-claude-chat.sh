#!/bin/bash

# Claude Chat Backup Script
# Automatically save Ubuntu Claude chat history to current Windows project directory

set -e

# Configuration
CLAUDE_LOG_SOURCE="/home/qingxuantang/.claude.json"
CURRENT_DIR=$(pwd)
CLAUDE_DIR="$CURRENT_DIR/.claude"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Claude Chat Backup Script ===${NC}"
echo -e "${BLUE}Current directory: ${YELLOW}$CURRENT_DIR${NC}"
echo

# Check if source file exists
if [ ! -f "$CLAUDE_LOG_SOURCE" ]; then
    echo -e "${RED}Error: Claude log file not found: $CLAUDE_LOG_SOURCE${NC}"
    echo -e "${YELLOW}Please ensure Claude is running and has generated chat history${NC}"
    exit 1
fi

# Create .claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}Creating .claude directory...${NC}"
    mkdir -p "$CLAUDE_DIR"
fi

# Generate timestamped filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PROJECT_NAME=$(basename "$CURRENT_DIR")
TARGET_FILE="$CLAUDE_DIR/claude-chat-${PROJECT_NAME}-${TIMESTAMP}.json"

# Copy file
echo -e "${BLUE}Copying Claude chat history...${NC}"
echo -e "Source: ${YELLOW}$CLAUDE_LOG_SOURCE${NC}"
echo -e "Target: ${YELLOW}$TARGET_FILE${NC}"

cp "$CLAUDE_LOG_SOURCE" "$TARGET_FILE"

# Verify file size
SOURCE_SIZE=$(stat -c%s "$CLAUDE_LOG_SOURCE")
TARGET_SIZE=$(stat -c%s "$TARGET_FILE")

if [ "$SOURCE_SIZE" -eq "$TARGET_SIZE" ]; then
    echo -e "${GREEN}✓ Chat history saved successfully!${NC}"
    echo -e "File size: ${YELLOW}$(( SOURCE_SIZE / 1024 )) KB${NC}"
else
    echo -e "${RED}✗ File copy may have issues, size mismatch${NC}"
    exit 1
fi

# Create latest record symlink
LATEST_LINK="$CLAUDE_DIR/claude-chat-latest.json"
if [ -L "$LATEST_LINK" ]; then
    rm "$LATEST_LINK"
fi
ln -s "$(basename "$TARGET_FILE")" "$LATEST_LINK"
echo -e "${GREEN}✓ Created latest record link: claude-chat-latest.json${NC}"

# Show file list
echo
echo -e "${BLUE}=== .claude directory contents ===${NC}"
ls -la "$CLAUDE_DIR" | grep -E '\.(json|md)$' | while read line; do
    echo -e "${YELLOW}$line${NC}"
done

# Optional: Create history location README
HISTORY_README="$CLAUDE_DIR/claude-chat-history-location.md"
if [ ! -f "$HISTORY_README" ]; then
    cat > "$HISTORY_README" << EOF
# Claude Chat History

## File Locations
- **Ubuntu Source**: \`/home/qingxuantang/.claude.json\`
- **Project Storage**: \`.claude/\` directory

## File Naming Convention
- **Format**: \`claude-chat-{project-name}-{timestamp}.json\`
- **Latest Link**: \`claude-chat-latest.json\`

## Usage
1. Run in project root: \`./save-claude-chat.sh\`
2. Script automatically copies and renames chat history
3. Updates \`claude-chat-latest.json\` link each time

## Notes
- Run this script in WSL/Ubuntu environment
- Script automatically creates \`.claude\` directory
- Recommended to run after each work session

Generated: $(date '+%Y-%m-%d %H:%M:%S')
EOF
    echo -e "${GREEN}✓ Created usage documentation${NC}"
fi

echo
echo -e "${GREEN}=== Backup Complete ===${NC}"
echo -e "Project: ${BLUE}$PROJECT_NAME${NC}"
echo -e "Time: ${YELLOW}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "Saved file: ${YELLOW}$(basename "$TARGET_FILE")${NC}"

# Provide quick access commands
echo
echo -e "${BLUE}Quick access commands:${NC}"
echo -e "View latest: ${YELLOW}cat $CLAUDE_DIR/claude-chat-latest.json | jq${NC}"
echo -e "Open directory: ${YELLOW}cd $CLAUDE_DIR${NC}"