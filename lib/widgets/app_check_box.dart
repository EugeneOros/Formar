import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:flutter_neumorphic_null_safety/src/neumorphic_icons.dart';
import 'package:flutter_neumorphic_null_safety/src/widget/container.dart';

typedef void AppCheckboxListener<T>(T value);

/// A Style used to customize a NeumorphicCheckbox
///
/// selectedDepth : the depth when checked
/// unselectedDepth : the depth when unchecked (default : theme.depth)
/// selectedColor : the color when checked (default: theme.accent)
///
class AppCheckboxStyle {
  final double? selectedDepth;
  final double? unselectedDepth;
  final bool? disableDepth;
  final double? selectedIntensity;
  final double unselectedIntensity;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? disabledColor;
  final LightSource? lightSource;
  final NeumorphicBorder border;
  final NeumorphicBoxShape? boxShape;

  const AppCheckboxStyle({
    this.selectedDepth,
    this.border = const NeumorphicBorder.none(),
    this.selectedColor,
    this.unselectedColor,
    this.unselectedDepth,
    this.disableDepth,
    this.lightSource,
    this.disabledColor,
    this.boxShape,
    this.selectedIntensity = 1,
    this.unselectedIntensity = 0.7,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppCheckboxStyle &&
              runtimeType == other.runtimeType &&
              selectedDepth == other.selectedDepth &&
              border == other.border &&
              unselectedDepth == other.unselectedDepth &&
              disableDepth == other.disableDepth &&
              selectedIntensity == other.selectedIntensity &&
              lightSource == other.lightSource &&
              unselectedIntensity == other.unselectedIntensity &&
              boxShape == other.boxShape &&
              selectedColor == other.selectedColor &&
              unselectedColor == other.unselectedColor &&
              disabledColor == other.disabledColor;

  @override
  int get hashCode =>
      selectedDepth.hashCode ^
      unselectedDepth.hashCode ^
      border.hashCode ^
      lightSource.hashCode ^
      disableDepth.hashCode ^
      selectedIntensity.hashCode ^
      unselectedIntensity.hashCode ^
      boxShape.hashCode ^
      selectedColor.hashCode ^
      unselectedColor.hashCode ^
      disabledColor.hashCode;
}

@immutable
class AppCheckbox extends StatelessWidget {
  final bool value;
  final AppCheckboxStyle style;
  final AppCheckboxListener onChanged;
  final isEnabled;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Duration duration;
  final Curve curve;

  AppCheckbox({
    this.style = const AppCheckboxStyle(),
    required this.value,
    required this.onChanged,
    this.curve = Neumorphic.DEFAULT_CURVE,
    this.duration = Neumorphic.DEFAULT_DURATION,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.margin = const EdgeInsets.all(0),
    this.isEnabled = true,
  });

  bool get isSelected => this.value;

  void _onClick() {
    this.onChanged(!this.value);
  }

  @override
  Widget build(BuildContext context) {
    final NeumorphicThemeData theme = NeumorphicTheme.currentTheme(context);
    final selectedColor = this.style.selectedColor ?? theme.accentColor;
    final unselectedColor = this.style.unselectedColor ?? theme.baseColor;

    final double selectedDepth =
        -1 * (this.style.selectedDepth ?? theme.depth).abs();
    final double unselectedDepth =
    (this.style.unselectedDepth ?? theme.depth).abs();
    final double selectedIntensity =
    (this.style.selectedIntensity ?? theme.intensity)
        .abs()
        .clamp(Neumorphic.MIN_INTENSITY, Neumorphic.MAX_INTENSITY);
    final double unselectedIntensity = this
        .style
        .unselectedIntensity
        .clamp(Neumorphic.MIN_INTENSITY, Neumorphic.MAX_INTENSITY);

    double depth = isSelected ? selectedDepth : unselectedDepth;
    if (!this.isEnabled) {
      depth = 0;
    }

    Color? color = isSelected ? selectedColor : unselectedColor;
    if (!this.isEnabled) {
      color = null;
    }

    Color iconColor = isSelected ? unselectedColor : selectedColor;
    if (!this.isEnabled) {
      iconColor = theme.disabledColor;
    }

    return NeumorphicButton(
      padding: this.padding,
      pressed: isSelected,
      margin: this.margin,
      duration: this.duration,
      curve: this.curve,
      onPressed: () {
        if (this.isEnabled) {
          _onClick();
        }
      },
      drawSurfaceAboveChild: true,
      minDistance: selectedDepth.abs(),
      child: Icon(
        Icons.check,
        color: iconColor,
        size: 20.0,
      ),
      style: NeumorphicStyle(
        boxShape: this.style.boxShape,
        border: this.style.border,
        color: color,
        depth: depth,
        lightSource: this.style.lightSource ?? theme.lightSource,
        disableDepth: this.style.disableDepth,
        intensity: isSelected ? selectedIntensity : unselectedIntensity,
        shape: NeumorphicShape.concave,
      ),
    );
  }
}
