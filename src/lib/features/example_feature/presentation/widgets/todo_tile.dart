import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/data/services/supabase_service.dart';
import 'package:src/features/example_feature/data/repositories/todo_repository_impl.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';

class TodoTile extends StatelessWidget {
  final TodoEntity todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                    final todoRepository = TodoRepositoryImpl(
                      SupabaseService(),
                    );
                    todoRepository.deleteTodo(todo);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 45.w,
        height: 10.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(todo.name, style: TextStyle(fontSize: 16.sp)),
      ),
    );
  }
}
