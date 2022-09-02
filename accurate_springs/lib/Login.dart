import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'NewWO.dart';

var um_id;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var UserName=TextEditingController();
  var Password=TextEditingController();

  void Login() async {
    var url="https://apiaspl.larch.in/Home/FetchLoginDetails?Login=${UserName.text}&Password=${Password.text}";
    var response=await http.get(Uri.parse(url));
    //print(response);
    var data=jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      if(data[i]['Message'] == 'Success'){
        um_id= data[i]['um_iId'];
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewWO()));
      }
      else{
        Widget okbutton = OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 15.0),));
        AlertDialog dialog = AlertDialog(
          title: Text('Error'),
          content: Text('${data[i]['Message']}'),
          actions: [okbutton],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 170.0,),
              Container(
                child: Text('Accurate - ERP',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 30.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('UserName',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      child: TextFormField(
                        controller: UserName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Password',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      child: TextFormField(
                        controller: Password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70.0,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey),onPressed: ()=> Login(), child: Text('Log In',style: TextStyle(color: Colors.white,fontSize: 15.0),)),
                    SizedBox(width: 20.0,),
                    OutlinedButton(style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey),onPressed: (){SystemNavigator.pop();}, child: Text('Exit',style: TextStyle(color: Colors.white,fontSize: 15.0),))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async => false);
  }
}
