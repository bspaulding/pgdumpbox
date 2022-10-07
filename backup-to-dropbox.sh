#! /usr/bin/env sh

file=$APP-$(date +%Y-%m-%d-%R).sql

echo "APP is set to $APP"
if [ -z "$APP" ]; then
	echo "MUST set \$APP"
	exit 1
fi

if [ -z "$DROPBOX_BEARER_TOKEN" ]; then
	echo "MUST set \$DROPBOX_BEARER_TOKEN"
	exit 1
fi

echo "setting up credentials in ~/.pgpass"
echo "$PGHOST:*:$PGDATABASE:$PGUSER:$PGPASSWORD"
echo "$PGHOST:*:$PGDATABASE:$PGUSER:$PGPASSWORD" >> ~/.pgpass

echo "Exporting database to $file..."
pg_dump > $file

if [ $? -gt 0 ]; then
	echo "something when wrong...exiting..."
	exit 1
fi

echo "Uploading to dropbox..."
curl -X POST https://content.dropboxapi.com/2/files/upload \
	--header "Authorization: Bearer $DROPBOX_BEARER_TOKEN" \
	--header "Content-Type: application/octet-stream" \
	--header "Dropbox-API-Arg: { \"path\": \"/$APP/$file\" }" \
	--data-binary @$file

echo "\nCleaning up..."
rm $file

echo "Done."
