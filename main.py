import sys
import asyncio
from mcp import MCP

print(">>> MCP минимальный запущен", file=sys.stderr, flush=True)

mcp = MCP()

@mcp.handler()
async def initialize(context):
    print(">>> initialize получен", file=sys.stderr, flush=True)
    return {
        "message": "Привет из MCP!",
    }

if __name__ == "__main__":
    asyncio.run(mcp.run_stdio_async())
