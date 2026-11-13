import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../models/greenhouse_state.dart';
import '../../theme/app_colors.dart';
import '../main_wrapper.dart';

/// Screen 3: Initial Greenhouse setup with interactive OpenStreetMap pin placement.
class DeployGreenhouseScreen extends StatefulWidget {
  const DeployGreenhouseScreen({super.key});

  @override
  State<DeployGreenhouseScreen> createState() => _DeployGreenhouseScreenState();
}

class _DeployGreenhouseScreenState extends State<DeployGreenhouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'My Backyard House');
  final _areaController = TextEditingController(text: '24');
  final _addressController = TextEditingController(text: 'Atyrau, Satpayev Ave');

  late final MapController _mapController;

  // Default coordinates: Atyrau, Kazakhstan
  LatLng _pinnedLocation = const LatLng(47.1067, 51.9167);
  bool _isSearching = false;
  String _mapStatusText = 'OpenStreetMap';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Geocoding search via OpenStreetMap Nominatim API
  Future<void> _searchAddress() async {
    final query = _addressController.text.trim();
    if (query.isEmpty) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSearching = true;
      _mapStatusText = 'Searching...';
    });

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1',
      );
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'PlantumApp/1.0 (contact@plantum.app)',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat'].toString());
          final lon = double.tryParse(data[0]['lon'].toString());
          if (lat != null && lon != null) {
            final newPos = LatLng(lat, lon);
            setState(() {
              _pinnedLocation = newPos;
              _mapStatusText = 'Found!';
            });
            _mapController.move(newPos, 14.0);
            return;
          }
        }
      }
      setState(() {
        _mapStatusText = 'Not found, tap map';
      });
    } catch (_) {
      setState(() {
        _mapStatusText = 'Offline mode, tap map';
      });
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _handleDeploy() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim().isEmpty ? 'My Backyard House' : _nameController.text.trim();
    final area = double.tryParse(_areaController.text.trim()) ?? 24.0;
    final address = _addressController.text.trim();

    // Persist to GreenhouseController
    try {
      final controller = GreenhouseScope.of(context);
      controller.updateGreenhouseDetails(
        name: name,
        area: area,
        address: address,
        latitude: _pinnedLocation.latitude,
        longitude: _pinnedLocation.longitude,
      );
    } catch (_) {
      // Ignored outside GreenhouseScope
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"$name" ($area m²) pinned & ready!',
          style: const TextStyle(
            color: AppColors.authGreen,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        backgroundColor: AppColors.authGreenSoft,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainWrapper()),
        (route) => false,
      );
    });
  }

  Widget _buildPinMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.authGreen,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Container(
          width: 3,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.authGreen,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Navigation Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.authInput,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.authText,
                              size: 19,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),

                        // Plantum Brand Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.authGreenSoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                color: AppColors.authGreen,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Plantum',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.authGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Heading
                    const Text(
                      'Set up your greenhouse',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.authText,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Name your space and pin its location on the map',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.authMuted,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Inputs Row: Name & Area
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greenhouse Name
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Greenhouse Name',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.authMuted,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Home Tomato House',
                                  hintStyle: const TextStyle(
                                    color: AppColors.authPlaceholder,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.authInput,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: AppColors.authGreen, width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter name';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Area (m²)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Area (m²)',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.authMuted,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _areaController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                ],
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: '24',
                                  hintStyle: const TextStyle(
                                    color: AppColors.authPlaceholder,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.authInput,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(color: AppColors.authGreen, width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Area';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Search Address / City
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address or City',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authMuted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _addressController,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (_) => _searchAddress(),
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'e.g. Atyrau, Satpayev Ave',
                            hintStyle: const TextStyle(
                              color: AppColors.authPlaceholder,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: AppColors.authInput,
                            contentPadding: const EdgeInsets.only(left: 14, right: 6, top: 10, bottom: 10),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.authGreen,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: _isSearching
                                    ? const Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.search_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: _searchAddress,
                                      ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: AppColors.authGreen, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Map Header (label & status)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tap map to place pin',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authMuted,
                          ),
                        ),
                        Text(
                          _mapStatusText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authGreen,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Interactive OpenStreetMap Container
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _pinnedLocation,
                            initialZoom: 13.0,
                            onTap: (tapPosition, point) {
                              setState(() {
                                _pinnedLocation = point;
                                _mapStatusText = 'Pin updated';
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.plantum.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _pinnedLocation,
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.topCenter,
                                  child: _buildPinMarker(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Coordinates Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.authInput,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.authGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pinned location',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.authMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${_pinnedLocation.latitude.toStringAsFixed(4)}, ${_pinnedLocation.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                              color: AppColors.authText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Deploy / Create Greenhouse Button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _handleDeploy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.authGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Create Greenhouse',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
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
