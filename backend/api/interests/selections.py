import firebase_admin

from firebase_admin import credentials, firestore


def write_interests(db: firestore.client, user_id: int, interests: list):
    query = db.collection('interests').where('user_id', '==', user_id)
    query_snapshot = query.get()

    for doc in query_snapshot:
        doc_ref = db.collection('interests').document(doc.id)
        data_to_update = {
            'interests': interests
        }
        doc_ref.update(data_to_update)


def write_noninterests(db: firestore.client, user_id: int, noninterests: list):

    query = db.collection('noninterests').where('user_id', '==', user_id)
    query_snapshot = query.get()

    for doc in query_snapshot:
        doc_ref = db.collection('noninterests').document(doc.id)
        data_to_update = {
            'noninterests': noninterests
        }
        doc_ref.update(data_to_update)