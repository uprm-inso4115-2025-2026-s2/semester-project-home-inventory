import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/household_model.dart';
import '../models/household_member_model.dart';
import '../models/household_summary_model.dart';

class HouseholdRemoteDataSource {
  final SupabaseClient _client;

  HouseholdRemoteDataSource(this._client);

  Future<List<HouseholdModel>> fetchHouseholds() async {
    final response = await _client.from('households').select();
    return (response as List<dynamic>)
        .map((e) => HouseholdModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<HouseholdMemberModel>> fetchHouseholdMembers() async {
    final response = await _client.from('household_members').select();
    return (response as List<dynamic>)
        .map((e) => HouseholdMemberModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<HouseholdSummaryModel>> fetchHouseholdSummaries() async {
    final response = await _client.from('household_summary').select();
    return (response as List<dynamic>)
        .map((e) => HouseholdSummaryModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
    Future<HouseholdModel> createHousehold(HouseholdModel household) async {
    final data = household.toMap();
    if (household.id == -1) data.remove('id');

    final response = await _client
        .from('households')
        .insert(data)
        .select()
        .single();

    return HouseholdModel.fromMap(response);
  }

  Future<HouseholdModel?> fetchHouseholdById(int id) async {
    final response = await _client
        .from('households')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return HouseholdModel.fromMap(response);
  }

  Future<List<HouseholdMemberModel>> fetchMembersByHousehold(
    int householdId,
  ) async {
    final response = await _client
        .from('household_members')
        .select()
        .eq('household_id', householdId);

    return (response as List<dynamic>)
        .map((e) => HouseholdMemberModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<HouseholdMemberModel> createMember(HouseholdMemberModel member) async {
    final data = member.toMap();
    if (member.id == -1) data.remove('id');

    final response = await _client
        .from('household_members')
        .insert(data)
        .select()
        .single();

    return HouseholdMemberModel.fromMap(response);
  }

  Future<void> removeMember(int memberId) async {
    await _client
        .from('household_members')
        .delete()
        .eq('id', memberId);
  }
}