
import 'package:ProZone/controllers/nav_screens/providers_controller.dart';
import 'package:ProZone/controllers/provider_type_controller.dart';
import 'package:ProZone/controllers/state_controller.dart';
import 'package:ProZone/data/constants.dart';
import 'package:ProZone/data/styles.dart';
import 'package:ProZone/schemas/provider_type.dart';
import 'package:ProZone/shared/widgets/profile_image_upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../background.dart';

class Dashboard extends StatefulWidget {

  final Function setIndex;
  Dashboard({this.setIndex});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


    bool isLoading = true;
    double _opacity = 0;
    List providers = List();
    List providerTypes = List();
    List states = List();
    List filteredProvidersList = List();
    ProviderController sc = ProviderController();
    ProviderTypeController ptc = ProviderTypeController();
    StateController stateController = StateController();

    int activeProviders;
    int pendingProviders;
    int deletedProviders;


    @override
    void initState() {
      super.initState();

      getProviderTypes();
      getProviders();

    }

    void getProviders() async{

        Map<String,dynamic> res = await sc.getProviders();

        if(res["success"] && res["title"] == 'success'){

            setState(() {
                providers = res["providers"];
                filteredProvidersList = providers;
                //isLoading = false;
            });

            var activeProvidersList = providers.where(
              (element) => element.activeStatus.toLowerCase() == "active")
              .toList();
            
            var pendingProvidersList = providers.where(
              (element) => element.activeStatus.toLowerCase() == "pending")
              .toList();

            var deletedProvidersList = providers.where(
              (element) => element.activeStatus.toLowerCase() == "deleted")
              .toList();

            activeProviders = activeProvidersList.length;
            pendingProviders = pendingProvidersList.length;
            deletedProviders = deletedProvidersList.length;


            Future.delayed(Duration(milliseconds: 100), (){
                 setState(() {
                   _opacity = 1;
                });
            });
           
        }
       
    }

    void getProviderTypes() async{

        
        Map<String,dynamic> res = await ptc.getProviderTypes();

        if(res["success"] && res["title"] == 'success'){

            setState(() {
                providerTypes = res["providerTypes"];
                isLoading = false;
            });  

            Future.delayed(Duration(milliseconds: 100), (){
                 setState(() {
                   _opacity = 1;
                });
            });
            
        }
       
        print(res.toString());
    }

    @override
    Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return isLoading ? Background(): AnimatedOpacity(
            duration: Duration(milliseconds: 1500),
            opacity: _opacity,
            child: SingleChildScrollView(
            child: Column(
            children: <Widget>[
              Stack(
                    children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                      width: double.infinity,

                      height: MediaQuery.of(context).size.height / 4.5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(BACKGROUND_IMAGE),
                            repeat: ImageRepeat.noRepeat,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop)
                          ),
                          //color: Colors.green,
                          color: Theme.of(context).primaryColor,
                          
                      ),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        ProfileImageUpload(),
                        SizedBox(width: 8.0,),
                        Container(
                          //width: 275.0,
                          padding: EdgeInsets.only(top:12),
                          child: Text(
                            "Hello, Emmanuel",
                            overflow: TextOverflow.ellipsis,
                            style: textStyleBlack(isTitle: true, size: 14.0, color: Colors.white),
                          )
                        )
                        ]
                      )
                    ),
                    Container(
                          margin: EdgeInsets.only(top: deviceHeight / 6.0, left: 30.0, right: 30.0, bottom: 16.0),
                          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
                          width: deviceWidth - 60,
                          //height: 360,
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(-1,2),
                                blurRadius: 6.0
                              )
                            ]
                          ),
                          child: Column(
                            children: <Widget>[
                            Row(   
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,              
                                children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                      Text("Total Providers", style: textStyleBlack(isTitle: true, size: 14.0, color: Colors.black54)),
                                      SizedBox(height: 3.0),
                                      Row(
                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                            isLoading ? Container(child: Center(child: CupertinoActivityIndicator(radius: 10,))) : 
                                            Text(providers.length.toString(), style: textStyleBlack(isTitle: true, size: 30, color: Theme.of(context).primaryColor))
                                        ],
                                      )
                                      
                                      ],
                                    ),
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 8.0, offset: Offset(0,0), color: Colors.black12, spreadRadius:3)
                      ],
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.moneyBillWave,
                      size: 24.0,
                      color: Colors.grey,
                    ),
                                    )
                                ]
                    ),
                    Divider(height: 25.0, color: Colors.grey, thickness: 2.0,),
                    Row(   
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,              
                          children: [
                                  
                              Expanded(
                                  flex: 4,
                      child: GestureDetector(
                          onTap: () => widget.setIndex(2),
                          child: Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "$activeProviders Active | ",
                                style: textStyleBlack(isTitle:true, size: 10, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "$pendingProviders Pending | ",
                                style: textStyleBlack(isTitle:true, size: 10, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "$deletedProviders deleted ",
                                style: textStyleBlack(isTitle:true, size: 10, color: Theme.of(context).primaryColor),
                              ),
                    ],
                                    ),
                        ),
                      ),
                                  )
                                ]
                              ),
                            ],
                          ),
                      ),
                  ],
              ),
              SizedBox(height: 10.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Provider Types (${providerTypes.length})",
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () => widget.setIndex(1),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(25.0)
                            ),
                            child: Row(children: <Widget>[
                              Text(
                                "See All",
                                style: textStyleBlack(isTitle:true, size: 10, color: Colors.white),
                              ),
                              SizedBox(width: 3.0),
                              FaIcon(
                                FontAwesomeIcons.arrowAltCircleRight,
                                size: 12.0,
                                color: Colors.white,
                              )
                            ],
                          ),
                          ),
                      ),
                    ],
                  ),
              ),
              Container(
              height: deviceHeight - 275,
              padding: EdgeInsets.only(right: 10.0, bottom: 8.0, left: 10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: providerTypes.length,
                itemBuilder: (BuildContext context, int index){
                  
                  ProviderType providerType = providerTypes[index];

                  return Container(
                    padding: EdgeInsets.only(top: 6.0, left: 16.0, right: 16.0, bottom: 12.0),
                    margin: EdgeInsets.only(bottom: 12),
                    width: deviceWidth - 50,
                    //height: 360,
                   
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(   
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                            crossAxisAlignment: CrossAxisAlignment.center,            
                            children: [
                                Icon(Icons.arrow_forward_ios, size: 16.0, color: Theme.of(context).primaryColor),
                                SizedBox(width: 10.0),
                                Text(providerType.name, style: textStyleBlack(isTitle:true, color: Colors.grey),), 
                            ]
                          ),
                          
                        ],
                      ),
                  );
                }
              )
            ),
            
              
            ],
              ),
        ),
      );
  }
}