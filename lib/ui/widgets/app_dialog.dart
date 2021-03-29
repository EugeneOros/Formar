import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/dependency.dart';

class AppDialog extends StatefulWidget {
  final Widget? content;
  final String title;
  final List<Widget>? actionsHorizontal;
  final List<Widget>? actionsVertical;

  const AppDialog({
    Key? key,
    this.content,
    required this.title,
    this.actionsHorizontal,
    this.actionsVertical,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppDialogState();
}

class AppDialogState extends State<AppDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              margin: EdgeInsets.all(30),
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.content != null) widget.content!,
                    if (widget.actionsVertical != null)
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: widget.actionsVertical!.map((e) {
                            return Container(
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: Colors.grey[400]!, width: 1)),
                              ),
                              child: e,
                            );
                          }).toList(),
                        ),
                      ),
                    if (widget.actionsHorizontal != null)
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.grey[400]!, width: 1)),
                          ),
                          child: Row(
                            children: widget.actionsHorizontal!.map((e) {
                              return Expanded(
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: e != widget.actionsHorizontal!.last
                                        ? Border(right: BorderSide(color: Colors.grey[400]!, width: 1))
                                        : Border(),
                                  ),
                                  child: e,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
