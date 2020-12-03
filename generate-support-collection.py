# %% DB connection setup
import pymongo
import os
from datetime import datetime
client = pymongo.MongoClient("mongodb://localhost:27017")
print("Connection setup")

# %% Function setup
def createCollection(collection, isUsers, min):

    collection.drop()
    print("Old collection dropped")

    # GROUP
    groupQuery = {
        "count": {"$sum": 1},
    }

    if not min:
        # typeOfActions
        groupQuery["ADDITION"] = {"$sum": {"$cond": [{"$eq": ["$type", "ADDITION"]}, 1, 0]}}
        groupQuery["MODIFICATION"] = {"$sum": {"$cond": [{"$eq": ["$type", "MODIFICATION"]}, 1, 0]}}
        groupQuery["DELETION"] = {"$sum": {"$cond": [{"$eq": ["$type", "DELETION"]}, 1, 0]}}
        groupQuery["RESTORATION"] = {"$sum": {"$cond": [{"$eq": ["$type", "RESTORATION"]}, 1, 0]}}

        # scoreActions
        groupQuery["toxicityCounter"] = {"$sum": {"$cond": [{"$gt": ["$score.toxicity", 0.5]}, 1, 0]}}
        groupQuery["severeToxicityCounter"] = {"$sum": {"$cond": [{"$gt": ["$score.severeToxicity", 0.5]}, 1, 0]}}
        groupQuery["profanityCounter"] = {"$sum": {"$cond": [{"$gt": ["$score.profanity", 0.5]}, 1, 0]}}
        groupQuery["threatCounter"] = {"$sum": {"$cond": [{"$gt": ["$score.threat", 0.5]}, 1, 0]}}
        groupQuery["insultCounter"] = {"$sum": {"$cond": [{"$gt": ["$score.insult", 0.5]}, 1, 0]}}
        groupQuery["identityAttackCounter"] = {"$sum": {"$cond": [{"$gt": ["$score.identityAttack", 0.5]}, 1, 0]}}

        # activityDate
        groupQuery["firstEdit"] = {"$min": "$timestamp"}
        groupQuery["lastEdit"] = {"$max": "$timestamp"}

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
    }

    if not min:
        projectQuery["typeOfActions"] = {
            "ADDITION": "$ADDITION",
            "MODIFICATION": "$MODIFICATION",
            "DELETION": "$DELETION",
            "RESTORATION": "$RESTORATION",
        }
        projectQuery["scoreActions"] = {
            "toxicityCounter": "$toxicityCounter",
            "severeToxicityCounter": "$severeToxicityCounter",
            "profanityCounter": "$profanityCounter",
            "threatCounter": "$threatCounter",
            "insultCounter": "$insultCounter",
            "identityAttackCounter": "$identityAttackCounter"
        }
        projectQuery["activityDate"] = {
            "firstEdit": "$firstEdit",
            "lastEdit": "$lastEdit",
        }

    if isUsers:
        projectQuery["username"] = 1
        projectQuery["workedOnPagesCount"] = { "$cond": { "if": { "$isArray": "$workedOnPagesCount" }, "then": { "$size": "$workedOnPagesCount" }, "else": None} }
    else:
        projectQuery["pageTitle"] = 1
        projectQuery["workedByUsersCount"] = { "$cond": { "if": { "$isArray": "$workedByUsersCount" }, "then": { "$size": "$workedByUsersCount" }, "else": None} }


    usersPointer = collFull.aggregate(
        [{"$group": groupQuery}, {"$project": projectQuery}],
        allowDiskUse=True)

    counter = 0
    for u in usersPointer:
        if isUsers:
            if 'ip' in u['_id']:
                u['_id'] = u['_id']['ip']
            if 'id' in u['_id']:
                u['_id'] = u['_id']['id']

        if not min:
            u['activityDate']['firstEdit'] = datetime.strptime(u['activityDate']['firstEdit'], '%Y-%m-%dT%H:%M:%SZ')
            u['activityDate']['lastEdit'] = datetime.strptime(u['activityDate']['lastEdit'], '%Y-%m-%dT%H:%M:%SZ')
            days = (u['activityDate']['lastEdit'] - u['activityDate']['firstEdit']).days
            u['activityDate']['activeDays'] = days
            u['activityDate']['editsPerDay'] = u['count'] / days if days > 0 else 0

            count = u['count']
            u['scoreActions']['toxicityCounterRatio'] = u['scoreActions']['toxicityCounter'] / count
            u['scoreActions']['severeToxicityCounterRatio'] = u['scoreActions']['severeToxicityCounter'] / count
            u['scoreActions']['profanityCounterRatio'] = u['scoreActions']['profanityCounter'] / count
            u['scoreActions']['threatCounterRatio'] = u['scoreActions']['threatCounter'] / count
            u['scoreActions']['insultCounterRatio'] = u['scoreActions']['insultCounter'] / count
            u['scoreActions']['identityAttackCounterRatio'] = u['scoreActions']['identityAttackCounter'] / count

        if isUsers:
            u['isBot'] = True if u['username'] and "bot" in u['username'].lower() else False
        collection.insert(u)
        counter += 1
        if counter % 1000 == 0:
            print(f'Inserted {counter} documents')

    print('All documents inserted')

print("Functions defined")

# %% config db
DB_NAME = 'wiki'
DATASET_COLLECTION_NAME = 'dataset-it-min'
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
createCollection(collUsers, True, False)

# %% Create Users Min
print(" -- USERS MIN -- ")
createCollection(collUsersMin, True, True)

# %% Create Pages
print(" -- PAGES -- ")
createCollection(collPages, False, False)

# %% Create Pages Min
print(" -- PAGES MIN -- ")
createCollection(collPagesMin, False, True)
