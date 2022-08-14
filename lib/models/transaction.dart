import 'package:equatable/equatable.dart';

/// a model class for user transaction
class Transaction extends Equatable {
  final String id;
  final String notes;
  final double amount;
  final String timeTransaction;
  final String timeCreated;
  final String createdBy;
  final bool isExpense;
  final int categoryId;

  const Transaction(this.id, this.notes, this.amount, this.timeTransaction,
      this.timeCreated, this.createdBy, this.isExpense, this.categoryId);

  @override
  List<Object> get props => [
        id,
        notes,
        amount,
        timeTransaction,
        timeCreated,
        createdBy,
        isExpense,
        categoryId
      ];

  /// factory method to convert json data to this class
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        json['id'] as String,
        json['notes'] as String,
        json['amount'].toDouble() as double,
        json['time_transaction'] as String,
        json['time_created'] as String,
        json['created_by'] as String,
        json['is_expense'] as bool,
        json['category_id'] as int);
  }

  @override
  String toString() {
    return 'id: $id, notes: $notes, amount: $amount, time: $timeTransaction, created by: $createdBy, isExpense: $isExpense';
  }
}
