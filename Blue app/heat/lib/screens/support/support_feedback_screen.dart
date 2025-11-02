import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/colors.dart';
import '../../widgets/heat_app_bar.dart';
import '../../services/auth_service.dart';

class SupportFeedbackScreen extends StatefulWidget {
  static const route = '/support-feedback';
  const SupportFeedbackScreen({super.key});

  @override
  State<SupportFeedbackScreen> createState() => _SupportFeedbackScreenState();
}

class _SupportFeedbackScreenState extends State<SupportFeedbackScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Support form controllers
  final _supportFormKey = GlobalKey<FormState>();
  final _supportNameController = TextEditingController();
  final _supportEmailController = TextEditingController();
  final _supportMessageController = TextEditingController();
  String? _selectedIssueType;
  bool _supportLoading = false;

  // Feedback form controllers
  final _feedbackFormKey = GlobalKey<FormState>();
  final _feedbackNameController = TextEditingController();
  final _feedbackEmailController = TextEditingController();
  final _feedbackMessageController = TextEditingController();
  bool _feedbackLoading = false;

  final List<String> _issueTypes = [
    'API Error',
    'Login Issue',
    'Performance',
    'Data Display',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await AuthService.getUserData();
    final user = AuthService.currentUser;
    
    if (userData != null || user != null) {
      final name = userData?['name'] ?? user?.displayName ?? '';
      final email = userData?['email'] ?? user?.email ?? '';
      
      setState(() {
        _supportNameController.text = name;
        _supportEmailController.text = email;
        _feedbackNameController.text = name;
        _feedbackEmailController.text = email;
      });
    }
  }

  Future<void> _submitSupport() async {
    if (!_supportFormKey.currentState!.validate() || _selectedIssueType == null) {
      if (_selectedIssueType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an issue type')),
        );
      }
      return;
    }

    setState(() => _supportLoading = true);

    try {
      await FirebaseFirestore.instance.collection('support').add({
        'name': _supportNameController.text.trim(),
        'email': _supportEmailController.text.trim(),
        'issueType': _selectedIssueType!,
        'message': _supportMessageController.text.trim(),
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': AuthService.currentUser?.uid,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your issue has been submitted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        _supportMessageController.clear();
        setState(() => _selectedIssueType = null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _supportLoading = false);
  }

  Future<void> _submitFeedback() async {
    if (!_feedbackFormKey.currentState!.validate()) return;

    setState(() => _feedbackLoading = true);

    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'name': _feedbackNameController.text.trim(),
        'email': _feedbackEmailController.text.trim(),
        'message': _feedbackMessageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': AuthService.currentUser?.uid,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );
        _feedbackMessageController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _feedbackLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(112),
        child: AppBar(
          title: Text(
            'Support & Feedback',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, 
              color: Colors.white,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.support_agent), text: 'Support'),
              Tab(icon: Icon(Icons.feedback), text: 'Feedback'),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg, Colors.white],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSupportTab(),
            _buildFeedbackTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _supportFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: '🛠️ Report an Issue',
              subtitle: 'Help us improve by reporting any problems you encounter',
              children: [
                _buildTextField(
                  controller: _supportNameController,
                  label: 'Your Name',
                  icon: Icons.person_outline,
                  validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _supportEmailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v?.contains('@') != true ? 'Valid email required' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _supportMessageController,
                  label: 'Describe the issue',
                  icon: Icons.message_outlined,
                  maxLines: 4,
                  validator: (v) => v?.isEmpty == true ? 'Please describe the issue' : null,
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(
                  onPressed: _submitSupport,
                  loading: _supportLoading,
                  text: 'Submit Issue',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _feedbackFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: '💬 Share Your Feedback',
              subtitle: 'We value your opinion and suggestions for improvement',
              children: [
                _buildTextField(
                  controller: _feedbackNameController,
                  label: 'Your Name',
                  icon: Icons.person_outline,
                  validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _feedbackEmailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v?.contains('@') != true ? 'Valid email required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _feedbackMessageController,
                  label: 'Your feedback',
                  icon: Icons.rate_review_outlined,
                  maxLines: 5,
                  validator: (v) => v?.isEmpty == true ? 'Please share your feedback' : null,
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(
                  onPressed: _submitFeedback,
                  loading: _feedbackLoading,
                  text: 'Send Feedback',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.text.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.text.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.bg.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedIssueType,
      decoration: InputDecoration(
        labelText: 'Issue Type',
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.text.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.category_outlined, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.bg.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
      ),
      items: _issueTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => _selectedIssueType = value),
      validator: (v) => v == null ? 'Please select an issue type' : null,
    );
  }

  Widget _buildSubmitButton({
    required VoidCallback onPressed,
    required bool loading,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _supportNameController.dispose();
    _supportEmailController.dispose();
    _supportMessageController.dispose();
    _feedbackNameController.dispose();
    _feedbackEmailController.dispose();
    _feedbackMessageController.dispose();
    super.dispose();
  }
}