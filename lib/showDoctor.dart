import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/showInfo.dart';
import 'package:flutter_app/input.dart';
import 'package:flutter_app/main.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> equation(String token) async {
  const url = 'http://127.0.0.1:8000/api/equation';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print('Response body: ${response.body}');
  final Map<String, dynamic> data = jsonDecode(response.body);
  var message = data['message'];

  if (response.statusCode == 200) {
    return {
      'message': message,
    };
  } else {
    return {
      'message': message,
    };
  }
}

Future<Map<String, dynamic>> doctorKey(String token, String equation) async {
  const url = 'http://127.0.0.1:8000/api/doctorKeys';
  final response = await http.post(Uri.parse(url), headers: {
    'Authorization': 'Bearer $token',
  }, body: {
    "equation": equation,
  });
  print('Response body: ${response.body}');
  final Map<String, dynamic> data = jsonDecode(response.body);
  var message = data['message'];

  if (response.statusCode == 200) {
    return {
      'message': message,
    };
  } else {
    return {
      'message': message,
    };
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

Map<String, dynamic> Mymap = {};

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  // تعريف المتغيرات اللازمة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Center(
            child: Text('Doctor', style: TextStyle(color: Colors.black))),
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
                  Icon(Icons.person, color: Colors.amber, size: 50),
                ],
              ),
            ),
            SizedBox(height: 25),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  Mymap = await equation(token);

                  //ignore navigator
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => doctor2Screen()));
                },
                child: Text(
                  'Genaraite CSR',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
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
                child: Text(
                  'LogOut',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.blueGrey[400],
        child: Padding(
            padding: EdgeInsets.all(150.0),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: 10),
                    Divider(color: Colors.amber, height: 2, thickness: 2),
                    SizedBox(height: 10),
                  ],
                );
              },
              itemCount: doctorScreen['data'].length,
              itemBuilder: (context, int index) {
                return Container(
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_sharp,
                          color: Colors.amber, size: 35),
                      SizedBox(width: 25),
                      Column(
                        children: [
                          Text(
                            doctorScreen['data'][index]['name'],
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                          Text(
                            doctorScreen['data'][index]['data'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}

class doctor2Screen extends StatefulWidget {
  @override
  _doctor2ScreenState createState() => _doctor2ScreenState();
}

class _doctor2ScreenState extends State<doctor2Screen> {
  final TextEditingController resultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.amber,
          title: Center(
              child: Text('Send Data', style: TextStyle(color: Colors.black))),
        ),
        body: Container(
          color: Colors.blueGrey[400],
          child: Padding(
            padding: EdgeInsets.all(150.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                      child: Text(
                    Mymap['message'],
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 25),
                  )),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 200),
                    child: TextField(
                      controller: resultController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        labelText: 'The Result',
                        labelStyle: TextStyle(color: Colors.amber),
                        prefixIcon: Icon(
                          Icons.question_mark_rounded,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 200,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        Map<String, dynamic> add_info =
                            await doctorKey(token, resultController.text);
                        print(add_info['message']);
                        var snackBar = SnackBar(
                          content: Text(
                              textAlign: TextAlign.center, "${add_info['message']}"),
                          backgroundColor: Colors.amber,
                          behavior: SnackBarBehavior.floating,
                          width: 350,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text(
                        "Send To CA",
                        style: TextStyle(color: Colors.black),
                      ),
                      minWidth: 5,
                      color: Colors.amber,
                    ),
                  ),
                ]),
          ),
        ));
  }
}
