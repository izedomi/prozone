
import 'dart:io';

import 'package:ProZone/controllers/add_update_provider_controller.dart';
import 'package:ProZone/controllers/provider_type_controller.dart';
import 'package:ProZone/controllers/state_controller.dart';
import 'package:ProZone/data/constants.dart';
import 'package:ProZone/data/dropdown_items.dart';
import 'package:ProZone/data/styles.dart';
import 'package:ProZone/schemas/provider.dart';
import 'package:ProZone/screens/background.dart';
import 'package:ProZone/shared/helpers/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddUpdateProviderScreen extends StatefulWidget {

  final ProviderSchema provider;
  AddUpdateProviderScreen({this.provider});
 

  @override
  _AddUpdateProviderScreenState createState() => _AddUpdateProviderScreenState();
}

class _AddUpdateProviderScreenState extends State<AddUpdateProviderScreen> {

    bool isLoading = true;
    String name;
    String address;
    String state;
    String description;
    String rating;
    String status;
    String type;
    double _opacity = 0;

    List providerTypes = List();
    List states = List();
   
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final AddUpdateController addUpdateController = AddUpdateController();
    final ProviderTypeController sc = ProviderTypeController();
    final StateController stateController = StateController();

    
  @override
  void initState() {
    super.initState();
    initializeVars();
    populateDropDownButtons();
  }


  void initializeVars(){
      if(widget.provider == null){
        status = dropdownItemStatusValues[0].value;
        rating = dropdownItemsRating[0].value;
        type = dropdownItemsTypes[0].value;
      }
  }

  
    @override
    Widget build(BuildContext context) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      double deviceWidth = MediaQuery.of(context).size.width;
      double deviceHeight = MediaQuery.of(context).size.height;

      return WillPopScope(
        onWillPop: () async => false,
          child: Scaffold(      
              body: isLoading ? Background() : Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(BACKGROUND_IMAGE),
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop)
                )
              ),   
              height: deviceHeight,
              width: deviceWidth,
              child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[  
                        SizedBox(height: 24,),
                        GestureDetector(
                          child: Platform.isIOS ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back),
                          onTap: () => Navigator.pop(context),
                        ),              
                        SizedBox(height: 24.0),
                        Text(widget.provider == null ? "Add New Provider": "Update Provider", style: textStyleBlack(isTitle: true, size: 20)),
                        SizedBox(height: 2,),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 40,
                          height: 6,
                        ),
                        SizedBox(height: 40.0),
                        buildProviderNameTextField(),
                        SizedBox(height: 16.0,),
                        buildProviderDescriptionTextField(),
                        SizedBox(height: 16.0,),
                        buildProviderAddressTextField(),
                        SizedBox(height: 16.0,),
                        buiildProviderStateDropDownButton(),
                        SizedBox(height: 16.0),
                        buiildProviderStatusDropDownButton(),
                        SizedBox(height: 16.0),
                        buiildProviderRatingDropDownButton(),
                        SizedBox(height: 16.0),
                        buiildProviderTypeDropDownButton(),
                        SizedBox(height: 40.0),
                        buildSubmitButton(),  
                    ]
                ),
                  ),
              ),
              ),
          )
        );
    }

    //fetch list of states and provider types and populate dropdown with retrieved data
    void populateDropDownButtons() async{

        Map<String,dynamic> resTypes = await sc.getProviderTypes();      
        Map<String,dynamic> resStates = await stateController.getStates();


        if(resTypes["success"] && resTypes["title"] == 'success'){

            //clear list
            providerTypes.clear();
            providerTypes = resTypes["providerTypes"];

            //clear dropdown items if any exists
            if(dropdownItemsTypes.length > 1){
                dropdownItemsTypes.removeRange(1, dropdownItemsTypes.length);
            }

            providerTypes.forEach((element) {
              dropdownItemsTypes.add(
                  DropdownMenuItem(
                    child: Text(element.name, overflow: TextOverflow.visible,),
                    value: element.id.toString(),
                  ),
              );
            }); 

        }

        if(resStates["success"] && resStates["title"] == 'success'){

            //clear list
            states.clear();
            states = resStates["states"];

            //clear dropdown items if any exists
            if(dropdownItemsStates.length > 1){
                dropdownItemsStates.removeRange(1, dropdownItemsStates.length);
            }

            states.forEach((element) {
              dropdownItemsStates.add(
                  DropdownMenuItem(
                    child: Text(element.name, overflow: TextOverflow.visible,),
                    value: element.id.toString(),
                  ),
              );
            }); 

        } 

        //display screen widgets if states and provider types was retrieved successfully
        if(states.length > 0 && providerTypes.length > 0){
          if(this.mounted){
            setState(() {
              isLoading = false;
              _opacity = 1;
            });
          }
        }
    }


    submit() async{

      //if inputs has error
      if(validateInput()) return;

      setState(() => isLoading = true);

      _formKey.currentState.save();

      Map<String, dynamic> provider = {
          "name" : name,
          "address": address,
          "description" : description,
          "state": state == null && widget.provider != null ? widget.provider.state["name"] : state,
          "rating": rating == null && widget.provider != null ? int.parse(widget.provider.rating) : int.parse(rating),
          "activeStatus": status == null && widget.provider != null ? widget.provider.activeStatus : status,
          "providerType": type == null  && widget.provider != null ? widget.provider.providerType["name"] : type
      };


      print(provider.toString());
      
      
      try{

          Map<String,dynamic> res;

          res = widget.provider == null ?
          await addUpdateController.addUpdateProvider(provider) :
          await addUpdateController.addUpdateProvider(provider, id: widget.provider.id);
                    
          if(res["success"] && res["title"] == 'success'){
              
              displayDialog(
                context:context,
                heading: "Success!",
                body: widget.provider == null ? "New Provider Added!" : "Provider Updated!",
                type:"success",
                navigateTo: '/home'
              );     

          }
          else{
             
               displayDialog(
                  context:context,
                  heading:"Encountered an error",
                  body: "Something went wrong. Please try agian.",
                  type:"error",
                );  
          }
      }
      catch(e){
          displayDialog(
            context:context,
            heading:"Server error!",
            body: "Something went wrong. Please try agian.",
            type:"error",
          );  
      }
       
      setState(() => isLoading = false);
    }

    
    bool validateInput(){

        //validates textfields
        if(!_formKey.currentState.validate()){
          return true;
        }

        print(status);
        print(status == null && widget.provider != null);
        
        //if action is editing and user didn't make any change to the status dropdown
        //i.e(status == null), don't validate instead use the existing status value
        //i.e(status = widget.provider.status)
        if(!(status == null && widget.provider != null)){
            if(status == null || status.isEmpty || status.length < 0){
              showErrorDialog(context, "Provider status is required");
              return true;
            }
        }

        //if action is editing and user didn't make any change to the provider type dropdown
        //i.e(type == null), don't validate instead use the existing type value
        //i.e(type = widget.provider.providerType["name"])
        if(!(type == null && widget.provider != null)){
            if(type == null || type.isEmpty || type.length < 0){
              showErrorDialog(context, "Provider type is required");
              return true;
            }
        }

         //if action is editing and user didn't make any change to the provider state dropdown
        //i.e(state == null), don't validate instead use the existing state value
        //i.e(state = widget.provider.state["name"])
        if(!(state == null && widget.provider != null)){
            if(state == null || state.isEmpty || state.length < 0){
              showErrorDialog(context, "Provider state is required");
              return true;
            }
        }

        //if action is editing and user didn't make any change to the rating dropdown
        //i.e(rating == null), don't validate instead use the existing rating value
        //i.e(rating = widget.provider.status)
        if(!(rating == null && widget.provider != null)){
          if(rating == null || rating.isEmpty || rating.length < 0){
            showErrorDialog(context, "Provider rating is required");
            return true;
          }
        }
       
        return false;

    }

    showErrorDialog(BuildContext context, String msg) async{
       displayDialog(
          context: context,
          heading: msg,
          body: "Please complete the necesary fields",
          type: "error"
        );
    }

    Widget buildProviderNameTextField(){
        return Container(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "Provider Name",
              labelStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2),
            ),
            //onChanged: (value) => setState(() => name = value),
            onSaved: (value) => setState(() => name = value),
            validator: (String value){
                  if(value.isEmpty || value.trim().length < 1){
                    return "Provider name is required";
                  }
                  return null;
            },
            initialValue: widget.provider == null ? '' : widget.provider.name,
          ),
        );
    }

    Widget buildProviderDescriptionTextField(){
            return Container(
                            //height: 40.0,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2),
                ),
                onSaved: (value) => setState(() => description = value),
                initialValue: widget.provider == null ? '' : widget.provider.description,
              ),
            );
    }
   
    Widget buildProviderAddressTextField(){
          return Container(
                          //height: 40.0,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Address",
                labelStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2),
              ),
              onSaved: (value) =>  setState(() => address = value),
              validator: (String value){
                  if(value.isEmpty || value.trim().length < 1){
                    return "Provider address is required";
                  }
                  return null;
              },
              initialValue: widget.provider == null ? '' : widget.provider.address,
            ),
          );
    }

    Widget buiildProviderStatusDropDownButton(){

          return Container(
              width: double.infinity,
              height: 50.0,
              child: DropdownButton(
              hint: Text(widget.provider == null ? 'Select Provider Status' : widget.provider.activeStatus),
              items: dropdownItemStatusValues,
              value: status,
              onChanged: (dynamic value){
                 setState(() => status = value);
              },
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400
                ),
              )
          );
    }

    Widget buiildProviderRatingDropDownButton(){

          return Container(
              width: double.infinity,
              height: 50.0,
              child: DropdownButton(
              hint: Text(widget.provider == null ? 'Select Rating' : widget.provider.rating),
              items: dropdownItemsRating,
              onChanged: (dynamic value){
                  setState(() => rating = value);
              },
              value: rating,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400
                ),
              )
          );
          
    }

    Widget buiildProviderStateDropDownButton(){

          return Container(
              width: double.infinity,
              height: 50.0,
              child: DropdownButton(
              hint: Text(widget.provider == null ? 'Select State' : widget.provider.state["name"]),
              items: dropdownItemsStates,
              onChanged: (dynamic value){
                 setState(() => state = value);
              },
              value: state,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400
                ),
              )
          );   
    }
    
    Widget buiildProviderTypeDropDownButton(){

          return Container(
              width: double.infinity,
              height: 50.0,
              child: DropdownButton(
              hint: Text(widget.provider == null ? 'Select State' : widget.provider.providerType["name"]),
              items: dropdownItemsTypes,
              onChanged: (dynamic value){
                setState(() => type = value);
              },
              value: type,
               style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400
                ),
              
              )
          );
    }

    Widget buildSubmitButton(){
        return Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: GestureDetector(
                //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())),
                onTap: () => submit(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuad,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal:24, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50.0,
                      child: isLoading ? 
                      Row(
                        children: <Widget>[                        
                          CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),
                          SizedBox(width: 8,),
                          Text(widget.provider == null ? "Adding..." : "Updating...", style: textStyleWhite(isTitle:true),),
                        ],
                      ) :
                      Row(
                        children: <Widget>[
                          Text(widget.provider == null ? "Add provider" : "Update Provider", style: textStyleBlack(isTitle: true, size: 18.0, color: Colors.white)),
                          SizedBox(width: 8,),
                          Platform.isIOS ? Icon(Icons.arrow_forward_ios, color: Colors.white,) : Icon(Icons.arrow_forward, color: Colors.white,),
                          //Icon(Icons.arrow_forward, color: Colors.white,)
                        ],
                      ),
                    ),
                    
                  ],
                ),
            ),
          );
      }

}

