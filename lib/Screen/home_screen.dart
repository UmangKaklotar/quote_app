import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quote_app/Helper/database_helper.dart';
import 'package:quote_app/model/quotes_model.dart';
import 'package:quote_app/utils/color.dart';

import '../utils/quote_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: MyColor.red,
                alignment: Alignment.center,
                child: Text("Life Quotes And Sayings",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'lobster'

                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            splashRadius: 25,
            icon: Icon(Icons.menu_rounded, color: MyColor.black,),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Life Quotes And Sayings",
          style: TextStyle(
            color: MyColor.black,
            fontFamily: 'lobster'
          ),
        ),
        actions: [
          Icon(Icons.notifications_active_rounded, color: MyColor.yellow,),
          const SizedBox(width: 10
          ),
          Icon(CupertinoIcons.heart_fill, color: MyColor.red,),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
