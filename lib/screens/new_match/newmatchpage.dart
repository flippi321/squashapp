import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squashmate/models/match_model.dart';
import 'package:squashmate/models/user_model.dart';
import 'package:squashmate/services/auth_service.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({Key? key}) : super(key: key);

  @override
  NewMatchState createState() => NewMatchState();
}

class NewMatchState extends State<NewMatchPage> {
  late UserModel leftUser;
  late UserModel rightUser;
  late AuthService authService;
  int leftUserCounter = 0;
  int rightUserCounter = 0;
  String errorMessage = "";

  // TODO Fetch all users form backend
  List<UserModel> getUsers() {
    List<UserModel> users = [];
    UserModel user1 = const UserModel(
        username: "bruker1", firstName: "Navn", lastName: "Navnessen");
    UserModel user2 = const UserModel(
        username: "bruker2", firstName: "Ole", lastName: "Nordmann");
    users.add(user1);
    users.add(user2);
    if (authService.currentUser != null) {
      users.add(authService.currentUser!);
    }
    return users;
  }

  // Actually save match
  saveMatch(context) {
    // We need to update the state if we change the error screen
    setState(
      () {
        if (leftUser.username == rightUser.username) {
          errorMessage = "A match can't be played between you and yourself...";
        } else if (leftUserCounter <= 0 && rightUserCounter <= 0) {
          errorMessage = "At least one user has to win a rally";
        } else {
          MatchModel match = MatchModel(
            matchDate: Timestamp.now(),
            player1: leftUser.username,
            player2: rightUser.username,
          );
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Get user information from AuthService
    authService = context.read<AuthService>();
    leftUser = authService.currentUser!;
    rightUser = getUsers().first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Match'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              buildColumn(true),
              buildColumn(false),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              saveMatch(context);
            },
            child: const Text("Done"),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  // Built one of the columns
  Widget buildColumn(bool isLeftColumn) {
    List<UserModel> users = getUsers();

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isLeftColumn ? "Opponent 1" : "Opponent 2",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<UserModel>(
            value: isLeftColumn ? leftUser : rightUser,
            key: UniqueKey(), // Add this line to ensure uniqueness
            onChanged: (newValue) {
              setState(() {
                if (isLeftColumn) {
                  leftUser = newValue!;
                } else {
                  rightUser = newValue!;
                }
              });
            },
            items: users.map((user) {
              return DropdownMenuItem<UserModel>(
                key: UniqueKey(), // Add this line to ensure uniqueness
                value: user,
                child: Text("${user.firstName} ${user.lastName}"),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            "Rallies",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          buildRalliesCounter(isLeftColumn),
        ],
      ),
    );
  }

  Widget buildRalliesCounter(bool isLeftColumn) {
    final counter = isLeftColumn ? leftUserCounter : rightUserCounter;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (isLeftColumn && leftUserCounter > 0) {
                leftUserCounter--;
              } else if (!isLeftColumn && rightUserCounter > 0) {
                rightUserCounter--;
              }
            });
          },
          icon: const Icon(Icons.remove),
        ),
        Text(
          '$counter',
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (isLeftColumn && leftUserCounter < 99) {
                leftUserCounter++;
              } else if (!isLeftColumn && rightUserCounter < 99) {
                rightUserCounter++;
              }
            });
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
