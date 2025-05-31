// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class ZegoCallScreen extends StatefulWidget {
//   const ZegoCallScreen({super.key});

//   @override
//   State<ZegoCallScreen> createState() => _ZegoCallScreenState();
// }

// class _ZegoCallScreenState extends State<ZegoCallScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ZegoUIKitPrebuiltCall(
//         appID:
//             170880794, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign:
//             '2a6131976af25e424ed2fe7340fd3dd8e5f5232ef52e4c6df1b9e7e3a02af317', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: '2',
//         userName: 'sushil',
//         callID: '2',
//         // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//         config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//         events: ZegoUIKitPrebuiltCallEvents(user: ZegoCallUserEvents(
//           onEnter: (p0) {
//             print("hello its enterd");
//           },
//         )),
//       ),
//     );
//   }
// }
