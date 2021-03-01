import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;

import 'dart:io' show Platform;
import '../demo/GetLocationInfo.dart';
import '../basic.dart';

void main() {
  runApp(MyApp());
}

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
            child: LocDemo(),
          ),
        ),
      ),
    );
  }
}

class LocDemo extends StatefulWidget {
  @override
  LocDemoState createState() => LocDemoState();
}

class LocDemoState extends State<LocDemo> with AutomaticKeepAliveClientMixin {
  ///监控地址控制器
  static final TextEditingController monitorAddress = TextEditingController();

  Map<String, Object> locationResult;

  bool flag = false;

  GlobalKey buttonKey = GlobalKey();
  /// 定位结果
  BaiduLocation baiduLocation;

  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();

  ///定位监听器
  StreamSubscription<Map<String, Object>> _locationListener;

  @override
  void initState() {
    super.initState();

    _locationPlugin.requestPermission();
    _locationListener =
        _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        locationResult = result;
        try {
          baiduLocation =
              BaiduLocation.fromMap(result);
          //print(baiduLocation);// 将原生端返回的定位结果信息存储在定位结果类中
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_locationListener != null) {
      _locationListener.cancel();
    }
  }

  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(false); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();

    ///配置Android端和iOS端定位参数
    _locationPlugin.prepareLoc(androidMap, iosMap);
  }

  void _startLocation() {
    if (_locationPlugin != null) {
      _setLocOption();
      _locationPlugin.startLocation();
    }
  }

  void _stopLocation() {
    if (_locationPlugin != null) {
      _locationPlugin.stopLocation();
    }
  }

  openMonitoring(){

  }

  Container _createButtonContainer() {
    return new Container(
        alignment: Alignment.center,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: (){
                _startLocation();
              },
              child: new Text('开始定位'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            new Container(width: 20.0),
            new RaisedButton(
              key: buttonKey,
              onPressed: baiduLocation == null ? null : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BasicMap(baiduLocation?.latitude,baiduLocation?.longitude
                        )));
              },
              child: new Text('查看地图'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            Switch(
                value: flag,
                activeColor: Colors.red,
                onChanged: (value) {
                  //baiduLocation?.latitude;
                  setState(() {
                    this.flag = value;
                  });
                }),
            Text(
              "开启监控",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }

  // ignore: missing_return
  Widget _resultWidget(key, value) {
    return new Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('$key:' ' $value'),
            ]),
      ),
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List<Widget> widgets = new List();

    if (locationResult != null) {
      locationResult.forEach((key, value) {
        if (key == 'latitude' || key == 'address' || key == 'longitude') {
        widgets.add(_resultWidget(key, value));
        }
        //widgets.add(_resultWidget(key, value));
      });
    }

    widgets.add(_createButtonContainer());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
