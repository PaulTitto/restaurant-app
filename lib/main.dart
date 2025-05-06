import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/screen/detail/detail_screen.dart';
import 'package:restaurant_api/screen/detail/restaurant_detail_provider.dart';
import 'package:restaurant_api/screen/main/main_screen.dart';
import 'package:restaurant_api/screen/main/restaurant_list_provider.dart';
import 'package:restaurant_api/screen/theme_provider.dart';
import 'package:restaurant_api/static/navigation_route.dart';

import 'data/api/api_services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => ApiServices(),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantListProvider(
            context.read<ApiServices>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            context.read<ApiServices>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Restaurant App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light, // ✅ tambahkan brightness
            ),
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            chipTheme: const ChipThemeData(
              backgroundColor: Colors.tealAccent,
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark, // ✅ tambahkan brightness
            ),
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            chipTheme: const ChipThemeData(
              backgroundColor: Colors.deepOrangeAccent,
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          themeMode: themeProvider.themeMode,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId: ModalRoute.of(context)?.settings.arguments as String,
            ),
          },
        );
      },
    );
  }
}
