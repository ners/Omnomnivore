all: build

build:
	stack build

run: build
	stack exec -- Omnomnivore-exe

CONTAINER_IMAGE := janusgraph/janusgraph:latest
CONTAINER_NAME := janusgraph
graphdb:
	podman container exists ${CONTAINER_NAME} || podman run \
		--rm \
		-d \
		--publish 8182:8182 \
		--name ${CONTAINER_NAME} \
		-e GREMLIN_REMOTE_HOSTS=localhost \
		${CONTAINER_IMAGE}

gremlin: graphdb
	@echo -e "To connect to the local graph DB, use the following command:\n\n  g = traversal().withRemote('conf/remote-graph.properties')  " | boxes -d parchment
	@echo
	podman exec -it ${CONTAINER_NAME} ./bin/gremlin.sh

cleandb:
	podman container exists ${CONTAINER_NAME} && podman rm -f ${CONTAINER_NAME}