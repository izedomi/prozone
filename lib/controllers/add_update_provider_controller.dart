
import 'dart:convert';
import 'package:ProZone/data/constants.dart';
import 'package:http/http.dart' as http;


class AddUpdateController{

  Future<Map<String,dynamic>> addUpdateProvider(Map<String,dynamic> data, {String id}) async{


    http.Response response;
    Map<String, dynamic> _res = {};

    try{

      var headers = {
        'Authorization': 'Bearer $TOKEN',
      };

      var payload =  json.encode({
        "name": data["name"],
        "description": data["description"],
        "rating": data["rating"],
        "address": data["address"],
        "active_status": data["activeStatus"],
        "provider_type": data["providerType"],
        "state": data["state"],
      });
 
      response = id == null ? 
      await http.post("$PRO_ZONE_BASE_URL/providers", body: payload,headers: headers) :
      await http.put("$PRO_ZONE_BASE_URL/providers/$id", body: payload,headers: headers);

      //successful call
      if(response.statusCode == 200){
        print("UPLOAD RESPONSE: ${response.body}");
        _res = {
          'success': true,
          'title': "success",
          'msg': id == null ? "Provider added successfully" : "Product updated successfully"
        };

      }
      //failed call
      else{
      
        _res = {
          'success': false,
          'title': "failed",
          'msg': "Sorry! Operation couldn't be completed"
        };
      }

    }
    catch(e){

      print(e.toString());
      _res = {
        'success': false,
        'title': "failed",
        'msg': "Ooops..system couldn't complete action.Please try again"
      };

    }
    return _res;

  }

}