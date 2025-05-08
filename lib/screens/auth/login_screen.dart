import 'package:flutter/material.dart';
import 'package:intro_screens/core/models/service_model.dart';
import 'package:intro_screens/widgets/navigation_menu.dart';

import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  // final ServiceModel serviceModel;
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formLoginKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;


  Future<void> _submitForm() async {
    if (!_formLoginKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = AuthService();
    bool success = await authService.login(
      usernameController.text,
      passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.navigationMenu, (route) => false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> NavigationMenu()), (route)=>false);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid username or password"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formLoginKey,
            child: Column(
              children: [
                Image.asset('assets/images/intro/logo-no-slogan.png',
                    height: 150, fit: BoxFit.cover),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                        color: Color(0xff3A3434),
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: usernameController,
                  decoration: _buildInputDecoration('Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      }),
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  obscuringCharacter: '*',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3A3434),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.signup);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
