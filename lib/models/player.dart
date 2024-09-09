import 'package:volibas/models/positions.dart';

class Jogador {
  int? id;
  String nome;
  Position posicao;
  int? timeId;

  Jogador({
    this.id,
    required this.nome,
    required this.posicao,
    this.timeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'posicao': posicao.index,
      'timeId': timeId,
    };
  }

  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      nome: map['nome'],
      posicao: Position.values[map['posicao']],
      timeId: map['timeId'],
    );
  }
}
