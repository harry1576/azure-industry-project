from flask import Flask,render_template
from flask import request,jsonify
from pymongo import MongoClient

import config

client = MongoClient(config.connection_string)


mydb = client["customerFeedback"]
mycol = mydb["feedBackData"]
app = Flask("cotissFeedback")


@app.route('/')
def index():
    
    feedback = []

    for i in mycol.find({},{"_id":0}):
        feedback.append(i)

    return render_template("index.html", heading="feedback", data=feedback)


@app.route('/upload', methods = ["GET"])
def upload():
    feedback = request.args.get('feedback')
    print(feedback)
    insertDict = {
        "feedback": feedback
    }
    try:
        insertOp = mycol.insert_one(insertDict)
        return index()
    except:
        return "Insertion failed"


app.run(debug=True,host="0.0.0.0",port=8080)
