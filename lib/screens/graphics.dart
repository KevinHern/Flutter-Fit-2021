// Basic Imports
import 'package:flutter/material.dart';
import '../utils.dart';

// Charts
import 'charts/line_chart.dart';
import 'charts/pie_chart.dart';
import 'charts/scatter_plot.dart';
import 'charts/radar_chart.dart';

// Templates
import 'package:sp2_presentation/templates/common_assets_template.dart';

class GraphicsTitle extends StatelessWidget {
  final String title;
  GraphicsTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.025,
      ),
      child: Card(
        elevation: 5,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              this.title,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.subtitle1!.fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GraphicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: MyUtils.setScreenPadding(context: context),
      children: [
        GraphicsTitle(
          title: "Line Chart",
        ),
        LineChartSample1(),
        ResponsiveDivider(),
        GraphicsTitle(
          title: "Pie Chart",
        ),
        PieChartSample2(),
        ResponsiveDivider(),
        GraphicsTitle(
          title: "Scatter Plot",
        ),
        ScatterChartSample1(),
        ResponsiveDivider(),
        GraphicsTitle(
          title: "Radar Chart",
        ),
        Card(
          elevation: 5.0,
          child: Container(
            child: RadarChartSample1(),
          ),
        ),
      ],
    );
  }
}
