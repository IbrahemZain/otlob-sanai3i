import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import '../widget/constData.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import '../providers/authProvider.dart';
import '../signUpPages/loginScreen.dart';
import '../widget/downCards.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constantTheme.dart';
import '../providers/networking.dart';
import '../services/admob_services.dart';
import '../mainScreens/profilePage.dart';
import '../size.dart';
import '../widget/upperCard.dart';
import 'filterScreen.dart';
import 'searchScreen.dart';

class HomePage extends StatefulWidget {
  final bool isUser;

  HomePage({@required this.isUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> allUserData = new List();
  List<dynamic> mostViewUserData = [];

  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();
  TextEditingController searchHolder = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _form1 = GlobalKey<FormState>();
  var flag = 0;
  List<dynamic> job = [];
  List<dynamic> country = [];
  List<dynamic> city = [];
  String selectedSan3a, selectedCity, selectedCountry, searchValue;
  UserAuth _userAuth = UserAuth();
  int count = 0;
  int pageCount = 1;
  final ams = AdMobService();
  FocusNode myFocusNode;
  Timer timer;
  var _userSharedImage, _promo;
  bool _bottomLoading = false;
  var facebookUrl;

  @override
  void initState() {
    // Firebase.initializeApp();

    super.initState();
    getImage();
    getMostViewUsers();
    getAllUsers();
    // getPageCommunicationData();
    getAllCountries();
    getAlljobs();

    timer =
        Timer.periodic(Duration(seconds: 0), (Timer t) => checkDataNotExist());

    Admob.initialize(testDeviceIds: [ams.getAdMobAppId()]);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _bottomLoading = true;
        });
        getAllUsers();
      }
    });
    myFocusNode = FocusNode();
  }

  getAllCountries() async{
    try{
      country = await getAllCountry();
    }catch(e){print(e);}
  }
  getAlljobs() async{
    try{
      job = await getAllJob();
    }catch(e){print(e);}
  }
  getCityOfCountry()async{
    try{
      switch (selectedCountry) {
        case 'مصر':
          city = await getAllCity(nameOfCountry: 'city of egypt');
          break;
        case 'السعودية':
          city = await getAllCity(nameOfCountry: 'city of saudia');
          break;
        case 'الكويت':
          city = await getAllCity(nameOfCountry: 'city of elkwet');
          break;
        case 'اليمن':
          city = await getAllCity(nameOfCountry: 'city of elyaman');
          break;
        case 'الإمارات':
          city = await getAllCity(nameOfCountry: 'city of emarat');
          break;
        case 'قطر':
          city = await getAllCity(nameOfCountry: 'city of qatar');
          break;
        case 'عمان':
          city = await getAllCity(nameOfCountry: 'city of oman');
          break;
        case 'البحرين':
          city = await getAllCity(nameOfCountry: 'city of the sea');
          break;
        case 'سوريا':
          city = await getAllCity(nameOfCountry: 'city of sorya');
          break;
        case 'العراق':
          city = await getAllCity(nameOfCountry: 'city of iraq');
          break;
        case 'فلسطين':
          city = await getAllCity(nameOfCountry: 'city of palastin');
          break;
        case 'لبنان':
          city = await getAllCity(nameOfCountry: 'city of lbnan');
          break;
        case 'الاردن':
          city = await getAllCity(nameOfCountry: 'city of elordon');
          break;
        case 'تونس':
          city = await getAllCity(nameOfCountry: 'city of twones');
          break;
        case 'الجزائر':
          city = await getAllCity(nameOfCountry: 'city of elgza2er');
          break;
        case 'ليبيا':
          city = await getAllCity(nameOfCountry: 'city of lebya');
          break;
        case 'السودان':
          city = await getAllCity(nameOfCountry: 'city of sodan');
          break;
        case 'موريتانيا':
          city = await getAllCity(nameOfCountry: 'city of moretanya');
          break;
        case 'الصومال':
          city = await getAllCity(nameOfCountry: 'city of somal');
          break;
        case 'جيبوتي':
          city = await getAllCity(nameOfCountry: 'city of geboty');
          break;
        case 'جرز القمر':
          city = await getAllCity(nameOfCountry: 'city of elkamer');
          break;
        default:
          break;
      }

    }catch(e){
      print(e);
    }
  }
  @override
  void dispose() {
    myFocusNode.dispose();
    scrollController.dispose();
    scrollController1.dispose();
    timer?.cancel();
    super.dispose();
  }
  Future _getAllDataRefresh() async {
    await getAllUsers();

    await getMostViewUsers();
  }
  void submitDrawer() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => FilterScreen(
                nameOfCountry: selectedCountry, nameOfCity: selectedCity, nameOfSan3a: selectedSan3a))));
  }

  // the submit for using search
  void submitForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    if (searchValue == 'الاسماعيليه') searchValue = "الإسماعيلية";
    _form.currentState.save();
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => SearchScreen(searchValue))));
    searchHolder.clear();
  }

  bool checkDataNotExist() {
    bool check;
    setState(() {
      check = flag == 0 ? true : false;
    });
    return check;
  }

  Widget homeBanner() {
    return AdmobBanner(
      adUnitId: ams.getHome1(),
      adSize: AdmobBannerSize.BANNER,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Align(
              alignment: Alignment(.8, 1),
              child: widget.isUser ? Text('') : Text('أطلب صنايعي')),
          elevation: 0.0,
          backgroundColor: KMainColor,
          actions: widget.isUser ? [
                  Center(
                    child: FlatButton(
                      child: Text('الصفحه الشخصية', style: TextStyle(fontSize: 18,color: Colors.white),),
                      onPressed:(){
                        Navigator.push(context,MaterialPageRoute(
                            builder: ((context) => ProfilePage(
                              isUser: true,
                              index: null,
                              mvUsers: null,
                            ))));
                      },
                    ),
                  ),
                  FlatButton(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(_userSharedImage),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ProfilePage(
                                      isUser: true,
                                      index: null,
                                      mvUsers: null,
                                    ))));
                      })
                ]
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: _getAllDataRefresh,
          displacement: 5,
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                homeBanner(),
                Container(
                  decoration: BoxDecoration(),
                  height: _deviceHeight * .15,
                  padding: EdgeInsets.only(
                      left: _deviceWidth * .045,
                      right: _deviceWidth * .045,
                      top: _deviceHeight * .06,
                      bottom: _deviceHeight * .03),
                  child: Form(
                    key: _form,
                    child: Container(
                        //margin: EdgeInsets.symmetric(horizontal: _deviceWidth*.02,vertical: _deviceHeight*.09),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black12,
                        ),

                        // widget of search

                        child: TextFormField(
                          controller: searchHolder,
                          textAlign: TextAlign.right,
                          textAlignVertical: TextAlignVertical.bottom,
                          textDirection: TextDirection.rtl,
                          onSaved: (value) {
                            searchValue = value;
                          },
                          onEditingComplete: () {
                            submitForm();
                          },
                          decoration: InputDecoration(
                            //prefixIcon:Icon(Icons.search,) ,
                            hintText: 'ابحث عن اسم الحرفة او مكان البحث',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                submitForm();
                              },
                            ),
                            //helperMaxLines: 2,
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        )),
                  ),
                ),
                Align(
                  //  alignment: Alignment(-.9, 1),
                  child: Text(
                    'الاكثر مشاهدة',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: KMainColor, fontSize: 20.0),
                  ),
                ),
                checkDataNotExist() == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: _deviceHeight * .0001),
                        width: _deviceWidth * .3,
                        height: _deviceHeight * .17,
                        child: ListView.builder(
                          controller: scrollController1,
                          itemBuilder: (BuildContext context, int index) =>
                              UpperCard(index, mostViewUserData),
                          scrollDirection: Axis.horizontal,
                          itemCount: mostViewUserData.length,
                          shrinkWrap: true,
                        ),
                      ),
                SizedBox(height: 5.0),
                Align(
                    child: Text('الكل',
                        style: TextStyle(color: KMainColor, fontSize: 20.0))),
                SizedBox(height: 10.0),
                checkDataNotExist()
                    ? Center(
                        child: CircularProgressIndicator(),
                      )

                    //the build of the all users

                    : Container(
                        margin: EdgeInsets.only(
                            right: _deviceWidth * .05,
                            top: _deviceHeight * .003,
                            left: _deviceWidth * .05,
                            bottom: _deviceHeight * .003),
                        height: _deviceHeight * .4,
                        child: ListView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) =>
                              DownCard(index, 'الكل', allUserData),
                          itemCount: allUserData.length,
                          shrinkWrap: true,
                        ),
                      ),
                _bottomLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      ),
                Container(
                  child: AdmobBanner(
                    adUnitId: ams.getHome2(),
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // get all view of users
  Future getAllUsers() async {
    NetWorkHelper netWorkHelper = NetWorkHelper();
    var url = await netWorkHelper.getUrlAddress();

    if (pageCount == 0) {
      pageCount = 1;
    }
    if (count <= pageCount) {
      count++;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String lon = sharedPreferences.getString('lon');
      String lat = sharedPreferences.getString('lat');
      String countrySelected = sharedPreferences.getString('countrySelected');
      String citySelected = sharedPreferences.getString('citySelected');



      var urls ;
      if(lon != null ){
        urls = '${url}general/getAllTech?lon=$lon&lat=$lat&page=$count';
      }else{
        urls = '${url}general/getAllTech?country=$countrySelected&city=$citySelected&page=$count';
      }

      var response = await http.get(urls);
      if (response.statusCode == 200) {
        setState(() {
          flag = 1;
        });
        int lengthOfAllUser = jsonDecode(response.body)['TotaNum'];
        pageCount = (lengthOfAllUser / 10).floor().toInt();
        allUserData.addAll(jsonDecode(response.body)['Data']);

      } else {}
    }
    setState(() {
      _bottomLoading = false;
    });
  }

  // get most view real
  getMostViewUsers() async {
    NetWorkHelper networkHelper = NetWorkHelper();
    mostViewUserData = await networkHelper.getMostViewReal();
  }

  // get the image of user
  getImage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _userSharedImage = _prefs.getString('photo');
    _promo = _prefs.getString('promo');
  }

  // the build of drawer
  Widget _buildSideDrawer(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);
    return Drawer(
      child: Form(
        key: _form1,
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                AppBar(
                  backgroundColor: KMainColor,
                ),
                ListTile(
                  // leading: Icon(Icons.filter_list),
                  title: Center(
                      child: Text(
                    'اختر الصنعه التي تريد البحث عنها',
                    style: TextStyle(fontSize: 15, color: KMainColor),
                  )),
                ),
                DropdownButtonFormField<dynamic>(
                  value: selectedSan3a,
                  isExpanded: true,
                  items: job
                      .map((label) => DropdownMenuItem(
                          child: Align(
                              alignment: Alignment(1, 1),
                              child: Container(width: _deviceWidth,child: Text(label.toString(),textAlign: TextAlign.end,))),
                          value: label))
                      .toList(),
                  hint: Align(
                      alignment: Alignment(1, 1), child: Text('اختر الصنعة')),
                  onChanged: (value) {
                    setState(() {
                      selectedSan3a = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      selectedSan3a = value;
                    });
                  },
                ),
                Divider(),
                SizedBox(
                  height: _deviceHeight * .02,
                ),
                Center(
                  child: Text(
                    'حدد الدولة التي تريد البحث بها',
                    style: TextStyle(color: KMainColor),
                  ),
                ),
                // chosse the country
                DropdownButtonFormField<dynamic>(
                  value: selectedCountry,
                  isExpanded: true,
                  items: country
                      .map((label) => DropdownMenuItem(
                          child: Align(
                              alignment: Alignment(1, 1),
                              child: Container(width: _deviceWidth,child: Text(label.toString(),textAlign: TextAlign.end,))),
                          value: label)).toList(),
                  hint: Align(
                      alignment: Alignment(1, 1),
                      child: Text(
                        'اختر الدولة',
                      )),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                      selectedCity = 'أختر محافظة';
                      getCityOfCountry();
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                ),

                SizedBox(
                  height: _deviceHeight * .02,
                ),
                Align(
                  child: Text(
                    'حدد المحافظة التي تريد البحث بها',
                    style: TextStyle(color: KMainColor),
                  ),
                ),
                DropdownButtonFormField<dynamic>(
                  value: selectedCity,
                  isExpanded: true,
                  items: city
                      .map((label) => DropdownMenuItem(
                          child: Align(
                              alignment: Alignment(1, 1),
                              child: Container(width: _deviceWidth,child: Text(label.toString(),textAlign: TextAlign.end,))),
                          value: label)).toList(),
                  hint: Align(
                      alignment: Alignment(1, 1),
                      child: Text(
                        'اختر المحافظة',
                      )),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
                SizedBox(
                  height: _deviceHeight * .03,
                ),
                Container(
                  width: _deviceWidth * .5,
                  child: RaisedButton(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: KMainColor,
                      onPressed: submitDrawer,
                      child: Center(
                        child: Text(
                          'عرض نتائج الفلترة',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                SizedBox(
                  height: _deviceHeight * .05,
                ),
                widget.isUser
                    ? RaisedButton(
                        onPressed: () {
                          _userAuth.logOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => LogInScreen())));
                        },
                        child: Text(
                          'تسجيل الخروج',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: KMainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      )
                    : Container(),
                widget.isUser
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: _deviceHeight * .1,
                          ),
                          Text(_promo, style: TextStyle(fontSize: 15)),
                          SizedBox(
                            width: _deviceWidth * .052,
                          ),
                          Text(
                            'كود الدعوة',
                            style: TextStyle(color: KMainColor, fontSize: 15),
                          )
                        ],
                      )
                    : SizedBox(
                        height: _deviceHeight * .05,
                      ),
                RaisedButton(
                    color: KMainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 15,
                    onPressed: () {
                      launch(ConsData.facebookUrl);
                    },
                    child: Text(
                      'تواصل معنا',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
