import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'showAll.dart' as s;
import '../database/ConnectionDB.dart';

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
            body: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 200.0,
                  ),
                  Center(
                    child: ABC(),
                  ),
                ],
              ),
            )));
  }
}

class ABC extends StatefulWidget {
  @override
  _ABCState createState() => _ABCState();
}

class _ABCState extends State<ABC> with ConnectionDb{
  String monitorName;
  GlobalKey<FormState> _formKey=GlobalKey();

  TextEditingController usernameController = new TextEditingController();

  MySqlConnection conn;
  List list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }
  selectMonitor(String monitorName)async{
    String selectSql = "select monitor_name from monitor where monitor_name = '$monitorName'";
    Results result = await(await conn.execute(selectSql)).deStream();
    if(result != null){
      print("hahaahah");
      print(result);
    }
    Form.of(context).validate();

    result.forEach((element) {
      print(element);
      list.add(element);
    });
}
  Future<void> registerMonitor(String monitorName) async{


    if(list.length == 0 ){
      String sql = "insert into monitor (monitor_name) values (?)";
      List<StreamedResults> results=
      await(await conn.preparedWithAll(sql, [['$monitorName']])).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text('添加一个监护人'),
          onPressed: () {
            showDialog<void>(
              context: context,
              // false = user must tap button, true = tap outside dialog
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('title'),
                  content: Text('dialogBody'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('buttonText'),
                      onPressed: () {
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                );
              },
            );
            /*Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => a.MyApp()));*/
          },
        ),
        ElevatedButton(
          child: Text('添加一个老人'),
          onPressed: () {},
        ),
        ElevatedButton(
          child: Text('查看所有人'),
          onPressed: () {
            try {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => s.MyApp()));
            } catch (e) {
              print(e);
            }
          },
        ),
        Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //用户名输入框
                  TextFormField(
                    controller: usernameController,
                    //添加装饰盒显示图标
                    decoration: InputDecoration(
                      hintText: "必须输入2-16个字符",
                      labelText: "用户名:",
                      icon: Icon(Icons.person),
                    ),
                    onSaved: (value) {
                      monitorName = value;
                    },
                    validator: (String value) {
                      if(value.length >= 2 && value.length <= 16){
                        if(list.length>0){
                          return "该用户已存在";
                        }
                        return null;
                      }else{
                        return '只能输入2-16个字符';
                      }
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            selectMonitor(usernameController.text);
                           if (_formKey.currentState.validate()) {
                             registerMonitor(
                                 usernameController.text);
                              _formKey.currentState.save();
                              Fluttertoast.showToast(msg: '添加成功');
                            }
                          },
                          child: Text("添加"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
