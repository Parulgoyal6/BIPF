import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAchievementsChart extends StatelessWidget {

  List<String> get months {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('MMM');
    return List.generate(6, (index) {
      final month = DateTime(now.year, now.month - (5 - index));
      return formatter.format(month);
    });
  }

  // final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  final List<double> eventsData =[5, 8, 12, 10, 20, 15];
  final List<double> activitiesData = [10, 20, 15, 25, 30, 35];
  final List<double> beneficiariesData =  [30, 40, 25, 35, 60, 50];

  // Calculate the maxY used for all charts for consistent grid lines
  double getMaxY() {
    double maxEvents = eventsData.reduce((a, b) => a > b ? a : b);
    double maxActivities = activitiesData.reduce((a, b) => a > b ? a : b);
    double maxBeneficiaries = beneficiariesData.reduce((a, b) => a > b ? a : b);

    return [maxEvents, maxActivities, maxBeneficiaries].reduce((a, b) => a > b ? a : b) + 10;
  }

  @override
  Widget build(BuildContext context) {
    final double maxY = getMaxY();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'My Achievements',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSummaryBox(),
              const SizedBox(height: 30),
              buildChartSection("Beneficiaries", beneficiariesData, Colors.blue, Icons.group, maxY),
              const SizedBox(height: 30),
              buildChartSection("Activities", activitiesData, Colors.orange, Icons.event, maxY),
              const SizedBox(height: 30),
              buildChartSection("Events", eventsData, Colors.green, Icons.emoji_events, maxY),
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSummaryBox() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.yellow.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSummaryRow(Colors.blue, 'Beneficiaries', 140),
          buildSummaryRow(Colors.orange, 'Activities', 135),
          buildSummaryRow(Colors.green, 'Events', 70),
        ],
      ),
    );
  }

  Widget buildChartSection(
      String title, List<double> data, Color color, IconData iconData, double maxY) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$title per Month',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(
              iconData,
              color: color,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 220, // a bit taller for labels
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = 20.0;
              final spaceBetweenBars = (constraints.maxWidth - (data.length * barWidth)) / (data.length + 1);

              return Stack(
                children: [
                  BarChart(
                    BarChartData(
                      maxY: maxY,
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 10,
                        drawVerticalLine: true,
                        verticalInterval: 1,
                      ),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            getTitlesWidget: (value, meta) =>
                                Text('${value.toInt()}', style: TextStyle(fontSize: 10)),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < 0 || index >= months.length) return SizedBox.shrink();

                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  months[index],
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(data.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: data[i],
                              color: color,
                              width: barWidth,
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ],
                        );
                      }),
                      alignment: BarChartAlignment.spaceAround,
                    ),
                  ),
                  // Labels on top of bars
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final containerHeight = 200; // bar chart container height
                        final barWidth = 20.0;
                        final spacing = (constraints.maxWidth - (data.length * barWidth)) / (data.length + 1);

                        return Stack(
                          children: List.generate(data.length, (i) {
                            final heightFactor = data[i] / maxY;
                            final bottomOffset = (containerHeight * heightFactor) + 22;
                            final leftPosition = spacing + i * (barWidth + spacing) + barWidth / 2;

                            return Positioned(
                              left: leftPosition,
                              bottom: bottomOffset,
                              width: barWidth,
                              child: Center(
                                child: Text(
                                  data[i].toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildSummaryRow(Color color, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Text(
            '$label: $value',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
