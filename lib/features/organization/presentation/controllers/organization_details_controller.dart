import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/features/organization/domain/entities/organization_details.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_organization_by_id_usecase.dart';
import '../providers/organization_provider.dart';

/// State for the organization details page.
class OrganizationDetailsState {
  const OrganizationDetailsState({
    this.organization,
    this.isLoading = false,
    this.error,
  });

  final OrganizationDetails? organization;
  final bool isLoading;
  final String? error;

  OrganizationDetailsState copyWith({
    OrganizationDetails? organization,
    bool? isLoading,
    String? error,
  }) {
    return OrganizationDetailsState(
      organization: organization ?? this.organization,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider for the organization details controller.
final organizationDetailsControllerProvider =
    NotifierProvider<OrganizationDetailsController, OrganizationDetailsState>(
      OrganizationDetailsController.new,
    );

/// Controller for the organization details page.
class OrganizationDetailsController extends Notifier<OrganizationDetailsState> {
  late final GetOrganizationByIdUseCase _getOrganizationById;
  String? _activeOrganizationId;

  @override
  OrganizationDetailsState build() {
    _getOrganizationById = ref.read(getOrganizationByIdUseCaseProvider);
    return const OrganizationDetailsState(isLoading: false);
  }

  /// Loads organization details by ID.
  Future<void> loadOrganization(String organizationId) async {
    if (_activeOrganizationId == organizationId) {
      if (state.isLoading) return;
      if (state.organization != null) return;
    }

    _activeOrganizationId = organizationId;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orgId = int.tryParse(organizationId);
      if (orgId == null) {
        throw Exception('Invalid organization id');
      }
      final organization = await _getOrganizationById(orgId);

      state = state.copyWith(organization: organization, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل بيانات الجمعية: ${e.toString()}',
      );
    }
  }

  /// Refreshes organization details.
  Future<void> refresh() async {
    final id = _activeOrganizationId;
    if (id == null || id.isEmpty) return;
    await loadOrganization(id);
  }
}
