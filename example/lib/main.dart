import 'package:flutter/material.dart';
import 'package:sbp_pay/sbp_pay.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Только ссылки такого формата позволяют открыть модалку, иначе падает исключение
  static const _paymentLink =
      'https://qr.nspk.ru/AS100001ORTF4GAF80KPJ53K186D9A3G?type=01&bank=100000000007&crc=0C8A';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await SbpPay.init()) {
                    await SbpPay.showPaymentModal(_paymentLink);
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Not supported')),
                    );
                  }
                },
                child: const Text('Running on'),
              ),
            );
          }
        ),
      ),
    );
  }
}
