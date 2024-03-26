import 'package:tetris_game/utils/values.dart';

  //check for collision in a future position
  //return true -> there is a collision 
  //return false -> there is not collision
bool checkCollision(Direction direction, position){
    //loop through each position of the current piece
    for (var i = 0; i < position.length; ++i) {
    //calcule the row and the column of the current position 
     var row = (position[i] / rowL).floor();
     var column = position[i] % rowL;
     //adjust the row and column based on the direction     
     switch (direction) {
       case Direction.left:
         column -= 1;
         case Direction.right:
         column += 1;
         case Direction.dow:
         row += 1;
         break;
       default:
     }
      //check if the piece is out of bounds (either too low or too far to the left or right) 
      if (row >= columL || column < 0 || column >= rowL) {return true;}
    }
    //if no collisions are detected, return false
    return false;
  }