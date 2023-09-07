import 'package:flutter_weigh_serial/src/device_model/usb_serial_device_ex.dart';
import 'package:flutter_weigh_serial/src/extension/usb_serial_ex.dart';
import 'package:dartx/dartx.dart';
import '../flutter_weigh_serial.dart';

/// 称重功能提供者
class WeighSerialProvider {
  late final UsbSerialFactory serialFactory;

  WeighSerialProvider() {
    serialFactory = UsbSerialFactory();
  }

  // 第一步，初始化, 并连接称重设备
  Future<bool> findAndConnect() async {
    if (isConnect) {
      return Future(() => true);
    }
    final devices = await serialFactory.usbSerial.getAvailablePorts();
    final weighDevice = devices.firstOrNullWhere(
      (element) => element.isWeighDevice,
    );
    if (weighDevice == null) {
      throw Exception('无可用称重设备');
    }
    await serialFactory.usbSerial.create(weighDevice);
    return await serialFactory.usbSerial.open();
  }

  // 第二步， 初始化成功后，监听称重结果
  Stream<WeighResult>? get weighListener {
    return serialFactory.usbSerial.weighResultStream;
  }

  // 最后一步， 关闭
  Future<bool> close() {
    return serialFactory.usbSerial.close();
  }

  // 获取称重设备是否已连接
  bool get isConnect {
    try {
      return serialFactory.usbSerial.isOpen();
    } catch (e) {
      return false;
    }
  }

  // 获取匹配上的设备
  UsbSerialDevice? get selectedDevice => serialFactory.usbSerial.selectedDevice;
}
