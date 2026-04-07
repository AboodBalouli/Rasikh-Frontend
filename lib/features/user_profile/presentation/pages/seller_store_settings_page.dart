import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/store_info.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class SellerStoreSettingsPage extends ConsumerStatefulWidget {
  const SellerStoreSettingsPage({super.key});

  @override
  ConsumerState<SellerStoreSettingsPage> createState() =>
      _SellerStoreSettingsPageState();
}

class _SellerStoreSettingsPageState
    extends ConsumerState<SellerStoreSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _pickedProfileImageBytes;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  final _openingHourController = TextEditingController();
  final _closingHourController = TextEditingController();

  final _countryController = TextEditingController(text: 'Jordan');
  String? _selectedGovernment;

  final _themeColorController = TextEditingController();

  final List<String> _jordanGovernorates = const [
    'عمان',
    'إربد',
    'الزرقاء',
    'البلقاء',
    'مأدبا',
    'الكرك',
    'الطفيلة',
    'معان',
    'العقبة',
    'جرش',
    'عجلون',
  ];

  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(storeSettingsControllerProvider).load());
  }

  Future<void> _onRefresh() async {
    // Reset prefill flag so form gets repopulated with fresh data
    setState(() => _didPrefill = false);
    await ref.read(storeSettingsControllerProvider).load();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _storeNameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _openingHourController.dispose();
    _closingHourController.dispose();
    _countryController.dispose();
    _themeColorController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded() {
    if (_didPrefill) return;

    final controller = ref.read(storeSettingsControllerProvider);
    final profile = controller.profile;
    if (profile == null) return;

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;

    final store = profile.store;
    _storeNameController.text = store?.storeName ?? '';
    _descriptionController.text = store?.description ?? '';
    _tagsController.text = (store?.tags ?? const <String>[]).join(', ');

    _addressController.text = store?.address ?? '';
    _phoneController.text = store?.phone ?? '';

    _countryController.text = store?.country?.isNotEmpty == true
        ? store!.country!
        : _countryController.text;

    _selectedGovernment = store?.government;

    final themeColor = store?.themeColor;
    if (themeColor != null && themeColor.isNotEmpty) {
      _themeColorController.text = themeColor;
    }

    final workingHours = store?.workingHours;
    final hours = _tryParseWorkingHoursHoursOnly(workingHours);
    if (hours != null) {
      _openingHourController.text = '${hours.$1}';
      _closingHourController.text = '${hours.$2}';
    }

    _didPrefill = true;
  }

  String? _toAbsoluteImageUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.trim().isEmpty) return null;
    final trimmed = pathOrUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  ImageProvider _profileAvatarImageProvider() {
    final bytes = _pickedProfileImageBytes;
    if (bytes != null) return MemoryImage(bytes);

    final profile = ref.read(storeSettingsControllerProvider).profile;
    final url = _toAbsoluteImageUrl(profile?.profilePicturePath);
    if (url != null) return NetworkImage(url);

    return const AssetImage('assets/images/photo5.png');
  }

  Future<void> _pickAndUploadProfileImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _pickedProfileImageBytes = bytes;
    });

    await ref
        .read(storeSettingsControllerProvider)
        .uploadProfilePicture(bytes: bytes, filename: picked.name);

    if (!mounted) return;

    final controller = ref.read(storeSettingsControllerProvider);
    if (controller.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.error!)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تحديث صورة الملف الشخصي')));

    setState(() {
      _pickedProfileImageBytes = null;
    });
  }

  (int, int)? _tryParseWorkingHoursHoursOnly(String? workingHours) {
    if (workingHours == null) return null;
    // Best-effort: find two hours anywhere in the string.
    final match = RegExp(r'(\d{1,2})\D+(\d{1,2})').firstMatch(workingHours);
    if (match == null) return null;
    final open = int.tryParse(match.group(1) ?? '');
    final close = int.tryParse(match.group(2) ?? '');
    if (open == null || close == null) return null;
    if (open < 0 || open > 23 || close < 0 || close > 23) return null;
    return (open, close);
  }

  List<String>? _parseTags(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final items = trimmed
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.toLowerCase())
        .toList();
    return items.isEmpty ? null : items;
  }

  String? _normalizeHexColor(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final normalized = trimmed.startsWith('#') ? trimmed : '#$trimmed';
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(normalized)) return null;
    return normalized.toUpperCase();
  }

  int? _parseHour(String raw) {
    final v = int.tryParse(raw.trim());
    if (v == null) return null;
    if (v < 0 || v > 23) return null;
    return v;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final open = _parseHour(_openingHourController.text) ?? 0;
    final close = _parseHour(_closingHourController.text) ?? 0;

    final themeColor = _normalizeHexColor(_themeColorController.text);
    if (_themeColorController.text.trim().isNotEmpty && themeColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لون الثيم يجب أن يكون بصيغة #RRGGBB')),
      );
      return;
    }

    final request = StoreInfo(
      // Store
      storeName: _storeNameController.text.trim().isEmpty
          ? null
          : _storeNameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      tags: _parseTags(_tagsController.text),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      workingHours: '$open-$close',
      country: _countryController.text.trim().isEmpty
          ? null
          : _countryController.text.trim(),
      government: _selectedGovernment,
      themeColor: themeColor,

      // Profile
      firstName: _firstNameController.text.trim().isEmpty
          ? null
          : _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim().isEmpty
          ? null
          : _lastNameController.text.trim(),
    );

    final controller = ref.read(storeSettingsControllerProvider);
    await controller.save(request);

    if (!mounted) return;

    if (controller.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.error!)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ إعدادات المتجر بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(storeSettingsControllerProvider);
    _prefillIfNeeded();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعدادات المتجر العامة',
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
          ? Center(
              child: Padding(
                padding: Responsive.paddingAll(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(fontSize: context.sp(14)),
                    ),
                    SizedBox(height: context.hp(1.5)),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(storeSettingsControllerProvider).load(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: Responsive.paddingAll(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: context.sp(55),
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _profileAvatarImageProvider(),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: controller.isSaving
                                    ? null
                                    : _pickAndUploadProfileImage,
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: EdgeInsets.all(context.wp(2)),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: controller.isSaving
                                      ? SizedBox(
                                          width: context.sp(18),
                                          height: context.sp(18),
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                      : Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: context.sp(18),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.hp(2.5)),

                      _buildSectionTitle(Icons.person, 'بيانات البائع'),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'الاسم الأول',
                        icon: Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'الاسم الأول مطلوب'
                            : null,
                      ),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'اسم العائلة',
                        icon: Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'اسم العائلة مطلوب'
                            : null,
                      ),

                      SizedBox(height: context.hp(2.5)),
                      _buildSectionTitle(
                        Icons.store_mall_directory,
                        'معلومات المتجر',
                      ),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _storeNameController,
                        label: 'اسم المتجر',
                        icon: Icons.storefront_outlined,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'اسم المتجر مطلوب'
                            : null,
                      ),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'الوصف',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _tagsController,
                        label: 'التاغز (افصل بفواصل ,)',
                        icon: Icons.tag,
                      ),

                      SizedBox(height: context.hp(2.5)),
                      _buildSectionTitle(Icons.location_on_outlined, 'العنوان'),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _countryController,
                        label: 'الدولة',
                        icon: Icons.public,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'الدولة مطلوبة'
                            : null,
                      ),
                      SizedBox(height: context.hp(1.5)),
                      DropdownButtonFormField<String>(
                        value: _selectedGovernment,
                        decoration: InputDecoration(
                          labelText: 'المحافظة',
                          labelStyle: TextStyle(fontSize: context.sp(14)),
                          prefixIcon: const Icon(Icons.map_outlined),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _jordanGovernorates
                            .map(
                              (gov) => DropdownMenuItem(
                                value: gov,
                                child: Text(
                                  gov,
                                  style: GoogleFonts.cairo(
                                    fontSize: context.sp(14),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedGovernment = val),
                        validator: (v) =>
                            v == null ? 'الرجاء اختيار المحافظة' : null,
                      ),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _addressController,
                        label: 'العنوان التفصيلي',
                        icon: Icons.location_city_outlined,
                        maxLines: 2,
                      ),

                      SizedBox(height: context.hp(2.5)),
                      _buildSectionTitle(Icons.phone_android, 'التواصل'),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'رقم الهاتف',
                        icon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'رقم الهاتف مطلوب'
                            : null,
                      ),

                      SizedBox(height: context.hp(2.5)),
                      _buildSectionTitle(
                        Icons.access_time_filled,
                        'ساعات العمل',
                      ),
                      SizedBox(height: context.hp(1.5)),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _openingHourController,
                              label: 'ساعة الفتح (0-23)',
                              icon: Icons.lock_clock,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              validator: (v) {
                                final hour = _parseHour(v ?? '');
                                return hour == null ? 'ادخل رقم 0-23' : null;
                              },
                            ),
                          ),
                          SizedBox(width: context.wp(3)),
                          Expanded(
                            child: _buildTextField(
                              controller: _closingHourController,
                              label: 'ساعة الإغلاق (0-23)',
                              icon: Icons.lock_clock,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              validator: (v) {
                                final hour = _parseHour(v ?? '');
                                return hour == null ? 'ادخل رقم 0-23' : null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.hp(2.5)),
                      _buildSectionTitle(Icons.palette_outlined, 'ثيم المتجر'),
                      SizedBox(height: context.hp(1.5)),
                      _buildTextField(
                        controller: _themeColorController,
                        label: 'Theme Color (مثال: #1A2B3C)',
                        icon: Icons.color_lens_outlined,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: [
                          _colorChip('#1A2B3C'),
                          _colorChip('#2E7D32'),
                          _colorChip('#1565C0'),
                          _colorChip('#6A1B9A'),
                          _colorChip('#C62828'),
                        ],
                      ),

                      SizedBox(height: context.hp(4)),
                      SizedBox(
                        width: double.infinity,
                        height: context.hp(6),
                        child: ElevatedButton(
                          onPressed: controller.isSaving ? null : _save,
                          child: controller.isSaving
                              ? SizedBox(
                                  width: context.sp(20),
                                  height: context.sp(20),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'حفظ التغييرات',
                                  style: TextStyle(fontSize: context.sp(16)),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _colorChip(String hex) {
    final color = Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
    final selected =
        _themeColorController.text.trim().toUpperCase() == hex.toUpperCase();

    return InkWell(
      onTap: () => setState(() => _themeColorController.text = hex),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: context.wp(10),
        height: context.wp(10),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.black : Colors.black12,
            width: selected ? 3 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: context.sp(24)),
        SizedBox(width: context.wp(2.5)),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: context.sp(16),
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(fontSize: context.sp(14)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: context.sp(14)),
        prefixIcon: Icon(icon, size: context.sp(22)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
