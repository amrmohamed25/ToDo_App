import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField(
    {required controller,
    required label,
    required keyType,
    required validate,
    required prefix,
    isPassword = false,
    suffix,
    function,
    onsubmit,
    onchange,
    readOnly: false,
    onTap}) {
  return TextFormField(
    onTap: onTap,
    readOnly: readOnly,
    onFieldSubmitted: onsubmit,
    onChanged: onchange,
    keyboardType: keyType,
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix == null
            ? null
            : IconButton(
                onPressed: function,
                icon: Icon(suffix),
              )),
    validator: validate,
    obscureText: isPassword,
  );
}

Widget buildNewTaskList(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabaseState(model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue,
            child: Text(
              '${model['time']}',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 25),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              var cubit = AppCubit.get(context);
              cubit.updateDatabaseState('done', model['id']);
            },
            icon: Icon(Icons.done_outline),
            color: Colors.green,
          ),
          IconButton(
            onPressed: () {
              var cubit = AppCubit.get(context);
              cubit.updateDatabaseState('archived', model['id']);
            },
            icon: Icon(Icons.archive),
            color: Colors.grey[400],
          ),
        ],
      ),
    ),
  );
}

Widget taskBuilder() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100,
        ),
        Text(
          'You didn\'t add any tasks yet',
          style: TextStyle(color: Colors.grey, fontSize: 25),
        ),
      ],
    ),
  );
}


