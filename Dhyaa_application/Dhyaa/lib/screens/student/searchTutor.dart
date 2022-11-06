import 'package:flutter/material.dart';

class SeachTutorScreen extends StatefulWidget {
  const SeachTutorScreen({Key? key, required this.searchText})
      : super(key: key);
  final String searchText;
  @override
  State<SeachTutorScreen> createState() => _SeachTutorScreenState();
}

class _SeachTutorScreenState extends State<SeachTutorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(widget.searchText+'انت تبحث عن  ' ),
        ),
      ),
    );
  }
}
