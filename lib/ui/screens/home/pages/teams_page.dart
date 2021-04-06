import 'package:form_it/config/dependency.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_state.dart';
import 'package:form_it/ui/screens/add_edit_team_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/ui/widgets/app_snack_bar.dart';
import 'package:form_it/ui/widgets/item_team.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/ui/shared/constants.dart';

class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;

    void onEdit(Team team) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
              List<Player> players = [];
              if (state is PeopleLoaded) {
                players = state.people;
              }
              return AddEditTeamScreen(
                players: players,
                onSave: (name, players) {
                  BlocProvider.of<TeamsBloc>(context).add(
                    UpdateTeam(
                      team.copyWith(name: name, players: players),
                    ),
                  );
                },
                isEditing: true,
                team: team,
              );
            });
          },
        ),
      );
    }

    return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, state) {
      if (state is TeamsLoading) {
        return Loading(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          )),
          indicatorColor: Colors.white,
        );
      } else if (state is TeamsLoaded) {
        final teams = state.teams;
        return Container(
            height: size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
              ],
            )),
            child: CarouselSlider.builder(
              itemCount: teams.length,
              itemBuilder: (context, index, i) {
                final team = teams[index];
                return ItemTeam(
                  team: team,
                  onDelete: () {
                    BlocProvider.of<TeamsBloc>(context).add(DeleteTeam(team));
                    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
                      AppSnackBar(
                        text: AppLocalizations.of(scaffoldKey.currentContext!)!.deleted + " " + team.name,
                        actionName: AppLocalizations.of(scaffoldKey.currentContext!)!.undo,
                        onAction: () => BlocProvider.of<TeamsBloc>(scaffoldKey.currentContext!)
                            .add(AddTeam(team)),
                        actionColor: Theme.of(scaffoldKey.currentContext!).accentColor,
                      ),
                    );
                  },
                  onEdit: () => onEdit(team),
                );
              },
              options: CarouselOptions(

                height: 6 / 10 * size.height,
                aspectRatio: 1,
                viewportFraction: MediaQuery.of(context).size.width > 600 ? 0.5 : 0.7,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ));
      } else {
        return Container();
      }
    });
  }
}
