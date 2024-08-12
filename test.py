import sqlite3
import pandas as pd
from contextlib import closing
import json
import os
import re
def create_database(db_name='math_questions.db'):
    with sqlite3.connect(db_name) as conn:
        with closing(conn.cursor()) as cursor:
            cursor.execute('''
            CREATE TABLE IF NOT EXISTS questions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                question_id TEXT,
                question_type TEXT,
                text TEXT,
                answer_choices TEXT,
                correct_answer TEXT,
                rationale TEXT,
                url TEXT
            )
            ''')
            conn.commit()


def add_question_to_db(question, db_name='math_questions.db'):
    with sqlite3.connect(db_name) as conn:
        with closing(conn.cursor()) as cursor:
            url_json = json.dumps(question['url'])
            cursor.execute('''
            INSERT INTO questions (question_id, question_type, text, answer_choices, correct_answer, rationale, url)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', (question['question_id'], question['question_type'], question['text'],
                  question['answer_choices'], question['correct_answer'],
                  question['rationale'], url_json))
            conn.commit()


def replace_links(text, url_list):
    # Заменяет метки вида [link_1] на соответствующие URL из списка
    for index, url in enumerate(url_list):
        text = text.replace(f'[link_{index + 1}]', url)
    return text


def load_questions_from_excel(file_path, db_name='math_questions.db'):
    df = pd.read_excel(file_path)

    questions = df.to_dict(orient='records')

    for question in questions:
        # Преобразуем строку JSON из Excel в список
        url_list = parse_json_list(question['url'])

        # Заменяем метки в текстовых полях на соответствующие URL
        question['text'] = replace_links(question['text'], url_list)
        question['answer_choices'] = replace_links(question['answer_choices'], url_list)
        question['rationale'] = replace_links(question['rationale'], url_list)

        add_question_to_db(question, db_name)


def fetch_question_by_id(question_id, db_name='math_questions.db'):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT * FROM questions WHERE id = ?', (question_id,))
            result = cursor.fetchone()
            print(result['answer_choices'])
            if result:
                question = {
                    'question_id':result['question_id'],
                    'question_type':result['question_type'],
                    'text':result['text'],
                    'answer_choices':result['answer_choices'],
                    'correct_answer':result['correct_answer'],
                    'rationale':result['rationale'],
                    'url':json.loads(result['url'])  # Декодируем JSON обратно в список
                }
                return question
            return None


def parse_json_list(json_str):
    # Преобразует строку JSON в список Python
    if not isinstance(json_str, str):
        return []  # Возвращаем пустой список, если значение не строка

    json_str = json_str.strip()
    if json_str.startswith('[') and json_str.endswith(']'):
        json_str = json_str[1:-1]
    return [item.strip().strip('"') for item in json_str.split(',')]


def natural_sort_key(s):
    # Функция для генерации ключа сортировки, который учитывает числа в строке
    return [int(text) if text.isdigit() else text.lower() for text in re.split('([0-9]+)', s)]


def generate_image_urls(question_id, base_url='http://192.168.0.102:5000/get-image/'):
    question_dir = os.path.join('images', question_id)
    if not os.path.isdir(question_dir):
        return []

    # Получаем список файлов и сортируем их по числовым значениям в имени
    image_files = sorted([f for f in os.listdir(question_dir) if os.path.isfile(os.path.join(question_dir, f))],
                         key=natural_sort_key)

    # Генерируем URL для каждого файла
    urls = [base_url + f"{question_id}/{image}" for image in image_files]
    print(urls)
    return urls


def update_question_urls(db_name='math_questions.db'):
    with sqlite3.connect(db_name) as conn:
        conn.row_factory = sqlite3.Row
        with closing(conn.cursor()) as cursor:
            cursor.execute('SELECT id, question_id FROM questions')
            rows = cursor.fetchall()
            for row in rows:
                question_id = row['question_id']
                urls = ', '.join(generate_image_urls(question_id))
                url_json = json.dumps(urls)
                cursor.execute('''
                UPDATE questions
                SET url = ?
                WHERE id = ?
                ''', (url_json, row['id']))
            conn.commit()


if __name__ == '__main__':
    create_database()
    load_questions_from_excel('documents/math/Excel/math_questions.xlsx')
    update_question_urls()
    # Пример получения вопроса по ID
    question = fetch_question_by_id(3)
    if question:
        print(question)
