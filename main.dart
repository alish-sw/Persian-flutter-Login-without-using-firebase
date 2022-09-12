import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'providers/welcome.dart';
import 'screens/auth_screen.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
        ChangeNotifierProvider.value(
        value: Auth(),
     ), ChangeNotifierProvider(create: (ctx) => Auth()),
           ChangeNotifierProxyProvider<Auth,Welcome>(
               create:(ctx)=> Welcome('',''),
               update: (ctx,auth,_)=> Welcome(auth.token as String,auth.userId as String)
           )
        ],
    child:Consumer<Auth>(builder: (ctx,auth,_)=>MaterialApp
      (
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,

           ),

      home:auth.isAuthenticated?const Welcome_screen():FutureBuilder(
          future:auth.AutoLogin(),
          builder: (ctx,authResultSnapshot)=>
          authResultSnapshot.connectionState==ConnectionState.waiting
              ?const Center(child: CircularProgressIndicator(),)
              :const Auth_screen()
      ),
    ),
    ),
    );

  }

}


