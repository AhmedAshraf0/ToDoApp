import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/presentation/addTask/widgets/addTasksWidgets.dart';
import 'package:todo_app/presentation/components/components.dart';
import 'package:todo_app/presentation/cubit/bloc.dart';
import 'package:todo_app/presentation/cubit/states.dart';
import 'package:todo_app/presentation/styles/colors.dart';

class AddTaskScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController startCustomTimeController = TextEditingController();
  TextEditingController customDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TimeOfDay? timeOfDay;
  DateTime? dateTime;

  AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 15.0,
          ),
        ),
        title: mainText(
            color: Colors.black, text: 'Add task', weight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainText(text: 'Title', weight: FontWeight.bold),
                mainSmallSizedBox(),
                MainTextFormField(
                    TextFormFieldMainController: titleController,
                    MainTextInputType: TextInputType.text,
                    context: context,
                    validatorMessage: 'You must enter title task!',
                    hintText: 'Online interview meeting'),
                mainBigSizedBox(),
                mainText(text: 'Date', weight: FontWeight.bold),
                mainSmallSizedBox(),
                MainTextFormField(
                  MainTextInputType: TextInputType.datetime,
                  TextFormFieldMainController: deadlineController,
                  hintText: '2022-07-20',
                  hintTextSize: 16,
                  validatorMessage: 'You must enter deadline for the task!',
                  icon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey.withOpacity(0.5),
                      size: 22,
                    ),
                  ),
                  context: context,
                  onTapFunction: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 360)),
                    ).then((value) {
                      deadlineController.text =
                          DateFormat.yMMMd().format(value!).toString();
                    });
                  },
                ),
                mainBigSizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mainText(text: 'Start Time', weight: FontWeight.bold),
                        mainSmallSizedBox(),
                        SizedBox(
                          width: 149,
                          child: MainTextFormField(
                              MainTextInputType: TextInputType.datetime,
                              hintText: '11:00 Am',
                              validatorMessage: 'You must enter a start time!',
                              context: context,
                              icon: Icon(
                                Icons.watch_later_outlined,
                                size: 18,
                              ),
                              TextFormFieldMainController: startTimeController,
                              onTapFunction: () {
                                MainShowTimePicker(
                                    context: context,
                                    controller: startTimeController);
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mainText(text: 'End Time', weight: FontWeight.bold),
                        mainSmallSizedBox(),
                        SizedBox(
                          width: 149,
                          child: MainTextFormField(
                              MainTextInputType: TextInputType.datetime,
                              hintText: '14:00 Pm',
                              validatorMessage: 'You must enter an end time!',
                              context: context,
                              icon: Icon(
                                Icons.watch_later_outlined,
                                size: 18,
                              ),
                              TextFormFieldMainController: endTimeController,
                              onTapFunction: () {
                                MainShowTimePicker(
                                    controller: endTimeController,
                                    context: context);
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
                mainBigSizedBox(),
                mainText(text: 'Remind', weight: FontWeight.bold),
                mainSmallSizedBox(),
                BlocConsumer<TasksBloc, TasksState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 58.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            value:
                                TasksBloc.get(context).initialValueOfRemindList,
                            icon: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.grey.withOpacity(0.5),
                                size: 22,
                              ),
                            ),
                            isExpanded: true,
                            items:
                                TasksBloc.get(context).RemindlistItems.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                              print('VALUE CAHNAGED');
                              if (value == 'Custom') {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Align(
                                        alignment: Alignment.topCenter,
                                        child: mainText(
                                            text: 'Custom Remind',
                                            weight: FontWeight.bold),
                                      ),
                                      content: Form(
                                        key: _formKey2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            mainText(
                                              text:
                                                  'Please choose date and time:',
                                            ),
                                            mainBigSizedBox(),
                                            Row(
                                              children: [
                                                mainText(
                                                  text: 'Time',
                                                  weight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 145,
                                                  child: MainTextFormField(
                                                      MainTextInputType:
                                                          TextInputType
                                                              .datetime,
                                                      hintText: '11:00 Am',
                                                      validatorMessage:
                                                          'Time missed!',
                                                      context: context,
                                                      icon: Icon(
                                                        Icons
                                                            .watch_later_outlined,
                                                        size: 18,
                                                      ),
                                                      TextFormFieldMainController:
                                                          startCustomTimeController,
                                                      onTapFunction: () {
                                                        showTimePicker(
                                                                context:
                                                                    context,
                                                                initialTime:
                                                                    TimeOfDay
                                                                        .now())
                                                            .then((value) {
                                                          startCustomTimeController
                                                                  .text =
                                                              value!
                                                                  .format(
                                                                      context)
                                                                  .toString();
                                                          timeOfDay = value;
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                            mainBigSizedBox(),
                                            Row(
                                              children: [
                                                mainText(
                                                  text: 'Date',
                                                  weight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  width: 19,
                                                ),
                                                SizedBox(
                                                  width: 145,
                                                  child: MainTextFormField(
                                                      MainTextInputType:
                                                          TextInputType
                                                              .datetime,
                                                      hintText: '2022-07-20',
                                                      validatorMessage:
                                                          'Date is missed!',
                                                      context: context,
                                                      icon: Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        size: 18,
                                                      ),
                                                      TextFormFieldMainController:
                                                          customDateController,
                                                      onTapFunction: () {
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate: DateTime
                                                                  .now()
                                                              .add(
                                                                  const Duration(
                                                                      days:
                                                                          360)),
                                                        ).then((value) {
                                                          customDateController
                                                                  .text =
                                                              DateFormat.yMMMd()
                                                                  .format(
                                                                      value!)
                                                                  .toString();
                                                          dateTime = value;
                                                          print("testing date" +
                                                              dateTime
                                                                  .toString());
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            if (_formKey2.currentState!
                                                .validate()) {
                                              TasksBloc.get(context)
                                                  .addToRemindList(
                                                      dateTime: dateTime,
                                                      timeOfDay: timeOfDay);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: mainText(
                                              text: 'OK', color: buttonColor),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: mainText(
                                              text: 'CANCEL',
                                              color: buttonColor),
                                        ),
                                      ],
                                    );
                                  },
                                  barrierDismissible: true,
                                );
                              }
                              TasksBloc.get(context)
                                  .dropDownMenuOfRemindChanged(newValue: value);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                mainBigSizedBox(),
                mainText(text: 'Repeat', weight: FontWeight.bold),
                mainSmallSizedBox(),
                BlocConsumer<TasksBloc, TasksState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 58.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            value:
                                TasksBloc.get(context).initialValueOfRepeatList,
                            icon: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.grey.withOpacity(0.5),
                                size: 22,
                              ),
                            ),
                            isExpanded: true,
                            items:
                                TasksBloc.get(context).RepeatlistItems.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                              print('VALUE CAHNAGED in repeat');
                              TasksBloc.get(context)
                                  .dropDownMenuOfRepeatChanged(newValue: value);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 50.0,
                ),
                mainButton(
                    context: context,
                    label: 'Create a Task',
                    width: double.infinity,
                    function: () {
                      print("creat task button pressed");
                      if (_formKey.currentState!.validate()) {
                        TasksBloc.get(context).insertAppDatabase(
                            deadline: deadlineController.text,
                            endTime: endTimeController.text,
                            isTaskDone: 0,
                            startTime: startTimeController.text,
                            remind:
                                TasksBloc.get(context).initialValueOfRemindList,
                            repeat:
                                TasksBloc.get(context).initialValueOfRepeatList,
                            title: titleController.text,
                            favorite: 0);
                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
