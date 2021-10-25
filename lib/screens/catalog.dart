// Basic Imports
import 'package:flutter/material.dart';
import '../utils.dart';
import 'package:provider/provider.dart';

// Models
import 'package:sp2_presentation/models/navigation_model.dart';

class CatalogScreen extends StatefulWidget {
  final List<String> items;
  CatalogScreen({required this.items});

  CatalogScreenState createState() => CatalogScreenState(items: this.items);
}

class CatalogScreenState extends State<CatalogScreen> {
  final List<String> items;
  late List<String> myCart;
  CatalogScreenState({required this.items}) {
    this.myCart = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: MyUtils.setScreenPadding(context: context),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              shadowColor: Colors.black26,
            ),
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(
              "Go to cart",
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Provider.of<NavigationModel>(context, listen: false).pushRoute(
                  route: NavigationModel.subScreens[0],
                  arguments: [this.myCart]);
            },
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            padding: MyUtils.setScreenPadding(context: context),
            itemCount: this.items.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: !this.myCart.contains(this.items[index]),
                child: Card(
                  child: ListTile(
                    title: Text(
                      this.items[index],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    leading: Icon(Icons.menu),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shadowColor: Colors.black26,
                      ),
                      child: Icon(Icons.add),
                      onPressed: () {
                        this.myCart.add(this.items[index]);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
