import 'dart:typed_data';

import 'package:serial_port_win32/serial_port_win32.dart';
import '../../device_model/usb_serial_device.dart';
import '../../device_model/platform/windows_usb_device.dart';
import '../usb_serial.dart';

class UsbSerialWindows extends UsbSerial {
  late SerialPort port;

  @override
  Future<bool> close() async {
    port.close();
    return !port.isOpened;
  }

  @override
  Future<void> create(UsbSerialDevice usbSerialDevice) async {
    port = SerialPort(
      usbSerialDevice.connectPort,
      openNow: false,
      ByteSize: dataBits,
      ReadIntervalTimeout: readIntervalTimeout,
      ReadTotalTimeoutConstant: 2,
    );
  }

  @override
  Future<List<UsbSerialDevice>> getAvailablePorts() async {
    final messages = SerialPort.getPortsWithFullMessages();
    return messages
        .where(
          (element) => element.hardwareID.isUsbSerialPort,
        )
        .map(
          (e) => WindowsUsbDevice.fromSerialPort(
            port: e.hardwareID,
            portName: e.portName,
          ),
        )
        .toList();
  }

  @override
  bool isOpen() => port.isOpened;

  @override
  Future<bool> open() async {
    port.openWithSettings(
      BaudRate: baudRate,
      ByteSize: dataBits,
      ReadIntervalTimeout: readIntervalTimeout,
      Parity: parity,
      StopBits: stopBits,
    );
    if (port.isOpened) {
      port.readBytesOnListen(
        16,
        controller.sink.add,
      );
    }
    return port.isOpened;
  }

  @override
  Future<bool> write(Uint8List data) async {
    return port.writeBytesFromUint8List(data);
  }

  @override
  Future<bool> writeString(String data) async {
    return write(Uint8List.fromList(data.codeUnits));
  }
}

extension on String {
  bool get isUsbSerialPort => startsWith(r'USB\');
}
