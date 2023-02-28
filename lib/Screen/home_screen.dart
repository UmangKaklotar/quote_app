import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_app/utils/color.dart';
import 'package:quote_app/utils/quotes_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Set<String> categories = Set<String>.from(MyList.quotesList.map((item) => item['category']));
    MyList.uniqueList = categories.map((category) => {'category': category}).toList();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.3),
              ),
              child: const Text("\nLife quotes and sayings",
                  style: TextStyle(fontSize: 30)),
            ),
            ListTile(
              leading: Icon(
                Icons.topic_rounded,
                color: MyColor.yellow,
              ),
              title: const Text('By Topic'),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.person_crop_circle,
                color: MyColor.blue,
              ),
              title: const Text('By Author'),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.star_fill,
                color: MyColor.yellow,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "detail", arguments: "Favourite");
              },
              title: const Text('Favourites'),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.lightbulb_fill,
                color: MyColor.deepOrange,
              ),
              title: const Text('Quote of the day'),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.play_rectangle_fill,
                color: MyColor.red,
              ),
              title: const Text('Videos'),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text("Communicate",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: MyColor.grey,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.share_up),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.play_arrow_solid),
              title: const Text('Rate'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.mail_solid),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            splashRadius: 25,
            icon: Icon(
              Icons.menu_rounded,
              color: MyColor.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Life Quotes And Sayings",
          style: TextStyle(
            color: MyColor.black,
            fontSize: 20,
          ),
        ),
        actions: [
          Icon(
            Icons.notifications_active_rounded,
            color: MyColor.yellow,
          ),
          IconButton(
            icon: Icon(CupertinoIcons.heart_fill,
              color: MyColor.red,),
            splashRadius: 25,
            onPressed: () => Navigator.pushNamed(context, 'detail', arguments: "Favourite"),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          CarouselSlider(
            items: MyList.quotesList.map((e) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detail', arguments: e['author']),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage("${e['bgImg']}"),
                          fit: BoxFit.cover,
                          opacity: 0.8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${e['quote']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: MyColor.black),
                    ),
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              initialPage: 0,
              enableInfiniteScroll: true,
              aspectRatio: 18 / 9,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1200),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MyList.category
                .map(
                  (e) => Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(e['route'], arguments: e['catName']);
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                            height: 60,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: e['color'],
                            ),
                            child: Center(
                              child: Icon(
                                e['icon'],
                                size: 30,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          e['catName'],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: MyColor.black),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Quotes by category",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MyColor.black,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 20,
              physics: const NeverScrollableScrollPhysics(),
              children: MyList.uniqueList
                  .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('detail',
                        arguments: e['category']);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(MyList.quotesList[Random().nextInt(MyList.quotesList.length)]['bgImg']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      (e['category']),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Quotes by author",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColor.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 1000,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              physics: const NeverScrollableScrollPhysics(),
              children: MyList.quotesList
                  .map((e) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('detail',
                      arguments: e['author']);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(e['bgImg']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(e['author'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
