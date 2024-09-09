import 'package:flutter/material.dart';
import 'package:volibas/utils/utils.dart';
import 'package:volibas/widgets/generical_widgets.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.azulMikasa,
        title: const Text(
          'Bem-Vindo!!',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: AppColors.amareloMikasa,
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10)),
                width: 400,
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.sports_volleyball,
                      size: 100,
                      color: AppColors.azulMikasa,
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: AppColors.azulMikasa,
                      width: 400,
                      height: 80,
                      child: const Text(
                        'Volibas',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/form-jogador');
                    },
                    child: const BotaoInicial(
                        nomeBotao: 'Adicionar Jogador',
                        iconeBotao: Icons.person_add),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/lista-jogadores');
                      },
                      child: const BotaoInicial(
                          nomeBotao: 'Jogadores', iconeBotao: Icons.people)),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/form-time');
                      },
                      child: const BotaoInicial(
                          nomeBotao: 'Adicionar Time',
                          iconeBotao: Icons.shield)),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/lista-times');
                      },
                      child: const BotaoInicial(
                          nomeBotao: 'Lista de Times',
                          iconeBotao: Icons.shield)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
