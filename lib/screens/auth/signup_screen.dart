import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../../../routes/app_routes.dart';
import '../../core/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formSignUpKey = GlobalKey<FormState>();
  final GlobalKey<FlutterPwValidatorState> _validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordTyped = false;
  bool _isPasswordValid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  /*Future<void> _submitForm(String username, String email, String password, String phoneNumber) async {
    if (!_formSignUpKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = SignupAuth();
      final response = await authService.signUp(username, email, password, phoneNumber);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
*/

  Future<void> _submitForm(String username, String email, String password, String phoneNumber) async {
    if (!_formSignUpKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = AuthService();
    final response = await authService.signUp(username, email, password, phoneNumber);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (response["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful!"), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      String errorMessage = response["message"] ?? "Signup Failed. Try again.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
            child: Form(
              key: _formSignUpKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/intro/logo-no-slogan.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to ',
                        style:
                            TextStyle(color: Color(0xff3A3434), fontSize: 20),
                      ),
                      Text(
                        'RoadEx',
                        style: TextStyle(
                            color: Color(0xff3A3434),
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Text(
                    'Sign up and start your journey',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // username
                  TextFormField(
                    controller: _usernameController,
                    decoration: _buildInputDecoration('Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your username';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // phone number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration('Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your phone number';
                      }
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value) ||
                          value.length < 11) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration('Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      }
                      if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // password
                  TextFormField(
                    controller: _passwordController,
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
                    onChanged: (value) => setState(() {
                      _isPasswordTyped = value.isNotEmpty;
                    }),
                  ),
                  const SizedBox(height: 5),
                  if (_isPasswordTyped)
                    FlutterPwValidator(
                      key: _validatorKey,
                      width: 400,
                      height: 200,
                      minLength: 6,
                      uppercaseCharCount: 1,
                      numericCharCount: 1,
                      specialCharCount: 1,
                      controller: _passwordController,
                      onSuccess: () => setState(() => _isPasswordValid = true),
                      onFail: () => setState(() => _isPasswordValid = false),
                    ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    // onPressed: () => _submitForm,
                    onPressed: () {
                      _submitForm(
                          _usernameController.text.toString(),
                          _emailController.text.toString(),
                          _passwordController.text.toString(),
                          _phoneController.text.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3A3434),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.login),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
