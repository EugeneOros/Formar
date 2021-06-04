import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/logic/models/app_state_notifier.dart';

class Loading extends StatelessWidget {
  final Color? backgroundColor;
  final Color? indicatorColor;
  final BoxDecoration? decoration;

  Loading({Key? key, this.backgroundColor, this.indicatorColor, this.decoration} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      color: decoration == null ? (backgroundColor ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Colors.white))
          : null,
      child: Center(
        child: SpinKitSquareCircle(
          color: ( indicatorColor ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightBlue : Colors.black) ),
          size: 50.0,
        ),
      ),
    );
  }
}
