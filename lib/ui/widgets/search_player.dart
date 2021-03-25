import 'package:flutter/cupertino.dart';
import 'package:form_it/ui/shared/dependency.dart';

class SearchPlayer extends SearchDelegate<String> {
  final playerNames = [
    "Hejo",
    "jklkj",
    "eugene",
    "joni",
    "tibi",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "null");
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? [] : playerNames.where((element) => element.contains(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {showResults(context);},
            title: Text(
              suggestionList[index],
        ));
      },
      itemCount: suggestionList.length,
    );
  }
}
