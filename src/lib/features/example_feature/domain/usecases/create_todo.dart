import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';

class CreateTodo {
  final TodoRepository repository;

  CreateTodo(this.repository);

  Future<void> call(TodoEntity todo) async {
    return await repository.addTodo(todo);
  }
}