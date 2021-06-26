import 'dart:async';
import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constantTheme.dart';
import '../providers/networking.dart';
import '../services/admob_services.dart';
import '../widget/FilterCard.dart';
import '../size.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  String nameOfField;
  SearchScreen(this.nameOfField);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController scrollController = ScrollController();
  List<dynamic> searchResult = new List();
  Timer timer;
  int count =0;
  int countLoading = 0;
  int pageCount = 1;
 var searchString='جاري البحث';
  final _form = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  double dataCount=0;
  final ams = AdMobService();
  bool _bottomLoading=false;

  @override
  void initState() {
    super.initState();
    controller.text = widget.nameOfField;
    timer =
        Timer.periodic(Duration(seconds: 2), (Timer t) {countLoading++; return checkDataNotExist();});
    getSearch();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _bottomLoading=true;
        });
        getSearch();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  bool checkDataNotExist() {
    bool check;
    setState(() {
      check = searchResult.isEmpty ? true : false;
    });
    return check;
  }

  // Future getData() async {
  //   NetWorkHelper networkHelper = NetWorkHelper();
  //   searchResult = await networkHelper.getSearch(widget.nameOfField);
  // }

  void submitForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    count = 0;
    countLoading = 0;
    searchResult.clear();
    getSearch();
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);

    return Scaffold(
      // drawer: _buildSideDrawer(
      //     context,
      //     allData.isNotEmpty ? null : null,
      //     '01022144280'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KMainColor,
      ),
      body: checkDataNotExist() && dataCount > 0 ?
      Center(
        child: CircularProgressIndicator(),)
          : Container(
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              //AdMob here
              // AdmobBanner(
              //   adUnitId: ams.getBannarAdId(),
              //   adSize: AdmobBannerSize.FULL_BANNER,
              // ),

                AdmobBanner(
                  adUnitId: ams.getSearch1(),
                  adSize: AdmobBannerSize.LARGE_BANNER,
                ),

              Container(
                decoration: BoxDecoration(),
                height: _deviceHeight * .15,
                padding: EdgeInsets.only(
                    left: _deviceWidth * .045,
                    right: _deviceWidth * .045,
                    top: _deviceHeight * .06,
                    bottom: _deviceHeight * .03),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:Colors.black12,

                    ),
                    child: TextFormField(

                      controller: controller,
                      textAlign: TextAlign.right,

                      textAlignVertical: TextAlignVertical.bottom,
                      textDirection: TextDirection.rtl,
                      onSaved: (value) {
                        setState(() {
                          widget.nameOfField = value;

                        });

                      },
                      // ignore: missing_return


                      onEditingComplete: (){

                        submitForm();
                        setState(() {
                          count=0;
                          pageCount=0;
                          searchString='جاري البحث';
                        });

                      },
                      decoration: InputDecoration(
                        //prefixIcon:Icon(Icons.search,) ,
                        hintText: 'ابحث عن اسم الحرفة او مكان البحث',

                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),

                          onPressed: () {
                            submitForm();
                            setState(() {
                              count=0;
                              pageCount=0;
                              searchString='جاري البحث';
                            });


                          },

                        ),
                       // helperMaxLines: 2,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10),
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    )),
              ),

              Align(
                //alignment: Alignment(-.9, 1),
                child: Text(
                  'نتائج البحث',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),

              SizedBox(height: 5.0),

              searchResult.isNotEmpty ?
              Container(
                height: _deviceHeight * .4,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                      FilterCard(index, 'الكل', searchResult),
                  itemCount: searchResult.length,
                  shrinkWrap: true,
                ),
              ) : Container(child: Center(child: Text(searchString)),),
              SizedBox(height: _deviceHeight*.05),
              _bottomLoading?
              Center(child: CircularProgressIndicator(),):SizedBox(width: 0,height: 0,),

              Container(

                child:
                AdmobBanner(
                  adUnitId: ams.getSearch2(),
                  adSize: AdmobBannerSize.BANNER,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   getSearch() async {
     NetWorkHelper netWorkHelper = NetWorkHelper();
     var url = await netWorkHelper.getUrlAddress();
     if (widget.nameOfField=='الاسماعيليه')widget.nameOfField="الإسماعيلية";
     if (count <= pageCount) {
       if(widget.nameOfField.trim().length==0)
       {
         widget.nameOfField=null;
       }
       count++;

    var response = await http.get(
        "${url}general/search?search=${widget.nameOfField}&page=$count");

    if (response.statusCode == 200) {
      searchResult.addAll(await jsonDecode(response.body)['searchResult']);
      int lengthOfAllUser = jsonDecode(response.body)['totalItems'];
      if(lengthOfAllUser==0){

setState(() {
  searchString='لا توجد نتائج';
});
      }
  else {   setState(() {
        searchString='';
      });}
      pageCount = ((lengthOfAllUser / 10).floorToDouble()).toInt();
    } else {
      print(response.statusCode);
    }
  }
     setState(() {
       _bottomLoading=false;
     });
  }
}
