import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spike_users/service/users.dart';

import 'model/user.dart';

void main() {
  runApp(const SpikeApp());
}

class SpikeApp extends StatelessWidget {
  const SpikeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SpikeHomePage(title: 'Flutter Spike Users'),
    );
  }
}

class SpikeHomePage extends StatefulWidget {
  const SpikeHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SpikeHomePage> createState() => _SpikeHomePageState();
}

class _SpikeHomePageState extends State<SpikeHomePage> {
  late Future<List<User>> userList;

  @override
  void initState() {
    super.initState();
    userList = UserService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<User>>(
        future: userList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                padding: const EdgeInsets.all(8),
                children: snapshot.data!.map(userCard).toList());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget userCard(User user) {
    return Card(
      child: ExpansionTile(title: Text('🧍‍ ${user.name}'), children: <Widget>[
        const Divider(),
        userField('📙', 'Username', user.username),
        userField('📧', 'E-mail', user.email),
        userField('📍', 'Address', '${user.address}'),
        userField('🌐', 'Website', user.website, true),
        userField('🏢', 'Company', user.company.name),
        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 7))
      ]),
    );
  }

  Widget userField(String emoji, String name, String value, [bool? link]) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 2, 40, 0),
          child: Row(children: [
            Expanded(flex: 4, child: Html(data: '<strong>$name</strong>:')),
            Expanded(
                flex: 10,
                child: Html(
                    data: link != null && link
                        ? '$emoji <a href="$value">$value</a>'
                        : '$emoji $value'))
          ])),
    );
  }
}
