import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


# Set up the credentials and initialize the app
cred = credentials.Certificate("database/serviceAccountKey.json")
options = {
    "use_firestore_emulator": False,
}
firebase_admin.initialize_app(cred, options)

# Get a reference to the Firestore database
db = firestore.client()