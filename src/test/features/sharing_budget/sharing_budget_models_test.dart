import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/sharing_budget/data/models/budget_allocation_model.dart';
import 'package:src/features/sharing_budget/data/models/budget_model.dart';
import 'package:src/features/sharing_budget/data/models/household_member_model.dart';
import 'package:src/features/sharing_budget/data/models/household_model.dart';
import 'package:src/features/sharing_budget/data/models/invite_model.dart';
import 'package:src/features/sharing_budget/data/models/spend_event_model.dart';
import 'package:src/features/sharing_budget/domain/entities/enums.dart';

void main() {
  group('HouseholdModel fromJson/toJson', () {
    test('round-trip produces identical data', () {
      final original = HouseholdModel(id: 1, name: 'Casa', ownerId: 42);
      final json = original.toJson();
      final restored = HouseholdModel.fromJson(json);
      expect(restored, equals(original));
    });

    test('fromJson maps snake_case keys correctly', () {
      final json = {'id': 3, 'name': 'Dorm Room', 'owner_id': 99};
      final model = HouseholdModel.fromJson(json);
      expect(model.id, 3);
      expect(model.name, 'Dorm Room');
      expect(model.ownerId, 99);
    });

    test('toJson produces snake_case keys for Supabase', () {
      final model = HouseholdModel(id: 1, name: 'Casa', ownerId: 42);
      final json = model.toJson();
      expect(json.containsKey('owner_id'), isTrue);
      expect(json.containsKey('ownerId'), isFalse);
    });

    test('initial() builds without error', () {
      expect(() => HouseholdModel.initial(), returnsNormally);
    });
  });

  group('HouseholdMemberModel fromJson/toJson', () {
    test('round-trip produces identical data', () {
      final original = HouseholdMemberModel(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.editor,
      );
      final json = original.toJson();
      final restored = HouseholdMemberModel.fromJson(json);
      expect(restored, equals(original));
    });

    test('role serializes to string name', () {
      final model = HouseholdMemberModel(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.owner,
      );
      expect(model.toJson()['role'], equals('owner'));
    });

    test('initial() builds without error', () {
      expect(() => HouseholdMemberModel.initial(), returnsNormally);
    });
  });

  group('InviteModel fromJson/toJson', () {
    final now = DateTime(2025, 1, 1, 12, 0, 0);
    final later = DateTime(2025, 1, 8, 12, 0, 0);

    test('round-trip produces identical data', () {
      final original = InviteModel(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'mate@home.com',
        status: InviteStatus.pending,
        createdAt: now,
        expiresAt: later,
      );
      final json = original.toJson();
      final restored = InviteModel.fromJson(json);
      expect(restored, equals(original));
    });

    test('status serializes to string name', () {
      final model = InviteModel(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'mate@home.com',
        status: InviteStatus.accepted,
        createdAt: now,
        expiresAt: later,
      );
      expect(model.toJson()['status'], equals('accepted'));
    });

    test('initial() builds without error', () {
      expect(() => InviteModel.initial(), returnsNormally);
    });
  });

  group('BudgetModel fromJson/toJson', () {
    final startDate = DateTime(2025, 6, 1);

    test('round-trip produces identical data', () {
      final original = BudgetModel(
        id: 1,
        householdId: 5,
        limitAmount: 300.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      final json = original.toJson();
      final restored = BudgetModel.fromJson(json);
      expect(restored, equals(original));
    });

    test('limitAmount handles int JSON values', () {
      final json = {
        'id': 1,
        'household_id': 5,
        'limit_amount': 300,
        'period': 'monthly',
        'start_date': startDate.toIso8601String(),
      };
      final model = BudgetModel.fromJson(json);
      expect(model.limitAmount, 300.0);
      expect(model.limitAmount, isA<double>());
    });

    test('initial() builds without error', () {
      expect(() => BudgetModel.initial(), returnsNormally);
    });
  });

  group('SpendEventModel fromJson/toJson', () {
    final date = DateTime(2025, 6, 15, 10, 30);

    test('round-trip produces identical data', () {
      final original = SpendEventModel(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.scan,
        receiptId: 'REC-001',
      );
      final json = original.toJson();
      final restored = SpendEventModel.fromJson(json);
      expect(restored, equals(original));
    });

    test('null receiptId round-trips correctly', () {
      final original = SpendEventModel(
        id: 2,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 10.0,
        date: date,
        source: SpendSource.manual,
      );
      final json = original.toJson();
      final restored = SpendEventModel.fromJson(json);
      expect(restored.receiptId, isNull);
    });

    test('amount handles int JSON values', () {
      final json = {
        'id': 1,
        'user_id': 10,
        'household_id': 5,
        'product_id': 99,
        'amount': 25,
        'date': date.toIso8601String(),
        'source': 'manual',
        'receipt_id': null,
      };
      final model = SpendEventModel.fromJson(json);
      expect(model.amount, 25.0);
      expect(model.amount, isA<double>());
    });

    test('initial() builds without error', () {
      expect(() => SpendEventModel.initial(), returnsNormally);
    });
  });

  group('BudgetAllocationModel fromJson/toJson', () {
    test('round-trip produces identical data', () {
      const original = BudgetAllocationModel(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.equal,
      );
      final json = original.toJson();
      final restored = BudgetAllocationModel.fromJson(json);
      expect(restored, equals(original));
    });

    test('splitMode serializes to string name', () {
      const model = BudgetAllocationModel(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.weighted,
      );
      expect(model.toJson()['split_mode'], equals('weighted'));
    });

    test('initial() builds without error', () {
      expect(() => BudgetAllocationModel.initial(), returnsNormally);
    });
  });
}
