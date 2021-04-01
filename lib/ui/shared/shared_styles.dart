import 'package:flutter/material.dart';

// Box Decorations

// Input Decorations

const InputDecoration mainInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  labelStyle: TextStyle(color: Colors.grey),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
);

const InputDecoration postInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  labelStyle: TextStyle(color: Colors.grey),
  border: InputBorder.none,
  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
);
