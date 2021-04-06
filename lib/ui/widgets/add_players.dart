import 'package:flutter/material.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';

class AddPlayersList extends StatefulWidget {
  final List<Player> players;
  final List<Player>? playersAdded;

  late final List<CheckBoxListTileModel> checkBoxListTileModel;

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
    if (query.isNotEmpty) {
      List<CheckBoxListTileModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.player.nickname.toLowerCase().contains(query.toLowerCase())) {
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
    var borderSearch = UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
    );
    // items.addAll(widget.checkBoxListTileModel);
    return Container(
      constraints: BoxConstraints(minWidth: 50, maxWidth: 350),
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          TextField(
            style: Theme.of(context).textTheme.bodyText2,
            scrollPadding: EdgeInsets.all(0.0),
            cursorColor: Colors.black,
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: editingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              filled: true,
              fillColor: Colors.transparent,
              hintText: MaterialLocalizations.of(context).searchFieldLabel,
              prefixIcon: Icon(Icons.search, size: 20, color: Theme.of(context).dividerColor),
              border: borderSearch,
              focusedBorder: borderSearch,
              enabledBorder: borderSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  activeColor: Colors.black,
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
