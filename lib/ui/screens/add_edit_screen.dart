import 'package:flutter_svg/svg.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:repositories/repositories.dart';

typedef OnSaveCallback = Function(String? nickname, Level? level, Sex? sex);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Player? person;

  AddEditScreen({
    Key? key,
    required this.onSave,
    required this.isEditing,
    this.person,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _nickname;
  Level? _level;
  Sex? _sex;

  bool get isEditing => widget.isEditing;

  void onRadioChanged(Level? level) {
    setState(() {
      _level = level;
    });
  }

  void onSexChanged(Sex? sex) {
    setState(() {
      _sex = sex;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.person == null) {
      _level = Level.beginner;
      _sex = Sex.man;
    } else {
      _level = widget.person!.level;
      _sex = widget.person!.sex;
    }
  }

  @override
  Widget build(BuildContext context) {
    String _getLevelName(Level level) {
      switch (level) {
        case Level.beginner:
          return AppLocalizations.of(context)!.beginner;
        case Level.intermediate:
          return AppLocalizations.of(context)!.intermediate;
        case Level.proficient:
          return AppLocalizations.of(context)!.proficient;
        case Level.advanced:
          return AppLocalizations.of(context)!.advanced;
        case Level.expert:
          return AppLocalizations.of(context)!.expert;
        default:
          return "";
      }
    }

    Color _getLevelColor(Level level) {
      switch (level) {
        case Level.beginner:
          return BeginnerColor;
        case Level.intermediate:
          return IntermediateColor;
        case Level.proficient:
          return ProficientColor;
        case Level.advanced:
          return AdvancedColor;
        case Level.expert:
          return ExpertColor;
        default:
          return Colors.black;
      }
    }

    SvgPicture _getSvgPicture(Sex sex) {
      switch (sex) {
        case Sex.man:
          return SvgPicture.asset(sex == _sex ? "assets/man_fill.svg" : "assets/man_empty.svg");
        case Sex.woman:
          return SvgPicture.asset(sex == _sex ? "assets/woman_fill.svg" : "assets/woman_empty.svg");
      }
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
                initialValue: isEditing ? widget.person!.nickname : '',
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
                onSaved: (value) => _nickname = value,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: Sex.values
                    .map(
                      (sex) => Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () => onSexChanged(sex),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.transparent,
                        child: _getSvgPicture(sex),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),

              Column(
                children: Level.values
                    .map(
                      (level) => RadioListTile(
                        onChanged: (Level? l) => onRadioChanged(l),
                        value: level,
                        groupValue: _level,
                        activeColor: _getLevelColor(level),
                        title: Text(_getLevelName(level), style: Theme.of(context).textTheme.bodyText2),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            isEditing ? Icons.check : Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSave(_nickname, _level, _sex);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
