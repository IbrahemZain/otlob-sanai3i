import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../constantTheme.dart';
import '../size.dart';
import '../mainScreens/profilePage.dart';

class UpperCard extends StatelessWidget {
  final int index;
  final List<dynamic> mvUsers;
  UpperCard(this.index, this.mvUsers);

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProfilePage(
                      isUser: false,
                      index: index,
                      mvUsers: mvUsers,
                    ))));
        return;
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: _deviceWidth * .01),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[],
              color: KMainColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              border: Border.all(color: Colors.teal)),
          width: _deviceWidth * .31,
          height: _deviceHeight * .05,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: _deviceHeight * .008,
                right: _deviceWidth * .02,
                //left:_deviceWidth*.01,
                child: Text(
                  mvUsers[index]['technician']['name'].toString(),
                  maxLines: 2,
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),
              Positioned(
                top: _deviceHeight * .035,
                right: _deviceWidth * .02,
                child: Text(
                  mvUsers[index]['technician']['field'].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Positioned(
                top: _deviceHeight * .07,
                right: 0,
                left: 0,
                bottom: .002,
                child: Container(
                  //height: _deviceHeight,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      // borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(15.0),
                      //     bottomRight: Radius.circular(15.0)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(mvUsers[index]['technician']['photo']))),
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
