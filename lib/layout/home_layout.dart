import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/app_state.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AppCubit()..createDatabase();
      },
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, state) {
          if (state is AppInsertDatabaseState) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        },
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: cubit.state is! AppLoadingState
                ? cubit.bodies[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.readFromDatabase(cubit.database);
                if (cubit.showBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDatabase(titleController.text,
                        dateController.text, timeController.text);
                    titleController.text = "";
                    timeController.text = "";
                    dateController.text = "";
                    cubit.setBottomSheet(Icons.edit, false);
                  }
                } else {
                  cubit.setBottomSheet(Icons.add, true);

                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return Container(
                          color: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    label: "Title",
                                    keyType: TextInputType.text,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter a title';
                                      }
                                      return null;
                                    },
                                    prefix: Icons.title,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultFormField(
                                    readOnly: true,
                                    onTap: () async {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text = value != null
                                            ? value.format(context).toString()
                                            : "";
                                      });
                                    },
                                    controller: timeController,
                                    label: "Time",
                                    keyType: TextInputType.datetime,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter a time';
                                      }
                                      return null;
                                    },
                                    prefix: Icons.watch_later_outlined,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultFormField(
                                    readOnly: true,
                                    onTap: () async {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now()
                                                  .add(Duration(days: 30)))
                                          .then((value) {
                                        dateController.text = value != null
                                            ? DateFormat.yMMMd().format(value)
                                            : '';
                                      });
                                    },
                                    controller: dateController,
                                    label: "Date",
                                    keyType: TextInputType.datetime,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter a Date';
                                      }
                                      return null;
                                    },
                                    prefix: Icons.calendar_today_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubit.setBottomSheet(Icons.edit, false);
                      });
                }
              },
              child: Icon(cubit.icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.grey,
              elevation: 50,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.setIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
