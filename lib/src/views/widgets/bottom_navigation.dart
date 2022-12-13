import 'package:flutter/material.dart' as md;
import 'package:flutter/material.dart';

final md.Color defaultColor = md.Colors.grey;
final md.Color defaultOnSelectColor = md.Colors.blue;
final md.Color defaultBarColor = md.Colors.transparent;
final md.Color defaultOnSelectBarColor = md.Colors.blue;

class BottomNavbar extends md.StatefulWidget {
  final int index;
  final void Function(int i) onTap;
  final List<BottomNavItem> items;
  final double elevation;
  final IconStyle iconStyle;
  final md.Color color;
  final LabelStyle labelStyle;

  BottomNavbar({
    required this.index,
    required this.onTap,
    required this.items,
    this.elevation = 0.0,
    required this.iconStyle,
    this.color = md.Colors.white,
    required this.labelStyle,
  }) : assert(items.length >= 2);

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends md.State<BottomNavbar> {
  late int currentIndex;
  late IconStyle iconStyle;
  late LabelStyle labelStyle;

  @override
  void initState() {
    currentIndex = widget.index;
    iconStyle = widget.iconStyle;
    labelStyle = widget.labelStyle;
    super.initState();
  }

  @override
  md.Widget build(md.BuildContext context) {
    return md.Material(
        elevation: widget.elevation,
        color: widget.color,
        child: md.Row(
          mainAxisAlignment: md.MainAxisAlignment.spaceAround,
          mainAxisSize: md.MainAxisSize.max,
          children: widget.items.map((b) {
            final int i = widget.items.indexOf(b);
            final bool selected = i == currentIndex;
            return BMNavItem(
              icon: b.icon,
              iconSize:
              selected ? iconStyle.getSelectedSize() : iconStyle.getSize(),
              label: parseLabel(b.label, labelStyle, selected),
              onTap: () => onItemClick(i),
              textStyle: selected
                  ? labelStyle.getOnSelectTextStyle()
                  : labelStyle.getTextStyle(),
              color: selected
                  ? iconStyle.getSelectedColor()
                  : iconStyle.getColor(),
              barColor: selected ? iconStyle.getSelectedBarColor():iconStyle.getBarColor(),
            );
          }).toList(),
        ));
  }

  onItemClick(int i) {
    setState(() {
      currentIndex = i;
    });
    widget.onTap(i);
  }

  parseLabel(String label, LabelStyle style, bool selected) {
    if (!style.isVisible()) {
      return null;
    }
    if (style.isShowOnSelect()) {
      return selected ? label : null;
    }
    return label;
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({required this.icon, required this.label});
}

class LabelStyle {
  final bool visible;
  final bool showOnSelect;
  final md.TextStyle textStyle;
  final md.TextStyle onSelectTextStyle;

  LabelStyle({
    required this.visible,
    required this.showOnSelect,
    required this.textStyle,
    required this.onSelectTextStyle
  });

  isVisible() {
    return visible;
  }

  isShowOnSelect() {
    return showOnSelect;
  }

  // getTextStyle returns `textStyle` with default `fontSize` and
  // `color` values if not provided. if `textStyle` is null then
  // returns default text style

  getTextStyle() {
    return md.TextStyle(
      inherit: textStyle.inherit,
      color: textStyle.color ?? defaultOnSelectColor,
      fontSize: textStyle.fontSize ?? 12.0,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      letterSpacing: textStyle.letterSpacing,
      wordSpacing: textStyle.wordSpacing,
      textBaseline: textStyle.textBaseline,
      height: textStyle.height,
      locale: textStyle.locale,
      foreground: textStyle.foreground,
      background: textStyle.background,
      decoration: textStyle.decoration,
      decorationColor: textStyle.decorationColor,
      decorationStyle: textStyle.decorationStyle,
      debugLabel: textStyle.debugLabel,
      fontFamily: textStyle.fontFamily,
    );
  }

  // getOnSelectTextStyle returns `onSelectTextStyle` with
  // default `fontSize` and `color` values if not provided. if
  // `onSelectTextStyle` is null then returns default text style

  getOnSelectTextStyle() {
    return md.TextStyle(
      inherit: onSelectTextStyle.inherit,
      color: onSelectTextStyle.color ?? defaultOnSelectColor,
      fontSize: onSelectTextStyle.fontSize ?? 12.0,
      fontWeight: onSelectTextStyle.fontWeight,
      fontStyle: onSelectTextStyle.fontStyle,
      letterSpacing: onSelectTextStyle.letterSpacing,
      wordSpacing: onSelectTextStyle.wordSpacing,
      textBaseline: onSelectTextStyle.textBaseline,
      height: onSelectTextStyle.height,
      locale: onSelectTextStyle.locale,
      foreground: onSelectTextStyle.foreground,
      background: onSelectTextStyle.background,
      decoration: onSelectTextStyle.decoration,
      decorationColor: onSelectTextStyle.decorationColor,
      decorationStyle: onSelectTextStyle.decorationStyle,
      debugLabel: onSelectTextStyle.debugLabel,
      fontFamily: onSelectTextStyle.fontFamily,
    );
  }
}

class IconStyle {
  final double size;
  final double onSelectSize;
  final md.Color color;
  final md.Color onSelectColor;
  final md.Color barColor;
  final md.Color onSelectBarColor;

  IconStyle({
    required this.size,
    required this.onSelectSize,
    required this.color,
    required this.onSelectColor,
    required this.barColor,
    required this.onSelectBarColor
  });

  getSize() {
    return size;
  }

  getSelectedSize() {
    return onSelectSize;
  }

  getColor() {
    return color;
  }

  getSelectedColor() {
    return onSelectColor;
  }

  getBarColor() {
    return barColor;
  }

  getSelectedBarColor() {
    return onSelectBarColor;
  }
}

class BMNavItem extends md.StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final void Function() onTap;
  final md.Color color;
  final md.Color barColor;
  final md.TextStyle textStyle;

  BMNavItem({
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.onTap,
    required this.color,
    required this.barColor,
    required this.textStyle,
  });

  @override
  md.Widget build(md.BuildContext context) {
    return md.Expanded(
        child: md.InkResponse(
          key: key,
          child: md.Padding(
            padding: getPadding(),
            child:
            md.Column(mainAxisSize: md.MainAxisSize.min, children: <md.Widget>[
              Icon(
                icon,
                size: iconSize,
                color: color,
              ),
              md.SizedBox(
                height: 5,
              ),
              // ignore: unnecessary_null_comparison
              label != null
                  ? md.Container(
                height: 2,
                width: iconSize,
                color: barColor,
              )
                  : md.Container(
                  height: 2, width: iconSize, color: md.Colors.transparent)
            ]),
          ),
          highlightColor: Colors.blue,
          splashColor: md.Theme.of(context).splashColor,
          radius: md.Material.defaultSplashRadius,
          onTap: () => onTap(),
        ));
  }

  getPadding() {
    final double p = ((56 - textStyle.fontSize!) - iconSize) / 2;
    return md.EdgeInsets.fromLTRB(0.0, p, 0.0, p);
  }
}
