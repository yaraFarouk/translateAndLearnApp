import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class TrackProgressPage extends StatefulWidget {
  const TrackProgressPage({Key? key}) : super(key: key);

  @override
  _TrackProgressPageState createState() => _TrackProgressPageState();
}

class _TrackProgressPageState extends State<TrackProgressPage> {
  List<FlSpot> _progressData = [];
  String _selectedLanguage = 'English'; // Default language
  List<String> _languages = [
    'English',
    'Spanish',
    'French'
  ]; // Add your languages here

  @override
  void initState() {
    super.initState();
    _fetchProgressData();
  }

  Future<void> _fetchProgressData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final trackProgressRef = FirebaseFirestore.instance
          .collection('track_progress')
          .doc(uid)
          .collection(_selectedLanguage);

      final querySnapshot = await trackProgressRef.get();
      final data = querySnapshot.docs.map((doc) {
        final dateParts = doc.id.split('-');
        final dateTime = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        );
        final score = doc.data()?['score'] as int;
        return FlSpot(
            dateTime.millisecondsSinceEpoch.toDouble(), score.toDouble());
      }).toList();

      setState(() {
        _progressData = data;
      });
    }
  }

  Future<void> _storeProgressData(DateTime dateTime, double score) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final trackProgressRef = FirebaseFirestore.instance
          .collection('track_progress')
          .doc(uid)
          .collection(_selectedLanguage)
          .doc('${dateTime.year}-${dateTime.month}-${dateTime.day}');

      await trackProgressRef.set({'score': score});
      await _fetchProgressData(); // Refresh data after storing
    }
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: _progressData.isNotEmpty ? _progressData.first.x : 0,
      maxX: _progressData.isNotEmpty ? _progressData.last.x : 0,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: _progressData,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff232d37),
      appBar: AppBar(
        backgroundColor: const Color(0xff232d37),
        title: Text('Progress in $_selectedLanguage'),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
                _fetchProgressData(); // Fetch data for the new language
              });
            },
            items: _languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: _progressData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No progress data available for $_selectedLanguage.',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle action for taking a quiz or adding progress
                    },
                    child: Text('Take a quiz and get your progress'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
    );
  }
}
