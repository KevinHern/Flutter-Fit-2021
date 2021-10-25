// Basic Imports
import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:provider/provider.dart';

// Models
import 'package:sp2_presentation/models/navigation_model.dart';

// Templates
import 'package:sp2_presentation/templates/dialog_template.dart';

class MyCartScreen extends StatefulWidget {
  final List<String> myCart;
  MyCartScreen({required this.myCart});

  MyCartScreenState createState() => MyCartScreenState(myCart: this.myCart);
}

class MyCartScreenState extends State<MyCartScreen> {
  final List<String> myCart;
  MyCartScreenState({required this.myCart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: ListView.builder(
            padding: MyUtils.setScreenPadding(context: context),
            itemCount: this.myCart.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.menu),
                  title: Text(
                    this.myCart[index],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shadowColor: Colors.black26),
                    child: Icon(Icons.remove_circle),
                    onPressed: () {
                      this.myCart.removeAt(index);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).accentColor,
            shadowColor: Colors.black26,
          ),
          icon: Icon(
            Icons.check,
            color: (this.myCart.isEmpty) ? Colors.black : Colors.white,
          ),
          label: Text(
            "Buy",
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
              fontSize: 20,
              color: (this.myCart.isEmpty) ? Colors.black : Colors.white,
            ),
          ),
          onPressed: (this.myCart.isEmpty)
              ? null
              : () async {
                  await showDialog(
                    context: context,
                    builder: (context) => FutureProgressDialog(
                      Future.delayed(const Duration(seconds: 2)),
                      message: Text(
                        'Completing transaction...',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  );
                  await DialogTemplate.showMessage(
                      context: context,
                      message: "Transaction has been completed successfully");
                  Provider.of<NavigationModel>(context, listen: false)
                      .popRoute();
                },
        ),
      ],
    );
  }
}
