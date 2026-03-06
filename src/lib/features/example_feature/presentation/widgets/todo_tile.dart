import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_cubit.dart';

import '../../../../config/injection_dependencies.dart';

class TodoTile extends StatelessWidget {
  final TodoEntity todo;
  final TextEditingController todoController = TextEditingController();

  TodoTile({super.key, required this.todo});

  @override
  StatelessElement createElement() {
    todoController.text = todo.name;
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapEdit(context),
      child: Container(
        width: 80.w,
        height: 10.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    sl<TodoCubit>().toggleTodo(todo);
                  },
                ),
                Text(todo.name, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.redAccent,
              onPressed: tapDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback tapEdit(BuildContext context) {
    return () {
      showCupertinoDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text("Edit Todo"),
            content: Material(
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: todoController,
                onSubmitted: (value) {
                  todo.name = value;
                  sl<TodoCubit>().updateTodo(todo);
                  Navigator.pop(context);
                },
                decoration: InputDecoration(hintText: "Enter a todo"),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("Confirm"),
                onPressed: () {
                  todo.name = todoController.text;
                  sl<TodoCubit>().updateTodo(todo);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    };
  }


  VoidCallback tapDelete(BuildContext context) {
    return () {
      showCupertinoDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text("Delete Todo"),
            content: Text("Are you sure you want to delete this todo?"),
            actions: [
              CupertinoDialogAction(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("Yes"),
                onPressed: () {
                  sl<TodoCubit>().deleteTodo(todo);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    };
  }
}
