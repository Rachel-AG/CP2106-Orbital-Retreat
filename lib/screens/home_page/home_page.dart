import 'package:flutter/material.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/supabase_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _supabaseClient = SupabaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.pushReplacementNamed(context, '/record');},
        tooltip: 'Button',
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<Profile>(
        future: _supabaseClient.getProfile(context),
        builder: (context, AsyncSnapshot<Profile> snapshot) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Text(
              snapshot.data?.username ?? 'hello user',
              style: TextStyles.headerTextStyle,
            ),
          );
        },
      ),
    );
  }
}
