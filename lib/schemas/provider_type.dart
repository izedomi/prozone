import 'package:flutter/material.dart';

class ProviderType {
    
    String id;
    String name;
    
    ProviderType({
      @required this.id,
      this.name,
    });

    factory ProviderType.createProviderType(Map<String, dynamic> json){
        return ProviderType(
          id: json['id'].toString(),
          name: json['name'].toString(),
        );
    }
}