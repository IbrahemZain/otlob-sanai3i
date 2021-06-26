import 'package:flutter/material.dart';
import '../signUpPages/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainScreens/homePage.dart';
import 'package:geolocator/geolocator.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Position _position;
  SharedPreferences sharedPreferences;
  bool isLoading = false;

  @override
  void initState() {
    getLocation();
    checkLoginStatus();
    super.initState();
  }

  // it to know if he login or not
  checkLoginStatus() async {
    setState(() {
      isLoading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogInScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomePage(isUser: true)));
    }
  }

  // to get the current location of user when he just open
  void getLocation() async {
    try {
      _position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('lon', _position.longitude.toString());
      sharedPreferences.setString('lat', _position.latitude.toString());
    } catch (err) {
      print('errrrrrrrrrrrrrrrrr$err');
      sharedPreferences.setString('lon', null);
      sharedPreferences.setString('lat', null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: FlatButton(
          child: Text('مرحبا'),
          onPressed: () {
            isLoading ? CircularProgressIndicator() : checkLoginStatus();
          },
        ),
      ),
    ));
  }
}
