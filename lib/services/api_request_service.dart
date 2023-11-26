import 'package:meta_insights_tft_frontend/models/composition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta_insights_tft_frontend/models/composition_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<List<CompositionGroup>?> getCompositionGroups(String groupBy,
      [String? patch,
      int? combinationSize,
      bool? ignoreSingleUnitTraits,
      int? maxPlacement,
      int? maxAvgPlacement,
      int? minCounter,
      String? region,
      String? league,
      String? championName,
      String? traitName,
      String? itemName,
      DateTime? minDatetime]) async {
    Map<String, String> queryParameters = {};

    addParametersIfNotNull(queryParameters, {
      'patch': patch,
      'combination_size': combinationSize,
      'ignore_single_unit_traits': ignoreSingleUnitTraits,
      'region': region,
      'league': league,
      'min_datetime': minDatetime?.toIso8601String(),
      'max_placement': maxPlacement,
      'max_avg_placement': maxAvgPlacement,
      'min_counter': minCounter,
    });

    if (groupBy == 'champion') {
      addParametersIfNotNull(queryParameters, {
        'champion_name': championName,
      });
    }
    if (groupBy == 'trait') {
      addParametersIfNotNull(queryParameters, {
        'trait_name': traitName,
      });
    }

    var uri = Uri.http(
        'localhost:8000', '/compositionGroup/by-$groupBy', queryParameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return compositionGroupFromJson(jsonString);
    } else {
      return null;
    }
  }

  void addParametersIfNotNull(
      Map<String, String?> queryParameters, Map<String, dynamic> parameters) {
    parameters.forEach((key, value) {
      if (value != null && value != '') {
        queryParameters[key] = value.toString();
      }
    });
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

  Future<List<String>?> getDisplayNames(String table) async {
    var client = http.Client();
    var url = Uri.parse('http://localhost:8000/$table');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((dynamic value) => value.toString())
          .toList();
    } else {
      return null;
    }
  }
}

final apiServiceProvider =
    Provider<ApiRequestService>((ref) => ApiRequestService());
