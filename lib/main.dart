import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_api/data/local/local_database_service.dart';
import 'package:restaurant_api/screen/bookmark/local_database_provider.dart';
import 'package:restaurant_api/screen/detail/detail_screen.dart';
import 'package:restaurant_api/screen/detail/restaurant_detail_provider.dart';
import 'package:restaurant_api/screen/home/restaurant_list_provider.dart';
import 'package:restaurant_api/screen/main/index_nav_provider.dart';
import 'package:restaurant_api/screen/main/main_screen.dart';
import 'package:restaurant_api/screen/theme_provider.dart';
import 'package:restaurant_api/static/navigation_route.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'data/api/api_services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (contex) => IndexNavProvider()),
        Provider(
          create: (context) => ApiServices(),
        ),
        // ChangeNotifierProvider(create: (context) => BookmarkScreen()),
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (context)=> LocalDatabaseService()),
        ChangeNotifierProvider(create: (context) =>LocalDatabaseProvider(
          context.read<LocalDatabaseService>()
        ))


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
              brightness: Brightness.light,
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
              brightness: Brightness.dark,
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
          initialRoute: NavigationRoute.mainRoute.name,
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
