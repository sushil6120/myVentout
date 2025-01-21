import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SingleStoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 5),
            child: Shimmer.fromColors(
                     baseColor: Colors.black,
          highlightColor: Colors.grey[500]!.withOpacity(.5),
              child: Container(
                width: double.infinity,
                height: 20, 
             color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 16.0),
      
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Shimmer.fromColors(
                        baseColor: Colors.black,
          highlightColor: Colors.grey[500]!.withOpacity(.5),
                    child: Container(
                      width: 170,
                      height: 170,
                        color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
           
                Expanded(
                  child: Shimmer.fromColors(
                      baseColor: Colors.black,
          highlightColor: Colors.grey[500]!.withOpacity(.5),
                    child: Container(
                      height: 50, // Height for the quote
                 color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 5),
            child: Shimmer.fromColors(
                     baseColor: Colors.black,
          highlightColor: Colors.grey[500]!.withOpacity(.5),
              child: Container(
                height: 60, // Height for the description
              color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 26.0),
      
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(
                  Icons.check,
                   color: Colors.black, 
                ),
                SizedBox(width: 5),
                Shimmer.fromColors(
                       baseColor: Colors.black,
          highlightColor: Colors.grey[500]!.withOpacity(.5),
                  child: Container(
                    width: 120,
                    height: 20, 
             color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28),
       
          ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                        baseColor: Colors.black,
          highlightColor: Colors.grey[500]!.withOpacity(.5),
                child: Container(
                  height: 80, 
                  margin: EdgeInsets.only(bottom: 10), 
               color: Colors.black,
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
