import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_screens/routes/app_routes.dart';

import '../../core/models/car_model.dart';
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
        // backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Add Car",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
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

  final List<TextEditingController> _numberControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String? _letter1;
  String? _letter2;
  String? _letter3;

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a correct license plate.")),
        );
        return;
      }

      String numberPart = _numberControllers.map((c) => c.text).join();
      if (numberPart.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter all 4 numbers.")),
        );
        return;
      }

      String license = "$_letter1$_letter2$_letter3$numberPart";
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Car added successfully!")),
        );

        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.myCars);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add car. Try again.")),
        );
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  // License Plate Letters
                  _buildLetterDropdown(
                      "-", (val) => setState(() => _letter1 = val), _letter1),
                  _buildLetterDropdown(
                      "-", (val) => setState(() => _letter2 = val), _letter2),
                  _buildLetterDropdown(
                      "-", (val) => setState(() => _letter3 = val), _letter3),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          width: 35,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter a number";
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Make Field
              TextFormField(
                controller: _makeController,
                decoration:
                    const InputDecoration(labelText: "Make (e.g., Toyota)"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[a-zA-Z\u0600-\u06FF ]+$')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter car make";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Model Field
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                    labelText: "Model (e.g., Camry 2022)"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[a-zA-Z0-9\u0600-\u06FF ]+$')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter car model";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Year Field
              TextFormField(
                controller: _yearController,
                decoration:
                    const InputDecoration(labelText: "Year (e.g., 2022)"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter car year";
                  int? year = int.tryParse(value);
                  if (year == null || year < 1886 || year > currentYear) {
                    return "Enter a valid year (1886-$currentYear)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3A3434),
                  minimumSize: const Size(250, 60),
                ),
                child: const Text(
                  'Add Car',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterDropdown(
      String hint, Function(String?) onChanged, String? value) {
    return DropdownButton<String>(
      value: value,
      hint: Text(hint),
      items: _arabicLetters.map((letter) {
        return DropdownMenuItem<String>(
          value: letter,
          child: Text(letter, style: const TextStyle(fontSize: 20)),
        );
      }).toList(),
      onChanged: onChanged,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Car deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete car")),
      );
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
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ));
    }

    return cars.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No cars added yet.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              DefaultTabController.of(context)?.animateTo(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3A3434),
              minimumSize: const Size(250, 60),
            ),
            child: const Text(
              "Add a Car",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    )
        : ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.map,
            arguments: car);
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                "${car.make} ${car.model}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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



