import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';

class RemoveTodo {
  final TodoRepository repository;

  RemoveTodo(this.repository);

  Future<void> call(TodoEntity todo) async {
    return await repository.deleteTodo(todo);
  }
}