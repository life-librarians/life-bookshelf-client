import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_bookshelf/main_app.dart';
import 'package:life_bookshelf/services/userpreferences_service.dart';

void main() async {
  /* Open .env file */
  await dotenv.load(fileName: "assets/config/.env");
  await initializeDateFormatting();
  await UserPreferences.init();
  runApp(const MainApp(initialRoute: "/"));
}
