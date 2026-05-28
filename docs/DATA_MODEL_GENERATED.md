# Auto-Generated Data Model Summary
Generated: Tue May 26 23:20:04 SAWST 2026

## auth_user_model.dart

```dart
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.name,
    super.profilePictureUrl,
    super.birthday,
  });

  factory AuthUserModel.fromEntity(AuthUser entity) {
    return AuthUserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      profilePictureUrl: entity.profilePictureUrl,
      birthday: entity.birthday,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
```

## todo_model.dart

```dart
class TodoModel extends TodoEntity {
  TodoModel({
    required super.id,
    required super.name,
    super.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'completed': completed};
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      name: json['name'],
      completed: json['completed'],
    );
  }

  TodoEntity toEntity() {
    return TodoEntity(id: id, name: name, completed: completed);
```

## budget_allocation_model.dart

```dart
class BudgetAllocationModel extends BudgetAllocationEntity {
  const BudgetAllocationModel({
    required super.id,
    required super.spendEventId,
    required super.userId,
    required super.allocatedAmount,
    required super.splitMode,
  });

  factory BudgetAllocationModel.fromEntity(BudgetAllocationEntity entity) {
    return BudgetAllocationModel(
      id: entity.id,
      spendEventId: entity.spendEventId,
      userId: entity.userId,
      allocatedAmount: entity.allocatedAmount,
      splitMode: entity.splitMode,
    );
  }

  BudgetAllocationEntity toEntity() {
    return this as BudgetAllocationEntity;
```

## budget_model.dart

```dart
class BudgetModel extends BudgetEntity {
  const BudgetModel({
    required super.id,
    required super.householdId,
    required super.limitAmount,
    required super.period,
    required super.startDate,
  });

  factory BudgetModel.fromEntity(BudgetEntity entity) {
    return BudgetModel(
      id: entity.id,
      householdId: entity.householdId,
      limitAmount: entity.limitAmount,
      period: entity.period,
      startDate: entity.startDate,
    );
  }

  BudgetEntity toEntity() {
    return BudgetEntity(
```

## expense_model.dart

```dart
class ExpenseModel {
  final int id;
  final int householdId;
  final int? userId;
  final double amount;
  final String? category;
  final String? description;
  final DateTime incurredOn;
  final DateTime createdAt;

  const ExpenseModel({
    required this.id,
    required this.householdId,
    this.userId,
    required this.amount,
    this.category,
    this.description,
    required this.incurredOn,
    required this.createdAt,
  });

```

## household_member_model.dart

```dart
class HouseholdMemberModel extends HouseholdMemberEntity {
  const HouseholdMemberModel({
    required super.id,
    required super.householdId,
    required super.userId,
    required super.role,
  });

  factory HouseholdMemberModel.fromEntity(HouseholdMemberEntity entity) {
    return HouseholdMemberModel(
      id: entity.id,
      householdId: entity.householdId,
      userId: entity.userId,
      role: entity.role,
    );
  }

  HouseholdMemberEntity toEntity() {
    return HouseholdMemberEntity(
      id: id,
      householdId: householdId,
```

## household_model.dart

```dart
class HouseholdModel extends HouseholdEntity {
  const HouseholdModel({
    required super.id,
    required super.name,
    required super.ownerId,
  });

  factory HouseholdModel.fromEntity(HouseholdEntity entity) {
    return HouseholdModel(
      id: entity.id,
      name: entity.name,
      ownerId: entity.ownerId,
    );
  }

  HouseholdEntity toEntity() {
    return HouseholdEntity(
      id: id,
      name: name,
      ownerId: ownerId,
    );
```

## household_summary_model.dart

```dart
class HouseholdSummaryModel {
  final int id;
  final int householdId;
  final String? month;
  final double totalSpent;
  final double budgetLimit;
  final DateTime updatedAt;

  const HouseholdSummaryModel({
    required this.id,
    required this.householdId,
    this.month,
    required this.totalSpent,
    required this.budgetLimit,
    required this.updatedAt,
  });

  factory HouseholdSummaryModel.fromMap(Map<String, dynamic> map) {
    return HouseholdSummaryModel(
      id: map['id'] as int,
      householdId: map['household_id'] as int,
```

## invite_model.dart

```dart
class InviteModel extends InviteEntity {
  const InviteModel({
    required super.id,
    required super.householdId,
    required super.invitedByUserId,
    required super.invitedEmail,
    required super.status,
    required super.createdAt,
    required super.expiresAt,
  });

  factory InviteModel.fromEntity(InviteEntity entity) {
    return InviteModel(
      id: entity.id,
      householdId: entity.householdId,
      invitedByUserId: entity.invitedByUserId,
      invitedEmail: entity.invitedEmail,
      status: entity.status,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
    );
```

## invite_token_model.dart

```dart
class InviteTokenModel {
  final int id;
  final int householdId;
  final String token;
  final DateTime? expiresAt;
  final DateTime? usedAt;
  final DateTime createdAt;

  const InviteTokenModel({
    required this.id,
    required this.householdId,
    required this.token,
    this.expiresAt,
    this.usedAt,
    required this.createdAt,
  });

  factory InviteTokenModel.fromMap(Map<String, dynamic> map) {
    return InviteTokenModel(
      id: map['id'] as int,
      householdId: map['household_id'] as int,
```

## spend_event_model.dart

```dart
class SpendEventModel extends SpendEventEntity {
  const SpendEventModel({
    required super.id,
    required super.userId,
    required super.householdId,
    required super.productId,
    required super.amount,
    required super.date,
    required super.source,
    super.receiptId,
  });

  factory SpendEventModel.fromEntity(SpendEventEntity entity) {
    return SpendEventModel(
      id: entity.id,
      userId: entity.userId,
      householdId: entity.householdId,
      productId: entity.productId,
      amount: entity.amount,
      date: entity.date,
      source: entity.source,
```

