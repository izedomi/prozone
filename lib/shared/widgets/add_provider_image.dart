import 'dart:io';

import 'package:ProZone/controllers/shared/image_upload_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProviderImageUpload extends StatefulWidget {

  final String id;
  ProviderImageUpload(this.id);

  @override
  _ProviderImageUploadState createState() => _ProviderImageUploadState();
}

class _ProviderImageUploadState extends State<ProviderImageUpload> {

    List selectedImageList = List();
    void openImagePicker(BuildContext context){
      
      
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        height: 200.0,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 1.0),
        child: Column(
          children: <Widget>[
              Text("Add Image", style: TextStyle(fontWeight: FontWeight.bold),),
               SizedBox(height: 10.0),
               FlatButton(
                 child: Text("Use Camera", style: TextStyle(color: Theme.of(context).primaryColor),),
                 onPressed: (){
                   getImage(context, ImageSource.camera);
                 },
               ),
               FlatButton(
                 child: Text("Use Gallery", style: TextStyle(color: Theme.of(context).primaryColor),),
                 onPressed: (){
                   getImage(context, ImageSource.gallery);
                 },
               ),
         
          ],
        )
      );
    });

    //showAlertDialog(context);
    
   
  }


  showAlertDialog(BuildContext context, String title, String content, bool isSubmiting) {

      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () => Navigator.of(context).pop()
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: isSubmiting ? Container(
          child:Center(child: CircularProgressIndicator()),
          width: 45,
          height: 45,
        ): Text(content),
        actions: [
          isSubmiting ? Container() : okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

 

  void getImage(BuildContext context, ImageSource imageSource) async {

      var image;
      if(imageSource == ImageSource.camera){
        image = await ImagePicker().getImage(
          source: imageSource, imageQuality: 60
        );
      }
      else{
        image = await ImagePicker().getImage(
          source: imageSource, imageQuality: 60
        );
      }

      if(image != null){ 
        Navigator.pop(context);  //remove bottom sheet
        uploadSelectImage(image);
      }

      
  }


  uploadSelectImage(var image) async{

      //add dialog for image processing
      showAlertDialog(context, "Uploading image", "Please wait", true); 

      Map<String, dynamic> response;

      //initiate uploading image
      ImageUploadController imageUploader = ImageUploadController();

      //selectedImageList.add(File(image.path));
      response = await imageUploader.uploadImage(image: File(image.path), providerId: widget.id);

      if(response != null){

          //remove image processing dialog
          Navigator.pop(context);  

          //image uploaded successfully
          if(response["success"]){  
            
              //add dialog for successful upload
              showAlertDialog(context, "Success", "Image Added", false); 
          }
      }
     
  }

  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
       onTap: () => openImagePicker(context),
        child: Icon(Icons.camera_alt, size: 24.0, color: Colors.orange,),
    );
  }
}