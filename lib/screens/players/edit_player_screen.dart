import 'package:flutter/material.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/services/player_service.dart';
import 'package:volibas/utils/utils.dart';

class TelaEditarJogador extends StatefulWidget {
  final Jogador jogador;

  const TelaEditarJogador({super.key, required this.jogador});

  @override
  // ignore: library_private_types_in_public_api
  _TelaEditarJogadorState createState() => _TelaEditarJogadorState();
}

class _TelaEditarJogadorState extends State<TelaEditarJogador> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  String? _posicaoSelecionada;
  final PlayerService _playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.jogador.nome);
    _posicaoSelecionada = positionToString(widget.jogador.posicao);
  }

  void _salvarJogador() async {
    if (_formKey.currentState!.validate()) {
      widget.jogador.nome = _nomeController.text;
      widget.jogador.posicao =
          _playerService.stringToPosition(_posicaoSelecionada ?? 'Nenhum');

      await _playerService.updateJogador(widget.jogador);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Jogador',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.azulMikasa,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.azulMikasa,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: _nomeController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _posicaoSelecionada,
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
                    items: [
                      'Levantador',
                      'Central',
                      'Oposto',
                      'Ponteiro',
                      'Libero',
                      'Nenhum'
                    ].map((posicao) {
                      return DropdownMenuItem<String>(
                        value: posicao,
                        child: Text(posicao),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _posicaoSelecionada = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _salvarJogador,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
