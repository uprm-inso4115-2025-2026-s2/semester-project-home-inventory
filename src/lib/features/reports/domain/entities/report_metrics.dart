class Report {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
