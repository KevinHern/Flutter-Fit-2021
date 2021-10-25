// Basic Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

// Extra stuff
import 'package:sp2_presentation/utils.dart';
import 'package:sp2_presentation/templates/dialog_template.dart';

enum ScreenType { LOGIN, SIGN_UP, RECOVER }
enum SessionInputType { EMAIL, PASSWORD, TEXT, NUMBER }

class SessionWidgetBackground extends StatelessWidget {
  final Widget child;
  SessionWidgetBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Color(0xFF3a93e0),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      height: 60.0,
      child: this.child,
    );
  }
}

class SessionInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final SessionInputType sessionInputType;
  final IconData iconData;
  final String hintText;
  final bool readOnly, caps, lastInput;
  final Function(String? value)? validator;
  SessionInputWidget({
    required this.controller,
    required this.sessionInputType,
    required this.iconData,
    required this.hintText,
    this.readOnly = false,
    this.caps = false,
    this.lastInput = false,
    @required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SessionWidgetBackground(
      child: TextFormField(
        validator: (String? value) =>
            (this.validator == null) ? null : this.validator!(value),
        keyboardType: (this.sessionInputType == SessionInputType.EMAIL)
            ? TextInputType.emailAddress
            : (this.sessionInputType == SessionInputType.PASSWORD)
                ? TextInputType.visiblePassword
                : (this.sessionInputType == SessionInputType.TEXT)
                    ? TextInputType.text
                    : TextInputType.number,
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
        obscureText: this.sessionInputType == SessionInputType.PASSWORD,
        controller: this.controller,
        readOnly: this.readOnly,
        textCapitalization:
            this.caps ? TextCapitalization.words : TextCapitalization.none,
        textInputAction:
            (lastInput) ? TextInputAction.done : TextInputAction.next,
        onEditingComplete: () => (lastInput)
            ? FocusScope.of(context).unfocus()
            : FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 0.0),
          prefixIcon: Icon(
            this.iconData,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: this.hintText,
          hintStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

class SessionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String? text;
  final double fontSize;
  final Function onPressed;

  SessionButtonWidget(
      {required this.icon,
      required this.text,
      required this.onPressed,
      this.fontSize = 25});

  @override
  Widget build(BuildContext context) {
    return (this.text != null)
        ? ElevatedButton.icon(
            icon: Icon(
              this.icon,
              color: Colors.black87,
            ),
            label: AutoSizeText(
              this.text!,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.subtitle1!.fontFamily,
                fontSize: this.fontSize,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              minFontSize: 0,
              maxFontSize: 30,
              stepGranularity: 0.1,
            ),
            style: ElevatedButton.styleFrom(
              elevation: 15.0,
              shadowColor: Colors.black45,
              primary: Colors.white.withOpacity(0.85),
              onPrimary: Colors.grey,
            ),
            onPressed: () => this.onPressed(),
          )
        : ElevatedButton(
            child: Icon(
              this.icon,
              color: Colors.black87,
            ),
            style: ElevatedButton.styleFrom(
              elevation: 15.0,
              shadowColor: Colors.black45,
              primary: Colors.white.withOpacity(0.85),
              onPrimary: Colors.grey,
            ),
            onPressed: () => this.onPressed(),
          );
  }
}

class SessionBackgroundWidget extends StatelessWidget {
  final Widget child;
  SessionBackgroundWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1CB5E0),
                    Color(0xFF000046),
                  ],
                  stops: [0.5, 1],
                ),
              ),
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: this.child,

                /**/
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final BooleanWrapper hidePassword = BooleanWrapper(value: true);
  final _key = GlobalKey<FormState>();
  static const double spacing = 12.0;

  LoginScreen();

  @override
  Widget build(BuildContext context) {
    return SessionBackgroundWidget(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: MyUtils.setScreenPadding(context: context),
            child: Form(
              key: this._key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1!.fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SessionInputWidget(
                    controller: this._emailController,
                    sessionInputType: SessionInputType.EMAIL,
                    iconData: Icons.email_outlined,
                    hintText: 'Email',
                    validator: (String? value) {
                      return (value == null)
                          ? null
                          : (value.trim().isEmpty)
                              ? 'Please, provide an email'
                              : (!RegExp(".+@[a-z]+(\.[a-z]+)+")
                                      .hasMatch(value))
                                  ? "A valid email is required"
                                  : null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SessionInputWidget(
                    controller: this._passwordController,
                    sessionInputType: SessionInputType.PASSWORD,
                    iconData: Icons.vpn_key,
                    hintText: 'Password',
                    lastInput: true,
                    validator: (String? value) {
                      if (value == null)
                        return null;
                      else
                        return (value.trim().isEmpty)
                            ? 'Provide a password'
                            : (value.length < 6)
                                ? "The password's length must be at least 6 characters long"
                                : null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  SessionButtonWidget(
                    icon: Icons.login,
                    text: "Access",
                    onPressed: () async {
                      if (this._key.currentState!.validate()) {
                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Future.delayed(const Duration(seconds: 1)),
                            message: Text(
                              'Verifying data...',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        );

                        Navigator.of(context).pushNamed("/mainscreen").then(
                          (value) {
                            this._emailController.text = "";
                            this._passwordController.text = "";
                          },
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Divider(
                      color: Colors.black54,
                      thickness: 2.5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SessionButtonWidget(
                        icon: Icons.add,
                        text: "Sign up",
                        onPressed: () =>
                            Navigator.of(context).pushNamed("/signup"),
                      ),
                      SessionButtonWidget(
                        icon: Icons.update,
                        text: "Recover",
                        onPressed: () =>
                            Navigator.of(context).pushNamed("/recover"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecoverPasswordScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  RecoverPasswordScreen();

  static const double spacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return SessionBackgroundWidget(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: MyUtils.setScreenPadding(context: context),
            child: Form(
              key: this.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Recover\nPassword",
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1!.fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SessionInputWidget(
                    controller: this._emailController,
                    sessionInputType: SessionInputType.EMAIL,
                    iconData: Icons.email_outlined,
                    hintText: 'Email',
                    lastInput: true,
                    validator: (String? value) {
                      return (value == null)
                          ? null
                          : (value.trim().isEmpty)
                              ? 'Provide an email'
                              : (!RegExp(".+@[a-z]+(\.[a-z]+)+")
                                      .hasMatch(value))
                                  ? "Provide a valid email"
                                  : null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  SessionButtonWidget(
                    icon: Icons.send,
                    text: 'Recover',
                    onPressed: () async {
                      if (this.formKey.currentState!.validate()) {
                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Future.delayed(const Duration(seconds: 1)),
                            message: Text(
                              'Verifying data...',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  SessionButtonWidget(
                    icon: Icons.login,
                    text: 'Log in',
                    onPressed: () => Navigator.of(context)
                        .popUntil(ModalRoute.withName('/')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController();
  final BooleanWrapper hidePassword = BooleanWrapper(value: true);
  final formKey = GlobalKey<FormState>();
  static const double spacing = 15.0;
  final faculties = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
    'Option 6',
    'Option 7',
    'Option 8',
  ];

  SignUpScreen();

  @override
  Widget build(BuildContext context) {
    return SessionBackgroundWidget(
      child: ListView(
        padding: MyUtils.setScreenPadding(context: context),
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Create Account",
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 60,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30.0),
          Form(
            key: this.formKey,
            child: Column(
              children: [
                SessionInputWidget(
                  controller: this._emailController,
                  sessionInputType: SessionInputType.EMAIL,
                  iconData: Icons.email_outlined,
                  hintText: 'Email',
                  validator: (String? value) {
                    return (value == null)
                        ? null
                        : (value.trim().isEmpty)
                            ? 'A valid email is required'
                            : (!RegExp(".+@[a-z]+(\.[a-z]+)+").hasMatch(value))
                                ? "A valid email is required"
                                : null;
                  },
                ),
                const SizedBox(height: spacing),
                SessionInputWidget(
                    controller: this._passwordController,
                    sessionInputType: SessionInputType.PASSWORD,
                    iconData: Icons.vpn_key,
                    hintText: 'Password',
                    validator: (String? value) {
                      if (value == null)
                        return null;
                      else
                        return (value.trim().isEmpty)
                            ? 'A password is required'
                            : (value.length < 6)
                                ? "Password must have at least a length of 6"
                                : null;
                    }),
                const SizedBox(height: spacing),
                SessionInputWidget(
                    controller: this._nameController,
                    sessionInputType: SessionInputType.TEXT,
                    iconData: Icons.person,
                    hintText: 'Name(s)',
                    caps: true,
                    validator: (String? value) {
                      if (value == null)
                        return null;
                      else
                        return (value.trim().isEmpty)
                            ? 'Your name(s) are required'
                            : null;
                    }),
                const SizedBox(height: spacing),
                SessionInputWidget(
                    controller: this._lastNameController,
                    sessionInputType: SessionInputType.TEXT,
                    iconData: Icons.person,
                    hintText: 'Last Name(s)',
                    caps: true,
                    validator: (String? value) {
                      if (value == null)
                        return null;
                      else
                        return (value.trim().isEmpty)
                            ? 'Your last name(s) are required'
                            : null;
                    }),
                const SizedBox(height: spacing),
                SessionInputWidget(
                    controller: this._idController,
                    sessionInputType: SessionInputType.NUMBER,
                    iconData: Icons.featured_video,
                    hintText: 'Id',
                    lastInput: true,
                    validator: (String? value) {
                      if (value == null)
                        return null;
                      else
                        return (value.trim().isEmpty)
                            ? 'An ID is required'
                            : null;
                    }),
                const SizedBox(height: spacing),
                ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  title: SessionInputWidget(
                      controller: this._optionsController,
                      sessionInputType: SessionInputType.TEXT,
                      iconData: Icons.list,
                      hintText: 'Options',
                      readOnly: true,
                      lastInput: true,
                      validator: (String? value) {
                        if (value == null)
                          return null;
                        else
                          return (value.trim().isEmpty)
                              ? 'Please, select an option'
                              : null;
                      }),
                  trailing: SessionButtonWidget(
                    icon: Icons.search,
                    text: null,
                    onPressed: () => {
                      DialogTemplate.showSelectOptions(
                        context: context,
                        title: 'Options',
                        options: const [0, 1, 2, 3, 4, 5, 6, 7],
                        captions: this.faculties,
                        aftermath: (index) => this._optionsController.text =
                            this.faculties[index],
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SessionButtonWidget(
                    icon: Icons.refresh,
                    text: 'Reset',
                    onPressed: () {
                      this._emailController.text = '';
                      this._passwordController.text = '';
                      this._nameController.text = '';
                      this._lastNameController.text = '';
                      this._idController.text = '';
                      this._optionsController.text = '';
                    },
                  ),
                  SessionButtonWidget(
                    icon: Icons.send,
                    text: 'Register',
                    onPressed: () async {
                      String message = '';
                      if (this.formKey.currentState!.validate()) {
                        bool result = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return BinaryAlert(
                                message: 'Is your information correct?',
                                title: 'Warning');
                          },
                        );

                        if (result) {
                          await showDialog(
                            context: context,
                            builder: (context) => FutureProgressDialog(
                              Future.delayed(const Duration(seconds: 3)),
                              message: Text(
                                'Sending data...',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          );

                          message =
                              "Your registration has completed successfully";
                        }
                      } else {
                        message =
                            'Please, fill in the form and make sure that all the data you provide is valid.';
                      }
                      DialogTemplate.showMessage(
                          context: context, message: message);
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              SessionButtonWidget(
                icon: Icons.login,
                text: 'Log in',
                onPressed: () =>
                    Navigator.of(context).popUntil(ModalRoute.withName('/')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
