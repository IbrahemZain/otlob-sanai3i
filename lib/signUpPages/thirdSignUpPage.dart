import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanai3i/services/admob_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constantTheme.dart';
import '../providers/authProvider.dart';

import '../size.dart';
import '../mainScreens/homePage.dart';

List<String> selectedProfession;

// ignore: must_be_immutable
class ThirdSignUpScreen extends StatefulWidget {
  final String city, country;
  final String name, password, bio, address;

  File imageFile;

  ThirdSignUpScreen({
    this.city,
    this.country,
    this.imageFile,
    this.bio,
    this.name,
    this.password,
    this.address,
  });

  @override
  _ThirdSignUpScreenState createState() => _ThirdSignUpScreenState();
}

class _ThirdSignUpScreenState extends State<ThirdSignUpScreen> {
  String pattern = r'(^(?:[+0]9)?[0-9]{11,11}$)';
  bool _notConnected = true;
  String _phone;
  String _imagePath;
  bool _buttonIsLoading = false;
  final ams = AdMobService();
  final _form = GlobalKey<FormState>();
  String lon = '';
  String lat = '';
  String selectedJob;
  List<dynamic> job = [];

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    lon = sharedPreferences.getString('lon') != null
        ? sharedPreferences.getString('lon')
        : '';
    lat = sharedPreferences.getString('lat') != null
        ? sharedPreferences.getString('lat')
        : '';
  }

  final Map<String, dynamic> _formData = {
    'mobile': null,
    'bio': null,
    'password': null,
    'name': null,
    'city': null,
    'country': null,
    'image': null,
    'address': null,
    'field': null,
    'refer': null,
    'lon': null,
    'lat': null,
  };

  Widget buildText({String textInfo}) {
    return Align(
        alignment: Alignment(-1, -1),
        child: Row(children: <Widget>[
          Text(textInfo,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.blue, fontSize: 18.0, inherit: false))
        ]));
  }

  @override
  void initState() {
    checkConnection();
    Firebase.initializeApp();
    //_imagePath = widget.imageFile != null ? widget.imageFile.path : "";
    super.initState();
  }

  // getAlljobs() async{
  //   try{
  //     job = await getAllJob();
  //   }catch(e){print(e);}
  // }

  @override
  Widget build(BuildContext context) {
    RegExp regExp = new RegExp(pattern);
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);
    UserAuth _userAuth = Provider.of<UserAuth>(context);
    _formData['name'] = widget.name;
    _formData['city'] = widget.city;
    _formData['country'] = widget.country;
    _formData['bio'] = widget.bio;
    _formData['image'] = _imagePath;
    _formData['address'] = widget.address;
    _formData['password'] = widget.password;
    _formData['lon'] = lon;
    _formData['lat'] = lat;

    void _submitForm(Function signUpAuth) async {
      if (!_form.currentState.validate()) {
        setState(() {
          _buttonIsLoading = false;
        });
        return;
      }
      if (_notConnected) {
        showDialog(
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
                      _buttonIsLoading = false;
                      checkConnection();
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      var FImage;
      if (widget.imageFile != null) {
        FImage = widget.imageFile.path;
      } else {
        FImage = '';
      }
      _form.currentState.save();
      //selectedAllJobs.add(selectedJob);
      Map<String, dynamic> successInformation;
      successInformation = await signUpAuth(
        password: _formData['password'],
        name: _formData['name'],
        mobile: _formData['mobile'],
        image: FImage,
        city: _formData['city'],
        country: _formData['country'],
        bio: _formData['bio'],
        address: _formData['address'],
        field: _formData['field'],
        refer: _formData['refer'],
        lon: _formData['lon'],
        lat: _formData['lat'],
      );

      if (successInformation['success']) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => HomePage(isUser: true))),
            (Route<dynamic> route) => false);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                successInformation['message'],
                textAlign: TextAlign.right,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Center(child: Text("حسنا")),
                  onPressed: () {
                    setState(() {
                      _buttonIsLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      body: job ==null ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Form(
          key: _form,
          child: Container(
            height: deviceHeight,
            padding: EdgeInsets.only(
                //  top: deviceHeight * .1,
                left: deviceWidth * .04,
                right: deviceWidth * .04),
            // margin: EdgeInsets.only(top: deviceHeight*.05,bottom: deviceHeight*.03),
            decoration: BoxDecoration(color: Colors.white60),
            child: Stack(
              children: [
                Positioned(
                  top: deviceHeight * .2,
                  left: deviceWidth * .3,
                  child: Text('رقم الهاتف',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: KMainColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
                Positioned(
                  top: deviceHeight * .3,
                  right: deviceWidth * .01,
                  child: Icon(
                    Icons.phone,
                    color: KMainColor,
                  ),
                ),
                Positioned(
                  top: deviceHeight * .28,
                  right: deviceWidth * .1,
                  left: deviceWidth * .02,
                  child: TextFormField(
                    //  keyboardType: TextInputType.number ,

                    textAlign: TextAlign.right,
                    cursorColor: Colors.lightBlueAccent,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'رقم الهاتف الخاص بك',
                      hintStyle: TextStyle(
                        color: KMainColor,
                      ),
                    ),
                    // ignore: missing_return
                    validator: (String value) {
                      if (value.isEmpty || value.length < 5 ) {
                        return 'من فضلك ادخل رقم هاتف صحيح';
                      }
                    },
                    onSaved: (value) {
                      _formData['mobile'] = value;
                    },
                    onChanged: (value) {
                      _formData['mobile'] = value;
                      setState(() {
                        _phone = value;
                      });
                    },
                  ),
                ),
                Positioned(
                  top: deviceHeight * .41,
                  right: deviceWidth * .01,
                  child: Icon(
                    Icons.phone,
                    color: KMainColor,
                  ),
                ),
                Positioned(
                  top: deviceHeight * .38,
                  right: deviceWidth * .1,
                  left: deviceWidth * .02,
                  child: TextFormField(
                    //  keyboardType: TextInputType.number ,

                    textAlign: TextAlign.right,
                    cursorColor: Colors.lightBlueAccent,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'تأكيد رقم الهاتف',
                      hintStyle: TextStyle(
                        color: KMainColor,
                      ),
                    ),
                    // ignore: missing_return
                    validator: (String value) {
                      if (value != _phone) {
                        return 'من فضلك تأكد من رقم هاتفك';
                      }
                    },
                    onSaved: (value) {
                      _formData['mobile'] = value;
                    },
                    onChanged: (value) {
                      _formData['mobile'] = value;
                    },
                  ),
                ),
                Positioned(
                  top: deviceHeight * .53,
                  right: deviceWidth * .01,
                  child: Icon(
                    Icons.build,
                    color: KMainColor,
                  ),
                ),
                Positioned(
                  top: deviceHeight * .51,
                  right: deviceWidth * .1,
                  left: deviceWidth * .02,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('job')
                          .snapshots(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator(),);
                        } else {
                          for (var countries in snapshot.data.documents) {
                            job = countries.data()["jobs"];
                          }
                          return  DropdownButtonFormField<dynamic>(
                            autovalidateMode: AutovalidateMode.always,
                            elevation: 9,
                            value: selectedJob,
                            isExpanded: true,
                            items: job
                                .map((label) => DropdownMenuItem(
                                child: Align(
                                    alignment: Alignment(1, 1),
                                    child: Container(
                                        width: deviceWidth,
                                        child: Text(
                                          label.toString(),
                                          textAlign: TextAlign.end,
                                        ))),
                                value: label))
                                .toList(),
                            hint: Align(
                                alignment: Alignment(1, 1),
                                child: Text("اختار الحرفه")),
                            dropdownColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                selectedJob = value;
                                _formData['field'] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                selectedJob = value;
                                _formData['field'] = value;
                              });
                            },
                            // ignore: missing_return
                            validator: (value) {
                              if (value == null) return 'من فضلك اختر حرفة';
                            },
                          );
                        }
                      }),

                ),

                Positioned(
                  top: deviceHeight * .63,
                  left: deviceWidth * .02,
                  right: deviceWidth * .1,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _formData['refer'] = value;
                      });
                    },
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        hintText: 'كود الدعوة  (اختياري)',
                        hintStyle: TextStyle(color: KMainColor)),
                  ),
                ),
                Positioned(
                  top: deviceHeight * .73,
                  left: deviceWidth * .25,
                  right: deviceWidth * .25,
                  child: !_buttonIsLoading
                      ? RaisedButton(
                          elevation: 25,
                          hoverElevation: 30,
                          onPressed: () {
                            setState(() {
                              _buttonIsLoading = true;
                            });
                            _submitForm(_userAuth.signUpAuth);
                          },
                          child: Text(
                            'تسجيل',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: KMainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hoverColor: Colors.grey,
                          splashColor: Colors.black,
                        )
                      : Center(
                          child: Text(
                            'جاري التسجيل',
                            style: TextStyle(
                                color: KMainColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
