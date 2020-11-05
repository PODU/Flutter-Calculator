import 'package:calculator/modals/Solution.dart';
import 'package:flutter/material.dart';

class SolutionCard extends StatefulWidget {
  final Solution solution;

  SolutionCard({this.solution});

  @override
  _SolutionCardState createState() =>
      _SolutionCardState(solution: this.solution);
}

class _SolutionCardState extends State<SolutionCard> {
  Solution solution;

  _SolutionCardState({this.solution});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              this.solution.expression,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.end,
            ),
            Text(
              this.solution.solution,
              style: TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
      onDoubleTap: () {
        Navigator.pop(context, {
          'solution': this.solution.solution,
          'expression': this.solution.expression
        });
      },
    );
  }
}
