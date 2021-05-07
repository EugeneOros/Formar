import 'package:flutter/material.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tab_bar.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/tab_bar.dart';
import 'package:form_it/widgets/fade_end_listview.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:flutter_neumorphic_null_safety/generated/i18n.dart';

class AddEditTournamentPage extends StatefulWidget {
  @override
  _AddEditTournamentPageState createState() => _AddEditTournamentPageState();
}

class _AddEditTournamentPageState extends State<AddEditTournamentPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late TabController _tabController;

  //
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButtonAppBar(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   widget.onSave(_name, _players);
              //   Navigator.pop(context);
              // }
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
      body: Stack(
        children: [
          TabBarView(controller: _tabController, children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child:
              NeumorphicIcon(
                Icons.add_circle,
                size: 80,
              ),
            ),
            Icon(Icons.movie),
            Icon(Icons.games),
            Icon(Icons.movie),
          ]),
          // FadeEndLIstView(
          //   height: 30,
          //   width: MediaQuery.of(context).size.width,
          //   color: Colors.white,
          //   isTop: true,
          // ),
          FadeEndLIstView(
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            isTop: false,
          ),
          TabBarTournament(
            controller: _tabController,
          )
        ],
      ),
    );
  }
}

// class TabBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
