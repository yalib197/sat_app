import questions_parser
import time
from flask import Flask, jsonify, send_file
from flask_cors import CORS
import sqlite3
from contextlib import closing
import json
import tempfile
import os
from sat import Question
from random import randint


def fill_db():
    start_time = time.time()
    questions_parser.create_database()
    all_questions = []
    file_names = questions_parser.parse_file_names()
    print(file_names)

    for file_name in file_names:
        questions = questions_parser.parse_pdf(file_name)
        all_questions.extend(questions)
        for question in questions:
            try:
                questions_parser.add_question_to_db(question)
            except sqlite3.Error as e:
                print(f"Error adding question to database: {e}")

    end_time = time.time()
    print(f"Time taken to fill the database: {int(end_time - start_time)} seconds")
    return 0



app = Flask(__name__)
CORS(app)
def get_question_by_id(db_name, question_id):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM questions WHERE id = ?', (question_id,))
            result = cursor.fetchone()
            if result:
                print(result['answer_choices'])
                question = Question(
                    question_id=result['question_id'],
                    text=result['text'],
                    answer_choices=json.dumps(result['answer_choices']),
                    correct_answer=result['correct_answer'],
                    rationale=result['rationale'],
                    question_type=result['question_type']
                )
                return question
            else:
                return None


def get_question_by_question_id(db_name, question_id):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM questions WHERE question_id = ?', (question_id,))
            result = cursor.fetchone()
            if result:
                question = Question(
                    question_id=result['question_id'],
                    text=result['text'],
                    answer_choices=json.dumps(result['answer_choices']),
                    correct_answer=result['correct_answer'],
                    rationale=result['rationale'],
                    question_type=result['question_type']
                )
                return question
            else:
                return None


def find_by_type(db_name, question_type):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT question_id FROM questions WHERE question_type = ?', (question_type,))
            results = cursor.fetchall()
            question_ids = [result['question_id'] for result in results]
            return question_ids


def get_all_question_ids(db_name):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT question_id FROM questions')
            results = cursor.fetchall()
            question_ids = [result['question_id'] for result in results]
            return question_ids


@app.route('/get/id/<int:question_id>', methods=['GET'])
def get_question_by_id_route(question_id):
    question = get_question_by_id("questions.db", question_id)
    if question:
        return jsonify(question.to_dict()), 200
    else:
        return jsonify({"error": "Question not found"}), 404


@app.route('/get/question_id/<string:question_id>', methods=['GET'])
def get_question_by_question_id_route(question_id):
    question = get_question_by_question_id("questions.db", question_id)
    if question:
        return jsonify(question.to_dict()), 200
    else:
        return jsonify({"error": "Question not found"}), 404


@app.route('/get/list_type/<string:question_type>', methods=['GET'])
def find_questions_by_type(question_type):
    valid_types = [
        'Boundaries', 'Central Ideas and Details', 'Command of Evidence',
        'Cross Text Connections', 'Form Structure and Sense', 'Inference',
        'Rhetorical Synthesis', 'Text Structure and Purpose', 'Transitions',
        'Words in Context'
    ]
    if question_type not in valid_types:
        return jsonify({"error": "Invalid question type"}), 400

    question_ids = find_by_type("questions.db", question_type)
    return jsonify({"question_ids": question_ids}), 200

@app.route('/get/random/list_type/<string:question_type>', methods=['GET'])
def get_random_question_by_type(question_type):
    valid_types = [
        'Boundaries', 'Central Ideas and Details', 'Command of Evidence',
        'Cross Text Connections', 'Form Structure and Sense', 'Inference',
        'Rhetorical Synthesis', 'Text Structure and Purpose', 'Transitions',
        'Words in Context'
    ]
    if question_type not in valid_types:
        return jsonify({"error": "Invalid question type"}), 400

    question_ids = find_by_type("questions.db", question_type)
    random_number = randint(0,len(question_ids)-1)
    question = get_question_by_question_id(
        "questions.db",
        question_ids[random_number]
    )
    return jsonify(question.to_dict()), 200

@app.route('/get/all_ids', methods=['GET'])
def get_all_question_ids_route():
    question_ids = get_all_question_ids("questions.db")
    return jsonify({"question_ids": question_ids}), 200


if __name__ == '__main__':
    if not os.path.exists('questions.db'):
        fill_db()
    app.run(host="0.0.0.0")
