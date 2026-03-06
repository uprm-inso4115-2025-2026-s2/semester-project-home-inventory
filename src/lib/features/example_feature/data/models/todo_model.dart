// This directory holds the models, data sources, and repository implementation, essentially to bridge the gap between domain and presentation

import 'package:src/features/example_feature/domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  TodoModel({
    required super.id,
    required super.name,
    super.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'completed': completed};
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      name: json['name'],
      completed: json['completed'],
    );
  }

  TodoEntity toEntity() {
    return TodoEntity(id: id, name: name, completed: completed);
  }

  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      name: entity.name,
      completed: entity.completed,
    );
  }

  factory TodoModel.initial() {
    return TodoModel(id: 0, name: '', completed: false);
  }

}
