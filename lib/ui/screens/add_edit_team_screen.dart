import 'package:flutter_svg/svg.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/widgets/dialog.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/select_players_dialog.dart';
import 'package:repositories/repositories.dart';

typedef OnSaveCallback = Function(String? name, List<Player>? players);

class AddEditTeamScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Team? team;

  AddEditTeamScreen({
    Key? key,
    required this.onSave,
    required this.isEditing,
    this.team,
  }) : super(key: key);

  @override
  _AddEditTeamScreenState createState() => _AddEditTeamScreenState();
}

class _AddEditTeamScreenState extends State<AddEditTeamScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name;
  List<Player>? _players;
  String _selectedId = 'One';

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _players = widget.team == null ? [] : List.from(widget.team!.players);
    // _name = widget.team == null ? null : widget.team!.name;
  }

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  void _onAddPlayers(List<Player> players){
    setState(() {
      _players = _players;
    });
  }

  @override
  Widget build(BuildContext context) {
    _onAddPlayer() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
            onValueChange: _onValueChange,
            initialValue: _selectedId,
          );
        },
      );
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return FunkyOverlay(
      //         title: "Вибрати гравців",
      //         actions: [
      //           TextButton(
      //             child: Text(
      //               AppLocalizations.of(context)!.cancel,
      //               style: Theme.of(context).textTheme.button,
      //             ),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //       );
      //     });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
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
                isEditing ? "Done" : "Add",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  isEditing ? AppLocalizations.of(context)!.editPerson : AppLocalizations.of(context)!.addPerson,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2,
                cursorColor: Colors.black,
                initialValue: isEditing ? widget.team!.name : '',
                autofocus: !isEditing,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterNickname,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person, color: PrimaryColor),
                  border: borderRoundedTransparent,
                  focusedBorder: borderRoundedTransparent,
                  enabledBorder: borderRoundedTransparent,
                ),
                validator: (val) {
                  return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                },
                onSaved: (value) => _name = value,
              ),
              _players!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: RoundedButton(
                        text: "Додати гравця",
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
                          margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 20, bottom: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
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
                        ),
                        Positioned.fill(
                          bottom: 10,
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
      ),
    );
  }
}
