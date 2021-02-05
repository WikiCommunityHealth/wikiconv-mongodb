#! /bin/bash

DB_FOLDER="dataset"
LANG_FOLDER="wikiconv-es"
URL_DB="mongodb://localhost:27017/wiki-conv-es"
DB_COLLECTION="full"

mkdir -p $DB_FOLDER && cd $DB_FOLDER && mkdir -p $LANG_FOLDER && cd $LANG_FOLDER

echo "Downloading files"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914305/20200401esjsonlines00000of00005.gz --output wikiconv-es-0.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914317/20200401esjsonlines00001of00005.gz --output wikiconv-es-1.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914344/20200401esjsonlines00002of00005.gz --output wikiconv-es-2.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914371/20200401esjsonlines00003of00005.gz --output wikiconv-es-3.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914374/20200401esjsonlines00004of00005.gz --output wikiconv-es-4.gz

echo "Decompressing files"
gzip -d wikiconv-es-0.gz
gzip -d wikiconv-es-1.gz
gzip -d wikiconv-es-2.gz
gzip -d wikiconv-es-3.gz
gzip -d wikiconv-es-4.gz

echo "Importing in mongodb"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-es-0"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-es-1"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-es-2"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-es-3"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-es-4"

echo "Done"
