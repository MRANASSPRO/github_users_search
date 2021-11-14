import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_users_search/ui/repositories/github_repos.dart';
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
  dynamic userData;
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 20;
  List<dynamic> userItemsList = [];
  ScrollController scrollController = new ScrollController();

  void _search(String query) {
    String requestUrl =
        "https://api.github.com/search/users?q=$query&per_page=$pageSize&page=$currentPage";
    print(requestUrl);
    http.get(Uri.parse(requestUrl)).then((response) {
      setState(() {
        userData = json.decode(response.body);
        this.userItemsList.addAll(userData['items']);

        if (userData['total_count'] % pageSize == 0) {
          //round results with integer division
          totalPages = userData['total_count'] ~/ pageSize;
          /*} else if (userData['total_count'] <= pageSize) {
          totalPages = 1;
          currentPage = 1;*/
        } else
          totalPages = (userData['total_count'] / pageSize).floor() + 1;
      });
      //print("response length ${response.body.length}");
    }).catchError((error) {
      print(error);
    });
  }

  //will be executed once before build method
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPages) {
            ++currentPage;
            _search(query);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building page...");
    return Scaffold(
      appBar:
          AppBar(title: Text('User $query => $currentPage / $totalPages')),
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
                  icon: Icon(Icons.clear),
                  color: Colors.deepOrange,
                  onPressed: () {
                    setState(() {
                      queryTextEditingController.clear();
                    });
                  },
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        userItemsList = [];
                        currentPage = 0;
                        this.query = queryTextEditingController.text;
                        //private fun indicated with _
                        _search(query);
                      });
                    })
              ],
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.deepOrange,
                      ),
                  controller: scrollController,
                  itemCount: userItemsList.length,
                  //itemCount: (userData == null) ? 0 : userData['items'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GithubRepos(
                                      userName: userItemsList[index]['login'],
                                      avatarUrl: userItemsList[index]
                                          ['avatar_url'])));
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userItemsList[index]['avatar_url']),
                                  radius: 40,
                                ),
                                SizedBox(width: 20),
                                Text("${userItemsList[index]['login']}"),
                              ],
                            ),
                            //to display user score
                            CircleAvatar(
                              child: Text("${userItemsList[index]['score']}"),
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
