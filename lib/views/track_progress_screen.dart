import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/views/words_list_view.dart';
// Import your WordListScreen

class TrackProgressPage extends StatefulWidget {
  const TrackProgressPage({Key? key}) : super(key: key);

  @override
  _TrackProgressPageState createState() => _TrackProgressPageState();
}

class _TrackProgressPageState extends State<TrackProgressPage> {
  List<FlSpot> _progressData = [];
  String _selectedLanguage = 'English'; // Default language
  List<Map<String, dynamic>> _progressList = [];

  @override
  void initState() {
    super.initState();
  }

  List<FlSpot> downsample(List<FlSpot> data, int threshold) {
    if (data.length <= threshold) return data;
    final step = (data.length / threshold).ceil();
    return [for (int i = 0; i < data.length; i += step) data[i]];
  }

  Stream<QuerySnapshot> _fetchProgressData() {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final trackProgressRef = FirebaseFirestore.instance
          .collection('track_progress')
          .doc(uid)
          .collection(_selectedLanguage);

      return trackProgressRef.snapshots();
    } else {
      return Stream.empty();
    }
  }

  List<Map<String, dynamic>> _processData(QuerySnapshot snapshot) {
    final data = snapshot.docs.map((doc) {
      final docData = doc.data() as Map<String, dynamic>;
      final dateParts = doc.id.split('-');
      final dateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );
      final score = docData['score'] as int;
      return {
        'total':
            (docData['answeredWords'] as Map<String, dynamic>?)?.length ?? 0,
        'dateTime': dateTime,
        'score': score,
        'spot': FlSpot(
          dateTime.millisecondsSinceEpoch.toDouble(),
          score.toDouble(),
        ),
      };
    }).toList();

    return data;
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    final double minX = _progressData.isNotEmpty
        ? _progressData.first.x
        : DateTime.now().millisecondsSinceEpoch.toDouble();
    final double maxX = _progressData.isNotEmpty
        ? max(_progressData.last.x, minX + 4 * 24 * 60 * 60 * 1000)
        : minX + 4 * 24 * 60 * 60 * 1000;

    final double maxY = _progressData.isNotEmpty
        ? max(5, _progressData.map((e) => e.y).reduce(max)).ceilToDouble()
        : 5;

    final double yInterval = maxY / 5;

    return LineChartData(
      gridData: FlGridData(
        show: false, // Disable grid to save memory
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
            showTitles: false, // Hide x-axis labels
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval:
                yInterval > 0 ? yInterval : 1, // Ensure interval is not zero
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: _progressData,
          isCurved: false, // Set to false for linear graph
          color: kAppBarColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: kAppBarColor.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: 150.w,
                    height: 40.h,
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: kAppBarColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          borderRadius: BorderRadius.circular(8),
                          dropdownColor: kAppBarColor,
                          value: _selectedLanguage,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: kAppBarColor, // No underline
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                          },
                          items: <String>[
                            'English',
                            'Spanish',
                            'French',
                            'German',
                            'Italian',
                            'Portuguese',
                            'Chinese',
                            'Japanese',
                            'Polish',
                            'Turkish',
                            'Russian',
                            'Dutch',
                            'Korean'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _fetchProgressData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Text("No Progress Yet"),
                          SizedBox(height: 20),
                          Card(
                            color: Color.fromARGB(255, 204, 198, 255),
                            margin: EdgeInsets.all(8.r),
                            child: ListTile(
                              title: Center(
                                child: Text(
                                  "Start Studying",
                                  style: TextStyle(
                                    fontFamily: kFont,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kAppBarColor,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WordListScreen(
                                      language: _selectedLanguage,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final data = _processData(snapshot.data!);

                  final downsampledData = downsample(
                      data.map((e) => e['spot'] as FlSpot).toList(),
                      100); // Downsample to max 100 points

                  _progressData = downsampledData;
                  _progressList = data
                    ..sort((a, b) => (b['dateTime'] as DateTime)
                        .compareTo(a['dateTime'] as DateTime));

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 204, 198, 255),
                          borderRadius: BorderRadius.circular(
                              16.0), // Adjust the radius as needed
                        ),
                        height: 200.h, // Reduced height for the chart
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: LineChart(
                            mainData(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ..._progressList.map((entry) {
                        final score = entry['score'] as int;
                        final totalWords = entry['total'] as int;
                        final incorrectAnswers = totalWords - score;
                        final color = _progressList.indexOf(entry) % 2 == 0
                            ? kTranslationCardColor
                            : kTranslatorcardColor;

                        return Card(
                          color: color,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Text(
                              '${entry['dateTime'].year}-${entry['dateTime'].month}-${entry['dateTime'].day}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            trailing: CircularPercentIndicator(
                              radius: 20.0,
                              lineWidth: 8.0,
                              percent: incorrectAnswers / totalWords,
                              center: Text(
                                '$score',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              progressColor:
                                  const Color.fromARGB(255, 245, 136, 128),
                              backgroundColor:
                                  const Color.fromARGB(255, 154, 255, 158),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
