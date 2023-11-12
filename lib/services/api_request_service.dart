import 'package:meta_insights_tft_frontend/models/composition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta_insights_tft_frontend/models/composition_group.dart';

class ApiRequestService {
  Future<List<Composition>?> getCompositions() async {
    var client = http.Client();
    var url = Uri.parse('http://localhost:8000/composition/get-data');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return compositionFromJson(jsonString);
    } else {
      return null;
    }
  }

  Future<List<CompositionGroup>?> getCompositionGroups(String groupBy) async {
    var client = http.Client();
    var url = Uri.parse('http://localhost:8000/compositionGroup/by-$groupBy');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return compositionGroupFromJson(jsonString);
    } else {
      return null;
    }
  }

  Future<Map<String, String>?> getIconMap(String table) async {
    var client = http.Client();
    var url = Uri.parse('http://localhost:8000/$table/icons');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      return (json.decode(response.body) as Map<String, dynamic>)
          .map((key, dynamic value) => MapEntry(key, value.toString()));
    } else {
      return null;
    }
  }
}
