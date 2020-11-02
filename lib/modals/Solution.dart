class Solution {
  String expression;
  String solution;
  String timespamp;
  Solution({this.timespamp, this.expression, this.solution});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "timestamp": this.timespamp,
      "expression": this.expression,
      "solution": this.solution,
    };
  }

  static Solution fromMap(Map<String, dynamic> map) {
    return Solution(
        timespamp: map['timestamp'].toString(),
        expression: map['expression'].toString(),
        solution: map['solution'].toString());
  }

  @override
  String toString() {
    return '{timespamp: ' +
        this.timespamp +
        ', expression: ' +
        this.expression +
        ', solution: ' +
        this.solution +
        '}';
  }
}
