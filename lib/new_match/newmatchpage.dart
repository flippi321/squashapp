import 'package:flutter/material.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({super.key});

  @override
  NewMatchState createState() => NewMatchState();
}

class NewMatchState extends State<NewMatchPage> {
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
