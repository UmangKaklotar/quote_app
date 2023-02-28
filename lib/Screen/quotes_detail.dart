import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_app/utils/quotes_list.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/color.dart';

class QuoteDetail extends StatefulWidget {
  const QuoteDetail({Key? key}) : super(key: key);

  @override
  State<QuoteDetail> createState() => _QuoteDetailState();
}

class _QuoteDetailState extends State<QuoteDetail> {
  Future saveImage(Uint8List bytes) async {
    await ImageGallerySaver.saveImage(bytes, name: "data", quality: 100);
  }
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          splashRadius: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            color: MyColor.black,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ...MyList.quotesList.map((e) {
            if(title == e['category']){
              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(MyList.quotesList[Random().nextInt(MyList.quotesList.length)]['bgImg']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(e['quote'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(CupertinoIcons.square_stack_fill, color: MyColor.red,),
                                onPressed: (){
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.copy_rounded, color: MyColor.blue,),
                                onPressed: () {
                                  FlutterClipboard.copy(
                                    e['quote'].toString(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Copied..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.share_solid, color: MyColor.red,),
                                onPressed: () async {
                                  final byte = await screenshotController.captureFromWidget(Material(
                                    child: Stack(alignment: Alignment.center, children: [
                                      Container(
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['image']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            style: const TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ));
                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/image.jpg';
                                  File(path).writeAsBytesSync(byte);
                                  await Share.share(path);
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.arrow_down_to_line, color: MyColor.green,),
                                onPressed: () async {
                                  Uint8List? imageBytes = await screenshotController.captureFromWidget(
                                    Stack(alignment: Alignment.center, children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 350,
                                        width: 400,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['bgImg']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'lobster'),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                  saveImage(imageBytes);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Downloaded..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));


                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.star_fill, color: MyColor.blue,),
                                onPressed: (){
                                  MyList.favourite.add(e);
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Add to Favourite..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }).toList(),

          ...MyList.quotesList.map((e) {
            if(title == "Latest Quotes" || title == "Pic Quotes"){
              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(MyList.quotesList[Random().nextInt(MyList.quotesList.length)]['bgImg']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(e['quote'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(CupertinoIcons.square_stack_fill, color: MyColor.red,),
                                onPressed: (){
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.copy_rounded, color: MyColor.blue,),
                                onPressed: () {
                                  FlutterClipboard.copy(
                                    e['quote'].toString(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Copied..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.share_solid, color: MyColor.red,),
                                onPressed: () async {
                                  final byte = await screenshotController.captureFromWidget(Material(
                                    child: Stack(alignment: Alignment.center, children: [
                                      Container(
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['image']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            style: const TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ));
                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/image.jpg';
                                  File(path).writeAsBytesSync(byte);
                                  await Share.share(path);
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.arrow_down_to_line, color: MyColor.green,),
                                onPressed: () async {
                                  Uint8List? imageBytes = await screenshotController.captureFromWidget(
                                    Stack(alignment: Alignment.center, children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 350,
                                        width: 400,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['bgImg']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'lobster'),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                  saveImage(imageBytes);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Downloaded..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));


                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.star_fill, color: MyColor.blue,),
                                onPressed: (){
                                  MyList.favourite.add(e);
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Add to Favourite..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }).toList(),

          ...MyList.quotesList.map((e) {
            if(title == e['author']){
              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(MyList.quotesList[Random().nextInt(MyList.quotesList.length)]['bgImg']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(e['quote'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(CupertinoIcons.square_stack_fill, color: MyColor.red,),
                                onPressed: (){
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.copy_rounded, color: MyColor.blue,),
                                onPressed: () {
                                  FlutterClipboard.copy(
                                    e['quote'].toString(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Copied..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.share_solid, color: MyColor.red,),
                                onPressed: () async {
                                  final byte = await screenshotController.captureFromWidget(Material(
                                    child: Stack(alignment: Alignment.center, children: [
                                      Container(
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['image']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            style: const TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ));
                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/image.jpg';
                                  File(path).writeAsBytesSync(byte);
                                  await Share.share(path);
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.arrow_down_to_line, color: MyColor.green,),
                                onPressed: () async {
                                  Uint8List? imageBytes = await screenshotController.captureFromWidget(
                                    Stack(alignment: Alignment.center, children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 350,
                                        width: 400,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['bgImg']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'lobster'),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                  saveImage(imageBytes);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Downloaded..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));


                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.star_fill, color: MyColor.blue,),
                                onPressed: (){
                                  MyList.favourite.add(e);
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Add to Favourite..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }).toList(),

          ...MyList.quotesList.map((e) {
            if(title == "Articles"){
              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(MyList.quotesList[Random().nextInt(MyList.quotesList.length)]['bgImg']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(e['quote'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }).toList(),

          ...MyList.favourite.map((e) {
            if(title == "Favourite"){
              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(MyList.quotesList[Random().nextInt(MyList.quotesList.length)]['bgImg']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(e['quote'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColor.white,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(CupertinoIcons.square_stack_fill, color: MyColor.red,),
                                onPressed: (){
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.copy_rounded, color: MyColor.blue,),
                                onPressed: () {
                                  FlutterClipboard.copy(
                                    e['quote'].toString(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Copied..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.share_solid, color: MyColor.red,),
                                onPressed: () async {
                                  final byte = await screenshotController.captureFromWidget(Material(
                                    child: Stack(alignment: Alignment.center, children: [
                                      Container(
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['image']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            style: const TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ));
                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/image.jpg';
                                  File(path).writeAsBytesSync(byte);
                                  await Share.share(path);
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.arrow_down_to_line, color: MyColor.green,),
                                onPressed: () async {
                                  Uint8List? imageBytes = await screenshotController.captureFromWidget(
                                    Stack(alignment: Alignment.center, children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 350,
                                        width: 400,
                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${e['bgImg']}"), fit: BoxFit.cover)),
                                        child: Center(
                                          child: Text(
                                            "${e['quote']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'lobster'),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                  saveImage(imageBytes);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Downloaded..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));


                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.star_fill, color: MyColor.blue,),
                                onPressed: (){
                                  MyList.favourite.add(e);
                                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                    content: const Text("Add to Favourite..."),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }).toList(),
        ],
      ),
    );
  }
}
