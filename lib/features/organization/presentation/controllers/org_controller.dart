import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/app/dependency_injection/organization_dependency_injection.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';

class OrganizationState {
  final List<Organization> organizations;
  final bool isLoading;
  final String? error;

  const OrganizationState({
    this.organizations = const [],
    this.isLoading = false,
    this.error,
  });

  OrganizationState copyWith({
    List<Organization>? organizations,
    bool? isLoading,
    String? error,
  }) {
    return OrganizationState(
      organizations: organizations ?? this.organizations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final organizationControllerProvider =
    NotifierProvider<OrganizationController, OrganizationState>(
      OrganizationController.new,
    );

class OrganizationController extends Notifier<OrganizationState> {
  late final OrganizationRepository _repo;

  @override
  OrganizationState build() {
    _repo = ref.read(organizationRepositoryProvider);
    Future.microtask(loadOrganizations);
    return const OrganizationState(isLoading: true);
  }

  Future<void> loadOrganizations() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final organizations = await _repo.getAllOrganizations();
      state = state.copyWith(organizations: organizations, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load organizations',
      );
    }
  }
}
