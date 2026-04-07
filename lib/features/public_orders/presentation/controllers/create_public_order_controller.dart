import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/orders_exception.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/create_public_order_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/update_public_order_usecase.dart';
import 'package:flutter_application_1/features/public_orders/domain/usecases/upload_public_order_images_usecase.dart';
import 'package:flutter_application_1/features/public_orders/presentation/controllers/create_public_order_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class CreatePublicOrderController
    extends StateNotifier<CreatePublicOrderState> {
  final CreatePublicOrderUseCase _createPublicOrderUseCase;
  final UpdatePublicOrderUseCase _updatePublicOrderUseCase;
  final UploadPublicOrderImagesUseCase _uploadImagesUseCase;

  /// Mapping from English (database) to Arabic (display) governorate names.
  static const Map<String, String> governorateEnToAr = <String, String>{
    'amman': 'عمان',
    'ajloun': 'عجلون',
    'aqaba': 'العقبة',
    'balqa': 'البلقاء',
    'irbid': 'إربد',
    'jerash': 'جرش',
    'karak': 'الكرك',
    'maan': 'معان',
    'madaba': 'مأدبا',
    'mafraq': 'المفرق',
    'tafilah': 'الطفيلة',
    'zarqa': 'الزرقاء',
  };

  /// Reverse mapping from Arabic to English.
  static final Map<String, String> governorateArToEn = {
    for (final entry in governorateEnToAr.entries) entry.value: entry.key,
  };

  /// List of Arabic governorate names for dropdown display.
  List<String> get governorates => governorateEnToAr.values.toList();

  /// Converts English governorate to Arabic for display.
  String? englishToArabic(String? english) {
    if (english == null || english.isEmpty) return null;
    return governorateEnToAr[english.toLowerCase()];
  }

  /// Converts Arabic governorate to English for storage.
  String? arabicToEnglish(String? arabic) {
    if (arabic == null || arabic.isEmpty) return null;
    return governorateArToEn[arabic];
  }

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController locationController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController whatsappUrlController;

  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<XFile?> imageFile = ValueNotifier<XFile?>(null);

  CreatePublicOrderController(
    this._createPublicOrderUseCase,
    this._updatePublicOrderUseCase,
    this._uploadImagesUseCase,
  ) : super(CreatePublicOrderState.initial()) {
    _initializeControllers();
  }

  void _initializeControllers() {
    titleController = TextEditingController()..addListener(_controllerListener);
    descriptionController = TextEditingController()
      ..addListener(_controllerListener);
    locationController = TextEditingController()
      ..addListener(_controllerListener);
    phoneNumberController = TextEditingController()
      ..addListener(_controllerListener);
    whatsappUrlController = TextEditingController()
      ..addListener(_controllerListener);
  }

  void _controllerListener() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final governorate = (state.selectedGovernorate ?? '').trim();
    final phone = phoneNumberController.text.trim();
    final whatsapp = whatsappUrlController.text.trim();

    final isValid =
        title.isNotEmpty &&
        description.isNotEmpty &&
        governorate.isNotEmpty &&
        phone.isNotEmpty &&
        whatsapp.isNotEmpty;

    if (state.isFormValid == isValid) return;
    state = state.copyWith(isFormValid: isValid);
  }

  void setGovernorate(String? arabicValue) {
    // Store Arabic for dropdown display, but keep English for API.
    state = state.copyWith(selectedGovernorate: arabicValue);
    // locationController stores the English value for API submission.
    final englishValue = arabicToEnglish(arabicValue) ?? arabicValue ?? '';
    locationController.text = englishValue;
    _controllerListener();
  }

  void initializeForEdit(PublicOrder order) {
    // Populate fields from existing order.
    // Convert English location from DB to Arabic for dropdown display.
    final arabicGov = englishToArabic(order.location);
    state = state.copyWith(
      editingOrderId: order.id,
      selectedGovernorate: arabicGov,
    );
    titleController.text = order.title;
    descriptionController.text = order.description;
    // locationController stores English for API submission.
    locationController.text = order.location;
    phoneNumberController.text = order.phoneNumber;
    whatsappUrlController.text = order.whatsappUrl;
    _controllerListener();
  }

  String _normalizeWhatsAppUrl(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return raw;

    final uri = Uri.tryParse(raw);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return raw;
    }

    // If user entered a phone number, convert to wa.me URL.
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return raw;
    return 'https://wa.me/$digitsOnly';
  }

  Future<bool> submitOrder(BuildContext context) async {
    if (!state.isFormValid) {
      SnackbarHelper.showSnackBar(
        'Please fill all required fields',
        isError: true,
      );
      return false;
    }

    try {
      state = state.copyWith(isLoading: true);

      // Use the English value from locationController for API submission.
      final governorate = locationController.text.trim();
      final whatsappUrl = _normalizeWhatsAppUrl(whatsappUrlController.text);

      final editingId = state.editingOrderId;

      PublicOrder saved;
      if (editingId == null || editingId.isEmpty) {
        final order = PublicOrder.create(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          location: governorate,
          phoneNumber: phoneNumberController.text.trim(),
          whatsappUrl: whatsappUrl,
          imageUrl: null,
        );

        saved = await _createPublicOrderUseCase(order);
      } else {
        saved = await _updatePublicOrderUseCase(
          id: editingId,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          location: governorate,
          phoneNumber: phoneNumberController.text.trim(),
          whatsappUrl: whatsappUrl,
        );
      }

      final file = imageFile.value;
      if (file != null) {
        await _uploadImagesUseCase(
          publicOrderId: saved.id,
          filePaths: [file.path],
        );
      }

      final success = true;
      if (!context.mounted) return success;
      SnackbarHelper.showSnackBar(
        (editingId == null || editingId.isEmpty)
            ? 'Order created successfully'
            : 'Order updated successfully',
      );
      return success;
    } on OrdersException catch (e) {
      if (!context.mounted) return false;
      SnackbarHelper.showSnackBar(e.message, isError: true);
      return false;
    } catch (_) {
      if (!context.mounted) return false;
      SnackbarHelper.showSnackBar('Unexpected error, try again', isError: true);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return;

      imageFile.value = picked;
    } catch (_) {
      SnackbarHelper.showSnackBar('Failed to pick image', isError: true);
    }
  }

  /// Pick image from camera
  Future<void> pickFromCamera() async {
    // On Web, ImageSource.camera is supported by modern browsers.
    // On Mobile, it works natively.
    // On Desktop (Windows/Mac/Linux), it might not be supported yet by image_picker.
    // We try; if it throws or is not supported, we catch it or let the plugin handle it.

    // For now, we simply remove the blocking check for Web users.

    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;

      imageFile.value = picked;
    } catch (_) {
      // Fallback or error
      // If camera fails (e.g. not supported on Windows Desktop app), we could try gallery
      // or just show error.
      SnackbarHelper.showSnackBar(
        'Camera not supported or failed. Trying gallery...',
        isError: false,
      );
      await pickFromGallery();
    }
  }

  /// Remove image
  void clearImage() {
    imageFile.value = null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    phoneNumberController.dispose();
    whatsappUrlController.dispose();
    imageFile.dispose();
    super.dispose();
  }
}
