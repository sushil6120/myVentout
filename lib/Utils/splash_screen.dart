// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter/src/widgets/implicit_animations.dart';
// import 'package:overcooked/chat/chat.dart';
// import 'package:overcooked/extension.dart';
//
// import 'home/home.dart';
//
// class UserSplashPage extends StatefulWidget {
//   const UserSplashPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _UserSplashPageState();
// }
//
// class _UserSplashPageState extends State<UserSplashPage>
//     with SingleTickerProviderStateMixin {
//   late Timer timer;
//   late Timer timer1;
//   late AnimationController controller;
//   late Animation sizeAnimation;
//   late Animation<double> curve;
//
//   @override
//   void initState() {
//     controller =
//         AnimationController(duration: const Duration(seconds: 1), vsync: this,animationBehavior: AnimationBehavior.normal);
//     controller.repeat(reverse: true);
//     timer = Timer(Duration(seconds: 2), () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ChatScreen()),
//       );
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     controller.forward();
//     var w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xFF231F20),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: controller,
//               builder: (BuildContext _, child) {
//                 return Transform.scale(
//                   scale: controller.value,
//                   child: child,
//                 );
//               },
//               child: Image.asset(
//                 "assets/img/logo.png",
//                 width: w * 0.8,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
