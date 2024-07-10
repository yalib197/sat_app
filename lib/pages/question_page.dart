// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final String
      questionType; // Эту переменную юзаешь короче чтобы отправить тип вопроса который нужен
  const QuestionPage({super.key, required this.questionType});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Map<String, String> answers = {
    //замени на варианты ответа
    'A': 'writers',
    'B': 'writers,',
    'C': 'writers—',
    'D': 'writers;'
  };
  /* 
  Future<void> fetchQuestion(int questionId) async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.101:5000/get/$questionId'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          questionText = jsonData['text'];
          correctAnswer = jsonData['correct_answer'];
          answerChoices = jsonDecode(jsonData['answer_choices']);
        });
      } else {
        throw Exception('Failed to load question');
      }
    } catch (e) {
      print('Error fetching question: $e');
      // Обработка ошибки, например, показ сообщения об ошибке пользователю
    }
  }
  */
  String correctAnswer = "A"; // замени на правильный ответ
  // string that store questions
  String questionText = // замени на вопрос
      '''Generations of mystery and horror __ have been inﬂuenced by the dark, gothic stories of celebrated American author
Edgar Allan Poe (1809–1849).

Which choice completes the text so that it conforms to the conventions of Standard English?''';
  String explanation = // замени на обьяснение
      '''Choice A is the best answer. The convention being tested is punctuation between a subject and a verb. When, as in this
case, a subject (“Generations of mystery and horror writers”) is immediately followed by a verb (“have been influenced”),
no punctuation is needed.
Choice B is incorrect because no punctuation is needed between the subject and the verb. Choice C is incorrect because
no punctuation is needed between the subject and the verb. Choice D is incorrect because no punctuation is needed
between the subject and the verb.''';
  void checkAnswer(String selectedAnswer) {
    bool isCorrect = correctAnswer == selectedAnswer;
    String resultText = isCorrect ? 'Correct!' : 'Wrong!';
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(resultText),
            content: Text(
              isCorrect ? 'Good job!' : 'Try again next time.',
            ),
            actions: <Widget>[
              Row(
                children: [
                  TextButton(
                    child: Text('Explanation'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showExplanation();
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  void showExplanation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Explanation:'),
          content: SizedBox(
              height: 200,
              child: SingleChildScrollView(child: Text(explanation))),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 40, // Adjust the height as needed
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Handle help icon button press (e.g., show help dialog)
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showExplanation(); // Show explanation dialog when pressed
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              //TODo Сделай короче тут функцию которая перекидывает в след вопрос
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1, // Higher row takes 3 parts of the available space
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    questionText,
                    style: TextStyle(fontSize: 16.0),
                  )),
            ),
          ),
          Expanded(
            flex: 1, // Lower row takes 1 part of the available space
            child: ListView.builder(
              itemCount: answers.keys
                  .toList()
                  .length, // Number of items based on the keys length
              itemBuilder: (context, index) {
                String key = answers.keys.toList()[index];
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      checkAnswer(key);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14.0),
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize: Size(double.infinity, 50.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 97, 184, 255),
                          ),
                          child: Center(
                            child: Text(
                              key,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            answers[key]!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
