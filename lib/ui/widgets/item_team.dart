import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';

import 'fade_end_listview.dart';

class ItemTeam extends StatelessWidget {
  final GestureTapCallback onEdit;
  final Function onDelete;
  final Team team;

  const ItemTeam({Key? key, required this.onEdit, required this.team, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 400),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(2, 2),
            )
          ], borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    top: 13,
                    left: 13,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset("assets/power.svg"),
                        ),
                        Text(
                          team.power.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => onDelete(),
                      icon: Icon(
                        Icons.delete,
                        size: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 35, bottom: 0, right: 20, left: 20),
                    alignment: Alignment.center,
                    child: Text(
                      team.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 0),
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: team.players.length,
                        itemBuilder: (context, index) {
                          final player = team.players[index];
                          return Padding(
                            padding: EdgeInsets.only(top: index == 0 ? 15 : 7),
                            child: Row(children: [
                              PlayerIndicator(player: player),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  player.nickname,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ]),
                          );
                        },
                      ),
                      FadeEndLIstView(
                        height: 15,
                        width: MediaQuery.of(context).size.width,
                      ),
                      FadeEndLIstView(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        fromTopToBottom: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
