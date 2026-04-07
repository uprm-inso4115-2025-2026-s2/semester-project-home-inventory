import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/budget_model.dart';
import '../models/budget_allocation_model.dart';

class BudgetRemoteDataSource {
  final SupabaseClient _client;

  BudgetRemoteDataSource(this._client);

  /// Fetch a single budget by householdId
  /// Uses maybeSingle() as a household might not have a budget set yet
  Future<BudgetModel?> fetchBudgetByHousehold(int householdId) async {
    final response = await _client
        .from('budgets')
        .select()
        .eq('household_id', householdId)
        .maybeSingle();

    if (response == null) return null;
    return BudgetModel.fromMap(response);
  }

  /// Create a new budget record
  Future<BudgetModel> createBudget(BudgetModel budget) async {
    // We remove the 'id' if it's -1 or null to let Supabase generate the primary key
    final data = budget.toMap();
    if (budget.id == -1) data.remove('id');

    final response = await _client
        .from('budgets')
        .insert(data)
        .select()
        .single();
    
    return BudgetModel.fromMap(response);
  }

  /// Update an existing budget
  Future<BudgetModel> updateBudget(int id, Map<String, dynamic> updates) async {
    final response = await _client
        .from('budgets')
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    
    return BudgetModel.fromMap(response);
  }

  /// Delete a budget record
  Future<void> deleteBudget(int id) async {
    await _client
        .from('budgets')
        .delete()
        .eq('id', id);
  }

  Future<BudgetAllocationModel> createAllocation(
    BudgetAllocationModel allocation,
  ) async {
    final data = allocation.toJson();
    if (allocation.id == -1) data.remove('id');

    final response = await _client
        .from('budget_allocations')
        .insert(data)
        .select()
        .single();

    return BudgetAllocationModel.fromJson(response);
  }

  Future<List<BudgetAllocationModel>> fetchAllocationsBySpendEvent(
    int spendEventId,
  ) async {
    final response = await _client
        .from('budget_allocations')
        .select()
        .eq('spend_event_id', spendEventId);

    return (response as List<dynamic>)
        .map((e) => BudgetAllocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

}