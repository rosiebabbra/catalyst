import uuid

from utils.utils import unpack_query_results, format_phone_number
from typing import Any
from firebase_admin import auth, firestore
from datetime import datetime
from werkzeug.exceptions import HTTPException


class UserExistsError(HTTPException):
    """Forbid existing users to register"""

    code = 409

    def __init__(self, message):
        self.message = message
        super().__init__(message)


def generate_uuid() -> str:
    """Generate a random ID."""

    return uuid.uuid4().hex


def generate_user_id(db: firestore.client) -> str:
    """Generate a unique user ID by repeatedly generating random IDs until
    one is found that doesn't already exist in the database."""

    while True:
        user_id = generate_uuid()
        query = db.collection("users").where("user_id", "==", user_id)
        docs = query.get()
        if not unpack_query_results(docs):
            return user_id


def check_user_existence(db: firestore.client, exit_code: str, phone_number: str):
    """Check if a user's inputted phone numbers already exists."""

    phone_number = format_phone_number(phone_number=phone_number, exit_code=exit_code)

    query = db.collection("users").where("phone_number", "==", phone_number)
    docs = query.stream()

    if unpack_query_results(docs):
        return True
    else:
        return False


def create_new_user(
    db: firestore.client, exit_code: str, phone_number: str, role_id: int
) -> Any:
    """Create a new user"""

    phone_number = format_phone_number(phone_number=phone_number, exit_code=exit_code)

    user_id = generate_user_id(db)

    # This is for authentication but I can't figure out if it's needed or not..
    # In case an already registered user is attempting to register
    # try:
    #     # Check if a user with the phone number already exists
    #     existing_user = auth.get_user_by_phone_number(phone_number)
    #     # If a user with the phone number exists, return an error message
    #     return {'error': 'User with phone number already exists'}

    # except auth.AuthError as e:
    #     # If the error is not "USER_NOT_FOUND", raise the error
    #     if e.code != 'USER_NOT_FOUND':
    #         raise e

    # # If no user with the phone number exists, create a new user
    # auth.create_user(
    #     uid= user_id,
    #     phone_number=phone_number
    # )

    users_cf = db.collection("users")
    users_cf.add(
        {
            "user_id": user_id,
            "phone_number": phone_number,
            "created_at": datetime.now(),
            "role_id": int(role_id),
        }
    )

    selected_interests_cf = db.collection("selected_interests")
    selected_interests_cf.add({"user_id": user_id})

    declined_interests_cf = db.collection("declined_interests")
    declined_interests_cf.add({"user_id": user_id})


def update_user_info(db: firestore.client, phone_number: str, data: str) -> None:
    """After user is created with their phone number, update the record with their first name"""

    query = db.collection("users").where("phone_number", "==", phone_number)
    docs = query.get()

    if len(docs) > 0:
        field = list(data.keys())[0]
        doc_ref = docs[0].reference
        doc_ref.update({field: data[field]})


def generate_token(user) -> Any:
    """Generate a token for a new user for token based login."""

    token = auth.create_custom_token(user.uid)

    return token


def get_existing_users(db: firestore.client) -> Any:
    """Retrieve existing user info."""

    collection_ref = db.collection("users")
    docs = collection_ref.stream()
    results = unpack_query_results(docs)

    return results


def get_user_info(db: firestore.client, user_id: int) -> list:
    """Retrieve existing user info."""

    collection_ref = db.collection("users")
    query = collection_ref.where("user_id", "==", user_id)
    docs = query.get()

    results = unpack_query_results(docs)

    return results


def update_user_role(db: firestore.client, user_id: int, role_id: int) -> Any:
    users = db.collection("users")
    query = users.where("user_id", "==", user_id)
    query.update({"role_id": role_id})
