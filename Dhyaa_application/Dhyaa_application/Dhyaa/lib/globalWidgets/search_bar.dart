import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/screens/student/searchTutor.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController = new TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: EdgeInsets.only(
        left: 40,
      ),
      decoration: BoxDecoration(
        color: kBlueColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 180,
            child: TextField(
              controller: textController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration.collapsed(
                hintText: '... Search by subject',
                hintTextDirection: TextDirection.rtl,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeachTutorScreen(
                    searchText: textController.text,
                  ),
                ),
              );
            },
            child: Container(
              height: 50,
              width: 70,
              decoration: BoxDecoration(
                color: kOrangeColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                height: 25,
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: MaterialButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SeachTutorScreen(
          //             searchText: textController.text,
          //           ),
          //         ),
          //       );
          //     },
          //     color: kOrangeColor,
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 10,
          //       vertical: 15,
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     height: 15,
          //     child: SvgPicture.asset(
          //       'assets/icons/search.svg',
          //       height: 25,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
