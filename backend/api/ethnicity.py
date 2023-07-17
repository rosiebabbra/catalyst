from firebase_admin import firestore


def get_ethnicity_desc(ethnicity_id: int) -> str:

    ethnicity_map = {
        1 : 'White Non-Hispanic',
        2 : 'White Hispanic',
        3 : 'Non-white Hispanic',
        4 : 'American Indian or Alaska Native',
        5 : 'Native Hawaiian or other Pacific Islander',
        6 : 'Asian',
        7 : 'Black or African American'
    }

    return ethnicity_map[ethnicity_id]


def write_ethnicity(db: firestore.client, user_id: int, ethnicity_id: int) -> list:
    """Get a user's info from the database"""

    ethnicity_desc = get_ethnicity_desc(ethnicity_id)

    collection_ref = db.collection("ethnicity").document(str(user_id))
    # Using `set` here instead of `add` because ethnicity can be updated
    collection_ref.set({
        'ethnicity_id': ethnicity_id,
        'ethnicity_desc': ethnicity_desc
    })