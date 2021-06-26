import 'package:flutter/material.dart';
import 'providers/networking.dart';

const Color KMainColor=Colors.blueAccent;
const KTextColor=Colors.white;

Future<List>getAllCountry()async{
 List kACountry = [];
 NetWorkHelper netWorkHelper = NetWorkHelper();
 kACountry = await netWorkHelper.getCountryList();
 print('this is the all country : $kACountry');
 return kACountry;
}
Future<List>getAllCity({String nameOfCountry})async{
 List kCity = [];
 NetWorkHelper netWorkHelper = NetWorkHelper();
 kCity = await netWorkHelper.getCityList(nameOfCountry: nameOfCountry);
 print('this is the all country : $kCity');
 return kCity;
}
Future<List>getAllJob()async{
 List allAField = [];
 NetWorkHelper netWorkHelper = NetWorkHelper();
 allAField = await netWorkHelper.getJobList();
 print('this is the all country : $allAField');
 return allAField;
}