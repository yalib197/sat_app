import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sat_app/pages/calculator_page.dart';

class QuestionPage extends StatefulWidget {
  final String questionType;
  final bool showMathQuestions;
  const QuestionPage(
      {super.key, required this.questionType, required this.showMathQuestions});

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

  String correctAnswer = "A";
  String questionText =
      '''Generations of mystery and horror __ have been inﬂuenced by the dark, gothic stories of celebrated American author
Edgar Allan Poe (1809–1849).

Which choice completes the text so that it conforms to the conventions of Standard English?''';
  String explanation =
      '''Choice A is the best answer. The convention being tested is punctuation between a subject and a verb. When, as in this
case, a subject (“Generations of mystery and horror writers”) is immediately followed by a verb (“have been influenced”),
no punctuation is needed.
Choice B is incorrect because no punctuation is needed between the subject and the verb. Choice C is incorrect because
no punctuation is needed between the subject and the verb. Choice D is incorrect because no punctuation is needed
between the subject and the verb.''';

  bool showBottomNavBar = false;
  String? selectedAnswer;
  String? clickedAnswer;
  bool isHintVisible = false;
  late Future<String?> _hint;

  @override
  void initState() {
    super.initState();
    _hint = getHint(questionText, answers, correctAnswer, explanation);
  }

  void checkAnswer(String selectedAnswer) {
    setState(() {
      clickedAnswer = selectedAnswer;
      if (selectedAnswer == correctAnswer) {
        showBottomNavBar = true;
      }
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

  Future<String?> getHint(String questionText, Map<String, String> answers,
      String correctAnswer, String explanation) async {
    const apiKey = 'YOUR API KEY';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [
      Content.text(
          '''Give me a hint to this question using this information. Also in your message show just hint itself.
          here is question
          $questionText 
          here are possible answers
          $answers
          here is the correct answer
          $correctAnswer
          and here is the explanation
          $explanation
          ''')
    ];
    final response = await model.generateContent(content);
    return response.text;
  }

  Widget showCalculator(bool showMathQuestions) {
    if (showMathQuestions) {
      return (IconButton(
        icon: Icon(Icons.calculate),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalculatorPage()),
          );
        },
      ));
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 40,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              setState(() {
                isHintVisible = !isHintVisible;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showExplanation();
            },
          ),
          showCalculator(widget.showMathQuestions),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionText,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isHintVisible = !isHintVisible;
                          });
                        },
                        child: Text(
                          "Show Hint",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      if (isHintVisible)
                        FutureBuilder<String?>(
                          future: _hint,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error loading hint");
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  snapshot.data ?? "No hint available",
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black87),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: answers.keys.length,
              itemBuilder: (context, index) {
                String key = answers.keys.toList()[index];
                Color borderColor = Colors.black;

                if (clickedAnswer != null) {
                  if (key == clickedAnswer) {
                    borderColor =
                        key == correctAnswer ? Colors.green : Colors.red;
                  }
                }

                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      checkAnswer(key);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .scaffoldBackgroundColor, // Match background color
                      padding: EdgeInsets.all(14.0),
                      textStyle: TextStyle(fontSize: 16.0),
                      minimumSize: Size(double.infinity, 50.0),
                      side: BorderSide(
                          color: borderColor, width: 2.0), // Add border color
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          child: Center(
                            child: Text(
                              key,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
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
                            style: TextStyle(color: Colors.black),
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
      bottomNavigationBar: showBottomNavBar
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'Explanation',
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_forward),
                  label: 'Next',
                  backgroundColor: Colors.blue,
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  showExplanation();
                } else {
                  // Implement the functionality for 'Next' button
                }
              },
            )
          : null,
    );
  }
}
