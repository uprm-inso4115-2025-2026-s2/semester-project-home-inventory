import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseService();

  Future<PostgrestList> selectAll(String table) async {
    return await _supabase.from(table).select();
  }

  Future<PostgrestResponse<List<Map<String, dynamic>>>> insert(String table, Map<String, dynamic> data) async {
    return await _supabase.from(table).insert(data);
  }

  Future<PostgrestResponse<List<Map<String, dynamic>>>> update(String table, Map<String, dynamic> data) async {
    return await _supabase.from(table).update(data);
  }

  Future<PostgrestResponse<List<Map<String, dynamic>>>> delete(String table, Map<String, dynamic> data) async {
    return await _supabase.from(table).delete().eq('id', data['id']);
  }

  Future<PostgrestList> selectBySimilar(String table, String column, String value) async {
    return await _supabase.from(table).select().ilike(column, value);
  }
}