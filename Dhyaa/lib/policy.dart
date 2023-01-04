
import 'package:Dhyaa/provider/firestore.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/theme/tutorTopBarNavigator.dart';

class policy extends StatefulWidget {
  const policy ({Key? key}) : super(key: key);

  @override
  //State<policy> createState() => _policy();
}

class Policy extends State<policy> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        //TutorTopBarNavigator(),
    Divider(),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Column(
    children: [
    Container(
    decoration: BoxDecoration(
    color: kSearchBackgroundColor,
    borderRadius: BorderRadius.circular(20),
    ),
    padding: EdgeInsets.all(20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Image.asset(
    'assets/images/DhyaaLogo.png',
    width: 150,
    ),
    Expanded(
    child: Text(
    'سياسة الدفع والاسترجاع:' ,
    textAlign: TextAlign.right,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),
    ),














//@override
//Widget build(BuildContext context) {
  //var screenWidth = SizeConfig.widthMultiplier;
  //return Scaffold(
   // backgroundColor: theme.appBackgroundColor,
   // body: Center(
 // children: [
  //Column(
  //children: [
  //SizedBox(height: 30,
 // ),
  //Image.asset("")],),
 // Text(""),//insetpath here
  //Column(
 // children: [
  //SizedBox(height: 30,
 // ),
  //Image.asset("")],),
  //Text(""),
 // Column(
 // SizedBox(height: 30,
  //),
  //children: [
  //Image.asset("")],),
  //Text(""),