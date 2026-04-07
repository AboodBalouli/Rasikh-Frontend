import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import '../providers/create_org_form_provider.dart';
import '../widgets/organization_text_field.dart';
import '../widgets/proof_document_uploader.dart';
import '../widgets/work_images_grid.dart';
import '../widgets/step_navigation_buttons.dart';
import 'package:flutter_application_1/features/shared/presentation/widgets/review_step_widget.dart';

class CreateOrgShopPage extends ConsumerWidget {
  const CreateOrgShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createOrgFormControllerProvider);
    final controller = ref.read(createOrgFormControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: CustomBackButton()),
        centerTitle: true,
        title: Image.asset(
          'assets/images/logobg.png',
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: formState.currentStep,
          onStepContinue: formState.currentStep < 2
              ? () => _nextStep(context, ref)
              : null,
          onStepCancel: formState.currentStep > 0
              ? () => controller.previousStep()
              : null,
          controlsBuilder: (context, details) {
            return const SizedBox.shrink();
          },
          steps: [
            Step(
              title: const Text(
                "المعلومات",
                style: TextStyle(fontFamily: AppFonts.parastoo),
              ),
              content: _CreateOrgStep1(
                formState: formState,
                onNextStep: () => _nextStep(context, ref),
                onPickProfileImage: () => _pickProfileImage(ref),
              ),
              isActive: formState.currentStep >= 0,
              state: formState.currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text(
                "المرفقات",
                style: TextStyle(fontFamily: AppFonts.parastoo),
              ),
              content: _buildStep2(context, ref, formState, controller),
              isActive: formState.currentStep >= 1,
              state: formState.currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text(
                "المراجعة",
                style: TextStyle(fontFamily: AppFonts.parastoo),
              ),
              content: _buildStep3(context, ref, formState, controller),
              isActive: formState.currentStep >= 2,
              state: formState.currentStep == 2
                  ? StepState.complete
                  : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep(BuildContext context, WidgetRef ref) {
    final controller = ref.read(createOrgFormControllerProvider.notifier);
    final success = controller.nextStep();
    if (!success) {
      HapticFeedback.lightImpact();
      final state = ref.read(createOrgFormControllerProvider);
      if (state.currentStep == 0 && state.profileImageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار صورة المتجر')),
        );
      } else if (state.currentStep == 1) {
        if (state.certificateBytes == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى ارفاق اثبات الجمعية')),
          );
        } else if (state.proofImages.length != 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى ارفاق 5 صور بالضبط من الأعمال')),
          );
        }
      }
    }
  }

  Future<void> _pickProfileImage(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      ref.read(createOrgFormControllerProvider.notifier).setProfileImage(bytes);
    }
  }

  Future<void> _pickProofImage(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      ref.read(createOrgFormControllerProvider.notifier).setCertificate(bytes);
    }
  }

  Future<void> _pickWorkImages(BuildContext context, WidgetRef ref) async {
    final state = ref.read(createOrgFormControllerProvider);
    if (state.proofImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يمكنك اختيار 5 صور كحد أقصى')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty) {
      final controller = ref.read(createOrgFormControllerProvider.notifier);
      for (var image in images) {
        final currentState = ref.read(createOrgFormControllerProvider);
        if (currentState.proofImages.length < 5) {
          final bytes = await image.readAsBytes();
          controller.addProofImage(bytes);
        } else {
          break;
        }
      }
    }
  }

  Future<void> _submitApplication(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(createOrgFormControllerProvider.notifier);
    final success = await controller.submit();
    if (success && context.mounted) {
      context.push('/org-success');
    } else if (context.mounted) {
      final state = ref.read(createOrgFormControllerProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!)));
      }
    }
  }

  Widget _buildStep2(
    BuildContext context,
    WidgetRef ref,
    CreateOrgFormState formState,
    CreateOrgFormController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProofDocumentUploader(
          proofDocumentBytes: formState.certificateBytes,
          onTap: () => _pickProofImage(ref),
        ),
        const SizedBox(height: 24),
        WorkImagesGrid(
          workImages: formState.proofImages,
          onAddTap: () => _pickWorkImages(context, ref),
          onRemoveTap: controller.removeProofImage,
        ),
        const SizedBox(height: 32),
        StepNavigationButtons(
          onNextPressed: () => _nextStep(context, ref),
          onPrevPressed: controller.previousStep,
          showPrevButton: true,
        ),
      ],
    );
  }

  Widget _buildStep3(
    BuildContext context,
    WidgetRef ref,
    CreateOrgFormState formState,
    CreateOrgFormController controller,
  ) {
    return ReviewStepWidget(
      onSubmit: () => _submitApplication(context, ref),
      onPrevious: controller.previousStep,
    );
  }
}

/// Step 1 widget with proper TextEditingController lifecycle management
class _CreateOrgStep1 extends ConsumerStatefulWidget {
  const _CreateOrgStep1({
    required this.formState,
    required this.onNextStep,
    required this.onPickProfileImage,
  });

  final CreateOrgFormState formState;
  final VoidCallback onNextStep;
  final VoidCallback onPickProfileImage;

  @override
  ConsumerState<_CreateOrgStep1> createState() => _CreateOrgStep1State();
}

class _CreateOrgStep1State extends ConsumerState<_CreateOrgStep1> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.formState.name);
    _descriptionController = TextEditingController(
      text: widget.formState.description,
    );
    _locationController = TextEditingController(
      text: widget.formState.location,
    );
    _phoneController = TextEditingController(text: widget.formState.phone);
  }

  @override
  void didUpdateWidget(_CreateOrgStep1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if state changed externally (not from our typing)
    if (widget.formState.name != oldWidget.formState.name &&
        widget.formState.name != _nameController.text) {
      _nameController.text = widget.formState.name;
    }
    if (widget.formState.description != oldWidget.formState.description &&
        widget.formState.description != _descriptionController.text) {
      _descriptionController.text = widget.formState.description;
    }
    if (widget.formState.location != oldWidget.formState.location &&
        widget.formState.location != _locationController.text) {
      _locationController.text = widget.formState.location;
    }
    if (widget.formState.phone != oldWidget.formState.phone &&
        widget.formState.phone != _phoneController.text) {
      _phoneController.text = widget.formState.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(createOrgFormControllerProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image picker
          Center(
            child: GestureDetector(
              onTap: widget.onPickProfileImage,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.formState.profileImageError
                            ? Colors.red
                            : const Color.fromARGB(
                                255,
                                83,
                                148,
                                93,
                              ).withValues(alpha: 0.3),
                        width: widget.formState.profileImageError ? 2 : 1,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color.fromARGB(
                        255,
                        83,
                        148,
                        93,
                      ).withValues(alpha: 0.1),
                      backgroundImage:
                          widget.formState.profileImageBytes != null
                          ? MemoryImage(widget.formState.profileImageBytes!)
                          : null,
                      child: widget.formState.profileImageBytes == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Color.fromARGB(255, 83, 148, 93),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "صورة المتجر *",
                    style: TextStyle(
                      fontFamily: AppFonts.parastoo,
                      fontSize: 12,
                    ),
                  ),
                  if (widget.formState.profileImageError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "هذا الحقل مطلوب",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          OrganizationTextField(
            "اسم الجمعية",
            _nameController,
            prefixIcon: Icons.business,
            inputFormatters: [LengthLimitingTextInputFormatter(15)],
            onChanged: controller.setName,
          ),
          const SizedBox(height: 16),
          OrganizationTextField(
            "وصف الجمعيه",
            _descriptionController,
            maxLines: 3,
            prefixIcon: Icons.description,
            inputFormatters: [LengthLimitingTextInputFormatter(500)],
            onChanged: controller.setDescription,
          ),
          const SizedBox(height: 16),
          OrganizationTextField(
            "الموقع",
            _locationController,
            prefixIcon: Icons.location_on,
            inputFormatters: [LengthLimitingTextInputFormatter(150)],
            onChanged: controller.setLocation,
          ),
          const SizedBox(height: 16),
          OrganizationTextField(
            "رقم للجمعيه",
            _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            prefixIcon: Icons.phone,
            onChanged: controller.setPhone,
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
          const SizedBox(height: 32),
          StepNavigationButtons(
            onNextPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                widget.onNextStep();
              } else {
                HapticFeedback.lightImpact();
              }
            },
            showPrevButton: false,
          ),
        ],
      ),
    );
  }
}
