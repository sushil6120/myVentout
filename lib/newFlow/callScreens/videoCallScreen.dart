// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:ventout/Utils/responsive.dart';
// import 'package:ventout/newFlow/homeScreen.dart';
// import 'package:ventout/newFlow/services/sharedPrefs.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';

// import '../widgets/ratingDialog.dart'; // Import Agora UI Kit

// const appId = "710c49d130bb4f558dd017699e6f02df";
// // const token =
// //     "007eJxTYJCobBbi9ZvtLVdxJ3i7p8bi0Fmzrp49oPlqYnqt4YaJ+/4oMKRYGCYbJielJlsYJJukmBklpRgnp5ilJqeYGpqmWVgminzZl9YQyMjQ4C/AwAiFID4LQ3JiTg4DAwBK8x/Y";
// // const channel = "call";
// // int localUid = 123456; // Ensure this UID is unique

// class VideoCallScreen extends StatefulWidget {
//   final String channelName;
//   final String? name;
//   final String? agoraToken, therapistId, image;

//   VideoCallScreen({
//     super.key,
//     required this.channelName,
//     required this.name,
//     required this.agoraToken,
//     required this.therapistId,
//     required this.image,
//   });

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   SharedPreferencesViewModel sharedPreferencesViewModel =
//       SharedPreferencesViewModel();
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//   bool _muted = false;
//   bool _cameraEnabled = true;
//   bool _isFrontCamera = true;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();

//     Future.wait([sharedPreferencesViewModel.getToken()]).then((value) {
//       token = value[0];
//     });
//   }

//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();

//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));

//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//             _localUserJoined == false;
//           });
//           _endCall();
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );

//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();

//     await _engine.joinChannel(
//       token: widget.agoraToken.toString(),
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   void _toggleMute() async {
//     setState(() {
//       _muted = !_muted;
//     });
//     await _engine.muteLocalAudioStream(_muted);
//   }

//   void _toggleCamera() async {
//     setState(() {
//       _cameraEnabled = !_cameraEnabled;
//     });
//     await _engine.enableLocalVideo(_cameraEnabled);
//   }

//   void _toggleBetweenCamera() async {
//     setState(() {
//       _isFrontCamera = !_isFrontCamera;
//     });
//     await _engine.switchCamera();
//   }

//   void _endCall() {
//     Navigator.pop(context);
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

//   @override
//   void dispose() {
//     super.dispose();

//     _dispose();
//   }

//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

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
//         body: Stack(
//           children: [
//             Center(
//               child: _remoteVideo(),
//             ),
//             _localUserJoined
//                 ? Align(
//                     alignment: Alignment.topLeft,
//                     child: SizedBox(
//                         width: 100,
//                         height: 150,
//                         child: Center(
//                             child: AgoraVideoView(
//                           controller: VideoViewController(
//                             rtcEngine: _engine,
//                             canvas: const VideoCanvas(uid: 0),
//                           ),
//                         ))),
//                   )
//                 : Center(
//                     child: Padding(
//                       padding:
//                           EdgeInsets.only(bottom: context.deviceHeight * .06),
//                       child: LoadingAnimationWidget.prograssiveDots(
//                           color: Colors.white, size: 45),
//                     ),
//                   ),
//           ],
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
//                 onPressed: _toggleMute,
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
//                 onPressed: _toggleCamera,
//                 shape: CircleBorder(),
//                 elevation: 2.0,
//                 fillColor: _cameraEnabled ? Color(0xff1A1C21) : Colors.white,
//                 padding: const EdgeInsets.all(12.0),
//                 child: Icon(
//                   _cameraEnabled
//                       ? Icons.disabled_by_default_outlined
//                       : Icons.disabled_by_default,
//                   color: _cameraEnabled ? Colors.white : Colors.black,
//                   size: 28.0,
//                 ),
//               ),
//               RawMaterialButton(
//                 onPressed: _toggleBetweenCamera,
//                 shape: CircleBorder(),
//                 elevation: 2.0,
//                 fillColor: _isFrontCamera ? Color(0xff1A1C21) : Colors.white,
//                 padding: const EdgeInsets.all(12.0),
//                 child: Icon(
//                   _isFrontCamera
//                       ? Icons.switch_camera_outlined
//                       : Icons.switch_camera,
//                   color: _isFrontCamera ? Colors.white : Colors.black,
//                   size: 28.0,
//                 ),
//               ),
//               RawMaterialButton(
//                 onPressed: _endCall,
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

//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
