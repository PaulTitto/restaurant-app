import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../static/navigation_route.dart';
import '../home/restaurant_card_widget.dart';
import 'local_database_provider.dart';


class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark List"),
      ),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          final bookmarkList = value.restaurantList ?? [];
          return switch (bookmarkList.isNotEmpty) {
            true => ListView.builder(
              itemCount: bookmarkList.length,
              itemBuilder: (context, index) {
                final restaurant = bookmarkList[index];

                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.name,
                      arguments: restaurant.id,
                    );
                  },
                );
              },
            ),
            _ => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Bookmarked"),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}