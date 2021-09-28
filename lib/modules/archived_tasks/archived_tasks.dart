import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/app_state.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

class ArchiveTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var list = AppCubit.get(context).archivedTasks;
        return list.length > 0
            ? ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return buildNewTaskList(list[index], context);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.grey,
                width: double.infinity,
                height: 1,
              );
            },
            itemCount: list.length)
            : taskBuilder();
      },
    );
  }
}
