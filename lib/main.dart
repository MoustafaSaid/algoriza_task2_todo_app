import 'package:algoriza_task2_todo_app/cubit/bloc_observer.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/add_tasks_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/board_screen.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/schedile_tasks_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
        () {
      // Use cubits...
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
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent
          ),
          elevation: 0,
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25
          )
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,

        )
      ),
      debugShowCheckedModeBanner: false,
      // home: AddTasksScreen(),
      home: BoardScreen(),
      routes: {
        // '/':(context)=>BoardScreen(),
        AddTasksScreen.routeName:(context)=>AddTasksScreen(),
        ScheduleTasksScreen.routeName:(context)=>ScheduleTasksScreen(),
        BoardScreen.routeName:(context)=>BoardScreen(),
      },
    );
  }
}
