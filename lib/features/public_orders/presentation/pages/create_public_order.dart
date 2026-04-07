import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/core/widgets/forms/app_text_form_field.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/presentation/widgets/create_public_order_page_appbar.dart';
import 'package:flutter_application_1/features/public_orders/presentation/providers/orders_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreatePublicOrder extends ConsumerStatefulWidget {
  final PublicOrder? initialOrder;

  const CreatePublicOrder({super.key, this.initialOrder});

  @override
  ConsumerState<CreatePublicOrder> createState() => _CreatePublicOrderState();
}

class _CreatePublicOrderState extends ConsumerState<CreatePublicOrder> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPublicOrderControllerProvider);
    final controller = ref.read(createPublicOrderControllerProvider.notifier);

    // Initialize edit mode once per build lifecycle.
    // This is safe because StateNotifierProvider is autoDispose and recreated per route.
    final order = widget.initialOrder;
    if (order != null && state.editingOrderId == null) {
      controller.initializeForEdit(order);
    }

    // Create page is for creating only.

    Future<void> showPickImageSheet() async {
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                  onTap: () async {
                    sheetContext.pop();
                    await controller.pickFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Gallery'),
                  onTap: () async {
                    sheetContext.pop();
                    await controller.pickFromGallery();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: const CreatePublicOrderPageAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight + 16),
                AppTextFormField(
                  textInputAction: TextInputAction.next,
                  labelText: 'Title',
                  keyboardType: TextInputType.text,
                  controller: controller.titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                ),
                AppTextFormField(
                  textInputAction: TextInputAction.next,
                  labelText: 'Description',
                  keyboardType: TextInputType.text,
                  controller: controller.descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: DropdownButtonFormField<String>(
                    value: state.selectedGovernorate,
                    items: controller.governorates
                        .map(
                          (g) => DropdownMenuItem<String>(
                            value: g,
                            child: Text(g),
                          ),
                        )
                        .toList(),
                    onChanged: controller.setGovernorate,
                    decoration: const InputDecoration(
                      labelText: 'Governorate',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                ),
                AppTextFormField(
                  textInputAction: TextInputAction.next,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    if (!RegExp(r'^0(77|78|79)\d{7}$').hasMatch(value)) {
                      return 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079 ويتكون من 10 أرقام';
                    }
                    return null;
                  },
                ),
                AppTextFormField(
                  textInputAction: TextInputAction.done,
                  labelText: 'WhatsApp Phone Number',
                  keyboardType: TextInputType.phone,
                  controller: controller.whatsappUrlController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    if (!RegExp(r'^0(77|78|79)\d{7}$').hasMatch(value)) {
                      return 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079 ويتكون من 10 أرقام'; // todo: put them in app constants
                    }
                    return null;
                  },
                ),
                // Image picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ValueListenableBuilder(
                    valueListenable: controller.imageFile,
                    builder: (context, file, _) {
                      final borderRadius = BorderRadius.circular(12);

                      if (file == null) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: showPickImageSheet,
                            child: SizedBox(
                              width: double.infinity,
                              height: 160,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 28,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add image',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                            maxHeight: 500,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Material(
                                    borderRadius: borderRadius,
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: showPickImageSheet,
                                      child: kIsWeb
                                          ? FutureBuilder<Uint8List>(
                                              future: file.readAsBytes(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Image.memory(
                                                    snapshot.data!,
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            )
                                          : Image.file(
                                              File(file.path),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton.filledTonal(
                                        onPressed: showPickImageSheet,
                                        icon: const Icon(Icons.edit_outlined),
                                        tooltip: 'Edit image',
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton.filledTonal(
                                        onPressed: controller.clearImage,
                                        icon: const Icon(Icons.delete_outline),
                                        tooltip: 'Remove image',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                Builder(
                  builder: (_) {
                    final loading = state.isLoading;
                    final enabled = !loading && state.isFormValid;

                    return CustomButton(
                      onPressed: enabled
                          ? () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              final ok = await controller.submitOrder(context);
                              if (!context.mounted) return;
                              if (ok) context.pop();
                            }
                          : () {
                              _formKey.currentState!.validate();
                            },
                      text: 'إرسال الطلب',
                      isLoading: loading,
                      height: 50,
                      borderRadius: 12,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
