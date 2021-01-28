
import 'package:ProZone/controllers/nav_screens/providers_controller.dart';
import 'package:ProZone/controllers/shared/sort_tab_setting_controller.dart';
import 'package:ProZone/data/styles.dart';
import 'package:ProZone/schemas/provider.dart';
import 'package:ProZone/screens/providers/add_update_provider.dart';
import 'package:ProZone/screens/background.dart';
import 'package:ProZone/screens/providers/provider_details.dart';
import 'package:ProZone/shared/widgets/add_provider_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';


class ProvidersScreen extends StatefulWidget {
  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {

  
    bool isLoading = true;
    double _opacity = 0;
    List providers = List();
    List filteredProvidersList = List();
    ProviderController sc = ProviderController();
 
  
    @override
    void initState() {
      super.initState();
      getProviders();
    }

    void getProviders() async{

        Map<String,dynamic> res = await sc.getProviders();

        if(res["success"] && res["title"] == 'success'){

            setState(() {
                providers = res["providers"];
                filteredProvidersList = providers;
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


    Widget _buildCategoryPanel(SortingTabSetting sts, String title, {bool isActive = false}){
      return  GestureDetector(
          onTap: (){
              sts.setCurrentProviderTab(title);
              sortProviders(title);
          },
          child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutQuad,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,   
          decoration: sts.getCurrentProviderTab == title  ? BoxDecoration(
            color: sts.getCurrentProviderTab == title ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(sts.getCurrentProviderTab == title ? 25 : 0),
            boxShadow: [
            ]
          ) : BoxDecoration(),
          child: Text(title, style: textStyleWhite(isTitle: true, color: sts.getCurrentProviderTab == title ? Colors.white : Theme.of(context).accentColor)),
        ),
      );
    }

    //bottom sheet modal
    Future<bool> _showBSModal(ProviderSchema provider){

        return showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          useRootNavigator: true,
          isDismissible: false,
          //barrierColor: Colors.cyan,
          enableDrag: true,
          bounce: true,
          duration: Duration(milliseconds: 600),
          backgroundColor: Colors.yellow,
          builder: (context, scrollController) => ProviderDetails(provider)
        );
    }


    sortProviders(String query){
        
        print(query);
        
        if(query == "ALL"){
          setState(() => filteredProvidersList = providers);
        }
        else{
          setState(
            () => filteredProvidersList = providers.where((element) => element.activeStatus.toLowerCase() == query.toLowerCase()).toList()
          );
        }

        print(filteredProvidersList);
   
    }

    filterProviders(query){
        print(query);
        if(query.trim().length == 0){
            setState(() {
              filteredProvidersList.clear();
              filteredProvidersList = providers;
            });
        }
        else{

          var ls = filteredProvidersList.where((provider){
            return provider.state["name"].toLowerCase().contains(query.toLowerCase()) || provider.name.toLowerCase().contains(query.toLowerCase()) ;
          }).toList();
          setState(() {
            filteredProvidersList = ls;
          });
        }

    }

  
  @override
  Widget build(BuildContext context) {
    SortingTabSetting sts = Provider.of<SortingTabSetting>(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
      return  isLoading ? Background() : AnimatedOpacity(
            duration: Duration(milliseconds: 1500),
            opacity: _opacity,
            child: SingleChildScrollView(
              child: Column(
              children: <Widget>[        
                Container(
                  width: deviceWidth,
                  height: deviceHeight / 8.0,
                  //alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/hmo.png'),
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop)
                    ),
                    color: Theme.of(context).primaryColor,
                    //color: Color(0xfff4f4f4),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.transfer_within_a_station, size: 36.0, color: Colors.white,),
                      //FaIcon(FontAwesomeIcons.transgender),
                      SizedBox(width: 20.0),
                      Text("ProZone Providers", style: textStyleWhite(isTitle: true, size: 18))
                    ],
                  ),
                ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      labelText: "Search by name/location",
                      suffixIcon: GestureDetector(
                          onTap: (){
                            
                          },
                          child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                          child: Icon(Icons.search)
                        ),
                      ),
                  ),
                  onChanged: (value) => filterProviders(value),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 45.0,
                //color: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
                //margin: EdgeInsets.only(left: 14, right: 14),
                width: deviceWidth,
                child: Row(
                  //physics: BouncingScrollPhysics(),
                  //scrollDirection: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildCategoryPanel(sts, "ALL", isActive: true),
                    _buildCategoryPanel(sts, "ACTIVE"),
                    _buildCategoryPanel(sts, "PENDING"),
                    _buildCategoryPanel(sts, "DELETED"),
                  ],
                ),
              ),
                Container(
                height: deviceHeight - 50,
               // margin: EdgeInsets.only(bottom: deviceHeight - 60),
                padding: EdgeInsets.only(bottom: 50),
                child: ListView.builder(              
                  physics: BouncingScrollPhysics(),
                  itemCount: filteredProvidersList.length,
                  itemBuilder: (BuildContext context, int index){
                    
                    ProviderSchema provider = filteredProvidersList[index];
                    Color statusColor;
              
                    if(provider.activeStatus == "Active"){
                      statusColor = Theme.of(context).primaryColor;
                    }
                    if(provider.activeStatus == "Pending"){
                      statusColor = Theme.of(context).accentColor;
                    }
                    if(provider.activeStatus == "Deleted"){
                      statusColor = Colors.red;
                    }

                    return Container(
                      margin: EdgeInsets.only(left: 15, top: 15.0, right: 15.0, bottom: 8.0),
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
                      alignment: Alignment.center,   
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                            BoxShadow(color: Colors.black12, offset: Offset(0,0), blurRadius: 3.0)
                        ],
                        //borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(provider.name, style: textStyleBlack(isTitle: true, size: 14.0, color: Colors.black)),
                                SizedBox(width: 3.0),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal:2, vertical:1),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  child: Text(
                                    provider.activeStatus, 
                                    style: textStyleWhite(size: 10, isTitle: true),),
                                )
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Text("${provider.providerType["name"]} | ${provider.state["name"]}", style: textStyleBlack(isTitle: true, size: 14.0, color: Colors.grey))
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){_showBSModal(provider);},
                                  child: Icon(Icons.info_outline, size: 24.0, color: Colors.orange,)
                                ),
                                SizedBox(width: 30.0),
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddUpdateProviderScreen(provider: provider,))),
                                  child: Icon(Icons.edit, size: 24.0, color: Colors.orange,)
                                ),
                                SizedBox(width: 30.0),
                                ProviderImageUpload(provider.id)
                              ],
                            ),
                            
                          ],
                        ),
                      )
                    );
                  }
                ),
              )
          ],
        ),
            ),
      );

  }
}