import 'package:flutter/material.dart';
import 'package:sat_app/pages/question_page.dart';

class QuestionTypesPage extends StatelessWidget {
  final bool showMathQuestions; // Variable to determine which questions to show
  const QuestionTypesPage({super.key, required this.showMathQuestions});

  static const List<String> verbalQuestionTypes = [
    'Central Ideas and Details',
    'Inferences',
    'Command of Evidence',
    'Words in Context',
    'Text Structure and Purpose',
    'Cross-Text Connections',
    'Rhetorical Synthesis',
    'Transitions',
    'Boundaries',
    'Form, Structure, and Sense'
  ];

  static const List<String> mathQuestionTypes = [
    'Linear equations in one variable',
    'Linear functions',
    'Linear equations in two variables',
    'Systems of two linear equations in two variables',
    'Linear inequalities in one or two variables',
    'Nonlinear functions',
    'Nonlinear equations in one variable and systems of equations in two variables',
    'Equivalent expressions',
    'Ratios, rates, proportional relationships, and units',
    'Percentages',
    'One-variable data: Distributions and measures of center and spread',
    'Two-variable data: Models and scatterplots',
    'Probability and conditional probability',
    'Inference from sample statistics and margin of error',
    'Evaluating statistical claims: Observational studies and experiments',
    'Area and volume',
    'Lines, angles, and triangles',
    'Right triangles and trigonometry',
    'Circles'
  ];

  @override
  Widget build(BuildContext context) {
    List<String> questionTypes =
        showMathQuestions ? mathQuestionTypes : verbalQuestionTypes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question Types'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: questionTypes.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(questionTypes[index]), //это короче название типа
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuestionPage(questionType: questionTypes[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
