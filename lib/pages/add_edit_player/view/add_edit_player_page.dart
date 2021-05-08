import 'package:form_it/config/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/widgets/fade_end_listview.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:form_it/widgets/rounded_input_field.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/config/constants.dart';

import 'package:form_it/pages/add_edit_player/widgets/widgets.dart';

typedef OnSaveCallback = Function(String? nickname, Level? level, Sex? sex);

class AddEditPlayerScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Player? person;

  AddEditPlayerScreen({
    Key? key,
    required this.onSave,
    required this.isEditing,
    this.person,
  }) : super(key: key);

  @override
  _AddEditPlayerScreenState createState() => _AddEditPlayerScreenState();
}

class _AddEditPlayerScreenState extends State<AddEditPlayerScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _nickname;
  Level _level = Level.beginner;
  Sex _sex = Sex.man;

  bool get isEditing => widget.isEditing;

  void onLevelChanged(Level level) {
    setState(() {
      _level = level;
    });
  }

  void onSexChanged(Sex sex) {
    setState(() {
      _sex = sex;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _level = widget.person!.level;
      _sex = widget.person!.sex;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                widget.onSave(_nickname, _level, _sex);
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
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              // Theme.of(context).accentColor,
            ],
          ),
        ),
        child: Stack(children: [
          Container(
            constraints: BoxConstraints(minWidth: 50, maxWidth: 500),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20.0),
                    child: Text(
                      isEditing ? AppLocalizations.of(context)!.editPlayer : AppLocalizations.of(context)!.addPlayer,
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RoundedInputField(
                      name: "Name",
                      autofocus: !isEditing,
                      initialValue: isEditing ? widget.person!.nickname : '',
                      onSaved: (value) => _nickname = value,
                      hintText: AppLocalizations.of(context)!.enterNickname,
                      validator: (val) {
                        return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                      },
                      radius: 15,
                    ),
                  ),
                  LevelPicker(level: _level, onLevelChanged: onLevelChanged),
                  SexPicker(sex: _sex, onSexChanged: onSexChanged)
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
        ]),
      ),
    );
  }
}
