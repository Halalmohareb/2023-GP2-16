import 'package:flutter/material.dart';
import 'package:moyasar_testing/completed.dart';
import 'package:moyasar_testing/failed.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VerifyPage extends StatefulWidget {
  final dynamic url;
  const VerifyPage({super.key, required this.url});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment in process'),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {
          dynamic u = Uri.parse(url);
          print(' @@@@@@@@@@@@@@@@@@@@@ url');
          final uri = Uri.parse(url);
          print(uri.host);
          print(uri.queryParameters);
          if (uri.host == 'www.google.com' || uri.host == 'google.com') {
            if (uri.queryParameters['status'] == 'failed') {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Failed(msg: uri.queryParameters['message'] )),
                  (Route<dynamic> route) => false);
            } else if (uri.queryParameters['status'] == 'success') {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Completed()),
                  (Route<dynamic> route) => false);
            }
          }
        },
      ),
    );
  }
}
