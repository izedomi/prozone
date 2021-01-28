

import 'package:ProZone/data/constants.dart';
import 'package:ProZone/screens/nav_screens/account.dart';
import 'package:ProZone/screens/nav_screens/dashboard.dart';
import 'package:ProZone/screens/nav_screens/providers.dart';
import 'package:ProZone/screens/providers/add_update_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  final int currentTab;
  HomeScreen({this.currentTab});

}

class _HomeScreenState extends State<HomeScreen> {

    int selectedIndex; 
    List<Widget> bottomNavScreens = [];

    Future<bool> _onBackPressed(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text("Exit ProZone\n\nAre you sure?",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
          actions: <Widget>[
            FlatButton(
            //color: Colors.blue,
              textColor: Colors.red,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("CANCEL"),
            ),
            //SizedBox(height: 16),
            FlatButton(
            //color: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
              return true;
            },
            child: Text("YES"),
            ),
          ],
        ),
      ) ?? false;  
    }

    setIndex(int index){
      setState(() {
        selectedIndex = index;
      });
    }
  
  

  @override
  void initState() {
      super.initState();
      selectedIndex = widget.currentTab != null ? widget.currentTab : DASHBOARD_TAB;
  }

  @override
  void dispose() {
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {

    bottomNavScreens.add(Dashboard(setIndex: setIndex));
    bottomNavScreens.add(ProvidersScreen());
    bottomNavScreens.add(AccountScreen());
   
    return WillPopScope(
        onWillPop: selectedIndex != DASHBOARD_TAB  ? () async => false : () => _onBackPressed(context),
        //onWillPop: (){Navigator.pushNamed(context, '/login').; true},
        child: Scaffold(
          body:  bottomNavScreens[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor:Theme.of(context).primaryColor,
            showUnselectedLabels: true,
            selectedFontSize: 13,
            unselectedFontSize: 11,
            elevation: 15.0,
            currentIndex: selectedIndex,
            onTap: (index){
              setState (() => selectedIndex = index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Dashboard"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.transfer_within_a_station),
                label: "Providers"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Account"
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddUpdateProviderScreen())),
            child: Icon(Icons.add, size: 24.0, color: Colors.white),
            backgroundColor: Colors.deepOrange,
            mini: true,
          )
        ),
    );
  }
}
