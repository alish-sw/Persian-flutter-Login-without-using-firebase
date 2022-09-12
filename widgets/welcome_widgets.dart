import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/welcome.dart';

class Welcome_widgets extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    void LogOut(){
      Provider.of<Auth>(context,listen: false).LogOut();
     }
    final welcomedata = Provider.of<Welcome>(context);
    return Scaffold(
      body: ListView(
        children: [
          Text(welcomedata.getUserId),
          Text(welcomedata.getToken),
          ElevatedButton(onPressed: LogOut, child: const Text("LogOut"))
        ],
      ),
    );
  }
}