import 'package:excelledia/Utils/loader_util.dart';
import 'package:excelledia/View/image_maximization.dart';
import 'package:excelledia/ViewModel/images_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';


class SearchImage extends StatefulWidget {
  const SearchImage({Key key}) : super(key: key);

  @override
  _SearchImageState createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  TextEditingController searchController = TextEditingController();
  String imageName;
  bool isSearched = false;
  var searchValue;
  ImagesViewModel imagesViewModel = new ImagesViewModel();
  List<int> data = [];
  int currentLength = 0;

  final int increment = 20;
  var pageCount = 1;
  bool isLoading = false;

  @override
  void initState() {
    imagesViewModel = Provider.of<ImagesViewModel>(context, listen: false);
    super.initState();

    // imagesViewModel.getDetails("Flowers",context: context);
  }

  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });

    await new Future.delayed(const Duration(seconds: 2));
    /*for (var i = currentLength;
        i <= imagesViewModel.imagesModel.hits.length *//*+increment*//*;
        i++) {
      data.add(i);
    }*/data.addAll(
        List.generate(increment, (index) => imagesViewModel.imagesModel.hits.length + index));

    setState(() {
      isLoading = false;
     // currentLength = 10;
    });
  }

  void apiCall(String itemName) async {
    await imagesViewModel.getDetails("$itemName", pageCount, context: context);
    _loadMore();
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
            padding: EdgeInsets.only(top: 12, left: 8, right: 8),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: searchController,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) async {
                      if (searchController.text != imageName) {
                        if (searchController.text.trim().length > 0) {
                          imageName = searchController.text.toLowerCase();
                          setState(() {
                            apiCall(searchController.text);
                            isSearched = true;
                            searchValue = imagesViewModel.searchValue;
                          });
                        }
                      }
                    },
                    validator: (value) {
                      if (value.trim().isEmpty || value.trim().length > 1) {
                        return 'Please enter image name';
                      }
                      return null;
                    },
                    textAlign: TextAlign.left,
                    onChanged: (text) {
                      setState(() {
                        if (text.trim().length <= 0) {
                          searchController.clear();
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Color(0xff808080),
                        fontSize: 14,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: "Enter image name",
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (searchController.text != imageName) {
                            if (searchController.text.trim().length > 0) {
                              showLoaderDialog(context);
                              imageName = searchController.text.toLowerCase();
                              setState(() {
                                apiCall(searchController.text);
                                isSearched = true;
                                searchValue = imagesViewModel.searchValue;
                              });
                              Navigator.pop(context);
                            }
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
                isSearched == true
                    ? /*searchValue!=0?*/ gridView(
                        imagesViewModel != null ? imagesViewModel : Container())
                    : Column(
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/search_icon.svg',
                        color: Color(0xffA9A9A9),
                        height:
                        MediaQuery.of(context).size.height / 3,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Enter image name to load data",
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 16,
                          color: Color(0xff696969),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                /*  :Container()*/
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget gridView(ImagesViewModel model) {
    return LazyLoadScrollView(
      isLoading: isLoading,
      onEndOfPage: () => _loadMore(),
      child: Scrollbar(
        child: GridView.builder(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 2,
            ),
            itemCount: model != null &&
                    model.imagesModel != null &&
                    model.imagesModel.hits != null
                ? data.length
                : 0,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageMazimization(
                            model.imagesModel.hits[index].largeImageURL)),
                  );
                },
                child: FadeInImage(
                  image: NetworkImage(
                      '${model.imagesModel.hits[index].largeImageURL}'),
                  placeholder: AssetImage('assets/images/loader.gif'),
                ),
              );
            }),
      ),
    );
  }
}
