from firebase_admin import firestore
from enum import Enum, auto


class Interest(Enum):
    selected = 'selected'
    declined = 'declined'


def get_user(db, user_id):

    query = db.collection('selected_interests').where('user_id', '==', user_id)
    results = query.get()

    return results


def write_interests(db: firestore.client, user_id: int, interest_id: list, interest_type: Interest):

    table_name = f'{interest_type.name}_interests'
    results = get_user(db, user_id)

    if results:
        for doc in results:
            user_record = db.collection(table_name).document(doc.id)
            doc = user_record.get()

            if doc.exists:
                try:
                    existing_interest_ids = doc.get('interest_ids')

                    # if multiple interests exist
                    if isinstance(existing_interest_ids, list):
                        existing_interest_ids.append(interest_id)
                        # casting to a set and a list again to write interests that do not already exist
                        data_to_update = {
                            'interest_ids': list(set(existing_interest_ids))
                        }
                    # if only one interest exists
                    else:
                        # casting to a set and a list again to write interests that do not already exist
                        interests = list(set([existing_interest_ids, interest_id]))
                        data_to_update = {
                            'interest_ids': interests
                        }

                    user_record.update(data_to_update)
                    return 204
                
                # if no interests exist for the user yet
                except KeyError:
                    data_to_update = {
                        'interest_ids': interest_id
                    }
                    user_record.update(data_to_update)
                    return 204
        
    else:
        # if the user does not already exist in the db, create the user and add the interest
        collection_ref = db.collection(table_name)
        data_to_update = {
            'interest_ids': [interest_id],
            'user_id': user_id
        }
        collection_ref.add(data_to_update)
        return 204