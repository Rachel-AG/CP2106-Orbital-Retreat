class Item {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String type;

  Item(this.id, this.name, this.price, this.imageUrl, this.type);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        json['id'].toString() as String,
        json['name'] as String,
        json['price'] as int,
        json['image_url'] as String,
        json['type'] as String
        );
  }

}