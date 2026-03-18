import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';

class StreamTodos {
  final TodoRepository repository;

  StreamTodos(this.repository);

  Stream<List<TodoEntity>> call(String name) {
    return repository.streamTodos(name);
  }
}
