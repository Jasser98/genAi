import 'package:flutter/material.dart';
import 'package:genai/core/location.dart';
import 'package:genai/core/open_map.dart';
import 'package:genai/main.dart';
import 'package:genai/model/equipment.dart';

class LocationDetailsScreen extends StatelessWidget {
  final Equipment locationData;

  const LocationDetailsScreen({super.key, required this.locationData});

  @override
  Widget build(BuildContext context) {
    print(userLocation?.latitude.toString());
    print(userLocation?.longitude.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(locationData.nom),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Salle:', locationData.salle),
            _buildDetailItem('Emplacement:', locationData.emplacement),
            _buildDetailItem('Description:', locationData.description),
            _buildDetailItem(
                'Disponibility:',
                locationData.disponibility == true
                    ? 'Available'
                    : 'Not Available'),
            _buildDetailItem('Distance:',
                '${UserLocation.calculateDistance(locationData.latitude!, locationData.longitude!).toStringAsFixed(2)} Km'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () async {
                await openMap(locationData.latitude!, locationData.longitude!);
              },
              child: Text(
                "Go to google map",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            // _buildDetailItem('Longitude:', locationData.longitude?.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
