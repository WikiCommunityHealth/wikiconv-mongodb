import pymongo
import sys


DB_NAME = 'wiki-conv-it'
DATASET_COLLECTION_NAME = 'full'
if (len(sys.argv) == 3):
    DB_NAME = sys.argv[1]
    DATASET_COLLECTION_NAME = sys.argv[2]
print(f'Using db: {DB_NAME} collection: {DATASET_COLLECTION_NAME}')

client = pymongo.MongoClient('mongodb://localhost:27017')
db = client[DB_NAME]
coll = db[DATASET_COLLECTION_NAME]

coll.create_index("id")
print('id index created')
coll.create_index("pageId")
print('pageId index created')
coll.create_index("user")
print('user index created')