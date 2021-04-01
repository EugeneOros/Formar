import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter/foundation.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/fade_end_listview.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/ui/shared/constants.dart';

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

  double value = 2;
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
          return SvgPicture.asset(sex == _sex ? "assets/man_black.svg" : "assets/man_empty.svg");
        case Sex.woman:
          return SvgPicture.asset(sex == _sex ? "assets/woman_black.svg" : "assets/woman_empty.svg");
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
                MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize(),
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
        child: Stack(children: [
          Form(
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
                    icon: Icons.drive_file_rename_outline,
                    autofocus: !isEditing,
                    initialValue: isEditing ? widget.person!.nickname : '',
                    onSaved: (value) => _nickname = value,
                    hintText: AppLocalizations.of(context)!.enterNickname,
                    validator: (val) {
                      return val!.trim().isEmpty ? AppLocalizations.of(context)!.enterSomeText : null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 20),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.level,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _getLevelColor(_level),
                            inactiveTrackColor: Colors.black,
                            valueIndicatorTextStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            valueIndicatorShape: RectangularSliderValueIndicatorShape(),
                            trackHeight: 3.0,
                            valueIndicatorColor: Colors.black,
                            thumbColor: Colors.white,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                            inactiveTickMarkColor: Colors.transparent,
                            activeTickMarkColor: Colors.transparent,
                            overlayColor: Theme.of(context).accentColor.withAlpha(50),
                          ),
                          child: Slider(
                            label: _getLevelName(_level),
                            value: _level.index.toDouble(),
                            onChanged: (double newLevelIndex) {
                              onLevelChanged(Level.values[newLevelIndex.toInt()]);
                            },
                            divisions: 4,
                            min: 0,
                            max: 4,
                          ),
                        ),
                      ),
                    ],
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
        ]),
      ),
    );
  }
}
