import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/data/model/restaurant.dart';

import '../bookmark/bookmark_icon_provider.dart';
import '../bookmark/local_database_provider.dart';

class BookmarkIconWidget extends StatefulWidget {
  final Restaurant restaurant;

  const BookmarkIconWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
}

class _BookmarkIconWidgetState extends State<BookmarkIconWidget> {
  @override
  void initState() {
    super.initState();
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final bookmarkIconProvider = context.read<BookmarkIconProvider>();

    Future.microtask(() async {
      await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
      final value = localDatabaseProvider.checkRestaurantBookmark(widget.restaurant.id);
      bookmarkIconProvider.isBookmarked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final bookmarkIconProvider = context.read<BookmarkIconProvider>();
        final isBookmarked = bookmarkIconProvider.isBookmarked;

        if (isBookmarked) {
          await localDatabaseProvider.removeRestaurantById(widget.restaurant.id);
        } else {
          await localDatabaseProvider.saveRestaurant(widget.restaurant);
        }
        bookmarkIconProvider.isBookmarked = !isBookmarked;
        localDatabaseProvider.loadAllRestaurants();
      },
      icon: Icon(
        context.watch<BookmarkIconProvider>().isBookmarked
            ? Icons.bookmark
            : Icons.bookmark_outline,
      ),
    );
  }
}