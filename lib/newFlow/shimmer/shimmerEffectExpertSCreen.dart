import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerExpertInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/back-designs.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Shimmer.fromColors(
            baseColor: Colors.black,
            highlightColor: Colors.grey[500]!.withOpacity(.5),
            child: Container(
              width: width * 0.5,
              height: 24,
              color: Colors.grey[800],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.grey[500]!.withOpacity(.5),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey[500]!.withOpacity(.5),
                          child: Container(
                            width: width * 0.4,
                            height: 20,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey[500]!.withOpacity(.5),
                          child: Container(
                            width: width * 0.3,
                            height: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey[500]!.withOpacity(.5),
                          child: Container(
                            width: width * 0.2,
                            height: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.grey[500]!.withOpacity(.5),
                              child: Container(
                                width: 100,
                                height: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 28),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: width * 0.3,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 28),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: width * 0.5,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(6, (index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.grey[500]!.withOpacity(.5),
                      child: Chip(
                        backgroundColor: Colors.grey[800],
                        label: Container(
                          width: width * 0.2,
                          height: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 28),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: width * 0.5,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    return Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey[500]!.withOpacity(.5),
                          child: Container(
                            width: 32,
                            height: 32,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 5),
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey[500]!.withOpacity(.5),
                          child: Container(
                            width: 50,
                            height: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 28),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: width * 0.7,
                    height: 20,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
