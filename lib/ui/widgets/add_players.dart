import 'package:flutter/material.dart';
import 'package:repositories/repositories.dart';

class AddPlayersList extends StatefulWidget {
  final List<Player> players;

  const AddPlayersList({Key? key, required this.players}) : super(key: key);

  @override
  _AddPlayersListState createState() => _AddPlayersListState();
}

class _AddPlayersListState extends State<AddPlayersList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: widget.players.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.players[index].nickname),
              );
            },
          ))
        ],
      ),
    );
  }
}
