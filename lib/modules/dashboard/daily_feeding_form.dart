import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_manager/data/local/feed_repo.dart';
import 'package:poultry_manager/data/models/dialy_feeding.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';
import 'package:poultry_manager/modules/dashboard/feed_type_chip.dart';
import 'package:poultry_manager/modules/global_widgets/custom_btn.dart';

class DailyFeedingForm extends StatefulWidget {
  final Flock flock;
  final FeedRepository feedRepo = Get.find();

  DailyFeedingForm({super.key, required this.flock});

  @override
  State<DailyFeedingForm> createState() => _DailyFeedingFormState();
}

class _DailyFeedingFormState extends State<DailyFeedingForm> {
  DashboardController controller = Get.find<DashboardController>();
  FeedType? _selectedFeedType;
  String? _selectedCompany;
  DateTime? _selectedDate = DateTime.now();
  final TextEditingController _quantityController = TextEditingController();
  List<FeedType> _availableFeedTypes = [];
  List<String> _availableCompanies = [];

  @override
  void initState() {
    _loadAvailableFeeds();
    super.initState();
    
  }

  void _loadAvailableFeeds() {
    setState(() {
      widget.feedRepo.init();
      _availableFeedTypes = widget.feedRepo.availableFeedTypes;
      if (_availableFeedTypes.isNotEmpty) {
        _selectedFeedType = _availableFeedTypes.first;
        _updateAvailableCompanies();
      }
    });
  }

  void _updateAvailableCompanies() {
    if (_selectedFeedType != null) {
      setState(() {
        _availableCompanies = widget.feedRepo.getCompaniesForFeedType(
          _selectedFeedType!,
        );
        if (_availableCompanies.isNotEmpty) {
          _selectedCompany = _availableCompanies.first;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_availableFeedTypes.isEmpty) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('لا يوجد علف متاح في المخزن'),
            const SizedBox(height: 16),
            const Text('الرجاء إضافة علف جديد قبل تسجيل التغذية اليومية.'),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل التغذية اليومية'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeedTypeDropdown(),
                  const SizedBox(height: 16),
                  _buildFeedCompanyDropdown(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'الكمية (كجم)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الكمية';
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'الرجاء إدخال كمية صحيحة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ملاحظة: الكمية يجب أن تكون أقل من أو تساوي الكمية المتاحة في المخزن.',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  CustomBtn(title: 'حفظ', onTap: _onSave),
                  const SizedBox(height: 16),
                  if (widget.flock.feedingRecords.isNotEmpty) ...[
                    _buildSectionHeader('سجل التغذية اليومية'),
                    ...widget.flock.feedingRecords.map(
                      (record) => _buildDetailCard([
                        _buildDetailRow(
                          'التاريخ',
                          _formatDateTime(record.date),
                        ),
                        _buildDetailRow(
                          'الكمية',
                          '${record.quantity} كجم ${record.quantity * record.costPerKg} جنيه',
                        ),
                        _buildDetailRow(
                          'سعر الكيلو',
                          '${record.costPerKg} جنيه لكل كجم (${record.feedType.arabicName})',
                        ),
                      ]),
                    ),
                  ],

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

 Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'تاريخ التغذية',
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          setState(() {
            _selectedDate = selectedDate;
          });
        }
      },
      controller: TextEditingController(
        text:
            _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : '',
      ),
    );
  }

  void _onSave() {
    if (_selectedFeedType == null || _selectedCompany == null) {
      Get.snackbar(
        'خطأ',
        'الرجاء اختيار نوع العلف والشركة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      Get.snackbar(
        'خطأ',
        'الرجاء إدخال كمية صحيحة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final feeding = DailyFeeding(
      feedType: _selectedFeedType!,
      quantity: quantity,
      date: _selectedDate ?? DateTime.now(),
      costPerKg: widget.feedRepo.getCostPerKg(_selectedFeedType!),
      feedCompany: '',
      countOfBirdsThen: widget.flock.count,
    );

    final updatedFlock = widget.flock.copyWith(
      feedingRecords: [...widget.flock.feedingRecords, feeding],
    );

    controller.saveAndNavigateToFlockDetails(updatedFlock);
  }

  Widget _buildFeedTypeDropdown() {
    return DropdownButtonFormField<FeedType>(
      decoration: const InputDecoration(
        labelText: 'نوع العلف',
        border: OutlineInputBorder(),
      ),
      value: _selectedFeedType,
      items:
          _availableFeedTypes.map((FeedType type) {
            return DropdownMenuItem<FeedType>(
              value: type,
              child: Row(
                children: [
                  FeedTypeChip(feedType: type),
                  const SizedBox(width: 8),
                  Text('(${widget.feedRepo.getStockQuantity(type)} كجم متاح)'),
                ],
              ),
            );
          }).toList(),
      onChanged: (FeedType? newValue) {
        setState(() {
          _selectedFeedType = newValue;
          _updateAvailableCompanies();
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار نوع العلف' : null,
    );
  }

  Widget _buildFeedCompanyDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'شركة العلف',
        border: OutlineInputBorder(),
      ),
      value: _selectedCompany,
      items:
          _availableCompanies.map((String company) {
            return DropdownMenuItem<String>(
              value: company,
              child: Text(company),
            );
          }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCompany = newValue;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار الشركة' : null,
    );
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('yyyy/MM/dd - hh:mm a').format(date);
  }
}
