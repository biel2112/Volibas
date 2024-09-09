import 'package:flutter/material.dart';
import 'package:volibas/screens/initial_screen.dart';
import 'package:volibas/screens/players/player_form_screen.dart';
import 'package:volibas/screens/players/player_list_screen.dart';
import 'package:volibas/screens/teams/teams_form_screen.dart';
import 'package:volibas/screens/teams/teams_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volibas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      home: const InitialScreen(),
      routes: {
        '/form-jogador': (context) => const TelaFormularioJogador(),
        '/lista-jogadores': (context) => const TelaListaJogadores(),
        '/form-time': (context) => const TelaFormularioTime(),
        '/lista-times': (context) => const TelaListaTimes(),
      },
    );
  }
}
