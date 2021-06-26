import 'dart:io';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sanai3i/services/admob_services.dart';
import '../constantTheme.dart';
import '../signUpPages/thirdSignUpPage.dart';
import '../size.dart';

class SecondSignUpScreen extends StatefulWidget {
  final String _name, _password;

  SecondSignUpScreen(this._name, this._password);

  @override
  _SecondSignUpScreenState createState() => _SecondSignUpScreenState();
}

class _SecondSignUpScreenState extends State<SecondSignUpScreen> {
  String selectedCity, selectedCountry;
  String _bio, _manualLocation;
  File _imageFile;
  final ams = AdMobService();
  final _form = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  List<dynamic> country = [];
  List<dynamic> city = [];

  String countryName;

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

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

  Widget buildText({String textInfo}) {
    return Text(textInfo,
        textAlign: TextAlign.center,
        style: TextStyle(color: KMainColor, fontSize: 18.0, inherit: false));
  }
  takePhoto() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 960, maxHeight: 675);
    setState(() {
      _imageFile = imageFile;
    });
  }
  chooseFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = imageFile;
    });
  }
  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("اختيار صوره شخصيه"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("قم بتصوير صورة"),
                onPressed: takePhoto,
              ),
              SimpleDialogOption(
                child: Text("اختر صورة من المعرض"),
                onPressed: chooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text("الغاء"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    void _submitForm() async {
      if (!_form.currentState.validate()) {
        return;
      }
      _form.currentState.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdSignUpScreen(
            country: selectedCountry,
            city: selectedCity,
            imageFile: _imageFile,
            bio: _bio,
            name: widget._name,
            password: widget._password,
            address: _manualLocation,
          ),
        ),
      );
    }

    return Scaffold(
      body: country ==null ? Center(child: CircularProgressIndicator(),) : ListView(
        children: [
          Form(
            key: _form,
            child: Column(
              children: <Widget>[
                SizedBox(height: deviceHeight * .02),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * .08),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: AdmobBanner(
                          adUnitId: ams.getRegB1(),
                          adSize: AdmobBannerSize.FULL_BANNER,
                        ),
                      ),
                      SizedBox(height: deviceHeight * .02),
                      Center(
                          child: Text(
                        'انشئ حساب 2',
                        style: TextStyle(color: KMainColor),
                      )),
                      SizedBox(height: deviceHeight > 650 ? 10.0 : 7 * .02),
                      buildText(textInfo: 'الدولة'),

                      country ==null ? Center(child: CircularProgressIndicator(),) : StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('country')
                            .snapshots(),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator(),);
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
                                              width: deviceWidth,
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
                        },
                      ),

                      buildText(textInfo: 'المحافظة'),

                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection(
                            countryName == null ? 'default city' : countryName)
                            .snapshots(),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator(),);
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
                                          width: deviceWidth,
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
                                if (value == null || value == 'أختر محافظة' ) {
                                  return 'من فضلك اختر محافظة';
                                }
                              },
                            );
                          }
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          maxLength: 50,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: 'قم بادخال العنوان بالتفصيل  (اختياري)',
                              hintStyle: TextStyle(color: KMainColor)),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          onSaved: (value) {
                            _manualLocation = value;
                          },
                        ),
                      ),
                      SizedBox(height: deviceHeight * .02),
                      buildText(textInfo: 'نبذة مختصرة عنك'),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        maxLines: 3,
                        maxLength: 150,
                        minLines: 1,
                        textAlign: TextAlign.right,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            hintText:
                                'يمكنك كتابة بعض المعلومات عن نفسك (اختياري)'),
                        onSaved: (value) {
                          _bio = value;
                        },
                      ),
                      SizedBox(height: deviceHeight * .02),
                      Container(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            'ارفق صورة (اختياري)',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () => selectImage(context),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Container(
                          height: 200,
                          width: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _imageFile != null
                                  ? FileImage(_imageFile)
                                  : AssetImage('assets/images/tech.jpg'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: deviceWidth,
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
                          ],
                        ),
                      ),
                      AdmobBanner(
                        adUnitId: ams.getRegB2(),
                        adSize: AdmobBannerSize.BANNER,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
