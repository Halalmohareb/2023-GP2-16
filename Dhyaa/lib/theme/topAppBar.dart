import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/menu.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class TopAppBar extends StatefulWidget {
  final bool isHome;
  const TopAppBar({super.key, required this.isHome});

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  UserData userData = emptyUserData;
  // Functions
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 110.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              spreadRadius: 7,
              color: theme.fillColor,
              offset: Offset(0, 1),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
              MediaQuery.of(context).size.width,
              190,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    (Navigator.canPop(context) && !widget.isHome)
                        ? Container(
                            width: 30,
                            child: IconButton(
                              padding: EdgeInsets.only(left: 15, right: 0),
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: false).push(
                          MaterialPageRoute(
                            builder: (context) => Menu(userData: userData),
                            maintainState: false,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: userData.avatar,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset('assets/icons/DhyaaLogo.png', height: 40),
              ],
            ),
            Center(
              child: Text(
                'مرحباً, ' + userData.username,
                maxLines: 1,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 18,
                  color: kBlueColor,
                  fontFamily: 'bc',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
