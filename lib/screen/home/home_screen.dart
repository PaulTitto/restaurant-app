import 'package:flutter/material.dart';
import 'package:restaurant_api/data/model/restaurant_list_response.dart';
import 'package:restaurant_api/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_api/screen/home/restaurant_list_provider.dart';
import 'package:restaurant_api/static/navigation_route.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/static/restaurant_list_result_state.dart';

import '../settings/SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<RestaurantListResponse> _futureRestaurantResponse;

  @override
  void initState() {
    super.initState();
    // _futureRestaurantResponse = ApiServices().getRestaurantList();


    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState){
            RestaurantListLoadingState()=> const Center(
              child: CircularProgressIndicator(),
            ),

            RestaurantListLoadedState(data: var restaurantList) => ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index){
                final restaurant = restaurantList[index];

                return RestaurantCard(
                    restaurant: restaurant,
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          NavigationRoute.detailRoute.name,
                          arguments: restaurant.id
                      );
                    });
              }),
            RestaurantListErrorState(error: var message) => Center(
              child: Text(message),
          ),
          _ => const SizedBox()
          };
        },

      )
    );
    }
  }

