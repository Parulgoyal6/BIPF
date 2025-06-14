import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  final Map<String, MaterialColor> baseColors = {
    'Beneficiaries': Colors.teal,
    'Events': Colors.orange,
    'Activities': Colors.purple,
  };

  final currentMonth = "June";
  final previousMonth = "May";

  final Map<String, List<int>> targetData = {
    'Beneficiaries': [90, 100], // [Previous, Current]
    'Events': [50, 60],
    'Activities': [70, 80],
  };

  final Map<String, List<int>> achievedData = {
    'Beneficiaries': [75, 80],
    'Events': [45, 45],
    'Activities': [60, 65],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSummaryBox(),
              SizedBox(height: 30),
              ...targetData.keys.map((metric) {
                final target = targetData[metric]!;
                final achieved = achievedData[metric]!;
                final color = baseColors[metric]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildChartCard(
                    metric,
                    achieved,
                    target,
                    color.shade100,
                    color,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  double calculateMaxY(List<int> targets, List<int> actuals) {
    final allValues = [...targets, ...actuals];
    final highest = allValues.reduce((a, b) => a > b ? a : b);
    return (highest / 20).ceil() * 20 + 20;
  }

  Widget buildChartCard(
      String title,
      List<int> actualValues,
      List<int> targetValues,
      Color targetColor,
      Color actualColor,
      ) {
    double maxX = calculateMaxY(targetValues, actualValues).toDouble();
    double interval = maxX / 5;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child:Stack(children: [
              BarChart(
                BarChartData(
                  maxY: maxX,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.shade200,
                      tooltipPadding: const EdgeInsets.all(6),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()}',
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),


                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        getTitlesWidget: (value, _) {
                          return Text('${value.toInt()}');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 0:
                              return Text(previousMonth, style: TextStyle(fontSize: 10));
                            case 1:
                              return Text(currentMonth, style: TextStyle(fontSize: 10));
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barsSpace: 8,
                      barRods: [
                        BarChartRodData(toY: targetValues[0].toDouble(), color: targetColor, width: 18, borderRadius: BorderRadius.circular(0)),
                        BarChartRodData(toY: actualValues[0].toDouble(), color: actualColor, width: 18, borderRadius: BorderRadius.circular(0)),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barsSpace: 10,
                      barRods: [
                        BarChartRodData(toY: targetValues[1].toDouble(), color: targetColor, width: 18, borderRadius: BorderRadius.circular(0)),
                        BarChartRodData(toY: actualValues[1].toDouble(), color: actualColor, width: 18, borderRadius: BorderRadius.circular(0)),
                      ],
                    ),
                  ],
                ),

              ),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate bar chart height
                      double chartHeight = constraints.maxHeight;
                      double barMax = maxX;

                      // Calculate bar heights relative to chart
                      double calcTop(double value) {
                        return chartHeight - (value / barMax * chartHeight) - 26; // 16 for padding from top of bar
                      }

                      return Stack(
                        children: [
                          // Previous month group (x: 0)
                          Positioned(
                            left: constraints.maxWidth * 0.30,
                            top: calcTop(targetValues[0].toDouble()),
                            child: Text('${targetValues[0]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Positioned(
                            left: constraints.maxWidth * 0.40,
                            top: calcTop(actualValues[0].toDouble()),
                            child: Text('${actualValues[0]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),

                          // Current month group (x: 1)
                          Positioned(
                            left: constraints.maxWidth * 0.65,
                            top: calcTop(targetValues[1].toDouble()),
                            child: Text('${targetValues[1]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Positioned(
                            left: constraints.maxWidth * 0.75,
                            top: calcTop(actualValues[1].toDouble()),
                            child: Text('${actualValues[1]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              ]),

            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLegendDot(targetColor, "Target"),
                SizedBox(width: 12),
                buildLegendDot(actualColor, "Achieved"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget buildSummaryBox() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        // borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.yellow.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: targetData.keys.map((metric) {
          final base = baseColors[metric]!;
          return Column(
            children: [
              buildSummaryRow(base, '$previousMonth Target $metric', targetData[metric]![0]),
              buildSummaryRow(base.shade100, '$previousMonth Achieved $metric', achievedData[metric]![0]),
              buildSummaryRow(base, '$currentMonth Target $metric', targetData[metric]![1]),
              buildSummaryRow(base.shade100, '$currentMonth Achieved $metric', achievedData[metric]![1]),
              SizedBox(height: 6),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildSummaryRow(Color color, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 12, height: 12, color: color),
          SizedBox(width: 8),
          Expanded(child: Text('$label: $value')),
        ],
      ),
    );
  }
}
