import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invite_token_model.dart';
import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import '../models/invite_model.dart';

class InvitationRemoteDataSource {
  final SupabaseClient _client;

  InvitationRemoteDataSource(this._client);

  Future<List<InviteTokenModel>> fetchInvitations() async {
    final response = await _client.from('invite_tokens').select();
    return (response as List<dynamic>)
        .map((e) => InviteTokenModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<InviteModel> createInvite(InviteModel invite) async {
    final data = invite.toJson();
    if (invite.id == -1) data.remove('id');

    final response = await _client
        .from('invites')
        .insert(data)
        .select()
        .single();

    return InviteModel.fromJson(response);
  }

  Future<InviteModel?> fetchInviteById(int id) async {
    final response = await _client
        .from('invites')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return InviteModel.fromJson(response);
  }

  Future<List<InviteModel>> fetchInvitesByHousehold(int householdId) async {
    final response = await _client
        .from('invites')
        .select()
        .eq('household_id', householdId);

    return (response as List<dynamic>)
        .map((e) => InviteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<InviteModel> updateInviteStatus(int inviteId, InviteStatus status) async {
    final response = await _client
        .from('invites')
        .update({'status': status.name})
        .eq('id', inviteId)
        .select()
        .single();

    return InviteModel.fromJson(response);
  }

}