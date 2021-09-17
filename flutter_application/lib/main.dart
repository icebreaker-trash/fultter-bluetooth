import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome to Flutter',
      home: ThermometryGunListPages()
    );
  }
}

class ThermometryGunListPages extends StatefulWidget {
  const ThermometryGunListPages({Key? key}) : super(key: key);

  @override
  _ThermometryGunListPagesState createState() =>
      _ThermometryGunListPagesState();
}

class _ThermometryGunListPagesState extends State<ThermometryGunListPages> {
  List nearbyBleList = []; // 主要用于判断附近设备是否搜索到
  bool showNearbyThermonetryList = false; // 显示附近蓝牙列表
  List myBleList = []; // 我的蓝牙设备列表

  // 这是创建widget时调用的除构造方法外的第一个方法
  @override
  void initState() {
    print('---initState---');
    super.initState();
    // getMyBleList();
  }

  // 组件被销毁时调用：
  @override
  void dispose() {
    print('-----dispose-----');
    super.dispose();
    nearbyBleList = [];
  }

//
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("测温枪列表"),
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.popAndPushNamed(context, '/');
                  },
                  child: Row(children: const <Widget>[
                    Icon(Icons.arrow_back_ios),
                    // Text("返回", style: TextStyle(fontSize: 16),)
                  ])),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: StreamBuilder<BluetoothState>(
                stream: FlutterBlue.instance.state,
                initialData: BluetoothState.unknown,
                builder: (c, snapshot) {
                  if (snapshot.hasError) return Container(child: null);
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    // return Text('没有Stream');
                    case ConnectionState.waiting:
                    // return Text('等待数据...');
                    case ConnectionState.active:
                      final state = snapshot.data;
                      print('--------1111111111111111----------');
                      print(state);
                      print('--------1111111111111111----------');
                      return page(state);
                    case ConnectionState.done:
                      return Text('Stream已关闭');
                  }
                })));
  }

  Widget page(state) {
    return MaterialApp(
        home: Container(
            child: SingleChildScrollView(
                child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          myThermonetryList(),
                          showNearbyThermonetryList
                              ? nearbyThermonetryList()
                              : Container(child: null),
                          bottomPage(state)
                        ],
                      ),
                    )))));
  }

  myThermonetryList() {
    return Container(
      child: Column(
        children: <Widget>[
          listTitlePage('我的测温枪'),
        ],
      ),
    );
  }

  nearbyThermonetryList() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          listTitlePage('附近的测温枪'),
          StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: const [],
              builder: (c, snapshot) {
                print('列表的StreamBuilder');
                print(snapshot.connectionState);
                print('列表的StreamBuilder');
                if (snapshot.hasError) return Container(child: null);
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  // return Text('没有数据', textAlign: TextAlign.center,);
                  case ConnectionState.waiting:
                  // return Text('正在加载...', textAlign: TextAlign.center,);
                  case ConnectionState.active:
                    return Column(
                      children: snapshot.data!.map(
                        (r) {
                          return listWidget(r);
                        },
                      ).toList(),
                    );
                  case ConnectionState.done:
                    return Text('Stream已关闭');
                }
              }),
        ],
      ),
    );
  }

  listTitlePage(String title) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Color(0xBCE0FD).withOpacity(.8),
            ),
            child: Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => {}, //点击
                  child: Text(title.toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                )),
          ),
        )
      ],
    ));
  }

  Widget listWidget(item) {
    // print(item);
    // print('------------------------');
    BluetoothDevice device = item.device;
    // print(device.name); // 蓝牙设备名
    // print(device.id); // MAX地址
    // print(item.rssi); // 信号值
    if (device.name.toLowerCase().contains('bf') ||
        device.name.toLowerCase().contains('zf')) {
      // if (this.nearbyBleList.length > 0) {
      //   this.nearbyBleList.forEach((nearbyItem) {
      //   BluetoothDevice nearbyDevice = nearbyItem.device;
      //     if (nearbyDevice.id != device.id) {
      //       this.nearbyBleList.add(item);
      //     }
      //   });
      // } else {
      //   this.nearbyBleList.add(item);
      // }

      return Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      handleRow(item);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Color(0xBCE0FD).withOpacity(.3),
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.blue))),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.blue[200],
                              // ),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(device.id.toString(),
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                    Text(device.name.toString(),
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 14)),
                                    Text(item.rssi.toString(),
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 14))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: Colors.green,
                              // ),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        //  decoration: BoxDecoration(
                                        //     color: Colors.red,
                                        //   ),
                                        child: Text('去连接',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        //  decoration: BoxDecoration(
                                        //     color: Colors.pink,
                                        //   ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.blue,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )))
          ],
        ),
      );
    } else {
      return Container(
        child: null,
      );
    }
  }

  bottomPage(state) {
    return Container(
      margin: EdgeInsets.only(top: 160, bottom: 20),
      // decoration: BoxDecoration(
      //   color:  Colors.red,
      // ),
      child: Row(
          children: <Widget>[publicFlatButton(state)],
          mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  publicFlatButton(state) {
    return Container(
      child: Expanded(
        child: FlatButton(
          color: Colors.blue, // 设置按钮背景颜色
          // disabledTextColor: Colors.grey, //按钮禁用时的文字颜色
          disabledColor: Colors.grey, //按钮禁用时的背景颜色
          highlightColor: Colors.blue, //按钮按下时的背景颜色
          colorBrightness: Brightness.dark, //按钮主题，默认是浅色主题
          splashColor: Colors.grey, // 设置溅墨效果的颜色
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15), // 按钮的填充
          child: Text('搜索附近测温枪', style: TextStyle(fontSize: 15)), // 按钮的内容
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), // 外形
          onPressed: () async {
            //off关闭 | on开启
            // print(state.toString().substring(15));
            if (state.toString().substring(15) == 'on') {
              print('搜索附近测温枪');
              try {
                setState(() {
                  showNearbyThermonetryList = true;
                });

                // this.nearbyBleList = [];

                FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));

                await Future.delayed(Duration(seconds: 3));
              } catch (e) {
                print('搜索异常');
                print(e);
              }
            } else {
              print('请打开蓝牙');
            }
          },
        ),
      ),
    );
  }

  handleRow(item) async {
    BluetoothDevice device = item.device;
    FlutterBlue.instance.stopScan();

    print('--正在连接--');
    print(device.id); // 蓝牙设备名
    try {
      await device.connect(); // 连接蓝牙设备
    } on Exception catch (e) {
      EasyLoading.dismiss();
      print('连接异常');
      print(e);
      return false;
    }

    print('连接完成');

    // 设置我的蓝牙列表缓存
    // setMyBleList(item);

    //获取蓝牙设备服务
    List<BluetoothService> services = await device.discoverServices();
    BluetoothService serviceObj;
    //遍历蓝牙设备对列表
    for (var service in services) {
      // 判断服务id
      if (service.uuid.toString().toLowerCase().contains('000018f0') ||
          service.uuid.toString().toLowerCase().contains('0000fee9')) {
        serviceObj = service;
      }
    }

    // __belCharacteristics(device, serviceObj);
  }

  setNotifyValue(device, characteristics) async {
    print('----正在开启订阅---');
    // 开启订阅
    await characteristics.setNotifyValue(true);
    print('----开启订阅成功---');
    // 订阅回调
    characteristics.value.listen((List<int> value) {
      print('----监听到返回的数据----');
      print(value); // [255, 1, 95, 94] // 返回10进制
      // 循环然后xxx.toRadixString(16); 转成16进制
    });
  }

  __belCharacteristics(device, serviceObj) async {
    // 获取蓝牙设备的特征值
    var characteristics = serviceObj.characteristics;
    for (var item in characteristics) {
      // 开启读
      // List<int> value = await item.read();
      // print(value);

      print('-------item---------');
      print(item);
      print(item.properties);
      print(item.properties.notify);

      if (item.properties.notify) {
        setNotifyValue(device, item);
      }
    }
  }
}
