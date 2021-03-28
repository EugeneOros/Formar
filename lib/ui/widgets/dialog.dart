import 'dart:ui';
import 'package:flutter/material.dart';

class AppDialog extends StatefulWidget {
  final Widget? content;
  final String title;
  final List<Widget>? actions;

  const AppDialog({
    Key? key,
    this.content,
    required this.title,
    this.actions,
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
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: IntrinsicWidth(
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(15),
                        child: Text(widget.title, style: Theme.of(context).textTheme.headline2),
                      ),
                      widget.content ?? SizedBox.shrink(),
                      if (widget.actions != null)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(
                                color: Colors.grey[400]!,
                                width: 1,
                              ),
                            )),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: widget.actions!.map((e) {
                                return Expanded(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      border: e != widget.actions!.last
                                          ? Border(
                                              right: BorderSide(
                                                color: Colors.grey[400]!,
                                                width: 1,
                                              ),
                                            )
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
      ),
    );
  }
}
