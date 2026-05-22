import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/report_filters.dart';

class FavoritesRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _getUserId() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw Exception('No authenticated user');
    return uid;
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
    try {
      final userId = _getUserId();
      final existing = await _supabase
          .from('user_report_favorites')
          .select()
          .eq('user_id', userId)
          .eq('name', name)
          .maybeSingle();

      if (existing != null) {
        await _supabase.from('user_report_favorites').update({
          'filters': filters.toJson(),
          'updated_at': DateTime.now().toIso8601String(),
        }).match({'id': existing['id']});
      } else {
        await _supabase.from('user_report_favorites').insert({
          'user_id': userId,
          'name': name,
          'filters': filters.toJson(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
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