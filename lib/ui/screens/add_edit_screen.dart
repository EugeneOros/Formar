// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:people_repository/people_repository.dart';

typedef OnSaveCallback = Function(String task, String note);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Person person;

  AddEditScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.person,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _task;
  String _note;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                  "Add person",
                  style: TextStyle(
                      fontFamily: 'Navicons',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                cursorColor: Colors.black,
                initialValue: isEditing ? widget.person.task : '',
                autofocus: !isEditing,
                decoration: InputDecoration(
                  hintText: 'Enter person nickname',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person, color: PrimaryColor),
                  border: borderRoundedTransparent,
                  focusedBorder: borderRoundedTransparent,
                  enabledBorder: borderRoundedTransparent,
                ),
                validator: (val) {
                  return val.trim().isEmpty ? 'Please enter some text' : null;
                },
                onSaved: (value) => _task = value,
              ),
              TextFormField(
                initialValue: isEditing ? widget.person.note : '',
                maxLines: 10,
                style: textTheme.subtitle1,
                decoration: InputDecoration(
                  hintText: 'Additional Notes...',
                ),
                onSaved: (value) => _note = value,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? 'Save changes' : 'Add Todo',
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSave(_task, _note);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
