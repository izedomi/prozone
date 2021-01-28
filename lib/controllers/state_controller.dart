import 'dart:convert';
import 'package:ProZone/data/constants.dart';
import 'package:ProZone/schemas/state.dart';
import 'package:http/http.dart' as http;


class StateController{


      Map<String, String> _headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $TOKEN',
      };


      Future<Map<String, dynamic>> getStates() async{

        try{

            http.Response response;
            Map<String,dynamic> res;
            List states = List();
    
            response = await http.get("$PRO_ZONE_BASE_URL/states", headers: _headers);

            print('Response status: ${response.statusCode}');
            
            if(response.statusCode == 200){
                
                var content = json.decode(response.body);

                print("uuuuu:" + content.length.toString());

                if(content.length > 0){
                  states  = content.map((e) => State.createState(e)).toList();
                }
              
                res = {
                  'success' : true,
                  'title': "success",
                  'states' : states,
                }; 
                
            }
            else if(response.statusCode == 404){
                res = {
                  'success' : false,
                  'title': "Something went wrong",
                  'message' : "404 error occured. The url resource couldn't be found",
                  'states' : states
                }; 
            }
            else{
              res = json.decode(response.body);
            }
            
            return res;

        }
        catch(error){
            print(error);
            return {
              'success' : false,
              'title': "Something went wrong",
              'message' : "We couldn't connect to the server. please refresh or try again later",
            }; 
        }



    }




        

}