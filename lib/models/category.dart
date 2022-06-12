class Category {
  final int id;
  final String name;
  final bool isExpense;

  Category(this.id, this.name, this.isExpense);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        json['id'] as int, json['name'] as String, json['is_expense'] as bool);
  }

  @override
  String toString() {
    return 'id: $id, name: $name, expense: $isExpense';
  }
}
