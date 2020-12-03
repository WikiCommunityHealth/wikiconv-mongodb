# %% SETUP CONNECTION
import pymongo
import os
from dotenv import load_dotenv
from datetime import datetime
load_dotenv()
client = pymongo.MongoClient("mongodb://localhost:27017")
print("CONNECTION SETUP")

# %% config db
DB_NAME = 'wiki'
DATASET_COLLECTION_NAME = 'dataset-it-min'
USER_COLLECTION_NAME = 'users'
print("Collections selected")

# %% DB setup
db = client[DB_NAME]
collFull = db[DATASET_COLLECTION_NAME]
collUsers = db[USER_COLLECTION_NAME]

collUsers.drop()
print("Database cleaned")

usersPointer = collFull.aggregate([{
    "$group": {
        "_id": { "id": "$user.id", "ip": "$user.ip" },
        "username": {"$first": "$user.text"},

        "workedOnPagesCount": {"$addToSet": "$pageId"},

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
        "lastEdit": {"$max": "$timestamp"},

        # "toxicity": { "$avg": "$score.toxicity" },
        # "severeToxicity": { "$avg": "$score.severeToxicity" },
        # "profanity": { "$avg": "$score.profanity" },
        # "profanity": { "$avg": "$score.profanity" },
        # "threat": { "$avg": "$score.threat" },
        # "identityAttack": { "$avg": "$score.identityAttack" },
        "count": {"$sum": 1}
    }
}, {
    "$project": {
        "_id": 1,
        "username": 1,
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
        },
    }
}], allowDiskUse=True)

counter = 0;
for u in usersPointer:
    if 'ip' in u['_id']:
        u['_id'] = u['_id']['ip']
    if 'id' in u['_id']:
        u['_id'] = u['_id']['id']
    
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

    u['isBot'] = True if u['username'] and "bot" in u['username'].lower() else False
    collUsers.insert(u)
    counter += 1
    if counter % 1000 == 0:
        print(f'Inserted {counter} users')

print('All users inserted')



# %%
