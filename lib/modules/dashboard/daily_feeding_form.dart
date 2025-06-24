import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_manager/data/local/feed_repo.dart';
import 'package:poultry_manager/data/models/dialy_feeding.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';
import 'package:poultry_manager/modules/dashboard/feed_type_chip.dart';

class DailyFeedingForm extends StatefulWidget {
  final Function(DailyFeeding) onSave;
  final FeedRepository feedRepo = Get.find();

  DailyFeedingForm({super.key, required this.onSave});

  @override
  State<DailyFeedingForm> createState() => _DailyFeedingFormState();
}

class _DailyFeedingFormState extends State<DailyFeedingForm> {
  FeedType? _selectedFeedType;
  String? _selectedCompany;
  DateTime? _selectedDate = DateTime.now();
  final TextEditingController _quantityController = TextEditingController();
  List<FeedType> _availableFeedTypes = [];
  List<String> _availableCompanies = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableFeeds();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('لا يوجد علف متاح في المخزن'),
            const SizedBox(height: 16),
            const Text('الرجاء إضافة علف جديد قبل تسجيل التغذية اليومية.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/add-feed');
              },
              child: const Text('إضافة علف جديد'),
            ),
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
                  _buildSaveBtn(),
                ],
              ),
            ),
          ),
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

  Widget _buildSaveBtn() {
    return ElevatedButton(
      onPressed: () {
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
        );

        widget.onSave(feeding);
        Get.back();
      },
      child: const Text('حفظ'),
    );
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
}
