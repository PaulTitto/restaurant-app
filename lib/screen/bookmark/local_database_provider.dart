import 'package:flutter/widgets.dart';
import '../../data/local/local_database_service.dart';
import '../../data/model/restaurant.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  // Function to save a restaurant
  Future<void> saveRestaurant(Restaurant value) async {
    try {
      final result = await _service.insertRestaurant(value); // Call service to save restaurant

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your restaurant data";
      } else {
        _message = "Your restaurant data is saved";
      }
      notifyListeners(); // Notify listeners of state change
    } catch (e) {
      _message = "Failed to save your restaurant data";
      notifyListeners();
    }
  }

  // Load all restaurants
  Future<void> loadAllRestaurants() async {
    try {
      _restaurantList = await _service.getAllRestaurants(); // Get all restaurants
      _message = "All of your restaurant data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your restaurant data";
      notifyListeners();
    }
  }

  // Load a specific restaurant by id
  Future<void> loadRestaurantById(String id) async {
    try {
      _restaurant = await _service.getRestaurantById(id); // Get restaurant by ID
      _message = "Your restaurant data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your restaurant data";
      notifyListeners();
    }
  }

  // Remove a restaurant by id
  Future<void> removeRestaurantById(String id) async {
    try {
      await _service.removeRestaurant(id); // Remove restaurant from database

      _message = "Your restaurant data is removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your restaurant data";
      notifyListeners();
    }
  }

  // Check if a restaurant is bookmarked
  bool checkRestaurantBookmark(String id) {
    final isSameRestaurant = _restaurant?.id == id; // Compare with current restaurant
    return isSameRestaurant;
  }
}
