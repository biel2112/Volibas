import 'package:flutter/material.dart';
import 'package:volibas/models/team.dart';
import 'package:volibas/services/team_service.dart';
import 'package:volibas/utils/utils.dart';

class TelaEditarTime extends StatefulWidget {
  final Time time;

  const TelaEditarTime({super.key, required this.time});

  @override
  // ignore: library_private_types_in_public_api
  _TelaEditarTimeState createState() => _TelaEditarTimeState();
}

class _TelaEditarTimeState extends State<TelaEditarTime> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  final TeamService _teamService = TeamService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.time.nome);
  }

  void _salvarEdicao() async {
    if (_formKey.currentState!.validate()) {
      Time timeAtualizado = Time(
        id: widget.time.id,
        nome: _nomeController.text,
      );

      await _teamService.updateTime(timeAtualizado);

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Time',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  fillColor: AppColors.amareloMikasa,
                  filled: true,
                  hintText: 'Digite o nome do time',
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
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  errorStyle: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStateColor.transparent),
                onPressed: _salvarEdicao,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
