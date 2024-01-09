import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int currentIndex;

  const CustomBottomAppBar({
    Key? key,
    required this.onItemSelected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => onItemSelected(1),
          ),
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => onItemSelected(2),
          ),
          FloatingActionButton(
            child: const Icon(Icons.add, size: 30,),
            onPressed: () => onItemSelected(3),
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () => onItemSelected(4),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => onItemSelected(5),
          ),
        ],
      ),
    );
  }
}
