import 'package:flutter/material.dart';

import '../newFlow/login/dob.dart';


class OnboardingScreen extends StatefulWidget {
  final String mobile;
  const OnboardingScreen({super.key, required this.mobile});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  double currentIndex = 0;
  final PageController _controller = PageController();
  final bool _visible = true;
  final bool _cloudVisiblity = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.page!;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> items = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'call the coach',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: height * 0.003),
          SizedBox(
            width: width * 0.7,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'reach our ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'LeagueSpartan',
                    fontSize: 20,
                    height: 1.2),
                children: <TextSpan>[
                  TextSpan(
                    text: 'mental health coaches ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LeagueSpartan',
                        fontSize: 20,
                        height: 1.2),
                  ),
                  TextSpan(
                    text: 'in just 5 seconds.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'LeagueSpartan',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6,),
          Text('“with 70-92% of those needing mental health care not receiving it, we bridge the gap.”',style: TextStyle(fontSize: 12),)
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'circle Healing',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: height * 0.001),
          SizedBox(
            width: width * 0.7,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'Get ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'LeagueSpartan',
                    fontSize: 20,
                    height: 1.2),
                children: <TextSpan>[
                  TextSpan(
                    text: 'awareness ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LeagueSpartan',
                        fontSize: 20,
                        height: 1.2),
                  ),
                  TextSpan(
                    text:
                        ' with mental health stories near you and share your stories in the +Post section.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'LeagueSpartan',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6,),
          Text('“awareness can grow the mental health market at a projected CAGR of 15% from 2021-2026”',style: TextStyle(fontSize: 12),)
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avie',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
   
           SizedBox(height: height * 0.001),
          SizedBox(
            width: width * 0.7,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'get your emotions to the other end with the help of our ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'LeagueSpartan',
                    fontSize: 20,
                    height: 1.2),
                children: <TextSpan>[
                  TextSpan(
                    text: 'friendly AI Healer ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'LeagueSpartan',
                        fontSize: 20,
                        height: 1.2),
                  ),
                  TextSpan(
                    text:
                        ' called Avie.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'LeagueSpartan',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6,),
          Text('“an informal help leads to 25% increase in the willingness of people to seek help for mental health issues.”',style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),)
        ],
      ),
      Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anonymous',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
                SizedBox(height: height * 0.001),
          SizedBox(
            width: width * 0.7,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'nobody ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'LeagueSpartan',
                    fontSize: 20,
                    height: 1.2),
                children: <TextSpan>[
                  TextSpan(
                    text: 'nobody gets to know who you’re. you just have to add a random photo to ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LeagueSpartan',
                        fontSize: 20,
                        height: 1.2),
                  ),
                  TextSpan(
                    text:
                        'belong',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'LeagueSpartan',
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text:
                        'on this platform.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'LeagueSpartan',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2,),
          Text('“no fear of judgement can reduce \$14 billion losses annually due to untreated mental health issues.”',style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),)
          ],
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/img/human.png',
                  height: height * .78,
                )),
            (currentIndex < 1.5)
                ? AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, top: 8),
                      child: Image.asset(
                        'assets/img/thoughts.png',
                        fit: BoxFit.cover,
                        height: height * .98,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 14, top: 8),
                    child: AnimatedOpacity(
                      opacity: _visible ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset(
                        'assets/img/thoughts.png',
                        height: height * .98,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            (currentIndex < 0.5)
                ? AnimatedOpacity(
                    opacity: _cloudVisiblity ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/img/cloud.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : AnimatedOpacity(
                    opacity: _cloudVisiblity ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/img/cloud.png',
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              width: width,
              height: height,
              child: PageView.builder(
                  padEnds: false,
                  controller: _controller,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.17, right: width * .12, left: width*.16),
                        child: items[index]);
                  }),
            ),

            //Dot Indicators
            Positioned(
              top: height * 0.14,
              left: width * 0.15,
              child: Row(
                children: List.generate(items.length, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _controller.jumpToPage(index);
                        });
                      },
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 1.5),
                          color: (currentIndex >= index - 0.4 &&
                                  currentIndex < index + 0.6)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            //Navigation Buttons
            Positioned(
                top: height * 0.4,
                left: width * .16,
                child: GestureDetector(
                  onTap: () {
                            if (currentIndex > 0) {
                      _controller.animateToPage(currentIndex.toInt() - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    }
                  },
                  child: Container(
                     width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: currentIndex == 0? Colors.grey.shade800:Colors.white, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  ),
                )
                //  ElevatedButton(
                //   onPressed: () {
                //     if (currentIndex > 0) {
                //       _controller.animateToPage(currentIndex.toInt() - 1,
                //           duration: const Duration(milliseconds: 400),
                //           curve: Curves.easeIn);
                //     }
                //   },
                //   child: const Text('Previous'),
                // ),
                ),
            Positioned(
                top: height * 0.37,
                right: width * 0.54,
                child: GestureDetector(
                  onTap: () {
                           if (currentIndex < items.length - 1) {
                      _controller.animateToPage(currentIndex.toInt() + 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    } else {
                      DOBScreen(
                        // img: image!,
                        // mobile: widget.mobile,
                      );
                    }
                  },
                  child: Container(
                  width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  ),
                )
                // ElevatedButton(
                //   onPressed: () {
                //     if (currentIndex < items.length - 1) {
                //       _controller.animateToPage(currentIndex.toInt() + 1,
                //           duration: const Duration(milliseconds: 400),
                //           curve: Curves.easeIn);
                //     } else {
                //       DOBScreen(
                //         // img: image!,
                //         mobile: widget.mobile,
                //       ).navigate();
                //     }
                //   },
                //   child: const Text('Next'),
                // ),
                ),

            //Tap Controller
            GestureDetector(
              onTapDown: (details) {
                if (details.localPosition.direction > 1.2) {
                  print('Left');
                  _controller.animateToPage(currentIndex.toInt() - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                }
                if (details.localPosition.direction < 1.2) {
                  print('Right');
                  if (currentIndex == items.length - 1) {
                    DOBScreen(
                      // img: image!,
                      // mobile: widget.mobile,
                    );
                  } else {
                    _controller.animateToPage(currentIndex.toInt() + 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  }
                }
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
