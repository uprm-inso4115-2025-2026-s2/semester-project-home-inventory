import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';

class ExpenseRemoteDataSource {
  final SupabaseClient _client;

  ExpenseRemoteDataSource(this._client);

  Future<List<ExpenseModel>> fetchExpenses() async {
    final response = await _client.from('expenses').select();
    return (response as List<dynamic>)
        .map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}