// import 'dart:async';
// import 'dart:io';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:overcooked/main.dart';
// import 'package:overcooked/newFlow/services/sharedPrefs.dart';
// import 'package:overcooked/newFlow/widgets/ratingDialog.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:permission_handler/permission_handler.dart';

// String appId = "710c49d130bb4f558dd017699e6f02df";

// class CallScreen extends StatefulWidget {
//   final String channelName;
//   final String? name;
//   final String? agoraToken, therapistId, image;
//   CallScreen({
//     super.key,
//     required this.channelName,
//     required this.name,
//     required this.agoraToken,
//     required this.therapistId,
//     required this.image,
//   });

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
//   SharedPreferencesViewModel sharedPreferencesViewModel =
//       SharedPreferencesViewModel();

//   late RtcEngine _engine;
//   bool _localUserJoined = false;
//   int? _remoteUid;
//   bool _muted = false;
//   bool _speakerOn = false;
//   Timer? _timer;
//   int _callDuration = 0;
//   String? userToken, tokenId, token;
//   late AnimationController _ellipsisController;
//   String calltext = 'Connecting to server';

//   @override
//   void initState() {
//     super.initState();
//     preferences!.remove('callData');
//     Future.wait([sharedPreferencesViewModel.getToken()]).then((value) {
//       token = value[0];
//     });
//     print(userToken);
//     _ellipsisController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     print(" callt =======================================");
//     print(widget.agoraToken);
//     print(widget.channelName);
//     print("=======================================call");
//     // Change text to "Ringing" after 7 seconds and start the ellipsis animation
//     Future.delayed(Duration(seconds: 7), () {
//       setState(() {
//         calltext = 'Ringing';
//       });
//       _ellipsisController.repeat();
//     });
//     _initAgora();
//     // _fetchToken('test', 0);
//   }

//   Future<void> _initAgora() async {
//     // Request microphone permission
//     await [Permission.microphone].request();

//     // Create RtcEngine instance
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));

//     // Enable audio
//     await _engine.enableAudio();

//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onError: (err, msg) {
//           print("*******************************************");
//           print("$err   $msg");
//           print("*******************************************");
//         },
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           if (mounted) {
//             setState(() {
//               _remoteUid = remoteUid;
//               setState(() {
//                 _localUserJoined = true;
//                 _startTimer();
//               });
//             });
//           }
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           _endCall(context);
//         },
//       ),
//     );

//     // Join the channel
//     await _engine.joinChannel(
//       token: widget.agoraToken.toString(),
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     // _removeToken(tokenId.toString(), userToken);
//     _engine.release();
//     _ellipsisController.dispose();
//     _stopTimer();
//     super.dispose();
//   }

//   void _onToggleMute() {
//     if (mounted) {
//       setState(() {
//         _muted = !_muted;
//       });
//     }
//     _engine.muteLocalAudioStream(_muted);
//   }

//   void _onToggleSpeaker() {
//     if (mounted) {
//       setState(() {
//         _speakerOn = !_speakerOn;
//       });
//     }
//     _engine.setEnableSpeakerphone(_speakerOn);
//   }

//   // void _onCallEnd(BuildContext context) {
//   //   Navigator.pop(context);
//   //   if (_remoteUid != null) {
//   //     // Future.delayed(Duration(milliseconds: 100), () {
//   //     //   showRatingBottomSheet(context);
//   //     // });
//   //   }
//   // }

//   Future<bool> _onWillPop() async {
//     // showRatingBottomSheet(context);
//     return false;
//   }

//   void _startTimer() {
//     _callDuration = 0;
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           _callDuration++;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void _stopTimer() {
//     if (_timer != null) {
//       _timer!.cancel();
//     }
//   }

//   void _endCall(BuildContext context) {
//     Navigator.pop(context);
//     _stopTimer();
//     Future.delayed(Duration(milliseconds: 100), () {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return RatingDialog(
//             therapist: widget.therapistId,
//             token: token,
//           );
//         },
//       );
//     });
//   }

//   String _formatDuration(int seconds) {
//     final duration = Duration(seconds: seconds);
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final secs = twoDigits(duration.inSeconds.remainder(60));
//     return [minutes, secs].join(':');
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     // final CallService callService = Get.put(CallService());
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.black,
//         image: DecorationImage(
//           image: AssetImage('assets/img/back-designs.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         // appBar: AppBar(
//         //   backgroundColor: Colors.transparent,
//         //   elevation: 0,
//         //   leading: IconButton(
//         //     icon: Icon(Icons.arrow_back_ios_new_rounded),
//         //     onPressed: () {
//         //       Navigator.of(context).pop();
//         //     },
//         //   ),
//         //   actions: [
//         //     IconButton(
//         //       icon: Icon(CupertinoIcons.exclamationmark_octagon),
//         //       onPressed: () {},
//         //     ),
//         //   ],
//         // ),
//         body: Center(
//           child: SafeArea(
//               child: _localUserJoined
//                   ? SingleChildScrollView(
//                       physics: NeverScrollableScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.lock,
//                                 color: Color(0xffA8A8A8),
//                                 size: 18,
//                               ),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               Text(
//                                 "End-to-end encrypted",
//                                 style: TextStyle(color: Color(0xffA8A8A8)),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Text(
//                             widget.name.toString(),
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w800),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             ' ${_formatDuration(_callDuration)}',
//                             style: TextStyle(
//                               color: Color(0xffFFFFFF),
//                             ),
//                           ),
//                           widget.image == null || widget.image!.isEmpty
//                               ? Center(
//                                   heightFactor: 3,
//                                   child: CircleAvatar(
//                                     radius: 70,
//                                     backgroundColor: Colors.white,
//                                     child: Icon(
//                                       Icons.person,
//                                       size: 100,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 )
//                               : Center(
//                                   heightFactor: 3,
//                                   child: CircleAvatar(
//                                     radius: 70,
//                                     backgroundColor: Colors.white,
//                                     backgroundImage:
//                                         NetworkImage(widget.image!),
//                                   ),
//                                 ),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     )
//                   : Center(
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 80,
//                           ),
//                           AnimatedBuilder(
//                             animation: _ellipsisController,
//                             builder: (context, child) {
//                               String dots = '';
//                               if (calltext == 'Ringing') {
//                                 dots = '.' *
//                                     ((3 * _ellipsisController.value).round() %
//                                         4);
//                               }
//                               return Text(
//                                 '$calltext$dots',
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.grey.shade500),
//                               );
//                             },
//                           ),
//                           Center(
//                             heightFactor: 5,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Center(
//                                     child: LoadingAnimationWidget
//                                         .threeRotatingDots(
//                                   color: Colors.white,
//                                   size: 30,
//                                 )),
//                                 SizedBox(
//                                   height: 16,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 80),
//                                   child: RichText(
//                                       textAlign: TextAlign.center,
//                                       text: TextSpan(children: [
//                                         TextSpan(
//                                             text: 'Hold On G!  \n',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w400)),
//                                         TextSpan(
//                                             text: 'Connecting you to a ',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w400)),
//                                         TextSpan(
//                                             text: ' VentOut Counsellor',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: Color(0XFFD10000),
//                                                 fontWeight: FontWeight.w700))
//                                       ])),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )),
//         ),
//         bottomNavigationBar: Container(
//           width: width,
//           height: Platform.isIOS ? height * .12 : height * .11,
//           padding: EdgeInsets.only(left: 14, right: 14, bottom: 8),
//           decoration: BoxDecoration(color: Color(0xff0E0E0E)),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               RawMaterialButton(
//                 onPressed: _onToggleMute,
//                 shape: CircleBorder(),
//                 elevation: 2.0,
//                 fillColor: _muted ? Colors.white : Color(0xff1A1C21),
//                 padding: const EdgeInsets.all(12.0),
//                 child: Icon(
//                   _muted ? Icons.mic_off : Icons.mic,
//                   color: _muted ? Colors.black : Colors.white,
//                   size: 28.0,
//                 ),
//               ),
//               RawMaterialButton(
//                 onPressed: _onToggleSpeaker,
//                 shape: CircleBorder(),
//                 elevation: 2.0,
//                 fillColor: _speakerOn ? Colors.white : Color(0xff1A1C21),
//                 padding: const EdgeInsets.all(12.0),
//                 child: Icon(
//                   _speakerOn ? Icons.volume_up : Icons.volume_off,
//                   color: _speakerOn ? Colors.black : Colors.white,
//                   size: 28.0,
//                 ),
//               ),
//               RawMaterialButton(
//                 onPressed: () {
//                   _endCall(context);
//                   showToast('Call Ended');
//                 },
//                 shape: CircleBorder(),
//                 elevation: 2.0,
//                 fillColor: Color(0XFFD10000),
//                 padding: const EdgeInsets.all(15.0),
//                 child: Icon(
//                   Icons.call_end,
//                   color: Colors.white,
//                   size: 25.0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // void showRatingBottomSheet(BuildContext context) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     backgroundColor: Color(0xff101010),
//   //     isScrollControlled: true,
//   //     builder: (context) {
//   //       return Obx(() {
//   //         print("isLoadings: ${_ventController.isLoadings.value}");
//   //         if (_ventController.isLoadings.value == true) {
//   //           return SizedBox();
//   //         } else {
//   //           print("t");
//   //           print(_ventController
//   //               .callHistoryModel.value.success!.data!.first.callRecordId);
//   //           return Padding(
//   //             padding: EdgeInsets.only(
//   //               bottom: MediaQuery.of(context).viewInsets.bottom,
//   //             ),
//   //             child: RatingBottomSheet(
//   //               token: token,
//   //               callerId: _ventController
//   //                   .callHistoryModel.value.success!.data!.first.callRecordId,
//   //             ),
//   //           );
//   //         }
//   //       });
//   //     },
//   //   );
//   // }

//   void showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.transparent,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
// }
