import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/report_filters.dart';

class FavoritesRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current user ID or throw if not logged in.
  String _getUserId() {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated. Please log in.');
    return user.id;
  }

  Future<List<ReportFavorite>> getUserFavorites() async {
    try {
      final userId = _getUserId();
      final response = await _supabase
          .from('user_report_favorites')
          .select()
          .eq('user_id', userId)
          .order('name');
      return response.map((json) => ReportFavorite.fromJson(json)).toList();
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }

  Future<void> saveFavorite(String name, ReportFilters filters) async {
    final userId = _getUserId();
    try {
      await _supabase.from('user_report_favorites').upsert(
        {
          'user_id': userId,
          'name': name,
          'filters': filters.toJson(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'name',
      ).select();
    } catch (e) {
      print('Error saving favorite: $e');
      rethrow;
    }
  }

  Future<void> updateFavorite(String id, String newName, ReportFilters filters) async {
    final userId = _getUserId();
    await _supabase.from('user_report_favorites').update({
      'name': newName,
      'filters': filters.toJson(),
      'updated_at': DateTime.now().toIso8601String(),
    }).match({'id': id, 'user_id': userId});
  }

  Future<void> deleteFavorite(String id) async {
    final userId = _getUserId();
    await _supabase.from('user_report_favorites').delete().match({'id': id, 'user_id': userId});
  }
}

class ReportFavorite {
  final String id;
  final String name;
  final ReportFilters filters;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportFavorite({
    required this.id,
    required this.name,
    required this.filters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportFavorite.fromJson(Map<String, dynamic> json) {
    return ReportFavorite(
      id: json['id'],
      name: json['name'],
      filters: ReportFilters.fromJson(json['filters']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}