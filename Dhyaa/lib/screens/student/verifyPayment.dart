import 'package:Dhyaa/globalWidgets/toast.dart';
import 'package:Dhyaa/models/appointment.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/theme/loader.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VerifyPayment extends StatefulWidget {
  final Appointment appointmentData;
  final dynamic url;
  const VerifyPayment(
      {super.key, required this.url, required this.appointmentData});

  @override
  State<VerifyPayment> createState() => _VerifyPaymentState();
}

class _VerifyPaymentState extends State<VerifyPayment> {
  doBook(id) {
    widget.appointmentData.paymentId = id;
    FirestoreHelper.bookAppointment(widget.appointmentData).then((value) {
      showToast('تم حجز الموعد بنجاح');
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'الدفع قيد المعالجة',
          style: TextStyle(
            color: theme.mainColor,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            margin: EdgeInsets.only(right: 20),
            child: Image.asset('assets/icons/DhyaaLogo.png', height: 40),
          ),
        ],
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {
          final uri = Uri.parse(url);
          if (uri.host == 'www.google.com' || uri.host == 'google.com') {
            print(uri.queryParameters);
            if (uri.queryParameters['status'] == 'paid') {
              doBook(uri.queryParameters['id']);
            } else {
              showToast('فشل الدفع ، يرجى المحاولة مرة أخرى.');
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
