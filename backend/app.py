import json

from flask import g, Flask, jsonify, make_response, request
from database.db import db
from api.users import get_user_info, create_new_user, format_phone_number, check_user_existence, update_user_info
from api.ethnicity import write_ethnicity
from api.interests.selections import write_selected_interests, write_declined_interests
from utils.utils import sanitize_input, ward_injection_attempt


app = Flask(__name__)


@app.before_request
def store_user_input():
    g.phone_number = request.form.get('phone_number')


@app.route("/user_presence", methods=['POST'])
def user_existence():

    exit_code = ward_injection_attempt(request.form['exit_code'])
    phone_number = ward_injection_attempt(request.form['phone_number'])

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

    exit_code = ward_injection_attempt(request.form['exit_code'])
    phone_number = ward_injection_attempt(request.form['phone_number'])
    role_id = ward_injection_attempt(request.form['role_id'])

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


@app.route("/users", methods=['POST'])
def user_data():

    user_id = int(
        request.form['user_id']
    )
    user = get_user_info(db, user_id)

    return user


@app.route("/ethnicity", methods=['POST'])
def ethnicity():

    user_id = int(
        request.form['user_id']
    )
    ethnicity_id = int(
        request.form['ethnicity_id']
    )
    
    write_ethnicity(user_id, ethnicity_id)
    print('ethnicity written')


@app.route('/interests', methods=['PUT'])
def interests():
    
    write_selected_interests(db, 1, ['some crap'])
    return make_response('Interests updated', 204)


@app.route('/noninterests', methods=['PUT'])
def noninterests():

    write_declined_interests(db, 1, ['some crap'])
    return make_response('Non-interests updated', 204)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
