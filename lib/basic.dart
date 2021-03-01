import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
import 'package:flutter_bmfutils/BaiduMap/utils/bmf_utils_calculate.dart';
import 'package:flutter_bmfmap/BaiduMap/map/bmf_map_controller.dart';
import 'package:flutter_bmfmap/BaiduMap/map/bmf_map_view.dart';
import 'package:flutter_bmfmap/BaiduMap/models/bmf_map_options.dart';
import 'package:flutter_bmfmap/BaiduMap/models/bmf_userlocation.dart';

import 'bysj/monitor.dart';

class BasicMap extends StatefulWidget {
  double longitude, latitude;

  BasicMap(this.latitude, this.longitude);

  @override
  BasicMapState createState() => BasicMapState(latitude, longitude);
}

class BasicMapState extends State<BasicMap> {
  double latitude, longitude;

  BasicMapState(this.latitude, this.longitude);

  /// 我的位置
  BMFUserLocation _userLocation;

  //double latitude=LocDemo().createState().locationResult[latitude],longitude=LocDemo().createState().baiduLocation.longitude;
  /// 定位点样式
  BMFUserlocationDisplayParam _displayParam;

  Size screenSize;
  BMFMapOptions mapOptions;
  BMFMapController myMapController;

  ///初始化地图
  @override
  void initState() {
    super.initState();

    mapOptions = BMFMapOptions(
        center: BMFCoordinate(latitude, longitude),
        zoomLevel: 18,
        mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0));
  }

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 地图加载回调
    myMapController?.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
    });

    ///展示图层
    myMapController?.showUserLocation(true);
  }

  /// 更新位置
  void updateUserLocation() {
    BMFCoordinate coordinate = BMFCoordinate(latitude, longitude);
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);
    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    _userLocation = userLocation;
    myMapController?.updateLocationData(_userLocation);
  }

  /// 更新定位图层样式
  void updateUserLocationDisplayParam() {
    BMFUserlocationDisplayParam displayParam = BMFUserlocationDisplayParam(
        locationViewOffsetX: 0,
        locationViewOffsetY: 0,
        accuracyCircleFillColor: Colors.red,
        accuracyCircleStrokeColor: Colors.blue,
        isAccuracyCircleShow: true,
        locationViewImage: 'Resources/animation_red.png',
        locationViewHierarchy:
            BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);

    _displayParam = displayParam;
    myMapController?.updateLocationViewWithParam(_displayParam);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("aaa"),
      ),
      body: Container(
        height: 500.0,
        width: 500.0,
        child: BMFMapWidget(
          onBMFMapCreated: (controller) {
            onBMFMapCreated(controller);
            updateUserLocation();
            updateUserLocationDisplayParam();
          },
          mapOptions: mapOptions,
        ),
      ),
    );
  }
}
