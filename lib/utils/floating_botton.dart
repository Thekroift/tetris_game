
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class floatingBottonRotate extends StatelessWidget {
  Function() onpress;
  floatingBottonRotate({required this.onpress,super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 2, 67, 84),
        onPressed: onpress,
        child: const Icon(Icons.rotate_90_degrees_cw_outlined, color: Colors.white));
  }
}


// ignore: must_be_immutable
class floatingBottonDown extends StatelessWidget {
  Function() onpress;
  floatingBottonDown({required this.onpress,super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 2, 67, 84),
        onPressed: onpress,
        child: const Icon(Icons.keyboard_double_arrow_down, color: Colors.white));
  }
}