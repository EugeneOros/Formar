import 'package:flutter/material.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';

class AddPlayersList extends StatefulWidget {
  final List<Player> players;
  final List<Player>? playersAdded;

  late List<CheckBoxListTileModel> checkBoxListTileModel;

  AddPlayersList({Key? key, required this.players, this.playersAdded}) : super(key: key) {
    checkBoxListTileModel = CheckBoxListTileModel.getFromPlayers(players, playersAdded);
  }

  List<Player> getPlayers() {
    List<Player> players = [];
    for (CheckBoxListTileModel c in checkBoxListTileModel) {
      if (c.isCheck) players.add(c.player);
    }
    return players;
  }

  @override
  _AddPlayersListState createState() => _AddPlayersListState();
}

class _AddPlayersListState extends State<AddPlayersList> {
  TextEditingController editingController = TextEditingController();

  List<CheckBoxListTileModel> items = [];

  void filterSearchResults(String query) {
    List<CheckBoxListTileModel> dummySearchList = [];
    dummySearchList.addAll(widget.checkBoxListTileModel);
    if(query.isNotEmpty) {
      List<CheckBoxListTileModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.player.nickname.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.checkBoxListTileModel);
      });
    }

  }

  @override
  void initState() {
    items.addAll(widget.checkBoxListTileModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // items.addAll(widget.checkBoxListTileModel);
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Row(
                    children: [
                      PlayerIndicator(
                        player: items[index].player,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          items[index].player.nickname,
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  value: items[index].isCheck,
                  onChanged: (val) {
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
      items[index].isCheck = val;
    });
  }
}

class CheckBoxListTileModel {
  Player player;
  bool isCheck;

  CheckBoxListTileModel({required this.player, required this.isCheck});

  static List<CheckBoxListTileModel> getFromPlayers(List<Player> playersAll, List<Player>? playersChecked) {
    List<CheckBoxListTileModel> result = [];
    for (Player player in playersAll) {
      playersChecked == null
          ? result.add(CheckBoxListTileModel(player: player, isCheck: false))
          : result.add(CheckBoxListTileModel(player: player, isCheck: playersChecked.contains(player) ? true : false));
    }
    return result;
  }
}
