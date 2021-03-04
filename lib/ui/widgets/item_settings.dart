import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class ItemSettings extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;
  final Widget secondaryWidget;

  ItemSettings({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.secondaryWidget = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          children: [
            Icon(
              this.icon,
            ),
            SizedBox(width: 10),
            Text(this.text,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0)),
            Spacer(),
            this.secondaryWidget ?? Container(),
          ],
        ),
      ),
    );
  }
}
