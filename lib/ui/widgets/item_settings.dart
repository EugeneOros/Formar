import 'package:flutter/material.dart';

class ItemSettings extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;
  final Widget? secondaryWidget;

  ItemSettings({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.secondaryWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Row(
          children: [
            Icon(this.icon),
            SizedBox(width: 10),
            Text(this.text, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis,),
            Spacer(),
            this.secondaryWidget ?? Container(),
          ],
        ),
      ),
    );
  }
}
