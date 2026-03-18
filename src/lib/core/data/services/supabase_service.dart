import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase;

  SupabaseService(this._supabase);

  Stream<PostgrestList> streamTable(String table) {
    return _supabase.from(table).stream(primaryKey: ['id']).asyncMap((e) => e);
  }

  Stream<PostgrestList> streamWhere(String table, String column, Object value) {
    return _supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq(column, value)
        .asyncMap((e) => e);
  }

  Stream<PostgrestList> streamLike(
      String table,
      String column,
      String value,
      ) {
    return _supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .map((rows) => rows.where((row) {
      final field = row[column]?.toString().toLowerCase() ?? '';
      return field.contains(value.toLowerCase());
    }).toList());
  }

  Future<PostgrestList> selectAll(String table) async {
    return await _supabase.from(table).select();
  }

  Future<PostgrestList> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    return await _supabase.from(table).insert(data).select();
  }

  Future<PostgrestList> update(
    String table,
    Map<String, dynamic> data,
  ) async {
    return await _supabase.from(table).update(data).eq('id', data['id']).select();
  }

  Future<PostgrestList> delete(
    String table,
    Map<String, dynamic> data,
  ) async {
    return await _supabase.from(table).delete().eq('id', data['id']).select();
  }

  Future<PostgrestList> selectBySimilar(
    String table,
    String column,
    String value,
  ) async {
    return await _supabase.from(table).select().ilike(column, value);
  }

  Future<PostgrestList> selectWhere(
    String table,
    String column,
    String value,
  ) async {
    return await _supabase.from(table).select().eq(column, value);
  }
}
