class Transaction {
  final String id;
  final String notes;
  final double amount;
  final String timeTransaction;
  final String timeCreated;
  final String created_by;
  final String category;
  final bool isExpense;

  Transaction(this.id, this.notes, this.amount, this.timeTransaction, this.timeCreated,
  this.created_by, this.category, this.isExpense);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        json['id'] as String,
        json['notes'] as String,
        json['amount'].toDouble() as double,
        json['timeTransaction'] as String,
        json['timeCreated'] as String,
        json['created_by'] as String,
        json['category'] as String,
        json['isExpense'] as bool);
  }

  @override
  String toString() {
    return 'id: $id, notes: $notes, amount: $amount, time: $timeTransaction, created by: $created_by, category: $category, isExpense: $isExpense';
  }
}
