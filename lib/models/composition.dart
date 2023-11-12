import 'dart:convert';

List<Composition> compositionFromJson(String str) => List<Composition>.from(
    json.decode(str).map((x) => Composition.fromJson(x)));

String compositionToJson(List<Composition> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Composition {
  int id;
  String matchId;
  int level;
  int placement;
  String patch;
  String region;
  DateTime matchTime;

  Composition({
    required this.id,
    required this.matchId,
    required this.level,
    required this.placement,
    required this.patch,
    required this.region,
    required this.matchTime,
  });

  factory Composition.fromJson(Map<String, dynamic> json) => Composition(
        id: json["id"],
        matchId: json["match_id"],
        level: json["level"],
        placement: json["placement"],
        patch: json["patch"],
        region: json["region"],
        matchTime: DateTime.parse(json["match_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "match_id": matchId,
        "level": level,
        "placement": placement,
        "patch": patch,
        "region": region,
        "match_time": matchTime.toIso8601String(),
      };
}
