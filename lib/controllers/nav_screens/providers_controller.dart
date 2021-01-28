import 'dart:convert';
import 'package:ProZone/schemas/provider.dart';
import 'package:http/http.dart' as http;
import '../../data/constants.dart';


class ProviderController{

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $TOKEN',
    };


    Future<Map<String, dynamic>> getProviders() async{
       
      try{

          http.Response response;
          Map<String,dynamic> res;
          List providers = List();
  
          response = await http.get("$PRO_ZONE_BASE_URL/providers", headers: _headers);

          print('Response status: ${response.statusCode}');
         
          if(response.statusCode == 200){
              
              var content = json.decode(response.body);

              print("uuuuu:" + content.length.toString());

              if(content.length > 0){
                 providers  = content.map((e) => ProviderSchema.createProvider(e)).toList();
              }
             
              res = {
                'success' : true,
                'title': "success",
                'providers' : providers,
              }; 

          }
          else if(response.statusCode == 404){
              res = {
                'success' : false,
                'title': "Something went wrong",
                'message' : "404 error occured. The url resource couldn't be found",
                'providers' : providers
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