import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/presentation/allTasks/allTasks.dart';
import 'package:todo_app/presentation/completedTasks/completedTasks.dart';
import 'package:todo_app/presentation/cubit/states.dart';
import 'package:todo_app/presentation/favoriteTasks/favoriteTasks.dart';
import 'package:todo_app/presentation/uncomplitedTasks/uncompletedTasks.dart';
import 'package:path/path.dart' as p;

class TasksBloc extends Cubit<TasksState> {
  TasksBloc() : super(TasksInitialState());

  late Database database;
  int currentIndex = 0;
  bool checkBoxValue = false;
  String initialValueOfRemindList = '5 minutes early';
  String initialValueOfRepeatList = 'Daily';

  List<Widget> screens = [
    AllTasks(),
    CompletedTasks(),
    UnCompletedTasks(),
    FavoriteTasks(),
  ];
  List<String> RemindlistItems = [
    '5 minutes early',
    '10 minutes early',
    '15 minutes early',
    '30 minutes early',
    'One hour early',
    'One day early',
    'Custom',
  ];
  List<String> RepeatlistItems = [
    'Daily',
    'Weekly',
    'Monthly',
    'Every year',
  ];
  List<Map> databaseList = [];

  static TasksBloc get(context) => BlocProvider.of<TasksBloc>(context);

  void newStateTest({required int idx}) {
    if (idx == 0) {
      emit(AllTasksState());
    } else if (idx == 1) {
      emit(CompletedTaskState());
    } else if (idx == 2) {
      emit(UnCompletedTaskState());
    } else {
      emit(FavoriteTaskState());
    }
  }

  void checkBoxValueChanged({required newValue, required int idx}) {
    // emit(CheckBoxValueChangedState());

    updateAppDatabase(
        title: databaseList[idx]['title'],
        favorite: databaseList[idx]['favorite'],
        repeat: databaseList[idx]['repeat'],
        remind: databaseList[idx]['remind'],
        startTime: databaseList[idx]['startTime'],
        isTaskDone: databaseList[idx]['isTaskDone']!,
        endTime: databaseList[idx]['endTime'],
        deadline: databaseList[idx]['deadline'],
        id: idx);
  }

  void dropDownMenuOfRemindChanged({required newValue}) {
    initialValueOfRemindList = newValue;
    emit(DropDownMenuChangedState());
  }

  void dropDownMenuOfRepeatChanged({required newValue}) {
    initialValueOfRepeatList = newValue;
    emit(DropDownMenuChangedState());
  }

  void addToRemindList(
      {required TimeOfDay? timeOfDay, required DateTime? dateTime}) {
    Map<String, String>? map1;
    final dayDifference = dateTime!.difference(DateTime.now());
    print('----------from day difference' + dayDifference.inDays.toString());
    print('----------from day difference' + timeOfDay.toString());
    int hourDifference = timeOfDay!.hour - TimeOfDay.now().hour;
    int minuteDifference = timeOfDay!.minute;
    int? plusOne = 0;
    // print("-----------hours difference"+timeOfDay.hour.toString()+'\nminutes'+timeOfDay.minute.toString());
    int? missedHours, missedMinutes;
    if (TimeOfDay.now().period.name == 'am') {
      //how much hours are left until the rest of the day
      missedHours = 23 - TimeOfDay.now().hour;
      print(missedHours.toString() + 'missedhours');
    } else {
      missedHours = TimeOfDay.now().hour - 11;
    }
    missedMinutes = 60 - TimeOfDay.now().minute;
    print(missedMinutes.toString() + 'missedMinutes');
    if (hourDifference < 0) //if 3-23
      hourDifference += 23;
    minuteDifference += missedMinutes;
    if (missedMinutes >= 60) {
      hourDifference += (missedMinutes / 60) as int;
      missedMinutes %= 60;
    }
    hourDifference += missedHours;
    if (hourDifference >= 23) {
      plusOne = 1;
      hourDifference %= 23;
    }
    RemindlistItems.add('Before ' +
        (dayDifference.inDays + plusOne!).toString() +
        ' Days , ' +
        hourDifference.toString() +
        ':' +
        minuteDifference.toString() +
        ' H:M');
    emit(CustomChangeDropMenuState());
    dropDownMenuOfRemindChanged(newValue: RemindlistItems.last);
  }

  //sqflite

  void createAppDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'tasks.db');
    openAppDatabase(path: path);
    // deleteDb(path: path);
  }

  void openAppDatabase({required String path}) async {
    await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      debugPrint('Database Created');
      await db
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, deadline TEXT, startTime TEXT , endTime TEXT, remind TEXT , repeat TEXT , isTaskDone INTEGER , favorite INTEGER)')
          .then((value) {
        debugPrint('Table Created');
      }).catchError((error) {
        debugPrint('Error while creating database');
      });
    }, onOpen: (Database db) {
      emit(DatabaseCreatedState());
      debugPrint('Database Opened');
      database = db;
      getAppDatabase();
    });
  }

  void insertAppDatabase(
      {required String title,
      deadline,
      startTime,
      endTime,
      remind,
      repeat,
      isTaskDone,
      required int favorite}) {
    database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Tasks(title, deadline, startTime, endTime, remind, repeat, isTaskDone, favorite) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
          [
            title,
            deadline,
            startTime,
            endTime,
            remind,
            repeat,
            isTaskDone,
            favorite
          ]);
    }).then((value) {
      debugPrint(value.toString() + ' inserted successfully');
      emit(DatabaseInsertState());
    }).catchError((e) {
      debugPrint(e.toString() + 'from insert database');
    });
  }

  void getAppDatabase() async {
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      debugPrint('Data is here');
      databaseList = value;
      print(databaseList.length);
      emit(DatabaseGetDataState());
    });
  }

  void updateAppDatabase(
      {required String title,
      deadline,
      startTime,
      endTime,
      remind,
      repeat,
      isTaskDone,
      required int favorite,
      id}) async {
    await database.rawUpdate(
        '''UPDATE Tasks SET title = ?, deadline = ?, startTime = ?, endTime = ?,
         remind = ?, repeat = ?, isTaskDone = ?, favorite = ? WHERE id = $id''',
        [
          title,
          deadline,
          startTime,
          endTime,
          remind,
          repeat,
          isTaskDone,
          favorite
        ]);
    getAppDatabase();
  }

  void deleteDb({required path}) {
    deleteDatabase(path).then((value) {
      debugPrint('database deleted s');
    });
  }
}
