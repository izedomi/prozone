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
          id: json["id"] == null ? "N/A" : json['id'].toString(),
          name: json["name"] == null ? "N/A" : json['name'].toString(),
          description: json["description"] == null ? "N/A" : json['description'].toString(),
          rating: json["rating"] == null ? "N/A" : json['rating'].toString(),
          address: json["address"] == null ? "N/A" : json['address'].toString(),
          images: json["address"] == null ? "N/A" : json['images'].toList(),
          activeStatus: json['active_status'].toString(),
          providerType:  {
            "id": json["provider_type"] == null ? "N/A" : json["provider_type"]["id"].toString(),
            "name": json["provider_type"] == null ? "N/A" : json["provider_type"]["name"]
          },
          state:  {
            "id": json["state"] == null ? "N/A" : json["state"]["id"].toString(),
            "name": json["state"] == null ? "N/A" : json["state"]["name"]
          },
        );
    }
}