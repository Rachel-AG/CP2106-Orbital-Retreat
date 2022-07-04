class Island {
  final int gridRadius;
  final int maxHeight;
  final int steepness;
  final String seed;
  final List<double> ratios;
  final int maxAnimal;
  final List<String> animalList;
  final List<String> envList;
  final bool dayBool;
  final bool cloudBool;

  Island(
      this.gridRadius,
      this.maxHeight,
      this.steepness,
      this.seed,
      this.ratios,
      this.maxAnimal,
      this.animalList,
      this.envList,
      this.dayBool,
      this.cloudBool);
}
