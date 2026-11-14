TAG ?= 18-alpine
IMAGE ?= ghcr.io/bspaulding/pgdumpbox

default:
	docker build --build-arg TAG=$(TAG) -t $(IMAGE):$(TAG) .

test:
	docker run -e APP=pgdumpboxtest -e DROPBOX_BEARER_TOKEN=$(DROPBOX_BEARER_TOKEN) -e PGHOST=host.docker.internal -e PGUSER=pgdumpbox -e PGPASSWORD=password -e PGDATABASE=pgdumpboxtest --network=host $(IMAGE):$(TAG)
