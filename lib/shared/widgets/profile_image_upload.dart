import 'dart:io';

import 'package:ProZone/controllers/shared/image_upload_controller.dart';
import 'package:ProZone/data/constants.dart';
import 'package:ProZone/shared/helpers/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';


class ProfileImageUpload extends StatefulWidget {

  @override
  _ProfileImageUploadState createState() => _ProfileImageUploadState();
}

class _ProfileImageUploadState extends State<ProfileImageUpload> {

  List selectedImageList = List();
  void openImagePicker(BuildContext context){
  
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Choose an option'),
          //message: const Text(''),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                 getImage(context, ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
               getImage(context, ImageSource.gallery);
              },
            )
          ],
          ),
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
        uploadSelectImage(image);
      }

      Navigator.pop(context);
  }


  uploadSelectImage(var image) async{

      //display loading modal
      displayDialog(
          context: context,
          heading: "Updating profile photo",
          body: "Please wait",
          type: "info"
      );

      Map<String, dynamic> response;

      //initiate uploading image
      ImageUploadController imageUploader = ImageUploadController();
      //selectedImageList.add(File(image.path));
      response = await imageUploader.uploadImagesToServer(image: File(image.path));

      if(response != null){

        Navigator.pop(context);  //remove modal

        //image uploaded successfully
        if(response["success"]){
            setState(() => authenticatedUser.imagePath = response["data"]); 
        }

      }
     
  }

  @override
  Widget build(BuildContext context) {

    return  Container(
      height: 45,
      width: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white, 
        boxShadow: authenticatedUser.imagePath != null ? [] : [
          BoxShadow(blurRadius: 8.0, offset: Offset(0,0), color: Colors.black26, spreadRadius:3)
        ],
        borderRadius: BorderRadius.circular(22.0)
      ),
      child: authenticatedUser.imagePath == null ? 
        GestureDetector(
            onTap: () => openImagePicker(context),
            child: FaIcon(
            FontAwesomeIcons.userEdit,
            size: 24.0,
            color: Colors.grey,
          ),
        ):
        GestureDetector(
           onTap: () => openImagePicker(context),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(22.0),
            child: FadeInImage(
            placeholder: AssetImage(BACKGROUND_IMAGE),
            image: NetworkImage(PROFILE_IMAGE_BASE_URL + "emmanuel izedomi-1610939099.jpg"),
            fit: BoxFit.cover,
            width: 45.0,
            height: 45.0,
          ),
      ),
        ),
    );
  }
}