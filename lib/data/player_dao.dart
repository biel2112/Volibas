import 'package:sqflite/sqflite.dart';
import 'package:volibas/data/database_helper.dart';
import 'package:volibas/models/player.dart';

class PlayerDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertJogador(Jogador jogador) async {
    final db = await _dbHelper.database;
    await db.insert(
      'jogadores',
      jogador.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Jogador>> getJogadores() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('jogadores');
    return List.generate(maps.length, (i) {
      return Jogador.fromMap(maps[i]);
    });
  }

  Future<void> updateJogador(Jogador jogador) async {
    Database db = await _dbHelper.database;
    await db.update(
      'jogadores',
      jogador.toMap(),
      where: 'id = ?',
      whereArgs: [jogador.id],
    );
  }

  Future<void> deleteJogador(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'jogadores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> removerJogadorDoTime(int jogadorId, int timeId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'jogadores_times',
      where: 'jogador_id = ? AND time_id = ?',
      whereArgs: [jogadorId, timeId],
    );
  }

  Future<void> adicionarJogadorDisponivel(int jogadorId) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      'UPDATE jogadores SET disponivel = 1 WHERE id = ?',
      [jogadorId],
    );
  }

   Future<void> adicionarJogadoresAoTime(List<Jogador> jogadores, int timeId) async {
    final db = await _dbHelper.database;
    for (var jogador in jogadores) {
      await db.insert(
        'jogadores_times',
        {
          'jogador_id': jogador.id,
          'time_id': timeId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<List<Jogador>> getJogadoresByTime(int timeId) async {
    final db = await _dbHelper.database;
    var res = await db.rawQuery('''
    SELECT jogadores.* 
    FROM jogadores 
    INNER JOIN jogadores_times 
    ON jogadores.id = jogadores_times.jogador_id 
    WHERE jogadores_times.time_id = ?
    ''', [timeId]);

    List<Jogador> lista =
        res.isNotEmpty ? res.map((j) => Jogador.fromMap(j)).toList() : [];
    return lista;
  }

  Future<List<Jogador>> getJogadoresSemTime(int timeId) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      'jogadores',
      where: 'timeId IS NULL OR timeId != ?',
      whereArgs: [timeId],
    );
    List<Jogador> lista =
        res.isNotEmpty ? res.map((j) => Jogador.fromMap(j)).toList() : [];
    return lista;
  }
}
