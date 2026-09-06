import websockets
import asyncio

async def relay(client, target):
	async for message in client:
		await target.send(message)

async def handler(socket):
	async with websockets.connect("ws://localhost:38281") as target:
		await asyncio.gather(
			relay(socket, target),
			relay(target, socket)
		)

async def main():
	async with websockets.serve(handler, "localhost", 38282, ping_interval=None):
		await asyncio.Future()

if __name__ == "__main__":
    asyncio.run(main())