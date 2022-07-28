class Task {
  int? id;

  String? title;


  int? isCompleted;
  int? isFavourite;

  String? date;

  String? startTime;

  String? endTime;


  int? remind;

  String? repeat;

  Task({
    this.id,
    this.title,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,

    this.isFavourite,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'isFavourite': isFavourite,

    };
  }

  Task.fromJson(Map<String, dynamic> json) {

    id= json['id'] ;
    title= json['title'] ;
    isCompleted= json['isCompleted'];
    date=json['date'] ;
    startTime= json['startTime'] ;
    endTime= json['endTime'];
    remind=json['remind'] ;
    repeat= json['repeat'] ;
    isFavourite= json['isFavourite'];


  }
}



//
// Database? db;
// int version = 1;
// String tableName = 'tasks';
//
// Future<void> initDb() async {
//   if (db != null) {
//     return;
//   } else {
//     try {
//       String path = '${await getDatabasesPath()}task.db';
//       db = await openDatabase(
//           path, version: version, onCreate: (Database db, int version) async {
//         await db.execute(
//             'CREATE TABLE $tableName ('
//                 'id INTEGER PRIMARY KEY AUTOINCREMENT, '
//                 'title STRING , date STRING, startTime STRING ,'
//                 'endTime STRING , remind INTEGER , '
//                 'repeat STRING, color INTEGER, '
//                 'isCompleted INTEGER,isFavourite INTEGER)');
//         emit(AppCreateDatabaseSuccessState());
//       });
//     } catch (e) {
//       print(e);
//       emit(AppCreateDatabaseErrorState());
//     }
//   }
// }
//
// Future<int> insert(Task? task) async {
//
//   return  await db!.insert(tableName, task!.toJson());
//
//
// }
//
// Future<int> delete(Task task) async {
//   return await db!.delete(tableName, where: 'id=?', whereArgs: [task.id]);
// }
//
// Future<int> deleteAll() async {
//   return await db!.delete(tableName);
// }
//
//
// final List<Task> taskList = <Task>[];
// // final List completedTasks=taskList[];
// //     final List<Task> completedTasks=taskList.where((element) e)
//
// Future<int> addTask(Task? task) {
//   return insert(task);
// }
//
// Future<void> getTasks() async {
//   final List<Map<String, dynamic>> tasks = await query();
//   taskList.addAll(tasks.map((e) => Task.fromJson(e)).toList());
//   emit(AppGetDataSuccessState());
// }
//
// void deleteTasks(Task task) async {
//   await delete(task);
//   getTasks();
// }
//
// void deleteAllTasks() async {
//   await deleteAll();
//   getTasks();
// }
//
//
// void markTaskAsCompleted(int id) async {
//   await upDate(id);
//   getTasks();
// }
//
//
// Future<List<Map<String, dynamic>>> query() async {
//   return await db!.query(tableName);
// }
//
// Future<int> upDate(int id) async {
//   return await db!.rawUpdate(
//       '''Update tasks SET isCompleted=? WHERE id=?''', [1, id]);
// }
//
//
// validateDate(BuildContext context) {
//   if (titleController.value.text.isNotEmpty
//   ) {
//     addTasksToDb();
//     Navigator.pop(context);
//   }
//
//   return;
// }
//
//
// addTasksToDb() async {
//   int value = await addTask(Task(
//       title: titleController.value.text,
//       isFavourite: 0,
//       isCompleted: 0,
//       date: DateFormat.yMd().format(selectedDate),
//       startTime: startTime,
//       endTime: endTime,
//       remind: selectedRemind,
//       repeat: selectedRepeat));
//   emit(AppInsertSuccessState());
//
// }
