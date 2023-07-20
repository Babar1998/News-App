//Color theme
import 'package:flutter/material.dart';

//categories
List<String> categories = [
  'Business',
  'Entertainment',
  'Health',
  'Science',
  'Sports',
  'Technology',
];

//colors
const primaryColor = Color(0xff2C3E50);
const highLightColor = Color(0xff0b85e5);
const textColor = Color(0xffbbbfc4);
final iconBackground = Colors.grey[100];
const iconColor = Color(0xff2e2e2e);
const backgroundColor = Color(0xFFffffff);
const tabColor = Color(0xFFFEF7FF);

//text styles
const headingText = TextStyle(
  color: primaryColor,
  fontSize: 24,
  fontWeight: FontWeight.w700,
);
const newsHeading = TextStyle(
  color: primaryColor,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
const categoryText = TextStyle(
  color: textColor,
  fontSize: 12,
  fontWeight: FontWeight.normal,
);

const subHeadingText = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.w700,
);
const viewAll = TextStyle(
  color: highLightColor,
  fontSize: 16,
  fontWeight: FontWeight.w700,
);
const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
