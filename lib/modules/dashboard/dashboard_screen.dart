import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), centerTitle: true),
      body: Obx(
        () => Column(
          children: [
            // Add your dashboard widgets here
            _buildSummaryCards(),
            _buildFlockList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAddFlock,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Income', controller.income.value)),
        Expanded(child: _buildSummaryCard('Expense', controller.expense.value)),
        Expanded(child: _buildSummaryCard('Profit', controller.profit.value)),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double value) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: Get.textTheme.titleSmall),
            Text(
              '\$${value.toStringAsFixed(2)}',
              style: Get.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlockList() {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.flocks.length,
        itemBuilder: (context, index) {
          final flock = controller.flocks[index];
          return ListTile(
            title: Text(flock.name),
            subtitle: Text('Birds: ${flock.count}, Type: ${flock.birdType}'),
            trailing: Text('Added: ${flock.date}'),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) => controller.navigateTo(index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Pharmacy',
        ),
      ],
    );
  }
}
