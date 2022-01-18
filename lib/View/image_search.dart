import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/Utils/loader_util.dart';
import 'package:excelledia/Utils/toast_util.dart';
import 'package:excelledia/View/image_maximization.dart';
import 'package:excelledia/ViewModel/images_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class SearchImage extends StatefulWidget {
  const SearchImage({Key key}) : super(key: key);

  @override
  _SearchImageState createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  TextEditingController searchController = TextEditingController();

  ImagesViewModel imagesViewModel;

  int pageCount = 1;
  int pageSize = 10;
  List<Hits> Data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  var checkforSearchName = "images";
  var valueForImageNameCheck = 1;

  @override
  void initState() {
    imagesViewModel = Provider.of<ImagesViewModel>(context, listen: false);
    loader();
    _loadMore();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void loader() async {
    await new Future.delayed(const Duration(microseconds: 0));
    showLoaderDialog(context);
    await imagesViewModel.getDetails(searchController.text, pageCount,
        perPage: pageSize);
    Navigator.pop(context);
  }

  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });
    pageCount += 1;
    //  await new Future.delayed(const Duration(microseconds: 0));
    //  showLoaderDialog(context);
    ImagesModel _imagesModel = await imagesViewModel
        .getDetails(searchController.text, pageCount, perPage: pageSize);
    //  Navigator.pop(context);
    // dummy delay
    // await new Future.delayed(const Duration(seconds: 2));
    for (var i = currentLength;
        i <= _imagesModel.hits.length + increment;
        i++) {
      if (_imagesModel != null &&
          _imagesModel.hits != null &&
          _imagesModel.hits.length > 0) {
        setState(() {
          Data.addAll(_imagesModel.hits);
          Data = Data.toSet().toList();
        });
      } else {
        pageCount -= 1;
      }
    }
    setState(() {
      isLoading = false;
      currentLength = _imagesModel.hits.length;
    });
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
          return Padding(
            padding: EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 8),
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
                        showLoaderDialog(context);
                        pageCount = 1;
                        await imagesViewModel.getDetailsStarter(
                            "${searchController.text.trim()}", pageCount,
                            context: context, perPage: pageSize);
                        pageCount = 0;
                        if (imagesViewModel.listvalueLength != null &&
                            imagesViewModel.listvalueLength != 0) {
                          checkforSearchName = searchController.text;
                          valueForImageNameCheck = 2;
                          Data.clear();
                          await _loadMore();
                        } else {
                          if (valueForImageNameCheck == 1) {
                            checkforSearchName = "";
                          } else {
                            checkforSearchName = checkforSearchName;
                          }

                          await _loadMore();
                        }
                        imagesViewModel.listvalueLength == 0
                            ? getToast(
                                message:
                                    "No results found for ${searchController.text}",
                                color: Color(0xffF40909))
                            : print("");
                        imagesViewModel.listvalueLength == 0
                            ? searchController.text = checkforSearchName
                            : searchController.text = searchController.text;

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
                    maxLines: 1,
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
                          if (searchController.text != null &&
                              searchController.text.length > 1) {
                            if (searchController.text == " ") {
                              searchController.clear();
                              return;
                            }
                            showLoaderDialog(context);
                            pageCount = 1;
                            await imagesViewModel.getDetailsStarter(
                                "${searchController.text}", pageCount,
                                context: context, perPage: pageSize);

                            pageCount = 0;
                            if (imagesViewModel.listvalueLength != null &&
                                imagesViewModel.listvalueLength != 0) {
                              checkforSearchName = searchController.text;
                              valueForImageNameCheck = 2;
                              Data.clear();
                              await _loadMore();
                            } else {
                              if (valueForImageNameCheck == 1) {
                                checkforSearchName = "";
                              } else {
                                checkforSearchName = checkforSearchName;
                              }

                              await _loadMore();
                            }
                            imagesViewModel.listvalueLength == 0
                                ? getToast(
                                    message:
                                        "No results found for ${searchController.text}",
                                    color: Color(0xffF40909))
                                : print("");
                            imagesViewModel.listvalueLength == 0
                                ? searchController.text = checkforSearchName
                                : searchController.text = searchController.text;

                            Navigator.pop(context);
                            //  FocusScope.of(context).requestFocus(FocusNode());
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
                Data != null && Data.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: LazyLoadScrollView(
                          isLoading: isLoading,
                          onEndOfPage: () => _loadMore(),
                          child: CustomScrollView(
                            semanticChildCount: 4,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200.0,
                                  mainAxisSpacing: 5.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 1.0,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Data[index].largeImageURL}",
                                        placeholder: (context, url) => Center(
                                          child: Image.asset(
                                            'assets/images/loader.gif',
                                            fit: BoxFit.fill,
                                            height: 25,
                                            width: 25,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageMazimization(Data[index]
                                                      .largeImageURL)),
                                        );
                                      },
                                    );
                                  },
                                  childCount: Data != null && Data.isNotEmpty
                                      ? Data.length
                                      : 0,
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 18.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/loader.gif',
                                            fit: BoxFit.fitHeight,
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text(
                                            " Loading...",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
        }),
      ),
    );
  }
}
