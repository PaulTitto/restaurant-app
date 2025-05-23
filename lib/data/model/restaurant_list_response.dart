// To parse this JSON data, do
//
//     final restaurantListResponse = restaurantListResponseFromJson(jsonString);

import 'dart:convert';

import 'restaurant.dart';

RestaurantListResponse restaurantListResponseFromJson(String str) => RestaurantListResponse.fromJson(json.decode(str));

String restaurantListResponseToJson(RestaurantListResponse data) => json.encode(data.toJson());

class RestaurantListResponse {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) => RestaurantListResponse(
    error: json["error"],
    message: json["message"],
    count: json["count"],
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

