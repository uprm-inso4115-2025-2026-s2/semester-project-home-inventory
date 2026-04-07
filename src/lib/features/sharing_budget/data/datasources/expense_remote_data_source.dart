import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';
import '../models/spend_event_model.dart';

class ExpenseRemoteDataSource {
  final SupabaseClient _client;

  ExpenseRemoteDataSource(this._client);

  /// Fetch spending records filtered by householdId
  Future<List<ExpenseModel>> fetchExpensesByHousehold(int householdId) async {
    final response = await _client
        .from('expenses')
        .select()
        .eq('household_id', householdId);
    
    return (response as List<dynamic>)
        .map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch spending records filtered by userId
  Future<List<ExpenseModel>> fetchExpensesByUser(int userId) async {
    final response = await _client
        .from('expenses')
        .select()
        .eq('user_id', userId);
    
    return (response as List<dynamic>)
        .map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a new spending record
  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    final data = expense.toMap();
    // Ensure we don't send a dummy ID to Supabase
    if (expense.id == -1) data.remove('id');

    final response = await _client
        .from('expenses')
        .insert(data)
        .select()
        .single();
    
    return ExpenseModel.fromMap(response);
  }

  /// Delete a spending record
  Future<void> deleteExpense(int id) async {
    await _client
        .from('expenses')
        .delete()
        .eq('id', id);
  }

  Future<List<SpendEventModel>> fetchSpendEventsByHousehold(
    int householdId,
  ) async {
    final response = await _client
        .from('spend_events')
        .select()
        .eq('household_id', householdId);

    return (response as List<dynamic>)
        .map((e) => SpendEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SpendEventModel>> fetchSpendEventsByUser(int userId) async {
    final response = await _client
        .from('spend_events')
        .select()
        .eq('user_id', userId);

    return (response as List<dynamic>)
        .map((e) => SpendEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SpendEventModel> createSpendEvent(SpendEventModel event) async {
    final data = event.toJson();
    if (event.id == -1) data.remove('id');

    final response = await _client
        .from('spend_events')
        .insert(data)
        .select()
        .single();

    return SpendEventModel.fromJson(response);
  }

  Future<void> deleteSpendEvent(int id) async {
    await _client
        .from('spend_events')
        .delete()
        .eq('id', id);
  }

}