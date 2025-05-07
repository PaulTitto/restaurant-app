import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_api/data/api/api_services.dart';
import 'package:restaurant_api/data/model/restaurant_list_response.dart';
import 'package:restaurant_api/data/model/restaurant.dart'; // ✅ FIXED
import 'package:restaurant_api/screen/home/restaurant_list_provider.dart'; // ✅ FIXED
import 'package:restaurant_api/static/restaurant_list_result_state.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockApiServices mockApiServices;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiServices = MockApiServices();
    provider = RestaurantListProvider(mockApiServices);
  });

  test('State awal provider harus RestaurantListNoneState', () {
    expect(provider.resultState, isA<RestaurantListNoneState>());
  });

  test('Mengembalikan daftar restoran saat API sukses', () async {
    final dummyRestaurants = [
      Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'Test Description',
        pictureId: '1',
        city: 'Test City',
        rating: 4.5,
      ),
    ];

    final response = RestaurantListResponse(
      error: false,
      message: 'success',
      count: 1,
      restaurants: dummyRestaurants,
    );

    when(() => mockApiServices.getRestaurantList())
        .thenAnswer((_) async => response);

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListLoadedState>());

    final state = provider.resultState as RestaurantListLoadedState;
    expect(state.data, equals(dummyRestaurants));

    verify(() => mockApiServices.getRestaurantList()).called(1);
  });

  test('Mengembalikan error saat API gagal', () async {
    final response = RestaurantListResponse(
      error: true,
      message: 'API error',
      count: 0,
      restaurants: [],
    );

    when(() => mockApiServices.getRestaurantList())
        .thenAnswer((_) async => response);

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListErrorState>());

    final state = provider.resultState as RestaurantListErrorState;
    expect(state.error, equals('API error'));

    verify(() => mockApiServices.getRestaurantList()).called(1);
  });

  test('Mengembalikan error saat exception dilempar', () async {
    when(() => mockApiServices.getRestaurantList())
        .thenThrow(Exception('Network Error'));

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListErrorState>());

    final state = provider.resultState as RestaurantListErrorState;
    expect(state.error, contains('Exception: Network Error'));

    verify(() => mockApiServices.getRestaurantList()).called(1);
  });
}
