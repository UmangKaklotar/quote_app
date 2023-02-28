import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyList {
  static List<Map<String, dynamic>> quotesList = [];

  static List<Map<String, dynamic>> uniqueList = [];

  static List<Map<String, dynamic>> favourite = [];

  static List<Map<String, dynamic>> category = [
    {
      'catName': 'Categories',
      'icon': CupertinoIcons.square_grid_2x2,
      'color': const Color(0xffA7727D),
      'route': "Category",
    },
    {
      'catName': 'Pic Quotes',
      'icon': CupertinoIcons.photo,
      'color': const Color(0xff4355B6),
      'route': 'detail',
    },
    {
      'catName': 'Latest Quotes',
      'icon': Icons.local_attraction_rounded,
      'color': const Color(0xffD3756B),
      'route': "detail",
    },
    {
      'catName': 'Articles',
      'icon': CupertinoIcons.book,
      'color': const Color(0xff61876E),
      'route': "detail",
    },
  ];
}