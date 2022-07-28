import 'package:algoriza_task2_todo_app/cubit/app_states.dart';
import 'package:algoriza_task2_todo_app/model/task_model.dart';
import 'package:algoriza_task2_todo_app/ui/modules/screen/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  AppCubit get(context) => BlocProvider.of(context);
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  DateTime selectedDate = DateTime.now();

  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  TextEditingController titleController = TextEditingController();
  List<Task> taskList = <Task>[];
  List<Task> completeTaskList = <Task>[];
  List<Task> unCompleteTaskList = <Task>[];
  List<Task> favouriteTaskList = <Task>[];


  getDateFromUser(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2040),
    );
    if (pickedDate != null) {
      selectedDate = pickedDate;
      emit(AppGetDateFromUserState());
    } else {
      return;
    }
  }

  getTimeFromUser(bool isStartTime, BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    String formattedTime = pickedTime!.format(context);
    if (isStartTime) {
      startTime = formattedTime;
      emit(AppGetTimeFromUserState());
    } else if (!isStartTime) {
      endTime = formattedTime;
      emit(AppGetTimeFromUserState());
    } else {
      return;
    }
  }

  getRemindFromUser(String? newValue) {
    selectedRemind = int.parse(newValue!);
    emit(AppGetRemindFromUserState());
  }

  getRepeatFromUser(String? newValue) {
    selectedRepeat = newValue!;
    emit(AppGetRepeatFromUserState());
  }

  createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db
          .execute('CREATE TABLE tasks ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING , date STRING, startTime STRING ,'
              'endTime STRING , remind INTEGER , '
              'repeat STRING,  '
              'isCompleted INTEGER,isFavourite INTEGER)')
          .then((value) {
        emit(AppCreateDatabaseSuccessState());
      }).catchError(((e) {
        emit(AppCreateDatabaseErrorState());
        print(e.toString());
      }));
    });
  }

  List<Map>? tasks;

  getDataFromDatabase() async {
    taskList = [];
    completeTaskList=[];
    unCompleteTaskList=[];
    favouriteTaskList=[];
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      tasks = value;
      taskList.addAll(value.map((e) => Task.fromJson(e)).toList());
      completeTaskList.addAll(value.map((e) => Task.fromJson(e)).toList());

// print(value);
      emit(AppGetDataSuccessState());
    }).catchError(((e) {
      emit(AppGetDataErrorState());
      print(e.toString());
    }));

    // database.close();
  }

  getDataCompletedFromDatabase() async {
// taskList=[];
    completeTaskList = [];
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    await database
        .rawQuery('SELECT * FROM tasks WHERE isCompleted=1')
        .then((value) {
      completeTaskList.addAll(value.map((e) => Task.fromJson(e)).toList());
// print(value);
      emit(AppGetDataSuccessState());
    }).catchError(((e) {
      emit(AppGetDataErrorState());
      print(e.toString());
    }));

    // database.close();
  }

  getDataUnCompletedFromDatabase() async {
// taskList=[];
    unCompleteTaskList = [];
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    await database
        .rawQuery('SELECT * FROM tasks WHERE isCompleted=0')
        .then((value) {
      // tasks = value;
      // taskList.addAll(value.map((e) => Task.fromJson(e)).toList());
      unCompleteTaskList.addAll(value.map((e) => Task.fromJson(e)).toList());
// print(value);
      emit(AppGetDataSuccessState());
    }).catchError(((e) {
      emit(AppGetDataErrorState());
      print(e.toString());
    }));

    // database.close();
  }

  getDataFavouriteFromDatabase() async {
// taskList=[];
    favouriteTaskList = [];
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    await database
        .rawQuery('SELECT * FROM tasks WHERE isFavourite=1')
        .then((value) {
      // tasks = value;
      // taskList.addAll(value.map((e) => Task.fromJson(e)).toList());
      favouriteTaskList.addAll(value.map((e) => Task.fromJson(e)).toList());
// print(value);
      emit(AppGetDataSuccessState());
    }).catchError(((e) {
      emit(AppGetDataErrorState());
      print(e.toString());
    }));

    // database.close();
  }

  insertDataToDatabase(Task task) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    await database.insert('tasks', task.toJson()).then((value) {
      emit(AppInsertSuccessState());
    }).catchError(((e) {
      print(e.toString());
      emit(AppInsertErrorState());
    }));
  }

  upDateToDatabase(int id) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    return await database.rawUpdate(
        '''Update tasks SET isCompleted=? WHERE id=?''', [1, id]).then((value) {
      emit(AppUpdateTaskSuccessState());
    }).catchError(((e) {
      print(e.toString());
      emit(AppUpdateTaskErrorState());
    }));
  }
  deleteTaskFromDatabase(int id) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    return await database.rawDelete(
        'DELETE  FROM tasks WHERE  id=?', [id]).then((value) {
      getDataFromDatabase();
      emit(AppDeleteTaskSuccessState());
    }).catchError(((e) {
      print(e.toString());
      emit(AppDeleteTaskErrorState());
    }));
  }
      // .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
  addTasksToDb(BuildContext context) async {
    await insertDataToDatabase(Task(
      title: titleController.value.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime,
      endTime: endTime,
      remind: selectedRemind,
      repeat: selectedRepeat,
      isFavourite: 0,
    )).then((value) {
      getDataFromDatabase();
      Navigator.pushReplacementNamed(context, BoardScreen.routeName);

      emit(AppInsertSuccessState());

    }).catchError(((e) {
      print(e.toString());

      emit(AppInsertErrorState());
    }));
  }

  bool makeTaskComplete = false;

  makeTaskStateComplete(int? id) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    return await database.rawUpdate(
        '''UPDATE  tasks SET isCompleted=? WHERE id=?''',
        [1, id]).then((value) {
      print(value);
      emit(AppUpdateTaskSuccessState());
      getDataFromDatabase();
    }).catchError(((e) {
      print(e);
      emit(AppUpdateTaskErrorState());
    }));
  }

  makeTaskStateUnComplete(int? id) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    return await database.rawUpdate(
        '''UPDATE  tasks SET isCompleted=? WHERE id=?''',
        [0, id]).then((value) {
      print(value);
      emit(AppUpdateTaskSuccessState());
      getDataFromDatabase();
    }).catchError(((e) {
      print(e);
      emit(AppUpdateTaskErrorState());
    }));
  }

  makeTaskStateFavourite(int? id) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    return await database.rawUpdate(
        '''UPDATE  tasks SET isFavourite=? WHERE id=?''',
        [1, id]).then((value) {
      print(value);
      emit(AppUpdateTaskSuccessState());
      getDataFromDatabase();
    }).catchError(((e) {
      print(e);
      emit(AppUpdateTaskErrorState());
    }));
  }

  upDataState({required int id, required int state}) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.db');
    Database database = await openDatabase(path);
    return await database.rawUpdate(
        '''UPDATE  tasks SET isCompleted=? WHERE id=?''',
        [state, id]).then((value) {
      print(value);
      emit(AppUpdateTaskSuccessState());
      getDataFromDatabase();
    }).catchError(((e) {
      print(e);
      emit(AppUpdateTaskErrorState());
    }));
  }

// change(){
//      completeTasks=taskList.where((element) {
//        if(element.isCompleted==1){
//          completeTasks.add(element);
//        }
//        return true;
//      }).toList();
// }
//   changeTaskState(bool? state, int index) {
//     // makeTaskComplete = state!;
//     if (state == false) {
//       upDate(state: 0,id :index);
//       // taskList[index].isCompleted = 1;
//
//     } else {
//       upDate(state: 1,id :index);
//
//       // taskList[index].isCompleted = 0;
//     }
//
//     emit(AppChangeTaskState());
//   }

  DatePickerController datePickerController = DatePickerController();
  DateTime selectedDateTime = DateTime.now();

  onDateChange(DateTime dateTime) {
    selectedDateTime = dateTime;
    // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime);

    emit(AppSelectedDateTimeState());
  }

// final NotificationService notificationService=NotificationService._internal();


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
  BehaviorSubject<String>();

  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }


  cancelNotification(Task task) async {
    flutterLocalNotificationsPlugin.cancel(task.id!);
  }
  cancelAllNotification() async {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.title,

      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id', 'your channel name',
        playSound: true,
          priority: Priority.max,
          importance: Importance.max,
          channelDescription: "Description"
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,

      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, int remind,
      String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    var formattedDate = DateFormat.yMd().parse(date);
    final tz.TZDateTime fd = tz.TZDateTime.from(formattedDate, tz.local);

    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);


    scheduledDate = afterRemind(remind, scheduledDate);


    if (scheduledDate.isBefore(now)) {
      if (repeat == "Daily") {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, now.month, (formattedDate.day) + 1, hour,
            minutes);
      }
      if (repeat == "Weekly") {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, now.month, (formattedDate.day) + 7, hour,
            minutes);
      }
      if (repeat == "Monthly") {
        scheduledDate = tz.TZDateTime(
            tz.local, now.year, (formattedDate.month) + 1, (formattedDate.day),
            hour, minutes);
      }

      scheduledDate = afterRemind(remind, scheduledDate);
    }


    return scheduledDate;
  }

  tz.TZDateTime afterRemind(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }


//Older IOS
  Future onDidReceiveLocalNotification(int id, String? title, String? body,
      String? payload) async {

  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is ' + payload);

    });
  }












}
