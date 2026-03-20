import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/budget_model.dart';

class BudgetRemoteDataSource {
  final SupabaseClient _client;

  BudgetRemoteDataSource(this._client);

  Future<List<BudgetModel>> fetchBudgets() async {
    final response = await _client.from('budgets').select();
    return (response as List<dynamic>)
        .map((e) => BudgetModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}