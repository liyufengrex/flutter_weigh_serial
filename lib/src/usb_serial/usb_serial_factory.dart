import 'dart:io';

import 'package:flutter/services.dart';

import 'platform/usb_serial_android.dart';
import 'platform/usb_serial_windows.dart';
import 'usb_serial.dart';

abstract class BaseUsbSerialFactory {
  UsbSerial get usbSerial;
}

///自动识别平台
class UsbSerialFactory extends BaseUsbSerialFactory {
  UsbSerial? _usbSerial;

  @override
  UsbSerial get usbSerial {
    if (Platform.isAndroid) {
      return _usbSerial ??= UsbSerialAndroid();
    } else if (Platform.isWindows) {
      return _usbSerial ??= UsbSerialWindows();
    } else {
      throw PlatformException(code: "-1", message: "暂不支持该平台");
    }
  }
}

///windows平台
class UsbSerialWindowsFactory extends BaseUsbSerialFactory {
  UsbSerial? _usbSerial;

  @override
  UsbSerial get usbSerial => _usbSerial ??= UsbSerialAndroid();
}

///android平台
class UsbSerialAndroidFactory extends BaseUsbSerialFactory {
  UsbSerial? _usbSerial;

  @override
  UsbSerial get usbSerial => _usbSerial ??= UsbSerialWindows();
}
