import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

Map<String,String>createHeader(){
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '<Your token>'
  };
  return requestHeaders;
}

Map<String,String>createHeaderWithAuth(String token){
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  return requestHeaders;
}

String formatDateFromString( String date){
  var formatter = new DateFormat.yMMMMd('en_US');
  String formatted = formatter.format(DateTime.tryParse(date));
  return formatted; // something like 2013-04-20
}

String formatTimeFromString( String date){
  var formatter = new DateFormat('hh:mm a');
  String formatted = formatter.format(DateTime.tryParse(date).toLocal());
  return formatted;// something like 2013-04-20
}

String formatMonthFromString( String date){
  var formatter = new DateFormat.yMMMM('en_US');
  String formatted = formatter.format(DateTime.tryParse(date));
  return formatted; // something like 2013-04-20
}

DateTime getDateTimeFromString( String date){
  var formatter = new DateFormat.yMMMMd('en_US');
  return DateTime.tryParse(date).toLocal(); // something like 2013-04-20
}

TimeOfDay getTimeFromString( String date){
  var formatter = new DateFormat.yMMMMd('en_US');
  DateTime dateTime = DateTime.tryParse(date).toLocal();
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  TimeOfDay timeOfDay = new TimeOfDay(hour: hour,minute: minute);
  return timeOfDay; // something like 2013-04-20
}

bool compareDate(DateTime a,DateTime b){
  if(a.day==b.day&&a.month==b.month&&a.year==b.year)
    return true;
  return false;
}