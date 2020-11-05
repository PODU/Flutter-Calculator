import 'package:calculator/modals/Solution.dart';
import 'package:calculator/views/HistoryCards/solutionCard.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatefulWidget {
  final String timeStamp;
  final List<Solution> list;
  HistoryCard({Key key, this.timeStamp, this.list}) : super(key: key);

  @override
  _HistoryCardState createState() =>
      _HistoryCardState(timeStamp: this.timeStamp, list: this.list);
}

class _HistoryCardState extends State<HistoryCard> {
  String timeStamp;
  List<Solution> list;

  _HistoryCardState({this.timeStamp, this.list});

  Solution getSolutionFromList(int index) {
    if (index >= this.list.length) {
      return null;
    }
    int key = this.list.asMap().keys.elementAt(index);
    return this.list.asMap()[key];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.timeStamp,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[350],
                ),
                itemCount: this.list.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext childContext, int index) {
                  return SolutionCard(solution: getSolutionFromList(index));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
