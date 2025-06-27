import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:sns_pocketbase_app/utils/translations.dart';

class CalendarView extends StatefulWidget {
  final Map<DateTime, List<String>> events;

  const CalendarView({super.key, required this.events});

  static Future<Map<DateTime, List<String>>> fetchGoogleSheetData() async {
    try {
      String credentials = await rootBundle.loadString('assets/credentials.json');
      final accountCredentials = ServiceAccountCredentials.fromJson(json.decode(credentials));

      final scopes = [sheets.SheetsApi.spreadsheetsReadonlyScope];
      final authClient = await clientViaServiceAccount(accountCredentials, scopes);
      final sheetsApi = sheets.SheetsApi(authClient);

      const spreadsheetId = '1IvZwFYh0L5N8FQiDt_Cz_Bn2ZcA2iPcQ5qtRsgGrbz4';
      const range = 'Events List!A:D';

      final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);

      Map<DateTime, List<String>> fetchedEvents = {};
      if (response.values != null) {
        for (var i = 1; i < response.values!.length; i++) {
          String yearString = response.values![i][0].toString();
          String monthString = response.values![i][1].toString();
          String dayString = response.values![i][2].toString();
          String eventTitle = response.values![i][3].toString();

          try {
            DateTime date = DateTime(
              int.parse(yearString),
              int.parse(monthString),
              int.parse(dayString),
            );

            if (fetchedEvents[date] == null) {
              fetchedEvents[date] = [];
            }
            fetchedEvents[date]?.add(eventTitle);
          } catch (e) {
            print('Error parsing date: $e');
          }
        }
      } else {
        print('No data found in the spreadsheet.');
      }

      authClient.close();
      return fetchedEvents;
    } catch (e) {
      print('Error fetching Google Sheet data: $e');
      return {};
    }
  }

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<String> _getEventsForDay(DateTime day) {
    return widget.events[_normalizeDate(day)] ?? [];
  }

  String translate(BuildContext context, String key) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    String currentLanguage = languageProvider.currentLanguage;
    return translations[currentLanguage]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    // Detect current brightness (light or dark mode)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Change background color dynamically
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        // title: Text(
        //   translate(context, 'bec_news_calendar'), // Translated title
        //   style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: isDarkMode ? Colors.grey[850] : Colors.grey[200], // Change card color dynamically
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: _getEventsForDay,
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    weekendTextStyle: TextStyle(color: isDarkMode ? Colors.blueAccent : Colors.redAccent),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(Icons.chevron_left, color: isDarkMode ? Colors.white : Colors.black),
                    rightChevronIcon: Icon(Icons.chevron_right, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  calendarFormat: CalendarFormat.month,
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty
                      ? ListView(
                          children: _getEventsForDay(_selectedDay!)
                              .map((event) => Card(
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: ListTile(
                                      title: Text(
                                        event,
                                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : Center(
                          child: Text(
                            translate(context, 'no_events'), // Translated "No Events" text
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
