class Transactions {
  final String id;
  final String name;
  final double price;
  final String time;
  final String created_by;
  final int category_id;

  Transactions(this.id, this.name, this.price, this.time, this.created_by, this.category_id);

  factory Transactions.fromJson(Map<String, dynamic> json) { //??
    return Transactions(json['id'] as String, 
                        json['name'] as String,
                        json['price'] as double,
                        json['time'] as String,
                        json['created_by'] as String,
                        json['category_id'] as int);
  }

  @override
  String toString() {
    return 'id: $id, name: $name, price: $price, time: $time, created by: $created_by, category id: $category_id';
  }
}
