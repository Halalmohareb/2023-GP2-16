import 'package:flutter/material.dart';

class Failed extends StatefulWidget {
  final dynamic msg;
  const Failed({super.key, required this.msg});

  @override
  State<Failed> createState() => _FailedState();
}

class _FailedState extends State<Failed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Failed'),
      ),
      body: Center(
        child: Text(
          'Payment Failed ! \n' + widget.msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
