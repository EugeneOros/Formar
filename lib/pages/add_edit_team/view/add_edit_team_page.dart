import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/widgets/widgets.dart';
import 'package:repositories/repositories.dart';

import 'package:form_it/pages/add_edit_team/widgets/widgets.dart';

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

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _players = widget.team == null ? [] : List.from(widget.team!.players);
  }

  @override
  Widget build(BuildContext context) {

    _onAddPlayer(List<Player> newPlayers){
      setState(() {
        _players = newPlayers;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColorLight,
        leading: IconButtonAppBar(
          icon: Icons.arrow_back_ios_rounded,
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
                MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              // Theme.of(context).accentColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 50, maxWidth: 500),
              child: Form(
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
                        autofocus: !isEditing,
                        initialValue: isEditing ? widget.team!.name : '',
                        onSaved: (value) => _name = value,
                        hintText: AppLocalizations.of(context)!.enterNameTeam,
                        validator: (val) {
                          return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                        },
                      ),
                    ),
                    MemberList(members: _players!, onAddPlayersCallback: _onAddPlayer)
                  ],
                ),
              ),
            ),
            FadeEndLIstView(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColorLight,
            ),
            FadeEndLIstView(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              isTop: false,
            ),
          ],
        ),
      ),
    );
  }
}
