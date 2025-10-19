
n8n-mcp 设置指南：
https://github.com/czlonkowski/n8n-mcp/blob/main/docs/CLAUDE_CODE_SETUP.md


claude mcp add n8n-mcp \
  -e MCP_MODE=stdio \
  -e LOG_LEVEL=error \
  -e DISABLE_CONSOLE_OUTPUT=true \
  -e N8N_API_URL=http://localhost:5678 \
  -e N8N_API_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjNzgwODU5NS05NDEzLTQ4NTYtYmJlMi0xZGMzNjU2MjgwMTAiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzYwODUyMzI4LCJleHAiOjE3Njg2MjYwMDB9.9ejJvfUnpjEsd1rhdgM2Gmqq4QQPe0SPCs7NycEZwE8 \
  -- npx n8n-mcp