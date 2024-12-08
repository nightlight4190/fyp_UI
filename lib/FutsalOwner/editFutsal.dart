import 'package:flutter/material.dart';

class EditFutsalPage extends StatefulWidget {
  final Map<String, dynamic> futsal;

  const EditFutsalPage({super.key, required this.futsal});

  @override
  State<EditFutsalPage> createState() => _EditFutsalPageState();
}

class _EditFutsalPageState extends State<EditFutsalPage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _fieldTypeController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.futsal['name']);
    _locationController = TextEditingController(
      text: widget.futsal['location'],
    );
    _priceController = TextEditingController(
      text: widget.futsal['price'].toString(),
    );
    _fieldTypeController = TextEditingController(
      text: widget.futsal['fieldType'],
    );
    _imageUrlController = TextEditingController(
      text: widget.futsal['imageUrl'],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _fieldTypeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveFutsalDetails() {
    // Add logic to save futsal details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Futsal details updated successfully."),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Futsal",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview Section
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                _imageUrlController.text,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Image URL Field
            _buildTextField(
              controller: _imageUrlController,
              label: "Image URL",
              prefixIcon: Icons.image,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Name Field
            _buildTextField(
              controller: _nameController,
              label: "Futsal Name",
              prefixIcon: Icons.sports_soccer,
            ),
            const SizedBox(height: 16),

            // Location Field
            _buildTextField(
              controller: _locationController,
              label: "Location",
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: 16),

            // Field Type Field
            _buildTextField(
              controller: _fieldTypeController,
              label: "Field Type",
              prefixIcon: Icons.grass,
            ),
            const SizedBox(height: 16),

            // Price Field
            _buildTextField(
              controller: _priceController,
              label: "Price (Rs.)",
              prefixIcon: Icons.monetization_on,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveFutsalDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                "Save Changes",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}
