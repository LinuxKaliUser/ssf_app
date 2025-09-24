import 'package:flutter/material.dart';

class ModuleInfo {
  final String name;
  final IconData icon;
  final String description;
  final Widget widget;
  const ModuleInfo({
    required this.name,
    required this.icon,
    required this.description,
    required this.widget,
  });
}
