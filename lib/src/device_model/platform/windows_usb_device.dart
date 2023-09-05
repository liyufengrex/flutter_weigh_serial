import '../usb_serial_device.dart';

/// window usb 设备模型
class WindowsUsbDevice extends UsbSerialDevice {
  final String windowsSerialPort;
  final String portName;

  WindowsUsbDevice({
    required int pid,
    required int vid,
    required this.windowsSerialPort,
    required this.portName,
  }) : super(
          pId: pid,
          vId: vid,
        );

  factory WindowsUsbDevice.fromSerialPort({
    required String port,
    required String portName,
  }) {
    // USB\VID_1A86&PID_7523&REV_0264
    final resultPort = port.replaceAll(r'USB\', '');
    final list = resultPort.split('&');
    final vidStr = list
        .firstWhere(
          (element) => element.startsWith('VID_'),
          orElse: () => '',
        )
        .replaceAll(
          'VID_',
          '',
        );
    final pidStr = list
        .firstWhere(
          (element) => element.startsWith('PID_'),
          orElse: () => '',
        )
        .replaceAll(
          'PID_',
          '',
        );
    final vid = int.tryParse(vidStr, radix: 16);
    final pid = int.tryParse(pidStr, radix: 16);
    return WindowsUsbDevice(
      pid: pid ?? 0,
      vid: vid ?? 0,
      windowsSerialPort: port,
      portName: portName,
    );
  }

  @override
  String get connectPort => portName;

  @override
  PlatForm get platform => PlatForm.windows;
}
