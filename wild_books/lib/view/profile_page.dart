import 'package:flutter/material.dart';
import 'package:wild_books/classes/BookshelfData.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  //const ProfilePage({super.key, required this.userId});

  //final int userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late TextEditingController controller;

  String username = 'John Doe';
  String createdAt =
      DateFormat.yMMMd().format(DateTime.parse('2023-08-01 10:15:30+00'));
  int booksFound = 3;
  int booksReleased = 3;

  String userImg =
      'https://w7.pngwing.com/pngs/627/693/png-transparent-computer-icons-user-user-icon-thumbnail.png';

@override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Stack(
                    children: [
                      Image.network(userImg),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            // prompt to update img url

                            // POST to database
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(username),
                    IconButton(
                      onPressed: () async {
                        final newName = await renameDialog();
                        if(newName == null || newName.isEmpty) return;
                        setState(() => username = newName);

                        // TODO POST to db
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                Text('joined: $createdAt'),
                Text('found books: $booksFound'),
                Text('released books: $booksReleased'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> renameDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('New username'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter username',
            ),
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('SUBMIT'),
            )
          ],
        ),
      );
}
