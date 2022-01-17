import 'dart:developer';
import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/Utils/loader_util.dart';
import 'package:excelledia/Utils/toast_util.dart';
import 'package:excelledia/View/image_maximization.dart';
import 'package:excelledia/ViewModel/images_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchImage extends StatefulWidget {
  const SearchImage({Key key}) : super(key: key);

  @override
  _SearchImageState createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  TextEditingController searchController = TextEditingController();

  ImagesViewModel imagesViewModel;
  List<Hits> data;
  ScrollController scrollController = ScrollController();
  int pageCount = 1;
  int tempCount = 1;
  int pageSize = 10;

  @override
  void initState() {
    imagesViewModel = Provider.of<ImagesViewModel>(context, listen: false);
    imagesViewModel.getDetailsStarter("${searchController.text}", pageCount,
        context: context);
    paging();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void paging() {
    scrollController.addListener(() async {
      if (pageCount - tempCount == 0) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          showLoaderDialog(context);
          FocusScope.of(context).requestFocus(FocusNode());
          await _loadMorePhotos(searchText: searchController.text);
          Navigator.pop(context);
        }
      }
    });
  }

  Future _loadMorePhotos({String searchText}) async {
    pageCount += 1;
    ImagesModel _imagesModel = await imagesViewModel
        .getDetails(searchController.text, pageCount, perPage: pageSize);

    if (_imagesModel != null &&
        _imagesModel.hits != null &&
        _imagesModel.hits.length > 0) {
      setState(() {
        data.addAll(_imagesModel.hits);
      });
      tempCount = pageCount;
    } else {
      pageCount -= 1;
      //CustomWidgets.getToast(message: 'No More Orders Found', color: AppResources.errorColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: SingleChildScrollView(
        child: Consumer<ImagesViewModel>(
            builder: (context, imagesViewModel, child) {
          if (pageCount == 1) {
            if (imagesViewModel.imagesModel != null &&
                imagesViewModel.imagesModel.hits != null &&
                imagesViewModel.imagesModel.hits.length > 0) {
              /// 1st tym ,we ll take values from consumer then from next onwards we ll directly add values
              ///we are copying values of the list this way[... ] .This is Called Spread Operator
              /// .If we use = assign operator then refrence or same memory address will be given for both list so if we change one list then another
              /// list will also be changed
              data = [...imagesViewModel.imagesModel.hits];
            }
          }
          return Padding(
            padding: EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: searchController,
                    validator: (value) {
                      if (value.isEmpty || value.trim().length > 1) {
                        return 'Please enter image name';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) async {
                      if (searchController.text != null &&
                          searchController.text.length > 1) {
                        if (searchController.text == " ") {
                          searchController.clear();
                          return;
                        }
                        pageCount = 1;
                        tempCount = 1;
                        showLoaderDialog(context);
                        await imagesViewModel.getDetailsStarter(
                            searchController.text, pageCount,
                            perPage: pageSize);
                        imagesViewModel.listLength == 0
                            ? getToast(
                                message:
                                    "No results found for ${searchController.text}",
                                color: Color(0xffF40909))
                            : print("");
                        Navigator.pop(context);
                        //  FocusScope.of(context).requestFocus(FocusNode());
                      } else {
                        getToast(
                            message:
                                "Image name should be more than a character",
                            color: Color(0xffF40909));
                      }
                    },
                    textAlign: TextAlign.left,
                    onChanged: (text) async {},
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Color(0xff808080),
                        fontSize: 14,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: "Search for image name",
                      suffixIcon: IconButton(
                        onPressed: () async {
                          //  searchController.clear();
                          if (searchController.text != null &&
                              searchController.text.length > 1) {
                            if (searchController.text == " ") {
                              searchController.clear();
                              return;
                            }
                            pageCount = 1;
                            tempCount = 1;
                            showLoaderDialog(context);
                            await imagesViewModel.getDetailsStarter(
                                searchController.text, pageCount,
                                perPage: pageSize);
                            imagesViewModel.listLength == 0
                                ? getToast(
                                    message:
                                        "No results found for ${searchController.text}",
                                    color: Color(0xffF40909))
                                : print("");
                            Navigator.pop(context);
                            FocusScope.of(context).requestFocus(FocusNode());
                          } else {
                            getToast(
                                message:
                                    "Image name should be more than a character",
                                color: Color(0xffF40909));
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: Color(818086),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                data != null && data.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: GridView.builder(
                            controller: scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              crossAxisCount: 2,
                            ),
                            itemCount: data != null && data.isNotEmpty
                                ? data.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return /*ListTile(title: Text(dummyList[index]),)*/ GestureDetector(
                                child: FadeInImage(
                                  image: NetworkImage(
                                      '${data[index].largeImageURL}'),
                                  placeholder:
                                      AssetImage('assets/images/loader.gif'),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageMazimization(
                                            data[index].largeImageURL)),
                                  );
                                },
                              );
                            }),
                      )
                    : Container()

                /*  :Container()*/
              ],
            ),
          );
        }),
      ),
    );
  }
}
