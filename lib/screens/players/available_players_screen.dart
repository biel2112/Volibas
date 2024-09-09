import 'package:flutter/material.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/models/team.dart';
import 'package:volibas/services/player_service.dart';

class TelaJogadoresDisponiveis extends StatefulWidget {
  final Time time;

  const TelaJogadoresDisponiveis({super.key, required this.time});

  @override
  // ignore: library_private_types_in_public_api
  _TelaJogadoresDisponiveisState createState() =>
      _TelaJogadoresDisponiveisState();
}

class _TelaJogadoresDisponiveisState extends State<TelaJogadoresDisponiveis> {
  List<Jogador> jogadoresDisponiveis = [];
  List<Jogador> jogadoresFiltrados = [];
  List<Jogador> jogadoresSelecionados = [];
  final TextEditingController _searchController = TextEditingController();
  int maxJogadores = 6;
  final PlayerService _playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    _carregarJogadoresDisponiveis();
    _searchController.addListener(_filtrarJogadores);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _carregarJogadoresDisponiveis() async {
    final data = await _playerService.getJogadoresDisponiveis(widget.time.id!);
    setState(() {
      jogadoresDisponiveis = data;
      jogadoresFiltrados = jogadoresDisponiveis;
      jogadoresSelecionados = jogadoresSelecionados
          .where((jogador) => jogadoresDisponiveis.contains(jogador))
          .toList();
    });
  }

  void _filtrarJogadores() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      jogadoresFiltrados = jogadoresDisponiveis
          .where((jogador) => jogador.nome.toLowerCase().contains(query))
          .toList();
    });
  }

  void _adicionarJogadoresAoTime() async {
    final timeAtual = await _playerService.getJogadoresByTime(widget.time.id!);
    final quantidadeAtualJogadores = timeAtual.length;
    final quantidadeSelecionados = jogadoresSelecionados.length;
    final quantidadeMaxima = maxJogadores - quantidadeAtualJogadores;

    if (quantidadeSelecionados > quantidadeMaxima) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você não pode selecionar mais jogadores. Limite excedido.'),
        ),
      );
      return;
    }

    if (jogadoresSelecionados.isNotEmpty) {
      await _playerService.adicionarJogadoresAoTime(jogadoresSelecionados, widget.time.id!);
      _carregarJogadoresDisponiveis();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicionar Jogadores',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 24, 156),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar jogador',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: jogadoresFiltrados.isEmpty
                ? const Center(child: Text('Nenhum jogador disponível.'))
                : ListView.builder(
                    itemCount: jogadoresFiltrados.length,
                    itemBuilder: (context, index) {
                      final jogador = jogadoresFiltrados[index];
                      final isSelected = jogadoresSelecionados.contains(jogador);

                      return ListTile(
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (jogadoresSelecionados.length < maxJogadores) {
                                  if (jogadoresDisponiveis.contains(jogador)) {
                                    jogadoresSelecionados.add(jogador);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Este jogador não está mais disponível.'),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Você não pode selecionar mais jogadores.'),
                                    ),
                                  );
                                }
                              } else {
                                jogadoresSelecionados.remove(jogador);
                              }
                            });
                          },
                        ),
                        title: Text(jogador.nome),
                        subtitle: Text('Posição: ${positionToString(jogador.posicao)}'),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _adicionarJogadoresAoTime,
              child: const Text('Adicionar Jogadores Selecionados'),
            ),
          ),
        ],
      ),
    );
  }
}
