import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/Services/web_services.dart';
import 'package:excelledia/Utils/loader_util.dart';
import 'package:flutter/cupertino.dart';

class ImagesViewModel extends ChangeNotifier {
  ImagesModel imagesModel;
  var listvalueLength;

  /// we ll call this after 1st time to append data in the existing list
  Future<ImagesModel> getDetails(imageName, pageCount,
      {BuildContext context, var perPage}) async {
    final response = await WebServices().fetchImageDetails(imageName, pageCount,
        context: context, perPage: perPage);
    return response;
  }

  /// we ll call this in initMethod to getData for 1st time through consumer thats y notify listeners
  Future<void> getDetailsStarter(imageName, pageCount,
      {BuildContext context, var perPage}) async {
    final response = await WebServices().fetchImageDetails(imageName, pageCount,
        context: context, perPage: perPage);
    print("response$response");
    if (response != null) {
      this.imagesModel = response;
      this.listvalueLength = response.hits.length;
    }

    notifyListeners();
  }
}
