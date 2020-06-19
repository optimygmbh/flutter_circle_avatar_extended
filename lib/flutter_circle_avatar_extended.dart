library flutter_circle_avatar_extended;

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef Widget PlaceholderWidgetBuilder(
  BuildContext context,
  BoxConstraints constraints,
  String url,
);

class ImageBlurProvider {
  final double sigmaX;
  final double sigmaY;
  final Color color;

  ImageBlurProvider(this.sigmaX, this.sigmaY, this.color);
}

class CircleAvatarExtended extends StatelessWidget {
  final String imageUrl;
  final String initials;
  final PlaceholderWidgetBuilder placeholder;
  final Map<String, String> httpHeaders;
  final ImageBlurProvider blurProvider;
  final Color backgroundColor;
  final BoxBorder border;

  /// The size of the avatar, expressed as the radius (half the diameter).
  ///
  /// If [radius] is specified, then neither [minRadius] nor [maxRadius] may be
  /// specified. Specifying [radius] is equivalent to specifying a [minRadius]
  /// and [maxRadius], both with the value of [radius].
  ///
  /// If neither [minRadius] nor [maxRadius] are specified, defaults to 20
  /// logical pixels. This is the appropriate size for use with
  /// [ListTile.leading].
  ///
  /// Changes to the [radius] are animated (including changing from an explicit
  /// [radius] to a [minRadius]/[maxRadius] pair or vice versa).
  final double radius;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [minRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to zero.
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [minRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [minRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [maxRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to [double.infinity].
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [maxRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [maxRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double maxRadius;

  // The default radius if nothing is specified.
  static const double _defaultRadius = 20.0;

  // The default min if only the max is specified.
  static const double _defaultMinRadius = 0.0;

  // The default max if only the min is specified.
  static const double _defaultMaxRadius = double.infinity;

  double get _minDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? minRadius ?? _defaultMinRadius);
  }

  double get _maxDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? maxRadius ?? _defaultMaxRadius);
  }

  const CircleAvatarExtended({
    Key key,
    this.imageUrl,
    this.initials,
    this.placeholder,
    this.httpHeaders,
    this.blurProvider,
    this.backgroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.primaryTextTheme.subtitle1;
    Color effectiveBackgroundColor = backgroundColor;
    if (effectiveBackgroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(textStyle.color)) {
        case Brightness.dark:
          effectiveBackgroundColor = theme.primaryColorLight;
          break;
        case Brightness.light:
          effectiveBackgroundColor = theme.primaryColorDark;
          break;
      }
    } else {
      switch (ThemeData.estimateBrightnessForColor(backgroundColor)) {
        case Brightness.dark:
          textStyle = textStyle.copyWith(color: theme.primaryColorLight);
          break;
        case Brightness.light:
          textStyle = textStyle.copyWith(color: theme.primaryColorDark);
          break;
      }
    }
    final double minDiameter = _minDiameter;
    final double maxDiameter = _maxDiameter;
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: minDiameter,
        minWidth: minDiameter,
        maxWidth: maxDiameter,
        maxHeight: maxDiameter,
      ),
      duration: kThemeChangeDuration,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipOval(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return MediaQuery(
                        // Need to ignore the ambient textScaleFactor here so that the
                        // text doesn't escape the avatar when the textScaleFactor is large.
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: IconTheme(
                          data:
                              theme.iconTheme.copyWith(color: textStyle.color),
                          child: DefaultTextStyle(
                            style: textStyle.copyWith(
                              fontSize: constraints.maxHeight * 0.35,
                            ),
                            child: AnimatedContainer(
                              duration: kThemeChangeDuration,
                              color: effectiveBackgroundColor,
                              child: imageUrl == null
                                  ? effectivePlaceholder(
                                      context,
                                      constraints,
                                      imageUrl,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      httpHeaders: httpHeaders,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          fit: StackFit.expand,
                                          children: [
                                            Image(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            blurProvider == null
                                                ? SizedBox()
                                                : Container(
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                        sigmaX:
                                                            blurProvider.sigmaX,
                                                        sigmaY:
                                                            blurProvider.sigmaY,
                                                      ),
                                                      child: Container(
                                                        color:
                                                            blurProvider.color,
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        );
                                      },
                                      placeholder: (context, url) =>
                                          effectivePlaceholder(
                                        context,
                                        constraints,
                                        url,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedContainer(
                  duration: kThemeChangeDuration,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: border,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget effectivePlaceholder(
    BuildContext context,
    BoxConstraints constraints,
    String url,
  ) {
    if (placeholder != null) {
      return placeholder(context, constraints, url);
    }
    return Center(
      child: Text(initials ?? ''),
    );
  }
}
