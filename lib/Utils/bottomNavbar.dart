// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:ventout/chat/chat.dart';
// import 'package:ventout/home/home.dart';
// import 'package:ventout/profile.dart';

// class BottomNavBar extends StatefulWidget {
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   late PageController _controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     _controller = PageController(
//       initialPage: 1,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.chat),
//           label: 'Chat',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//       currentIndex: 0, // Set the current index based on your navigation logic
//       onTap: (index) {
//         // Handle navigation here
//         if (index == 0) {
//           Get.to(ChatScreen(_controller));
//         } else if (index == 1) {
//           Get.to(HomeScreen(_controller));
//         } else if (index == 2) {
//           Get.to(MyVents(_controller));
//         }
//       },
//     );
//   }
// }
