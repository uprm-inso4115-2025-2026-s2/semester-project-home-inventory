// This directory holds entities and abstract repositories, essentially all the contracts with how the app interacts with the domain

class TodoEntity {
  final int id;
  final String name;

  const TodoEntity({required this.id, required this.name});
}