import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import '../services/admob_services.dart';
import '../signUpPages/sLogin.dart';
import '../signUpPages/secodSignUpPage.dart';
import 'sLogin.dart';
import '../constantTheme.dart';
import '../size.dart';

class FirstSignUpScreen extends StatefulWidget {
  @override
  _FirstSignUpScreenState createState() => _FirstSignUpScreenState();
}

class _FirstSignUpScreenState extends State<FirstSignUpScreen> {
  String _password;
  String _name;
  bool _hidePass = true;
  bool _hideConfirmPass=true;
  final ams = AdMobService();
  final _form = GlobalKey<FormState>();

  Widget buildText({String textInfo}) {
    return Align(
        alignment: Alignment(-1, -1),
        child: Row(children: <Widget>[
          Text(textInfo,
              style:
              TextStyle(color: KMainColor, fontSize: 18.0, inherit: false))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    void _submitForm() {
      if (!_form.currentState.validate()) {
        return;
      }
      _form.currentState.save();
      Navigator.push(context, MaterialPageRoute(builder: (context) => SecondSignUpScreen(_name, _password)));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _form,
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              child: Stack(
                children: [
                  Positioned(
                    top: deviceHeight * .01,
                    left:  0,
                    right:  0,
                    child:  AdmobBanner(
                      adUnitId: ams.getRegA1(),
                      adSize: AdmobBannerSize.BANNER,
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .1,
                    left: deviceWidth * .40,
                    right: deviceWidth * .40,
                    child: Text(
                      'انشاء حساب',
                      style: TextStyle(color: KMainColor),
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .12,
                    right: deviceWidth * .03,
                    child: buildText(textInfo: 'الاسم'),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .17,
                    left: deviceWidth * .02,
                    right: deviceWidth * 0.05,
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      maxLength: 15,
                      autovalidateMode: AutovalidateMode.always,
                      textAlign: TextAlign.right,
                      cursorColor: Colors.grey,
                      style: TextStyle(color: KMainColor),
                      decoration: InputDecoration(
                          hintText: 'اسم الصنايعي',
                          hintStyle: TextStyle(color: KMainColor)),
                      onSaved: (value) {
                        _name = value;
                      },
                      // ignore: missing_return
                      validator: (String value) {
                        var _spaces=value.trim();
                        if (value.isEmpty||_spaces.length<5) {
                          return 'من فضلك ادخل اسمك صحيح   ';
                        }
                        if (value.length <=3 ) {
                          return '  يجب ان يتكون الاسم من اكثر من 3 احرف    ';
                        }
                      },
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .7,
                    left: deviceWidth * .47,
                    right: deviceWidth * .47,
                    child: Text(
                      'أو',
                      style: TextStyle(color: KMainColor),
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .75,
                    right: deviceWidth * .35,
                    child: Text(
                      'هل تملك حساب بالفعل ؟',
                      style: TextStyle(
                          color: KMainColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .8,
                    right: deviceWidth * .35,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SLogin())));
                      },
                      child: Text(
                        'ادخل علي حسابك الان ',
                        style: TextStyle(
                            color: KMainColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .29,
                    right: deviceWidth * .03,
                    child: buildText(
                      textInfo: ' كلمة السر',
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .35,
                    right: deviceWidth * .03,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                      icon: Icon(Icons.remove_red_eye, color: KMainColor,),
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .34,
                    left: deviceWidth * .02,
                    right: deviceWidth * 0.18,
                    child: TextFormField(
                      maxLength: 30,
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty||value.length<6) {
                          return 'من فضلك ادخل كلمة سر تتكون من اكثر من 6 احرف او ارقام   ';
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      onChanged: (value){
                        setState(() {
                          _password = value;
                        });
                      },
                      textAlign: TextAlign.right,
                      cursorColor: Colors.grey,
                      style: TextStyle(color: KMainColor),
                      obscureText: _hidePass,
                      decoration: InputDecoration(
                          hintText: 'كلمة السر',
                          counterText: '',
                          hintStyle: TextStyle(color: KMainColor)),
                    ),
                  ),
                  Positioned(
                    right: deviceWidth * .01,
                    top: deviceHeight * .45,
                    child: buildText(
                      textInfo: 'تأكيد كلمة السر',
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .51,
                    right: deviceWidth * .03,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _hideConfirmPass = !_hideConfirmPass;
                        });
                      },
                      icon: Icon(Icons.remove_red_eye, color: KMainColor,),
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * .5,
                    left: deviceWidth * .02,
                    right: deviceWidth * 0.18,
                    child: TextFormField(
                      // textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      cursorColor: Colors.grey,
                      style: TextStyle(color: KMainColor),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value != _password) {
                          return 'تأكد من ان كلمتان السر متطابقتان   ';
                        }
                      },

                      obscureText: _hideConfirmPass,
                      decoration: InputDecoration(
                          hintText: 'تأكيد كلمة المرور',
                          hintStyle: TextStyle(color: KMainColor)),
                    ),
                  ),
                  SizedBox(height: deviceHeight * .01),
                  Positioned(
                    top: deviceHeight * .62,
                    left: deviceWidth * .25,
                    right: deviceWidth * .25,
                    child: FlatButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text(
                        'اكمل باقي المعلومات',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: KMainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                  Positioned( top: deviceHeight * .9,
                    left:  0,
                    right:  0,
                    child:  AdmobBanner(
                      adUnitId: ams.getRegA2(),
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
}
