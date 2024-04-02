
// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tetris_game/pages/check_collision.dart';
import 'package:tetris_game/pages/game_over.dart';
import 'package:tetris_game/utils/floating_botton.dart';
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
  Piece currentPiece = Piece(type: Tetromino.O);
  //current score
  int currentScore = 0;
  //game over5
  bool gameover = false;
  //Fats
  bool isFast = true;
  //pause
  bool ispause = false;
  //show arrow left 
  bool arrowLeft = false;
  //show arrow right
  bool arrowRight = false;

  Duration onSec = const Duration(milliseconds: 200);
  
  Soundpool? _pool;
  SoundpoolOptions _soundpoolOptions = const SoundpoolOptions();
  int? _alarmSoundStreamId;
  dynamic alarmSound1;
  dynamic alarmSound2;
  dynamic alarmSound3;

  Soundpool? get _soundpool => _pool;

  @override
  void initState() {
    super.initState();
    //start game when app start
    startGame();
    _initPool(_soundpoolOptions);
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
        //pause game
        ispause == true ? timer.cancel() : null;
        //check landing
        checkLanding();
        //clear lines
        clearLines();
        //check if game is over
        gameover == true ?  {
          timer.cancel(),
          showGameOverDialog(context, currentScore, (){
          //reset game 
          resetGame();
          Navigator.pop(context);
        })
        } : null;
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

 void checkLanding() {
    // if going down is occupied or landed on other pieces
    if (checkCollision(Direction.dow, currentPiece.position) || checkLanded()) {
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

  bool checkSides(Direction direccion){
    for (var i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowL).floor();
      int col = currentPiece.position[i] % rowL;

       if (direccion == Direction.left) {
        if (row + 1 < columL && row >= 0 && gameBoard[row][col - 1] != null) {
        return true; // collision with a landed piece
      }  
       }else if(direccion == Direction.right){
        if (row + 1 < columL && row >= 0 && gameBoard[row][col + 1] != null) {
        return true; // collision with a landed piece
      }
       }
    }
    return false;
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
  
  //Move left o right
  void movePieces(Direction direction){
    if (!checkCollision(direction, currentPiece.position) && !checkSides(direction)) {
        setState(() {currentPiece.movePiece(direction);});
    }
  }
 

 //move down fast
 void moveDown(){
  isFast = true;
  Duration frameRate = const Duration(milliseconds: 100); 
  Timer.periodic(
      frameRate,
    (timer) {
      setState(() {
        //pause game
        ispause == true ? timer.cancel() : null;
        isFast == false ? timer.cancel() : null;
        //check landing
        checkLanding();
        //clear lines
        clearLines();
        //check if game is over
        gameover == true? {
          timer.cancel(),
          showGameOverDialog(context, currentScore, (){
          //reset game 
          resetGame();
          Navigator.pop(context);
        }),
        } : null;
 
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
 void clearLines() async{
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
      await playSound(alarmSound3);
      //step 5: move all rows above the cleared row dow by one position
      for (int r = row; r > 0; r--) {
        //copy the above row to the current row
        gameBoard[r] = List.from(gameBoard[r - 1]);}
      //step 6: set the top row to empty
      gameBoard[0] = List.generate(rowL, (i) => null);
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
    return SafeArea(
      child: Scaffold(
        //Score
        appBar: AppBar(
          toolbarHeight: 40,
          title: Text("Score: $currentScore"), 
          backgroundColor: const Color.fromARGB(135, 130, 130, 130),
          actions: [
            IconButton(
            splashRadius: 1,
            onPressed: (){
              if (ispause == false) {
                ispause = true;
              }else if(ispause == true){
                ispause = false;
                Duration frameRate = const Duration(milliseconds: 800); 
                //frame refresh rate
                gameLoop(frameRate);
              }
            },
            icon:  Icon(ispause == false ? Icons.pause : Icons.play_arrow, color: Colors.white)),
          ],
          ),
        backgroundColor: const Color.fromARGB(135, 130, 130, 130),
        body: body2(),
        //GAME CONTROLS
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
         floatingActionButton: Padding(
          padding: const EdgeInsets.all(10), child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            floatingBottonDown(
              onpress: ispause == false ? 
              () {moveDown();} : (){}),
              const SizedBox(width: 100),
              floatingBottonRotate(onpress: ispause == false ? () async {
              await playSound(alarmSound2);
              rotatePieces();} : (){})
           ]))
         ),
    );
  }
 
 //GAME CONTROLS>
  body2(){
  return Stack(
    children: [
       Container(
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
          return PixelPage(color: tetrominoColor[tetraminoType] );
        }
      //blank pixel
        else{
          return PixelPage(color: const Color.fromARGB(255, 0, 0, 0));
        }}
        )),
      
       //GAME CONTROLS
      Row(children: [
        Expanded(child: InkWell(onTap: ispause == false ? () async{
          //sound
          await playSound(alarmSound1);
          setState(() {arrowLeft = true;});
          Future.delayed(onSec, (){setState(() {arrowLeft = false;});});
          movePieces(Direction.left);} :() {}
          , child: Container(color: Colors.transparent,
          child: Center(
            child: Icon(Icons.keyboard_double_arrow_left, color: arrowLeft == true ? const Color.fromRGBO(106, 161, 206, 0.47) : Colors.transparent, size: 100))))),
          
          Expanded(child: InkWell(onTap: ispause == false ? () async {
            //sound
          await playSound(alarmSound1);
          setState(() {arrowRight = true;});
          Future.delayed(onSec, (){setState(() {arrowRight = false;});});
          movePieces(Direction.right);} 
          :() {}
          ,child: Container(color: Colors.transparent,
          child:  Center(
            child: Icon(Icons.keyboard_double_arrow_right, color: arrowRight == true ? const Color.fromRGBO(106, 161, 206, 0.47) : Colors.transparent,size: 100)))))])
    ],
  );
}

void _initPool(SoundpoolOptions soundpoolOptions) async {
    _pool?.dispose();
    setState(() {
      _soundpoolOptions = soundpoolOptions;
      _pool = Soundpool.fromOptions(options: _soundpoolOptions);});
    alarmSound1 = await _loadSound1();
    alarmSound2 = await _loadSound2();
    alarmSound3 = await _loadSound3();
    }

  Future<int> _loadSound1() async {
    var asset = await rootBundle.load("assets/sounds/down.mp3");
    return await _soundpool!.load(asset);}

  Future<int> _loadSound2() async {
    var asset = await rootBundle.load("assets/sounds/rotate.mp3");
    return await _soundpool!.load(asset);}

    Future<int> _loadSound3() async {
    var asset = await rootBundle.load("assets/sounds/borrar.mp3");
    return await _soundpool!.load(asset);}

    Future<void> playSound(sound) async {
    _alarmSoundStreamId = await _soundpool!.play(sound);
  }

  Future<void> pauseSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool!.pause(_alarmSoundStreamId!);
    }
  }

  Future<void> stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool!.stop(_alarmSoundStreamId!);
    }
  }

}
