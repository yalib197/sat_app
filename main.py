import questions_parser
import time
from flask import Flask, jsonify, send_file
from flask_cors import CORS
import sqlite3
from contextlib import closing
import json
import os
from sat import Question
from random import randint


def get_math_question_by_id(db_name, question_id):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM questions WHERE id = ?', (question_id,))
            result = cursor.fetchone()
            if result:
                question = Question(
                    question_id=result['question_id'],
                    text=result['text'],
                    answer_choices=json.dumps(result['answer_choices']),
                    correct_answer=result['correct_answer'],
                    rationale=result['rationale'],
                    question_type=result['question_type'],
                    url=result['url']
                )
                return question
            else:
                return None


def get_math_question_by_question_id(db_name, question_id):
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
                    question_type=result['question_type'],
                    url=result['url']
                )
                return question
            else:
                return None

# Функция для поиска вопросов по типу в базе данных математических вопросов
def find_math_questions_by_type(db_name, question_type):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT question_id FROM questions WHERE question_type = ?', (question_type,))
            results = cursor.fetchall()
            question_ids = [result['question_id'] for result in results]
            return question_ids

# Функция для получения всех question_id из базы данных математических вопросов
def get_all_math_question_ids(db_name):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT question_id FROM questions')
            results = cursor.fetchall()
            question_ids = [result['question_id'] for result in results]
            return question_ids

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
                question = Question(
                    question_id=result['question_id'],
                    text=result['text'],
                    answer_choices=json.dumps(result['answer_choices']),
                    correct_answer=result['correct_answer'],
                    rationale=result['rationale'],
                    question_type=result['question_type'],
                    url=result['url']
                )
                return question
            else:
                return None

def clean_string(value):
    # Function to remove unwanted characters
    return value.replace('\\"', '').replace('"', '')

def get_question_by_question_id(db_name, question_id):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM questions WHERE question_id = ?', (question_id,))
            result = cursor.fetchone()
            if db_name =="math_questions.db":
                if result:
                    question = Question(
                        question_id=clean_string(result['question_id']),
                        text=clean_string(result['text']),
                        answer_choices=clean_string(json.dumps(result['answer_choices'])),
                        correct_answer=clean_string(result['correct_answer']),
                        rationale=clean_string(result['rationale']),
                        question_type=clean_string(result['question_type']),
                        url=clean_string(result['url'])
                    )
                    return question
                else:
                    return None
            else:
                if result:
                    question = Question(
                        question_id=result['question_id'],
                        text=result['text'],
                        answer_choices=json.dumps(result['answer_choices']),
                        correct_answer=result['correct_answer'],
                        rationale=result['rationale'],
                        question_type=result['question_type'],
                        url=result['url']
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

@app.route('/get-math-function', methods=['GET'])
def get_math_function():
    math_function = r"E = mc^2"
    return jsonify({"function": math_function}), 200
@app.route('/get/math/id/<int:question_id>', methods=['GET'])
def get_math_question_by_id_route(question_id):
    question = get_math_question_by_id("math_questions.db", question_id)
    if question:
        return jsonify(question.to_dict()), 200
    else:
        return jsonify({"error": "Math question not found"}), 404


@app.route('/get/math/question_id/<string:question_id>', methods=['GET'])
def get_math_question_by_question_id_route(question_id):
    question = get_math_question_by_question_id("math_questions.db", question_id)
    if question:
        return jsonify(question.to_dict()), 200
    else:
        return jsonify({"error": "Math question not found"}), 404


@app.route('/get/math/list_type/<string:question_type>', methods=['GET'])
def find_math_questions_by_type_route(question_type):
    question_ids = find_math_questions_by_type("math_questions.db", question_type)
    return jsonify({"question_ids": question_ids}), 200


@app.route('/get/math/all_ids', methods=['GET'])
def get_all_math_question_ids_route():
    question_ids = get_all_math_question_ids("math_questions.db")
    return jsonify({"question_ids": question_ids}), 200

@app.route('/math/get/random/list_type/<string:question_type>', methods=['GET'])
def get_random_math_question_by_type(question_type):
    valid_types = [
        'Advanced Math', 'Algebra', 'Geometry and Trigonometry',
        'Problem Solving and Data analysis'
    ]
    if question_type not in valid_types:
        return jsonify({"error": "Invalid question type"}), 400

    question_ids = find_by_type("math_questions.db", question_type)
    random_number = randint(0,len(question_ids)-1)
    question = get_question_by_question_id(
        "math_questions.db",
        question_ids[random_number]
    )
    return jsonify(question.to_dict()), 200


@app.route('/get-image/<question_id>/<filename>', methods=['GET'])
def get_image(question_id, filename):
    # Укажите путь к директории с изображениями внутри проекта
    image_directory = os.path.join(app.root_path, 'images', question_id)
    # Полный путь к изображению
    image_path = os.path.join(image_directory, filename)
    try:
        return send_file(image_path, mimetype='image/jpeg')
    except FileNotFoundError:
        return jsonify({"error": "Image not found"}), 404


if __name__ == '__main__':
    if not os.path.exists('questions.db'):
        fill_db()
    app.run(host="0.0.0.0")
