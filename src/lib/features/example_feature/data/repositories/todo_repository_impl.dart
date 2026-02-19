import 'package:src/core/data/services/supabase_service.dart';
import 'package:src/features/example_feature/data/models/todo_model.dart';
import 'package:src/features/example_feature/domain/entities/todo_entity.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {

  final SupabaseService _supabaseService;

  TodoRepositoryImpl(this._supabaseService);

  @override
  Future<List<TodoEntity>> getAllTodos() async {
    final list = await _supabaseService.selectAll('todos');
    return list.map((e) => TodoModel.fromJson(e).toEntity()).toList();
  }

  @override
  Future<List<TodoEntity>> searchTodos(String name) async {
    final list = await _supabaseService.selectBySimilar('todos', 'name', name);
    return list.map((e) => TodoModel.fromJson(e).toEntity()).toList();
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    await _supabaseService.insert('todos', model.toJson()..remove('id'));
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    await _supabaseService.update('todos', model.toJson());
  }

  @override
  Future<void> deleteTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    await _supabaseService.delete('todos', model.toJson());
  }
}
