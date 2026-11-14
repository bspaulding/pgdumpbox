#! /usr/bin/env sh

if [ -z "$APP" ]; then
	echo "MUST set \$APP"
	exit 1
fi

if [ -z "$DROPBOX_BEARER_TOKEN" ]; then
	echo "MUST set \$DROPBOX_BEARER_TOKEN"
	exit 1
fi

echo "APP is set to $APP"
file=$APP-$(date +%Y-%m-%d-%H:%M).sql

# pg_dump reads PGHOST, PGUSER, PGDATABASE and PGPASSWORD from the environment,
# so no ~/.pgpass is needed (and the password is never printed).
echo "Exporting database to $file..."
if ! pg_dump > "$file"; then
	echo "pg_dump failed...exiting..."
	rm -f "$file"
	exit 1
fi

echo "Uploading to dropbox..."
# --fail-with-body makes curl exit non-zero on HTTP errors (e.g. expired token)
# so the job fails instead of reporting a successful backup.
if ! curl --fail-with-body -sS -X POST https://content.dropboxapi.com/2/files/upload \
	--header "Authorization: Bearer $DROPBOX_BEARER_TOKEN" \
	--header "Content-Type: application/octet-stream" \
	--header "Dropbox-API-Arg: { \"path\": \"/$APP/$file\" }" \
	--data-binary @"$file"; then
	echo
	echo "upload to dropbox failed...exiting..."
	rm -f "$file"
	exit 1
fi

printf '\nCleaning up...\n'
rm -f "$file"

echo "Done."
