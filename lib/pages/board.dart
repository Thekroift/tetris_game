
// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris_game/pages/game_over.dart';
import 'package:tetris_game/utils/floating_botton.dart';
import 'package:tetris_game/utils/my_botton.dart';
import 'package:tetris_game/utils/pieces.dart';
import 'package:tetris_game/utils/pixel.dart';
import 'package:tetris_game/utils/values.dart';

/*
GAME BOARD 
this is a 2x2 grid with null representing an empty space.
A non empty space will have the color to representing  the landed pieces 
*/

//create game board
List<List<Tetromino?>> gameBoard = List.generate(
  columL,(n) => List.generate(rowL, (d) => null));

// ignore: must_be_immutable
class GameBoardPage extends StatefulWidget {
  @override
  State<GameBoardPage> createState() => _GameBoardPageState();
}

class _GameBoardPageState extends State<GameBoardPage> {
  //current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);
  //current score
  int currentScore = 0;
  //game over
  bool gameover = false;
  //Fats
  bool isFast = true;
  //pause
  bool pause = false;

  @override
  void initState() {
    super.initState();
    //start game when app start
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    //Duration
     Duration frameRate = const Duration(milliseconds: 800); 
    //frame refresh rate
     gameLoop(frameRate);
  }

  //game loop
  void gameLoop(Duration frameRate){
    Timer.periodic(
      frameRate,
    (timer) {
      setState(() {
        //clear lines
        clearLines();
        //check landing
        checkLanding();
        //check if game is over
        if (gameover == true) {
          timer.cancel();
          showGameOverDialog(context, currentScore, (){
          //reset game 
          resetGame();
          Navigator.pop(context);
        });
        }else if (pause == true){
          timer.cancel();
        }
        //move current piece dow
      currentPiece.movePiece(Direction.dow);
      });
    });
  }


  //reset game
  void resetGame(){
    //clear the game board
    gameBoard = List.generate(
  columL,(n) => List.generate(rowL, (d) => null));
  //new game
  gameover = false;
  currentScore = 0;
  //create new piece
  createNewPiece();
  //star game again
  startGame();
  }

  //check for collision in a future position
  //return true -> there is a collision 
  //return false -> there is not collision
  bool checkCollision(Direction direction){
    //loop through each position of the current piece
    for (var i = 0; i < currentPiece.position.length; ++i) {
    //calcule the row and the column of the current position 
     var row = (currentPiece.position[i] / rowL).floor();
     var column = currentPiece.position[i] % rowL;
     //adjust the row and column based on the direction     
     if (direction == Direction.left) {
      column -= 1;
      }else if(direction == Direction.right){
      column += 1;
      }else if(direction == Direction.dow){
      row += 1;
      }
      //check if the piece is out of bounds (either too low or too far to the left or right) 
      if (row >= columL || column < 0 || column >= rowL) {
        return true;
        }
    }
    //if no collisions are detected, return false
    return false;
  }

 void checkLanding() {
    // if going down is occupied or landed on other pieces
    if (checkCollision(Direction.dow) || checkLanded()) {
      isFast = false;
      // mark position as occupied on the game board
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowL).floor();
        int col = currentPiece.position[i] % rowL;
        row >= 0 && col >= 0 ? gameBoard[row][col] = currentPiece.type : null;
      }
      // once landed, create the next piece
      createNewPiece();
    }
  }

  bool checkLanded() {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowL).floor();
      int col = currentPiece.position[i] % rowL;
      // check if the cell below is already occupied
      if (row + 1 < columL && row >= 0 && gameBoard[row + 1][col] != null) {
        return true; // collision with a landed piece
      }
    }
    return false; // no collision with landed pieces
  }

  void createNewPiece(){
    //create a random object to generate random tetromino types
    Random rand = Random();
    //create a new piece with random type
    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    //since our game over condition is if there is a piece at the top level, you want to check if the game is over when you create a new piece instead of checking every frame, because new pieces are allowed to go through the top level but if there is already a piece in the top level when the new piece is created, the game is over.
    if (isGameOver()) {
      gameover = true;
    }
  }
 
 //move left
 void moveLeft(){
  //make sure the move is validbefore moving there
  !checkCollision(Direction.left) ? setState(() {currentPiece.movePiece(Direction.left);}) : null;
 }
 
 //move right
 void moveRight(){
    //make sure the move is validbefore moving there
    !checkCollision(Direction.right) ? setState((){currentPiece.movePiece(Direction.right);}) : null;
 }

 //move down fast
 void moveDown(){
  isFast = true;
  Duration frameRate = const Duration(milliseconds: 100); 
  Timer.periodic(
      frameRate,
    (timer) {
      setState(() {
        //clear lines
        clearLines();
        //check landing
        checkLanding();
        //check if game is over
        if (gameover == true) {
          timer.cancel();
          showGameOverDialog(context, currentScore, (){
          //reset game 
          resetGame();
          Navigator.pop(context);
        });
        }else if (pause == true){
          timer.cancel();
        }else if(isFast == false){
          timer.cancel();
        }
        //move current piece dow
      currentPiece.movePiece(Direction.dow);
      });
    });
 }

 //rotate piece
 void rotatePieces(){
  setState(() {currentPiece.rotatePiece();});
 }
 
 //clean lines
 void clearLines(){
  //step 1: loop through each row of the game board from bottom to top
  for (int row = columL - 1; row >= 0; row--) {
    //step 2: initiaize a variable to track if the row is full
    bool rowIsFull = true;
    //step 3: chack if the row if full (all columns in the row are filled with pieces)
    for (int column = 0; column < rowL; column++ ) {
      // if there´s an empty column, set rowIsFull to false and break the loop
      if (gameBoard[row][column] == null) {
        rowIsFull = false;
        break;
      }
    }
    //step 4: if the row is full, clear the row and shift rows down
    if (rowIsFull) {
      //step 5: move all rows above the cleared row dow by one position
      for (int r = row; r > 0; r--) {
        //copy the above row to the current row
        gameBoard[r] = List.from(gameBoard[r - 1]);
      }
      //step 6: set the top row to empty
      gameBoard[0] = List.generate(row, (i) => null);
      //step 7: increase the score!
      currentScore++;
    }
  }
 }

 //game over method 
 bool isGameOver(){
  //check if any coluns in the top row are filled
  for(int column = 0; column < rowL; column++){
    if (gameBoard[0][column] != null) {
      return true;
    }
  }
  return false;
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Score
      appBar: AppBar(
        toolbarHeight: 28,
        title: Text("Score: $currentScore"), 
        backgroundColor: const Color.fromARGB(135, 130, 130, 130),
        actions: [
          IconButton(
          splashRadius: 1,
          onPressed: (){
            if (pause == false) {
              pause = true;
            }else if(pause == true){
              pause = false;
              Duration frameRate = const Duration(milliseconds: 800); 
              //frame refresh rate
              gameLoop(frameRate);
            }
          },
          icon:  Icon(pause == false ? Icons.pause : Icons.play_arrow, color: Colors.white)),
        ],
        ),
      backgroundColor: const Color.fromARGB(135, 130, 130, 130),
      body: Column(
          children: [
            //Game grid
                Expanded(
                child: InkWell(
                  onDoubleTap: () => moveDown(),
                  child: Container(
                    color: const Color.fromARGB(255, 62, 113, 156),
                    child: GridView.builder(
                      itemCount: rowL * columL,
                      physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowL), 
                    itemBuilder: (context, index) {
                      //get row and column of each index
                      int row = (index/ rowL).floor();
                      int column = index % rowL;
                      //current piece
                      if (currentPiece.position.contains(index)) {
                        return PixelPage(color: Colors.yellow[400]);
                      //landed pieces
                        }else if(gameBoard[row][column] != null){
                          final Tetromino? tetraminoType = gameBoard[row][column];
                          return PixelPage(color: tetrominoColor[tetraminoType]);
                        }
                      //blank pixel
                        else{
                          return PixelPage(color: const Color.fromARGB(255, 0, 0, 0));
                        }
                      }
                      ),
                  ),
                ),
            ),
            //GAME CONTROLS
            Padding(padding: const EdgeInsets.only(bottom: 15.0, top: 3.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                //left 0
                myBotton(context, pause == false ? () => moveLeft() : (){}, 10, 40, 0),
                //right 1
                myBotton(context, pause == false ? () => moveRight() : (){}, 40, 10, 1)
                ]))],
        ),
      //GAME CONTROLS
       floatingActionButton: floatingBotton(onpress: pause == false ? () => rotatePieces() : (){}),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat
      //FloatingActionButtonLocation.centerFloat,
   );
  }
}