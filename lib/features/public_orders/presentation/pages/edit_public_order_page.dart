import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/features/public_orders/presentation/providers/orders_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class EditPublicOrderPage extends ConsumerStatefulWidget {
  final String orderId;

  const EditPublicOrderPage({super.key, required this.orderId});

  @override
  ConsumerState<EditPublicOrderPage> createState() =>
      _EditPublicOrderPageState();
}

class _EditPublicOrderPageState extends ConsumerState<EditPublicOrderPage> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController locationController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController whatsappUrlController;

  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<File?> imageFile = ValueNotifier<File?>(null);

  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
    phoneNumberController = TextEditingController();
    whatsappUrlController = TextEditingController();
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

  String _normalizeWhatsAppUrl(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return raw;

    final uri = Uri.tryParse(raw);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return raw;
    }

    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return raw;
    return 'https://wa.me/$digitsOnly';
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return;
      imageFile.value = File(picked.path);
    } catch (_) {
      SnackbarHelper.showSnackBar('Failed to pick image', isError: true);
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;
      imageFile.value = File(picked.path);
    } catch (_) {
      SnackbarHelper.showSnackBar('Failed to take photo', isError: true);
    }
  }

  Future<void> _save() async {
    if (_loading) return;

    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    final loc = locationController.text.trim();
    final phone = phoneNumberController.text.trim();
    final wa = _normalizeWhatsAppUrl(whatsappUrlController.text);

    if (title.isEmpty ||
        desc.isEmpty ||
        loc.isEmpty ||
        phone.isEmpty ||
        wa.isEmpty) {
      SnackbarHelper.showSnackBar(
        'Please fill all required fields',
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final update = ref.read(updatePublicOrderUseCaseProvider);
      await update(
        id: widget.orderId,
        title: title,
        description: desc,
        location: loc,
        phoneNumber: phone,
        whatsappUrl: wa,
      );

      final file = imageFile.value;
      if (file != null) {
        final upload = ref.read(uploadPublicOrderImagesUseCaseProvider);
        await upload(publicOrderId: widget.orderId, filePaths: [file.path]);
      }

      ref.invalidate(publicOrderByIdProvider(widget.orderId));
      ref.invalidate(myPublicOrdersProvider);
      ref.invalidate(myPublicOrdersCountProvider);
      ref.invalidate(publicOrdersFeedControllerProvider);
      ref.invalidate(publicOrdersByStatusFeedControllerProvider('DISPLAYED'));
      ref.invalidate(publicOrdersByStatusFeedControllerProvider('COMPLETED'));

      if (!mounted) return;
      SnackbarHelper.showSnackBar('Order updated successfully');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color.fromARGB(255, 83, 148, 93);
    final orderAsync = ref.watch(publicOrderByIdProvider(widget.orderId));

    orderAsync.whenData((order) {
      if (_initialized) return;
      _initialized = true;
      titleController.text = order.title;
      descriptionController.text = order.description;
      locationController.text = order.location;
      phoneNumberController.text = order.phoneNumber;
      whatsappUrlController.text = order.whatsappUrl;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.7),
              elevation: 0,
              leading: const CustomBackButton(),
              title: const Text(
                'تعديل الطلب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryGreen,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: TextButton(
                      onPressed: _loading ? null : _save,
                      style: TextButton.styleFrom(
                        foregroundColor: primaryGreen,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryGreen,
                                ),
                              ),
                            )
                          : const Text(
                              'حفظ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 83, 148, 93),
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(e.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (_) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight + 16),
                  TextField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneNumberController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: whatsappUrlController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'WhatsApp (url or number)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<File?>(
                    valueListenable: imageFile,
                    builder: (context, file, _) {
                      if (file == null) {
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickFromGallery,
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('Gallery'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickFromCamera,
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text('Camera'),
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _pickFromGallery,
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Change'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => imageFile.value = null,
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Remove'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
