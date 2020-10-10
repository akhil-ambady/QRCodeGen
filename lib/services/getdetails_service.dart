import 'dart:convert';
import 'package:QRCodeGen/viewmodel/details_viewmodel.dart';

Future<List<Details>> getdetails() async {
  var details = [
    {"name": "Akhil A Ambady", "age": 28},
    {"name": "Nikhil Kumar", "age": 24},
    {"name": "Anil Kumar", "age": 52},
    {"name": "Preetha Anil", "age": 49},
    {"name": "Mukul M L", "age": 35},
    {"name": "Vikram Das", "age": 45},
    {"name": "Aryan V R", "age": 20},
    {"name": "Vishnu T R", "age": 19},
    {"name": "Freeda Francis", "age": 25},
    {"name": "Arjun Santhosh", "age": 30}
  ];
  return detailsFromJson(jsonEncode(details));
}
