import 'package:flutter/material.dart';
import 'package:volibas/models/team.dart';
import 'package:volibas/services/team_service.dart';
import 'package:volibas/utils/utils.dart';

class TelaFormularioTime extends StatefulWidget {
  const TelaFormularioTime({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaFormularioTimeState createState() => _TelaFormularioTimeState();
}

class _TelaFormularioTimeState extends State<TelaFormularioTime> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? cidade;

  final TeamService _teamService = TeamService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adicionar Time',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 17, 24, 156),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
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
                onSaved: (value) {
                  nome = value;
                },
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final time = Time(nome: nome!);

                    await _teamService.insertTime(time);

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Salvar', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
