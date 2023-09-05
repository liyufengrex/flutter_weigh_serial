abstract class UsbPortConstant {
  /// Constant to configure port with 5 databits.
  static const int dataBits5 = 5;

  /// Constant to configure port with 6 databits.
  static const int dataBit6 = 6;

  /// Constant to configure port with 7 databits.
  static const int dataBit7 = 7;

  /// Constant to configure port with 8 databits.
  static const int dataBit8 = 8;

  /// Constant to configure port with no flow control
  static const int flowControlOff = 0;

  /// Constant to configure port with flow control RTS/CTS
  static const int flowControlRtsCts = 1;

  /// Constant to configure port with flow contorl DSR / DTR
  static const int flowControlDsrDtr = 2;

  /// Constant to configure port with flow control XON XOFF
  static const int flowControlXonXOff = 3;

  /// Constant to configure port with parity none
  static const int parityNone = 0;

  /// Constant to configure port with event parity.
  static const int parityEven = 2;

  /// Constant to configure port with odd parity.
  static const int parityOdd = 1;

  /// Constant to configure port with mark parity.
  static const int parityMark = 3;

  /// Constant to configure port with space parity.
  static const int paritySpace = 4;

  /// Constant to configure port with 1 stop bits
  static const int stopBits1 = 1;

  /// Constant to configure port with 1.5 stop bits
  static const int stopBits1_5 = 3;

  /// Constant to configure port with 2 stop bits
  static const int stopBits2 = 2;
}
