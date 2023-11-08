# !pip install Flask
# !pip install firebase-admin

import firebase_admin
from firebase_admin import auth, credentials
from flask import Flask, request, jsonify

cred = credentials.Certificate('medical-diagnosis-system-5ac77-firebase-adminsdk-4qexv-977e5abc57.json') 
firebase_admin.initialize_app(cred)

app = Flask(__name__)

@app.route('/deleteUserAuth', methods = ['POST'])
def deleteUserAuth():
    # uid = request.form.get('uid')
    uid = request.form['uid']
    
    try:
        auth.delete_user(uid)
        return jsonify(
            {
                'message': 'User with UID {} deleted.'.format(uid)
            }
        )
    except auth.AuthError as ex:
        return jsonify(
            {
                'error': str(ex)
            }
        ), 400

if __name__ == '__main__':
    # app.run(debug = True)
    app.run(debug = False, port = 5000)
