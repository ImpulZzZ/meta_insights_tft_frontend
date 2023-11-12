import 'dart:convert';

List<CompositionGroup> compositionGroupFromJson(String str) =>
    List<CompositionGroup>.from(
        json.decode(str).map((x) => CompositionGroup.fromJson(x)));

String compositionGroupToJson(List<CompositionGroup> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompositionGroup {
  int counter;
  Map<String, int> traitStyles;
  double avgPlacement;

  CompositionGroup({
    required this.counter,
    required this.traitStyles,
    required this.avgPlacement,
  });

  factory CompositionGroup.fromJson(Map<String, dynamic> json) =>
      CompositionGroup(
        counter: json["counter"],
        traitStyles: Map.from(json["trait_styles"])
            .map((k, v) => MapEntry<String, int>(k, v)),
        avgPlacement: json["avg_placement"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "counter": counter,
        "trait_styles": Map.from(traitStyles)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "avg_placement": avgPlacement,
      };

  String getCounter() {
    return counter.toString();
  }

  String getAvgPlacement() {
    return avgPlacement.toString();
  }

  String getTraitStylesString() {
    return traitStyles.toString();
  }

  Map<String, int> getTraitStyles() {
    return traitStyles;
  }
}
