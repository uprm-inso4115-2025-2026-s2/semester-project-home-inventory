import 'package:src/features/example_feature/domain/entities/todo_entity.dart';

abstract class TodoState {}

class ErrorState extends TodoState {
  final Exception error;

  ErrorState(this.error);
}

class LoadingState extends TodoState {}

class LoadedState extends TodoState {
  final List<TodoEntity> todos;

  LoadedState(this.todos);
}
