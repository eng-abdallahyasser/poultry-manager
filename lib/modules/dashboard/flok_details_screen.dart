import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/daily_check_screen.dart';
import 'package:poultry_manager/modules/dashboard/daily_feeding_form.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';
import 'package:poultry_manager/modules/dashboard/flock_stats_card.dart';
import 'package:poultry_manager/modules/dashboard/modify_bird_screen.dart';

class FlockDetailsView extends StatelessWidget {
  final Flock flock;
  final DashboardController controller = Get.find<DashboardController>();

  FlockDetailsView({super.key, required this.flock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل القطيع - ${flock.name}'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildSummaryCard(
                          "الربح",
                          flock.totalIncome - flock.totalExpense,
                          300, // Height of the card
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildSummaryCard(
                              "المصروفات",
                              flock.totalExpense,
                              100,
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              "الإيرادات",
                              flock.totalIncome,
                              100,
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              "تكلفة التغذية",
                              flock.totalFeedCost,
                              100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FlockStatsCard(flock: flock),
                  SizedBox(height: 16),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildModifyBirdBtn()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDailyFeedingBtn()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildBirdHealthBth()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDailyCheckBtn()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCheckBtn() {
    return ElevatedButton(
      onPressed: () {
        Get.to(() => DailyCheckScreen(onSave: (weightRecord ) { 
          controller.addDailyCheck(flock.id, weightRecord);
         },));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 16),
          Text('فحص يومي', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildBirdHealthBth() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to bird health screen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.health_and_safety, color: Colors.white),
          SizedBox(width: 16),
          Text('صحة الطيور', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDailyFeedingBtn() {
    return ElevatedButton(
      onPressed: () {
        Get.to(() => DailyFeedingForm(flock: flock));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.fastfood, color: Colors.white),
          SizedBox(width: 16),
          Text('تغذية يومية', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildModifyBirdBtn() {
    return ElevatedButton(
      onPressed: ()  {
         Get.to(
          () => ModifyBirdsView(flock: flock),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 16),
          Text('تعديل الطيور', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double value, double height) {
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
                value.toStringAsFixed(1),
                style: Get.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}
