import 'package:flutter/material.dart';
import 'package:location/location.dart';

/// ---------------------------------------------------------------------------
/// LocationService - Handles fixed town selection for Harara app
/// ---------------------------------------------------------------------------
class LocationService {
  // Fixed towns supported by your model
  static const List<String> _supportedTowns = [
    'Juba',
    'Wau',
    'Yambio',
    'Bor',
    'Malakal',
    'Bentiu',
  ];

  /// Returns the list of supported towns
  static List<String> get supportedTowns => _supportedTowns;

  /// Checks if a given town is valid within the model’s trained data
  static bool isValidTown(String town) {
    return _supportedTowns.contains(town);
  }

  /// Displays a dropdown selector widget for choosing town
  static Widget buildTownDropdown({
    required String? selectedTown,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedTown,
      decoration: InputDecoration(
        labelText: 'Select Your Town',
        prefixIcon: const Icon(Icons.location_city, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: _supportedTowns.map((town) {
        return DropdownMenuItem<String>(
          value: town,
          child: Text(town),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select your town' : null,
    );
  }

  /// Utility to get a display name or short code (optional helper)
  static String getTownShortName(String town) {
    switch (town.toLowerCase()) {
      case 'juba':
        return 'JUB';
      case 'wau':
        return 'WAU';
      case 'yambio':
        return 'YMB';
      case 'bor':
        return 'BOR';
      case 'malakal':
        return 'MLK';
      case 'bentiu':
        return 'BNT';
      default:
        return 'UNK';
    }
  }
}
