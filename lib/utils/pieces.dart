
import 'package:flutter/material.dart';
import 'package:tetris_game/pages/board.dart';
import 'package:tetris_game/utils/values.dart';

class Piece{
  //tipe of tetris piece
 Tetromino type;

 Piece({required this.type});
 //the pice is just a list of integers
 List<int> position = [];
 //color of tetris piece
 Color get color{
  return tetrominoColor[type] ?? const Color(0xFFFFFFFF);
 }

 //generate the integers
 void initializePiece(){
  var tetrominoType = {
        Tetromino.L: [-38,-53,-68,-37],//ok
    Tetromino.J: [-38,-53,-68,-39],//ok
    Tetromino.I: [-37,-52,-67,-82],//ok
    Tetromino.O: [-37,-38,-52,-53],//OK
    Tetromino.S: [-50,-51,-36,-37],//ok
    
    Tetromino.Z: [-52,-53,-36,-37],
    Tetromino.T: [-37,-52,-67,-53],//ok
  };
  position = tetrominoType[type]!;
 }

 //move piece
 void movePiece(Direction direction){
  direction == Direction.dow ? {
    for(int i=0; i< position.length; i++){
        position[i] += rowL}
  }: direction == Direction.left ? {
    for(int i=0; i< position.length; i++){
        position[i] -= 1}
  }:direction == Direction.right ? {
    for(int i=0; i< position.length; i++){
        position[i] += 1}
  } : null;
 }

 //rotate piece
 int rotationState = 1;
 void rotatePiece(){
  //new position
  List<int> newPosition = [];
  //rotate the pice based on it´s type
  switch (type) {
    case Tetromino.L:
     var rotation = {
      0:[position[1] - rowL,position[1],position[1] + rowL,position[1] + rowL + 1],
      1:[position[1] - 1,position[1],position[1] + 1,position[1] + rowL - 1],
      2:[position[1] + rowL,position[1],position[1] - rowL,position[1] - rowL - 1],
      3:[position[1] - rowL + 1,position[1],position[1] + 1,position[1] - 1]};
    //get the new position
    newPosition = rotation[rotationState]!;
    //check that this new position is valid move before assigning it to the real position
    if(piecePositionIsValid(newPosition)){
      //update position
      position = newPosition;
      //update rotation state
      rotationState = (rotationState + 1) % 4;}
    break;
    case Tetromino.J:
     var rotation = {
      0:[position[1] - rowL,position[1],position[1] + rowL,position[1] + rowL - 1],
      1:[position[1] - rowL - 1,position[1],position[1] - 1,position[1] + 1],
      2:[position[1] + rowL,position[1],position[1] - rowL,position[1] - rowL + 1],
      3:[position[1] + 1,position[1],position[1] - 1,position[1] + rowL + 1]};
    //get the new position
    newPosition = rotation[rotationState]!;
    //check that this new position is valid move before assigning it to the real position
    if(piecePositionIsValid(newPosition)){
      //update position
      position = newPosition;
      //update rotation state
      rotationState = (rotationState + 1) % 4;}
    break;
    case Tetromino.I:
     var rotation = {
      0:[position[1] - 1,position[1],position[1] + 1,position[1] + 2],
      1:[position[1] - rowL,position[1],position[1] + rowL,position[1] + 2 * rowL],
      2:[position[1] + 1,position[1],position[1] - 1,position[1] - 2],
      3:[position[1] + rowL,position[1],position[1] - rowL,position[1] - 2 * rowL]};
    //get the new position
    newPosition = rotation[rotationState]!;
    //check that this new position is valid move before assigning it to the real position
    if(piecePositionIsValid(newPosition)){
      //update position
      position = newPosition;
      //update rotation state
      rotationState = (rotationState + 1) % 4;}
    break;
    case Tetromino.O:
     //the O tetromino does not need to be rotate
    break;
    case Tetromino.S:
     var rotation = {
      0:[position[1],position[1] + 1,position[1] + rowL - 1,position[1] + rowL],
      1:[position[0] - rowL,position[0],position[0] + 1,position[0] + rowL + 1],
      2:[position[1],position[1] + 1,position[1] + rowL - 1,position[1] + rowL],
      3:[position[0] - rowL,position[0],position[0] + 1,position[0]+ rowL + 1]};
    //get the new position
    newPosition = rotation[rotationState]!;
    //check that this new position is valid move before assigning it to the real position
    if(piecePositionIsValid(newPosition)){
      //update position
      position = newPosition;
      //update rotation state
      rotationState = (rotationState + 1) % 4;}
    break;
    case Tetromino.Z:
     var rotation = { 
      0:[position[0] + rowL ,position[1],position[2] + rowL + 1,position[3] + 1],
      1:[position[0] - rowL,position[1],position[2] - rowL - 1,position[3] - 1],
      2:[position[0] + rowL ,position[1],position[2] + rowL + 1,position[3] + 1], 
      3:[position[0] - rowL,position[1],position[2] - rowL - 1,position[3] - 1]};

    //get the new position
    newPosition = rotation[rotationState]!;
    //check that this new position is valid move before assigning it to the real position
    if(piecePositionIsValid(newPosition)){
      //update position
      position = newPosition;
      //update rotation state
      rotationState = (rotationState + 1) % 4;}
    break;
    case Tetromino.T:
     var rotation = {
      0:[position[2] - rowL,position[2],position[2] + 1,position[2] + rowL],
      1:[position[1] - 1,position[1],position[1] + 1,position[1] + rowL],
      2:[position[1] - rowL,position[1]-1,position[1],position[1] + rowL],
      3:[position[2] - rowL,position[2]-1,position[2],position[2] + 1]};
    //get the new position
    newPosition = rotation[rotationState]!;
    //check that this new position is valid move before assigning it to the real position
    if(piecePositionIsValid(newPosition)){
      //update position
      position = newPosition;
      //update rotation state
      rotationState = (rotationState + 1) % 4;}
    break;
    default:
  }
 }
 //check if valid position
 bool positionIsValid(int position){
  //get the row and column of position
  int row = (position / rowL).floor();
  int column = position % rowL;
  //if the position is taken, return false otherwise position is valid so return true
  return row <= 0 || column < 0 || gameBoard[row][column] != null ? false : true;
  }
  //check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition){
    bool firstColumnOcupied = false;
    bool lastColumnOcupied = false;
    for (int pos in piecePosition) {
      //return false if any position is already take
      if (!positionIsValid(pos)) {return false;}
      //get the column of position
      int column = pos % rowL;
      //check if the first or last column is ocupied
      if (column == 0) {firstColumnOcupied = true;}
      if (column == rowL -1) {lastColumnOcupied = true;}
    }
    //if there is a piece in the first column and  last column, it is going through the wall
    return !(firstColumnOcupied && lastColumnOcupied);
  }
}