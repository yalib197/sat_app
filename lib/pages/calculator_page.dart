import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //..loadFile('D:/AppDevelopment/sat_app/assets/calculator.html')
    ..loadRequest(Uri.parse('https://www.desmos.com/calculator'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
