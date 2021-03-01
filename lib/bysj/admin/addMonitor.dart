import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*class AddMonitor extends StatefulWidget {
  @override
  _AddMonitorState createState() => _AddMonitorState();
}

class _AddMonitorState extends State<AddMonitor> with Dialog{

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/

class AddMonitor extends Dialog {
  String monitorName;
  String _newValue = "男";
  String _dropValue;
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController usernameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(50.0),
              child: Container(
                width: 400,
                height: 300,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
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
                              if (value.length >= 2 && value.length <= 16) {
                                return null;
                              } else {
                                return '只能输入2-16个字符';
                              }
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Radio<String>(
                                  value: "男",
                                  groupValue: _newValue,
                                  onChanged: (value) {
                                    /*  setState(() {
                                  _newValue = value;
                                });*/
                                  }),
                              Radio<String>(
                                  value: "女",
                                  groupValue: _newValue,
                                  onChanged: (value) {
                                    /*  setState(() {
                                  _newValue = value;
                                });*/
                                  }),
                            ],
                          ),
                          DropdownButton(
                            value: _dropValue,
                            items: [
                              DropdownMenuItem(
                                child: Text('男'),
                                value: '男',
                              ),
                              DropdownMenuItem(child: Text('女'), value: '女'),
                            ],
                            onChanged: (value) {
                              // setState(() {
                              //   _dropValue = value;
                              // });
                            },
                          ), //用户名输入框
                          TextFormField(
                            controller: usernameController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              labelText: "年龄:",
                              icon: Icon(Icons.person),
                            ),
                            onSaved: (value) {
                              monitorName = value;
                            },
                            validator: (String value) {
                              return value == null ? "不能为空" : null;
                            },
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
