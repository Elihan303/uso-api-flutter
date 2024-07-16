import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  Future<Map<String, dynamic>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1'),
      headers: {
        'Authorization': 'Bearer {token}',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obteniendo la pelicula'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> movies = snapshot.data!;
              List<dynamic> results = movies['results'];
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(results[index]['title'] ?? 'No title'),
                    subtitle: Text('ID: ${results[index]['id']}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //         title: const Text("Consulta de peliculas"),
  //       ),
  //       body: const Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               'You have pushed the button this many times:',
  //             ),
  //           ],
  //         ),
  //       ));
  // }
}
