import 'package:flutter_weigh_serial/src/constant/weigh_serial_config.dart';

import 'usb_serial_device.dart';

extension UsbSerialDeviceExt on UsbSerialDevice {
  bool isFilter(
    int vid,
    int pid,
  ) {
    final products = WeighSerialConfig.weighDeviceList[vid];
    if (products == null) return false;
    if (products.isEmpty) return true;
    return products.contains(pid);
  }

  //校验是否在称重设备白名单
  bool get isWeighDevice {
    if (vId == null) return false;
    return isFilter(vId!, pId ?? 0);
  }
}
