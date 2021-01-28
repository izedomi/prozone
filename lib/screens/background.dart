import 'dart:async';

import 'package:ProZone/data/constants.dart';
import 'package:ProZone/data/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  

  Timer timer;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds:900), (Timer t){
      print("printing");
      _opacity == 1 ? setState(() => _opacity = 0) :  setState(() => _opacity = 1);
     
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfffcfcfc),
      //color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //CupertinoActivityIndicator(radius: 20),
          SizedBox(height: 3.0,),
          AnimatedOpacity(
              duration: Duration(milliseconds: 1000),
              opacity: _opacity,
              curve: Curves.easeInOut,
              child: Column(             
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage(BACKGROUND_IMAGE),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text("Loading...", style: textStyleWhite(isTitle:true, color: Colors.black54),)
                ],
              ),
          )
        ],
      ),
    );
    
  }
}