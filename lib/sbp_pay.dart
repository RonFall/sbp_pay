import 'package:flutter/services.dart';

class SbpPay {
  static const MethodChannel _channel = MethodChannel('sbp_pay');

  static bool _wasInitialized = false;

  /// Флаг доступности [SbpPay] на данном устройстве.
  ///
  /// Доступен только после успешного [init], иначе ошибка.
  static bool get isAvailable => _isAvailable;
  static late bool _isAvailable;

  /// Инициализация плагина SbpPay.
  ///
  /// Возвращает false, если сервис не поддерживается устройством.
  static Future<bool> init() async {
    if (!_wasInitialized) {
      _isAvailable = await _channel
          .invokeMethod<bool?>('init')
          .then((value) => value ?? false);

      _wasInitialized = true;
      return _isAvailable;
    }

    return _isAvailable;
  }

  /// Вызов нативного окна SbpPay выбора банков.
  static Future<void> showPaymentModal(String link) {
    return _channel.invokeMethod('showPaymentModal', link);
  }
}
