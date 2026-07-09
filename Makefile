lock:
	uv lock

build:
	docker build -t robosuite-runtime:torch-jax .

run:
	docker run ...