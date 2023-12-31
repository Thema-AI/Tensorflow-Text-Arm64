.PHONY: build

build: _docker_build_driver
	docker buildx build \
	  --builder=master-builder \
	  --target=artifact \
	  --output type=local,dest=build \
	  --platform=linux/arm64 \
	  --cache-to type=gha,mode=max \
	  --cache-from type=gha \
	  .

_docker_build_driver:
	docker buildx inspect master-builder || docker buildx create --name master-builder --driver=docker-container --driver-opt=image=moby/buildkit:master
