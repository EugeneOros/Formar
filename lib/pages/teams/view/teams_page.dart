import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/helpers.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_state.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/pages/add_edit_team/view/add_edit_team_page.dart';
import 'package:form_it/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:repositories/repositories.dart';

import 'package:form_it/pages/teams/widgets/widgets.dart';

class TeamsPage extends StatelessWidget {

  void onEdit(Team team) {
    Navigator.of(homeKey.currentContext!).push(
        getPageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
            List<Player> players = [];
            if (state is PeopleLoaded) {
              players = state.people;
            }
            return Provider<List<Player>>.value(
                value: players,
                child: AddEditTeamScreen(
                  onSave: (name, players) {
                    BlocProvider.of<TeamsBloc>(context).add(
                      UpdateTeam(
                        team.copyWith(name: name, players: players),
                      ),
                    );
                  },
                  isEditing: true,
                  team: team,
                ));
          })
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;

    return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, state) {
      if (state is TeamsLoading) {
        return Loading(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary,
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
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
              ],
            )),
            child: teams.isEmpty ? Container(
              padding: EdgeInsets.all(50),
              alignment: Alignment.center,
              child: EmptyWidget(
                // image: "cup_fill.svg",
                packageImage: PackageImage.Image_2,
                title: 'No Teams',
                subTitle: 'To add teams click plus in a top right corner',
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
            ) : CarouselSlider.builder(
              itemCount: teams.length,
              itemBuilder: (context, index, i) {
                final team = teams[index];
                return ItemTeam(
                  team: team,
                  onDelete: () {
                    BlocProvider.of<TeamsBloc>(context).add(DeleteTeam(team));
                    ScaffoldMessenger.of(homeKey.currentContext!).showSnackBar(
                      AppSnackBar(
                        text: AppLocalizations.of(homeKey.currentContext!)!.deleted + " " + team.name,
                        actionName: AppLocalizations.of(homeKey.currentContext!)!.undo,
                        onAction: () => BlocProvider.of<TeamsBloc>(homeKey.currentContext!)
                            .add(AddTeam(team)),
                        actionColor: Theme.of(homeKey.currentContext!).colorScheme.secondary,
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
                autoPlayAnimationDuration: Duration(milliseconds: 600),
                autoPlayCurve: Curves.elasticInOut,
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
