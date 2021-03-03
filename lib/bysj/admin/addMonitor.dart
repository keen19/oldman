import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/ConnectionDB.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
class AddMonitor extends StatefulWidget {
  @override
  _AddMonitorState createState() => _AddMonitorState();
}

class _AddMonitorState extends State<AddMonitor> with ConnectionDb {
  @override
  initState(){
    super.initState();
    getConnection();
  }

  GlobalKey<FormState> addMonitorKey = GlobalKey();

  TextEditingController addMonitorNameController = new TextEditingController();
  TextEditingController addMonitorAgeController = new TextEditingController();
  TextEditingController addMonitorSexController = new TextEditingController();

  Future<void> addMonitor(
      String monitorName, String monitorSex, String monitorAge) async {
    String sql = "insert into monitor (monitor_name,sex,age) values (?,?,?)";
    List<StreamedResults> results = await (await conn.preparedWithAll(sql, [
      ['$monitorName', '$monitorSex', '$monitorAge']
    ]))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('添加监护人'),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Container(
                  height: 400,
                  child: Form(
                    key: addMonitorKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        //用户名输入框
                        TextFormField(
                          controller: addMonitorNameController,
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
                          controller: addMonitorSexController,
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
                            labelText: "性别:",
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
                          controller: addMonitorAgeController,
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
                            return value.length > 0 && value.length < 3
                                ? null
                                : '只能输入0-99';
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text("取消"),
                              onPressed: () {
                                //清空表单
                                addMonitorKey.currentState.reset();
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              child: Text("添加"),
                              onPressed: () {
                                if (addMonitorKey.currentState.validate()) {
                                  addMonitor(
                                      addMonitorNameController.text,
                                      addMonitorSexController.text,
                                      addMonitorAgeController.text);
                                  //清空表单
                                  addMonitorKey.currentState.reset();
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(msg: "添加成功");
                                } else {
                                  Fluttertoast.showToast(msg: "添加失败");
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
    );
  }
}
