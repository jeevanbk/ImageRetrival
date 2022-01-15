import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/Utils/loader_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WebServices {
  String basic_url = "https://pixabay.com/api/?key=25243882-a7537b34fda5745101b94e439&q=";

  Future<ImagesModel> fetchImageDetails(String imageName,var pageCount,
      {BuildContext  context}) async {
    String url = basic_url +"$imageName&image_type=photo&page=$pageCount";
    print(url);
    Map<String, String> headers = <String, String>{
      "Content-Type": "application/json",
    };

    showLoaderDialog(context);
    final response = await http.get(url, headers: headers);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.body);
      final json = jsonDecode(response.body);
      final imageDetails = ImagesModel.fromJson(json);
    //  print(response.body);
      return imageDetails;

    } else {
      print('Error fetching Data - ' + response.body);
      throw Exception(
          'Could not fetch Details. HTTP Status Code: ${response.statusCode}.');
    }
  }
}
