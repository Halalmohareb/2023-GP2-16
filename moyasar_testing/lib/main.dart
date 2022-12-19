import 'package:flutter/material.dart';
import 'package:moyasar_payment/model/paymodel.dart';
import 'package:moyasar_payment/model/source/creditcardmodel.dart';
import 'package:moyasar_payment/model/source/stcpaymodel.dart';
import 'package:moyasar_payment/moyasar_payment.dart';
import 'package:moyasar_testing/verify.dart';

void main() => runApp(
      MaterialApp(
        title: "App",
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  byCard() async {
    PayModel res = await MoyasarPayment().creditCard(
      description: 'I am description',
      amount: 50.0, // 50 SAR
      publishableKey: 'pk_test_J5DLZVGe579PKmeXYK5v4rdBFK5YQwusMFFtyMiD',
      cardHolderName: 'Hala mohareb',
      cardNumber: '5555555555554444',
      cvv: 123,
      expiryManth: 12,
      expiryYear: 24,
      callbackUrl: 'https://google.com',
    );
    if (res.type != null) {
      print(res.message);
    } else {
      CreditcardModel creditcardModel = CreditcardModel.fromJson(res.source);
      print(creditcardModel.toJson());
      var temp = creditcardModel.toJson();
      print(temp['transaction_url']);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VerifyPage(
            url: creditcardModel.transactionUrl,
          ),
        ),
      );
      print('-=-=- =-=- =-=-=-= -=-=-= -= ');
      print(res.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                byCard();
              },
              color: Colors.blue,
              child: Text('Pay Credit Card'),
            ),
          ],
        ),
      ),
    );
  }
}
