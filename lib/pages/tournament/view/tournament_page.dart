import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/logic/blocs/tournament/bloc.dart';
import 'package:form_it/pages/tournament/widgets/item_tournament.dart';
import 'package:form_it/widgets/widgets.dart';
import 'package:repositories/repositories.dart';

// import 'package:form_it/pages/tournament_tab/widgets/widgets.dart';

class TournamentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SlidableController _slidableController = SlidableController();
    final size = MediaQuery.of(context).size;
    final UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    // return  ItemTournament( tournament: Tournament(name: 'Tournament 1', ownerId: '123'),);
    return BlocBuilder<TournamentsBloc, TournamentsState>(builder: (context, state) {
      if (state is TournamentsLoading) {
        return Loading();
      } else if (state is TournamentsLoaded) {
        final tournaments = state.tournaments;
        return Container(
          alignment: Alignment.center,
          color: Theme.of(context).accentColor,
          child: Container(
            color: Theme.of(context).primaryColorLight,
            constraints: BoxConstraints(minWidth: 50, maxWidth: 700),
            child: ListView.builder(
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                return ItemTournament(
                  slidableController: _slidableController,
                  tournament: tournaments[index],
                  userRepository: userRepository,
                );
              },
            ),
          ),
        );
      } else {
        return Container();
      }
    });
    //   Container(
    //     // alignment: Alignment.center,
    //     height: size.height,
    //     width: size.width,
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: [
    //           Theme.of(context).primaryColorLight,
    //           // Theme.of(context).accentColor,
    //           Theme.of(context).primaryColorLight,
    //         ],
    //       ),
    //     ),
    //     child:  ItemTournament( tournament: Tournament(name: 'Tournament 1', ownerId: '123'),)
    // );
  }
}
