
  //game over message
  import 'package:flutter/material.dart';

void showGameOverDialog(context, finalscore, Function() onpressed){
    showDialog(context: context, 
    barrierDismissible: false,
    builder: (context){
      return AlertDialog(
      title:const Text("GAME OVER"),
      content: Text("Your score is: $finalscore"),
      actions: [
        TextButton(
          onPressed: onpressed , child:const Text("Play again"))
      ],
    );
    } 
    );
  }
