import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int currentIndex;

  const CustomNavigationBar({
    Key? key,
    required this.onItemSelected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onItemSelected,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Match History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Scoreboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Profile',
            ),
          ],
        ),
        Positioned(
          bottom: 8.0, // Adjust the height as needed
          left: MediaQuery.of(context).size.width / 2 - 28.0, // Center the button horizontally
          child: ElevatedButton(
            onPressed: () {
              // Add your functionality for the circular button here
              // You can use the same onItemSelected method or define a new one
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16.0),
            ),
            child: const Icon(Icons.add, size: 28.0),
          ),
        ),
      ],
    );
  }
}
