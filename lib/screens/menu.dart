// Basic Imports
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Templates
import 'package:sp2_presentation/templates/grid_template.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Grid(
      numColumns: 2,
      children: [
        LargeTile(
          icon: Icon(
            Icons.account_box_rounded,
            color: Colors.white,
            size: 40.0,
          ),
          title: 'Account',
          backgroundColor: Colors.blueAccent,
          onTap: () {},
        ),
        BoxTile(
            icon: Icon(
              Icons.supervisor_account_sharp,
              color: Colors.white,
              size: 40.0,
            ),
            title: 'Classroom',
            backgroundColor: Colors.purple,
            onTap: () {}),
        BoxTile(
            icon: Icon(
              Icons.developer_board,
              color: Colors.white,
              size: 40.0,
            ),
            title: 'View\nCourses',
            backgroundColor: Colors.red,
            onTap: () {}),
        BoxTile(
            icon: Icon(
              Icons.show_chart,
              color: Colors.white,
              size: 40.0,
            ),
            title: 'Grades',
            backgroundColor: Colors.orange,
            onTap: () {}),
        BoxTile(
            icon: Icon(
              Icons.list,
              color: Colors.white,
              size: 40.0,
            ),
            title: 'Pensum',
            backgroundColor: Colors.yellow,
            onTap: () {}),
        BoxTile(
            icon: Icon(
              Icons.assignment,
              color: Colors.white,
              size: 40.0,
            ),
            title: 'Assign\nCourses',
            backgroundColor: Colors.green,
            onTap: () {}),
        BoxTile(
            icon: Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 40.0,
            ),
            title: 'Pay Debts',
            backgroundColor: Color(0xFF2bd9b3),
            onTap: () {}),
        LargeTile(
          icon: Icon(
            Icons.help,
            color: Colors.white,
            size: 40.0,
          ),
          title: 'Help',
          backgroundColor: Colors.blue,
          onTap: () {},
        ),
      ],
      staggeredTiles: [
        StaggeredTile.fit(2),
        StaggeredTile.fit(1),
        StaggeredTile.fit(1),
        StaggeredTile.fit(1),
        StaggeredTile.fit(1),
        StaggeredTile.fit(1),
        StaggeredTile.fit(1),
        StaggeredTile.fit(2),
      ],
    );
  }
}
