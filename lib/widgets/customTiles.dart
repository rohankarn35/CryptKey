
import 'package:flutter/material.dart';

class CustomTile{
  Widget customTile(String titleText, String subtitleText, IconData iconData, VoidCallback onTap){
    return Padding(
      padding: const EdgeInsets.only(left: 20,bottom: 10),
      child: ListTile(
        leading: Icon(iconData,color: Colors.white,size: 25,),
        title: Text(titleText,style: const TextStyle(color: Colors.white,fontSize: 23),textAlign: TextAlign.left,),
        subtitle: Text(subtitleText,style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 15),textAlign: TextAlign.left,),
        onTap: onTap,
      ),
    );
  }
}