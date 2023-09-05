import '../usb_serial_device.dart';

/// android usb 设备模型
class AndroidUsbDevice extends UsbSerialDevice {
  final int? deviceId;

  AndroidUsbDevice({
    int? pid,
    int? vid,
    this.deviceId,
  }) : super(
          pId: pid,
          vId: vid,
        );

  @override
  String get connectPort => deviceId.toString();

  @override
  PlatForm get platform => PlatForm.android;
}
