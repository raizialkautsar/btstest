import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tes_ujian_btsid/Vars.dart';
import 'package:http/http.dart' as http;

class Ceklis extends StatefulWidget {
  const Ceklis({super.key});

  @override
  State<Ceklis> createState() => _ceklisState();
}

class _ceklisState extends State<Ceklis> {
  TextEditingController lis = TextEditingController();

  List l = [];
  Future createnewceklis() async {
    var url = Uri.parse("http://94.74.86.174:8080/api/checklist");
    var headers = <String, String>{
      'Authorization': 'Bearer $auth_token',
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({"name": lis.text});
    var resp = await http.post(url, headers: headers, body: body);
    var data = json.decode(resp.body);
  }

  Future getAllceklis() async {
    var url = Uri.parse("http://94.74.86.174:8080/api/checklist");
    var headers = <String, String>{
      'Accept': '*/*',
      'Authorization': 'Bearer $auth_token',
      'Content-Type': 'application/json',
    };
    var resp = await http.get(url, headers: headers);
    var data = json.decode(resp.body);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextFormField(
          controller: lis,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
                height: 50,
                child: InkWell(
                    splashColor: Colors.teal,
                    onTap: () {
                      createnewceklis();
                    },
                    child: const Center(child: Text('tambah'))))),
        FutureBuilder(
            future: getAllceklis(),
            builder: (context, snapshot) {
              List? list = snapshot.data as List?;

              return snapshot.hasData
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: list![0].length,
                      itemBuilder: (context, i) {
                        return Row(
                          children: [
                            Text(list[i]['data']['name']),
                            Checkbox(
                                value: list[i]['checklistCompletionStatus'],
                                onChanged: (value) {
                                  setState(() {
                                    list[i]['checklistCompletionStatus'] =
                                        value!;
                                  });
                                })
                          ],
                        );
                      })
                  : SizedBox();
            }),
      ],
    ));
  }
}
