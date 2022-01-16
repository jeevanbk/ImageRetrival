import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/Services/web_services.dart';
import 'package:excelledia/Utils/loader_util.dart';
import 'package:flutter/cupertino.dart';

class ImagesViewModel extends ChangeNotifier {
  ImagesModel imagesModel = new ImagesModel();
  var searchValue=0;
  Future<void> getDetails(imageName, pageCount, {BuildContext  context,var perPage}) async {
   showLoaderDialog(context);
    final response =
    await WebServices().fetchImageDetails(imageName,pageCount, context: context,perPage: perPage);
    Navigator.pop(context);
    this.imagesModel = response;
    this.searchValue=response.hits.length;
    print(response);
   print("your search value $searchValue");
    notifyListeners();
  }

}