import 'dart:convert';

import 'package:flutter_spike_users/model/user.dart';
import 'package:http/http.dart';

class UserService {
  static const String url = "https://jsonplaceholder.typicode.com/users";

  static Future<List<User>> getUsers() async {
    final Response res = await get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<User> userList = (jsonDecode(res.body) as List)
          .map((item) => User.fromJson(item))
          .toList();
      return userList;
    } else {
      throw "Unable to retrieve users";
    }
  }
}
