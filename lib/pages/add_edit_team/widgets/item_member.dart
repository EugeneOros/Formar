import 'package:flutter/material.dart';
import 'package:form_it/pages/players/widgets/player_indicator.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:repositories/repositories.dart';

typedef void OnDeleteCallback();

class ItemMember extends StatelessWidget {
  final Player member;
  final OnDeleteCallback onDelete;

  const ItemMember({Key? key, required this.member, required this.onDelete}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          PlayerIndicator(player: member),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              member.nickname.replaceAll(' ', '\u00A0'),
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 13),
          RoundIconButton(icon: Icons.remove, onPressed: () => onDelete(),),
        ],
      ),
    );
  }
}
