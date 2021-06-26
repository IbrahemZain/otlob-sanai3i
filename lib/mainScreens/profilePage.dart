import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanai3i/mainScreens/imageProfile.dart';
import '../services/admob_services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constantTheme.dart';
import '../size.dart';
import 'editProfilePage.dart';

class ProfilePage extends StatefulWidget {
  final String phone;
  final bool isUser;
  final int index;

  final List<dynamic> mvUsers;
  ProfilePage(
      {this.phone,
      @required this.isUser,
      @required this.mvUsers,
      @required this.index});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var image;
  var name;
  var field;
  var country;
  var city;
  var address;
  var bio;
  bool check;
  Timer timer;
  final ams = AdMobService();

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 0), (Timer t) => checkDataNotExist());
    getUserData();
  }

  Future getUserData() async {
    if (widget.isUser) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      image = _prefs.getString('photo');
      name = _prefs.getString('name').toString();
      field = _prefs.getString('field').toString();
      bio = _prefs.getString('bio').toString();
      address = _prefs.getString('address').toString();
      country = _prefs.getString('country').toString();
      city = _prefs.getString('city').toString();

    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool checkDataNotExist() {
    setState(() {
      if (widget.mvUsers == null && image == null) {
        check = true;
      } else
        check = false;
    });
    return check;
  }
  Future<void> _launched;
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);
    // final double _fontSize = fontSize(context);
    // final TextStyle _followTextStyle =
    // TextStyle(color: Colors.white, fontSize: textScale * 17.5);


    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: checkDataNotExist()
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  //color: Colors.white,
                  height: deviceHeight,
                  width: deviceWidth,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: deviceHeight * .03,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: deviceWidth,
                          height: deviceHeight * .2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Container(
                            child: AdmobBanner(
                              adUnitId: ams.getProfile1(),
                              adSize: AdmobBannerSize.LARGE_BANNER,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: deviceHeight * .59,
                        thickness: 2,
                      ),
                      Positioned(
                        top: deviceHeight * .22,
                        left: deviceWidth * .34,
                        right: deviceWidth * .34,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>ImageProfile(image: widget.isUser? image : widget.mvUsers[widget.index]['technician']['photo'] )));
                          },
                          child: Hero(
                            tag: 'dash',
                            child: ClipOval(
                              child: Image(
                                image: widget.isUser
                                    ? NetworkImage(image)
                                    : NetworkImage(
                                        widget.mvUsers[widget.index]['technician']['photo']),
                                width: deviceWidth * .25,
                                height: deviceWidth * .29,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: deviceWidth / 8,
                        top: deviceHeight * 0.57,
                        left: deviceWidth / 11,
                        child: Container(
                          width: deviceWidth * .8,
                          height: deviceHeight * .25,
                          padding: EdgeInsets.only(left: deviceWidth * .1,right:deviceWidth * .03),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: KMainColor),
                          ),
                          child: ListView(
                            children: [
                              Text(
                                widget.isUser
                                    ? bio
                                    : widget.mvUsers[widget.index]['technician']['bio']
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.right,
                                maxLines: 10,

                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: deviceWidth * .25,
                        top: deviceHeight * 0.83,
                        right: deviceWidth * .25,
                        child: widget.isUser
                            ? Container(
                                //width: deviceWidth*.3,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white)),
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                EditProfile())));
                                  },
                                  child: Text(
                                    'تعديل المعلومات الشخصية',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10, //_fontSize * 11,
                                        height: 1),
                                  ),
                                  color: KMainColor,
                                  hoverColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                ),
                              )
                            : Center(
                                child: RaisedButton(
                                hoverColor: Colors.black,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                color: KMainColor,
                                child: Text(
                                  'اتصل الان',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  // function use to call to this user
                                  setState(() {
                                    _launched = _makePhoneCall(
                                        'tel:${widget.mvUsers[widget.index]['technician']['mobile']}');
                                  });
                                },
                              )),
                      ),
                      Positioned(
                        right: 0,
                        top: deviceHeight * .37,
                        left: 0,
                        child: Center(
                            child: Text(
                          widget.isUser
                              ? name
                              : widget.mvUsers[widget.index]['technician']['name'].toString(),
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                          ),
                        )),
                      ),
                      Positioned(
                        right: 0,
                        top: deviceHeight * .41,
                        left: 0,
                        child: Center(
                            child: Text(
                          widget.isUser
                              ? field
                              : widget.mvUsers[widget.index]['technician']['field']
                                  .toString(),
                          style: TextStyle(
                            color: KMainColor,
                            fontSize: 20.0,
                          ),
                        )),
                      ),
                      Positioned(
                        right: deviceWidth * .03,
                        top: deviceHeight * .44,
                        //left: 0,
                        child: Center(
                            child: Text(
                          widget.isUser
                              ? country
                              : widget.mvUsers[widget.index]['technician']['country'].toString(),
                          style: TextStyle(
                            color: KMainColor,
                            fontSize: 20.0,
                          ),
                        )),
                      ),
                      Positioned(
                        right: deviceWidth * .03,
                        top: deviceHeight * .47, // 47
                        //left: 0,
                        child: Center(
                            child: Text(
                              widget.isUser
                                  ? city
                                  : widget.mvUsers[widget.index]['technician']['city'].toString(),
                              style: TextStyle(
                                color: KMainColor,
                                fontSize: 20.0,
                              ),
                            )),
                      ),
                      Positioned(
                        right: deviceWidth * .03,
                        top: deviceHeight * .50, //50
                        left: 5,
                        child: Text(
                          widget.isUser
                              ? address == 'null'
                                  ? ''
                                  : address
                              : widget.mvUsers[widget.index]['technician']['address']
                                          .toString() !=
                                      'null'
                                  ? widget.mvUsers[widget.index]['technician']['address']
                                      .toString()
                                  : "",
                          style: TextStyle(
                            color: KMainColor,
                            fontSize: 20.0,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Positioned(
                        top: deviceHeight * .91,
                        left: 0,
                        right: 0,
                        child: AdmobBanner(
                          adUnitId: ams.getHome1(),
                          adSize: AdmobBannerSize.BANNER,
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
