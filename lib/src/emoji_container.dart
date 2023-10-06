import 'package:emoji_picker_flutter/src/emoji_picker.dart';
import 'package:flutter/material.dart';

/// A wrapper around a grid or list of emojis.
/// If the button style is Cupertino or None, this is just wrapping the
/// `child` with a container of a provided color.
/// For Material style it is a `Material` widget that allows to render
/// touch response for individual InkWell cells.
class EmojiContainer extends StatelessWidget {
  /// Constructor
  const EmojiContainer({
    this.color,
    required this.buttonMode,
    this.padding,
    this.decoration,
    required this.child,
  });

  /// Background color for container
  final Color? color;

  /// BoxDecoration color for container
  final BoxDecoration? decoration;

  /// Button mode that affects the type of container
  final ButtonMode buttonMode;

  /// Optional padding
  final EdgeInsets? padding;

  /// Child widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorNotNull = color != null;
    final decorationNotNull = decoration != null;
    assert((decorationNotNull || colorNotNull) &&
        colorNotNull != decorationNotNull);
    if (buttonMode == ButtonMode.MATERIAL) {
      return Material(
        color: color,
        child: padding == null
            ? child
            : Padding(
                padding: padding!,
                child: child,
              ),
      );
    } else {
      return Container(
        color: color,
        decoration: decoration,
        padding: padding,
        child: child,
      );
    }
  }
}
