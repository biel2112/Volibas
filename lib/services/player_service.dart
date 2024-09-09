import 'package:volibas/data/player_dao.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/models/positions.dart';

class PlayerService {
  final PlayerDao _playerDao = PlayerDao();

  Future<List<Jogador>> getJogadoresDisponiveis(int timeId) async {
    return await _playerDao.getJogadoresSemTime(timeId);
  }

  Future<List<Jogador>> getJogadoresByTime(int timeId) async {
    return await _playerDao.getJogadoresByTime(timeId);
  }

  Future<List<Jogador>> getJogadores() async {
    return await _playerDao.getJogadores();
  }

  Future<void> deleteJogador(int jogadorId) async {
    await _playerDao.deleteJogador(jogadorId);
  }

  Future<void> insertJogador(Jogador jogador) async {
    await _playerDao.insertJogador(jogador);
  }

  Future<void> updateJogador(Jogador jogador) async {
    await _playerDao.updateJogador(jogador);
  }

  Future<void> adicionarJogadoresAoTime(
      List<Jogador> jogadores, int timeId) async {
    await _playerDao.adicionarJogadoresAoTime(jogadores, timeId);
  }

  Future<void> removerJogadorDoTime(int jogadorId, int timeId) async {
    await _playerDao.removerJogadorDoTime(jogadorId, timeId);
  }

  Future<void> adicionarJogadorDisponivel(int jogadorId) async {
    await _playerDao.adicionarJogadorDisponivel(jogadorId);
  }

  Position stringToPosition(String position) {
    switch (position) {
      case 'Levantador':
        return Position.levantador;
      case 'Central':
        return Position.central;
      case 'Oposto':
        return Position.oposto;
      case 'Ponteiro':
        return Position.ponteiro;
      case 'Libero':
        return Position.libero;
      case 'Nenhum':
        return Position.nenhum;
      default:
        return Position.nenhum;
    }
  }
}

String positionToString(Position position) {
  switch (position) {
    case Position.levantador:
      return 'Levantador';
    case Position.central:
      return 'Central';
    case Position.oposto:
      return 'Oposto';
    case Position.ponteiro:
      return 'Ponteiro';
    case Position.libero:
      return 'Libero';
    case Position.nenhum:
      return 'Nenhum';
    default:
      return 'Desconhecido';
  }
}
