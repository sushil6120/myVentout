// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:swayye_frontend/core/constants/buzz.dart';
// import 'package:swayye_frontend/core/controllers/BottomBarController.dart';
// import 'package:swayye_frontend/core/controllers/global_controller.dart';

// class BottomBar extends ConsumerStatefulWidget {
//   const BottomBar({
//     Key? key,
//     this.notOnMainPage,
//   }) : super(key: key);

//   final bool? notOnMainPage;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _BottomBarState();
// }

// class _BottomBarState extends ConsumerState<BottomBar> {
//   late BottomBarProvider bottomBarPvd;
//   // int currentIndex = 0;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     bottomBarPvd = ref.watch(bottomBarProvider);
//     if (widget.notOnMainPage != null && widget.notOnMainPage!) {
//       bottomBarPvd.changeMainPageValue(widget.notOnMainPage!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     int currentIndex = ref.watch(bottomBarProvider).selectedIndex;
//     EdgeInsetsGeometry iconTopPadding = const EdgeInsets.only(top: 20.0);

//     return CurvedNavigationBar(
      
//       items: [
//         Padding(
//           padding: (currentIndex != 0) ? iconTopPadding : EdgeInsets.zero,
//           child: Image.asset(
//             (currentIndex != 0)
//                 ? BuzzConstants.discover
//                 : BuzzConstants.discoverActive,
//             fit: BoxFit.cover,
//             scale: 2.5,
//           ),
//         ),
//         Padding(
//           padding: (currentIndex != 1) ? iconTopPadding : EdgeInsets.zero,
//           child: Image.asset(
//             (currentIndex != 1) ? BuzzConstants.buzz : BuzzConstants.buzzActive,
//             scale: 2.5,
//           ),
//         ),
//         Padding(
//           padding: (currentIndex != 2) ? iconTopPadding : EdgeInsets.zero,
//           child: Image.asset(
//             (currentIndex != 2)
//                 ? BuzzConstants.sparks
//                 : BuzzConstants.sparksActive,
//             scale: 2.5,
//           ),
//         ),
//         Padding(
//           padding: (currentIndex != 3) ? iconTopPadding : EdgeInsets.zero,
//           child: Image.asset(
//             (currentIndex != 3)
//                 ? BuzzConstants.profile
//                 : BuzzConstants.profileActive,
//             scale: 2.5,
//           ),
//         ),
//       ],

//       // type: BottomNavigationBarType.fixed,
//       // buttonBackgroundColor: Socials.goldenColor,
//       backgroundColor: Colors.transparent,
//       color: Colors.grey[850]!,
//       animationDuration: const Duration(milliseconds: 500),
//       animationCurve: Curves.decelerate,
//       index: currentIndex,
//       // currentIndex: ref.watch(bottomBarProvider).selectedIndex,
//       // showSelectedLabels: false,
//       // showUnselectedLabels: false,
//       // selectedItemColor: UserProfileConstants.yellowColor,
//       // unselectedItemColor: Colors.white,

//       onTap: (value) {
//         // setState(() {
//         //   currentIndex = value;
//         // });

//         bottomBarPvd.onItemTapped(value, context);
//       },
//     );
//   }
// }