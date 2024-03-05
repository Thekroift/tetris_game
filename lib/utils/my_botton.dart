import 'package:flutter/material.dart';


myBotton (context, Function() ontap, double l, double r, int lor) {
  
 const  cl = [Colors.transparent,Color(0xFF00CCFF)];
 const cr = [Color(0xFF00CCFF), Colors.transparent];

  return InkWell(
                  highlightColor: const Color.fromARGB(184, 62, 114, 156),
                  splashColor: const Color.fromARGB(184, 62, 114, 156),
                  borderRadius:  BorderRadius.only(
                    topLeft: Radius.circular(l), bottomLeft: Radius.circular(l), 
                    topRight: Radius.circular(r), bottomRight: Radius.circular(r)),
                  onTap: ontap,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    decoration:  BoxDecoration(gradient: 
                     LinearGradient(
                colors: lor == 0 ? cl : cr,
                begin:  const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp)),
                    child:  Icon(lor == 0 ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios, color: Colors.white)
                  ),
                );
}
