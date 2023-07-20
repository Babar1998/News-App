import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/features/home/screens/news_detail.dart';
import 'package:news_app/utils/utils.dart';

class FirebaseDataScreen extends StatefulWidget {
  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  String defaultImageUrl =
      'https://images.pexels.com/photos/3230010/pexels-photo-3230010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  final fireStoreFetch =
      FirebaseFirestore.instance.collection('saved').snapshots();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double referenceWidth = 393;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.width;
    final double convertedHeight = (screenHeight / referenceWidth);

    final double convertedWidth = (screenWidth / referenceWidth);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: backgroundColor,
          title: Text(
            'Saved News',
            style: newsHeading,
          ),
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: fireStoreFetch,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Some error occurred");
            }

            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (BuildContext context, int index) {
                final article = snapshot.data!.docs[index];

                // Check if the required fields exist in the document
                String author = article['author'] ?? 'Not Mentioned';
                String title = article['title']?.toString() ?? '';
                String imageUrl =
                    article['imageUrl']?.toString() ?? defaultImageUrl;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Newsdetails(
                            category: categories[selectedIndex],
                            title: article['title'],
                            imageUrl: article['imageUrl'],
                            author: article['author'],
                            description: article['description'],
                            content: article['content'],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120,
                          width: convertedWidth * 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              // ignore: unnecessary_null_comparison
                              imageUrl != null
                                  ? imageUrl.toString()
                                  : defaultImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.network(
                                  defaultImageUrl,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: convertedWidth * 220,
                                child: Text(
                                  'Author: $author',
                                  style: GoogleFonts.poppins(
                                    textStyle: categoryText,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              SizedBox(
                                width: convertedWidth * 220,
                                child: Text(
                                  '${title.split(' ').take(8).join(' ')}....',
                                  style: GoogleFonts.poppins(
                                    textStyle: newsHeading,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              // You can add more widgets or data from the Firestore document here
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
