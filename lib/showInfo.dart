
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/info.dart';
import 'package:flutter_app/main.dart';
import 'package:http/http.dart' as http;


class showInfo extends StatefulWidget {
  @override
  State<showInfo> createState() => _showInfoState();
}

class _showInfoState extends State<showInfo> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.amber,
          title: Center(child: Text('User Information',style:TextStyle(
            color: Colors.black,
          ))),
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => info())
                );
              }
          ),
        ),
        body: Container(
          color: Colors.blueGrey[400],
          child: Center(
            child: Column(

              children: [
                SizedBox(height: 100.0),
                Text('Welcome To Our Websit',style: TextStyle(color: Colors.amber,fontWeight: FontWeight.w800,fontSize:25 ),),
                SizedBox(height: 100.0),
                Icon(Icons.person,color: Colors.amber,size: 50,),
                SizedBox(height: 25.0),
                Container(
                  color: Colors.amber,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Attribute',style:TextStyle(color: Colors.purple,fontWeight: FontWeight.w800))),
                      DataColumn(label: Text('Value',style:TextStyle(color: Colors.purple,fontWeight: FontWeight.w800))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Name',style:TextStyle(color: Colors.purple,fontWeight: FontWeight.w800))),
                        DataCell(Text(' ${userInfo['name'] }')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Phone',style:TextStyle(color: Colors.purple,fontWeight: FontWeight.w800))),
                        DataCell(Text('${userInfo['phone_n'] }')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Address',style:TextStyle(color: Colors.purple,fontWeight: FontWeight.w800))),
                        DataCell(Text('${userInfo['address'] }')),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}