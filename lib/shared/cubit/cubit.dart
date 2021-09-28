import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/network/local/shared_preferences.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List bodies = [NewTaskScreen(), DoneTaskScreen(), ArchiveTaskScreen()];
  List titles = ['New Task', 'Done Tasks', 'Archived Tasks'];

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void setIndex(index) {
    currentIndex = index;
    emit(AppChangeNavigationBarState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (Database db, int version) {
      print('DB created Successfully');
      db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT,status TEXT)');
      print('table created Successfully');
    }, onOpen: (Database db) {
      readFromDatabase(db);
      print('DB opened successfully');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }


  void insertIntoDatabase(title, date, time) async {
    await database.transaction((txn) async {
        txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
            .then((value) {
          print('inserted');
          emit(AppInsertDatabaseState());
          readFromDatabase(database);
        });
        print('$title inserted successfully');
    });
  }

  void readFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((List value) {
      value.forEach((i) {
        if (i['status'] == 'new') {
          newTasks.add(i);
        } else if (i['status'] == 'done') {
          doneTasks.add(i);
        } else
          archivedTasks.add(i);
      });
      emit(AppGetDatabaseState());
    });
  }

  bool showBottomSheet = false;
  IconData icon = Icons.edit;

  void setBottomSheet(newIcon, showSheet) {
    icon = newIcon;
    showBottomSheet = showSheet;
    emit(AppChangeBottomSheetState());
  }

  void updateDatabaseState(text, id) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$text', id]).then((value) {
      emit(AppUpdateDatabaseState());
      readFromDatabase(database);
    });
  }

  void deleteDatabaseState(id) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      readFromDatabase(database);
    });
  }
}
