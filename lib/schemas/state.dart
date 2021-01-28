import 'package:flutter/material.dart';

class State {
    
    String id;
    String name;
    
    State({
      @required this.id,
      this.name,
    });

    factory State.createState(Map<String, dynamic> json){
        return State(
          id: json['id'].toString(),
          name: json['name'].toString(),
        );
    }
}