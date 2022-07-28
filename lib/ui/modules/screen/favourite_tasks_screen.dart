import 'dart:math';

import 'package:algoriza_task2_todo_app/cubit/app_cubit.dart';
import 'package:algoriza_task2_todo_app/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteTasksScreen extends StatelessWidget {
  const FavouriteTasksScreen({Key? key}) : super(key: key);

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
      create: (context) => AppCubit()..getDataFavouriteFromDatabase(),
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
                              value: cubit.favouriteTaskList[index].isCompleted == 0
                                  ? false
                                  : true,
                              // onChanged: (s){},
                              onChanged: (value)=>cubit.upDataState(state: value==false?0:1,id: cubit.favouriteTaskList[index].id!),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        title: Text(cubit.favouriteTaskList[index].title!),
                        trailing: DropdownButton(
                          icon: Icon(Icons.more_vert_outlined),
                          underline: Container(),
                          onChanged: (s) {},
                          items: [
                            DropdownMenuItem(

                              child: Text("completed"),
                              value: 'completed',
                              onTap: ()=>cubit.makeTaskStateComplete(cubit.favouriteTaskList[index].id),

                            ),
                            DropdownMenuItem(
                              child: Text("uncompleted"),
                              value: 'uncompleted',
                              onTap: ()=>cubit.makeTaskStateUnComplete(cubit.favouriteTaskList[index].id),

                            ),
                            DropdownMenuItem(
                              child: Text("favourite"),
                              value: 'favourite',
                              onTap: ()=>cubit.makeTaskStateFavourite(cubit.favouriteTaskList[index].id),
                            ),
                            DropdownMenuItem(
                              child: Text("delete"),
                              onTap: ()=>cubit.deleteTaskFromDatabase(cubit.taskList[index].id!),

                              value: 'delete',
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: cubit.favouriteTaskList.length,
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
