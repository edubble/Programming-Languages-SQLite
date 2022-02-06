import 'package:api_to_sqlite/src/models/language_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class LanguageApiProvider {
  Future<List<Language?>> getAllLanguages() async {
    var url = "https://demo9955837.mockable.io/programming-languages";
    Response response = await Dio().get(url);

    return (response.data as List).map((language) {
      // ignore: avoid_print
      print('Inserting $language');
      DBProvider.db.createLanguage(Language.fromJson(language));
    }).toList();
  }
}