import 'package:flutter/material.dart';
import 'package:intro_screens/core/models/user_model.dart';
import 'package:intro_screens/core/services/api_service.dart';
import 'package:intro_screens/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout(context);
            },
          )
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: ApiService().getUserProfile(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching profile data"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user data available"));
          }

          UserModel user = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                // color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 40,
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.person, "Username", user.username),
                      _buildInfoRow(Icons.email, "Email", user.email),
                      _buildInfoRow(Icons.phone, "Phone", user.phoneNumber),
                      _buildInfoRow(Icons.location_on, "Latitude", user.latitude),
                      _buildInfoRow(
                          Icons.location_on, "Longitude", user.longitude),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xff3A3434),
          ),
          const SizedBox(width: 10),
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value.toString(), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}


