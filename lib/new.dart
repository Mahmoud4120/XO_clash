import 'package:flutter/material.dart';

class TicTacToeApp extends StatefulWidget {
  @override
  _TicTacToeAppState createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> {
  List<List<String?>> board = [
    [null, null, null],
    [null, null, null],
    [null, null, null]
  ];

  bool isXTurn = true; // الدور الحالي (X يبدأ دائمًا)
  String? winner;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("لعبة X O 🕹️")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              winner != null
                  ? "🎉 الفائز: $winner"
                  : (isBoardFull(board)
                      ? "🤝 التعادل!"
                      : "🚀 دور: ${isXTurn ? 'X' : 'O'}"),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildBoard(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: Text("🔄 إعادة اللعب"),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎮 **دالة بناء الشبكة (واجهة المستخدم)**
  Widget buildBoard() {
    return Column(
      children: List.generate(
          3,
          (row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3,
                        (col) => buildCell(row, col)),
              )),
    );
  }

  /// 📌 **إنشاء زر لكل خلية**
  Widget buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => makeMove(row, col),
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          board[row][col] ?? "",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 🏆 **تنفيذ الحركة والتحقق من الفائز**
  void makeMove(int row, int col) {
    if (board[row][col] != null || winner != null)
      return; // لا تغيير إذا كانت الخلية مشغولة أو هناك فائز

    setState(() {
      board[row][col] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn; // تبديل الدور
      winner = checkWinner(board); // التحقق من الفائز
    });
  }

  /// 🔄 **إعادة تعيين اللعبة**
  void resetGame() {
    setState(() {
      board = [
        [null, null, null],
        [null, null, null],
        [null, null, null]
      ];
      isXTurn = true;
      winner = null;
    });
  }
}

/// 🔍 **دالة التحقق من الفائز**
String? checkWinner(List<List<String?>> board) {
  // ✅ التحقق من الصفوف
  for (var row in board) {
    if (row[0] != null && row[0] == row[1] && row[1] == row[2]) {
      return row[0]; // الفائز في الصف
    }
  }

  // ✅ التحقق من الأعمدة
  for (int col = 0; col < 3; col++) {
    if (board[0][col] != null &&
        board[0][col] == board[1][col] &&
        board[1][col] == board[2][col]) {
      return board[0][col]; // الفائز في العمود
    }
  }

  // ✅ التحقق من القطر الرئيسي (↘)
  if (board[0][0] != null &&
      board[0][0] == board[1][1] &&
      board[1][1] == board[2][2]) {
    return board[0][0]; // الفائز في القطر الرئيسي
  }

  // ✅ التحقق من القطر الثانوي (↙)
  if (board[0][2] != null &&
      board[0][2] == board[1][1] &&
      board[1][1] == board[2][0]) {
    return board[0][2]; // الفائز في القطر الثانوي
  }

  return null; // ❌ لا يوجد فائز بعد
}

/// 🔄 **دالة التحقق من التعادل**
bool isBoardFull(List<List<String?>> board) {
  for (var row in board) {
    for (var cell in row) {
      if (cell == null) {
        return false; // لا تزال هناك خانات فارغة
      }
    }
  }
  return true; // ✅ كل الخانات ممتلئة
}
