import 'dart:async';
import 'dart:typed_data';

import '../constant/usb_port_constant.dart';
import '../constant/weigh_serial_config.dart';
import '../device_model/usb_serial_device.dart';

/// usb 串口通信
abstract class UsbSerial {
  /// 固定的比特率
  int baudRate = WeighSerialConfig.baudRate;
  int dataBits = UsbPortConstant.dataBit8;
  int stopBits = UsbPortConstant.stopBits1;
  int parity = UsbPortConstant.parityNone;
  int readIntervalTimeout = 10;

  final controller = StreamController<Uint8List>.broadcast();

  /// 用于监听输出流
  Stream<Uint8List> get readStream => controller.stream;

  Future<void> create(UsbSerialDevice usbSerialDevice);

  /// 打开串口
  Future<bool> open();

  /// 关闭串口
  Future<bool> close();

  /// 写入字节列表
  Future<bool> write(Uint8List data);

  ///写入字符串
  Future<bool> writeString(String data);

  ///串口状态
  bool isOpen();

  ///获取可用设备
  Future<List<UsbSerialDevice>> getAvailablePorts();
}
