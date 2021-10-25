import 'package:flutter/material.dart';

enum FitTextStyle { H1, H2, H3, H4, H5, H6, S1, S2, B1, B2 }

class FitText extends StatelessWidget {
  final String text;
  final TextAlign textAlignment;
  final Alignment fitAlignment;
  final FitTextStyle fitTextStyle;
  const FitText(
      {required this.text,
      required this.fitTextStyle,
      this.textAlignment = TextAlign.center,
      this.fitAlignment = Alignment.center});

  TextStyle _getTheme(BuildContext context) {
    switch (this.fitTextStyle) {
      case FitTextStyle.H1:
        return Theme.of(context).textTheme.headline1!;
      case FitTextStyle.H2:
        return Theme.of(context).textTheme.headline2!;
      case FitTextStyle.H3:
        return Theme.of(context).textTheme.headline3!;
      case FitTextStyle.B1:
        return Theme.of(context).textTheme.bodyText1!;
      case FitTextStyle.S1:
        return Theme.of(context).textTheme.subtitle1!;
      case FitTextStyle.B2:
        return Theme.of(context).textTheme.bodyText2!;
      case FitTextStyle.S2:
        return Theme.of(context).textTheme.subtitle2!;
      case FitTextStyle.H4:
        return Theme.of(context).textTheme.headline4!;
      case FitTextStyle.H5:
        return Theme.of(context).textTheme.headline5!;
      case FitTextStyle.H6:
        return Theme.of(context).textTheme.headline6!;
      default:
        throw Exception('Unreachable State');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: this.fitAlignment,
      fit: BoxFit.scaleDown,
      child: Text(
        this.text,
        style: this._getTheme(context),
        textAlign: this.textAlignment,
      ),
    );
  }
}

class MyUtils {
  static EdgeInsetsGeometry setScreenPadding({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.3, vertical: width * 0.01);
    } else if (width >= 992) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.2, vertical: width * 0.01);
    } else if (width >= 768) {
      return EdgeInsets.symmetric(
          horizontal: width * 0.1, vertical: width * 0.05);
    } else {
      return EdgeInsets.symmetric(
          horizontal: width * 0.075, vertical: width * 0.05);
    }
  }
}

class BooleanWrapper with ChangeNotifier {
  late bool _boolean;

  BooleanWrapper({required bool value}) {
    this._boolean = value;
  }

  bool get value => this._boolean;
  set value(bool newValue) {
    this._boolean = newValue;
    notifyListeners();
  }

  void invertValue() {
    this._boolean = !this._boolean;
    notifyListeners();
  }
}
