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
      String? combinationSize,
      bool? ignoreSingleUnitTraits,
      int? maxPlacement,
      int? maxAvgPlacement,
      int? minCounter,
      String? region,
      String? league,
      DateTime? minDatetime]) async {
    Map<String, String> queryParameters = {};

    int? combinationSizeParam;
    if (combinationSize != null && combinationSize.isNotEmpty) {
      combinationSizeParam = int.parse(combinationSize);
      if (groupBy == 'champion') {
        combinationSizeParam = combinationSizeParam.clamp(1, 2);
      } else {
        combinationSizeParam = combinationSizeParam.clamp(1, 7);
      }
    }

    int? maxPlacementParam = maxPlacement?.clamp(1, 8);
    int? maxAvgPlacementParam = maxAvgPlacement?.clamp(1, 8);
    int? minCounterParam = minCounter?.clamp(1, 999);

    addParametersIfNotNull(queryParameters, {
      'patch': patch,
      'combination_size': combinationSizeParam,
      'ignore_single_unit_traits': ignoreSingleUnitTraits,
      'region': region,
      'league': league,
      'min_datetime': minDatetime?.toIso8601String(),
      'max_placement': maxPlacementParam,
      'max_avg_placement': maxAvgPlacementParam,
      'min_counter': minCounterParam,
    });

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
      if (value != null) {
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
