import 'package:calculator/modals/Solution.dart';
import 'package:calculator/services/db_operations/db_operations.dart';
import 'package:calculator/views/HistoryCards/historyCard.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map<String, List<Solution>> list = {};

  void updateList() {
    DBOperations.read().then((value) {
      setState(() {
        Map<String, List<Solution>> entries = {};
        for (var item in value) {
          if (entries.containsKey(item.timespamp)) {
            entries[item.timespamp].add(item);
          } else {
            entries.putIfAbsent(item.timespamp, () {
              List<Solution> list = new List();
              list.add(item);
              return list;
            });
          }
        }
        this.list = entries;
      });
    });
  }

  Widget buildScreen() {
    if (this.list.isEmpty) {
      return Center(
        child: Text(
          'No History',
          style: Theme.of(context).textTheme.headline2,
        ),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        padding: EdgeInsets.all(10),
        itemCount: this.list.length,
        itemBuilder: (BuildContext builderContext, int index) {
          String key = this.list.keys.elementAt(index);
          return HistoryCard(
            timeStamp: key,
            list: this.list[key],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this.list = new Map<String, List<Solution>>();
    DBOperations.init();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    if (this.list.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Center(
          child: Text(
            'No History',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('History'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete History'),
                        content: Text('Are you sure?'),
                        actions: [
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              DBOperations.delete().then((value) {
                                Navigator.pop(context);
                              }).catchError((err) {
                                print('Error while deleting entries from DB.');
                                print(err);
                              });
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }).whenComplete(() {
                  setState(() {
                    updateList();
                  });
                });
              },
            )
          ],
        ),
        body: Container(
          child: buildScreen(),
        ),
      );
    }
  }
}
