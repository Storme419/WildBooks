import 'package:flutter/material.dart';
import 'package:wild_books/src/shared/themes/themes.dart';
import 'package:wild_books/view/about_us_page.dart';
import 'package:wild_books/view/account_page.dart';
import 'package:wild_books/view/add_a_book_page.dart';
import 'package:wild_books/view/book_shelf_page.dart';
import 'package:wild_books/view/discarded_pages/found_book_page.dart';
import 'package:wild_books/view/list_of_all_books.dart';
import 'package:wild_books/view/onboarding_page.dart';
import 'package:wild_books/view/search_page.dart';
import 'package:wild_books/view/home_page.dart';
import 'package:wild_books/view/login_page.dart';
import 'package:wild_books/view/redirect_page.dart';
import 'package:wild_books/view/map_page.dart';
import 'package:wild_books/controller/theme_controller.dart';
import 'package:wild_books/utils/db.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  await initSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: ThemeController.instance,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            themeMode: ThemeController.instance.isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            routes: {
              '/home': (context) => const HomePage(),
              '/profile-button': (context) => const RedirectPage(),
              '/sign-in': (context) => const LoginPage(),
              '/add-book': (context) => const AddBook(),
              '/about-us': (context) => const AboutUs(),
              '/account': (context) => const AccountPage(),
              '/books-list': (context) => const ListOfBooks(),
              '/found-book': (context) => const FoundBook()
            },
            home: const OnBoardingPage(),
          );
        });
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Bookshelf(),
    const Map(),
    const Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
             UserAccountsDrawerHeader(
              // currentAccountPicture: ClipRRect(
              //     borderRadius: BorderRadius.circular(40),
              //     child: Image.network(
              //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS29OImDEUJspbdQTIIKTar91MyZ920fD6jpQ&usqp=CAU")),
              accountName: Text(''),
              accountEmail: Text(''),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
              )
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
                // Navigator.of(context).pushNamed('/about-us');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log-out'),
              onTap: () async {
                Navigator.of(context).pop();
                await supabase.auth.signOut();
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(45),
                bottomLeft: Radius.circular(45))),
        title: const Text(
          'W I L D B O O K S',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 2, 4),
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile-button');
                },
                icon: const Icon(
                  Icons.person_2_rounded,
                  // size: 35,
                )),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            activeColor: Theme.of(context).colorScheme.onSurface,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(5),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                //iconSize: 35,
                text: 'Home',
              ),
              GButton(
                icon: Icons.book_rounded,
                //  iconSize: 35,
                text: 'Bookshelf',
              ),
              GButton(
                icon: Icons.map,
                // iconSize: 35,
                text: 'Map',
              ),
              GButton(
                icon: Icons.search,
                // iconSize: 35,
                text: 'Search',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
