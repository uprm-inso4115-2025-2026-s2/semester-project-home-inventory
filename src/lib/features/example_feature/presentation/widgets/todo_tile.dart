import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';

class TodoTile extends StatelessWidget {
  final TodoEntity todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.w,
      height: 10.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(todo.name, style: TextStyle(fontSize: 16.sp)),
    );
  }
}
