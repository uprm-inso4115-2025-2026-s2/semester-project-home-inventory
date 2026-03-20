import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invite_token_model.dart';

class InvitationRemoteDataSource {
  final SupabaseClient _client;

  InvitationRemoteDataSource(this._client);

  Future<List<InviteTokenModel>> fetchInvitations() async {
    final response = await _client.from('invite_tokens').select();
    return (response as List<dynamic>)
        .map((e) => InviteTokenModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}