import 'package:fitness_app/common_widget/round_button2.dart';

import '../../common_widget/round_button.dart';
import 'package:flutter/material.dart';

import  '../../common/color_extension.dart';
import '../view/meal_planner/meal_food_details_view.dart';

class FindEatCell extends StatelessWidget {
  final Map fObj;
  final int index;
  const FindEatCell({Key? key, required this.index, required this.fObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;
    double containerWidth = media.width > 600 ? media.width * 0.4 : media.width * 0.5;
    double imageWidth = media.width > 600 ? media.width * 0.3 : media.width * 0.25;
    double buttonWidth = media.width > 600 ? 120 : 90;
    double buttonFontSize = media.width > 600 ? 14 : 12;

    return Container(
      margin: const EdgeInsets.all(8),
      width: containerWidth,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEvent
                ? [
              Tcolor.primaryColor2.withOpacity(0.5),
              Tcolor.primaryColor1.withOpacity(0.5)
            ]
                : [
              Tcolor.secondaryColor2.withOpacity(0.5),
              Tcolor.secondaryColor1.withOpacity(0.5)
            ],
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(75),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                fObj["image"].toString(),
                width: imageWidth,
                height: imageWidth * 0.75, // Adjust aspect ratio
                fit: BoxFit.contain,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["name"],
              style: TextStyle(
                  color: Tcolor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["number"],
              style: TextStyle(color: Tcolor.gray, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: buttonWidth,
              height: 35,
              child: RoundButton2(
                  fontSize: buttonFontSize,
                  type: isEvent
                      ? RoundButtonType.bgGradient
                      : RoundButtonType.bgSGradient,
                  title: "Select",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MealFoodDetailsView(eObj: fObj) ) );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
