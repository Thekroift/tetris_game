// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class PixelPage extends StatelessWidget {
  Color? color;
  dynamic child;
  PixelPage({ required this.color, this.child = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.all(1),
      child: Center(
        child: Text(child.toString(), style: const TextStyle(color: Colors.white)),
      ),
   );
  }
}