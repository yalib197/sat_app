import 'package:flutter/material.dart';
import 'package:sat_app/pages/question_page.dart';

class QuestionTypesPage extends StatefulWidget {
  final bool showMathQuestions; // Variable to determine which questions to show
  const QuestionTypesPage({super.key, required this.showMathQuestions});

  @override
  _QuestionTypesPageState createState() => _QuestionTypesPageState();
}

class _QuestionTypesPageState extends State<QuestionTypesPage> {
  late List<String> questionTypes;
  late List<String> filteredQuestionTypes;
  final TextEditingController searchController = TextEditingController();

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
  void initState() {
    super.initState();
    questionTypes =
        widget.showMathQuestions ? mathQuestionTypes : verbalQuestionTypes;
    filteredQuestionTypes = questionTypes;
    searchController.addListener(_filterQuestionTypes);
  }

  void _filterQuestionTypes() {
    setState(() {
      filteredQuestionTypes = questionTypes
          .where((type) =>
              type.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showMathQuestions
            ? 'Math Question Types'
            : 'Verbal Question Types'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            // Sub-category List
            Expanded(
              child: ListView.separated(
                itemCount: filteredQuestionTypes.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      filteredQuestionTypes[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionPage(
                            questionType: filteredQuestionTypes[index],
                            showMathQuestions: widget.showMathQuestions,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
