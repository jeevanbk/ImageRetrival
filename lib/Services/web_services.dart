import 'dart:developer';
import 'dart:io';

import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/Utils/loader_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WebServices {
  String basic_url =
      "https://pixabay.com/api/?key=25243882-a7537b34fda5745101b94e439&q=";

  Future<ImagesModel> fetchImageDetails(String imageName, var pageCount,
      {BuildContext context, var perPage}) async {
    String url = basic_url +
        "$imageName&image_type=photo&page=$pageCount&per_page=$perPage";
   // print(url);

    Map<String, String> headers = <String, String>{
      "Content-Type": "application/json",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final json = jsonDecode(response.body);
        return ImagesModel.fromJson(json);
      }
    } on SocketException {
      log('Socket Exception ');
    } catch (e) {
      log('Error :: ${e.toString()}');
    }
    return null;
  }
}
