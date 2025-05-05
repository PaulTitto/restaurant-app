// todo-02-api-02: restructure this folder
// todo-02-api-03: create a folder for API services
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_api/data/model/restaurant_detail_response.dart';
import 'package:restaurant_api/data/model/restaurant_list_response.dart';

class ApiServices {
  // todo-02-api-04: add base url for api
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  // todo-02-api-05: create an end-point to get a list of tourism
  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}