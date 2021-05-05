import 'package:flutter/material.dart';
import 'package:form_it/pages/players/widgets/player_indicator.dart';
import 'package:repositories/repositories.dart';

typedef void OnDeleteCallback();

class ItemMember extends StatelessWidget {
  final Player member;
  final OnDeleteCallback onDelete;

  const ItemMember({Key? key, required this.member, required this.onDelete}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlayerIndicator(player: member),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            member.nickname,
            style: Theme.of(context).textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Spacer(),
        IconButton(
          padding: new EdgeInsets.all(0.0),
          icon: Icon(
            Icons.close,
            size: 15,
            color: Colors.black,
          ),
          onPressed: () {
            onDelete();
          },
        )
      ],
    );
  }
}
