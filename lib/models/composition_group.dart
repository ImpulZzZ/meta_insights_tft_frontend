import 'dart:convert';

List<CompositionGroup> compositionGroupFromJson(String str) =>
    List<CompositionGroup>.from(
        json.decode(str).map((x) => CompositionGroup.fromJson(x)));

String compositionGroupToJson(List<CompositionGroup> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompositionGroup {
  int counter;
  Map<String, int> combination;
  double avgPlacement;

  CompositionGroup({
    required this.counter,
    required this.combination,
    required this.avgPlacement,
  });

  factory CompositionGroup.fromJson(Map<String, dynamic> json) =>
      CompositionGroup(
        counter: json["counter"],
        combination: Map.from(json["combination"])
            .map((k, v) => MapEntry<String, int>(k, v)),
        avgPlacement: json["avg_placement"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "counter": counter,
        "combination": Map.from(combination)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "avg_placement": avgPlacement,
      };

  String getCounter() {
    return counter.toString();
  }

  String getAvgPlacement() {
    return avgPlacement.toString();
  }

  String getCombinationString() {
    return combination.toString();
  }

  Map<String, int> getCombination() {
    return combination;
  }
}
