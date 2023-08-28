import json

from flask import g, Flask, jsonify, make_response, request
from database.db import db
from api.users import get_user_info, create_new_user, check_user_existence, update_user_info, update_user_role
from api.interests.selections import write_interest_selections, get_interests, Interest
from utils.utils import thwart_injection_attempt


app = Flask(__name__)


@app.before_request
def store_user_input():
    g.phone_number = request.form.get('phone_number')


@app.route("/user_presence", methods=['POST'])
def user_existence():

    exit_code = thwart_injection_attempt(request.form['exit_code'])
    phone_number = thwart_injection_attempt(request.form['phone_number'])

    user_exists = check_user_existence(
        db, 
        exit_code=exit_code, 
        phone_number=phone_number
    )

    if user_exists == True:
        return jsonify({'status': 'User exists'}), 200
    else:
        return jsonify({'status': 'User does not exist'}), 404


@app.route("/create_user", methods=["POST"])
def create_user():

    exit_code = thwart_injection_attempt(request.form['exit_code'])
    phone_number = thwart_injection_attempt(request.form['phone_number'])
    role_id = thwart_injection_attempt(request.form['role_id'])

    create_new_user(
        db, 
        exit_code, 
        phone_number, 
        role_id
    )
    
    return make_response('New user created', 204)


@app.route("/update_user_info", methods=["POST"])
def update_user():

    data = json.loads(
        request.form['data']
    )
    phone_number = request.form['phone_number']

    update_user_info(
        db, 
        phone_number=phone_number,
        data=data
    )

    return make_response('User updated', 204)


@app.route("/user_role", methods=['POST'])
def update_role():

    user_id = int(
        request.form['user_id']
    )
    update_user_role(
        db, 
        user_id
    )

    return make_response('User updated', 204)


@app.route("/users", methods=['POST'])
def user_data():

    user_id = int(
        request.form['user_id']
    )
    user = get_user_info(db, user_id)

    return user


@app.route("/interests", methods=['GET'])
def interests():

    return get_interests(db)


@app.route('/selected-interests', methods=['PUT'])
def selected_interests():
    
    user_id = int(
        request.form['user_id'],
    )
    interest_id = int(
        request.form['interest_id'],
    )
    write_interest_selections(db, user_id, interest_id, Interest.selected)
    return make_response('Selected interests updated', 204)


@app.route('/declined-interests', methods=['PUT'])
def declined_interests():

    user_id = int(
        request.form['user_id'],
    )
    interest_id = int(
        request.form['interest_id'],
    )
    write_interest_selections(db, user_id, interest_id, Interest.declined)
    return make_response('Declined interests updated', 204)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
