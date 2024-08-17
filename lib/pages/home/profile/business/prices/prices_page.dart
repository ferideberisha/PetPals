import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/controllers/price_controller.dart';
import 'package:petpals/models/priceModel.dart';

class PricesPage extends StatefulWidget {
  final String userId;
  final String role;

  const PricesPage({Key? key, required this.userId, required this.role}) : super(key: key);

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  bool _dayCareEnabled = false;
  bool _houseSittingEnabled = false;
  bool _walkingEnabled = false;
  final TextEditingController _dayCarePriceController = TextEditingController();
  final TextEditingController _houseSittingPriceController = TextEditingController();
  final TextEditingController _walkingPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showErrorMessage = false;
  final PriceController _priceController = PriceController();
  String? _priceId; // To store the price ID

  @override
  void initState() {
    super.initState();
    print('userId: ${widget.userId}, role: ${widget.role}');
    _loadPrices();
  }

  Future<List<String>> _fetchPriceIds() async {
    try {
      final subCollection = widget.role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      final path = 'users/${widget.userId}/$subCollection/${widget.userId}/price';
      final querySnapshot = await FirebaseFirestore.instance.collection(path).get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching price IDs: $e');
      return [];
    }
  }

  Future<void> _loadPrices() async {
    try {
      if (widget.userId.isEmpty || widget.role.isEmpty) {
        throw Exception('userId or role cannot be empty');
      }

      final priceIds = await _fetchPriceIds();
      if (priceIds.isEmpty) {
        print('No price documents found for user.');
        return;
      }

      _priceId = priceIds.first; // Select the first priceId or implement your logic
      if (_priceId == null) {
        print('No priceId found');
        return;
      }

      Prices? prices = await _priceController.getPrices(widget.userId, widget.role, _priceId!);

      if (prices != null) {
        setState(() {
          _dayCareEnabled = prices.dayCareEnabled;
          _houseSittingEnabled = prices.houseSittingEnabled;
          _walkingEnabled = prices.walkingEnabled;
          _dayCarePriceController.text = prices.dayCarePrice?.toString() ?? '';
          _houseSittingPriceController.text = prices.houseSittingPrice?.toString() ?? '';
          _walkingPriceController.text = prices.walkingPrice?.toString() ?? '';
        });
      } else {
        print('No prices found for the specified priceId.');
      }
    } catch (e) {
      print('Error loading prices from Firestore: $e');
    }
  }

  @override
  void dispose() {
    _dayCarePriceController.dispose();
    _houseSittingPriceController.dispose();
    _walkingPriceController.dispose();
    super.dispose();
  }

  void _savePricesToFirestore(Prices prices) async {
    try {
      print('Saving prices for userId: ${widget.userId}, role: ${widget.role}');
      if (widget.userId.isEmpty || widget.role.isEmpty || _priceId == null) {
        throw Exception('userId, role, or priceId cannot be empty');
      }

      await _priceController.setPrices(prices, widget.userId, widget.role, _priceId!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prices saved successfully')),
      );
    } catch (e) {
      print('Error saving prices to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save prices: $e')),
      );
    }
  }

  void _saveButtonOnTap(BuildContext context) {
    setState(() {
      _showErrorMessage = !_dayCareEnabled && !_houseSittingEnabled && !_walkingEnabled;
    });

    if (_formKey.currentState!.validate() && !_showErrorMessage) {
      final prices = Prices(
        dayCareEnabled: _dayCareEnabled,
        houseSittingEnabled: _houseSittingEnabled,
        walkingEnabled: _walkingEnabled,
        dayCarePrice: _dayCareEnabled ? double.tryParse(_dayCarePriceController.text) : null,
        houseSittingPrice: _houseSittingEnabled ? double.tryParse(_houseSittingPriceController.text) : null,
        walkingPrice: _walkingEnabled ? double.tryParse(_walkingPriceController.text) : null,
      );

      _savePricesToFirestore(prices);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prices'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            _buildOptionTile(
              icon: Icons.watch_later,
              color: Colors.orange,
              title: 'Day Care',
              value: _dayCareEnabled,
              onChanged: (value) {
                setState(() {
                  _dayCareEnabled = value;
                  _showErrorMessage = false;
                });
              },
              controller: _dayCarePriceController,
            ),
            _buildOptionTile(
              icon: Icons.pin_drop,
              color: Colors.blue,
              title: 'House Sitting',
              value: _houseSittingEnabled,
              onChanged: (value) {
                setState(() {
                  _houseSittingEnabled = value;
                  _showErrorMessage = false;
                });
              },
              controller: _houseSittingPriceController,
            ),
            _buildOptionTile(
              icon: Icons.directions_walk,
              color: Colors.green,
              title: 'Walking',
              value: _walkingEnabled,
              onChanged: (value) {
                setState(() {
                  _walkingEnabled = value;
                  _showErrorMessage = false;
                });
              },
              controller: _walkingPriceController,
            ),
            if (_showErrorMessage)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Please choose at least one option',
                  style: TextStyle(color: Color.fromARGB(255, 175, 29, 29)),
                ),
              ),
            const SizedBox(height: 20),
            MyButton(
              onTap: () => _saveButtonOnTap(context),
              text: 'Save',
              color: const Color(0xFF967BB6),
              textColor: Colors.white,
              borderColor: const Color(0xFF967BB6),
              borderWidth: 1.0,
              width: 390,
              height: 60,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color color,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required TextEditingController controller,
  }) {
    Widget suffixIcon = const SizedBox();

    if (value) {
      suffixIcon = Icon(
        Icons.euro,
        color: Colors.grey.shade400,
      );
    }

    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: color,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF967BB6),
          ),
        ),
        if (value)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MyTextField(
              controller: controller,
              hintText: 'Price',
              obscureText: false,
              fillColor: Colors.white,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price';
                }
                if (!RegExp(r'^\d+\.?\d{0,2}$').hasMatch(value)) {
                  return 'Invalid price format. Please enter a valid price.';
                }
                double amount = double.tryParse(value) ?? 0.0;
                if (amount > 100.0) {
                  return 'Amount should not be greater than 100';
                }
                return null;
              },
              suffixIcon: suffixIcon,
            ),
          ),
      ],
    );
  }
}
