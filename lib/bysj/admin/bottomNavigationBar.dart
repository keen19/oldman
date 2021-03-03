import 'package:flutter/material.dart';
import '';
import 'showAll.dart';



class AdminTables extends StatefulWidget {
  AdminTables({Key key}) : super(key: key);

  @override
  _AdminTablesState createState() => _AdminTablesState();
}

class _AdminTablesState extends State<AdminTables> {
  int _currentIndex = 0;

  ///定义底部按钮
  final items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "老人",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: "监护人",
    )

  ];

  final pageController = PageController();

  void onTap(int index){
    pageController.jumpToPage(index);
  }
  void onPageChanged(int index){
    setState(() {
      _currentIndex=index;
    });
  }

  final _pageList = [
    ShowAllPeople(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return HomeContent();
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo"),
      ),
      //body: this._pageList[this._currentIndex],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTap,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        items:items,
      ),
    );
  }
}
