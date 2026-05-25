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

  group('BudgetEntity computedEndDate', () {
    test('weekly: ends 6 days after startDate', () {
      final budget = BudgetEntity(
        id: 1, householdId: 1, limitAmount: 100,
        period: BudgetPeriod.weekly,
        startDate: DateTime(2026, 3, 2),
      );
      expect(budget.computedEndDate, DateTime(2026, 3, 8));
    });

    test('monthly: ends the day before the same date next month', () {
      final budget = BudgetEntity(
        id: 1, householdId: 1, limitAmount: 100,
        period: BudgetPeriod.monthly,
        startDate: DateTime(2026, 1, 15),
      );
      expect(budget.computedEndDate, DateTime(2026, 2, 14));
    });

    test('monthly: wraps correctly across year boundary', () {
      final budget = BudgetEntity(
        id: 1, householdId: 1, limitAmount: 100,
        period: BudgetPeriod.monthly,
        startDate: DateTime(2026, 12, 1),
      );
      expect(budget.computedEndDate, DateTime(2026, 12, 31));
    });

    test('yearly: ends the day before the same date next year', () {
      final budget = BudgetEntity(
        id: 1, householdId: 1, limitAmount: 100,
        period: BudgetPeriod.yearly,
        startDate: DateTime(2026, 1, 15),
      );
      expect(budget.computedEndDate, DateTime(2027, 1, 14));
    });
  });

  group('BudgetEntity covers()', () {
    final monthly = BudgetEntity(
      id: 1, householdId: 1, limitAmount: 500,
      period: BudgetPeriod.monthly,
      startDate: DateTime(2026, 3, 10),
    );

    test('start date is covered', () {
      expect(monthly.covers(DateTime(2026, 3, 10)), isTrue);
    });

    test('end date is covered', () {
      expect(monthly.covers(DateTime(2026, 4, 9)), isTrue);
    });

    test('day after end date is not covered', () {
      expect(monthly.covers(DateTime(2026, 4, 10)), isFalse);
    });

    test('day before start date is not covered', () {
      expect(monthly.covers(DateTime(2026, 3, 9)), isFalse);
    });

    test('mid-period date is covered', () {
      expect(monthly.covers(DateTime(2026, 3, 25)), isTrue);
    });

    test('time-of-day is ignored: midnight on start date is covered', () {
      expect(monthly.covers(DateTime(2026, 3, 10, 0, 0, 0)), isTrue);
    });

    test('time-of-day is ignored: end of day on end date is covered', () {
      expect(monthly.covers(DateTime(2026, 4, 9, 23, 59, 59)), isTrue);
    });

    test('weekly covers exactly 7 days', () {
      final weekly = BudgetEntity(
        id: 2, householdId: 1, limitAmount: 100,
        period: BudgetPeriod.weekly,
        startDate: DateTime(2026, 3, 2),
      );
      expect(weekly.covers(DateTime(2026, 3, 2)), isTrue);
      expect(weekly.covers(DateTime(2026, 3, 8)), isTrue);
      expect(weekly.covers(DateTime(2026, 3, 9)), isFalse);
    });

    test('yearly covers correct range', () {
      final yearly = BudgetEntity(
        id: 3, householdId: 1, limitAmount: 5000,
        period: BudgetPeriod.yearly,
        startDate: DateTime(2026, 6, 1),
      );
      expect(yearly.covers(DateTime(2026, 6, 1)), isTrue);
      expect(yearly.covers(DateTime(2027, 5, 31)), isTrue);
      expect(yearly.covers(DateTime(2027, 6, 1)), isFalse);
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
