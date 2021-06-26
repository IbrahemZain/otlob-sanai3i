import 'dart:convert';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import '../providers/networking.dart';
import '../services/admob_services.dart';
import '../constantTheme.dart';
import 'package:http/http.dart' as http;
import '../mainScreens/homePage.dart';

import '../signUpPages/firstSignUpScreen.dart';
import '../size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SLogin extends StatefulWidget {
  @override
  _SLoginState createState() => _SLoginState();
}

class _SLoginState extends State<SLogin> {
  String _phone;
  String pattern = r'(^(?:[+0]9)?[0-9]{11,11}$)';
  String _password;
  bool _hidePass = true;
  String token;
  bool _buttonIsLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ams = AdMobService();

  Widget buildText({String textInfo}) {
    return Align(
        child: Row(
      children: <Widget>[
        Text(
          textInfo,
          style: TextStyle(color: KMainColor, fontSize: 18.0, inherit: false),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    Future logInAuth(String phone, String password) async {
      NetWorkHelper netWorkHelper = NetWorkHelper();
      var url = await netWorkHelper.getUrlAddress();
      try{
        var urlOfLogin = "${url}auth/login";
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var response = await http.post(urlOfLogin, body: {"mobile": phone, "password": password});

        var message = jsonDecode(response.body);

        if (message['state'] == 1) {
          token = message['data']['token'];
          sharedPreferences.setString('token', token);
          sharedPreferences.setString('name', message['data']['user']['name']);
          sharedPreferences.setString('mobile', message['data']['user']['mobile']);
          sharedPreferences.setString('photo', message['data']['user']['photo']);
          sharedPreferences.setString('promo', message['data']['user']['promo']);
          sharedPreferences.setString('field', message['data']['user']['field']);
          sharedPreferences.setString('country', message['data']['user']['country']);

          print("#############2@22222211!!!!!! ${message['data']}");

          sharedPreferences.setString('city', message['data']['user']['city']);
          sharedPreferences.setString('bio', message['data']['user']['bio']);
          //  sharedPreferences.setString('image', message['data']['user']['photo']);
          sharedPreferences.setString('address', message['data']['user']['address']);
          sharedPreferences.setString('techId', message['data']['user']['userId']);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: ((context) => HomePage(isUser: true))),
                  (Route<dynamic> route) => false);
        } else if (message['state'] == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(
                  message['message'],
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(
                  'تأكد من اتصالك بالأنترنت',
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
      }catch(e){print(e);}
    }

    void _submitForm() async {
      if (!_formKey.currentState.validate()) {
        setState(() {
          _buttonIsLoading = false;
        });
        return;
      }
      _formKey.currentState.save();
      logInAuth(_phone, _password);
    }

    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: AdmobBanner(
              adUnitId: ams.getLogin1(),
              adSize: AdmobBannerSize.BANNER,
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              // decoration: BoxDecoration(color: Colors.white60),
              child: Stack(
                children: [
                  Positioned(
                    top: deviceHeight * .1,
                    right: deviceWidth * .05,
                    child: buildText(textInfo: 'رقم الهاتف'),
                  ),
                  Positioned(
                    top: deviceHeight * .19,
                    right: deviceWidth * .05,
                    child: Icon(
                      Icons.phone,
                      color: KMainColor,
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .16,
                    left: deviceWidth * .08,
                    right: deviceWidth * .16,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.right,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          hintText: 'رقم الهاتف الخاص بك',
                          hintStyle: TextStyle(color: KMainColor)),
                      style: TextStyle(color: KMainColor),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'من فضلك ادخل رقم هاتف ';
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _phone = value;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .28,
                    right: deviceWidth * .05,
                    child: buildText(
                      textInfo: 'كلمة السر',
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .32,
                    right: deviceWidth * .03,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: KMainColor,
                      ),
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .32,
                    left: deviceWidth * .08,
                    right: deviceWidth * .16,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      cursorColor: Colors.grey,
                      obscureText: _hidePass,
                      decoration: InputDecoration(
                        hintText: 'ادخل كلمه السر',
                        hintStyle: TextStyle(color: KMainColor),
                      ),
                      style: TextStyle(color: KMainColor),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'من فضلك ادخل كلمة سر تتكون من اكثر من 6 احرف او ارقام';
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .45,
                    left: deviceWidth * .25,
                    right: deviceWidth * .25,
                    child: !_buttonIsLoading
                        ? RaisedButton(
                            elevation: 10,
                            onPressed: () {
                              setState(() {
                                _buttonIsLoading = true;
                              });
                              _submitForm();
                            },
                            child: Text(
                              'تسجيل',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: KMainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          )
                        : Center(
                            child: Text(
                              'جاري التسجيل',
                              style: TextStyle(color: KMainColor, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                  Positioned(
                    top: deviceHeight * .55,
                    left: deviceWidth * .47,
                    right: deviceWidth * .47,
                    child: Text(
                      'أو',
                      style: TextStyle(
                          color: KMainColor, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .6,
                    left: deviceWidth * .3,
                    right: deviceWidth * .3,
                    child: Text(
                      'لا تملك حساب؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: KMainColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),


                  Positioned(
                    top: deviceHeight * .65,
                    left: deviceWidth * .25,
                    right: deviceWidth * .25,
                    child: RaisedButton(
                      elevation: 10,
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => FirstSignUpScreen())));
                      },
                      child: Text(
                        'انشئ حساب الان',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: KMainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .8,
                    left: 0,
                    right: 0,
                    child: AdmobBanner(
                      adUnitId: ams.getLogin2(),
                      adSize: AdmobBannerSize.LARGE_BANNER,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
