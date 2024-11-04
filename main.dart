import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const ScientificCalculatorApp());
}

class ScientificCalculatorApp extends StatelessWidget {
  const ScientificCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScientificCalculator(),
    );
  }
}

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({Key? key}) : super(key: key);

  @override
  _ScientificCalculatorState createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String _expression = '';
  String _result = '0';

  final List<String> buttons = [
    '7', '8', '9', 'DEL', 'AC',
    '4', '5', '6', '×', '÷',
    '1', '2', '3', '-', '+',
    '0', '.', '^', '√', '=',
    'sin', 'cos', 'tan', 'log', 'ln',
  ];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _result = '0';
      } else if (buttonText == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        _calculateResult();
      } else if (buttonText == '√') {
        _expression += 'sqrt(';
      } else if (buttonText == 'sin' || buttonText == 'cos' || buttonText == 'tan' || buttonText == 'log' || buttonText == 'ln') {
        _expression += buttonText + '(';
      } else if (buttonText == '×') {
        _expression += '*';
      } else if (buttonText == '÷') {
        _expression += '/';
      } else {
        _expression += buttonText;
      }
    });
  }

  void _calculateResult() {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(_expression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        _result = eval.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scientific Calculator')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: buttons[index] == '=' ? Colors.blueAccent : Colors.grey[800],
                      onPrimary: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () => _onButtonPressed(buttons[index]),
                    child: Text(buttons[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
