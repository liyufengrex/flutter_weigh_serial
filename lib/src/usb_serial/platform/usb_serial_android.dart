import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart' as usb_serial_lib;
import '../../device_model/platform/android_usb_device.dart';
import '../../device_model/usb_serial_device.dart';
import '../usb_serial.dart';

class UsbSerialAndroid extends UsbSerial {
  usb_serial_lib.UsbPort? _port;
  bool _isOpened = false;

  @override
  Future<bool> close() async {
    if (_port == null) {
      return true;
    }
    final result = await _port!.close();
    if (result) {
      _port = null;
    }
    _isOpened = !result;
    return result;
  }

  @override
  Future<void> create(UsbSerialDevice usbSerialDevice) async {
    await close();
    _port = await usb_serial_lib.UsbSerial.createFromDeviceId(
      int.parse(usbSerialDevice.connectPort),
    );
  }

  @override
  Future<List<UsbSerialDevice>> getAvailablePorts() async {
    final list = await usb_serial_lib.UsbSerial.listDevices();
    return list
        .map(
          (e) => AndroidUsbDevice(
            pid: e.pid,
            vid: e.vid,
            deviceId: e.deviceId,
          ),
        )
        .toList();
  }

  @override
  bool isOpen() => _isOpened;

  @override
  Future<bool> open() async {
    if (_port == null) {
      throw Future.error('Android Serial Port is Null');
    }
    _isOpened = await _port!.open();
    if (_isOpened) {
      _port!.setDTR(true);
      _port!.setRTS(true);
      _port!.setPortParameters(
        baudRate,
        dataBits,
        stopBits,
        parity,
      );
      _port!.inputStream?.listen(
        (data) {
          controller.sink.add(data);
        },
      );
    }
    return _isOpened;
  }

  @override
  Future<bool> write(Uint8List data) {
    if (_port == null) {
      return Future(() => false);
    }
    _port!.write(data);
    return Future(() => true);
  }

  @override
  Future<bool> writeString(String data) {
    return write(
      Uint8List.fromList(data.codeUnits),
    );
  }
}
