import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:encontra_cep/models/endereco_model.dart';

import './cep_repository.dart';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final result = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      return EnderecoModel.frontMap(result.data);
    } on DioError catch (e) {
      log('Erro buscar CEP', error: e);
      throw Exception('erro ao buscar CEP');
    }
  }
}
