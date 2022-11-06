// import 'package:flutter/material.dart';
// import 'package:nibi/globalWidgets/textWidget/text_widget.dart';
// import 'package:nibi/providers/navigationProvider/navigation_provider.dart';
// import 'package:nibi/theme/theme.dart';
// import 'package:provider/provider.dart';

// import '../../../responsiveBloc/size_config.dart';

// class bottomNavigationBar extends StatefulWidget {
//   const bottomNavigationBar({Key? key}) : super(key: key);

//   @override
//   _bottomNavigationBarState createState() => _bottomNavigationBarState();
// }

// class _bottomNavigationBarState extends State<bottomNavigationBar> {
//   @override
//   void initState() {
//     var prov = Provider.of<NavigationProvider>(context, listen: false);
//     if (!prov.searchSelected && !prov.mapSelected) {
//       prov.homeSelected = true;
//     } else {
//       prov.homeSelected = false;
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var provData = Provider.of<NavigationProvider>(context);
//     var screenWidth = SizeConfig.widthMultiplier;
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: SizedBox(
//         height: screenWidth * 25,
//         width: double.infinity,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 5),
//             height: screenWidth * 15,
//             width: double.infinity,
//             decoration: BoxDecoration(
//                 color: Colors.white, boxShadow: theme.containerShadow),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                       onTap: () {
//                         provData.bottomNavigationValueChanges(home: true);

//                         // Navigator.of(context).pushReplacement(
//                         //     MaterialPageRoute(builder: (context) => home()));
//                       },
//                       child: Container(
//                         color: Colors.white.withOpacity(0),
//                         child: Center(
//                             child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.home,
//                               size: screenWidth * 6,
//                               color: provData.homeSelected
//                                   ? theme.darkPink
//                                   : theme.blueColor,
//                             ),
//                             provData.homeSelected
//                                 ? text('Home', screenWidth * 3, theme.darkPink,
//                                     fontWeight: FontWeight.w500)
//                                 : SizedBox()
//                           ],
//                         )),
//                       )),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                       onTap: () {
//                         provData.bottomNavigationValueChanges(search: true);

//                         // Navigator.of(context).pushReplacement(
//                         //     MaterialPageRoute(builder: (context) => home()));
//                       },
//                       child: Container(
//                         color: Colors.white.withOpacity(0),
//                         child: Center(
//                             child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.search,
//                               size: screenWidth * 6,
//                               color: provData.searchSelected
//                                   ? theme.darkPink
//                                   : theme.blueColor,
//                             ),
//                             provData.searchSelected
//                                 ? text(
//                                     'Search', screenWidth * 3, theme.darkPink,
//                                     fontWeight: FontWeight.w500)
//                                 : SizedBox()
//                           ],
//                         )),
//                       )),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                       onTap: () {
//                         provData.bottomNavigationValueChanges(map: true);

//                         // Navigator.of(context).pushReplacement(
//                         //     MaterialPageRoute(builder: (context) => home()));
//                       },
//                       child: Container(
//                         color: Colors.white.withOpacity(0),
//                         child: Center(
//                             child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.map,
//                               size: screenWidth * 6,
//                               color: provData.mapSelected
//                                   ? theme.darkPink
//                                   : theme.blueColor,
//                             ),
//                             provData.mapSelected
//                                 ? text('Maps', screenWidth * 3, theme.darkPink,
//                                     fontWeight: FontWeight.w500)
//                                 : SizedBox()
//                           ],
//                         )),
//                       )),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
