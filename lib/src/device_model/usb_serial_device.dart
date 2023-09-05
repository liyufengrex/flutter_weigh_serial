// usb 设备模型积累
abstract class UsbSerialDevice {
  int? pId;
  int? vId;

  UsbSerialDevice({this.pId, this.vId});

  // 获取用于连接的端口号
  String get connectPort;

  // 所属平台
  PlatForm get platform;
}

enum PlatForm {
  android,
  windows,
}
