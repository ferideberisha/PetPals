import 'package:flutter/material.dart';

class ServiceSection extends StatelessWidget {
  final double? dayCarePrice;
  final double? houseSittingPrice;
  final double? walkingPrice;

  const ServiceSection({
    Key? key,
    this.dayCarePrice,
    this.houseSittingPrice,
    this.walkingPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Color(0x0D967BB6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dayCarePrice != null) _buildServiceRow(Icons.watch_later, 'Day Care', dayCarePrice!),
          if (houseSittingPrice != null) _buildServiceRow(Icons.pin_drop, 'House Sitting', houseSittingPrice!),
          if (walkingPrice != null) _buildServiceRow(Icons.directions_walk, 'Walking', walkingPrice!),
        ],
      ),
    );
  }

  Widget _buildServiceRow(IconData icon, String serviceName, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: _getIconColor(serviceName)),
              const SizedBox(width: 12.0), // Increased space between icon and text
              Text(
                serviceName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${price.toStringAsFixed(0)} EUR',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'per hour',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getIconColor(String serviceName) {
    switch (serviceName) {
      case 'Day Care':
        return Colors.orange;
      case 'House Sitting':
        return Colors.blue;
      case 'Walking':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
