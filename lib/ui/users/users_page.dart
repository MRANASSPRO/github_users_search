import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String query = "null";
  bool notVisible = false;
  TextEditingController queryTextEditingController =
      new TextEditingController();
  dynamic data;
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 20;

  void _search(String query) {
    String requestUrl =
        "https://api.github.com/search/users?q=$query&per_page=$pageSize&page=$currentPage";
    print(requestUrl);
    http.get(Uri.parse(requestUrl)).then((response) {
      setState(() {
        data = json.decode(response.body);

        if (data['total_count'] % pageSize == 0) {
          //round results with integer division
          totalPages = data['total_count'] ~/ pageSize;
        }/* else if (data['total_count'] == 1){
        }*/ else
          totalPages = (data['total_count'] / pageSize).floor() + 1;
      });
      //print("response length ${response.body.length}");
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building page...");
    return Scaffold(
      appBar:
          AppBar(title: Text('Users => $query => $currentPage / $totalPages')),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      obscureText: notVisible,
                      onChanged: (value) {
                        setState(() {
                          this.query = value;
                        });
                      },
                      controller: queryTextEditingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              queryTextEditingController.clear();
                            },
                          ),
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.deepOrange))),
                    ),
                  ),
                ),
                /*Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                  ),
                  child: IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){}),
                ),*/
                IconButton(
                  onPressed: () {
                    setState(() {
                      notVisible = !notVisible;
                    });
                  },
                  color: Colors.deepOrange,
                  icon: Icon(notVisible == true
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        this.query = queryTextEditingController.text;
                        //private fun indicated with _
                        _search(query);
                      });
                    })
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: (data == null) ? 0 : data['items'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  data['items'][index]['avatar_url']),
                              radius: 40,
                            ),
                            SizedBox(width: 20),
                            Text("${data['items'][index]['login']}"),
                          ],
                        ),
                        CircleAvatar(
                          child: Text("${data['items'][index]['score']}"),
                        )
                      ],
                    ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
