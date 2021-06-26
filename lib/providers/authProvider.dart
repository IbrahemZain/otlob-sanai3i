import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'networking.dart';

// Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class UserAuth with ChangeNotifier {
  /////////SIGN UP AUTH
  Future<Map<String, dynamic>> signUpAuth(
      {String mobile,
      String password,
      String name,
      String country,
      String city,
      String bio,
      String image,
      String address,
      String field,
      String refer,
      String lon,
      String lat}) async {
    bool hasError = true;
    String message = 'حدث خطأ ما';
    NetWorkHelper netWorkHelper = NetWorkHelper();
    var url = await netWorkHelper.getUrlAddress();
    var request = http.MultipartRequest(
        'put', Uri.parse("${url}auth/register"));
    if (image != "") {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image,
        ),
      );
    }

    request.fields['mobile'] = mobile;
    request.fields['bio'] = bio != null ? bio : '';
    request.fields['password'] = password;
    request.fields['name'] = name;
    request.fields['city'] = city;
    request.fields['country'] = country;
    request.fields['address'] = address != null ? address : '';
    request.fields['field'] = field;

    request.fields['refer'] = refer != null ? refer : '';
    request.fields['lon'] = lon;
    request.fields['lat'] = lat;

    var res = await request.send();

    final respStr = await res.stream.bytesToString();

    Map<String, dynamic> jResponse = jsonDecode(respStr);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (jResponse['state'] == 1) {
      // token = message['data']['token'];
      hasError = false;
      message = 'Authentication succeeded!';

      sharedPreferences.setString('token', jResponse['data']['token']);
      sharedPreferences.setString('name', jResponse['data']['user']['name']);
      sharedPreferences.setString('mobile', jResponse['data']['user']['mobile']);
      sharedPreferences.setString('photo', jResponse['data']['user']['photo']);
      sharedPreferences.setString('field', jResponse['data']['user']['field']);
      sharedPreferences.setString('country', jResponse['data']['user']['country']);
      sharedPreferences.setString('city', jResponse['data']['user']['city']);
      sharedPreferences.setString('bio', jResponse['data']['user']['bio']);
      // sharedPreferences.setString('image', jResponse['data']['user']['photo']);
      sharedPreferences.setString('address', jResponse['data']['user']['address']);

      sharedPreferences.setString('techId', jResponse['data']['user']['userId']);
      sharedPreferences.setString('promo', jResponse['data']['user']['promo']);
    } else if (jResponse['state'] == 0) {
      hasError = true;
      message = jResponse['message'];
    } else {
      hasError = true;
      message = 'تأكد من اتصالك بالانترنت';
    }
    return {'success': !hasError, 'message': message};
  }

  logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('token');
    prefs.remove('name');
    prefs.remove('mobile');
    prefs.remove('photo');
    prefs.remove('field');
    prefs.remove('city');
    prefs.remove('country');
    prefs.remove('bio');
    prefs.remove('image');
    prefs.remove('address');
    prefs.remove('techId');
  }
}
