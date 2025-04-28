// ignore_for_file: unused_import

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

final bool debug = false;
//firebase instance
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

bool viewAsList = true;

//navigation
final List<NavigationDestination> navItems = [
  NavigationDestination(icon: Icon(Icons.home_rounded), label: "Glance"),
  NavigationDestination(icon: Icon(Icons.money_rounded), label: "Budget"),
  NavigationDestination(
    icon: Badge(
      isLabelVisible: false,
      child: Icon(Icons.task_alt_rounded),
    ),
    label: "Tasks",
  ),
];

int selectedNavIndex = 1;

//view insets
late Size screenSize;

//number formatter
NumberFormat numFormatter = NumberFormat("###,###,###,#00");

//extensions
extension MyDateExtension on DateTime {
  String formatDate() {
    return DateFormat.yMMMd().format(this);
  }
}

extension Capitalize on String {
  String capitalizeFirst() {
    String data = substring(1);
    return characters.first.toUpperCase() + data;
  }
}

//validators
String? validator(String? value) {
  if (value == null || value.isEmpty) {
    return "Oops! You missed this field";
  }

  return null;
}

String? numValidator(String? value) {
  if (value == null || value.isEmpty) {
    try {
      int.parse(value!);
    } catch (e) {
      return "Oops, a valid number please!";
    }

    return "Oops! You missed something";
  }

  return null;
}
