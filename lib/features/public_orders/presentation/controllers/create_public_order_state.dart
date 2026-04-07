class CreatePublicOrderState {
  final bool isLoading;
  final bool isFormValid;
  final String? selectedGovernorate;
  final String? editingOrderId;

  const CreatePublicOrderState({
    required this.isLoading,
    required this.isFormValid,
    required this.selectedGovernorate,
    required this.editingOrderId,
  });

  factory CreatePublicOrderState.initial() => const CreatePublicOrderState(
    isLoading: false,
    isFormValid: false,
    selectedGovernorate: null,
    editingOrderId: null,
  );

  CreatePublicOrderState copyWith({
    bool? isLoading,
    bool? isFormValid,
    String? selectedGovernorate,
    String? editingOrderId,
  }) {
    return CreatePublicOrderState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      editingOrderId: editingOrderId ?? this.editingOrderId,
    );
  }
}
