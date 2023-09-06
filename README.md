# flutter_weigh_serial
*flutter package*

提供获取电子秤数据能力，支持 Android、Windows 平台。

###### 注意：改库只支持串口方式连接（包括usb转串口）的称重设备。

### 使用方式

+ 添加依赖
```dart
dependencies:
  flutter_weigh_serial: ^1.0.0+1
```
+ api 调用方式
```dart
import 'package:flutter_weigh_serial/flutter_weigh_serial.dart';

class _MyAppState extends State<MyApp> {

  late WeighSerialProvider weighSerialProvider;
  
  @override
    void initState() {
      super.initState();
      weighSerialProvider = WeighSerialProvider();
    }

  @override
    void dispose() {
      weighSerialProvider.close();  //退出页面时断开连接
      super.dispose();
    }

  ...
  // 连接称重设备的方法如下：
  void _connectWeigh() {
    weighSerialProvider.findAndConnect().then(
      (success) {
        if (success) {
          //搜索到称重设备并连接成功
          weighSerialProvider.weighListener?.listen(
            (data) {
              // 获取到称重数据，返回数据模型 *WeighResult*
              log('称重数据 - ${data.toMap().toString()}');
            },
          );
        } else {
          Fluttertoast.showToast(msg: '称重设备连接失败');
        }
      },
      onError: (e) {
        Fluttertoast.showToast(msg: '称重设备连接失败（${e.toString()}）');
      },
    );
  }
}
```
+ 称重返回的模型数据 **WeighResult** 结构如下：
```dart
class WeighResult {
  /// 重量  单位是kg
  final double weight;

  /// 结果是否稳定  稳定：true  不稳定： false
  final bool isStable;
}
```
### 扩展
本库支持 vId、pId 如下组合的称重设备：
```dart
// vId - pId
static Map<int, List<int>> weighDeviceList = {
    1027: [
      24577,
      24592,
      24593,
      24596,
      24597,
    ],
    4292: [
      60000,
      60016,
      60017,
    ],
    1659: [
      8963,
      9123,
      9139,
      9155,
      9171,
      9187,
      9203,
    ],
    6790: [
      21795,
      29987,
      21972,
    ],
    9025: [],
    5824: [1155],
    1003: [8260],
    7855: [4],
    3368: [516],
    1155: [22336],
    11914: [
      5,
      10,
    ],
  };
```
可通过如下方式自行扩展支持的组合：
```dart
//示例，扩展 vId 为 1111， pId 为 1234,1235 的称重设备
WeighSerialConfig.weighDeviceList[1111] = [1234,1235];
```
##### 具体使用可参考 example 示例
![demo](https://github.com/liyufengrex/flutter_weigh_serial/blob/main/demo_weigh.gif)
