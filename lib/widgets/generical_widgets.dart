import 'package:flutter/material.dart';
import 'package:volibas/models/player.dart';
import 'package:volibas/services/player_service.dart';
import 'package:volibas/utils/utils.dart';

class BotaoInicial extends StatelessWidget {
  final String nomeBotao;
  final IconData iconeBotao;
  const BotaoInicial({
    super.key,
    required this.nomeBotao,
    required this.iconeBotao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: AppColors.amareloMikasa,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10)),
      width: 150,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconeBotao,
            size: 40,
            color: AppColors.azulMikasa,
          ),
          Text(
            nomeBotao,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.azulMikasa),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.jogador,
  });

  final Jogador jogador;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      elevation: 5,
      color: AppColors.amareloMikasa,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: AppColors.azulMikasa,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            jogador.nome,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            'Posição: ${positionToString(jogador.posicao)}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
