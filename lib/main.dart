import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

final pageStateProvider = StateProvider((ref) {
  return 1;
});
final listStateProvider = StateProvider((ref) {
  return fetch(ref.watch(pageStateProvider)) as List;
});
Future<http.Response> fetch(page) {
  return http.get(
      Uri.parse('https://pro-api.coingecko.com/api/v3/nfts/list?page=$page'));
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(listStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('value'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView.builder(
              itemCount: list.length,
              prototypeItem: ListTile(
                title: Text('nft'),
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(list[index].name),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(pageStateProvider.notifier).state++;
          ref.read(listStateProvider.notifier).state = [
            ...list,
            ref.watch(pageStateProvider)
          ];
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
