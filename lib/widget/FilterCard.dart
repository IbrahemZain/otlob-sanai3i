import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sanai3i/constantTheme.dart';
import 'package:sanai3i/providers/networking.dart';
import '../size.dart';
import '../mainScreens/profilePage.dart';
import 'package:http/http.dart' as http;

class FilterCard extends StatelessWidget {
  final int index;
  final String san3a;
  final List<dynamic> allData;

  FilterCard(this.index, this.san3a, this.allData);

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);

    return GestureDetector(
      onTap: () {
        NetWorkHelper netWorkHelper = NetWorkHelper();
        var url = netWorkHelper.getUrlAddress();
        http.post(
          '${url}general/IncreaseView',
          body: {"Id":allData[index]['technician']['_id']},
        );
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => ProfilePage(isUser: false,index: index,mvUsers: allData,))));
        return;
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: _deviceWidth*.05,vertical: _deviceHeight*.01),

          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: -5,
                  blurRadius: 5,
                  offset: Offset(0, 13), // changes position of shadow
                ),
              ],

              color: KMainColor,
              //borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: Colors.black,width: 1)
          ),
          width: _deviceWidth * .31,
          height: _deviceHeight * .1,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: _deviceHeight * .005,
                right: _deviceWidth*.06,
                child: Text(
                  allData[index]['technician']['name'],
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),Positioned(
                top: _deviceHeight * .04,
                right: _deviceWidth*.06,
                child: Text(allData[index]['technician']['city']
                  ,
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),
              Positioned(
                top: _deviceHeight * .068,
                right: _deviceWidth*.06,
                child: Text(
                  allData[index]['technician']['field'],
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),

              Positioned(
                top: _deviceHeight*.0003,
                right: _deviceWidth*.5,
                left: _deviceWidth*.001,
                bottom: _deviceHeight*.001,
                child: Container(

                  //height: _deviceHeight,
                  decoration: BoxDecoration(

                      color: Colors.black,
                     // borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20.0),topLeft:Radius.circular(20.0)  ),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              allData[index]['technician']['photo']
                          ),
                      )
                  ),

                ),
              ),

              // Positioned(
              //   top: _deviceHeight * .04,
              //   child: Image(
              //     image: FileImage(allData[index]['photo']),
              //     width: _deviceWidth * .299,
              //     height: _deviceHeight * .1,
              //     fit: BoxFit.fill,
              //   ),
              // ),


            ],
          )),

    );
  }
}
