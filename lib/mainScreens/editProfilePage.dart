import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/networking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constantTheme.dart';
import '../size.dart';
import 'homePage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SharedPreferences sharedPreferences;
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  File _imageFile;
  NetWorkHelper _netWorkHelper = NetWorkHelper();
  bool buttonIsLoading = false;
  String countryName;
  String selectCountry,selectCity;

  List<dynamic> job = [];
  List<dynamic> country = [];
  List<dynamic> city =[];

  Map<String, dynamic> userData = {
    "name": null,
    "mobile": null,
    "photo": null,
    "field": null,
    "country": null,
    "city": null,
    "bio": null,
    'token': null,
    "address": null
  };

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    userData['name'] = sharedPreferences.getString('name');
    userData['mobile'] = sharedPreferences.getString('mobile');
    userData['photo'] = sharedPreferences.getString('photo');
    userData['field'] = sharedPreferences.getString('field');
    userData['country'] = sharedPreferences.getString('country');
    userData['city'] = sharedPreferences.getString('city');
    userData['bio'] = sharedPreferences.getString('bio');
    userData['address'] = sharedPreferences.getString('address');
    userData['techId'] = sharedPreferences.getString('techId');
    setState(() {
      isLoading = false;
    });
  }

  getCityOfCountry() async {
    try {
      switch (userData['country']) {
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

  void _submitForm(Function update) async {
    if (!_form.currentState.validate()) {
      setState(() {
        buttonIsLoading = false;
      });
      return;
    }
    _form.currentState.save();
    var fImage = "";
    if (_imageFile != null) {
      fImage = _imageFile.path;
    }
    //selectedAllJobs.add(selectedJob);
    Map<String, dynamic> successInformation;
    successInformation = await update(
      techID: userData['techId'],
      name: userData['name'],
      mobile: userData['mobile'],
      image: fImage,
      country: userData['country'],
      city: userData['city'],
      bio: userData['bio'],
      address: userData['address'],
      field: userData['field'],
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
                    buttonIsLoading = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() {
      buttonIsLoading = false;
    });
    //after succes or alert
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);
    // String pattern = r'(^(?:[+0]9)?[0-9]{11,11}$)';
    // RegExp regExp = new RegExp(pattern);


    takePhoto() async {
      Navigator.pop(context);
      // ignore: deprecated_member_use
      File imageFile = await ImagePicker.pickImage(
          imageQuality: 0,
          source: ImageSource.camera,
          maxWidth: 960,
          maxHeight: 675);
      setState(() {
        _imageFile = imageFile;
      });
    }
    chooseFromGallery() async {
      Navigator.pop(context);
      // ignore: deprecated_member_use
      File imageFile = await ImagePicker.pickImage(
        imageQuality: 0,
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

    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Form(
                  key: _form,
                  child: Container(
                    height: deviceHeight,
                    width: deviceWidth,
                    child: Stack(
                      children: [
                        Positioned(
                          top: deviceHeight * .08,
                          left: deviceWidth * .27,
                          right: deviceWidth * .22,
                          child: Text(
                            'تعديل المعلومات الشخصية',
                            style: TextStyle(color: KMainColor),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * .01,
                        ),
                        SizedBox(
                          height: deviceHeight * .01,
                        ),
                        Positioned(
                          top: deviceHeight * .12,
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,
                          child: TextFormField(
                            initialValue: userData['name'],
                            textDirection: TextDirection.rtl,
                            maxLength: 25,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.length < 5) {
                                return 'من فضلك ادخل اسم';
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                userData['name'] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                userData['name'] = value;
                              });
                            },
                            textAlign: TextAlign.right,
                            cursorColor: Colors.grey,
                            style: TextStyle(color: KMainColor),
                            decoration: InputDecoration(
                                hintText: 'الاسم ',
                                hintStyle: TextStyle(color: KMainColor)),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * .01,
                        ),

                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: deviceHeight * .01,
                        ),
                        Positioned(
                          top: deviceHeight * .23,
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,
                          child: TextFormField(
                            initialValue: userData['mobile'],
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            onChanged: (value) {
                              setState(() {
                                userData['mobile'] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                userData['mobile'] = value;
                              });
                            },
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'من فضلك ادخل رقم هاتف صحيح';
                              }
                            },
                            // ignore: missing_return
                            textAlign: TextAlign.right,
                            cursorColor: Colors.grey,
                            style: TextStyle(color: KMainColor),
                            decoration: InputDecoration(
                                hintText: 'رقم الهاتف',
                                counterText: '',
                                hintStyle: TextStyle(color: KMainColor)),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * .01,
                        ),
                        Positioned(
                          top: deviceHeight * .33,
                          right: deviceWidth * 0.05,
                          left: deviceWidth * 0.05,
                          child: StreamBuilder<QuerySnapshot>(
                              // ignore: deprecated_member_use
                              stream: Firestore.instance
                                  .collection('job')
                                  .snapshots(),
                              // ignore: missing_return
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator(),);
                                } else {
                                  for (var countries
                                      // ignore: deprecated_member_use
                                      in snapshot.data.documents) {
                                    job = countries.data()["jobs"];
                                  }
                                  return DropdownButtonFormField<dynamic>(
                                    autovalidateMode: AutovalidateMode.always,
                                    elevation: 9,
                                    value: userData['field'],
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
                                        userData['field'] = value;
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        userData['field'] = value;
                                      });
                                    },
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value == null)
                                        return 'من فضلك اختر حرفة';
                                    },
                                  );
                                }
                              }),
                        ),

                        SizedBox(
                          height: deviceHeight * .01,
                        ),
                        Positioned(
                          top: deviceHeight * .42,
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: (deviceHeight * 0.04)),
                            child: TextFormField(
                              initialValue: userData['bio'],
                              maxLines: 2,
                              maxLength: 150,
                              minLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  userData['bio'] = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  userData['bio'] = value;
                                });
                              },
                              textAlign: TextAlign.right,
                              cursorColor: Colors.grey,
                              style: TextStyle(color: KMainColor),
                              decoration: InputDecoration(
                                  hintText: 'البايو الجديدة',
                                  hintStyle: TextStyle(color: KMainColor)),
                            ),
                          ),
                        ),


                        Positioned(
                          top: deviceHeight * .51,
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,

                          child: Center(
                            child: Text(
                              'حدد الدولة التي تريد البحث بها',
                              style: TextStyle(color: KMainColor),
                            ),
                          ),
                        ),

                        Positioned(
                          top: deviceHeight * .53,
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,
                          child: StreamBuilder<QuerySnapshot>(
                              // ignore: deprecated_member_use
                              stream: Firestore.instance
                                  .collection('country')
                                  .snapshots(),
                              // ignore: missing_return
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator(),);
                                } else {
                                  // ignore: deprecated_member_use
                                  for (var countries in snapshot.data.documents) {
                                    country = countries.data()["country"];
                                  }
                                  return DropdownButtonFormField<dynamic>(
                                    autovalidateMode: AutovalidateMode.always,
                                    value: selectCountry,//userData['country'],
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
                                        selectCountry = value;
                                        userData['country'] = value;
                                        selectCity = 'أختر محافظة';
                                        userData['city'] = 'أختر محافظة';
                                        getCityOfCountry();
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        selectCountry = value;
                                        userData['country'] = value;
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
                        ),

                        Positioned(
                          top: deviceHeight * .58,
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: (deviceHeight * 0.02)),
                            child: StreamBuilder<QuerySnapshot>(
                              // ignore: deprecated_member_use
                              stream: Firestore.instance
                                  .collection(
                                  countryName == null ? 'default city' : countryName)
                                  .snapshots(),
                              // ignore: missing_return
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator(),);
                                } else {
                                  // ignore: deprecated_member_use
                                  for (var country in snapshot.data.documents) {
                                    city = country.data()["city"];
                                  }
                                  return DropdownButtonFormField<dynamic>(
                                    autovalidateMode: AutovalidateMode.always,
                                    value: selectCity,//userData['city'],
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
                                        selectCity = value;
                                        userData['city'] = value;
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        selectCity = value;
                                        userData['city'] = value;
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
                          ),
                        ),

                        Positioned(
                          top: deviceHeight * .67,
                          right: deviceWidth * .04,
                          left: deviceWidth * .09,
                          child: TextFormField(
                            maxLength: 50,
                            minLines: 1,
                            maxLines: 2,
                            initialValue: userData['address'],
                            decoration: InputDecoration(
                                hintText:
                                    'قم بادخال المكان الخاص بك   (اختياري)',
                                hintStyle: TextStyle(color: KMainColor)),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {
                                userData['address'] = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                userData['address'] = value;
                              });
                            },
                          ),
                        ),
                        Positioned(
                          top: deviceHeight * .75,
                          right: deviceWidth * .04,
                          left: deviceWidth * .09,
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image(
                                  width: deviceWidth * .27,
                                  height: deviceWidth * .27,
                                  fit: BoxFit.fill,
                                  image: _imageFile != null
                                      ? FileImage(_imageFile)
                                      : NetworkImage(userData['photo']),
                                  // _imageFile != null ? FileImage(_imageFile) : AssetImage('assets/images/back1.png'),
                                ),
                              ),
                              SizedBox(
                                width: deviceWidth * .1,
                              ),
                              RaisedButton(
                                color: KMainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  'تغيير الصورة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () => selectImage(context),
                              ),
                            ],
                          ),
                        ),
                        // Positioned(

                        Positioned(
                          top: deviceHeight * .9,
                          right: deviceWidth * .09,
                          left: deviceWidth * .09,
                          child: !buttonIsLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      minWidth: deviceWidth * .35,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'الغاء',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: KMainColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                                    SizedBox(
                                      width: deviceWidth * .1,
                                    ),
                                    FlatButton(
                                      minWidth: deviceWidth * .35,
                                      onPressed: () {
                                        setState(() {
                                          buttonIsLoading = true;
                                        });
                                        _submitForm(_netWorkHelper.update);
                                      },
                                      child: Text(
                                        'تأكيد التعديل',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: KMainColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                                  ],
                                )
                              : Container(
                                  child: Center(
                                    child: Text(
                                      'جاري التعديل',
                                      style: TextStyle(color: KMainColor),
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
