import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/loading.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, state) {
      if (state is TeamsLoading) {
        return Loading();
      } else if (state is TeamsLoaded) {
        final teams = state.teams;
        return Container(
            height: size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Colors are easy thanks to Flutter's Colors class.

                SecondaryAssentColor,
                SecondaryPinkColor,
              ],
            )),
            child: CarouselSlider.builder(
              itemCount: teams.length,
              itemBuilder: (context, index, i) {
                final team = teams[index];
                return Container(
                    padding: EdgeInsets.all(30.0),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(5, 5), // changes position of shadow
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Text(
                          team.name,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          height: 3/10 * size.height,
                          child: ListView.builder(
                            itemCount: team.membersNames.length,
                            itemBuilder: (context, index) {
                              final memberName = team.membersNames[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(memberName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, ), overflow: TextOverflow.ellipsis,),
                              );
                            },
                          ),
                        ),
                      ],
                    ));
              },
              options: CarouselOptions(
                height: 6/10 * size.height,
                aspectRatio: 16 / 9,
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
