import 'package:ecommerce_flutter_admin/services/assets_manager.dart';
import 'package:ecommerce_flutter_admin/widget/dashboard_btn_model.dart';
import 'package:ecommerce_flutter_admin/widget/dashboard_btn_widget.dart';
import 'package:ecommerce_flutter_admin/widget/title_text.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.card),
          ),
          title: TitleTextWidget(label: "Admin Panel")),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          DashboardButtonModel.dashboardBtnList(context).length,
          (index) => DashboardButtonWidget(
              text: DashboardButtonModel.dashboardBtnList(context)[index].text,
              imagePath: DashboardButtonModel.dashboardBtnList(context)[index].imagePath,
              onPressed:  DashboardButtonModel.dashboardBtnList(context)[index].onPressed,
              ),
        ),
      ),
    );
  }
}
