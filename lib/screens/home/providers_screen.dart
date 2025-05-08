import 'package:flutter/material.dart';
import 'package:intro_screens/core/models/service_model.dart';
import 'package:intro_screens/routes/app_routes.dart';
import '../../core/models/provider_model.dart';
import '../../core/services/api_service.dart';

class ProvidersScreen extends StatefulWidget {
  final ServiceModel serviceModel;

  const ProvidersScreen({Key? key, required this.serviceModel}) : super(key: key);

  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  late Future<List<ProviderModel>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _providersFuture = ApiService().getAvailableProviders(widget.serviceModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Providers')),
      body: FutureBuilder<List<ProviderModel>>(
        future: _providersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No providers available.'));
          }

          final providers = snapshot.data!;

          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(provider.username),
                subtitle: Text('Rating: ${provider.rating} ⭐'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle provider selection
                  Navigator.pushNamed(context, AppRoutes.myCars);
                  print('Selected Provider: ${provider.username}');
                },
              );
            },
          );
        },
      ),
    );
  }
}