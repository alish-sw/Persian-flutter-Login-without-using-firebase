import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class Auth_screen extends StatelessWidget {
  const Auth_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceSize=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors:[
                const Color.fromARGB(215, 244, 248, 245).withOpacity(0.5),
                const Color.fromARGB(255, 7, 243, 189).withOpacity(0.9),
                ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0,1],
                ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: DeviceSize.height,
              width: DeviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child:
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 50.0),
                    transform: Matrix4.rotationZ(-20*pi/180)..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amberAccent,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black87,
                          offset: Offset(0,2)
                        )
                      ]
                    ),
                    child: const Text("alish-sw",style:TextStyle(
                      color: Colors.black87,
                      fontSize: 50,
                      fontWeight: FontWeight.normal

                    ) ,
                    ),


                  ),
                  ),
                  Flexible(
                    flex: DeviceSize.width>600?2:1,
                    child:const Auth_screenelements() ,
                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}

class Auth_screenelements extends StatefulWidget {
  const Auth_screenelements({Key? key}) : super(key: key);
  //static const routeName = '/auth';
  @override
  State<Auth_screenelements> createState() => _Auth_screenelementsState();
}

class _Auth_screenelementsState extends State<Auth_screenelements>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //final _formKey = GlobalKey<FormState>();
  var IsLogin=true;
  final Map<String, String?> _authData = {
    'email': '',
    'password': '',
  };
  void _showErorrDialog(String message)
  {
    showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title:const Text("خطایی رخ داده است"),
          content: Text(message),
          actions: [
            ElevatedButton(onPressed:(){ Navigator.of(ctx).pop();}, child: Text("متوجه شدم"))
          ],
        ));
  }
  Future<void>Submit()async
  {
    if(!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (IsLogin) {
        //login
        await Provider.of<Auth>(context, listen: false).Authenticate(
            _authData['email'] as String, _authData['password'] as String,
            'signIn');
      }
      else {
        //signup
        await Provider.of<Auth>(context, listen: false).Authenticate(
            _authData['email'] as String, _authData['password'] as String,
            'signup');
      }
    }
     on HttpException catch(erorr)
    {
      const erorrmsg="امکان احراز هویت شما وجود ندارد لطفا بعدا تلاش نمایید";
      _showErorrDialog(erorrmsg);
    }
    catch(erorr)
    {
      _showErorrDialog(erorr.toString());
    }
  }
  void _authenticateMode(){
    setState(() {
      if(IsLogin==true)
      {
        IsLogin=false;
      }
      else
      {
        IsLogin=true;
      }
    });
  }
  final _passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    return  Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 8,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: IsLogin?260:320,
          constraints: BoxConstraints(minHeight: IsLogin?260:320),
          width: deviceSize.width*0.75,
          padding: const EdgeInsets.all(5.0),
          child: Form(
              key: _formKey,
              child:Scaffold(
              body: Container(
              height: IsLogin?260:320,
              constraints:
              BoxConstraints(minHeight: IsLogin?260:320),
              width: deviceSize.width * 0.75,
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'ایمیل'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if( value==null || !value.contains('@')){
                          return "لطفا یک ایمیل صحیح وارد کنید";
                        }
                        return null;
                        },
                      onSaved: (value){
                        _authData['email']=value;

                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'کلمه عبور' ),
                      obscureText:true,
                      controller: _passwordController,
                      validator: (value){
                        if(value==null||value.length<=5) {
                          return "کلمه عبور بسیار کوتاه است";
                        }
                        return null;
                      },
                      onSaved: (value){
                        _authData['password']=value;
                      },
                    ),
                    if(IsLogin==false)
                      TextFormField(
                        enabled: IsLogin==false,
                        decoration: const InputDecoration(labelText: "تکرار کلمه عبور"),
                        obscureText: true,
                        validator: (value){
                          if(value!=_passwordController.text) {
                            return "کلمه عبور وتکرار آن باید برابر باشد";
                          }
                          return null;
                        },

                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(onPressed: Submit, child: Text(IsLogin?"ورود":"ثبت نام"),),
                    TextButton(onPressed: _authenticateMode, child: Text(IsLogin?"ساخت اکانت جدید":"ورود"))
                  ],
                ),
              ),
            ),
          ),),
        ),
      ),
    );
  }}
//}



