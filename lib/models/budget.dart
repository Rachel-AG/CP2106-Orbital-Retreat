class Budget {
  final String id;
  final String createdAt;
  final String createdBy;
  final double amount;
  final int month;
  final int year;

  Budget(this.id, this.createdAt, this.createdBy,this.amount, this.month, this.year);

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
