import 'package:flutter/material.dart';
import 'package:todo_app/presentation/components/components.dart';
import 'package:todo_app/presentation/cubit/bloc.dart';


//sized box and column to be removed when using the spacer in listview
Widget task({required Color color, required String title , required context , required int idx}) => Column(
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                onChanged: (bool? value) {
                  TasksBloc.get(context).checkBoxValueChanged(newValue: value , idx: idx);
                },
                value: (TasksBloc.get(context).databaseList[idx]['isTaskDone']) == 1 ? true : false,
                activeColor: color,
                side: BorderSide(
                  color: color,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            mainText(text: title , size: 17.4 , overflowValue: TextOverflow.ellipsis),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
