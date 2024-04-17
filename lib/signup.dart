
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



Future<String> register(String email, String password, String passwordConfig, ) async {
  const url = 'http://127.0.0.1:8000/api/register';
  final response = await http.post(Uri.parse(url), body: {
    "email": email,
    "password": password,
    "password_confirmation": passwordConfig,

  });
  print('Response status: ${response.statusCode}');

  if (response.statusCode == 200 || response.statusCode == 422) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final String message = data['message'];

    return message;
  } else if (response.statusCode == 500){
    return 'User Created Successfully';
  } else {
    throw Exception('Failed to create Department ');
  }
}

class SignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Center(child: Text('SignUp',style:TextStyle(
            color: Colors.black
        ))),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                    (route) => false,
              );
            }
        ),
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
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Again',
                  labelStyle: TextStyle(
                      color: Colors.amber),
                  prefixIcon: Icon(Icons.password,color: Colors.amber),
                ),
              ),
              SizedBox(height: 25.0),
              MaterialButton(onPressed: ()async {
                String checkCreateWH = await register(
                  usernameController.text,
                    passwordController.text,
                    passwordController.text,
                   );

                var snackBar = SnackBar(
                  content: Text(
                      textAlign: TextAlign.center,
                      checkCreateWH),
                  backgroundColor: Colors.amber,
                  behavior: SnackBarBehavior.floating,
                  width: 350,
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar);

                Navigator.of(context).pop();
              },
                child:Text("Creat Accaunt",style: TextStyle(color: Colors.black),),
                color: Colors.amber,

              ),
            ],
          ),
        ),
      ),
    );
  }
}