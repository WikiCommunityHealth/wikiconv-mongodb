#! /bin/bash

DB_FOLDER="dataset"
LANG_FOLDER="wikiconv-ca"
URL_DB="mongodb://localhost:27017/wiki-conv-ca"
DB_COLLECTION="full"

mkdir -p $DB_FOLDER && cd $DB_FOLDER && mkdir -p $LANG_FOLDER && cd $LANG_FOLDER

echo "Downloading files"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927481/20200401cajsonlines00000of00001.gz --output wikiconv-ca-0.gz

echo "Decompressing files"
gzip -d wikiconv-ca-0.gz

echo "Importing in mongodb"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-ca-0"

echo "Done"
