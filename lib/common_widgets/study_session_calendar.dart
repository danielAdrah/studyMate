import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';
import '../model/study_session.dart';

class StudySessionCalendar extends StatefulWidget {
  final String groupId;
  final Function(StudySession) onSessionSelected;

  const StudySessionCalendar({
    super.key,
    required this.groupId,
    required this.onSessionSelected,
  });

  @override
  State<StudySessionCalendar> createState() => _StudySessionCalendarState();
}

class _StudySessionCalendarState extends State<StudySessionCalendar> {
  late final ValueNotifier<List<StudySession>> _selectedSessions;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedSessions = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedSessions.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean up any range selection
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedSessions.value = [];
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    _selectedSessions.value = [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<StudySession>(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 10, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      
      calendarStyle: CalendarStyle(
        // Use theme colors
        todayDecoration: BoxDecoration(
          color: TColor.primary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: TColor.primary,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle().copyWith(color: TColor.error),
        outsideDaysVisible: false,
      ),
      
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(Icons.chevron_left, color: TColor.primary),
        rightChevronIcon: Icon(Icons.chevron_right, color: TColor.primary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: TColor.onSurface,
        ),
      ),
    );
  }
}