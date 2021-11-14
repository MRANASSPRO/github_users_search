import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GithubRepos extends StatefulWidget {
  String userName;
  String avatarUrl;

  GithubRepos({this.userName, this.avatarUrl});

  @override
  State<GithubRepos> createState() => _GithubReposState();
}

class _GithubReposState extends State<GithubRepos> {
  dynamic reposData;

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  void fetchRepositories() async {
    String reposBaseUrl =
        "https://api.github.com/users/${widget.userName}/repos";

    http.Response response = await http.get(Uri.parse(reposBaseUrl));
    if (response.statusCode == 200) {
      setState(() {
        reposData = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories ${widget.userName}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.avatarUrl),
            ),
          )
        ],
      ),
      body: Center(
          child: ListView.separated(
              itemBuilder: (context, index) =>
                  ListTile(title: Text("${reposData[index]['name']}")),
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.green),
              itemCount: reposData == null ? 0 : reposData.length)),
    );
  }
}
