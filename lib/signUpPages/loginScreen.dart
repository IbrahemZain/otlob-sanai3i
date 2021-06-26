import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:sanai3i/mainScreens/selectCountryCityScreen.dart';
import '../services/admob_services.dart';
import '../size.dart';
import '../widget/constData.dart';

import '../mainScreens/homePage.dart';
import '../constantTheme.dart';
import '../signUpPages/sLogin.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _notConnected = true;
  String lon,lat;
  @override


  void initState() {
    checkConnection();
    getPageCommunicationData();
    Firebase.initializeApp();
    checkLonLatExist();
    super.initState();
  }

  checkLonLatExist()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    lon = sharedPreferences.getString('lon');
    lat = sharedPreferences.getString('lat');
  }

  getPageCommunicationData() async {
    try{
      await Firebase.initializeApp();
      QuerySnapshot snapshot =
      await Firestore.instance.collection('urlFacebookPage').getDocuments();
      for(var country in snapshot.documents){
        ConsData.facebookUrl = country.data()['urlPage'];
      }
    }catch(e){print(e);}
  }

  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _notConnected = true;
      });
    } else {
      setState(() {
        _notConnected = false;
      });
    }
  }

  //Navigator.push(context, MaterialPageRoute(builder: ((context) => SLogin())))

  Widget buildRaisedButton(
      deviceWidth, deviceHeight, nameOfButton, thePageReturned) {
    return RaisedButton(
        color: KMainColor,
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth, vertical: deviceHeight),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: Text(nameOfButton, style: TextStyle(color: KTextColor)),
        onPressed: () {
          !_notConnected
              ? Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => thePageReturned)))
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text(
                        'من فضلك اتصل بالأنترنت',
                        textAlign: TextAlign.right,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Center(child: Text("حسنا")),
                          onPressed: () {
                            setState(() {
                              checkConnection();
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);
    final ams = AdMobService();


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: _deviceWidth,
          height: _deviceHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: _deviceHeight * .05),
                child: AdmobBanner(
                  adUnitId: ams.getWelcomePage1(),
                  adSize: AdmobBannerSize.LARGE_BANNER,
                ),
              ),

              SizedBox(height: _deviceHeight * .2),
              buildRaisedButton(_deviceWidth * .063, _deviceHeight * .01, 'الدخول للبحث عن صنايعي', lon == null ?  SelectCountryScreen() : HomePage(isUser: false,)),
              SizedBox(height: _deviceHeight * .05),
              buildRaisedButton(_deviceWidth * .119, _deviceHeight * .01, 'الدخول كصنايعي', SLogin()),

              Padding(
                padding: EdgeInsets.only(top: _deviceHeight * .2),
                child: AdmobBanner(
                  adUnitId: ams.getWelcomePage2(),
                  adSize: AdmobBannerSize.LARGE_BANNER,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
