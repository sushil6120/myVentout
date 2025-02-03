import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:overcooked/newFlow/widgets/color.dart';

class CallScreenAppBar extends StatelessWidget {
  String title, filterTitle, amount;

  CallScreenAppBar({
    super.key,
    required this.title,
    required this.filterTitle,
    required this.amount,
  });

  List texts = ['♥ Love', '📚 Education', '🎓 Career'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 38,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(CupertinoIcons.search)),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RoutesName.WalletHistoryScreen);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: greenColor),
                          color: Colors.black),
                      child: Center(
                        child: Text(
                          '₹0',
                          style:
                              TextStyle(fontSize: 14, color: greenColor),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                        onPressed: () {
                          UtilsClass().showSettingCard(context,amount);
                        },
                        iconSize: 28,
                        icon: Image.asset(
                          'assets/img/dots.png',
                          height: 30,
                        )),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.sortFilterScreen);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 14),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: Color(0xff202020),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/filter.png',
                          height: 18,
                        ),
                        Text(
                          'Filters',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 14),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                      color: Color(0xff202020),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'All',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                ...List.generate(
                    texts.length, (index) => CustomeContainer(texts[index]))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget CustomeContainer(String filterTitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
          color: Color(0xff202020), borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            filterTitle,
            style: TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ),
    );
  }
}
