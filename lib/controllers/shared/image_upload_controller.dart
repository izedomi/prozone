

import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../data/constants.dart';

class ImageUploadController{

    
    Future<Map<String, dynamic>> uploadImagesToServer({File image, String providerId}) async{

        print("uploading filese api called...");
        http.Response response;
        Map<String, dynamic> _res;


        String _baseUrl = PRO_ZONE_BASE_URL+"/upload";

        // Intilize the multipart request
        final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(_baseUrl));

        imageUploadRequest.fields["ref"] = "provider";
        imageUploadRequest.fields["refId"] = providerId.toString();
        imageUploadRequest.fields["field"] = "images";
        imageUploadRequest.headers["Authorization"] = "Bearer $TOKEN";


        // Attach the file in the request
        final imagePath = image.path;

        // Find the mime type of the selected file by looking at the header bytes of the file
        final mimeTypeData =
        lookupMimeType(imagePath, headerBytes: [0xFF, 0xD8]).split('/');

        //create a multipart file
        final file = await http.MultipartFile.fromPath(
          'files', 
          imagePath,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
        );

        //add to our request
        imageUploadRequest.files.add(file);
        
          
        try{

            final streamResponse = await imageUploadRequest.send();
            response = await http.Response.fromStream(streamResponse);

            print("upload selected image response ${response.statusCode}");
            print(response.body.toString());

            var decodedResponse = json.decode(response.body);
            //print(decodedResponse.toString());

            ///successful response
            if(response.statusCode == 200){

                //successful upload
                if(decodedResponse["success"] && decodedResponse["title"] == "success"){
                    _res = decodedResponse;
                    print("UPLOAD RESPONSE0: ${response.body}"); 

                }
                //failed upload
                else{
                    _res = decodedResponse;
                    print("UPLOAD RESPONSE1: "+ response.body); 
                }    
            }
            //failed upload
            else{
                _res = decodedResponse;
                print("UPLOAD RESPONSE2: "+ response.body); 
            } 
            
        }catch (e) {
          // error in calling the API point
            _res = {
                'success': false,
                'title': "Somthing went wrong",
                'message': "We encountered an error while uploading image. Please refresh and try again",  
            }; 
        }
        return _res;

    }

    Future<Map<String, dynamic>> uploadImage({File image, String providerId}) async{

        print("uploading filese api called...");
        http.Response response;
        Map<String, dynamic> _res;


        String _baseUrl = PRO_ZONE_BASE_URL+"/upload";

        // Intilize the multipart request
        final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(_baseUrl));

        
        imageUploadRequest.fields["ref"] = "provider";
        imageUploadRequest.fields["refId"] = providerId.toString();
        imageUploadRequest.fields["field"] = "images";
        imageUploadRequest.headers["Authorization"] = "Bearer $TOKEN";


        // Attach the file in the request
        final imagePath = image.path;

        // Find the mime type of the selected file by looking at the header bytes of the file
        final mimeTypeData =
        lookupMimeType(imagePath, headerBytes: [0xFF, 0xD8]).split('/');

        //create a multipart file
        final file = await http.MultipartFile.fromPath(
          'files', 
          imagePath,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
        );

        //add to our request
        imageUploadRequest.files.add(file);
        
          
        try{

            final streamResponse = await imageUploadRequest.send();
            response = await http.Response.fromStream(streamResponse);

            print("upload selected image response ${response.statusCode}");
            print(response.body.toString());

            var decodedResponse = json.decode(response.body);
            print(decodedResponse.toString());


            ///successful response
            if(response.statusCode == 200){

                _res = {
                  "success": true,
                  "message": "Image Uploaded"
                };

            }
            //failed upload
            else{
              _res = {
                'success': false,
                'title': "Image upload failed",
                'message': "We encountered an error while uploading image. Please refresh and try again",  
            }; 
            } 
            
        }catch (e) {
          // error in calling the API point
            _res = {
                'success': false,
                'title': "Somthing went wrong",
                'message': "We encountered an error while uploading image. Please refresh and try again",  
            }; 
        }
        return _res;

    }


}