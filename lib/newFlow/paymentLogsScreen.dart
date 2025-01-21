import 'package:flutter/material.dart';
import 'package:ventout/newFlow/widgets/color.dart';

class PaymentLogsScreen extends StatelessWidget {
  String time, price;

  PaymentLogsScreen({super.key, required this.price, required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xff202020),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Recharge',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '$time',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  '#ksamkasmdkamdasmc',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
            trailing: Text(
              '+₹$price',
              style: TextStyle(fontSize: 16, color:greenColor),
            )));
  }
}
