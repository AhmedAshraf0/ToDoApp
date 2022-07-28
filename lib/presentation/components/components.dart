import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_app/presentation/addTask/addTask.dart';
import 'package:todo_app/presentation/styles/colors.dart';

Widget mainText({
  required String text,
  Color? color,
  FontWeight? weight,
  double? size,
  TextOverflow? overflowValue,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: weight,
      fontSize: size,
      overflow: overflowValue,
    ),
  );
}

Widget mainButton({required context , double? width = 325.8 , required String label , required VoidCallback function}) {
  return Container(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: MaterialButton(
      padding: const EdgeInsets.all(20.0),
      onPressed: function,
      color: buttonColor,
      minWidth: width,
      height: 50.0,
      child: mainText(text: label, color: Colors.white, size: 18),
    ),
  );
}

Widget mainBigSizedBox() => const SizedBox(
  height: 20.0,
);

Widget mainSmallSizedBox() => const SizedBox(
  height: 10.0,
);
