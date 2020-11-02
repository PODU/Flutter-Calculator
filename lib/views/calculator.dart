import 'package:calculator/modals/Solution.dart';
import 'package:calculator/services/db_operations/db_operations.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String currentExpression;
  String totaledExpression;
  double equationFontSize;
  double solutionFontSize;
  int brackets = 0;

  Widget buildScreen(context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: false,
            child: Text(
              this.currentExpression,
              style: TextStyle(fontSize: this.equationFontSize),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              this.totaledExpression,
              style: TextStyle(
                fontSize: solutionFontSize,
              ),
            ),
          ),
        ),
        Divider(
          height: 50,
        ),
        Expanded(
          child: buildButtonPad(context),
        ),
      ],
    );
  }

  Widget getButtonChild(text, textColor) {
    if (text == 'bsp') {
      return Icon(Icons.backspace_outlined, color: textColor);
    } else {
      return Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      );
    }
  }

  String normalizeExpression(String exp) {
    exp = exp.replaceAll('x', '*');
    exp = exp.replaceAll('÷', '/');
    return exp;
  }

  void updateSolution() {
    var expression = normalizeExpression(this.currentExpression);
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double value = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        this.totaledExpression = value.toString();
      });
    } catch (ex) {}
  }

  void performAction(buttonText) {
    setState(() {
      switch (buttonText) {
        case 'bsp':
          if (this.currentExpression.length > 0) {
            this.currentExpression = this
                .currentExpression
                .substring(0, this.currentExpression.length - 1);
          }
          updateSolution();
          break;
        case 'AC':
          this.currentExpression = '';
          this.totaledExpression = '';
          this.brackets = 0;
          break;
        case '( )':
          if (this.brackets > 0) {
            int idx = this.currentExpression.lastIndexOf('(');
            if (idx == this.currentExpression.length - 1) {
              this.currentExpression += '(';
              this.brackets++;
            } else {
              this.currentExpression += ')';
              this.brackets--;
            }
          } else {
            this.currentExpression += '(';
            this.brackets++;
          }
          updateSolution();
          break;
        case '=':
          var expression = normalizeExpression(this.currentExpression);
          try {
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            double value = exp.evaluate(EvaluationType.REAL, cm);
            this.totaledExpression = value.toString();
            DBOperations.insert(new Solution(
                timespamp: formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]),
                expression: this.currentExpression,
                solution: this.totaledExpression));
            this.currentExpression = this.totaledExpression;
            this.totaledExpression = '';
          } catch (ex) {
            this.totaledExpression = 'ERROR';
          }
          break;
        default:
          this.currentExpression += buttonText;
          updateSolution();
          break;
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor,
      Color textColor) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(
          color: Colors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.all(16),
      onPressed: () => performAction(buttonText),
      height: buttonHeight,
      color: buttonColor,
      child: getButtonChild(buttonText, textColor),
    );
  }

  Widget buildButtonPad(context) {
    var height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Table(
            children: [
              TableRow(
                children: [
                  buildButton('AC', height * 0.13, Colors.red, Colors.white),
                  buildButton(
                      'bsp', height * 0.13, Colors.blue, Colors.yellow[700]),
                  buildButton(
                      '%', height * 0.13, Colors.blue, Colors.yellow[700]),
                  buildButton(
                      '÷', height * 0.13, Colors.blue, Colors.yellow[700]),
                ],
              ),
              TableRow(
                children: [
                  buildButton('7', height * 0.12, Colors.blue, Colors.white),
                  buildButton('8', height * 0.12, Colors.blue, Colors.white),
                  buildButton('9', height * 0.12, Colors.blue, Colors.white),
                  buildButton(
                      'x', height * 0.12, Colors.blue, Colors.yellow[700]),
                ],
              ),
              TableRow(
                children: [
                  buildButton('4', height * 0.12, Colors.blue, Colors.white),
                  buildButton('5', height * 0.12, Colors.blue, Colors.white),
                  buildButton('6', height * 0.12, Colors.blue, Colors.white),
                  buildButton(
                      '-', height * 0.12, Colors.blue, Colors.yellow[700]),
                ],
              ),
              TableRow(
                children: [
                  buildButton('1', height * 0.12, Colors.blue, Colors.white),
                  buildButton('2', height * 0.12, Colors.blue, Colors.white),
                  buildButton('3', height * 0.12, Colors.blue, Colors.white),
                  buildButton(
                      '+', height * 0.12, Colors.blue, Colors.yellow[700]),
                ],
              ),
              TableRow(
                children: [
                  buildButton('.', height * 0.12, Colors.blue, Colors.white),
                  buildButton('0', height * 0.12, Colors.blue, Colors.white),
                  buildButton('00', height * 0.12, Colors.blue, Colors.white),
                  buildButton('=', height * 0.12, Colors.green, Colors.white),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    this.totaledExpression = '';
    this.currentExpression = '';
    this.equationFontSize = 38;
    this.solutionFontSize = 48;
    DBOperations.init().catchError((error) {
      print('Failed to Initialize DB');
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/history',
              );
            },
          )
        ],
      ),
      body: buildScreen(context),
    );
  }
}
