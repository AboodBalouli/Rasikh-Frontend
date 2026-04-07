import 'package:flutter/material.dart';

class AuthenticationRegex {
  AuthenticationRegex._();

  static final navigationKey = GlobalKey<NavigatorState>();

  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
  );

  static final RegExp passwordRegex = RegExp(r'^.{6,}$');

  static final RegExp firstNameRegex = RegExp(
    r"^[A-Za-z\u0621-\u064A][A-Za-z\u0621-\u064A.\'-]{1,}$",
  );

  static final RegExp lastNameRegex = RegExp(
    r"^[A-Za-z\u0621-\u064A]+[A-Za-z\u0621-\u064A.\'-]*([ -][A-Za-z\u0621-\u064A.\'-]+)*$",
  );
}
