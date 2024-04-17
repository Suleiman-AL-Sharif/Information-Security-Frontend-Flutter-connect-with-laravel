
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/showInfo.dart';
import 'package:flutter_app/input.dart';
import 'package:flutter_app/main.dart';
import 'package:http/http.dart' as http;




Future<bool> sessionKey(String token,String id) async {
  const url = 'http://127.0.0.1:8000/api/generateKeyPair';
  final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "id":id,
      }
  );

  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}


Future<bool> data(String token,String data) async {
  const url = 'http://127.0.0.1:8000/api/data';
  final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "data":data,
      }
  );

  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}




class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // تعريف المتغيرات اللازمة
  final TextEditingController idController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  bool showAdditionalFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        title: Center(child: Text('Send Data',style:TextStyle(
            color: Colors.black
        ))),

      ),
      body: Container(
        color: Colors.blueGrey[400],
        child: Padding(
          padding: EdgeInsets.all(150.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: idController,
                onChanged: (value) {
                  setState(() {
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Doctor ID',
                  labelStyle: TextStyle(
                      color: Colors.amber),
                  prefixIcon: Icon(Icons.key,color: Colors.amber,),
                ),
              ),
              SizedBox(height: 16.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 200,),
                child: MaterialButton( onPressed: () async{
                  bool check_sessionKey = await sessionKey(token,idController.text);

                  if(check_sessionKey) {
                    const snackBar = SnackBar(
                      content: Text(
                          textAlign: TextAlign.center,
                          'sessionKey generated successfully'),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                      width: 350,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      showAdditionalFields = true;
                    });
                  }
                  else{
                    const snackBar = SnackBar(
                      content: Text(
                          textAlign: TextAlign.center,
                          'There is error: sessionKey dose not generated'),
                      backgroundColor: Colors.amber,
                      behavior: SnackBarBehavior.floating,
                      width: 350,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }



                  },

                  child:Text("Session Key",
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  minWidth: 5,
                  color: Colors.amber,
                ),
              ),
              SizedBox(height: 100.0),
              if (showAdditionalFields)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      controller: dataController,

                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        labelText: 'Project Details',
                        labelStyle: TextStyle(
                            color: Colors.limeAccent),
                        prefixIcon: Icon(Icons.laptop,color: Colors.amber,),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    ElevatedButton(
                      onPressed: ()async{
                        bool check_data = await data(token,dataController.text);

                        if(check_data) {
                          const snackBar = SnackBar(
                            content: Text(
                                textAlign: TextAlign.center,
                                'information sent successfully'),
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
                                'There is error: information dose not sent'),
                            backgroundColor: Colors.amber,
                            behavior: SnackBarBehavior.floating,
                            width: 350,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text('Send Information',style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                          primary:Colors.amber
                      ),
                    ),
                    SizedBox(height: 16.0),

                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
