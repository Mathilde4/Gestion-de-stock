import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TotalComparisonChart extends StatelessWidget {
  final double totalPurchase;
  final double totalSales;

  TotalComparisonChart({required this.totalPurchase, required this.totalSales});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 400,
        width: 500,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: totalPurchase > totalSales ? totalPurchase : totalSales,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: totalPurchase,
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      color: Colors.indigoAccent,
                    ),
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: totalSales,
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      color: Colors.greenAccent,
                    ),
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const style = TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                    Widget text;
                    switch (value.toInt()) {
                      case 0:
                        text = const Text('Ajout de stock', style: style);
                        break;
                      case 1:
                        text = const Text('Vente', style: style);
                        break;
                      default:
                        text = const Text('', style: style);
                        break;
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: text,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
