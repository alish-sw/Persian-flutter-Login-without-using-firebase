import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../models/httpExeptions.dart';

class Auth with ChangeNotifier
{
    String? _token;
    String? _userId;
    DateTime? _expireDate;
  //late Timer _authtimer;
  String get userId{
    if(_userId!=null)
      {
        return _userId!;
      }
    return "InvalidUsername";
  }
  String get token{
    // ignore: unnecessary_null_comparison
    if(_token!=null)
     {
       return _token!;
     }
    return 'InvalidToken';
   }
  bool get isAuthenticated{

    if(token != 'InvalidToken')
    {
      return true;
    }
      return false;
  }
  Future<void> Authenticate(String userName,String password,String type) async
  {

    const posturl='http://192.168.1.11/LoginService/SignUp';
    final geturl='http://192.168.1.11/LoginService/SignIn?userName=$userName&password=$password';
    final response;
    try
    {
      //login
      if(type=='signIn')
      {
        response=await http.get(Uri.parse(geturl));
      }
      //signup
      else
      {
        response=await http.post(Uri.parse(posturl),body: ({
            'userName':userName,
            'password':password,
            }));
      }

      final responseData=jsonDecode((response.body));
      //throw api error
      if(responseData['isSuccess']==false) {
        throw httpExeptions(responseData['messages']);
      }
      _token=responseData['messages']!;
      _userId=responseData['name']!;
      _expireDate=DateTime.parse(responseData['expireDate']);
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final _userData=json.encode(
          {
            'token':_token,
            'userId':_userId,
            'expireDate':_expireDate!.toIso8601String(),
          });
      prefs.setString('userData', _userData);
    }
    //throw other
    catch(erorr)
    {
      throw erorr;
    }

  }
  Future <bool> AutoLogin() async
  {

    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData'))
    {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')as String) as Map<String, dynamic>;

    final expireDate=DateTime.parse(extractedUserData['expireDate'] as String);

    if(expireDate.isBefore(DateTime.now()))
      {
        return false;
      }
    _userId=extractedUserData['userId']as String;
    _token=extractedUserData['token']as String;
    _expireDate=expireDate;

    notifyListeners();
    return true;
  }
  Future<void>LogOut()async
  {
     _token=null;
     _userId=null;
     _expireDate=DateTime.now();
     notifyListeners();
     final prefs=await SharedPreferences.getInstance();
     prefs.clear();
  }

}

