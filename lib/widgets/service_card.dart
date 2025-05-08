import 'package:flutter/material.dart';
import 'package:intro_screens/screens/home/service_details_screen.dart';
import 'package:provider/provider.dart';

import '../core/models/service_model.dart';
import '../map_pages/map_screen.dart';
import '../providers/model_provider.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({Key? key, required this.service}) : super(key: key);

  final ServiceModel service;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceDetailsScreen(service: service)));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    service.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  service.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}