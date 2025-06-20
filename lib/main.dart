import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      setState(() {
        output = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
      });
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/") {
      setState(() {
        num1 = double.parse(output);
        operand = buttonText;
        output = "0";
      });
    } else if (buttonText == "=") {
      setState(() {
        num2 = double.parse(output);
        if (operand == "+") {
          output = (num1 + num2).toString();
        }
        if (operand == "-") {
          output = (num1 - num2).toString();
        }
        if (operand == "x") {
          output = (num1 * num2).toString();
        }
        if (operand == "/") {
          output = (num1 / num2).toString();
        }
        num1 = 0;
        num2 = 0;
        operand = "";
      });
    } else {
      setState(() {
        if (output == "0") {
          output = buttonText;
        } else {
          output = output + buttonText;
        }
      });
    }
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          buttonPressed(buttonText);
        },
        child: SizedBox(
          width: 80,
          height: 80,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calculator'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                output,
                style: TextStyle(fontSize: 48.0),
              ),
            ),
            Row(
              children: <Widget>[
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/"),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("x"),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-"),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("C"),
                buildButton("0"),
                buildButton("="),
                buildButton("+"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}