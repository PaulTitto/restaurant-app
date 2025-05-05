import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/screen/detail/restaurant_detail_provider.dart';
import 'package:restaurant_api/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch restaurant detail via Provider
    Future.microtask(() {
      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.resultState;

          if (state is RestaurantDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else switch (state) {
            case RestaurantDetailErrorState():
              return Center(child: Text(state.error));
            case RestaurantDetailLoadedState():
              final restaurant = state.data;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 4),
                          Text(restaurant.address, ),
                          const SizedBox(width: 4),
                          Text(restaurant.city),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(restaurant.rating.toString()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        restaurant.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Menus',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Foods:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: restaurant.menus.foods
                            .map((food) => Chip(
                          label: Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Drinks:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: restaurant.menus.drinks
                            .map((drink) => Chip(
                          label: Text(
                            drink.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
