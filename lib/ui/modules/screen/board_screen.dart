import 'package:algoriza_task2_todo_app/cubit/app_cubit.dart';
import 'package:algoriza_task2_todo_app/cubit/app_states.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/favourite_tasks_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/add_tasks_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/all_tasks_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/completed_tasks_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/schedile_tasks_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/uncompleted_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);
  static const routeName = 'board';


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return  DefaultTabController(length: 4, child: Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark
              ),
              actions: [
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, ScheduleTasksScreen.routeName);

                }, icon: const Icon(Icons.calendar_today_outlined))
              ],
              toolbarHeight: 80,
              title:const Text("Board"),
              bottom: const TabBar(

                  labelPadding: EdgeInsets.all(0),
                  tabs: [
                    Tab(child: Text("All"),),
                    Tab(child: Text("Completed"),),
                    Tab(child: Text("UnCompleted"),),
                    Tab(child: Text("Favourite"),)
                  ]),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Expanded(
                    child: TabBarView(

                        children: [
                          AllTasksScreen(),
                          CompletedTasksScreen(),
                          UnCompletedTasksScreen(),
                          FavouriteTasksScreen()

                        ]),
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        color: Colors.green

                    ),
                    child: MaterialButton(
                      height: 45,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context, AddTasksScreen.routeName);
                      },
                      child: const Text(
                        "Add a task",style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),

          ));
        },
      ),);
  }
}
