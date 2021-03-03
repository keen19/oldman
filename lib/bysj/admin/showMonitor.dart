import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'package:date_format/date_format.dart';
import 'addMonitor.dart';
import 'addOldMan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('管理员界面'),
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

class _ShowAllPeopleState extends State<ShowAllPeople> {
  List list = List();

  Map<String, List> map = Map();

  @override
  void initState() {
    super.initState();
    getConnection();
    //showAll();
  }

  MySqlConnection conn;

  getConnection() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'rm-wz9zt03rn0864rz8uho.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'keen',
        password: "Zxc000222",
        db: 'demo1'));

    await showAll();
  }

  Future<void> showAll() async {
    //刷新界面清空widget
    await widgetClear();
    //清空list
    await listClear();
    //执行查询
    Results result = await (await conn.execute(
            "select monitor_name,monitor_sex,monitor_age,on_duty,off_duty,monitor_telephone from monitor"))
        .deStream();
    result.forEach((element) {
      list.add(element);
    });
    widgets = createListView();
  }

  deleteUser(String monitorName) async {
    conn.execute("delete from monitor where monitor_name='$monitorName'");
  }

  Future<void> listClear() async {
    list = List();
  }

  List<Widget> createListView() {
    TextEditingController oldManNameController = new TextEditingController();
    TextEditingController oldManSexController = new TextEditingController();
    TextEditingController oldManAgeController = new TextEditingController();

    GlobalKey<FormState> _formKey = GlobalKey();
    var a = Colors.black12;
    var b = Colors.grey;
    List<Widget> sortList = List();

    for (int i = 0; i < list.length; i++) {
      //print(list.toString());
      //根据上班时间排序
      if (DateTime.now().hour >= int.parse(list[i][4]) &&
          DateTime.now().hour <= int.parse(list[i][5])) {
        sortList.insert(
            0,
            InkWell(
              onTap: () {
                return showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    "姓名:",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "${list[i][0]}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "性别:",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "${list[i][1]}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "年龄:",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "${list[i][2]}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    //监护人姓名
                    Container(
                      width: 45,
                      child: Center(
                        child: Text(list[i][0]),
                      ),
                    ),
                    //监护人性别
                    Container(
                      width: 38,
                      child: Center(
                        child: Text(list[i][1]),
                      ),
                    ),
                    //监护人年龄
                    Container(
                      width: 40,
                      child: Center(
                        child: Text(list[i][2]),
                      ),
                    ),
                    //监护人电话
                    Container(
                      width: 88,
                      child: Center(
                        child: Text(list[i][5]),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    //修改
                    InkWell(
                      onTap: () {
                        oldManNameController.text = '${list[i][0]}';
                        oldManSexController.text = '${list[i][1]}';
                        oldManAgeController.text = '${list[i][2]}';
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                                child: Container(
                                  height: 400,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        //用户名输入框
                                        TextFormField(
                                          controller: oldManNameController,
                                          //添加装饰盒显示图标
                                          decoration: InputDecoration(
                                            fillColor: Color(0x30cccccc),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0x00FF0000)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0x00000000)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            labelText: "用户名:",
                                          ),
                                          validator: (String value) {
                                            if (value.length >= 2 &&
                                                value.length <= 16) {
                                              return null;
                                            } else {
                                              return '只能输入2-16个字符';
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: oldManSexController,
                                          //添加装饰盒显示图标
                                          decoration: InputDecoration(
                                            fillColor: Color(0x30cccccc),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0x00FF0000)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0x00000000)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            labelText: "监护人:",
                                          ),
                                          validator: (String value) {
                                            return value == 'nan' ||
                                                    value == 'nv'
                                                ? null
                                                : '请正确输入';
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: oldManAgeController,
                                          //添加装饰盒显示图标
                                          decoration: InputDecoration(
                                            fillColor: Color(0x30cccccc),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0x00FF0000)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0x00000000)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            labelText: "年龄:",
                                          ),
                                          validator: (String value) {
                                            return value.length > 0 &&
                                                    value.length < 3
                                                ? null
                                                : '只能输入2-16个字符';
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            ElevatedButton(
                                              child: Text("取消"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                              child: Text("修改"),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  Navigator.pop(context);
                                                  Fluttertoast.showToast(
                                                      msg: "修改成功");
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "修改失败");
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromARGB(255, 34, 150, 243)),
                          height: 30,
                          width: 50,
                          child: Text(
                            "修改",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                    //删除
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text("提示信息!"),
                                content: Text("您确定要删除吗?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("取消")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await deleteUser(list[i][0]);
                                        setState(() {
                                          widgets.remove(this);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text("确定")),
                                ],
                              );
                            });
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromARGB(255, 34, 150, 243)),
                          height: 30,
                          width: 50,
                          child: Text(
                            "删除",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                    //判断是否上班时间
                    Icon(Icons.circle,
                        color: DateTime.now().hour >= int.parse(list[i][4]) &&
                                DateTime.now().hour <= int.parse(list[i][5])
                            ? Colors.green
                            : Colors.red),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ));
      } else {
        sortList.add(InkWell(
          onTap: () {
            return showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 50,
                              ),
                              Text(
                                "姓名:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][0]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "性别:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][1]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "年龄:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][2]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Container(
            height: 50,
            child: Row(
              children: <Widget>[
                //监护人姓名
                Container(
                  width: 45,
                  child: Center(
                    child: Text(list[i][0]),
                  ),
                ),
                //监护人性别
                Container(
                  width: 38,
                  child: Center(
                    child: Text(list[i][1]),
                  ),
                ),
                //监护人年龄
                Container(
                  width: 40,
                  child: Center(
                    child: Text(list[i][2]),
                  ),
                ),
                //监护人电话
                Container(
                  width: 88,
                  child: Center(
                    child: Text(list[i][5]),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                //修改
                InkWell(
                  onTap: () {
                    oldManNameController.text = '${list[i][0]}';
                    oldManSexController.text = '${list[i][1]}';
                    oldManAgeController.text = '${list[i][2]}';
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                            child: Container(
                              height: 400,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //用户名输入框
                                    TextFormField(
                                      controller: oldManNameController,
                                      //添加装饰盒显示图标
                                      decoration: InputDecoration(
                                        fillColor: Color(0x30cccccc),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0x00FF0000)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0x00000000)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        labelText: "用户名:",
                                      ),
                                      validator: (String value) {
                                        if (value.length >= 2 &&
                                            value.length <= 16) {
                                          return null;
                                        } else {
                                          return '只能输入2-16个字符';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: oldManSexController,
                                      //添加装饰盒显示图标
                                      decoration: InputDecoration(
                                        fillColor: Color(0x30cccccc),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0x00FF0000)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0x00000000)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        labelText: "监护人:",
                                      ),
                                      validator: (String value) {
                                        return value == 'nan' || value == 'nv'
                                            ? null
                                            : '请正确输入';
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: oldManAgeController,
                                      //添加装饰盒显示图标
                                      decoration: InputDecoration(
                                        fillColor: Color(0x30cccccc),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0x00FF0000)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0x00000000)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        labelText: "年龄:",
                                      ),
                                      validator: (String value) {
                                        return value.length > 0 &&
                                                value.length < 3
                                            ? null
                                            : '只能输入2-16个字符';
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          child: Text("取消"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          child: Text("修改"),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              Navigator.pop(context);
                                              Fluttertoast.showToast(
                                                  msg: "修改成功");
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "修改失败");
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 34, 150, 243)),
                      height: 30,
                      width: 50,
                      child: Text(
                        "修改",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                //删除
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("提示信息!"),
                            content: Text("您确定要删除吗?"),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("取消")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await deleteUser(list[i][0]);
                                    setState(() {
                                      widgets.remove(this);

                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text("确定")),
                            ],
                          );
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 34, 150, 243)),
                      height: 30,
                      width: 50,
                      child: Text(
                        "删除",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                //判断是否上班时间
                Icon(Icons.circle,
                    color: DateTime.now().hour >= int.parse(list[i][4]) &&
                            DateTime.now().hour <= int.parse(list[i][5])
                        ? Colors.green
                        : Colors.red),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ));
      }
    }

    ///排序修改颜色
    for (int i = 0; i < sortList.length; i++) {
      widgets.add(Container(
        color: i % 2 != 0 ? a : b,
        child: sortList[i],
      ));
    }return widgets;
  }

  List<Widget> widgets = List();

  Widget createButtonContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 45,
            child: Center(
              child: Text("监护人"),
            ),
          ),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          //垂直分割线
          Container(
            width: 38,
            child: Center(
              child: Text("性别"),
            ),
          ),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          Container(
            width: 40,
            child: Center(
              child: Text("年龄"),
            ),
          ),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          Container(
            width: 88,
            child: Center(
              child: Text("电话"),
            ),
          ),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          Container(
            width: 90,
            child: Center(
              child: Text("设置"),
            ),
          ),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          Container(
            width: 30,
            child: Center(
              child: Text("值班"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> widgetClear() async {
    if (widgets != null) {
      widgets.clear();
    }
  }


  GlobalKey key = GlobalKey();
  bool offstage = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //添加监护人按钮
            AddMonitor(),
            SizedBox(
              width: 5,
            ),
            //添加老人按钮
            AddOldMan(),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 70,
              child: ElevatedButton(
                onPressed: () async {
                  await showAll();
                  setState(() {

                  });
                },
                child: Text("刷新"),
              ),
            ),
          ],
        ),
        createButtonContainer(),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
          ),
        ),
      ],
    );
  }
}
