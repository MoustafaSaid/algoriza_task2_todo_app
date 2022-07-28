import 'dart:math';

import 'package:algoriza_task2_todo_app/cubit/app_cubit.dart';
import 'package:algoriza_task2_todo_app/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var gr = Random();
    List<Color> color = [Colors.red, Colors.orange, Colors.amber, Colors.blue];
    List<Color> color2 = [
      Colors.red.shade300,
      Colors.orange.shade300,
      Colors.amber.shade300,
      Colors.blue.shade300
    ];
    return BlocProvider(
      create: (context) => AppCubit()..getDataFromDatabase()..initializeNotification()
      ,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit().get(context);
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index,) {
                      var date = DateFormat.jm().parse(cubit.taskList[index].startTime!);
                      var myTime = DateFormat('HH:mm').format(date);
                      var newHour=myTime.split(':')[0];
                      var newMinutes=myTime.split(':')[1];
                      cubit.scheduledNotification( int.parse(newHour), int.parse(newMinutes), cubit.taskList[index]);
                      return ListTile(
                        leading: Transform.scale(
                          scale: 3 / 2,
                          child: Checkbox(
                              activeColor: color[gr.nextInt(3)],
                              side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 1.5, color: color2[gr.nextInt(3)]),
                              ),
                              checkColor: Colors.white,
                              value: cubit.taskList[index].isCompleted == 0
                                  ? false
                                  : true,
                              // onChanged: (s){},
                              onChanged: (value)=>cubit.upDataState(state: value==false?0:1,id: cubit.taskList[index].id!),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        title: Text(cubit.taskList[index].title!),
                        trailing: DropdownButton(
                          icon: const Icon(Icons.more_vert_outlined),
                          underline: Container(),
                          onChanged: (s) {},
                          items: [
                            DropdownMenuItem(

                              value: 'completed',
                              onTap: ()=>cubit.makeTaskStateComplete(cubit.taskList[index].id),

                              child: const Text("completed"),
                              
                            ),
                            DropdownMenuItem(
                              value: 'uncompleted',
                              onTap: ()=>cubit.makeTaskStateUnComplete(cubit.taskList[index].id),
                              child: const Text("uncompleted"),

                            ),
                            DropdownMenuItem(
                              value: 'favourite',
                              onTap: ()=>cubit.makeTaskStateFavourite(cubit.taskList[index].id),
                              child: const Text("favourite"),
                            ),
                             DropdownMenuItem(
                              value: 'delete',
                              onTap: ()=>cubit.deleteTaskFromDatabase(cubit.taskList[index].id!),

                              child:const Text("delete"),
                            ),
                          ],
                        ),
                      );
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
