import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:waste_mangement_app/pages/pages_Ext.dart';
import 'package:geocoding/geocoding.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';
import 'package:waste_mangement_app/pages/pages_Ext.dart';


class RequestPickupScreen extends StatefulWidget {
  const RequestPickupScreen({super.key});

  @override
  State<RequestPickupScreen> createState() => _RequestPickupScreenState();
}

class _RequestPickupScreenState extends State<RequestPickupScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _predictions = [];
  final String token ='1234567890';
  String? _selectedLocation;
  bool _isEditing = true;
  String? _selectedPaymentMethod;
  bool _isLoading = false;


  void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,           // Prevents tapping out to dismiss
    barrierColor: Colors.black45,        // Dimmed background
    builder: (_) => const Center(
      child: CircularProgressIndicator( color: Colors.white,),
    ),
  );
}



  void showWasteCollectorSheet(BuildContext context, String paymentMethod) {
  String? selectedCollector;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            child: Container(
                 padding: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: WMA_Colours.greenPrimary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                      "15% discount apply on this request",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                    ),

                     const SizedBox(height: 10,),
                    Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child:Column(
                      children: [
                        Container(
                      width: 60,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    
                  const SizedBox(height: 16),
                  Text("Your waste collector", style: Theme.of(context).textTheme.titleMedium),
              
                  const SizedBox(height: 12),
                  collectorTile(
                    name: "Kwaku Kwarteng",
                    distance: "0.2 km away",
                    selected: selectedCollector == "Kwaku",
                    onTap: () => setModalState(() => selectedCollector = "Kwaku"),
                    ProfileImage: WMA_profiles.Profile_2
                  ),
                  collectorTile(
                    name: "Jack Obeng",
                    distance: "2.4 km away",
                    selected: selectedCollector == "Jack",
                    onTap: () => setModalState(() => selectedCollector = "Jack"),
                      ProfileImage: WMA_profiles.Profile_4
                  ),
              
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: ButtonStyle(
                         shape: WidgetStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))))
                      ),
                      onPressed: selectedCollector == null
    ? null
    : ()async {
     // close sheet

      
      _showLoadingDialog(context);

      // 2) Small delay to let the dialog render (optional)
      await Future.delayed(const Duration(seconds: 4));

     
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PickupSuccessScreen(
              collectorName: selectedCollector!,
              distance: selectedCollector == "Kwaku" ? "0.2 km away" : "2.4 km away",
              rating: 4,
              isAvailable: true,
              profileImage: WMA_profiles.Profile_4,
            ),
          ),
        );
      },

                      child: const Text("Done"),
                    ),
                  ),
                  const SizedBox(height: 20),

                      ],
                ) ,
                ),
                  
              
                ],
              ),
            ),
          );
        },
      );
    },
  );
}






void _showCollectorSelectionSheet() {
  String? selectedCollector;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(builder: (context, setModalState) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              // ─── Green Discount Banner (with bottom curve) ─────────────
              Container(
                padding: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: WMA_Colours.greenPrimary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "15% discount apply on this request",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    // ── Drag Indicator ──
                    Container(
                      width: 60,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // ── Collector Cards ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCollectorCard(
                          title: "Collector X",
                          price: "GH₵ 45",
                          isSelected: selectedCollector == "X",
                          onTap: () {
                            setModalState(() => selectedCollector = "X");
                          },
                        ),
                        buildCollectorCard(
                          title: "Collector Co",
                          price: "GH₵ 60",
                          isSelected: selectedCollector == "Co",
                          onTap: () {
                            setModalState(() => selectedCollector = "Co");
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Payment Method ──
                    // ── Payment Method Dropdown ──
DropdownButtonFormField<String>(
  decoration: InputDecoration(
    prefixIcon: const Icon(Icons.attach_money_rounded, color: Colors.green),
    labelText: "Payment Method",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ),
  value: _selectedPaymentMethod,
  items: ['Cash', 'Card'].map((method) {
    return DropdownMenuItem<String>(
      value: method,
      child: Text(method),
    );
  }).toList(),
  onChanged: (value) {
    setModalState(() {
      _selectedPaymentMethod = value;
    });
  },
),


                    const SizedBox(height: 16),

                    // ── Next Button ──
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: selectedCollector == null || _selectedPaymentMethod == null
    ? null
    : () {
        Navigator.pop(context);
        showWasteCollectorSheet(context,  _selectedPaymentMethod!);
      },

                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  ],
                ),
              ),

              
            ],
          ),
        );
      });
    },
  );
}





Future<String?> _getPlaceNameFromLatLng(LatLng latLng) async {
  final apiKey = '${dotenv.env['GOOGLE_API_KEY']}';
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json'
    '?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      return data['results'][0]['formatted_address'];
    }
  }
  return null;
}

Future<String?> _getCityNameFromLatLng(LatLng latLng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      // Use null-aware operators to avoid crash
      final street = place.street ?? '';
      final locality = place.locality ?? '';
      final country = place.country ?? '';

      final components = [street, locality, country]
          .where((element) => element.isNotEmpty)
          .toList();

      return components.join(', ');
    }
  } catch (e) {
    print('Error in geocoding: $e');
  }
  return null;
}




  Future<void> _searchPlaces(String input) async {
  if (input.length < 3) {
    setState(() => _predictions = []);
    return;
  }

  setState(() => _isLoading = true); // Start loading

  final apiKey = '${dotenv.env['GOOGLE_API_KEY']}';
  final url = Uri.parse(
    '${dotenv.env['BASE_URL']}'
    '?input=$input'
    '&key=$apiKey'
    '&sessiontoken=$token',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    if (body['status'] == 'OK') {
      setState(() {
        _predictions = body['predictions'];
      });
    } else {
      print('Places API error: ${body['status']}');
    }
  } else {
    print('HTTP error ${response.statusCode}');
  }

  setState(() => _isLoading = false); // Stop loading
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request pickup",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ─── Search Bar + Map Button ─────────────────────────────────────────
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
                 Icon(
  _isEditing ? Icons.search : Icons.location_pin,
  color: _isEditing ? Colors.grey : Colors.green,
),

                  const SizedBox(width: 8),
                  Expanded(
  child: GestureDetector(
    onTap: () {
      if (!_isEditing) {
        setState(() => _isEditing = true);
      }
    },
    child: AbsorbPointer(
      absorbing: !_isEditing, // disables input if not editing
      child: TextField(
        controller: _searchController,
        onChanged: _searchPlaces,
        style: TextStyle(color: _isEditing ? Colors.black : Colors.grey),
        decoration: InputDecoration(
          hintText: _isLoading?"Loading........" :"Location" ,
          border: InputBorder.none,
        ),
      ),
    ),
  ),
),
                  ElevatedButton.icon(
                    onPressed: () async {
  setState(() => _isLoading = true); // Start loading

  final pickedLatLng = await Navigator.push<LatLng>(
    context,
    MaterialPageRoute(builder: (_) => const MapPage()),
  );

  if (pickedLatLng != null) {
    final place = await _getCityNameFromLatLng(pickedLatLng);
    if (place != null) {
      setState(() {
        _selectedLocation = place;
        _searchController.text = place;
        _isEditing = false;
      });
    }
  }

  setState(() => _isLoading = false); // Stop loading
},



                    icon: const Icon(Icons.map),
                    label: const Text("Map"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Suggestions List ───────────────────────────────────────────────
          Expanded(
  child: _isLoading
      ? const Center(child: Row( mainAxisAlignment: MainAxisAlignment.center,children: [
        Text("Loading........"),SizedBox(width: 15,), const Center(child: CircularProgressIndicator())
      ],))
      : _predictions.isEmpty
          ? const Center(child: Text("Search for a location..."))
          : ListView.separated(
              itemCount: _predictions.length,
              separatorBuilder: (_, __) => const Divider(height: 2, thickness: 0.4),
              itemBuilder: (context, index) {
                final p = _predictions[index];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(p['description'] as String),
                  onTap: () {
                    setState(() {
                      _selectedLocation = p['description'] as String;
                      _searchController.text = _selectedLocation!;
                      _predictions.clear();
                      _isEditing = false;
                    });
                  },
                );
              },
            ),
)
,

          // ─── Next Button ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _selectedLocation == null ? null : _showCollectorSelectionSheet,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


