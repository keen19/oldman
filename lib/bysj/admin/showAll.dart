import 'dart:math';

import 'package:flutter/material.dart';
import '../database/ConnectionDB.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: ShowAllPeople(),
      ),
    );
  }
}

class ShowAllPeople extends StatefulWidget {
  @override
  _ShowAllPeopleState createState() => _ShowAllPeopleState();
}

class _ShowAllPeopleState extends State<ShowAllPeople> with ConnectionDb {
  List list = List();

  @override
  void initState() {
    super.initState();
    getConnection();
  }

  ///查询所有信息
  Future<void> showAll() async {
    Results result =
        await (await conn.execute("select username,address,guardian from user"))
            .deStream();
    result.forEach((element) {
      list.add(element);
      print(element);
    });
  }

  deleteUser(String username) async {
    conn.execute("delete from user where user = '$username'");
  }

  returnText() {
    //showAll();
    List<Widget> widget = new List();
    for (int i = 0; i < list.length; i++) {
      //print(list.toString());
      widget.add(Container(
        child: Row(
          children: <Widget>[
            Text(list[i][0]),
            SizedBox(
              width: 10,
              child: Divider(),
            ),
/*          Container(child: VerticalDivider(
            color: Colors.grey,
            width: 1,
          ),
          ), */ //垂直分割线
            Text(list[i][1]),
            SizedBox(
              width: 1,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(list[i][2]),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(onPressed: null, child: Text("修改")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text("提示信息!"),
                          content: Text("您确定要删除吗"),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("取消")),
                            ElevatedButton(onPressed: () {}, child: Text("确定")),
                          ],
                        );
                      });
                  setState(() {
                    widget.remove(i);
                  });
                },
                child: Text("删除")),
          ],
        ),
      ));
    }
    return Container(
      child: Column(
        children: widget,
      ),
    );
  }

  List<Widget> widgets = List();

  Widget createButtonContainer() {
    return Row(
      children: <Widget>[
        Text("用户"),
        SizedBox(
          width: 10,
          child: Divider(),
        ),
/*          Container(child: VerticalDivider(
            color: Colors.grey,
            width: 1,
          ),
          ), */ //垂直分割线
        Text("监护人"),
        SizedBox(
          width: 1,
          height: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text("实时地点"),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(onPressed: null, child: Text("修改")),
        ElevatedButton(onPressed: null, child: Text("删除")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    widgets.add(ElevatedButton(
      onPressed: () {
        showAll();
        setState(() {
          widgets.add(returnText());
        });
      },
      child: Text("获取所有人"),
    ));
    widgets.add(createButtonContainer());

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
