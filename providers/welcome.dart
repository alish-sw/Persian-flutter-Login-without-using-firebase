import 'package:flutter/material.dart';

class Welcome with ChangeNotifier
{
  final String? Token;
  final String? UserId;
  //DateTime Expiredate=DateTime.now();
  Welcome(this.Token,this.UserId);
  String get getToken{
    if(Token==null)
      return "notfound";
    return Token!;
  }
  String get getUserId{
    if(UserId==null)
      return "notfound";
    return UserId!;
  }
}