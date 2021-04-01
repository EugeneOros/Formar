import 'package:flutter/material.dart';

class LetterDivider extends StatelessWidget {
  final String letter;
  final String? secondaryString;

  const LetterDivider({Key? key, required this.letter, this.secondaryString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      color: Colors.grey[200],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              letter,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Spacer(),
          if (secondaryString != null)
            Container(
              width: 100,
              child: Center(
                child: Text(secondaryString!,
                    // players.where((player) => player.available == true).length.toString() + "/" + players.length.toString(),
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ),
        ],
      ),
    );
  }
}
