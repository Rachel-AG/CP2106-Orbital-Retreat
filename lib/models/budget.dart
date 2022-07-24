
import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String createdAt;
  final String createdBy;
  final double amount;
  final int month;
  final int year;

  const Budget(this.id, this.createdAt, this.createdBy, this.amount, this.month,
      this.year);

  @override
  List<Object> get props => [id, createdAt, createdBy, amount, month, year];

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
        json['id'] as String,
        json['created_at'] as String,
        json['created_by'] as String,
        json['amount'].toDouble() as double,
        json['month'] as int,
        json['year'] as int);
  }
}
