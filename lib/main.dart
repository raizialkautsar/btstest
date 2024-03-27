import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes_ujian_btsid/ceklis.dart';

import 'Vars.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app checklist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'app checklist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  void register() async {
    var url = Uri.parse("http://94.74.86.174:8080/api/register");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };
    var body = jsonEncode(
        {"email": email.text, "password": pass.text, "username": user.text});
    var resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode == 200) {
      var data = json.decode(resp.body);
    } else {
      print('Failed to register: ${resp.reasonPhrase}');
    }
  }

  void login() async {
    var url = Uri.parse("http://94.74.86.174:8080/api/login");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({"password": pass.text, "username": user.text});
    var resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode == 200) {
      var data = await json.decode(resp.body);
      setState(() {
        auth_token = data["data"]["token"];
      });
    } else {
      print('Failed to login: ${resp.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              const SizedBox(height: 40),
              SizedBox(
                height: 60,
                width: 360,
                child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Masukan Email Pengguna",
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "*Nama email kosong";
                      }
                      return null;
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).nextFocus()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: 360,
                child: TextFormField(
                    controller: user,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Masukan Nama Pengguna",
                      labelText: "Pengguna",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "*Nama Pengguna kosong";
                      }
                      return null;
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).nextFocus()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: 360,
                child: TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black87),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Masukan Sandi",
                    labelText: "Sandi",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Sandi kosong";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                              height: 50,
                              child: InkWell(
                                  splashColor: Colors.teal,
                                  onTap: () {
                                    register();
                                  },
                                  child:
                                      const Center(child: Text('daftar')))))),
                  SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                              height: 50,
                              child: InkWell(
                                  splashColor: Colors.teal,
                                  onTap: () {
                                    login();
                                    if (auth_token != '') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Ceklis()));
                                    }
                                  },
                                  child: const Center(child: Text('masuk')))))),
                ],
              )
            ])));
  }
}
