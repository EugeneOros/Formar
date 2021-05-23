import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/widgets/app_check_box.dart';
import 'package:form_it/pages/players/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';

class DialogAddPlayers extends StatefulWidget {
  final List<Player> players;
  final List<Player>? playersAdded;

  late final List<CheckBoxListTileModel> checkBoxListTileModel;

  DialogAddPlayers({Key? key, required this.players, this.playersAdded}) : super(key: key) {
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
  _DialogAddPlayersState createState() => _DialogAddPlayersState();
}

class _DialogAddPlayersState extends State<DialogAddPlayers> {
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
    return Container(
      constraints: BoxConstraints(minWidth: 50, maxWidth: 350),
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          TextField(
            style: Theme.of(context).textTheme.bodyText2,
            scrollPadding: EdgeInsets.all(0.0),
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: editingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              filled: true,
              fillColor: Colors.transparent,
              hintText: MaterialLocalizations.of(context).searchFieldLabel,
              hintStyle:
                  TextStyle(color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Theme.of(context).dividerColor),
              prefixIcon: Icon(Icons.search,
                  size: 20, color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Theme.of(context).dividerColor),
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
                return ListTile(
                  // activeColor: Colors.black,
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
                      AppCheckbox(
                        value: items[index].isCheck,
                        onChanged: (val) {
                          itemChange(val!, index);
                        },
                        padding: EdgeInsets.all(3),
                        style: AppCheckboxStyle(
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                          selectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor,
                          unselectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).primaryColorLight,
                        ),
                      )
                    ],
                  ),

                  // value: items[index].isCheck,
                  // onChanged: (val) {
                  //   itemChange(val!, index);
                  // },
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
