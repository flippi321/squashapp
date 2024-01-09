import 'package:flutter/material.dart';
import 'package:squashmate/custom_assets/customnavigationbar.dart';
import 'package:squashmate/match_history/matchhistorypage.dart';
import 'package:squashmate/new_match/newmatchpage.dart';
import 'package:squashmate/scoreboard/scoreboardpage.dart';
import 'package:squashmate/user_profile/userprofilepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Home Page',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 1:
                // Navigate to Match History page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchHistoryPage()));
                break;
              case 2:
                // Navigate to Scoreboard page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ScoreboardPage()));
                break;
              case 3:
                // Navigate to New Match page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewMatchPage()));
                break;
              case 4:
                // Navigate to Feedback page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
                break;
              case 5:
                // Navigate to My Profile page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfilePage()));
                break;
              default:
                // Navigate to Home page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                break;
            }
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}