import 'package:flutter/material.dart';
import 'package:flutter_dev/emotions/happy.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String value;
  var _name;
  final nameCon = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.camera)],
        title: Text('CopyMe', style: TextStyle(fontSize: 20)),
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          height: 235,
          child: Image.asset("assets/images/Dynamic.jpeg"),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Form(
              child: Column(
            children: [
              TextFormField(
                controller: nameCon,
                onChanged: (text) {
                  value = text;
                },
                decoration: InputDecoration(
                    fillColor: Colors.cyan,
                    prefixIcon: Icon(Icons.person),
                    hintText: "enter ur name",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.4))),
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _name = nameCon.text;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Happy(value: _name)));
                        });
                      },
                      child: Text("Start", style: TextStyle(fontSize: 20))))
            ],
          )),
        )
      ]),
    );
  }
}
