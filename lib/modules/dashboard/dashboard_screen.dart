import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/modules/dashboard/flok_card.dart';
import 'package:poultry_manager/modules/dashboard/flok_details_screen.dart';
import 'package:poultry_manager/modules/main_scaffold.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      title: 'Dashboard',
      body: Obx(
        () => Column(
          children: [
            // Add your dashboard widgets here
            _buildSummaryCards(),
            _buildAddFlockBtn(),
            _buildFlockList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFlockBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: controller.navigateToAddFlock,
        child: Card(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Add New Flock',
              style: Get.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Profit', controller.profit.value, 200)),
        Expanded(
          child: Column(
            children: [
              _buildSummaryCard('Expense', controller.expense.value, 100),
              _buildSummaryCard('Income', controller.income.value, 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double value,double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Get.textTheme.titleSmall),
              Text(
                '\$${value.toStringAsFixed(2)}',
                style: Get.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlockList() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.flocks.length,
          itemBuilder: (context, index) {
            final flock = controller.flocks[index];
            return FlockCard(
              flock: flock,
              onTap:
                  () => Get.to(
                    () => FlockDetailsView(flock: flock),
                    fullscreenDialog: true,
                  ),
            );
          },
        ),
      ),
    );
  }
}
