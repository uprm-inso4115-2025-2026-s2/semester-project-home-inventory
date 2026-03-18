// This directory holds entities and abstract repositories, essentially all the contracts with how the app interacts with the domain

class TodoEntity {
  final int id;
  String name;
  bool completed;

  TodoEntity({required this.id, required this.name, this.completed = false});
}