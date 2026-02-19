// This directory hold the pages and widgets, essentially all the parts of the application concerning the presentation layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/data/services/supabase_service.dart';
import 'package:src/features/example_feature/data/repositories/todo_repository_impl.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/presentation/widgets/todo_tile.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoRepositoryImpl todoRepository = TodoRepositoryImpl(
      SupabaseService(),
    );

    return Scaffold(
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(title: Text("Todo Page")),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        children: [
          Text("All Todos"),
          FutureBuilder(
            future: todoRepository.getAllTodos(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              final List<TodoEntity> todos = snapshot.data ?? [];
              return Column(
                spacing: 1.h,
                children: List.generate(
                  todos.length,
                  (index) => TodoTile(todo: todos[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
