import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_manager/modules/global_widgets/main_scaffold.dart';
import 'package:poultry_manager/modules/stock/stock_controller.dart';

class StockScreen extends StatelessWidget {
  final StockController controller = Get.find();

  StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'إدارة المخزون',
      currentIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Quick Stats Cards
            _buildStatsRow(),
            const SizedBox(height: 20),

            // Main Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 20),

            // Stock Lists
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'الأعلاف'),
                        Tab(text: 'الأدوية'),
                        Tab(text: 'اللقاحات'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildFeedStockList(),
                          _buildMedicineStockList(),
                          _buildVaccineStockList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          'الأعلاف',
          '${controller.getTotalFeedStock()} كجم',
          Colors.blue,
        ),
        _buildStatCard(
          'الأدوية',
          '${controller.medicineStocks.length} نوع',
          Colors.green,
        ),
        _buildStatCard(
          'اللقاحات',
          '${controller.vaccineStocks.length} نوع',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: color)),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'إضافة علف',
            Icons.agriculture,
            Colors.blue,
            () => Get.toNamed('/add_feed_stock'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            'إضافة دواء',
            Icons.medical_services,
            Colors.green,
            () => Get.toNamed('/add_medicine_stock'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            'إضافة لقاح',
            Icons.vaccines,
            Colors.orange,
            () => Get.toNamed('/add_vaccine_stock'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      label: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildFeedStockList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.feedStocks.length,
        itemBuilder: (context, index) {
          final stock = controller.feedStocks[index];
          return _buildStockItem(
            stock.feedType.arabicName,
            '${stock.quantityInKg} كجم',
            '${stock.feedCompany} - ${stock.costPerKg} ج/كجم',
            Colors.blue,
          );
        },
      ),
    );
  }

  Widget _buildMedicineStockList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.medicineStocks.length,
        itemBuilder: (context, index) {
          final stock = controller.medicineStocks[index];
          return _buildStockItem(
            stock.name,
            '${stock.quantity} ${stock.unit}',
            '${stock.supplier} - ${stock.expiryDate != null ? DateFormat('yyyy/MM/dd').format(stock.expiryDate!) : "لا يوجد تاريخ صلاحية"}',
            Colors.green,
          );
        },
      ),
    );
  }

  Widget _buildVaccineStockList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.vaccineStocks.length,
        itemBuilder: (context, index) {
          final stock = controller.vaccineStocks[index];
          return _buildStockItem(
            stock.name,
            '${stock.quantity} جرعة',
            '${stock.targetDisease} - ${stock.expiryDate != null ? DateFormat('yyyy/MM/dd').format(stock.expiryDate!) : "لا يوجد تاريخ صلاحية"}',
            Colors.orange,
          );
        },
      ),
    );
  }

  Widget _buildStockItem(
    String title,
    String quantity,
    String subtitle,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.inventory, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          quantity,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
