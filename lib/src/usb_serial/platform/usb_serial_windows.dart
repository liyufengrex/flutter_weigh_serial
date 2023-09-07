import 'dart:typed_data';

import 'package:serial_port_win32/serial_port_win32.dart';
import '../../device_model/usb_serial_device.dart';
import '../../device_model/platform/windows_usb_device.dart';
import '../usb_serial.dart';

class UsbSerialWindows extends UsbSerial {
  SerialPort? _port;

  @override
  Future<bool> close() async {
    if (_port == null) {
      selectedDevice = null;
      return Future(() => true);
    }
    _port!.close();
    final success = !(_port!.isOpened);
    if (success) {
      _port = null;
      selectedDevice = null;
    }
    return success;
  }

  @override
  Future<void> create(UsbSerialDevice usbSerialDevice) async {
    await close();
    _port = SerialPort(
      usbSerialDevice.connectPort,
      openNow: false,
      ByteSize: dataBits,
      ReadIntervalTimeout: readIntervalTimeout,
      ReadTotalTimeoutConstant: 2,
    );
    selectedDevice = usbSerialDevice;
  }

  @override
  bool isOpen() => _port == null ? false : _port!.isOpened;

  @override
  Future<bool> open() async {
    if (_port == null) {
      throw Future.error('Windows Serial Port is Null');
    }
    _port!.openWithSettings(
      BaudRate: baudRate,
      ByteSize: dataBits,
      ReadIntervalTimeout: readIntervalTimeout,
      Parity: parity,
      StopBits: stopBits,
    );
    if (_port!.isOpened) {
      _port!.readBytesOnListen(
        16,
        controller.sink.add,
      );
    }
    return _port!.isOpened;
  }

  @override
  Future<bool> write(Uint8List data) async {
    if (_port == null) {
      return Future(() => false);
    }
    return _port!.writeBytesFromUint8List(data);
  }

  @override
  Future<bool> writeString(String data) async {
    return write(Uint8List.fromList(data.codeUnits));
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
}

extension on String {
  bool get isUsbSerialPort => startsWith(r'USB\');
}
