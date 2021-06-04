import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:form_it/config/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/widgets/fade_end_listview.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:form_it/widgets/rounded_input_field.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/config/helpers.dart';

import 'package:form_it/pages/add_edit_player/widgets/widgets.dart';

typedef OnSaveCallback = Function(String? nickname, Level? level, Sex? sex);

class AddEditPlayerPage extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Player? player;

  AddEditPlayerPage({
    Key? key,
    required this.onSave,
    required this.isEditing,
    this.player,
  }) : super(key: key);

  @override
  _AddEditPlayerPageState createState() => _AddEditPlayerPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _AddEditPlayerPageState extends State<AddEditPlayerPage> {

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
    if (widget.player != null) {
      _level = widget.player!.level;
      _sex = widget.player!.sex;
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
          onPressed: () => Navigator.pop(
            context,
            false,
          ),
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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // DefaultTextStyle(
                  //   style: Theme.of(context).textTheme.headline1!,
                  //   child: AnimatedTextKit(
                  //     animatedTexts: [
                  //       TyperAnimatedText(isEditing ? AppLocalizations.of(context)!.editPlayer : AppLocalizations.of(context)!.addPlayer,),
                  //     ],
                  //     repeatForever: false,
                  //     isRepeatingAnimation: false,
                  //   ),
                  // ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child:
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline1!,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(isEditing ? AppLocalizations.of(context)!.editPlayer : AppLocalizations.of(context)!.addPlayer, speed: Duration(milliseconds: 100))
                        ],
                        repeatForever: false,
                        isRepeatingAnimation: false,
                      ),
                    ),
                    // Text(
                    //   isEditing ? AppLocalizations.of(context)!.editPlayer : AppLocalizations.of(context)!.addPlayer,
                    //   style: Theme.of(context).textTheme.headline1,
                    //   textAlign: TextAlign.center,
                    // ),
                  ),
                  RoundedInputField(
                    name: AppLocalizations.of(context)!.nickname,
                    autofocus: !isEditing,
                    initialValue: isEditing ? widget.player!.nickname : '',
                    onSaved: (value) => _nickname = value,
                    hintText: AppLocalizations.of(context)!.enterNickname,
                    validator: (val) {
                      return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                    },
                    radius: 15,
                  ),
                  LevelPicker(level: _level, onLevelChanged: onLevelChanged),
                  SexPicker(
                    sex: _sex,
                    onSexChanged: onSexChanged,
                    heroTag: widget.player != null ? ("playerItem" + widget.player!.id!) : null,
                  )
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
