
 //grid dimensions
  import 'package:flutter/material.dart';

  int rowL = 10;
  int columL = 18;

enum Direction{
  left, 
  right,
  dow,
}

enum Tetromino{
  L,
  J,
  I,
  O,
  S,
  Z,
  T
}

const Map<Tetromino, Color> tetrominoColor = {
  Tetromino.L: Color.fromARGB(255, 150, 99, 4),
  Tetromino.J: Color.fromARGB(255, 0, 52, 130),
  Tetromino.I: Color.fromARGB(255, 133, 2, 139),
  Tetromino.O: Color.fromARGB(255, 155, 155, 1),
  Tetromino.S: Color.fromARGB(255, 2, 87, 2),
  Tetromino.Z: Color.fromARGB(255, 110, 1, 1),
  Tetromino.T: Color.fromARGB(255, 63, 3, 109),
};
