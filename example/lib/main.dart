import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_weigh_serial/flutter_weigh_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late WeighSerialProvider weighSerialProvider;
  StreamSubscription<WeighResult>? _subscription;

  String weighData = '';

  @override
  void initState() {
    super.initState();
    weighSerialProvider = WeighSerialProvider();
  }

  @override
  void dispose() {
    _closeWeigh();
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _closeWeigh() {
    return weighSerialProvider.close();
  }

  void _connectWeigh() {
    weighSerialProvider.findAndConnect().then(
      (success) {
        if (success) {
          Fluttertoast.showToast(msg: '称重设备连接成功');
          _subscription = weighSerialProvider.weighListener?.listen(
            (data) {
              log('称重数据 - ${data.toMap().toString()}');
              setState(() {
                weighData =
                    '${data.weight} kg (${data.isStable ? '稳定' : '不稳定'})';
              });
            },
          );
        } else {
          Fluttertoast.showToast(msg: '称重设备连接失败');
        }
      },
      onError: (e) {
        Fluttertoast.showToast(msg: '称重设备连接失败（${e.toString()}）');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('称重demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              weighSerialProvider.isConnect
                  ? Text('已连接 - 称重数据: $weighData')
                  : const Text('未连接'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: _connectWeigh,
                child: const Text('连接称重'),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () async {
                  await _closeWeigh();
                  setState(() {});
                },
                child: const Text('停止称重'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
