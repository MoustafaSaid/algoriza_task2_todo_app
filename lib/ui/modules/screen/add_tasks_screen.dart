import 'package:algoriza_task2_todo_app/cubit/app_cubit.dart';
import 'package:algoriza_task2_todo_app/cubit/app_states.dart';
import 'package:algoriza_task2_todo_app/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTasksScreen extends StatelessWidget {
  const AddTasksScreen({Key? key}) : super(key: key);
  static const routeName = 'add_task';

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AppCubit()..createDatabase()..getDataFromDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit().get(context);
          List<Task> taskList = <Task>[];

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              title: const Text("Add task"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title",
                      style:
                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cubit.titleController,
                            decoration: InputDecoration(
                                hintText: "Design team meeting",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),




                    const Text(
                      "Date",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText:
                                  DateFormat.yMd().format(cubit.selectedDate),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: IconButton(
                                onPressed: () => cubit.getDateFromUser(context),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 35,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),





                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start time",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () => cubit
                                              .getTimeFromUser(true, context),
                                          icon:
                                              const Icon(Icons.watch_later_outlined),
                                        ),
                                        hintText: cubit.startTime,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End time",
                              style:  TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () => cubit
                                              .getTimeFromUser(false, context),
                                          icon:
                                              const Icon(Icons.watch_later_outlined),
                                        ),
                                        hintText: cubit.endTime,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Remind",
                      style:
                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: DropdownButton(
                                    // dropdownColor: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(10),

                                    items: cubit.remindList
                                        .map<DropdownMenuItem<String>>(
                                            (int value) =>
                                                DropdownMenuItem<String>(
                                                    value: value.toString(),
                                                    child: Text("$value")))
                                        .toList(),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    iconSize: 32,
                                    elevation: 4,

                                    underline: Container(
                                      height: 0,
                                    ),
                                    onChanged: (String? newValue) =>cubit.getRemindFromUser(newValue),
                                  ),
                                ),
                                hintText:
                                    "${cubit.selectedRemind} minutes early",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),



                    const Text(
                      "Repeat",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                suffixIcon:Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: DropdownButton(
                                    // dropdownColor: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(10),

                                    items: cubit.repeatList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) =>
                                            DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value)))
                                        .toList(),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    iconSize: 32,
                                    elevation: 4,

                                    underline: Container(
                                      height: 0,
                                    ),
                                    onChanged: (String? newValue) =>cubit.getRepeatFromUser(newValue),
                                  ),
                                ),
                                hintText: cubit.selectedRepeat,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),


                    Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      child: MaterialButton(
                        height: 45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: (){
                          cubit.addTasksToDb(context);


                        },
                        child: const Text(
                          "Create a task",
                          style:  TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }



}
