import 'package:flutter/material.dart';
import 'package:fyp/user/bookedDetails.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleSlotsPage extends StatefulWidget {
  const ScheduleSlotsPage({super.key});

  @override
  State<ScheduleSlotsPage> createState() => _ScheduleSlotsPageState();
}

class _ScheduleSlotsPageState extends State<ScheduleSlotsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, List<String>> _bookedSlots = {
    DateTime.now(): ['9:00 AM - 10:00 AM', '1:00 PM - 2:00 PM'],
    DateTime.now().add(const Duration(days: 1)): ['11:00 AM - 12:00 PM'],
  };

  List<String> _getSlotsForDay(DateTime day) {
    return _bookedSlots[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Slots", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 30)),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade200,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                final startHour = 9 + index;
                final slotTime =
                    '${_formatTime(startHour)} AM - ${_formatTime(startHour + 1)} AM';

                bool isBooked = _getSlotsForDay(
                  _selectedDay,
                ).contains(slotTime);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      slotTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isBooked ? 'Booked' : 'Available',
                      style: TextStyle(
                        color: isBooked ? Colors.red : Colors.green,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed:
                              isBooked
                                  ? null
                                  : () {
                                    setState(() {
                                      _bookedSlots[_stripTime(_selectedDay)] = [
                                        ..._getSlotsForDay(_selectedDay),
                                        slotTime,
                                      ];
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BookedDetailsPage(
                                              futsalName:
                                                  'Futsal Name', // Add appropriate values
                                              futsalImageUrl:
                                                  'https://via.placeholder.com/200', // Replace with actual URL
                                              fieldType: '5A side',
                                              price: 'Hourly: Rs. 500',
                                              date:
                                                  _selectedDay
                                                      .toLocal()
                                                      .toString(),
                                              time: slotTime,
                                            ),
                                      ),
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isBooked ? Colors.red : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed:
                              isBooked
                                  ? null
                                  : () {
                                    _bookSlotForMonth(_selectedDay, slotTime);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BookedDetailsPage(
                                              futsalName:
                                                  'Futsal Name', // Add appropriate values
                                              futsalImageUrl:
                                                  'https://via.placeholder.com/200', // Replace with actual URL
                                              fieldType: '5A side',
                                              price: 'Monthly: Rs. 5000',
                                              date:
                                                  _selectedDay
                                                      .toLocal()
                                                      .toString(),
                                              time: slotTime,
                                            ),
                                      ),
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isBooked ? Colors.red : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Book Monthly',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _bookSlotForMonth(DateTime day, String slotTime) {
    final year = day.year;
    final month = day.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int d = 1; d <= daysInMonth; d++) {
      final dateKey = DateTime(year, month, d);
      final existingSlots = _getSlotsForDay(dateKey);
      if (!existingSlots.contains(slotTime)) {
        _bookedSlots[dateKey] = [...existingSlots, slotTime];
      }
    }
  }

  String _formatTime(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return h.toString();
  }

  DateTime _stripTime(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}
