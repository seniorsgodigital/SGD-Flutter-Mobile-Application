import 'dart:ui';

import 'package:flutter/material.dart';

enum AppointmentEnum { pending, accept, cancel, reject }

String appointmentButtonSender(AppointmentEnum value) {
  switch (value) {
    case AppointmentEnum.pending:
      return "Cancel Now";
    case AppointmentEnum.accept:
      return "Accepted";
    case AppointmentEnum.cancel:
      return "Cancelled";
    case AppointmentEnum.reject:
      return "Rejected";
  }
}

Color appointmentButtonColorSender(AppointmentEnum value) {
  switch (value) {
    case AppointmentEnum.pending:
      return Colors.lightBlue;
    case AppointmentEnum.accept:
      return Colors.green;
    case AppointmentEnum.cancel:
      return Colors.grey;
    case AppointmentEnum.reject:
      return Colors.redAccent;
  }
}



String appointmentButtonReceiver(AppointmentEnum value) {
  switch (value) {
    case AppointmentEnum.pending:
      return "Accept Now";
    case AppointmentEnum.accept:
      return "Accepted";
    case AppointmentEnum.cancel:
      return "Cancelled";
    case AppointmentEnum.reject:
      return "Rejected";
  }
}


