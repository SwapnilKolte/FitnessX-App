import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../../../common/color_extension.dart';
import '../workout_tracker_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:FitnessX_App/view/workout_tracker/Fullbody_workouts/full_cs.dart';

class full_chs extends StatefulWidget {
  @override
  _full_chsState createState() => _full_chsState();
}

class _full_chsState extends State<full_chs> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  late VideoPlayerController _controller;
  late Timer _timer;
  int _countdownSeconds = 20;
  bool _isPlaying = true;

  Future<void> updateWorkoutsNode(int currentDay) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.reference().child('users/$userId/workouts_count');

        DateTime now = DateTime.now();
        String dayName = getDayName(now.weekday);

        if (currentDay == now.weekday) {
          await ref.child(dayName).set(ServerValue.increment(1));
          print('Workouts node updated successfully.');
        } else {
          print('Not updating workouts node as it is not the current day.');
        }
      }
    } catch (e) {
      print('Error updating workouts node: $e');
    }
  }

  void updateCalories(int newCalories) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users/${user.uid}');
        await userRef.update({'user_calories': newCalories});
        print('User calories updated successfully!');
      } else {
        print('User not found. Unable to update calories.');
      }
    } catch (e) {
      print('Error updating user calories: $e');
    }
  }

  String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/cobra.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isPlaying && _countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      } else if (_countdownSeconds == 0) {
        _handleCountdownFinish();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    _controller.pause();
    _timer.cancel();

    bool quitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to quit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Quit'),
          ),
        ],
      ),
    );

    if (!quitConfirmed) {
      _controller.play();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_isPlaying && _countdownSeconds > 0) {
          setState(() {
            _countdownSeconds--;
          });
        } else if (_countdownSeconds == 0) {
          _handleCountdownFinish();
        }
      });
    }

    return quitConfirmed ?? false;
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _handleCountdownFinish() {
    _controller.pause();
    int currentDay = DateTime.now().weekday;
    updateWorkoutsNode(currentDay);
    updateCalories(90); // Update user calories to 500
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WorkoutTrackerView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
              SizedBox(height: 100),
              Text(
                'Chest Stretch',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '${(_countdownSeconds ~/ 60).toString().padLeft(2, '0')}:${(_countdownSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: Tcolor.primaryG,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3366FF).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: _togglePlayPause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isPlaying ? 'Pause' : 'Resume',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 125,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: Tcolor.primaryG,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF3366FF).withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => full_cs()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Container(
                    width: 125,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: Tcolor.primaryG,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF3366FF).withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WorkoutTrackerView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
