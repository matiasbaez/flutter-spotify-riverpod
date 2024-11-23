import 'package:client/core/providers/current_user_notifier.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    final data = switch (response) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    final response = await _authRemoteRepository.signin(
      email: email,
      password: password,
    );

    final data = switch (response) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.setUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = await _authLocalRepository.getToken();
    if (token != null) {
      final response = await _authRemoteRepository.getUserData(token);

      final data = switch (response) {
        Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
        Right(value: final r) => _getDataSuccess(r),
      };

      return data?.value;
    }

    return null;
  }

  AsyncValue<UserModel>? _getDataSuccess(UserModel user) {
    _currentUserNotifier.setUser(user);
    return state = AsyncValue.data(user);
  }
}
