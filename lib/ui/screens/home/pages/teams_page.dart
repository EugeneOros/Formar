import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:form_it/ui/widgets/player_indicator.dart';

class TeamsPage extends StatelessWidget {
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
                return Container(
                    padding: EdgeInsets.all(30.0),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(2, 2),
                      )
                    ], borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white),
                    child: Column(
                      children: [
                        Text(
                          team.name,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset("assets/power.svg"),
                            ),
                            Text(
                              team.power.toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: team.players.length,
                            itemBuilder: (context, index) {
                              final player = team.players[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(children: [
                                  PlayerIndicator(player: player),
                                  Expanded(
                                    child: Text(
                                      player.nickname,
                                      style: Theme.of(context).textTheme.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),
                              );
                            },
                          ),
                        ),
                      ],
                    ));
              },
              options: CarouselOptions(
                height: 6 / 10 * size.height,
                aspectRatio: 1,
                viewportFraction: 0.7,
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
