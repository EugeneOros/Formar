import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';

class ItemSettings extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;

  ItemSettings({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
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
            Text(this.text, style: TextStyle( fontWeight: FontWeight.w600, fontSize: 15.0)),
          ],
        ),
      ),
    );
  }

}