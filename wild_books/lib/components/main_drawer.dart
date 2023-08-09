import 'package:flutter/material.dart';
import 'package:wild_books/controller/theme_controller.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.signoutCallback});

  final signoutCallback;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(''),
              accountEmail: Text(''),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/images/book.drawer.jpg'),
                      fit: BoxFit.fill)),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: ThemeController.instance.isDarkTheme,
              onChanged: (value) {
                ThemeController.instance.changeTheme();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/about-us');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add a book'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/add-book');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_rounded),
              title: const Text('All Books'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/books-list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Find Books'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log-out'),
              onTap: () async {
                Navigator.of(context).pop();
                await signoutCallback();
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        ),
      );
  }
}