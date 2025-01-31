import 'package:volibas/models/positions.dart';

class Jogador {
  int? id;
  String nome;
  Position posicao;
  int? timeId;
  bool inTeam;

  Jogador({
    this.id,
    required this.nome,
    required this.posicao,
    this.timeId,
    this.inTeam = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'posicao': posicao.index,
      'timeId': timeId,
      'inTeam': inTeam ? 1 : 0
    };
  }

  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      nome: map['nome'],
      posicao: Position.values[map['posicao']],
      timeId: map['timeId'],
      inTeam: map['inTeam'] == 1
    );
  }
}
