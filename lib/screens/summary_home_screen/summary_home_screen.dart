import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:jara_market/screens/summary_home_screen/controller/summary_home_controller.dart';

SummaryHomeController  controller = Get.put(SummaryHomeController());

class SummaryHomeScreen extends StatefulWidget {
  const SummaryHomeScreen({super.key});

  @override
  State<SummaryHomeScreen> createState() => _SummaryHomeScreenState();
}

class _SummaryHomeScreenState extends State<SummaryHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}