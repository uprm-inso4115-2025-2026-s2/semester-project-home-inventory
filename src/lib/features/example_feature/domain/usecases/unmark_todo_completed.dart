import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';

class UnmarkTodoCompleted {
  final TodoRepository repository;

  UnmarkTodoCompleted(this.repository);

  Future<void> call(TodoEntity todo) async {
    final updatedTodo = TodoEntity(
      id: todo.id,
      name: todo.name,
      completed: false,
    );
    return await repository.updateTodo(updatedTodo);
  }
}
