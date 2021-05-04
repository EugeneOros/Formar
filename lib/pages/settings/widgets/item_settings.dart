import 'package:flutter/material.dart';
import 'package:form_it/config/constants.dart';

class ItemSettings extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;
  final Widget? secondaryWidget;
  final bool drawDivider;

  ItemSettings({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.secondaryWidget, this.drawDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: drawDivider ? BoxDecoration(
          border: Border(bottom: borderSideDivider),
        ) : null,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: [
            Icon(this.icon),
            SizedBox(width: 10),
            Text(
              this.text,
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            if (this.secondaryWidget != null) this.secondaryWidget!,
          ],
        ),
      ),
    );
  }
}
