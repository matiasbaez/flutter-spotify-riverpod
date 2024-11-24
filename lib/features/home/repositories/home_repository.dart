import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String artist,
    required String songName,
    required String hexColor,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.baseUrl}/song/upload'),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath(
            'song',
            selectedAudio.path,
          ),
          await http.MultipartFile.fromPath(
            'thumbnail',
            selectedImage.path,
          ),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexColor,
        })
        ..headers.addAll({
          'x-auth-token': token,
        });

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return Right(body);
      }

      return Left(AppFailure(body));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
