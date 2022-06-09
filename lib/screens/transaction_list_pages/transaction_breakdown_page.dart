import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';

class TransactionBreakdownPage extends StatefulWidget {
  const TransactionBreakdownPage({Key? key}) : super(key: key); //??

  @override
  State<TransactionBreakdownPage> createState() =>
      _TransactionBreakdownPageState();
}

class _TransactionBreakdownPageState
    extends AuthRequiredState<TransactionBreakdownPage> {
  final _supabaseClient = TransactionService();

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  // TODO: show available months
  static final _monthString = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // TODO: show earliest year
  static final List<String> _yearString =
      List<int>.generate(50, (index) => DateTime.now().year - index)
          .map((e) => e.toString())
          .toList();

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    CustomDropdownButton selectMonth = CustomDropdownButton(
      menuItems: _monthString,
      title: "Month",
    );

    CustomDropdownButton selectYear = CustomDropdownButton(
      menuItems: _yearString,
      title: "Year",
    );
    IconButton monthYearPopUpButton = IconButton(
        icon: const Icon(Icons.calendar_month),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Select Timeline"),
              actions: <Widget>[
                selectMonth,
                selectYear,
                TextButton(
                  onPressed: () {
                    if (selectMonth.btnSelectedVal == null ||
                        selectYear.btnSelectedVal == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Insert details'),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      setState(() {
                        month =
                            _monthString.indexOf(selectMonth.btnSelectedVal!) +
                                1;
                        year = int.parse(selectYear.btnSelectedVal!);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        });

    FutureBuilder<Map<String, double>> breakdownByCategoryChart =
        FutureBuilder<Map<String, double>>(
            // TODO: change to breakdown by expenses
            future: _supabaseClient.getBreakdownByCategoryFromTime(context,
                month: month, year: year),
            builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading....');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return const Text('No data');
                  } else {
                    // TODO: better color generator
                    final colorList = List<Color>.generate(
                        snapshot.data!.length,
                        (index) =>
                            Colors.blueGrey[index * 100] ??
                            AppColors.brightgreen);
                    return AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(PieChartData(
                        sections:
                            List.generate(snapshot.data?.length ?? 0, (index) {
                          final isTouched = index == touchedIndex;
                          final radius = isTouched ? 60.0 : 50.0;
                          return PieChartSectionData(
                            color: colorList[index],
                            title: snapshot.data?.keys.elementAt(index),
                            value: snapshot.data?.values.elementAt(index),
                            radius: radius,
                          );
                        }),
                        centerSpaceRadius: double.infinity,
                        sectionsSpace: 8,
                        borderData: FlBorderData(show: false),
                        // pieTouchData: PieTouchData(
                        //     touchCallback:
                        //         (FlTouchEvent event, pieTouchResponse) =>
                        //             setState(() {
                        //               if (!event.isInterestedForInteractions ||
                        //                   pieTouchResponse == null) {
                        //                 touchedIndex = -1;
                        //                 return;
                        //               }
                        //               touchedIndex = pieTouchResponse
                        //                   .touchedSection!.touchedSectionIndex;
                        //             }))
                      )),
                    );
                  }
              }
            });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions Breakdown'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_monthString[month - 1]}, $year',
                      style: TextStyles.optionCategoryStyle,
                    ),
                    monthYearPopUpButton,
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                breakdownByCategoryChart,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
