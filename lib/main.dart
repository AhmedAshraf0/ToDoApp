import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/allTasks/allTasks.dart';
import 'package:todo_app/presentation/cubit/bloc.dart';
import 'package:todo_app/presentation/cubit/blocObserver.dart';
import 'package:todo_app/presentation/cubit/states.dart';
import 'package:todo_app/presentation/main/mainScreen.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksBloc()..createAppDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do',
        theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        home: MainScreen(),
      ),
    );
  }
}
