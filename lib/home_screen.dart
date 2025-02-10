import 'package:flutter/material.dart';
import 'package:tic_tac/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'x';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  ...firstBlock(),
                  SizedBox(
                    height: 50,
                  ),
                  _expanded(),
                  ...lastBlock(),
                ],
              )
            : Row(children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...firstBlock(),
                      SizedBox(
                        height: 50,
                      ),
                      ...lastBlock(),
                    ],
                  ),
                ),
                _expanded(),
              ]),
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: Text(
          'Turn on/off two player ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          //textAlign: TextAlign.center,
        ),
        value: isSwitched,
        activeColor: Colors.white,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
      SizedBox(
        height: 40,
      ),
      Text(
        'It\'s $activePlayer turn'.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).splashColor,
        ),
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = '';
          });
        },
        label: Text(
          'Repeat the game',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: Icon(
          Icons.replay,
          color: Colors.white,
        ),
      )
    ];
  }

    _expanded() {
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.all(16.0),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: gameOver ? null : () => onTapItem(index),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'x'
                      : Player.playerO.contains(index)
                          ? 'o'
                          : '',
                  style: TextStyle(
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.red,
                    fontSize: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTapItem(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(activePlayer, index);
      updateState();
      if (!isSwitched && !gameOver) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'x') ? 'o' : 'x';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the winner';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw';
        gameOver = true;
      }
    });
  }
}
