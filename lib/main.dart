import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_app/Screen/quotes_detail.dart';
import 'package:quote_app/Screen/splash_screen.dart';
import 'package:quote_app/utils/quotes_list.dart';
import 'package:sqflite/sqflite.dart';

import 'Screen/category_screen.dart';
import 'Screen/home_screen.dart';

Future<void> copyDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'database.db');

  bool fileExists = await databaseExists(path);

  if (!fileExists) {
    ByteData data = await rootBundle.load(join('assets/database/Quote.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await copyDatabase();
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'database.db');
  Database database = await openDatabase(path);

  MyList.quotesList = await database.rawQuery('SELECT * FROM Quote');
  MyList.quotesList.toList().toSet();
  print(MyList.quotesList.length);
  runApp(
    MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'lobster',
          ),
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            fontFamily: 'lobster',
          ),
          bodyText1: TextStyle(
            fontFamily: "lobster",
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        'home': (context) => const HomeScreen(),
        'Category': (context) => const Category(),
        'detail': (context) => const QuoteDetail(),
      },
    ),
  );
}
