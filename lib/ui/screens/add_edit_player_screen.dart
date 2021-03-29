import 'package:flutter_svg/svg.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:repositories/repositories.dart';

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
                widget.onSave(_nickname, _level, _sex);
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
        // padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
              stops: [0.0, 0.1, 0.9, 1.0], // 10%, 80% transparent, 10%
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
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
                  padding: const EdgeInsets.symmetric( horizontal: 20.0),
                  child: RoundedInputField(
                    icon: Icons.person,
                    autofocus: !isEditing,
                    initialValue: isEditing ? widget.person!.nickname : '',
                    onSaved: (value) => _nickname = value,
                    hintText: AppLocalizations.of(context)!.email,
                    validator: (val) {
                      return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                    },
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: Sex.values
                      .map(
                        (sex) => Padding(
                          padding: EdgeInsets.all(15.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
