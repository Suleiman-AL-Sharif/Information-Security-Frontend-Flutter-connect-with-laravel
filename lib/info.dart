
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/showInfo.dart';
import 'package:flutter_app/input.dart';
import 'package:flutter_app/main.dart';
import 'package:http/http.dart' as http;


Future<bool> addInformation(String token,String key,String name,String address, String phone) async {
  const url = 'http://127.0.0.1:8000/api/info';
  final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "key":key,
        "name": name,
        "address":address,
        "phone_n":phone,
      }
  );


  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}



Future<bool> logout(String token) async {
  const url = 'http://127.0.0.1:8000/api/logout';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Map<String, dynamic> userInfo = {};

Future<Map<String,dynamic>> showInformation(String token,String key) async {
  const url = 'http://127.0.0.1:8000/api/showInfo';
  final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "key":key,
      }
  );

  print('Response body: ${response.body}');
  final Map<String, dynamic> data = jsonDecode(response.body);
  var name = data['name'];
  var address = data['address'];
  var phone = data['phone_n'];

  if (response.statusCode == 200) {
    return {
      'name': name,
      'phone_n': phone,
      'address': address
    };
  }
  else{
    return{
      'name': name,
      'phone_n': phone,
      'address': address
    };
  }
}


class info extends StatefulWidget {
  @override
  State<info> createState() => _infoState();
}

class _infoState extends State<info> {
  final TextEditingController keyController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController key1Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(

        backgroundColor: Colors.amber,
        title: Center(child: Text('Information Form',style:TextStyle(
            color: Colors.black
        ))),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: Column(
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 25),
                  Icon(Icons.person,color: Colors.amber,size: 50),
                ],
              ),
            ),
            ListTile(
              title: TextField(
                controller: key1Controller,
                onChanged: (value) {
                  setState(() {

                    }

                  );
                },
                decoration: InputDecoration(
                  labelText: 'National ID',
                  labelStyle: TextStyle(
                      color: Colors.amber),
                  prefixIcon: Icon(Icons.flag,color: Colors.amber),
                ),
              ),
            ),
                ListTile(
                 title: ElevatedButton(
                onPressed: ()async {
                  userInfo = await showInformation(
                      token, key1Controller.text);

                  print(userInfo['name']);

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => showInfo())
                    );



                },
                  child: Text('Show Information',style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                  primary:Colors.
                  amber
                  ),
              ),
            ),
            SizedBox(height: 50),
            ListTile(
              title: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InputScreen())
                  );

                },
                child: Text('Connect With Doctor',style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                    primary:Colors.amber
                ),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: ()async{
                  bool check_logout = await logout(token);

                  if (check_logout) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                          (route) => false,
                    );
                  }

                },
                child: Text('LogOut',style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                    primary:Colors.amber
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.blueGrey[400],
        child: Padding(

          padding: EdgeInsets.all(130.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: keyController,
                decoration: InputDecoration(
                  labelText: 'National ID',
                  labelStyle: TextStyle(
                      color: Colors.amber),
                  prefixIcon: Icon(Icons.flag,color: Colors.amber),

                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name',
                    labelStyle: TextStyle(
                        color: Colors.amber),
                    prefixIcon: Icon(Icons.person,color: Colors.amber,)),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address',
                    labelStyle: TextStyle(
                        color: Colors.amber),
                    prefixIcon: Icon(Icons.location_disabled_sharp,color: Colors.amber,)),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number',
                    labelStyle: TextStyle(
                        color: Colors.amber),
                    prefixIcon: Icon(Icons.phone,color: Colors.amber,)),
              ),
              SizedBox(height: 20),
              ElevatedButton(

                onPressed: () async{
                  bool check_add_info = await addInformation(token,keyController.text, nameController.text,  addressController.text,phoneController.text);

                  if(check_add_info) {
                    const snackBar = SnackBar(
                      content: Text(
                          textAlign: TextAlign.center,
                          'information added successfully'),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                      width: 350,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else{
                    const snackBar = SnackBar(
                      content: Text(
                          textAlign: TextAlign.center,
                          'There is error: information dose not added'),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                      width: 350,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                },
                child: Text('Submit',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w700),),
                style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 15),
                    primary:Colors.amber
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}