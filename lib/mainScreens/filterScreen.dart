import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/networking.dart';
import '../services/admob_services.dart';
import '../widget/FilterCard.dart';
import 'dart:async';
import '../constantTheme.dart';
import '../size.dart';

// ignore: must_be_immutable
class FilterScreen extends StatefulWidget {
  String nameOfCountry,nameOfSan3a,nameOfCity;
  FilterScreen({@required this.nameOfCountry,@required this.nameOfCity,@required this.nameOfSan3a});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  ScrollController scrollController = ScrollController();
  List<dynamic> filterResult = new List();
  Timer timer;
  int pageCount = 1;
  var searchString='جاري البحث';
  double dataCount=0;
  int count = 0;
  int countLoading = 0;
  bool _bottomLoading=false;
  final ams = AdMobService();

  final _form = GlobalKey<FormState>();


  @override
  void initState() {
    getFilterData();
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 2), (Timer t) {countLoading++;return checkDataNotExist(); });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _bottomLoading=true;
        });
        getFilterData();
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
      check = filterResult.isEmpty ? true : false;
    });
    return check;
  }

  @override
  Widget build(BuildContext context) {
    // final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);


    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KMainColor,
      ),
      body: checkDataNotExist() && countLoading <= 3
          ? Center(
        child: CircularProgressIndicator(),)
          : Container(
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[


               AdmobBanner(
                  adUnitId: ams.getFilter1(),
                  adSize: AdmobBannerSize.BANNER,
                ),



              Align(
                //alignment: Alignment(-.9, 1),
                child: Text(
                  'نتائج الفلتر',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),

              SizedBox(height: 5.0),

              filterResult.isNotEmpty ? Container(
                height: _deviceHeight * .5,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                      FilterCard(index, 'الكل', filterResult),
                  itemCount: filterResult.length,
                  shrinkWrap: true,
                ),
              ) : Container(child: Center(child: Text(searchString)),),
              _bottomLoading?
              Center(child: CircularProgressIndicator(),):SizedBox(width: 0,height: 0,),
              SizedBox(height: _deviceHeight*.08),
              Container(
                child: AdmobBanner(
                  adUnitId: ams.getFilter2(),
                  adSize: AdmobBannerSize.BANNER,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // get fillter data
  getFilterData() async {
    if(widget.nameOfSan3a==null||widget.nameOfSan3a=='الكل')widget.nameOfSan3a='';

    if(widget.nameOfCountry==null||widget.nameOfCountry=='أختر الدولة')widget.nameOfCountry='';

    if(widget.nameOfCity==null||widget.nameOfCity=='أختر محافظة')widget.nameOfCity='';
    NetWorkHelper netWorkHelper = NetWorkHelper();
    var url = await netWorkHelper.getUrlAddress();

    if (count <= pageCount) {
      count++;
      var response = await http.get(
          "${url}general/getfilter?country=${widget.nameOfCountry}&city=${widget
              .nameOfCity  }&field=${widget
              .nameOfSan3a }&page=$count");
      int lengthOfAllUser = jsonDecode(response.body)['TotaNum'];
      if(lengthOfAllUser==0){

        setState(() {
          searchString='لا توجد نتائج';
        });
      }
      else {   setState(() {
        searchString='';
      });}
      pageCount = ((lengthOfAllUser / 10).floor()).toInt();
      if (response.statusCode == 200) {
        filterResult.addAll(await jsonDecode(response.body)['Data']);
      } else {
        filterResult.clear();
      }
    }
    setState(() {
      _bottomLoading=false;
    });
  }
}
