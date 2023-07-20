import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/features/home/widgets/custom_tagline.dart';
import 'package:news_app/features/home/widgets/image_container.dart';

class Newsdetails extends StatefulWidget {
  const Newsdetails({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.description,
    required this.content,
  });
  final String category;
  final String title;
  final String imageUrl;
  final String author;
  final String description;
  final String content;

  @override
  State<Newsdetails> createState() => _NewsdetailsState();
}

class _NewsdetailsState extends State<Newsdetails> {
  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      width: double.infinity,
      imageUrl: widget.imageUrl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  CustomTag(
                    backgroundColor: highLightColor,
                    children: [
                      Text(
                        widget.category,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.25,
                        ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // _NewsBody(article: article)
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomTag(
                              backgroundColor: highLightColor,
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundImage: NetworkImage(
                                    widget.imageUrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.author,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 500,
                          child: Text(
                            widget.description,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
