import 'package:src/core/data/services/supabase_service.dart';
import 'package:src/features/example_feature/data/models/todo_model.dart';

class TodoDataSource {
  final SupabaseService _supabaseService;

  TodoDataSource(this._supabaseService);

  Future<List<TodoModel>> getAllTodos() async {
    final list = await _supabaseService.selectAll('todos');
    return list.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<List<TodoModel>> searchTodos(String name) async {
    final list = await _supabaseService.selectBySimilar('todos', 'name', name);
    return list.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<void> addTodo(TodoModel model) async {
    await _supabaseService.insert('todos', model.toJson()..remove('id'));
  }

  Future<void> updateTodo(TodoModel model) async {
    await _supabaseService.update('todos', model.toJson());
  }

  Future<void> deleteTodo(TodoModel model) async {
    await _supabaseService.delete('todos', model.toJson());
  }

  Stream<List<TodoModel>> streamTodos(String name) {
    if (name.isEmpty) {
      return _supabaseService
          .streamTable('todos')
          .map((list) => list.map((e) => TodoModel.fromJson(e)).toList());
    }
    return _supabaseService
        .streamLike('todos', 'name', name)
        .map((list) => list.map((e) => TodoModel.fromJson(e)).toList());
  }
}
