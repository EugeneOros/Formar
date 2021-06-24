import 'package:flutter/material.dart';
import 'package:form_it/config/helpers.dart';

class ItemTournamentInfo extends StatelessWidget {
  final String text;
  final bool drawDivider;
  final bool isVisible;
  final Widget? secondaryWidget;

  const ItemTournamentInfo({Key? key, required this.text, this.drawDivider = false, this.secondaryWidget, this.isVisible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isVisible ? 50 : 0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart,
      constraints: BoxConstraints(maxHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: drawDivider ? BoxDecoration(border: Border(top: getBorderDivider(context).copyWith(width: isVisible ? 0.5 : 0))) : null,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (secondaryWidget != null)
              Container(
                width: 90,
                alignment: Alignment.center,
                child: secondaryWidget!,
              ),
          ],
        ),
      ),
    );
  }
}
