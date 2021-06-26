import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetWorkHelper {

  Future<String> getUrlAddress() async {
    try {
      await Firebase.initializeApp();
      QuerySnapshot snapshot =
          await Firestore.instance.collection('urlAddress').getDocuments();
      for (var data in snapshot.documents) {
        return data.data()['url'];
      }
    } catch (e) {
      print(e);
    }
    // return 'https://snai3i-dev.herokuapp.com/';
  }

  Future<List> getCountryList()async {
    try{
      await Firebase.initializeApp();
      QuerySnapshot snapshot =
      await Firestore.instance.collection('country').getDocuments();
      for(var country in snapshot.documents){
        return country.data()['country'];
      }
    }catch(e){print(e);}
  }
  // ignore: missing_return
  Future<List> getCityList({String nameOfCountry})async {
    try{
      await Firebase.initializeApp();
      QuerySnapshot snapshot = await Firestore.instance.collection('$nameOfCountry').getDocuments();
      for(var country in snapshot.documents){
        return country.data()['city'];
      }
    }catch(e){print(e);}
  }
  Future<List> getJobList()async {
    try{
      await Firebase.initializeApp();
      QuerySnapshot snapshot =
      await Firestore.instance.collection('job').getDocuments();
      for(var country in snapshot.documents){
        return country.data()['jobs'];
      }
    }catch(e){print(e);}
  }

  Future<String> getHome1Address() async {
    try {
      await Firebase.initializeApp();
      QuerySnapshot snapshot =
      await Firestore.instance.collection('home1').getDocuments();
      for (var data in snapshot.documents) {
        return data.data()['home11'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future getMostViewReal() async {
    var url = await getUrlAddress();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lon = sharedPreferences.getString('lon');
    String lat = sharedPreferences.getString('lat');
    String countrySelected = sharedPreferences.getString('countrySelected');
    String citySelected = sharedPreferences.getString('citySelected');
    // var urls='${url}general/getMostViewReal?lat=$lat&lon=$lon';
    // if(lat==null) urls='${url}general/getMostView?lat=&lon=&country=$countrySelected&city=$citySelected';

    var urls ;
    if(lon != null ){
      urls = '${url}general/getMostView?lon=$lon&lat=$lat';
    }else{
      urls = '${url}general/getMostView?country=$countrySelected&city=$citySelected';
    }

    http.Response response = await http.get(urls);
    if (response.statusCode == 200) {
      List<dynamic> mostViewUsers = await jsonDecode(response.body)['Data'];
      return mostViewUsers;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  // Future increaseMostView(String id) async {
  //   var url = await getUrlAddress();
  //   var urls = '${url}general/IncreaseView';
  //   var response = await http.post(urls,body: {"Id": id});
  //   var message = jsonDecode(response.body);
  // }

  Future<Map<String, dynamic>> update(
      {String mobile,
      String name,
      String country,
      String city,
      String bio,
      String image,
      String address,
      String field,
      String techID}) async {
    var url = await getUrlAddress();
    var request = http.MultipartRequest('put',
        Uri.parse("${url}technichian/editProfile"));
    if (image != "") {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image,
        ),
      );
    }


    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    request.headers['Authorization'] = "Bearer $token";
    request.fields['mobile'] = mobile;
    request.fields['bio'] = bio;
    request.fields['name'] = name;
    request.fields['country'] = country;
    request.fields['city'] = city;
    request.fields['TechID'] = techID;
    request.fields['address'] = address != null ? address : '';
    request.fields['field'] = field;
    bool hasError = true;
    String message = 'حدث خطأ ما';
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    Map<String, dynamic> jResponse = jsonDecode(respStr);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (jResponse['state'] == 1) {
      // token = message['data']['token'];
      hasError = false;
      message = 'Authentication succeeded!';

      //sharedPreferences.setString('token',jResponse['Data']['token']);

      sharedPreferences.setString('name', jResponse['Data']['name']);
      sharedPreferences.setString('mobile', jResponse['Data']['mobile']);
      sharedPreferences.setString('photo', jResponse['Data']['photo']);
      sharedPreferences.setString('field', jResponse['Data']['field']);
      sharedPreferences.setString('country', jResponse['Data']['country']);
      sharedPreferences.setString('city', jResponse['Data']['city']);
      sharedPreferences.setString('bio', jResponse['Data']['bio']);
      sharedPreferences.setString('image', jResponse['Data']['photo']);
      sharedPreferences.setString('address', jResponse['Data']['address']);
      sharedPreferences.setString('techId', jResponse['Data']['_id']);

    } else if (jResponse['state'] == 0) {
      hasError = true;
      message = jResponse['message'];
    } else {
      hasError = true;
      message = 'تأكد من اتصالك بالانترنت';
    }
    return {'success': !hasError, 'message': message};
  }
}
