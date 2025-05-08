import 'package:flutter/material.dart';
import 'package:intro_screens/widgets/service_card.dart';
import '../../../core/models/service_model.dart';
import '../../../core/services/api_service.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late Future<List<ServiceModel>> futureServices;
  List<ServiceModel> allServices = [];
  List<ServiceModel> filteredServices = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureServices = ApiService().getServices();
    futureServices.then((services) {
      setState(() {
        allServices = services;
        filteredServices = services;
      });
    });
  }

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredServices = allServices;
      } else {
        filteredServices = allServices
            .where((service) => service.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffe4dfdf),
      appBar: AppBar(
        title: Text(
          "Our Services",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Services",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: _filterServices,
            ),
          ),
          // FutureBuilder to load data
          Expanded(
            child: FutureBuilder<List<ServiceModel>>(
              future: futureServices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No services available.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: filteredServices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, serviceIndex) {
                    return ServiceCard(service: filteredServices[serviceIndex]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
