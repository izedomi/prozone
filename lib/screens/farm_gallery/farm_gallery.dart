

import 'dart:io';

import 'package:ProZone/data/constants.dart';
import 'package:ProZone/data/styles.dart';
import 'package:ProZone/screens/farm_gallery/single_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DashboardMenu{
    Widget networkImage;
    String imagePath;
    String key;
    DashboardMenu(
      {@required this.networkImage, @required this.imagePath, @required this.key}
    );
}


class FarmGalleryScreen extends StatefulWidget {

   final List galleryImages;
   FarmGalleryScreen({this.galleryImages});

  @override
  _FarmGalleryScreenState createState() => _FarmGalleryScreenState();
}

class _FarmGalleryScreenState extends State<FarmGalleryScreen> {


    @override
    void initState() {
      super.initState();
    }

  List<DashboardMenu> dashboardMenu() {

      List<DashboardMenu> menu = List<DashboardMenu>();

      widget.galleryImages.forEach((element) {
          menu.add(
            DashboardMenu(
                networkImage: FadeInImage(
                  placeholder: AssetImage(BACKGROUND_IMAGE),
                  image: NetworkImage(element["url"]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                imagePath: element["url"],
                key: element["hash"]
            ),
           
          );
      });


      return menu;
  }

  Widget _buildGridView(DashboardMenu menuItem) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SingleImageScreen(
            menuItem.imagePath,
            menuItem.key
          )
        )
      ),
      child: Container(
          margin: EdgeInsets.all(3.0),
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Hero(
              tag: menuItem.key,
              child: menuItem.networkImage
            ),
          ),
      )
    );
  }


  @override
  Widget build(BuildContext context){

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                Container(
                width: deviceWidth,
                height: deviceHeight / 8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    image: DecorationImage(
                      image: AssetImage(BACKGROUND_IMAGE),
                      repeat: ImageRepeat.noRepeat,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop)
                    ),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(60.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 6.0, color: Colors.black12)
                    ]
                ),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: Platform.isIOS ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                        children: <Widget>[
                          Platform.isIOS ? Icon(Icons.arrow_back_ios, color: Colors.white,): Container(),
                          Platform.isIOS ? SizedBox(height: 16.0,) : Container(), 
                          Text("Gallery", style: textStyleWhite(isTitle: true, size: 20)),
                        ],
                      ),
                    ), 
                  ),
              SizedBox(height: 10.0),
              Container(
                height: deviceHeight - 16,
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 3.0, right: 3.0, bottom: 3.0),
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 3,
                  children:
                      List.generate(dashboardMenu().length, (index) {
                      return _buildGridView(dashboardMenu()[index]);
                    }
                  )
                ),
              ),
              
            ],
          )
        )
    );
}

}