#! /bin/bash

DB_FOLDER="dataset"
IT_FOLDER="wikiconv-en"
URL_DB="mongodb://localhost:27017/wiki-conv-en"
DB_COLLECTION="full"

mkdir -p $DB_FOLDER && cd $DB_FOLDER && mkdir -p $IT_FOLDER && cd $IT_FOLDER

### ------------- 00-09

echo "Downloading 00-09"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914644/20200401enjsonlines00000of00050.gz --output wikiconv-en-00.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914734/20200401enjsonlines00001of00050.gz --output wikiconv-en-01.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914917/20200401enjsonlines00002of00050.gz --output wikiconv-en-02.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22914974/20200401enjsonlines00003of00050.gz --output wikiconv-en-03.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22915775/20200401enjsonlines00004of00050.gz --output wikiconv-en-04.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22917755/20200401enjsonlines00005of00050.gz --output wikiconv-en-05.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22917929/20200401enjsonlines00006of00050.gz --output wikiconv-en-06.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22917968/20200401enjsonlines00007of00050.gz --output wikiconv-en-07.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22917998/20200401enjsonlines00008of00050.gz --output wikiconv-en-08.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22918007/20200401enjsonlines00009of00050.gz --output wikiconv-en-09.gz

echo "Unzipping 00-09"
gzip -d wikiconv-en-00.gz
gzip -d wikiconv-en-01.gz
gzip -d wikiconv-en-02.gz
gzip -d wikiconv-en-03.gz
gzip -d wikiconv-en-04.gz
gzip -d wikiconv-en-05.gz
gzip -d wikiconv-en-06.gz
gzip -d wikiconv-en-07.gz
gzip -d wikiconv-en-08.gz
gzip -d wikiconv-en-09.gz

echo "Importing 00-09"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-00"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-01"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-02"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-03"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-04"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-05"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-06"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-07"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-08"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-09"

echo "Removing 00-09"
rm wikiconv-en-*

echo "Done 00-09"

### ------------- 10-19

echo "Downloading 10-19"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22918022/20200401enjsonlines00010of00050.gz --output wikiconv-en-10.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22918049/20200401enjsonlines00011of00050.gz --output wikiconv-en-11.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22918094/20200401enjsonlines00012of00050.gz --output wikiconv-en-12.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22918103/20200401enjsonlines00013of00050.gz --output wikiconv-en-13.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22919366/20200401enjsonlines00014of00050.gz --output wikiconv-en-14.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22920863/20200401enjsonlines00015of00050.gz --output wikiconv-en-15.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22920914/20200401enjsonlines00016of00050.gz --output wikiconv-en-16.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22920935/20200401enjsonlines00017of00050.gz --output wikiconv-en-17.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22920974/20200401enjsonlines00018of00050.gz --output wikiconv-en-18.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22920989/20200401enjsonlines00019of00050.gz --output wikiconv-en-19.gz

echo "Unzipping 10-19"
gzip -d wikiconv-en-10.gz
gzip -d wikiconv-en-11.gz
gzip -d wikiconv-en-12.gz
gzip -d wikiconv-en-13.gz
gzip -d wikiconv-en-14.gz
gzip -d wikiconv-en-15.gz
gzip -d wikiconv-en-16.gz
gzip -d wikiconv-en-17.gz
gzip -d wikiconv-en-18.gz
gzip -d wikiconv-en-19.gz

echo "Importing 10-19"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-10"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-11"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-12"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-13"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-14"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-15"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-16"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-17"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-18"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-19"

echo "Removing 10-19"
rm wikiconv-en-*

echo "Done 10-19"

### ------------- 20-29

echo "Downloading 20-29"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921013/20200401enjsonlines00020of00050.gz --output wikiconv-en-20.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921031/20200401enjsonlines00021of00050.gz --output wikiconv-en-21.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921082/20200401enjsonlines00022of00050.gz --output wikiconv-en-22.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921106/20200401enjsonlines00023of00050.gz --output wikiconv-en-23.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921127/20200401enjsonlines00024of00050.gz --output wikiconv-en-24.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921148/20200401enjsonlines00025of00050.gz --output wikiconv-en-25.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921187/20200401enjsonlines00026of00050.gz --output wikiconv-en-26.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921247/20200401enjsonlines00027of00050.gz --output wikiconv-en-27.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921265/20200401enjsonlines00028of00050.gz --output wikiconv-en-28.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22921511/20200401enjsonlines00029of00050.gz --output wikiconv-en-29.gz

echo "Unzipping 20-29"
gzip -d wikiconv-en-20.gz
gzip -d wikiconv-en-21.gz
gzip -d wikiconv-en-22.gz
gzip -d wikiconv-en-23.gz
gzip -d wikiconv-en-24.gz
gzip -d wikiconv-en-25.gz
gzip -d wikiconv-en-26.gz
gzip -d wikiconv-en-27.gz
gzip -d wikiconv-en-28.gz
gzip -d wikiconv-en-29.gz

echo "Importing 20-29"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-20"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-21"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-22"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-23"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-24"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-25"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-26"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-27"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-28"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-29"

echo "Removing 20-29"
rm wikiconv-en-*

echo "Done 20-29"

### ------------- 30-39

echo "Downloading 30-39"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22923881/20200401enjsonlines00030of00050.gz --output wikiconv-en-30.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22924091/20200401enjsonlines00031of00050.gz --output wikiconv-en-31.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22925492/20200401enjsonlines00032of00050.gz --output wikiconv-en-32.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22926857/20200401enjsonlines00033of00050.gz --output wikiconv-en-33.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22926965/20200401enjsonlines00034of00050.gz --output wikiconv-en-34.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22926974/20200401enjsonlines00035of00050.gz --output wikiconv-en-35.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927010/20200401enjsonlines00036of00050.gz --output wikiconv-en-36.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927046/20200401enjsonlines00037of00050.gz --output wikiconv-en-37.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927079/20200401enjsonlines00038of00050.gz --output wikiconv-en-38.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927118/20200401enjsonlines00039of00050.gz --output wikiconv-en-39.gz

echo "Unzipping 30-39"
gzip -d wikiconv-en-30.gz
gzip -d wikiconv-en-31.gz
gzip -d wikiconv-en-32.gz
gzip -d wikiconv-en-33.gz
gzip -d wikiconv-en-34.gz
gzip -d wikiconv-en-35.gz
gzip -d wikiconv-en-36.gz
gzip -d wikiconv-en-37.gz
gzip -d wikiconv-en-38.gz
gzip -d wikiconv-en-39.gz

echo "Importing 30-39"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-30"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-31"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-32"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-33"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-34"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-35"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-36"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-37"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-38"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-39"

echo "Removing 30-39"
rm wikiconv-en-*

echo "Done 30-39"

### ------------- 30-39

echo "Downloading 40-49"
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927154/20200401enjsonlines00040of00050.gz --output wikiconv-en-40.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927193/20200401enjsonlines00041of00050.gz --output wikiconv-en-41.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927226/20200401enjsonlines00042of00050.gz --output wikiconv-en-42.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927244/20200401enjsonlines00043of00050.gz --output wikiconv-en-43.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927265/20200401enjsonlines00044of00050.gz --output wikiconv-en-44.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927286/20200401enjsonlines00045of00050.gz --output wikiconv-en-45.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927331/20200401enjsonlines00046of00050.gz --output wikiconv-en-46.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927340/20200401enjsonlines00047of00050.gz --output wikiconv-en-47.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927358/20200401enjsonlines00048of00050.gz --output wikiconv-en-48.gz
curl https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/22927361/20200401enjsonlines00049of00050.gz --output wikiconv-en-49.gz

echo "Unzipping 40-50"
gzip -d wikiconv-en-40.gz
gzip -d wikiconv-en-41.gz
gzip -d wikiconv-en-42.gz
gzip -d wikiconv-en-43.gz
gzip -d wikiconv-en-44.gz
gzip -d wikiconv-en-45.gz
gzip -d wikiconv-en-46.gz
gzip -d wikiconv-en-47.gz
gzip -d wikiconv-en-48.gz
gzip -d wikiconv-en-49.gz

echo "Importing 40-50"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-40"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-41"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-42"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-43"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-44"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-45"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-46"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-47"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-48"
mongoimport --uri $URL_DB -c=$DB_COLLECTION --type=json --file="wikiconv-en-49"

echo "Removing 40-49"
rm wikiconv-en-*

echo "Done 40-49"
