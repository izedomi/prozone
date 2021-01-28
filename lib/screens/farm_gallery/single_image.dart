

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SingleImageScreen extends StatelessWidget {

    final String imagePath;
    final String id;
    SingleImageScreen(this.imagePath, this.id);

    @override
    Widget build(BuildContext context){

        double deviceWidth = MediaQuery.of(context).size.width;
        double deviceHeight = MediaQuery.of(context).size.height;

        return Scaffold(
            body: Container(
              height: deviceHeight,
              width: deviceWidth,
              child: Hero(
                  tag: id,
                  child: Image(
                  image: NetworkImage(imagePath),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover
                ),
              ),
            )
        );
    }

}
