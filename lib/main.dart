
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/signup.dart';
import 'package:flutter_app/info.dart';
import 'package:flutter_app/showDoctor.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> doctorScreen = {};


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginPage(),
    );
  }
}

String token = '';
var url = 'http://127.0.0.1:8000/api/login';


Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/login'),
    body: {
      'email': email,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final String token = data['token'];
    final int type = data['type'];

    return {
      'token': token,
      'type': type,
    };
  }

  else {
    throw Exception('Failed to login');
  }
}


Future<List<dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/login'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}


Future<Map<String,dynamic>> showProject(String token) async {
  const url = 'http://127.0.0.1:8000/api/showData';
  final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
  );

  print('Response body: ${response.body}');
  final Map<String, dynamic> data = jsonDecode(response.body);
  var list = data['data'];


  if (response.statusCode == 200) {
    return {
      'data': list,
    };
  }
  else{
    return{
      'data': list,
    };
  }
}

class LoginPage extends StatelessWidget {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
         backgroundColor: Colors.amber,
        title: Center(child: Text('Login',style:TextStyle(
          color: Colors.black
        ))),

      ),
      body: Container(
        color: Colors.blueGrey[400],
        child: Padding(
          padding: EdgeInsets.all(70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: Colors.amber),
                  prefixIcon: Icon(Icons.email,color: Colors.amber),

                ),
              ),
              SizedBox(height: 25.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Colors.amber),
                  prefixIcon: Icon(Icons.password,color: Colors.amber),

                ),
              ),


              SizedBox(height: 25.0),

              MaterialButton(onPressed: () async {
                if (usernameController.text == '' ||
                    passwordController.text == '') {
                  const snackBar = SnackBar(
                    content: Text(
                        textAlign: TextAlign.center,
                        'You need to fill in all fields before we can proceed'),
                    backgroundColor: Colors.amber,
                    behavior: SnackBarBehavior.floating,
                    width: 350,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (usernameController.text != '' &&
                    passwordController.text != '') {


                  var response = await http.post(Uri.parse(url), body: {
                    "email": usernameController.text,
                    "password": passwordController.text
                  });

                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');

                  if (response.statusCode == 200) {

                    Map<String, dynamic> Mymap = await login(usernameController.text, passwordController.text) ;
                    token = Mymap['token'].toString();
                    String type = Mymap['type'].toString();




                    if (type == '0') {
                      doctorScreen = await showProject(token);

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorScreen()),
                      );
                    }

                    else if (type == '1'){
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => info()),
                      );

                    }

                    else {
                      const snackBar = SnackBar(
                        content: Text(textAlign: TextAlign.center, 'There is authorization error'),
                        backgroundColor: Colors.amber,
                        behavior: SnackBarBehavior.floating,
                        width: 350,
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }
                  } else {
                    if (response.statusCode == 403) {
                    const snackBar = SnackBar(
                      content: Text(
                          textAlign: TextAlign.center,
                          'Check your email or password and try again'),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                      width: 350,
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                  } else {
                      if (response.statusCode == 400) {
                    const snackBar = SnackBar(
                      content: Text(
                          textAlign: TextAlign.center,
                          'Check your email or password and try again'),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                      width: 350,
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                  }
                    }
                  }
                };
              },
                  child:Text("Login",
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                color: Colors.amber,
              ),

              SizedBox(height: 35.0),

              MaterialButton(onPressed:() async{
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage())
                );
              },
                child:Text("SignUp",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
                color: Colors.amber,
              ),

            ],
          ),
        ),
      ),
    );
  }
}




