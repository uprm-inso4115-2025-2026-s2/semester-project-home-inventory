import 'package:src/features/example_feature/data/data_sources/todo_data_source.dart';
import 'package:src/features/example_feature/data/models/todo_model.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _dataSource;

  TodoRepositoryImpl(this._dataSource);

  @override
  Future<List<TodoEntity>> getAllTodos() async {
    final models = await _dataSource.getAllTodos();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<TodoEntity>> searchTodos(String name) async {
    final models = await _dataSource.searchTodos(name);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    await _dataSource.addTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    await _dataSource.updateTodo(TodoModel.fromEntity(todo));
  }

  @override
  Future<void> deleteTodo(TodoEntity todo) async {
    await _dataSource.deleteTodo(TodoModel.fromEntity(todo));
  }

  @override
  Stream<List<TodoEntity>> streamTodos(String name) {
    return _dataSource
        .streamTodos(name)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
