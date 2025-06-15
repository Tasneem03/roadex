import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_screens/routes/app_routes.dart';

import '../../core/models/car_model.dart';
import '../../core/services/booking_storage.dart';
import '../../core/services/api_service.dart';

class CarsScreen extends StatefulWidget {
  CarsScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);
  final int initialTabIndex;

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Add Car",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            tabs: [
              Tab(text: "Add Car"),
              Tab(text: "My Cars"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddCarForm(),
            MyCars(),
          ],
        ),
      ),
    );
  }
}

class AddCarForm extends StatefulWidget {
  const AddCarForm({super.key});
  @override
  _AddCarFormState createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _numberControllers = List.generate(4, (index) => TextEditingController());
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String? _letter1, _letter2, _letter3;
  final List<String> _arabicLetters = ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هـ', 'و', 'ي'];

  @override
  void dispose() {
    for (var controller in _numberControllers) {
      controller.dispose();
    }
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_letter1 == null || _letter2 == null || _letter3 == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a correct license plate.")));
        return;
      }

      String numberPart = _numberControllers.map((c) => c.text).join();
      if (numberPart.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter all 4 numbers.")));
        return;
      }

      String license = "$_letter1 $_letter2 $_letter3 - $numberPart";
      String make = _makeController.text.trim();
      String model = _modelController.text.trim();
      String year = _yearController.text.trim();

      bool success = await ApiService().addCar(
        licensePlate: license,
        make: make,
        model: model,
        year: year,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Car added successfully!")));
        Navigator.pushNamed(context, AppRoutes.myCars);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to add car. Try again.")));
      }

      if (!mounted) return;

      setState(() {
        _letter1 = _letter2 = _letter3 = null;
        for (var controller in _numberControllers) {
          controller.clear();
        }
        _makeController.clear();
        _modelController.clear();
        _yearController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildLetterDropdown("-", (val) => setState(() => _letter1 = val), _letter1),
                    _buildLetterDropdown("-", (val) => setState(() => _letter2 = val), _letter2),
                    _buildLetterDropdown("-", (val) => setState(() => _letter3 = val), _letter3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedBox(
                            width: 40,
                            child: TextFormField(
                              controller: _numberControllers[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) => value == null || value.isEmpty ? "Enter" : null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(_makeController, "Make (e.g., Toyota)", r'^[a-zA-Z\u0600-\u06FF ]+$', "Enter car make"),
                const SizedBox(height: 20),
                _buildTextField(_modelController, "Model (e.g., Camry)", r'^[a-zA-Z0-9\u0600-\u06FF ]+$', "Enter car model"),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Year (e.g., 2022)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter car year";
                    int? year = int.tryParse(value);
                    if (year == null || year < 1886 || year > currentYear) return "Enter a valid year (1886-$currentYear)";
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Add Car", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterDropdown(String hint, Function(String?) onChanged, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _arabicLetters.map((letter) {
            return DropdownMenuItem<String>(
              value: letter,
              child: Text(letter, style: const TextStyle(fontSize: 18)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String pattern, String errorMsg) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(pattern))],
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
    );
  }
}

class MyCars extends StatefulWidget {
  const MyCars({Key? key}) : super(key: key);

  @override
  _MyCarsState createState() => _MyCarsState();
}

class _MyCarsState extends State<MyCars> {
  List<CarModel> cars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    List<CarModel> fetchedCars = await ApiService().getCars();
    setState(() {
      cars = fetchedCars;
      isLoading = false;
    });
  }

  Future<void> _deleteCar(int carId) async {
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (!confirmDelete) return;

    bool isDeleted = await ApiService().deleteCar(carId);
    if (isDeleted) {
      setState(() {
        cars.removeWhere((car) => car.id == carId);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Car deleted successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete car")));
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Car"),
        content: const Text("Are you sure you want to delete this car?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
    }

    return cars.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No cars added yet.", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              DefaultTabController.of(context).animateTo(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(250, 60),
            ),
            child: const Text("Add a Car", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    )
        : ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return GestureDetector(
          onTap: () async {
            await BookingStorage().saveCarId(car.id);
            Navigator.pushNamed(context, AppRoutes.map);
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: const Icon(Icons.directions_car, color: Colors.black54),
              ),
              title: Text("${car.make} ${car.model}", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("License: ${car.licensePlate}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCar(car.id),
              ),
            ),
          ),
        );
      },
    );
  }
}
