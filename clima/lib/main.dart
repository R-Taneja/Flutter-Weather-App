import 'package:flutter/material.dart';
import 'clima.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: Clima(),
        debugShowCheckedModeBanner: false,
      ),
    );
