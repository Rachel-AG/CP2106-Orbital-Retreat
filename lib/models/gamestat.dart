class Gamestat {
  final String id;
  final String createdBy;
  final int level;
  final int gold;
  final double multiplier;
  final int streak;

  Gamestat(this.id, this.createdBy, this.level, this.gold, this.multiplier, this.streak);

  factory Gamestat.fromJson(Map<String, dynamic> json) {
    return Gamestat(
        json['id'] as String,
        json['created_by'] as String,
        json['level'] as int,
        json['gold'] as int,
        json['multiplier'] as double,
        json['streak'] as int);    
  }

}