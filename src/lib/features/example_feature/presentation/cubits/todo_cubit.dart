import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/usecases/create_todo.dart';
import 'package:src/features/example_feature/domain/usecases/mark_todo_completed.dart';
import 'package:src/features/example_feature/domain/usecases/remove_todo.dart';
import 'package:src/features/example_feature/domain/usecases/stream_todos.dart';
import 'package:src/features/example_feature/domain/usecases/unmark_todo_completed.dart';
import 'package:src/features/example_feature/domain/usecases/update_todo.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final StreamTodos _streamTodos;
  final CreateTodo _createTodo;
  final RemoveTodo _removeTodo;
  final UpdateTodo _updateTodo;
  final MarkTodoCompleted _markTodoCompleted;
  final UnmarkTodoCompleted _unmarkTodoCompleted;

  TodoCubit(
    this._createTodo,
    this._removeTodo,
    this._updateTodo,
    this._markTodoCompleted,
    this._unmarkTodoCompleted,
    this._streamTodos,
  ) : super(LoadingState());

  Future<void> addTodo(TodoEntity todo) async {
    emit(LoadingState());
    try {
      await _createTodo(todo);
    } catch (e) {
      emit(ErrorState(e as Exception));
    }
  }

  Future<void> deleteTodo(TodoEntity todo) async {
    emit(LoadingState());
    try {
      await _removeTodo(todo);
    } catch (e) {
      emit(ErrorState(e as Exception));
    }
  }

  Future<void> updateTodo(TodoEntity todo) async {
    emit(LoadingState());
    try {
      await _updateTodo(todo);
    } catch (e) {
      emit(ErrorState(e as Exception));
    }
  }

  Future<void> toggleTodo(TodoEntity todo) async {
    emit(LoadingState());
    try {
      if (todo.completed) {
        await _unmarkTodoCompleted(todo);
      } else {
        await _markTodoCompleted(todo);
      }
    } catch (e) {
      emit(ErrorState(e as Exception));
    }
  }

  Stream<List<TodoEntity>> streamTodos(String name) {
    return _streamTodos(name);
  }
}
