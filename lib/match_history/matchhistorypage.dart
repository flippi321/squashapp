import 'package:flutter/material.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({super.key});

  @override
  MatchHistoryState createState() => MatchHistoryState();
}

class MatchHistoryState extends State<MatchHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History'),
      ),
      body: const Text("This is the Match History Page")
    );
  }
}
