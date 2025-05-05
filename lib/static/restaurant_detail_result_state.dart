import 'package:restaurant_api/data/model/restaurant_detail_response.dart';

sealed class RestaurantDetailResultState{}


class RestaurantDetailNoneState extends RestaurantDetailResultState {}

class RestaurantDetailLoadingState extends RestaurantDetailResultState {}

class RestaurantDetailErrorState extends RestaurantDetailResultState {
  final String error;

  RestaurantDetailErrorState(this.error);
}

class RestaurantDetailLoadedState extends RestaurantDetailResultState {
  final Restaurant data;

  RestaurantDetailLoadedState(this.data);
}