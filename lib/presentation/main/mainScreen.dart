import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/addTask/addTask.dart';
import 'package:todo_app/presentation/allTasks/allTasks.dart';
import 'package:todo_app/presentation/completedTasks/completedTasks.dart';
import 'package:todo_app/presentation/components/components.dart';
import 'package:todo_app/presentation/cubit/bloc.dart';
import 'package:todo_app/presentation/cubit/states.dart';
import 'package:todo_app/presentation/favoriteTasks/favoriteTasks.dart';
import 'package:todo_app/presentation/uncomplitedTasks/uncompletedTasks.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TasksState>(
      listener: (context, state) {
        if(state is DatabaseInsertState){
          TasksBloc.get(context).initialValueOfRepeatList = TasksBloc.get(context).RepeatlistItems[0];
          TasksBloc.get(context).initialValueOfRemindList = TasksBloc.get(context).RemindlistItems[0];
        }else if(state is CheckBoxValueChangedState){

        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: mainButton(
              context: context,
              label: 'Add a task',
              function: () {
                TasksBloc.get(context).emit(AddTaskScreenState());
                print("add task");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddTaskScreen()));
              }),
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1.0,
            title: mainText(
                color: Colors.black, text: 'Board', weight: FontWeight.bold),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                ),
              )
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: [
                mainText(text: 'All'),
                mainText(text: 'Complited'),
                mainText(text: 'Uncomplited'),
                mainText(text: 'Favorite')
              ],
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.black,
              isScrollable: true,
              //to remove default padding between tabs(all tabs shrink)
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              //then set the needed padding
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              //selected tab color
              onTap: (value) {
                TasksBloc.get(context).currentIndex = value;
                TasksBloc.get(context).newStateTest(idx: value);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 80.0),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              //disable swiping between taps
              controller: tabController,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: TasksBloc.get(context).screens[0],
                ),
                TasksBloc.get(context).screens[1],
                TasksBloc.get(context).screens[2],
                TasksBloc.get(context).screens[3],
              ],
            ),
          ),
        );
      },
    );
  }
}
