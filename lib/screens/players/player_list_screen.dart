import 'package:flutter/material.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/services/player_service.dart';
import 'package:volibas/screens/players/edit_player_screen.dart';
import 'package:volibas/utils/utils.dart';
import 'package:volibas/widgets/generical_widgets.dart';

class TelaListaJogadores extends StatefulWidget {
  const TelaListaJogadores({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaListaJogadoresState createState() => _TelaListaJogadoresState();
}

class _TelaListaJogadoresState extends State<TelaListaJogadores> {
  List<Jogador> jogadores = [];
  List<Jogador> jogadoresFiltrados = [];
  final PlayerService _playerService = PlayerService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarJogadores();
    _searchController.addListener(_filterJogadores);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _carregarJogadores() async {
    final data = await _playerService.getJogadores();
    setState(() {
      jogadores = data;
      jogadoresFiltrados = jogadores;
    });
  }

  void _filterJogadores() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      jogadoresFiltrados = jogadores.where((jogador) {
        return jogador.nome.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _excluirJogador(int jogadorId) async {
    await _playerService.deleteJogador(jogadorId);
    _carregarJogadores();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jogador excluído com sucesso!')),
    );
  }

  void _editarJogador(Jogador jogador) async {
    bool? atualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaEditarJogador(jogador: jogador),
      ),
    );

    if (atualizado == true) {
      _carregarJogadores();
    }
  }

  Future<bool?> _confirmarExclusao(Jogador jogador) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text(
            'Tem certeza que deseja excluir o jogador "${jogador.nome}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Jogadores',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 24, 156),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar jogador...',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total de Jogadores: ${jogadoresFiltrados.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jogadoresFiltrados.length,
              itemBuilder: (context, index) {
                final jogador = jogadoresFiltrados[index];

                return Dismissible(
                  key: Key(jogador.id.toString()),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _editarJogador(jogador);
                      return false;
                    } else if (direction == DismissDirection.endToStart) {
                      final bool? confirm = await _confirmarExclusao(jogador);
                      if (confirm == true) {
                        _excluirJogador(jogador.id!);
                        return true;
                      }
                      return false;
                    }
                    return false;
                  },
                  child: PlayerCard(jogador: jogador),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(context, '/form-jogador');

          if (resultado == true) {
            _carregarJogadores();
          }
        },
        elevation: 5,
        tooltip: 'Adicionar Jogadores',
        backgroundColor: AppColors.azulMikasa,
        child: const Icon(
          Icons.person_add_alt_1,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
