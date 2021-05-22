import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/widgets/app_check_box.dart';
import 'package:repositories/repositories.dart';

class DialogAddTeams extends StatefulWidget {
  final List<Team> teams;
  final List<Team>? teamsAdded;

  late final List<CheckBoxListTileModel> checkBoxListTileModel;

  DialogAddTeams({Key? key, required this.teams, this.teamsAdded}) : super(key: key) {
    checkBoxListTileModel = CheckBoxListTileModel.getFromTeams(teams, teamsAdded);
  }

  List<Team> getTeams() {
    List<Team> teams = [];
    for (CheckBoxListTileModel c in checkBoxListTileModel) {
      if (c.isCheck) teams.add(c.team);
    }
    return teams;
  }

  @override
  _DialogAddTeamsState createState() => _DialogAddTeamsState();
}

class _DialogAddTeamsState extends State<DialogAddTeams> {
  TextEditingController editingController = TextEditingController();

  List<CheckBoxListTileModel> items = [];

  void filterSearchResults(String query) {
    List<CheckBoxListTileModel> dummySearchList = [];
    dummySearchList.addAll(widget.checkBoxListTileModel);
    if (query.isNotEmpty) {
      List<CheckBoxListTileModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.team.name.toLowerCase().contains(query.toLowerCase())) {
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
                return ListTile(
                  // activeColor: Colors.black,
                  title: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          items[index].team.name,
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
                          selectedColor: Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor,
                          unselectedColor: Theme.of(context).primaryColorLight,
                        ),
                      )
                    ],
                  ),
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
  Team team;
  bool isCheck;

  CheckBoxListTileModel({required this.team, required this.isCheck});

  static List<CheckBoxListTileModel> getFromTeams(List<Team> teamsAll, List<Team>? teamsChecked) {
    List<CheckBoxListTileModel> result = [];
    for (Team team in teamsAll) {
      teamsChecked == null
          ? result.add(CheckBoxListTileModel(team: team, isCheck: false))
          : result.add(CheckBoxListTileModel(team: team, isCheck: teamsChecked.contains(team) ? true : false));
    }
    return result;
  }
}
