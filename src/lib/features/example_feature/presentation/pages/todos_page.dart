// This directory hold the pages and widgets, essentially all the parts of the application concerning the presentation layer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_cubit.dart';
import 'package:src/features/example_feature/presentation/widgets/todo_tile.dart';

import '../../../../config/injection_dependencies.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: addButton(context),
      appBar: AppBar(
        title: Text("All Todos", style: TextStyle(fontSize: 20.sp)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          searchBar(),
          SizedBox(height: 2.h),
          todos(),
        ],
      ),
    );
  }

  Widget searchBar() {
    return SearchBar(
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
      hintText: "Search for a todo",
      leading: Icon(Icons.search),
    );
  }

  Widget todos() {
    return StreamBuilder(
      stream: sl<TodoCubit>().streamTodos(searchText),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 5.spa,
              strokeCap: StrokeCap.round,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        final List<TodoEntity> todos = snapshot.data ?? [];
        return Column(
          spacing: 1.h,
          children: List.generate(
            todos.length,
            (index) => TodoTile(todo: todos[index]),
          ),
        );
      },
    );
  }

  Widget addButton(BuildContext context) {
    final TextEditingController todoController = TextEditingController();
    return FloatingActionButton(
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text("Add Todo"),
              content: Material(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: todoController,
                  onSubmitted: (value) {
                    sl<TodoCubit>().addTodo(TodoEntity(id: 0, name: value));
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
      child: Icon(Icons.add),
    );
  }
}
