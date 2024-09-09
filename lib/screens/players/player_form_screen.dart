import 'package:flutter/material.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/models/positions.dart';
import 'package:volibas/services/player_service.dart';
import 'package:volibas/utils/utils.dart';

class TelaFormularioJogador extends StatefulWidget {
  const TelaFormularioJogador({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaFormularioJogadorState createState() => _TelaFormularioJogadorState();
}

class _TelaFormularioJogadorState extends State<TelaFormularioJogador> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  Position? posicao;
  final PlayerService _playerService = PlayerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicionar Jogador',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 24, 156),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.azulMikasa,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 247, 244, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    fillColor: AppColors.amareloMikasa,
                    filled: true,
                    hintText: 'Digite o nome do jogador',
                    hintStyle: const TextStyle(color: Colors.black87),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Colors.blueGrey, width: 3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 3.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    errorStyle: const TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onSaved: (value) {
                    nome = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do jogador';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Position>(
                  decoration: const InputDecoration(
                    labelText: 'Posição',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    fillColor: AppColors.amareloMikasa,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                  value: posicao,
                  items: Position.values.map((Position pos) {
                    return DropdownMenuItem<Position>(
                      value: pos,
                      child: Text(
                        positionToString(pos),
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (Position? newValue) {
                    setState(() {
                      posicao = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma posição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final jogador = Jogador(nome: nome!, posicao: posicao!);
                      _playerService.insertJogador(jogador);
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: AppColors.amareloMikasa,
                    shadowColor: Colors.black54,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
