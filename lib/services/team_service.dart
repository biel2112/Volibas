import 'package:volibas/data/team_dao.dart';
import 'package:volibas/models/team.dart';

class TeamService {
  final TeamDao _teamDao = TeamDao();

  Future<List<Time>> getTimes() async {
    return await _teamDao.getTimes();
  }

  Future<void> insertTime(Time time) async {
    await _teamDao.insertTime(time);
  }

  Future<void> updateTime(Time time) async {
    await _teamDao.updateTime(time);
  }

  Future<void> deleteTime(int timeId) async {
    await _teamDao.deleteTime(timeId);
  }
}
