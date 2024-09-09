import 'package:sqflite/sqflite.dart';
import 'package:volibas/data/database_helper.dart';

class Time {
  int? id;
  String nome;

  Time({
    this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      id: map['id'],
      nome: map['nome'],
    );
  }

  Future<int> numeroJogadores() async {
    final db = await DatabaseHelper().database;
    var res = await db
        .rawQuery('SELECT COUNT(*) FROM jogadores WHERE timeId = ?', [id]);
    int count = Sqflite.firstIntValue(res) ?? 0;
    return count;
  }
}
