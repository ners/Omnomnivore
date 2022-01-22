all: build

build:
	cabal build

run:
	cabal run Omnomnivore

GRAPHDB_CONTAINER_NAME := janusgraph
graphdb:
	podman container exists ${GRAPHDB_CONTAINER_NAME} || podman run \
		--rm \
		-d \
		--publish 8182:8182 \
		--name ${GRAPHDB_CONTAINER_NAME} \
		-e GREMLIN_REMOTE_HOSTS=localhost \
		janusgraph/janusgraph:latest

gremlin: graphdb
	@echo -e "To connect to the local graph DB, use the following command:\n\n  g = traversal().withRemote('conf/remote-graph.properties')  " | boxes -d parchment
	@echo
	podman exec -it ${GRAPHDB_CONTAINER_NAME} ./bin/gremlin.sh conf/janusgraph-server.yaml

graphexp: graphdb
	podman container exists $@ || podman run \
		--rm \
		-d \
		--name $@ \
		--publish 8080:80 \
		pbgraff/graphexp-bootstrap:1.0
	@echo -e "Graph explorer listening on:\n\n  http://localhost:8080/" | boxes -d parchment

cleandb:
	podman container exists ${GRAPHDB_CONTAINER_NAME} && podman rm -f ${GRAPHDB_CONTAINER_NAME}
