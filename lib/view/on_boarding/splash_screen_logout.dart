import 'dart:async';
import 'package:FitnessX_App/common/color_extension.dart';
import 'package:FitnessX_App/view/on_boarding/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../dashboard/home/home.dart';

class Splash_Screen_Logout extends StatefulWidget {
  const Splash_Screen_Logout({super.key});

  @override
  State<Splash_Screen_Logout> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen_Logout> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome_Screen(),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Container(
        width: media.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: Tcolor.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "Fitness",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: media.width * 0.093,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "X",
                      style: TextStyle(
                        color: Tcolor.white,
                        fontSize: media.width * 0.13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
