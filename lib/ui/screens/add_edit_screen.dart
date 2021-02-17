import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:people_repository/people_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnSaveCallback = Function(String nickname, Level level);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Person person;
  Level _groutValue;

  AddEditScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.person,
  }) : super(key: key){
    if(person == null){
      _groutValue = Level.beginner;
    }else{
      _groutValue = person.level;
    }
  }

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _task;
  String _note;

  bool get isEditing => widget.isEditing;

  void onRadioChanged(Level level) {
    setState(() {
      for (Level lev in Level.values) {
        if (level == lev) {
          widget._groutValue = lev;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondaryBlueColor,
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  isEditing ? AppLocalizations.of(context).editPerson : AppLocalizations.of(context).addPerson,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                cursorColor: Colors.black,
                initialValue: isEditing ? widget.person.nickname : '',
                autofocus: !isEditing,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).enterNickname,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person, color: PrimaryColor),
                  border: borderRoundedTransparent,
                  focusedBorder: borderRoundedTransparent,
                  enabledBorder: borderRoundedTransparent,
                ),
                validator: (val) {
                  return val.trim().isEmpty ? AppLocalizations.of(context).enterSomeText : null;
                },
                onSaved: (value) => _task = value,
              ),

              Column(
                children: [
                  RadioListTile(
                    onChanged: (Level e) => onRadioChanged(e),
                    value: Level.beginner,
                    groupValue: widget._groutValue,
                    activeColor: BeginnerColor,
                    title: Text(AppLocalizations.of(context).beginner),
                  ),
                  RadioListTile(
                      onChanged: (Level e) => onRadioChanged(e),
                      value: Level.intermediate,
                      groupValue: widget._groutValue,
                      activeColor: IntermediateColor,
                      title: Text(AppLocalizations.of(context).intermediate)),
                  RadioListTile(
                    onChanged: (Level e) => onRadioChanged(e),
                    value: Level.proficient,
                    groupValue: widget._groutValue,
                    activeColor: ProficientColor,
                    title: Text(AppLocalizations.of(context).proficient),
                  ),
                  RadioListTile(
                      onChanged: (Level e) => onRadioChanged(e),
                      value: Level.advanced,
                      groupValue: widget._groutValue,
                      activeColor: AdvancedColor,
                      title: Text(AppLocalizations.of(context).advanced)),
                  RadioListTile(
                      onChanged: (Level e) => onRadioChanged(e),
                      value: Level.expert,
                      groupValue: widget._groutValue,
                      activeColor: ExpertColor,
                      title: Text(AppLocalizations.of(context).expert)),
                ],
              )
              // TextFormField(
              //   initialValue: isEditing ? widget.person.note : '',
              //   maxLines: 10,
              //   style: textTheme.subtitle1,
              //   decoration: InputDecoration(
              //     hintText: 'Additional Notes...',
              //   ),
              //   onSaved: (value) => _note = value,
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          backgroundColor: SecondaryColor,
          tooltip: isEditing ? 'Save changes' : 'Add Todo',
          child: Icon(isEditing ? Icons.check : Icons.add, color: Colors.black,),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(_task, widget._groutValue);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
