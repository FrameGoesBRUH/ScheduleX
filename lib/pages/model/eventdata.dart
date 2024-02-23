import '../model/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource<Event> {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }
  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;
  @override
  DateTime getEndTime(int index) => getEvent(index).to;
  @override
  String getSubject(int index) => getEvent(index).title;
  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
  @override
  Color getColor(int index) => getEvent(index).backgroundColor;
  @override
  String getNotes(int index) => getEvent(index).description;
  @override
  String getRecurrenceRule(int index) => getEvent(index).recurrenceRule;
  @override
  String getId(int index) => getEvent(index).id;
  @override
  Event? convertAppointmentToObject(
      Event? customData, Appointment appointment) {
// TODO: implement convertAppointmentToObject
    return Event(
      from: appointment.startTime,
      to: appointment.endTime,
      description: appointment.notes!,
      title: appointment.subject,
      backgroundColor: appointment.color,
      isAllDay: appointment.isAllDay,
//id: appointment.id,
      id: appointment.id.toString(),
      recurrenceRule: appointment.recurrenceRule!,
//recurrenceId: appointment.recurrenceId,
//exceptionDates: appointment.recurrenceExceptionDates,

      department: customData!.department,
    );
  }
}
