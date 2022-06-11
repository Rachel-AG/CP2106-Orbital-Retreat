import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key); //??

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends AuthRequiredState<OverviewPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              monthYearPopUpButton(),
              Text(
                '${_monthString[month - 1]}, $year',
                style: TextStyles.optionTextStyle,
              ),
            ],
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            color: Colors.white70,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Categories",
                        style: TextStyles.optionCategoryStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  FutureBuilder<Map<String, double>>(
                      // TODO: change to breakdown by expenses
                      future: _supabaseClient.getBreakdownByCategoryFromTime(
                          context,
                          month: month,
                          year: year),
                      builder: (context,
                          AsyncSnapshot<Map<String, double>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData &&
                              !snapshot.data!.values.fold(
                                  true,
                                  (previousValue, element) =>
                                      previousValue && element == 0.0)) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: AspectRatio(
                                      aspectRatio: 1,
                                      child: PieChart(
                                          pieChartMainData(snapshot.data!))),
                                ),
                                ...pieChartLegend(snapshot.data!),
                              ],
                            );
                          } else {
                            return const Text(
                              'No Transactions Recorded',
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  IconButton monthYearPopUpButton() {
    CustomDropdownButton selectMonth = CustomDropdownButton(
      menuItems: _monthString,
      title: "Month",
    );
    CustomDropdownButton selectYear = CustomDropdownButton(
      menuItems: _yearString,
      title: "Year",
    );
    return IconButton(
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
  }

  List<Widget> pieChartLegend(Map<String, double> breakdownByCategoryData) {
    final categories = breakdownByCategoryData.keys.toList();
    final amount = breakdownByCategoryData.values.toList();

    return List.generate(
        categories.length,
        (index) => Column(
              children: [
                index == 0
                    ? const SizedBox(
                        height: 24.0,
                      )
                    : const Divider(
                        height: 20,
                        thickness: 2,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(categories[index]),
                    Text('\$${amount[index].toString()}'),
                  ],
                ),
              ],
            ));
  }

  PieChartData pieChartMainData(Map<String, double> breakdownByCategoryData) {
    final double totalTransactions = breakdownByCategoryData.values.reduce(
      (value, element) => value + element,
    );

    return PieChartData(
      sections: List.generate(breakdownByCategoryData.length, (index) {
        final isTouched = index == touchedIndex;
        final radius = isTouched ? 60.0 : 50.0;
        final String category = breakdownByCategoryData.keys.elementAt(index);
        final double amount = breakdownByCategoryData.values.elementAt(index);
        final int percentage = (amount / totalTransactions * 100).round();

        return PieChartSectionData(
          color: Colors.primaries[index],
          title: '$category ($percentage%)',
          titleStyle: TextStyles.chartLabelStyle(),
          titlePositionPercentageOffset: 1,
          value: amount,
          radius: radius,
        );
      }),
      centerSpaceRadius: double.infinity,
      sectionsSpace: 8,
      borderData: FlBorderData(show: false),
    );
  }
}
