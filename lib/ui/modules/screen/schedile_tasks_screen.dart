import 'dart:math';

import 'package:algoriza_task2_todo_app/cubit/app_cubit.dart';
import 'package:algoriza_task2_todo_app/cubit/app_states.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ScheduleTasksScreen extends StatelessWidget {
  const ScheduleTasksScreen({Key? key}) : super(key: key);
  static const routeName = 'Schedule';

  @override
  Widget build(BuildContext context) {
    var gr = Random();

    List<Color> color = [
      Colors.red.shade600,
      Colors.orange.shade600,
      Colors.amber.shade600,
      Colors.blue.shade600
    ];
    return BlocProvider(
      create: (context) => AppCubit()..getDataFromDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit().get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_rounded),
              ),
              title: const Text("Schedule"),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: DatePicker(
                          DateTime.now(),
                          controller: cubit.datePickerController,
                          onDateChange: (s) => cubit.onDateChange(s),
                          width: 60,
                          height: 80,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Colors.green,
                          selectedTextColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${DateFormat('EEEE').format(cubit.selectedDateTime)}'),
                      Text(
                          '${DateFormat.yMMMMd().format(cubit.selectedDateTime)}'),
                      // 'YYYYMMMDD'
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      // cubit.scheduledNotification(
                      //     int.parse(newHour),  int.parse(newMinutes), cubit.taskList[index]);
                      // cubit.scheduledNotification(hour, minutes, task);
                      if (cubit.taskList[index].date ==
                              DateFormat.yMd().format(cubit.selectedDateTime) ||
                          cubit.taskList[index].repeat == 'Daily' ||
                          (cubit.taskList[index].repeat == "Weekly" &&
                              cubit.selectedDateTime
                                          .difference(DateFormat.yMd().parse(
                                              cubit.taskList[index].date!))
                                          .inDays %
                                      7 ==
                                  0) ||
                          (cubit.taskList[index].repeat == "Monthly" &&
                              DateFormat.yMd()
                                      .parse(cubit.taskList[index].date!)
                                      .day ==
                                  cubit.selectedDateTime.day)) {
                        return ListTile(
                          title: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: color[gr.nextInt(3)],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${cubit.taskList[index].startTime}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "${cubit.taskList[index].title}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Transform.scale(
                                      scale: 1.24,
                                      child: Checkbox(
                                        activeColor: Colors.black,
                                        value: cubit.completeTaskList[index]
                                                    .isCompleted ==
                                                0
                                            ? false
                                            : true,
                                        onChanged: (value) => cubit.upDataState(
                                            state: value == false ? 0 : 1,
                                            id: cubit
                                                .completeTaskList[index].id!),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                    itemCount: cubit.taskList.length,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
