// This directory hold the pages and widgets, essentially all the parts of the application concerning the presentation layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/core/data/services/supabase_service.dart';
import 'package:src/features/example_feature/data/repositories/todo_repository_impl.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/presentation/widgets/todo_tile.dart';

class TodosPage extends StatefulWidget {

  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final TodoRepositoryImpl todoRepository = TodoRepositoryImpl(
    SupabaseService(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: addButton(context),
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(title: Text("Todo Page"), backgroundColor: Colors.blue),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          Text("All Todos", style: TextStyle(fontSize: 20.sp)),
          SizedBox(height: 1.h),
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

  Widget addButton(BuildContext context) {
    final TextEditingController todoController = TextEditingController();
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text("Add Todo"),
              content: Material(
                child: TextField(
                  controller: todoController,
                  onSubmitted: (value) {
                    todoRepository.addTodo(TodoEntity(id: 0, name: value));
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
              ],
            );
          },
        );
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
