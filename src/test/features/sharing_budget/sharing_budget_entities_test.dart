import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/sharing_budget/domain/entities/budget_allocation_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/household_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/household_member_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/invite_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';

void main() {
  group('HouseholdEntity equality', () {
    test('two instances with same data are equal', () {
      const a = HouseholdEntity(id: 1, name: 'My Home', ownerId: 10);
      const b = HouseholdEntity(id: 1, name: 'My Home', ownerId: 10);
      expect(a, equals(b));
    });

    test('two instances with different id are not equal', () {
      const a = HouseholdEntity(id: 1, name: 'My Home', ownerId: 10);
      const b = HouseholdEntity(id: 2, name: 'My Home', ownerId: 10);
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      const a = HouseholdEntity(id: 1, name: 'My Home', ownerId: 10);
      const b = HouseholdEntity(id: 1, name: 'My Home', ownerId: 10);
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('HouseholdMemberEntity equality', () {
    test('two instances with same data are equal', () {
      const a = HouseholdMemberEntity(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.editor,
      );
      const b = HouseholdMemberEntity(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.editor,
      );
      expect(a, equals(b));
    });

    test('different role produces not equal', () {
      const a = HouseholdMemberEntity(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.editor,
      );
      const b = HouseholdMemberEntity(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.viewer,
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      const a = HouseholdMemberEntity(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.editor,
      );
      const b = HouseholdMemberEntity(
        id: 1,
        householdId: 5,
        userId: 10,
        role: MemberRole.editor,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('InviteEntity equality', () {
    final now = DateTime(2025, 1, 1);
    final later = DateTime(2025, 1, 8);

    test('two instances with same data are equal', () {
      final a = InviteEntity(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'room@mate.com',
        status: InviteStatus.pending,
        createdAt: now,
        expiresAt: later,
      );
      final b = InviteEntity(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'room@mate.com',
        status: InviteStatus.pending,
        createdAt: now,
        expiresAt: later,
      );
      expect(a, equals(b));
    });

    test('different status produces not equal', () {
      final a = InviteEntity(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'room@mate.com',
        status: InviteStatus.pending,
        createdAt: now,
        expiresAt: later,
      );
      final b = InviteEntity(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'room@mate.com',
        status: InviteStatus.accepted,
        createdAt: now,
        expiresAt: later,
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      final a = InviteEntity(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'room@mate.com',
        status: InviteStatus.pending,
        createdAt: now,
        expiresAt: later,
      );
      final b = InviteEntity(
        id: 1,
        householdId: 5,
        invitedByUserId: 10,
        invitedEmail: 'room@mate.com',
        status: InviteStatus.pending,
        createdAt: now,
        expiresAt: later,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('BudgetEntity equality', () {
    final startDate = DateTime(2025, 1, 1);

    test('two instances with same data are equal', () {
      final a = BudgetEntity(
        id: 1,
        householdId: 5,
        limitAmount: 500.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      final b = BudgetEntity(
        id: 1,
        householdId: 5,
        limitAmount: 500.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      expect(a, equals(b));
    });

    test('different limitAmount produces not equal', () {
      final a = BudgetEntity(
        id: 1,
        householdId: 5,
        limitAmount: 500.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      final b = BudgetEntity(
        id: 1,
        householdId: 5,
        limitAmount: 750.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      final a = BudgetEntity(
        id: 1,
        householdId: 5,
        limitAmount: 500.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      final b = BudgetEntity(
        id: 1,
        householdId: 5,
        limitAmount: 500.0,
        period: BudgetPeriod.monthly,
        startDate: startDate,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('SpendEventEntity equality', () {
    final date = DateTime(2025, 6, 15);

    test('two instances with same data are equal', () {
      final a = SpendEventEntity(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.manual,
        receiptId: 'REC-001',
      );
      final b = SpendEventEntity(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.manual,
        receiptId: 'REC-001',
      );
      expect(a, equals(b));
    });

    test('null receiptId vs provided receiptId produces not equal', () {
      final a = SpendEventEntity(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.manual,
      );
      final b = SpendEventEntity(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.manual,
        receiptId: 'REC-001',
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      final a = SpendEventEntity(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.manual,
      );
      final b = SpendEventEntity(
        id: 1,
        userId: 10,
        householdId: 5,
        productId: 99,
        amount: 25.50,
        date: date,
        source: SpendSource.manual,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('BudgetAllocationEntity equality', () {
    test('two instances with same data are equal', () {
      const a = BudgetAllocationEntity(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.equal,
      );
      const b = BudgetAllocationEntity(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.equal,
      );
      expect(a, equals(b));
    });

    test('different splitMode produces not equal', () {
      const a = BudgetAllocationEntity(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.equal,
      );
      const b = BudgetAllocationEntity(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.custom,
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent with equality', () {
      const a = BudgetAllocationEntity(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.equal,
      );
      const b = BudgetAllocationEntity(
        id: 1,
        spendEventId: 7,
        userId: 10,
        allocatedAmount: 12.75,
        splitMode: SplitMode.equal,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
