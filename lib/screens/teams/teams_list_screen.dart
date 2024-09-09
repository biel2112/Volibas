import 'dart:math';

import 'package:flutter/material.dart';
import 'package:volibas/models/team.dart';
import 'package:volibas/screens/players/players_by_team_screen.dart';
import 'package:volibas/screens/teams/edit_team_screen.dart';
import 'package:volibas/services/team_service.dart';
import 'package:volibas/utils/utils.dart';

class TelaListaTimes extends StatefulWidget {
  const TelaListaTimes({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaListaTimesState createState() => _TelaListaTimesState();
}

class _TelaListaTimesState extends State<TelaListaTimes> {
  List<Time> times = [];
  final TeamService _teamService = TeamService();

  @override
  void initState() {
    super.initState();
    _carregarTimes();
  }

  Future<void> _carregarTimes() async {
    final data = await _teamService.getTimes();
    setState(() {
      times = data;
    });
  }

  void _excluirTime(int timeId) async {
    await _teamService.deleteTime(timeId);
    await _carregarTimes();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Time excluído com sucesso!')),
    );
  }

  void _editarTime(Time time) async {
    bool? atualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaEditarTime(time: time),
      ),
    );

    if (atualizado == true) {
      await _carregarTimes();
    }
  }

  void _navegarParaJogadores(Time time) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaJogadoresPorTime(time: time),
      ),
    );
    await _carregarTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Times',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 24, 156),
      ),
      body: ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];

          return Dismissible(
            key: Key(time.id.toString()),
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
                _editarTime(time);
                return false;
              } else if (direction == DismissDirection.endToStart) {
                final bool confirm = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirmar Exclusão'),
                      content: Text(
                          'Tem certeza que deseja excluir o time "${time.nome}"?'),
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
                if (confirm) {
                  _excluirTime(time.id!);
                  return true;
                }
                return false;
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                elevation: 5,
                color: _gerarCorAleatoria(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: AppColors.azulMikasa,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Stack(
                      children: [
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Text(
                            time.nome,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Text(
                          time.nome,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _navegarParaJogadores(time);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(context, '/form-time');

          if (resultado == true) {
            _carregarTimes();
          }
        },
        elevation: 5,
        tooltip: 'Adicionar Time',
        backgroundColor: AppColors.azulMikasa,
        child: const Icon(
          Icons.add,
          size: 30,
          color: AppColors.amareloMikasa,
        ),
      ),
    );
  }
}

Color _gerarCorAleatoria() {
  final random = Random();
  return Color.fromARGB(
      255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
}
