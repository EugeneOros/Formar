import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';

class LogoSearch extends StatefulWidget {
  final _LogoSearchState state = _LogoSearchState();

  @override
  _LogoSearchState createState() => state;
}

class _LogoSearchState extends State<LogoSearch> with TickerProviderStateMixin {
  late AnimationController _controllerForSwitcher;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controllerForSwitcher = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  bool get isFlipped => _isFlipped;

  void flip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
    if (_isFlipped) {
      _controllerForSwitcher.forward(from: 0.0);
    } else {
      BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(searchQuery: ""));
      _controllerForSwitcher.reverse();
    }
  }

  void closeSearch(AppTab activeTab) {
    if (activeTab != AppTab.players) {
      setState(() {
        BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(searchQuery: ""));
        if (_isFlipped) {
          _controllerForSwitcher.reverse();
          _isFlipped = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Tween<double>(begin: 30.0, end: MediaQuery.of(context).size.width).animate(
      CurvedAnimation(parent: _controllerForSwitcher, curve: Interval(0.5, 1.0, curve: Curves.easeInOutQuart)),
    );

    final Widget _logo = Container(
      decoration: roundedShadowDecoration,
      child: SvgPicture.asset('assets/logo_rounded_black.svg', height: 35),
    );

    final Widget _searchField = AnimatedBuilder(
      animation: _controllerForSwitcher,
      builder: (context, widget) {
          return RoundedInputField(
            height: 35,
            width: width.value,
            initialValue: "",
            hintText: MaterialLocalizations.of(context).searchFieldLabel,
            autofocus: true,
            onChange: (value) {
              BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(searchQuery: value));
            },
          );
      },
    );

    Widget _transitionBuilder(Widget widget, Animation<double> animation) {
      final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
      return AnimatedBuilder(
        animation: _controllerForSwitcher,
        child: widget,
        builder: (context, widget) {
          final isUnder = (ValueKey(_isFlipped) != widget!.key);
          var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
          tilt *= isUnder ? -1.0 : 1.0;
          final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
          return Transform(
            transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
            child: widget,
            alignment: Alignment.center,
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 1000),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Interval(0.0, 1, curve: Curves.easeInCirc),
        switchOutCurve: Interval(0.0, 1, curve: Curves.easeInBack.flipped),
        child: _isFlipped ? _searchField : _logo,
      ),
    );
  }

  @override
  void dispose() {
    _isFlipped = false;
    _controllerForSwitcher.dispose();
    super.dispose();
  }
}
