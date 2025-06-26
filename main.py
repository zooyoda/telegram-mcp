print(">>> MCP STARTING...", flush=True)

import asyncio
import json
import sys

async def run_stdio_echo():
    print("✅ Minimal MCP launched and ready", flush=True)
    while True:
        line = await asyncio.get_event_loop().run_in_executor(None, sys.stdin.readline)
        if not line:
            break
        try:
            request = json.loads(line)
            print(f"📥 Got request: {request}", flush=True)

            # Ответ на initialize
            if request.get("method") == "initialize":
                response = {
                    "jsonrpc": "2.0",
                    "id": request.get("id"),
                    "result": {
                        "capabilities": {
                            "completion": {
                                "streaming": True,
                                "prompt": True
                            }
                        }
                    }
                }
                sys.stdout.write(json.dumps(response) + "\n")
                sys.stdout.flush()
                print("✅ Sent 'initialize' response", flush=True)
        except Exception as e:
            print(f"❌ Error: {e}", file=sys.stderr)

if __name__ == "__main__":
    asyncio.run(run_stdio_echo())
