class ReportFilters {
  final DateTime startDate;
  final DateTime endDate;
  final int page;          // 0 or 1 for category pagination
  final String searchQuery;

  const ReportFilters({
    required this.startDate,
    required this.endDate,
    required this.page,
    required this.searchQuery,
  });

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'page': page,
    'searchQuery': searchQuery,
  };

  factory ReportFilters.fromJson(Map<String, dynamic> json) {
    return ReportFilters(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      page: json['page'],
      searchQuery: json['searchQuery'],
    );
  }

  ReportFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    String? searchQuery,
  }) {
    return ReportFilters(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}