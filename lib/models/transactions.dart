class Transactions {
  final String id;
  final String notes;
  final double amount;
  final String time;
  final String created_by;
  final String category;

  Transactions(this.id, this.notes, this.amount, this.time, this.created_by,
      this.category);

  factory Transactions.fromJson(Map<String, dynamic> json) {
    //??
    return Transactions(
        json['id'] as String,
        json['notes'] as String,
        json['amount'].toDouble() as double,
        json['time'] as String,
        json['created_by'] as String,
        json['category'] as String);
  }

  @override
  String toString() {
    return 'id: $id, notes: $notes, amount: $amount, time: $time, created by: $created_by, category: $category';
  }
}
