import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictScreen extends StatefulWidget {
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mileageController = TextEditingController();

  final List<String> brands = ["BMW", "Honda", "Tesla", "Mercedes", "Ford", "Chevrolet", "Hyundai", "Volkswagen", "Nissan", "Toyota"];
  final List<String> models = ["X5", "CR-V", "Model X", "C-Class", "F-150", "Equinox", "5 Series", "Elantra", "Mustang", "Explorer", "Malibu", "Jetta", "Rogue", "Model S", "Tiguan", "Altima", "3 Series", "Sonata", "Tucson", "GLC", "Sentra", "Corolla", "Accord", "Model 3", "E-Class", "RAV4", "Civic", "Camry", "Passat", "Silverado"];
  final List<String> fuelTypes = ["Petrol", "Diesel", "Electric", "Hybrid"];
  final List<String> engineTypes = ["V4", "V8", "Electric", "V6"];
  final List<int> years = List.generate(15, (index) => 2010 + index);

  String? selectedBrand;
  String? selectedModel;
  String? selectedFuelType;
  String? selectedEngineType;
  int? selectedYear;
  String _result = "";
  bool _isLoading = false;

  Future<void> _predict() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse("http://192.168.174.1:8000/predict"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "brand": selectedBrand,
            "model": selectedModel,
            "year": selectedYear,
            "mileage": int.parse(_mileageController.text),
            "fuel_type": selectedFuelType,
            "engine_type": selectedEngineType,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          setState(() {
            _result = responseData["maintenance_advice"];
          });
        } else {
          setState(() => _result = "Error: ${response.body}");
        }
      } catch (e) {
        setState(() => _result = "Request failed: $e");
      }

      setState(() => _isLoading = false);
    }
  }

  Widget _buildDropdown<T>(
      String label,
      T? value,
      List<T> items,
      void Function(T?) onChanged,
      ) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) => DropdownMenuItem<T>(
        value: item,
        child: Text(item.toString(), style: TextStyle(fontSize: 16)),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value == null ? "Please select $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff3A3434);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Predict Maintenance", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDropdown("Brand", selectedBrand, brands, (val) => setState(() => selectedBrand = val)),
                    SizedBox(height: 15),
                    _buildDropdown("Model", selectedModel, models, (val) => setState(() => selectedModel = val)),
                    SizedBox(height: 15),
                    _buildDropdown("Year", selectedYear, years, (val) => setState(() => selectedYear = val)),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _mileageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Mileage",
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || int.tryParse(value) == null) return "Enter valid mileage";
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    _buildDropdown("Fuel Type", selectedFuelType, fuelTypes, (val) => setState(() => selectedFuelType = val)),
                    SizedBox(height: 15),
                    _buildDropdown("Engine Type", selectedEngineType, engineTypes, (val) => setState(() => selectedEngineType = val)),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _predict,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Predict", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 25),
                    if (_result.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _result,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
