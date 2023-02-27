import 'package:flutter/foundation.dart';

class Quotes {
  String? category;
  String? quote;
  Uint8List? image;

  Quotes(
    {
      required this.category,
      required this.quote,
      required this.image
    }
  );

  Quotes.fromMap(Map map) {
    category = map[category];
    quote = map[quote];
    image = map[image];
  }

  Map<String, dynamic> toMap() => {
    'category': category,
    'quote': quote,
    'image': image,
  };

}