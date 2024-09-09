import 'package:sqflite/sqflite.dart';
import 'package:volibas/data/database_helper.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/models/team.dart';

class TeamDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTime(Time time) async {
    Database db = await _dbHelper.database;
    return await db.insert('times', time.toMap());
  }

  Future<List<Time>> getTimes() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('times');
    return maps.map((map) => Time.fromMap(map)).toList();
  }

  Future<int> updateTime(Time time) async {
    final db = await _dbHelper.database;
    return await db.update(
      'times',
      time.toMap(),
      where: 'id = ?',
      whereArgs: [time.id],
    );
  }

  Future<int> deleteTime(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'times',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> adicionarJogadoresAoTime(
      List<Jogador> jogadores, int timeId) async {
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

  Future<int> getNumeroJogadoresPorTime(int timeId) async {
    final db = await _dbHelper.database;
    var res = await db
        .rawQuery('SELECT COUNT(*) FROM jogadores WHERE timeId = ?', [timeId]);
    int count = Sqflite.firstIntValue(res) ?? 0;
    return count;
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
