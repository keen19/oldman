import 'dart:async';
import 'package:sqljocky5/sqljocky.dart';

 main() async {
  // Open a connection (testdb should already exist)
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'rm-wz9zt03rn0864rz8uho.mysql.rds.aliyuncs.com',
      port: 3306,
      user: 'keen',
      password: "Zxc000222",
      db: 'demo1'));

  List list = List();

  Map<String,List>map =Map();
  ///查询所有信息
  Future<void> showAll() async {
   for (int i = 0; i < list.length; i++) {
    print(list);
    list.removeAt(i);
   }
   Results result =
   await (await conn.execute("select username,address,guardian from user"))
       .deStream();
   result.forEach((element) {
    list.add(element);
    print(element);
   });
   for(int i=0;i<list.length;i++){
    map['${list[i][0]}']=list[i];
   }
   print(map);
   //createListView();
  }
  showAll();
  // print(results);
/*   Results result = await (await conn.execute(
       "select username,password from user where username = 'nihao'"))
       .deStream();
   result.forEach((element) {print(element);});*/
   /*Future<bool> selectAdmin(String admin, String password) async {
     var results =
     await conn.execute("select * from adminInfo where admin_user = '$admin'");
     results.forEach((element) {
       if (element[0] == admin && element[1] == password) {
          return true;
       }
     });
      return false;
   }

   Future<bool> demo() async{
     return true;
   }
   demo().then((value) => (){});
   print(selectAdmin('张三', '123456'));*/
  await conn.close();
}
/*class User{
  String username;
  String password;

  User(this.username,this.password);

  @override
  String toString() {
    // TODO: implement toString
    return "User{"+
   "username='"+username+"\'"+",password='"+password+"\'"+"}";
  }
}*/
/*void main() {
 var a =new LoginVerify();
 a.selectAll();
}

void main() => runApp(MyApp());*/
/*
class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   title: 'Material App',
   home: Scaffold(
    appBar: AppBar(
     title: Text('Material App Bar'),
    ),
    body: Center(
     child: Container(
      child: Text(LoginVerify().selectAll()),
     ),
    ),
   ),
  );
 }
}

class LoginVerify  {
  MySqlConnection conn;
  LoginVerify(){
   init();
  }
  init() async {

  }
   selectAll (){
   var results = conn.query("select * from user");
   return results;
  }

}*/




