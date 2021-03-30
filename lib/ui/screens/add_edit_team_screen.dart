import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/ui/widgets/add_players.dart';
import 'package:form_it/ui/widgets/app_dialog.dart';
import 'package:form_it/ui/widgets/fade_end_listview.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:repositories/repositories.dart';

typedef OnSaveCallback = Function(String? name, List<Player>? players);

class AddEditTeamScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Team? team;
  final List<Player> players;

  AddEditTeamScreen({
    Key? key,
    required this.onSave,
    required this.isEditing,
    this.team,
    required this.players,
  }) : super(key: key);

  @override
  _AddEditTeamScreenState createState() => _AddEditTeamScreenState();
}

class _AddEditTeamScreenState extends State<AddEditTeamScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name;
  List<Player>? _players;

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _players = widget.team == null ? [] : List.from(widget.team!.players);
  }

  @override
  Widget build(BuildContext context) {
    _onAddPlayer() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          AddPlayersList _addPlayersList = AddPlayersList(
            players: widget.players,
            playersAdded: _players,
          );
          return AppDialog(
            title: AppLocalizations.of(context)!.chosePlayers,
            content: _addPlayersList,
            actionsHorizontal: [
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.ok,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  setState(() {
                    _players = _addPlayersList.getPlayers();
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
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

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSave(_name, _players);
                Navigator.pop(context);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Text(
                isEditing ? AppLocalizations.of(context)!.done : AppLocalizations.of(context)!.add,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30, top: 30),
                    child: Text(
                      isEditing ? AppLocalizations.of(context)!.editTeam : AppLocalizations.of(context)!.addTeam,
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RoundedInputField(
                      icon: Icons.person,
                      autofocus: !isEditing,
                      initialValue: isEditing ? widget.team!.name : '',
                      onSaved: (value) => _name = value,
                      hintText: AppLocalizations.of(context)!.email,
                      validator: (val) {
                        return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                      },
                    ),
                  ),
                  _players!.isEmpty
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
                              padding: EdgeInsets.all(20.0),
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
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _players!.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      PlayerIndicator(player: _players![index]),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          _players![index].nickname,
                                          style: Theme.of(context).textTheme.bodyText2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // Spacer(),
                                      IconButton(
                                        padding: new EdgeInsets.all(0.0),
                                        icon: Icon(
                                          Icons.close,
                                          size: 15,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _players!.removeAt(index);
                                          });
                                        },
                                      )
                                    ],
                                  );
                                },
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
                        )
                ],
              ),
            ),
            FadeEndLIstView(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor,
            ),
            FadeEndLIstView(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              fromTopToBottom: false,
            ),
          ],
        ),
      ),
    );
  }
}
