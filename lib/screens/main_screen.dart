// Basic Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:sp2_presentation/screens/AI/ai_day_2_night.dart';

// Screens
import 'AI/ai_art.dart';
import 'AI/ai_number.dart';
import 'profile.dart';
import 'catalog.dart';
import 'shop_cart.dart';
import 'graphics.dart';
import 'menu.dart';

// Models
import 'package:sp2_presentation/models/navigation_model.dart';

// Templates
import 'package:sp2_presentation/templates/dialog_template.dart';

class MainScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationModel>(
            create: (context) =>
                NavigationModel(currentScreen: '/profile', arguments: []),
          ),
          ChangeNotifierProvider<ValueNotifier<int>>(
            create: (context) => ValueNotifier<int>(0),
          ),
        ],
        child: Scaffold(
          key: this._scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'FIT Flutter Demo',
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.90),
                ),
              ),
            ),
          ),
          drawer: NavDrawer(
            scaffoldKey: this._scaffoldKey,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                //currentFocus.unfocus();
              }
            },
            child: Consumer<NavigationModel>(
              builder: (_, navigationModel, __) {
                return WillPopScope(
                  onWillPop: () async {
                    if (navigationModel.currentLevel > 1) {
                      navigationModel.popRoute();
                      return false;
                    } else {
                      bool logOut = await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return BinaryAlert(
                                message:
                                    'Are you sure you want to close session?',
                                title: 'Warning');
                          }).catchError((error) {
                        print('Error on Log Out dialog: ${error.toString()}');
                        return false;
                      });
                      if (logOut) {
                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Future.delayed(const Duration(seconds: 1)),
                            message: Text(
                              'Closing session...',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        );

                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        return true;
                      } else
                        return false;
                    }
                  },
                  child: SwitchScreen(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NavDrawerTile extends StatelessWidget {
  final int screenNumber;
  final IconData icon;
  final String title;
  final arguments;

  NavDrawerTile(
      {required this.screenNumber,
      required this.title,
      required this.icon,
      @required this.arguments});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        this.icon,
        color: Theme.of(context).primaryColorDark,
      ),
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Provider.of<ValueNotifier<int>>(context, listen: false).value =
            this.screenNumber;
        Provider.of<NavigationModel>(context, listen: false).clearThenPush(
            route: NavigationModel.screens[this.screenNumber],
            arguments: this.arguments);
      },
      tileColor:
          (Provider.of<ValueNotifier<int>>(context, listen: false).value ==
                  this.screenNumber)
              ? Theme.of(context).primaryColorLight.withOpacity(0.5)
              : null,
    );
  }
}

class NavDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final greyOpacity = 0.5;
  NavDrawer({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            decoration: FlutterLogoDecoration(),
          ),
          NavDrawerTile(
              screenNumber: 0,
              title: "Account",
              icon: Icons.person,
              arguments: null),
          NavDrawerTile(
              screenNumber: 1,
              title: "Catalog",
              icon: Icons.shopping_bag,
              arguments: null),
          NavDrawerTile(
              screenNumber: 2,
              title: "Charts",
              icon: Icons.pie_chart,
              arguments: null),
          NavDrawerTile(
              screenNumber: 3,
              title: "Menu",
              icon: Icons.dashboard,
              arguments: null),
          NavDrawerTile(
              screenNumber: 4,
              title: "Generative Art",
              icon: Icons.art_track,
              arguments: null),
          NavDrawerTile(
              screenNumber: 5,
              title: "Numbers",
              icon: Icons.confirmation_number,
              arguments: null),
          NavDrawerTile(
              screenNumber: 6,
              title: "Landscape",
              icon: Icons.brightness_2,
              arguments: null),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              'Log Out',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () async {
              bool logOut = await showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return BinaryAlert(
                        message: 'Are you sure you want to close session?',
                        title: 'Warning');
                  }).catchError((error) {
                print('Error on Log Out dialog: ${error.toString()}');
                return false;
              });
              if (logOut) {
                await showDialog(
                  context: context,
                  builder: (context) => FutureProgressDialog(
                    Future.delayed(const Duration(seconds: 3)),
                    message: Text(
                      'Clossing session...',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                );

                Navigator.popUntil(context, ModalRoute.withName('/'));
              }
            },
          ),
        ],
      ),
    );
  }
}

class SwitchAnimatedWidget extends StatelessWidget {
  final Widget child;

  SwitchAnimatedWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return TranslationAnimatedWidget.tween(
      enabled: true,
      translationDisabled: Offset(200, 0),
      translationEnabled: Offset(0, 0),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInCubic,
      child: OpacityAnimatedWidget.tween(
        enabled: true,
        opacityDisabled: 0,
        opacityEnabled: 1,
        child: this.child,
      ),
    );
  }
}

class SwitchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationModel>(builder: (_, navigationModel, __) {
      switch (navigationModel.currentScreen) {
        case '/profile':
          return SwitchAnimatedWidget(
            child: ProfileScreen(),
          );
        case '/catalog':
          return SwitchAnimatedWidget(
            child: CatalogScreen(
              items: [
                "Chocolates",
                "Crayones",
                "Lapiceros",
                "Pringles",
                "Kisses",
                "Ventiladores",
                "Laptop",
                "Mouse inalambrico",
                "Alcohol en gel",
                "Mascarillas",
                "Desinfectante",
                "Antibioticos",
              ],
            ),
          );
        case '/cart':
          return SwitchAnimatedWidget(
            child: MyCartScreen(
              myCart: navigationModel.arguments[0] as List<String>,
            ),
          );
        case '/charts':
          return SwitchAnimatedWidget(
            child: GraphicsScreen(),
          );
        case '/dashboard':
          return SwitchAnimatedWidget(
            child: MenuScreen(),
          );
        case '/aiart':
          return SwitchAnimatedWidget(
            child: AIArtScreen(),
          );
        case '/ainumber':
          return SwitchAnimatedWidget(
            child: AINumberScreen(),
          );
        case '/day2night':
          return SwitchAnimatedWidget(
            child: AIDay2NightScreen(),
          );
        default:
          throw Exception('Unreachable Screen');
      }
    });
  }
}
