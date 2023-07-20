import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:news_app/constants.dart';
import 'package:news_app/features/authentication/screens/login.dart';
import 'package:news_app/features/home/models/news_model.dart';
import 'package:news_app/features/home/screens/news_detail.dart';
import 'package:news_app/features/home/servicees/news_services.dart';
import 'package:news_app/features/home/widgets/time_converter.dart';
import 'package:news_app/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<NewsModel> _newsFuture;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNews(categories[selectedIndex]);
  }

  Future<void> _refreshNews() async {
    setState(() {
      _newsFuture = fetchNews(categories[selectedIndex]);
    });
  }

  String defaultImageUrl =
      'https://images.pexels.com/photos/3230010/pexels-photo-3230010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('saved');

  @override
  Widget build(BuildContext context) {
    final double referenceWidth = 393;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.width;
    final double convertedHeight = (screenHeight / referenceWidth);

    final double convertedWidth = (screenWidth / referenceWidth);
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          leadingWidth: 200,
          // Set the desired height for the AppBar
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 8.0),
            child: Image.asset(
              'assets/images/logo.png', // Replace with your logo asset path
              width: 50, // Set the desired width for the logo
              height: 100,
              fit: BoxFit.fill, // Set the desired height for the logo
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0),
              child: IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 8.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: primaryColor,
                ),
              ),
            ),
          ],

          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshNews,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(convertedWidth * 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: convertedWidth * 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                _newsFuture =
                                    fetchNews(categories[selectedIndex]);
                              });
                            },
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Adjust the value as desired
                              ),
                              label: Text(
                                category,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                              backgroundColor: selectedIndex == index
                                  ? highLightColor
                                  : iconBackground,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder<NewsModel>(
                    future: _newsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('No Internet Connection'),
                              ElevatedButton(
                                onPressed: () {
                                  _refreshNews();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final newsModel = snapshot.data!;
                        final articles = newsModel.articles;

                        if (articles == null || articles.isEmpty) {
                          return const Text('No News available');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (BuildContext context, int index) {
                              final article = articles[index];
                              String timeFinal = convertTimeFormat(
                                article.publishedAt ?? '',
                              );

                              String _imageURL =
                                  'https://images.pexels.com/photos/3230010/pexels-photo-3230010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Newsdetails(
                                              category:
                                                  categories[selectedIndex],
                                              title: article.title ?? '',
                                              imageUrl: _imageURL,
                                              author: article.author ??
                                                  'Not Mentioned',
                                              description:
                                                  article.description ?? '',
                                              content: article.content ?? '')),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 120,
                                        width: convertedWidth * 110,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            article.urlToImage != null
                                                ? article.urlToImage.toString()
                                                : defaultImageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.network(
                                                defaultImageUrl,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: convertedWidth * 220,
                                            child: Text(
                                              'Author: ${article.author ?? 'Not Mentioned'}',
                                              style: GoogleFonts.poppins(
                                                textStyle: categoryText,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            width: convertedWidth * 220,
                                            child: Text(
                                              '${article.title!.split(' ').take(10).join(' ')}....' ??
                                                  '',
                                              style: GoogleFonts.poppins(
                                                textStyle: newsHeading,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                timeFinal,
                                                style: GoogleFonts.poppins(
                                                  textStyle: categoryText,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  setState(() {});
                                                  String id = DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString();

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  fireStore.doc(id).set({
                                                    'category': categories[
                                                        selectedIndex],
                                                    'author': article.author,
                                                    'title':
                                                        article.title ?? '',
                                                    'imageUrl': _imageURL,
                                                    'description':
                                                        article.description ??
                                                            '',
                                                    'id': id,
                                                    'content': article.content,
                                                  }).then((value) {
                                                    Utils().toastMessage(
                                                        'News saved');
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    Utils().toastMessage(
                                                        error.toString());
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.bookmark,
                                                  color: highLightColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
