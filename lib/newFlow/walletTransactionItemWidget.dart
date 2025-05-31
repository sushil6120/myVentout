import 'package:flutter/material.dart';

class WalletTransactionItem extends StatelessWidget {
  String? name, date, price, duration, transactionId;
  WalletTransactionItem(
      {super.key,
      this.date,
      this.name,
      this.price,
      this.duration,
      this.transactionId});
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
            title: Text(
              'Call with $name.',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 2,
                ),
                Text(
                  date!,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '#$transactionId',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
            trailing: Text(
              '-₹$price',
              style: const TextStyle(fontSize: 16, color: Color(0xffFF5C5C)),
            )));
  }
}
