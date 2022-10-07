default:
	docker build --build-arg TAG=14-alpine -t bspaulding/pgdumpbox:14-alpine .

test:
	docker run -e APP=pgdumpboxtest -e DROPBOX_BEARER_TOKEN=$DROPBOX_BEARER_TOKEN -e PGHOST=host.docker.internal -e PGUSER=pgdumpbox -e PGPASSWORD=password -e PGDATABASE=pgdumpboxtest --network=host bspaulding/pgdumpbox:14-alpine

