import 'package:src/features/example_feature/domain/entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getAllTodos();

  Future<List<TodoEntity>> searchTodos(String name);

  Future<void> addTodo(TodoEntity todo);

  Future<void> updateTodo(TodoEntity todo);

  Future<void> deleteTodo(TodoEntity tod);
}
