from firebase_admin import firestore


def write_selected_interests(db: firestore.client, user_id: int, interest_ids: list):
    query = db.collection('selected_interests').where('user_id', '==', user_id)
    query_snapshot = query.get()

    for doc in query_snapshot:
        doc_ref = db.collection('selected_interests').document(doc.id)
        data_to_update = {
            'interests': interest_ids
        }
        doc_ref.update(data_to_update)


def write_declined_interests(db: firestore.client, user_id: int, interest_ids: list):

    query = db.collection('declined_interests').where('user_id', '==', user_id)
    query_snapshot = query.get()

    for doc in query_snapshot:
        doc_ref = db.collection('declined_interests').document(doc.id)
        data_to_update = {
            'interest_id': interest_ids
        }
        doc_ref.update(data_to_update)