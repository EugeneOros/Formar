import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/pages/add_edit_team/widgets/item_member.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/power.dart';
import 'package:form_it/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:repositories/repositories.dart';

import 'dialog_add_players.dart';

typedef void OnAddPlayersCallback(List<Player> newPlayers);

class MemberList extends StatefulWidget {
  final List<Player> members;
  final OnAddPlayersCallback onAddPlayersCallback;

  const MemberList({Key? key, required this.onAddPlayersCallback, required this.members}) : super(key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {
    final playersAll = Provider.of<List<Player>>(context);

    _onAddPlayer() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          DialogAddPlayers _dialogAddPlayers = DialogAddPlayers(
            players: playersAll,
            playersAdded: widget.members,
          );
          return AppDialog(
            title: AppLocalizations.of(context)!.chosePlayers,
            content: _dialogAddPlayers,
            actionsHorizontal: [
              TextButton(
                child: Text(
                  MaterialLocalizations.of(context).okButtonLabel,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  widget.onAddPlayersCallback(_dialogAddPlayers.getPlayers());
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel.toLowerCase().capitalize(),
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    int getPower(List<Player> players) {
      int power = 0;
      for (Player player in widget.members) {
        power += player.level.index + 1;
      }
      return power;
    }

    return widget.members.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RoundedButton(
              text: AppLocalizations.of(context)!.addPlayers,
              textColor: Colors.black,
              color: Theme.of(context).accentColor,
              sizeRatio: 0.9,
              onPressed: () {
                _onAddPlayer();
              },
            ),
          )
        : Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 60),
                // padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(2, 2),
                    )
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft, padding: EdgeInsets.only(left: 10, top: 10), child: Power(power: getPower(widget.members))),
                    Padding(
                      padding: const EdgeInsets.all(27).copyWith(top: 0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.members.length,
                        itemBuilder: (context, index) {
                          return ItemMember(
                            member: widget.members[index],
                            onDelete: () {
                              setState(() {
                                widget.members.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                bottom: 30,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _onAddPlayer();
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
