# %% DB connection setup
import pymongo
import os
from datetime import datetime
from tqdm import tqdm
client = pymongo.MongoClient("mongodb://localhost:27017")
print("Connection setup")

# %% Function setup
def createCollection(collection, collectionMin, isUsers):

    collection.drop()
    collectionMin.drop()
    print("Old collection dropped")

    # GROUP
    groupQuery = {
        "count": {"$sum": 1},

        # typeOfActions
        "ADDITION": {"$sum": {"$cond": [{"$eq": ["$type", "ADDITION"]}, 1, 0]}},
        "MODIFICATION": {"$sum": {"$cond": [{"$eq": ["$type", "MODIFICATION"]}, 1, 0]}},
        "DELETION": {"$sum": {"$cond": [{"$eq": ["$type", "DELETION"]}, 1, 0]}},
        "RESTORATION": {"$sum": {"$cond": [{"$eq": ["$type", "RESTORATION"]}, 1, 0]}},

        # scoreActions
        "toxicityCounter": {"$sum": {"$cond": [{"$gt": ["$score.toxicity", 0.5]}, 1, 0]}},
        "severeToxicityCounter": {"$sum": {"$cond": [{"$gt": ["$score.severeToxicity", 0.5]}, 1, 0]}},
        "profanityCounter": {"$sum": {"$cond": [{"$gt": ["$score.profanity", 0.5]}, 1, 0]}},
        "threatCounter": {"$sum": {"$cond": [{"$gt": ["$score.threat", 0.5]}, 1, 0]}},
        "insultCounter": {"$sum": {"$cond": [{"$gt": ["$score.insult", 0.5]}, 1, 0]}},
        "identityAttackCounter": {"$sum": {"$cond": [{"$gt": ["$score.identityAttack", 0.5]}, 1, 0]}},

        # activityDate
        "firstEdit": {"$min": "$timestamp"},
        "lastEdit": {"$max": "$timestamp"}
    }


    if isUsers:
        groupQuery["_id"] = {"id": "$user.id", "ip": "$user.ip"}
        groupQuery["username"] = {"$first": "$user.text"}
        groupQuery["workedOnPagesCount"] = {"$addToSet": "$pageId"}
    else:
        groupQuery["_id"] = "$pageId"
        groupQuery["pageTitle"] = {"$first": "$pageTitle"}
        groupQuery["workedByUsersCount"] = {"$addToSet": "$user"}

    # PROJECT
    projectQuery = {
        "_id": 1,
        "count": 1,
        "typeOfActions": {
            "ADDITION": "$ADDITION",
            "MODIFICATION": "$MODIFICATION",
            "DELETION": "$DELETION",
            "RESTORATION": "$RESTORATION",
        },
        "scoreActions": {
            "toxicityCounter": "$toxicityCounter",
            "severeToxicityCounter": "$severeToxicityCounter",
            "profanityCounter": "$profanityCounter",
            "threatCounter": "$threatCounter",
            "insultCounter": "$insultCounter",
            "identityAttackCounter": "$identityAttackCounter"
        },
        "activityDate": {
            "firstEdit": "$firstEdit",
            "lastEdit": "$lastEdit",
        }
    }

    if isUsers:
        projectQuery["username"] = 1
        projectQuery["workedOnPagesCount"] = { "$cond": { "if": { "$isArray": "$workedOnPagesCount" }, "then": { "$size": "$workedOnPagesCount" }, "else": None} }
    else:
        projectQuery["pageTitle"] = 1
        projectQuery["workedByUsersCount"] = { "$cond": { "if": { "$isArray": "$workedByUsersCount" }, "then": { "$size": "$workedByUsersCount" }, "else": None} }

    print('Querying ...')
    usersPointer = collFull.aggregate(
        [{"$group": groupQuery}, {"$project": projectQuery}],
        allowDiskUse=True)
    print('Query completed')

    counter = 0
    batchValues = []
    batchValuesMin = []
    for val in tqdm(usersPointer):
        if isUsers:
            if 'ip' in val['_id']:
                val['_id'] = val['_id']['ip']
            if 'id' in val['_id']:
                val['_id'] = val['_id']['id']

        val['activityDate']['firstEdit'] = datetime.strptime(val['activityDate']['firstEdit'], '%Y-%m-%dT%H:%M:%SZ')
        val['activityDate']['lastEdit'] = datetime.strptime(val['activityDate']['lastEdit'], '%Y-%m-%dT%H:%M:%SZ')
        days = (val['activityDate']['lastEdit'] - val['activityDate']['firstEdit']).days
        val['activityDate']['activeDays'] = days
        val['activityDate']['editsPerDay'] = val['count'] / days if days > 0 else 0

        count = val['count']
        val['scoreActions']['toxicityCounterRatio'] = val['scoreActions']['toxicityCounter'] / count
        val['scoreActions']['severeToxicityCounterRatio'] = val['scoreActions']['severeToxicityCounter'] / count
        val['scoreActions']['profanityCounterRatio'] = val['scoreActions']['profanityCounter'] / count
        val['scoreActions']['threatCounterRatio'] = val['scoreActions']['threatCounter'] / count
        val['scoreActions']['insultCounterRatio'] = val['scoreActions']['insultCounter'] / count
        val['scoreActions']['identityAttackCounterRatio'] = val['scoreActions']['identityAttackCounter'] / count

        if isUsers:
            val['isBot'] = True if val['username'] and "bot" in val['username'].lower() else False

        if isUsers:
            batchValuesMin.append({
                '_id': val['_id'],
                'username': val['username'],
                'count': val['count'],
                'isBot': val['isBot'],
                'workedOnPagesCount': val['workedOnPagesCount']
            })
        else:
            batchValuesMin.append({
                '_id': val['_id'],
                'pageTitle': val['pageTitle'],
                'count': val['count'],
                'workedByUsersCount': val['workedByUsersCount']
            })
        batchValues.append(val)
        # collection.insert(u)
        counter += 1
        if counter % 10000 == 0:
            collection.insert_many(batchValues)
            collectionMin.insert_many(batchValuesMin)
            batchValues = []
            batchValuesMin = []
            #print(f'Inserted {counter} documents')
    
    collection.insert_many(batchValues)
    collectionMin.insert_many(batchValuesMin)
    print(f'All {counter} documents inserted')

print("Functions defined")

# %% config db
DB_NAME = 'wiki'
DATASET_COLLECTION_NAME = 'dataset-it'
USERS_COLLECTION_NAME = 'users'
USERS_MIN_COLLECTION_NAME = 'users-min'
PAGES_COLLECTION_NAME = 'pages'
PAGES_MIN_COLLECTION_NAME = 'pages-min'

db = client[DB_NAME]
collFull = db[DATASET_COLLECTION_NAME]

collUsers = db[USERS_COLLECTION_NAME]
collUsersMin = db[USERS_MIN_COLLECTION_NAME]
collPages = db[PAGES_COLLECTION_NAME]
collPagesMin = db[PAGES_MIN_COLLECTION_NAME]
print("Collections selected")

# %% Create Users
print(" -- USERS -- ")
createCollection(collUsers, collUsersMin, True)

# %% Create Pages
print(" -- PAGES -- ")
createCollection(collPages, collPagesMin, False)
