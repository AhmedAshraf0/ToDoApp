import 'package:flutter/material.dart';
import 'package:todo_app/presentation/styles/colors.dart';

class FavoriteTasks extends StatelessWidget {
  const FavoriteTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainColor color1 = MainColor();
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          color: color1.checkBoxColor,
        ),
      ],
    );
  }
}
