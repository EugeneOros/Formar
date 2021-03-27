import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';


class AddPlayersList extends StatefulWidget {
  final List<Player> players;
  final List<Player>? playersAdded;

  late List<CheckBoxListTileModel> checkBoxListTileModel;


  AddPlayersList({Key? key, required this.players, this.playersAdded}) : super(key: key){
    checkBoxListTileModel = CheckBoxListTileModel.getFromPlayers(players, playersAdded);
  }

  List<Player> getPlayers(){
    List<Player> players = [];
    for(CheckBoxListTileModel c in checkBoxListTileModel){
      if(c.isCheck)
        players.add(c.player);
    }
    return players;
  }

  @override
  _AddPlayersListState createState() => _AddPlayersListState();
}

class _AddPlayersListState extends State<AddPlayersList> {
  // late List<CheckBoxListTileModel> checkBoxListTileModel;

  // @override
  // void initState() {
  //   // checkBoxListTileModel = CheckBoxListTileModel.getFromPlayers(widget.players, widget.playersAdded);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: widget.checkBoxListTileModel.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(widget.checkBoxListTileModel[index].player.nickname),
                  value: widget.checkBoxListTileModel[index].isCheck,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged:(val) {
                    itemChange(val!, index);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
  void itemChange(bool val, int index) {
    setState(() {
      widget.checkBoxListTileModel[index].isCheck = val;
    });
  }
}

class CheckBoxListTileModel {
  Player player;
  bool isCheck;

  CheckBoxListTileModel({required this.player, required this.isCheck});

  static List<CheckBoxListTileModel> getFromPlayers(List<Player> playersAll, List<Player>? playersChecked) {
    List<CheckBoxListTileModel> result = [];
    for(Player player in playersAll ){
      playersChecked == null ?  result.add(CheckBoxListTileModel(player: player, isCheck: false)) :
      result.add(CheckBoxListTileModel(player: player, isCheck: playersChecked.contains(player) ? true : false));
    }
    return result;
  }
}