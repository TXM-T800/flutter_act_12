import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, ke});

  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Favorito'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('Favoritos').listenable(),
        builder: (context, box, child) {
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              final isFavorite = box.get(index) != null;
              
              return ListTile(
                title: Text(word),
                trailing: IconButton(
                  onPressed: () {
                    _toggleFavorite(context, box, index, word, isFavorite);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context, Box box, int index, String word, bool isFavorite) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (isFavorite) {
      await box.delete(index);
      // ignore: prefer_const_declarations
      final snackBar = const SnackBar(
        content: Text('Remove Added successfully'),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await box.put(index, word);
      // ignore: prefer_const_declarations
      final snackBar = const SnackBar(
        content: Text('Added successfully'),
        backgroundColor: Colors.blue,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}