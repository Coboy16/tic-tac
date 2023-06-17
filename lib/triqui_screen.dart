import 'dart:math';

import 'package:flutter/material.dart';

class TriquiApp extends StatefulWidget {
  const TriquiApp({super.key});

  @override
  State<TriquiApp> createState() => _TriquiAppState();
}

class _TriquiAppState extends State<TriquiApp> {
  List<List<String>> board = [];
  String currentPlayer = '';
  String winner = '';

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    // Inicializar el tablero vacío
    board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
    currentPlayer = 'X';
    winner = '';
  }

  void makeMove(int row, int col) {
    if (board[row][col] == '' && winner == '') {
      setState(() {
        board[row][col] = currentPlayer;
        checkWinner();

        if (winner == '') {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
          if (currentPlayer == 'O') {
            makeAIMove();
          }
        }
      });
    }
  }

  void checkWinner() {
    // Comprobar filas
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][0] == board[i][2]) {
        setState(() {
          winner = board[i][0];
        });
        return;
      }
    }

    // Comprobar columnas
    for (int i = 0; i < 3; i++) {
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[0][i] == board[2][i]) {
        setState(() {
          winner = board[0][i];
        });
        return;
      }
    }

    // Comprobar diagonales
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[0][0] == board[2][2]) {
      setState(() {
        winner = board[0][0];
      });
      return;
    }

    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[0][2] == board[2][0]) {
      setState(() {
        winner = board[0][2];
      });
      return;
    }

    // Comprobar empate
    bool isBoardFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          isBoardFull = false;
          break;
        }
      }
    }
    if (isBoardFull) {
      setState(() {
        winner = 'Empate';
      });
    }
  }

  void makeAIMove() {
    int bestScore = -9999;
    int bestMoveRow = -1;
    int bestMoveCol = -1;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          board[i][j] = 'O';
          int score = minimax(board, 0, false, -9999, 9999);
          board[i][j] = '';

          if (score > bestScore) {
            bestScore = score;
            bestMoveRow = i;
            bestMoveCol = j;
          }
        }
      }
    }

    if (bestMoveRow != -1 && bestMoveCol != -1) {
      setState(() {
        board[bestMoveRow][bestMoveCol] = 'O';
        checkWinner();
        currentPlayer = 'X';
      });
    }
  }

  int minimax(List<List<String>> board, int depth, bool isMaximizingPlayer,
      int alpha, int beta) {
    String result = checkGameResult(board);
    if (result != null) {
      if (result == 'X') {
        return -1;
      } else if (result == 'O') {
        return 1;
      } else {
        return 0;
      }
    }

    if (isMaximizingPlayer) {
      int bestScore = -9999;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'O';
            int score = minimax(board, depth + 1, false, alpha, beta);
            board[i][j] = '';
            bestScore = max(bestScore, score);
            alpha = max(alpha, bestScore);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 9999;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'X';
            int score = minimax(board, depth + 1, true, alpha, beta);
            board[i][j] = '';
            bestScore = min(bestScore, score);
            beta = min(beta, bestScore);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }
      return bestScore;
    }
  }

  String checkGameResult(List<List<String>> board) {
    // Comprobar filas
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][0] == board[i][2]) {
        return board[i][0];
      }
    }

    // Comprobar columnas
    for (int i = 0; i < 3; i++) {
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[0][i] == board[2][i]) {
        return board[0][i];
      }
    }

    // Comprobar diagonales
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[0][0] == board[2][2]) {
      return board[0][0];
    }

    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[0][2] == board[2][0]) {
      return board[0][2];
    }

    // Comprobar empate
    bool isBoardFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          isBoardFull = false;
          break;
        }
      }
    }
    if (isBoardFull) {
      return 'Empate';
    }

    return '';
  }

  Widget buildCell(int row, int col) {
    return GestureDetector(
      onTap: () {
        makeMove(row, col);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        width: 100.0,
        height: 100.0,
        child: Center(
          child: Text(
            board[row][col],
            style: const TextStyle(fontSize: 48.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Triqui'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Turno de: $currentPlayer',
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 20.0),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: 9,
            itemBuilder: (BuildContext context, int index) {
              int row = index ~/ 3;
              int col = index % 3;
              return buildCell(row, col);
            },
          ),
          const SizedBox(height: 20.0),
          winner != null
              ? Text(
                  'Ganador: $winner',
                  style: const TextStyle(fontSize: 24.0),
                )
              : Container(),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: startGame,
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
