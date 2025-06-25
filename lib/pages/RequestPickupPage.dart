import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';

class RequestPickupScreen extends StatefulWidget {
  const RequestPickupScreen({super.key});

  @override
  State<RequestPickupScreen> createState() => _RequestPickupScreenState();
}

class _RequestPickupScreenState extends State<RequestPickupScreen> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    final apiKey = "AIzaSyDUArtqG6Q18-jaZfGaoljjhF23Det8X8A";
    if (apiKey == null) {
      throw Exception("GOOGLE_API_KEY not found in .env");
    }
    googlePlace = GooglePlace(apiKey);
  }

  void autoCompleteSearch(String value) async {
    if (value.isNotEmpty) {
      var result = await googlePlace.autocomplete.get(
        value,
        components: [Component("country", "gh")],
      );
      if (result != null && result.predictions != null && mounted) {
        setState(() {
          predictions = result.predictions!;
        });
      }
    } else {
      setState(() {
        predictions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request pickup", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar with Map Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: autoCompleteSearch,
                      decoration: const InputDecoration(
                        hintText: "Location",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage()));
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Map"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Suggestions list
          Expanded(
            child: predictions.isEmpty
                ? const Center(child: Text("Search for a location..."))
                : ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      final prediction = predictions[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text(prediction.description ?? ""),
                        onTap: () {
                          setState(() {
                            _selectedLocation = prediction.description;
                            _searchController.text = _selectedLocation!;
                            predictions.clear();
                          });
                        },
                      );
                    },
                  ),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _selectedLocation == null
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Selected: $_selectedLocation")),
                        );
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
