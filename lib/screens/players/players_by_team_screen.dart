import 'package:flutter/material.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/models/team.dart';
import 'package:volibas/screens/players/available_players_screen.dart';
import 'package:volibas/services/player_service.dart';
import 'package:volibas/utils/utils.dart';

class TelaJogadoresPorTime extends StatefulWidget {
  final Time time;

  const TelaJogadoresPorTime({super.key, required this.time});

  @override
  // ignore: library_private_types_in_public_api
  _TelaJogadoresPorTimeState createState() => _TelaJogadoresPorTimeState();
}

class _TelaJogadoresPorTimeState extends State<TelaJogadoresPorTime> {
  List<Jogador> jogadores = [];
  final int maxJogadores = 6;
  final PlayerService _playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    _carregarJogadores();
  }

  void _carregarJogadores() async {
    final data = await _playerService.getJogadoresByTime(widget.time.id!);
    setState(() {
      jogadores = data;
    });
  }

  void _removerJogador(Jogador jogador) async {
    await _playerService.removerJogadorDoTime(jogador.id!, widget.time.id!);
    await _playerService.adicionarJogadorDisponivel(jogador.id!);
    _carregarJogadores();
  }

  void _adicionarJogadores() async {
    if (jogadores.length >= maxJogadores) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Limite Atingido'),
          content: Text(
              'O time já tem o número máximo de jogadores ($maxJogadores).'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaJogadoresDisponiveis(time: widget.time),
      ),
    );
    if (resultado == true) {
      _carregarJogadores();
    }
  }

  Future<void> _mostrarLimiteAtingidoDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limite Atingido', textAlign: TextAlign.center),
        content: Text(
          'O time já tem o número máximo de jogadores ($maxJogadores).',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool podeAdicionarJogadores = jogadores.length < maxJogadores;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jogadores do ${widget.time.nome}',
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 24, 156),
      ),
      body: jogadores.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhum jogador encontrado para este time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: jogadores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jogadores[index].nome),
                  subtitle: Text(
                      'Posição: ${positionToString(jogadores[index].posicao)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      _removerJogador(jogadores[index]);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: podeAdicionarJogadores
            ? _adicionarJogadores
            : _mostrarLimiteAtingidoDialog,
        tooltip: 'Adicionar Jogadores',
        backgroundColor: AppColors.azulMikasa,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
