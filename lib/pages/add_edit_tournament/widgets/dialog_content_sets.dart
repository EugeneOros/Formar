import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:repositories/repositories.dart';

class DialogContentSets extends StatefulWidget {
  final Match match;

  DialogContentSets({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  _DialogContentSetsState createState() => _DialogContentSetsState();
}

class _DialogContentSetsState extends State<DialogContentSets> {
  int currentSet = 1;
  var firstTeamTxtController = TextEditingController();
  var secondTeamTxtController = TextEditingController();
  final _firstTeamFocusNode = FocusNode();
  final _secondTeamFocusNode = FocusNode();

  @override
  void dispose() {
    firstTeamTxtController.dispose();
    secondTeamTxtController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setControllers();
    secondTeamTxtController.selection = TextSelection.fromPosition(TextPosition(offset: secondTeamTxtController.text.length));
    _firstTeamFocusNode.addListener(() {
      if (_firstTeamFocusNode.hasFocus) {
        firstTeamTxtController.selection = TextSelection(baseOffset: 0, extentOffset: firstTeamTxtController.text.length);
      }
    });
    _secondTeamFocusNode.addListener(() {
      if (_secondTeamFocusNode.hasFocus) {
        secondTeamTxtController.selection = TextSelection(baseOffset: 0, extentOffset: secondTeamTxtController.text.length);
      }
    });
    super.initState();
  }

  void setControllers() {
    firstTeamTxtController.text =
        widget.match.sets[currentSet - 1].firstTeamPoints == null ? "" : widget.match.sets[currentSet - 1].firstTeamPoints.toString();
    firstTeamTxtController.selection = TextSelection.collapsed(offset: firstTeamTxtController.text.length);
    secondTeamTxtController.text =
        widget.match.sets[currentSet - 1].secondTeamPoints == null ? "" : widget.match.sets[currentSet - 1].secondTeamPoints.toString();
    secondTeamTxtController.selection = TextSelection.collapsed(offset: secondTeamTxtController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    // firstTeamTxtController.text = widget.match.sets[currentSet-1].firstTeamPoints.toString();
    // secondTeamTxtController.text = widget.match.sets[currentSet-1].secondTeamPoints.toString();
    return Container(
      constraints: BoxConstraints(minWidth: 50, maxWidth: 350),
      // height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (currentSet != 1)
                Visibility(
                  visible: currentSet != 1,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: RoundIconButton(
                    icon: Icons.arrow_back_ios_rounded,
                    onPressed: () {
                      setState(() {
                        currentSet -= 1;
                        setControllers();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                   AppLocalizations.of(context)!.set + " " + currentSet.toString(),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 20,
                ),
                currentSet < widget.match.sets.length
                    ? RoundIconButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        onPressed: () {
                          setState(() {
                            currentSet += 1;
                            setControllers();
                          });
                        },
                      )
                    : Wrap(
                        direction: Axis.vertical,
                        children: [
                          RoundIconButton(
                            icon: Icons.add,
                            onPressed: () {
                              setState(() {
                                widget.match.sets.add(Score());
                                currentSet += 1;
                                setControllers();
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          RoundIconButton(
                            icon: Icons.remove,
                            onPressed: () {
                              setState(() {
                                widget.match.sets.removeLast();
                                currentSet -= 1;
                                setControllers();
                              });
                            },
                          ),
                        ],
                      )
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: getBorderDivider(context),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            child: Text(
                              widget.match.firstTeam!.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ))),
                    Container(
                        padding: EdgeInsets.only(bottom: 7, left: 13, right: 15, top: 2),
                        decoration: BoxDecoration(
                          border: Border(
                            left: getBorderDivider(context),
                          ),
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                depth: -1.5,
                                intensity: 1,
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                lightSource: LightSource.topLeft,
                                shadowDarkColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                    ? DarkColorShadowDark
                                    : Colors.grey.withOpacity(0.7),
                                shadowLightColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                    ? DarkColorShadowLight
                                    : Colors.white.withOpacity(0.7),
                                color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                    ? DarkColor
                                    : Theme.of(context).primaryColorLight),
                            child: TextFormField(
                              // onSaved: (_) {},
                              onChanged: (value) {
                                // setState(() {

                                // firstTeamTxtController.text = value;
                                try {
                                  widget.match.sets[currentSet - 1].firstTeamPoints = int.parse(value);
                                  // firstTeamTxtController.text = widget.match.sets[currentSet-1].firstTeamPoints.toString();
                                } catch (exception) {
                                  widget.match.sets[currentSet - 1].firstTeamPoints = 0;
                                }
                                // });
                              },
                              controller: firstTeamTxtController,
                              textAlignVertical: TextAlignVertical.center,
                              focusNode: _firstTeamFocusNode,
                              // initialValue: widget.match.sets[currentSet - 1].firstTeamPoints.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                              // controller: controller,
                              // cursorColor: Colors.black,
                              // validator: validator,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: borderRoundedTransparent,
                                focusedBorder: borderRoundedTransparent,
                                enabledBorder: borderRoundedTransparent,
                                errorStyle: TextStyle(height: 0),
                                hintStyle: Theme.of(context).textTheme.bodyText1,
                                hintText: "?",
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            child: Text(
                              widget.match.secondTeam!.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ))),
                    Container(
                        padding: EdgeInsets.only(bottom: 2, left: 13, right: 15, top: 7),
                        decoration: BoxDecoration(
                          border: Border(left: getBorderDivider(context)),
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                depth: -1.5,
                                intensity: 1,
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                lightSource: LightSource.topLeft,
                                shadowDarkColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                    ? DarkColorShadowDark
                                    : Colors.grey.withOpacity(0.7),
                                shadowLightColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                    ? DarkColorShadowLight
                                    : Colors.white.withOpacity(0.7),
                                color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                    ? DarkColor
                                    : Theme.of(context).primaryColorLight),
                            child: TextField(
                              controller: secondTeamTxtController,
                              onChanged: (value) {
                                // setState(() {
                                try {
                                  widget.match.sets[currentSet - 1].secondTeamPoints = int.parse(value);
                                } catch (exception) {
                                  widget.match.sets[currentSet - 1].secondTeamPoints = 0;
                                }
                                // });
                              },
                              textAlignVertical: TextAlignVertical.center,
                              focusNode: _secondTeamFocusNode,
                              // initialValue: widget.match.sets[currentSet-1].secondTeamPoints.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                              // cursorColor: Colors.black,
                              // validator: validator,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: borderRoundedTransparent,
                                focusedBorder: borderRoundedTransparent,
                                enabledBorder: borderRoundedTransparent,
                                errorStyle: TextStyle(height: 0),
                                hintStyle: Theme.of(context).textTheme.bodyText1,
                                hintText: "?",
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Expanded(
//       child: Stack(
//         alignment: Alignment.topRight,
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: 40, right: 10, left: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               color: Theme.of(context).primaryColor,
//             ),
//             // width: MediaQuery.of(context).size.width / 3,
//             // height: 50,
//             padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//             child: Text(
//               "Командa 1",
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Positioned(
//               right: 0,
//               top: 0,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 alignment: Alignment.center,
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child:
//                 Container(
//                   padding: EdgeInsets.all(0),
//                   alignment: Alignment.center,
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).accentColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Text("?"),
//                 ),
//               ))
//         ],
//       ),
//     ),
//     SizedBox(
//       width: 10,
//     ),
//     Container(
//       height: 50,
//       alignment: Alignment.center,
//       child: Text(
//         ":",
//         style: Theme.of(context).textTheme.headline1,
//       ),
//     ),
//     SizedBox(
//       width: 10,
//     ),
//     Expanded(
//       child: Stack(
//         alignment: Alignment.topLeft,
//         children: [
//           Container(
//             margin: EdgeInsets.only(top: 40, right: 10, left: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//               color: Theme.of(context).primaryColor,
//             ),
//             // width: MediaQuery.of(context).size.width / 3,
//             // height: 50,
//             padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//             child: Text(
//               "Веселі котики",
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Positioned(
//               left: 0,
//               top: 0,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 alignment: Alignment.center,
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child:
//                 Container(
//                   padding: EdgeInsets.all(0),
//                   alignment: Alignment.center,
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).accentColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Text("?"),
//                 ),
//               ))
//         ],
//       ),
//     ),
//   ],
// ),
