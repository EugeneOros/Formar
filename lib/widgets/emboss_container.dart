import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';

class EmbossContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String? name;
  final Color? color;

  const EmbossContainer({Key? key, this.child, this.margin, this.padding, this.name, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10),
                  child: Text(
                    name!,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              : SizedBox(),
          Container(
              child: Neumorphic(
                style: getInnerNeumorphicStyle(context: context),
                child: child,
              )),
        ],
      ),
    );
  }
}
