import 'package:encontra_cep/models/endereco_model.dart';
import 'package:encontra_cep/repositories/cep_repository.dart';
import 'package:encontra_cep/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;
  bool loading = false;

  final formatKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Cep'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formatKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP Obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formatKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        loading = false;
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Erro ao buscar Endereço')),
                      );
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
              Visibility(
                  visible: loading, child: const CircularProgressIndicator()),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                  '${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}.',
                ),
              ),
            ],
          ),
        ),
      ),
    ); //Scaffold
  }
}
