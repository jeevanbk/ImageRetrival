import 'dart:developer';
import 'package:excelledia/Utils/loader_util.dart';
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
  String imageName;
  bool isSearched = false;
  var searchValue;
  ImagesViewModel imagesViewModel;
  List data=[];
  int currentLength = 0;
  final int increment = 10;
  var pageCount = 1;
  List dummyList;
  ScrollController scrollController=ScrollController();
  int currentMax=10;

  @override
  void initState() {
    apiCall("Images");
    super.initState();

  }
  getMoreData(){
    print("GET MORE");
    log("GET MORE");
    if(imagesViewModel.searchValue~/20==1){
      pageCount=pageCount+1;

    }
    for(int i=currentMax;i<imagesViewModel.imagesModel.hits.length;i++){
      dummyList.add("${imagesViewModel.imagesModel.hits[i].largeImageURL}");
    }currentMax=currentMax+10;

    setState(() { });
  }
  void apiCall(String itemName, {var perpage}) async {
    log("abc");

    imagesViewModel =await Provider.of<ImagesViewModel>(context, listen: false);
    await imagesViewModel.getDetails("$itemName", pageCount ,context: context);

    log("abc");
    dummyList=List.generate(currentMax, (index) => "${imagesViewModel.imagesModel.hits[index].largeImageURL}");
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        getMoreData();
      }
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
                padding: EdgeInsets.only(top: 12, left: 8, right: 8,bottom: 8),
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
                    SizedBox(
                      height: 10,
                    ),
                    imagesViewModel.searchValue!= null &&  imagesViewModel.searchValue!=0?Container(
                        height: MediaQuery.of(context).size.height*0.8,
                        child: GridView.builder(
                            controller: scrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              crossAxisCount: 2,
                            ),
                            itemCount: imagesViewModel != null &&
                                imagesViewModel.imagesModel != null &&
                                imagesViewModel.imagesModel.hits != null
                                ? dummyList.length:0,
                            itemBuilder: (BuildContext context, int index) {
                              if(dummyList.length==index){
                                apiCall(searchController.text,perpage: 20);
                              }
                              return /*ListTile(title: Text(dummyList[index]),)*/ GestureDetector(
                                child: FadeInImage(
                                  image: NetworkImage(
                                      '${dummyList[index]}'),
                                  placeholder: AssetImage('assets/images/loader.gif'),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageMazimization(
                                            imagesViewModel.imagesModel.hits[index].largeImageURL)),
                                  );
                                },
                              );
                            }),
                      ):Container(color: Colors.red,
                  height: 100,),

                    /*  :Container()*/
                  ],
                ),
              );
            }),
      ),
    );
  }
}