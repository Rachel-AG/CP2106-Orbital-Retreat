import 'dart:convert';

import 'package:equatable/equatable.dart';

class Island extends Equatable {
  final String id;
  final int gridRadius;
  final int maxHeight;
  final int steepness;
  final String seed;
  final List ratio;
  final int maxAnimal;
  final List animalList;
  final List envList;
  final bool dayBool;
  final bool cloudBool;
  final String createdBy;

  const Island(
      this.id,
      this.gridRadius,
      this.maxHeight,
      this.steepness,
      this.seed,
      this.ratio,
      this.maxAnimal,
      this.animalList,
      this.envList,
      this.dayBool,
      this.cloudBool,
      this.createdBy);

  @override
  List<Object> get props => [
        id,
        gridRadius,
        maxHeight,
        steepness,
        seed,
        ratio,
        maxAnimal,
        animalList,
        envList,
        dayBool,
        cloudBool,
        createdBy
      ];

  factory Island.fromJson(Map<String, dynamic> json) {
    List ratio = jsonDecode(json['ratio']);
    List animalList = jsonDecode(json['animal_list']);
    List envList = jsonDecode(json['env_list']);
    return Island(
      json['id'] as String,
      json['grid_radius'] as int,
      json['max_height'] as int,
      json['steepness'] as int,
      json['seed'] as String,
      ratio,
      json['max_animal'] as int,
      animalList,
      envList,
      json['day_bool'] as bool,
      json['cloud_bool'] as bool,
      json['created_by'] as String,
    );
  }
}
