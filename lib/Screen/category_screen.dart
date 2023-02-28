import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quote_app/utils/color.dart';

import '../utils/quotes_list.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quotes by category",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyColor.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColor.black,
          ),
          splashRadius: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyColor.white,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: MyList.uniqueList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed('detail',arguments: MyList.uniqueList[index]['category']);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.8),
                    child: Text(
                      "${MyList.uniqueList[index]['category'][0]}${MyList.uniqueList[index]['category'][1].toString().toUpperCase()}",
                      style: const TextStyle(fontSize: 18, fontFamily: 'lobster'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text('${MyList.uniqueList[index]['category']}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 2,
            color: MyColor.grey.withOpacity(0.5),
          );
        },
      ),
    );
  }
}
