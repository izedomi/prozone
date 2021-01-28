import 'package:flutter/material.dart';

class ProviderSchema {
    
    String id;
    String name;
    String description;
    String rating;
    String address;
    List<dynamic> images;
    String activeStatus;
    Map<String, dynamic> providerType;
    Map<String, dynamic> state;
   

    ProviderSchema({
      @required this.id,
      @required this.name,
      this.description,
      this.rating,
      @required this.address,
      this.images,
      @required this.activeStatus,
      this.providerType,
      this.state,
    });

    factory ProviderSchema.createProvider(Map<String, dynamic> json){
        
        return ProviderSchema(
          id: json['id'].toString(),
          name: json['name'].toString(),
          description: json['description'].toString(),
          rating: json['rating'].toString(),
          address: json['address'].toString(),
          images: json['images'].toList(),
          activeStatus: json['active_status'].toString(),
          providerType:  {
            "id": json["provider_type"]["id"].toString(),
            "name": json["provider_type"]["name"]
          },
          state:  {
            "id": json["state"]["id"].toString(),
            "name": json["state"]["name"]
          },
        );
    }
}