
import 'package:ProZone/data/styles.dart';
import 'package:ProZone/schemas/provider.dart';
import 'package:ProZone/screens/farm_gallery/farm_gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderDetails extends StatelessWidget {
  
   final ProviderSchema provider;
   ProviderDetails(this.provider);


   Widget buildDetailsCard(BuildContext context, IconData icon, String title, String subTitle){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 10, 
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      icon == null ? Container() : Icon(icon, color: Colors.deepOrange,),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(title, style:textStyleBlack(isTitle: true, size: 12.0, color: Colors.black54)),
                          SizedBox(height: 5.0,),
                          Text(subTitle, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blue),),
                        ],
                      )
                    ]
                  ),
                  SizedBox(height: 20.0,),
                ],
              )
            ),
            // Expanded(flex: 4, child: buildDetailsCard(context, Icons.account_box, "Amount", "N120,000"))
          ],
        );
  }

  
  @override
  Widget build(BuildContext context) {

     double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: deviceWidth,
                      height: deviceHeight / 4.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80.0)),
                          child:FadeInImage(
                                placeholder: AssetImage("assets/images/luxA.jpg"),
                                image: provider.images.length > 0 ? NetworkImage(provider.images[0]["url"]) : AssetImage("assets/images/luxA.jpg"),
                                width: 85,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                      )
                    ),
                    Container(
                      width: deviceWidth,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        //borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: deviceWidth - 50,       
                                child: Text(
                                provider.name,
                                style: textStyleBlack(isTitle: true, size: 14.0, color: Colors.white),
                                overflow: TextOverflow.visible,
                              ),
                            ), 
                            GestureDetector(
                                onTap: ()=> Navigator.pop(context),
                                child: Container(
                                width: 20,
                                height: 20,   
                                decoration: BoxDecoration(
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),                      
                                child: Icon(Icons.close, color: Colors.black, size: 14.0)
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
  
                  ],
                ),
                SizedBox(height: 24.0,),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         buildDetailsCard(context, Icons.book, "Provider", provider.name),
                         buildDetailsCard(context, Icons.book, "Type",  provider.providerType["name"]),
                         buildDetailsCard(context, Icons.book, "Address",  provider.address),
                         buildDetailsCard(context, Icons.book, "state",  provider.state["name"]),
                         buildDetailsCard(context, Icons.book, "Status",  provider.activeStatus),
                         buildDetailsCard(context, Icons.book, "Rating",  provider.rating),
                         buildDetailsCard(context, Icons.book, "Image(s)",  provider.images.length.toString()),
                         buildDetailsCard(context, Icons.book, "Description",  provider.address),
                         provider.images.length > 0 ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RaisedButton(
                             color: Theme.of(context).primaryColor,
                             textColor: Colors.white,
                             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FarmGalleryScreen(galleryImages: provider.images))), 
                             child: Text(provider.images.length > 1 ? "View Images (${provider.images.length})" : "View Image (${provider.images.length})")
                            ),
                         ): SizedBox()
                      ]
                  ),
                ),
              ],
            ),

        ),
      );
  }
}