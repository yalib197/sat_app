// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sat_app/pages/question_types_page.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    double progress = 0; // Example progress variable

    return Scaffold(
      backgroundColor:
          Colors.grey.shade200, // Set entire page color to a darker white
      appBar: AppBar(
        centerTitle: true,
        title: Text('Practice',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            )),
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Practice Test Progress Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set container color to white
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Questions Practice Progress',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 48,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('0',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  Text('Answered',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('60',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  Text('Left',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('00:00',
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  Text('Quiz Time',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons below Practice Test Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 140, // Fixed width
                    height: 80, // Fixed height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement Custom Practice Test
                      },
                      child: Text(
                        'Practice test from AI',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140, // Fixed width
                    height: 80, // Fixed height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement Custom Practice Test
                      },
                      child: Text(
                        'Custom practice test',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              // Practice by Subject Section
              // Practice by Subject Section
              Text(
                'Practice by Subject',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionTypesPage(showMathQuestions: false),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verbal',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'The main test is knowledge of finding support for ideas from texts, the meaning of words in context, and historical/social research and analysis.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionTypesPage(showMathQuestions: true),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Math',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Practice questions on algebra, geometry, statistics, and more.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
