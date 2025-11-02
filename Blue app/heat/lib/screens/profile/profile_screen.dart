import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/heat_app_bar.dart';
import '../../services/auth_service.dart';
import '../../core/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _loading = true;
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await AuthService.getUserData();
      setState(() {
        _userData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image == null) return;

      setState(() => _uploading = true);

      // Simple base64 encoding for now (works without Firebase Storage setup)
      final bytes = await image.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      await AuthService.updateUserData({'photoURL': base64Image});

      setState(() {
        _userData?['photoURL'] = base64Image;
        _uploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } catch (e) {
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userData: _userData),
      ),
    );

    if (result == true) {
      _loadUserData();
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and will permanently remove all your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AuthService.deleteAccount();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Print current UID to terminal with clear markers
    print("\n" + "="*50);
    print("🔥🔥🔥 CURRENT USER UID: ${FirebaseAuth.instance.currentUser?.uid} 🔥🔥🔥");
    print("🔥🔥🔥 EMAIL: ${FirebaseAuth.instance.currentUser?.email} 🔥🔥🔥");
    print("="*50 + "\n");
    
    if (_loading) {
      return const Scaffold(
        appBar: HeatAppBar(title: "Profile"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = AuthService.currentUser;
    final name = _userData?['name'] ?? user?.displayName ?? 'User';
    final email = _userData?['email'] ?? user?.email ?? 'No email';
    final location = _userData?['location'] ?? 'Not set';
    final photoURL = _userData?['photoURL'] ?? user?.photoURL;

    return Scaffold(
      appBar: const HeatAppBar(title: "Profile", showDrawer: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: photoURL != null 
                      ? (photoURL.startsWith('data:image') 
                          ? MemoryImage(base64Decode(photoURL.split(',')[1]))
                          : NetworkImage(photoURL)) as ImageProvider
                      : null,
                  child: photoURL == null
                      ? Icon(Icons.person, size: 50, color: AppColors.primary)
                      : null,
                ),
                if (_uploading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: _uploading ? null : _pickAndUploadImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.fingerprint, color: Colors.red),
              title: Text("Firebase UID (Debug)", style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(FirebaseAuth.instance.currentUser?.uid ?? 'No UID', 
                           style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red)),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text("Email", style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(email, style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text("Default Town", style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(location, style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: Text("Sign Out", style: Theme.of(context).textTheme.bodyLarge),
              onTap: () async {
                await AuthService.signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text("Delete Account", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red)),
              subtitle: Text("Permanently delete your account and all data", style: Theme.of(context).textTheme.bodySmall),
              onTap: _deleteAccount,
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const EditProfileScreen({super.key, this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedTown;
  bool _loading = false;

  final List<String> _towns = [
    'Juba', 'Wau', 'Yambio', 'Bor', 'Malakal', 'Bentiu'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData?['name'] ?? '');
    _phoneController = TextEditingController(text: widget.userData?['phone'] ?? '');
    _selectedTown = widget.userData?['location'];
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTown == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a town')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.updateUserData({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _selectedTown,
      });

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _saveChanges,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty == true ? 'Phone is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTown,
              decoration: const InputDecoration(
                labelText: 'Town',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _towns.map((town) => DropdownMenuItem(
                value: town,
                child: Text(town),
              )).toList(),
              onChanged: (value) => setState(() => _selectedTown = value),
              validator: (value) => value == null ? 'Please select a town' : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}