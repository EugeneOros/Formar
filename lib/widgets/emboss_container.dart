import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';

class EmbossContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String? name;
  final Color? color;
  final Widget? titleChild;

  const EmbossContainer({Key? key, this.child, this.margin, this.padding, this.name, this.color, this.titleChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              titleChild ?? SizedBox.shrink(),
            ],
          ),
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
