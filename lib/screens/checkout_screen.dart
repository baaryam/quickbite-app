import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final TextEditingController _notesController = TextEditingController();

  String _selectedLocation = 'Main Canteen - Counter 1';
  final List<String> _locations = [
    'Main Canteen - Counter 1',
    'Main Canteen - Counter 2 (Beverages)',
    'Engineering Faculty Cafe',
    'Student Center Kiosk',
  ];

  String _selectedPickupTime = 'ASAP (10-15 mins)';
  final List<String> _pickupTimes = [
    'ASAP (10-15 mins)',
    'In 30 mins',
    'After Next Lecture (12:30 PM)',
    'After Next Lecture (1:15 PM)',
  ];

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _nameController = TextEditingController(text: appState.currentUser?.name ?? 'Guest Student');
    _phoneController = TextEditingController(text: '+94 77 345 6789');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isProcessing = true);

      final appState = Provider.of<AppState>(context, listen: false);
      final newOrder = appState.placeOrder(
        pickupLocation: _selectedLocation,
        estimatedPickupTime: _selectedPickupTime,
        contactPhone: _phoneController.text.trim(),
        specialNotes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      // Simulate quick processing delay
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _isProcessing = false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/order-confirmation',
            (route) => route.settings.name == '/home',
            arguments: newOrder.id,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Simulated Checkout'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.cartItems.isEmpty && !_isProcessing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 60, color: AppTheme.successGreen),
                  const SizedBox(height: 16),
                  const Text(
                    'No pending items in cart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text('BACK TO MENU'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveLayout.getMaxContentWidth(context),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ResponsiveLayout(
                    mobile: _buildFormContent(context, appState),
                    tablet: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildFormContent(context, appState, isTablet: true)),
                        const SizedBox(width: 24),
                        Expanded(flex: 4, child: _buildOrderPreviewCard(context, appState)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, AppState appState, {bool isTablet = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pickup Details Section Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.storefront_rounded, color: AppTheme.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Pickup Details',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pickup Location Selector
                const Text('Select Pickup Counter', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
                  ),
                  items: _locations.map((loc) {
                    return DropdownMenuItem(value: loc, child: Text(loc, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLocation = val);
                  },
                ),
                const SizedBox(height: 16),

                // Pickup Time Selector
                const Text('Estimated Pickup Time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedPickupTime,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.access_time_rounded, color: AppTheme.primaryColor),
                  ),
                  items: _pickupTimes.map((time) {
                    return DropdownMenuItem(value: time, child: Text(time, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedPickupTime = val);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Contact Information Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_pin_rounded, color: AppTheme.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Student Contact Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter student name';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Contact Phone / WhatsApp',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter contact number';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Special Pickup Instructions (Optional)',
                    hintText: 'e.g. Please pack separately, keep extra chili paste...',
                    prefixIcon: Icon(Icons.note_alt_outlined, color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (!isTablet) _buildOrderPreviewCard(context, appState),
      ],
    );
  }

  Widget _buildOrderPreviewCard(BuildContext context, AppState appState) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_rounded, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Order Breakdown',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Item summary list
            ...appState.cartItems.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${c.quantity}x ${c.foodItem.name}',
                          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        c.formattedSubtotal,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
            const Divider(color: AppTheme.borderLight, height: 20),

            // Grand Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
                Text(
                  appState.formattedCartGrandTotal,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppTheme.primaryDark),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Pay at counter upon pickup (Simulated Mode)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // PLACE ORDER BUTTON
            ElevatedButton(
              onPressed: _isProcessing ? null : _handlePlaceOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryColor,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
