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
}