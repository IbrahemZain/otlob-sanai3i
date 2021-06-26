import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../services/admob_services.dart';

import 'package:flutter/material.dart';

import '../constantTheme.dart';
import '../size.dart';
import 'homePage.dart';

class SelectCountryScreen extends StatefulWidget {
  @override
  _SelectCountryScreenState createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final _form = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;

  String selectedCountry, selectedCity;
  String countryName;
  List<dynamic> country = [];
  List<dynamic> city = [];

  getCityOfCountry() async {
    try {
      switch (selectedCountry) {
        case 'مصر':
          countryName = 'city of egypt';
          break;
        case 'السعودية':
          countryName = 'city of saudia';
          break;
        case 'الكويت':
          countryName = 'city of elkwet';
          break;
        case 'اليمن':
          countryName = 'city of elyaman';
          break;
        case 'الإمارات':
          countryName = 'city of emarat';
          break;
        case 'قطر':
          countryName = 'city of qatar';
          break;
        case 'عمان':
          countryName = 'city of oman';
          break;
        case 'البحرين':
          countryName = 'city of the sea';
          break;
        case 'سوريا':
          countryName = 'city of sorya';
          break;
        case 'العراق':
          countryName = 'city of iraq';
          break;
        case 'فلسطين':
          countryName = 'city of palastin';
          break;
        case 'لبنان':
          countryName = 'city of lbnan';
          break;
        case 'الاردن':
          countryName = 'city of elordon';
          break;
        case 'تونس':
          countryName = 'city of twones';
          break;
        case 'الجزائر':
          countryName = 'city of elgza2er';
          break;
        case 'ليبيا':
          countryName = 'city of lebya';
          break;
        case 'السودان':
          countryName = 'city of sodan';
          break;
        case 'موريتانيا':
          countryName = 'city of moretanya';
          break;
        case 'الصومال':
          countryName = 'city of somal';
          break;
        case 'جيبوتي':
          countryName = 'city of geboty';
          break;
        case 'جرز القمر':
          countryName = 'city of elkamer';
          break;
        default:
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  void submitForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          'countrySelected', selectedCountry.toString());
      sharedPreferences.setString('citySelected', selectedCity.toString());
    } catch (err) {
      sharedPreferences.setString('lon', null);
      sharedPreferences.setString('lat', null);
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: ((context) => HomePage(isUser: false))));
  }

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);
    final ams = AdMobService();


    return Scaffold(
      body: Container(
        width: _deviceWidth,
        height: _deviceHeight,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _deviceHeight * .05),
                  child: AdmobBanner(
                    adUnitId: ams.getRegC1(),
                    adSize: AdmobBannerSize.LARGE_BANNER,
                  ),
                ),
                SizedBox(
                  height: _deviceHeight * .1,
                ),
                Center(
                  child: Text(
                    'حدد الدولة التي تريد البحث بها',
                    style: TextStyle(color: KMainColor),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('country').snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        for (var countries in snapshot.data.documents) {
                          country = countries.data()["country"];
                        }
                        return DropdownButtonFormField<dynamic>(
                          autovalidateMode: AutovalidateMode.always,
                          value: selectedCountry,
                          isExpanded: true,
                          items: country
                              .map((label) => DropdownMenuItem(
                                  child: Align(
                                      alignment: Alignment(1, 1),
                                      child: Container(
                                          width: _deviceWidth,
                                          child: Text(
                                            label.toString(),
                                            textAlign: TextAlign.end,
                                          ))),
                                  value: label))
                              .toList(),
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
                          // ignore: missing_return
                          validator: (value) {
                            if (value == null) {
                              return 'من فضلك اختر الدولة';
                            }
                          },
                        );
                      }
                    }),
                SizedBox(
                  height: _deviceHeight * .02,
                ),
                Align(
                  child: Text(
                    'حدد المحافظة التي تريد البحث بها',
                    style: TextStyle(color: KMainColor),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(
                          countryName == null ? 'default city' : countryName)
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      for (var country in snapshot.data.documents) {
                        city = country.data()["city"];
                      }
                      return DropdownButtonFormField<dynamic>(
                        autovalidateMode: AutovalidateMode.always,
                        value: selectedCity,
                        isExpanded: true,
                        items: city
                            .map((label) => DropdownMenuItem(
                                child: Align(
                                    alignment: Alignment(1, 1),
                                    child: Container(
                                        width: _deviceWidth,
                                        child: Text(
                                          label.toString(),
                                          textAlign: TextAlign.end,
                                        ))),
                                value: label))
                            .toList(),
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
                        // ignore: missing_return
                        validator: (value) {
                          if (value == null || value == 'أختر محافظة') {
                            return 'من فضلك اختر محافظة';
                          }
                        },
                      );
                    }
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
                    onPressed: submitForm,
                    child: Center(
                      child: Text(
                        'عرض النتائج',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight * .1,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: _deviceHeight * .2),
                  child: AdmobBanner(
                    adUnitId: ams.getRegC2(),
                    adSize: AdmobBannerSize.LARGE_BANNER,
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
