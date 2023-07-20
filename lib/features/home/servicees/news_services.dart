import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/bottom_navigation_bar.dart';
import 'package:news_app/features/home/models/news_model.dart';
import 'package:news_app/features/home/servicees/api_keys.dart';

Future<NewsModel> fetchNews(String category) async {
  final apiKey = apiKeys.first; // Get the first available API key

  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=$apiKey'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final NewsModel newsModel = NewsModel.fromJson(jsonData);
    return newsModel;
  } else if (apiKeys.length > 1) {
    // If the request fails and there are more API keys available, try the next one
    apiKeys.removeAt(0); // Remove the first API key from the list
    return fetchNews(category); // Retry the request with the next key
  } else {
    throw Exception('Failed to load news');
  }
}




// Future<NewsModel> newsFuture = fetchNews('business', apiKeys);


// https://newsapi.org/v2/top-headlines?country=in&apiKey=41b8202e3bcb48b6960b2ef98edae347

//https://newsapi.org/v2/top-headlines?country=de&category=business&apiKey=41b8202e3bcb48b6960b2ef98edae347