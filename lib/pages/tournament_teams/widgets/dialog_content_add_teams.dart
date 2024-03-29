import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';
import 'package:form_it/widgets/app_check_box.dart';
import 'package:repositories/repositories.dart';

class DialogContentAddTeams extends StatefulWidget {
  final List<Team> teams;
  final List<Team>? teamsAdded;

  late final List<CheckBoxListTileModel> checkBoxListTileModel;

  DialogContentAddTeams({Key? key, required this.teams, this.teamsAdded}) : super(key: key) {
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
  _DialogContentAddTeamsState createState() => _DialogContentAddTeamsState();
}

class _DialogContentAddTeamsState extends State<DialogContentAddTeams> {
  TextEditingController editingController = TextEditingController();
  bool selectAll = false;
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

  void selectUnselectAll() {
    setState(() {
      selectAll = !selectAll;
      for (CheckBoxListTileModel item in items) {
        item.isCheck = selectAll;
      }
    });
  }

  @override
  void initState() {
    items.addAll(widget.checkBoxListTileModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      constraints: BoxConstraints(minWidth: 50, maxWidth: 350),
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: getBorderDivider(context),
            )),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
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
                      focusColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(
                          color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Theme.of(context).dividerColor),
                      hintText: MaterialLocalizations.of(context).searchFieldLabel,
                      prefixIcon: Icon(Icons.search,
                          size: 20,
                          color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Theme.of(context).dividerColor),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: AppCheckbox(
                        value: selectAll,
                        onChanged: (val) {
                          selectUnselectAll();
                        },
                        padding: EdgeInsets.all(3),
                        style: AppCheckboxStyle(
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
                          selectedColor:
                              Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightBlue : Theme.of(context).colorScheme.secondary,
                          disabledColor: Theme.of(context).primaryColor,
                          unselectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                              ? DarkColorAccent
                              : Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        AppLocalizations.of(context)!.selectAll,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
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
                          selectedColor:
                              Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor,
                          unselectedColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                              ? DarkColorAccent
                              : Theme.of(context).primaryColorLight,
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
      if (teamsChecked == null) {
        result.add(CheckBoxListTileModel(team: team, isCheck: false));
      } else {
        result.add(CheckBoxListTileModel(team: team, isCheck: teamsChecked.contains(team)));
      }
    }
    return result;
  }
}
