import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // O método build é chamado automaticamente sempre que as circunstâncias do widget mudam, para que ele fique sempre atualizado.
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    // Garante a atualização da interface.
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      // Chamar copyWith() em displayMedium retorna uma cópia do estilo de texto com as mudanças definidas. Neste caso, eu estou apenas mudando a cor do texto.
      color: theme.colorScheme.onPrimary,
      fontStyle: FontStyle.italic,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // Acessibilidade.
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text(
          "No favorites yet.",
          style: style,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "You have ${appState.favorites.length} favorites:",
              style: style,
            ),
          ),
          for (var i = 0; i < appState.favorites.length; i++)
            CardFavorite(index: i, pair: appState.favorites[i]),
        ],
      ),
    );
  }
}

class CardFavorite extends StatelessWidget {
  final WordPair pair;
  final int index;

  const CardFavorite({super.key, required this.pair, required this.index});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var appState = context.watch<MyAppState>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withAlpha(75),
            border:
                Border.all(color: theme.colorScheme.secondary.withAlpha(125)),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: theme.colorScheme.shadow.withAlpha(20),
                  blurRadius: 8,
                  offset: Offset(3, 3)),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withAlpha(75),
                    border: Border.all(
                        color: theme.colorScheme.secondary.withAlpha(125)),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pair.asLowerCase,
                    style: style.copyWith(color: Colors.black54),
                  ),
                  IconButton(
                      onPressed: () {
                        appState.favorites.remove(pair);
                        appState.notifyListeners();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black54,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
