// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Map<String, String> answers = {
    'A': 'writers',
    'B': 'writers,',
    'C': 'writers—',
    'D': 'writers;'
  };
  // string that store questions
  String question =
      '''Generations of mystery and horror __ have been inﬂuenced by the dark, gothic stories of celebrated American author
Edgar Allan Poe (1809–1849).

Which choice completes the text so that it conforms to the conventions of Standard English?''';

  void checkAnswer(String rightAnswer, String selectedAnswer) {
    bool isCorrect = rightAnswer == selectedAnswer;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boundaries'),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 40, // Adjust the height as needed
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Handle icon button press (e.g., show help dialog)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6, // Higher row takes 3 parts of the available space
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    question,
                    style: TextStyle(fontSize: 16.0),
                  )),
            ),
          ),
          Expanded(
            flex: 4, // Lower row takes 1 part of the available space
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
                      checkAnswer(
                          'A', key); // Replace 'A' with the correct answer
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
