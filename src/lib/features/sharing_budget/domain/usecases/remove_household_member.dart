import '../repositories/sharing_repository.dart';

/// Use case for removing a household member.
class RemoveHouseholdMember {
  final SharingRepository repository;

  const RemoveHouseholdMember(this.repository);

  Future<void> call(int memberId) async {
    if (memberId <= 0) {
      throw Exception('Member ID must be a positive number');
    }

    await repository.removeMember(memberId);
  }
}
