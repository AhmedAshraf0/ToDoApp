import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:todo_app/models/taskStructure.dart';
import 'package:todo_app/presentation/components/components.dart';
import 'package:todo_app/presentation/cubit/bloc.dart';
import 'package:todo_app/presentation/cubit/states.dart';
import 'package:todo_app/presentation/styles/colors.dart';

class AllTasks extends StatelessWidget {
  AllTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is DatabaseGetDataState) {
          // TasksBloc.get(context).emit(AddTaskScreenRefreshState());
        }
      },
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context , idx){
            return mainBigSizedBox();
          },
          itemBuilder: (BuildContext context , int idx){
            MainColor color1 = MainColor();
            return task(
              color: color1.checkBoxColor,
              context: context,
              title: TasksBloc.get(context).databaseList[idx]['title'],
              idx: idx,
            );
          },
          itemCount: TasksBloc.get(context).databaseList.length,
        );
      },
    );
  }
}
