import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(
              'Join the Wild Books community today. Set your books free, enjoy the thrill of seeing where they end up, and take part in an exciting, shared reading experience. With Wild Books, every story has a story.',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 13),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'What is Wild Books?',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const Text(
              '      An application that fosters a reading community and promotes recycling in the most novel way possible. But Wild Books is not just an app; it\'s a call to action, a movement aimed at fostering a love for books while supporting sustainability.',
            ),
            const Text(
                '     Ever wonder what happens to your books after you read them? With Wild Books, you can send them on a remarkable journey, sharing the joy of reading with others. Pass them to friends, family, or even leave them in public spaces like parks, cafes, buses, or benches. Wherever you choose to \'release\' your books, you\'re not just decluttering; you\'re creating a ripple of reading joy in the community.'),
            const Text(
                '     Each book you release into the \'wild\' is marked with a unique code - a passport for its journey. Once found, the new reader enter the code on our app, instantly connecting them to the book\'s history. They\'ll see where it\'s traveled, who\'s enjoyed it before, and read comments from previous readers. After they\'ve added their own thoughts, they can continue the book\'s adventure, passing it forward for another reader to discover.'),
            const Text(
                '     Wild Books includes an interactive map, showing each book\'s adventures across town, the country, or even the world. Every book\'s journey is a testament to the power of stories, connecting people through shared experiences and perspectives.'),
            const Text(
                '     But Wild Books goes beyond connecting readers; it\'s a platform to inspire a new culture of reading. Discover the joy of finding a good book in unexpected places, explore different genres, and let your favourite stories touch others.'),
          ],
        ),
      )),
    );
  }
}
