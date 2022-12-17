from flask import Flask,render_template
from flask import request,jsonify
from pymongo import MongoClient

import config

client = MongoClient(config.connection_string)


mydb = client["customerFeedback"]
mycol = mydb["feedBackData"]
app = Flask(__name__)


@app.route('/')
def index():
    feedback = []

    for i in mycol.find({},{"_id":0}):
        feedback.append(i)

    return render_template("index.html", heading="feedback", data=feedback)


@app.route('/upload', methods = ["GET"])
def upload():
    feedback = request.args.get('feedback')

    if feedback == '':
      return "Invalid Feedback"

    try:
        insertOp = mycol.insert_one({"feedback": feedback})
        return index()
    except:
        return "Insertion failed"


if __name__ == "__main__":
    app.run()

