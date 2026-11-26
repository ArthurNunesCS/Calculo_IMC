import 'package:material_ui/material_ui.dart';
void main() {
  runApp(const MyApp());
}

// Classe MyApp (StatelessWidget): raiz do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

// Tela principal (StatefulWidget): o conteúdo muda conforme o cálculo
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controllers dos campos de texto
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  // Chave do formulário (para validar os campos)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Texto exibido abaixo do botão
  String _infoText = "Informe seus dados";

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  // Limpa os campos e volta o texto inicial
  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados";
      _formKey.currentState?.reset();
    });
  }

  // Calcula o IMC e atualiza o texto com a classificação
  void _calcular() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      // Aceita vírgula ou ponto como separador decimal
      double weight =
          double.parse(weightController.text.replaceAll(',', '.'));
      double height =
          double.parse(heightController.text.replaceAll(',', '.')) / 100;
      double imc = weight / (height * height);
      String valor = imc.toStringAsFixed(2);

      if (imc < 18.5) {
        _infoText = "Abaixo do peso ($valor)";
      } else if (imc < 25) {
        _infoText = "Peso ideal ($valor)";
      } else if (imc < 30) {
        _infoText = "Levemente acima do peso ($valor)";
      } else if (imc < 35) {
        _infoText = "Obesidade grau I ($valor)";
      } else if (imc < 40) {
        _infoText = "Obesidade grau II ($valor)";
      } else {
        _infoText = "Obesidade grau III ($valor)";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 136, 243),
        actions: <Widget>[
          IconButton(
            onPressed: _resetFields,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 175, 209, 236),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(
                Icons.person_outline_sharp,
                size: 140.0,
                color: Colors.blue,
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Peso (kg)",
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  final n = double.tryParse((value ?? '').replaceAll(',', '.'));
                  if (n == null || n <= 0) return "Insira seu peso!";
                  return null;
                },
              ),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Altura (cm)",
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 22.0),
                controller: heightController,
                validator: (value) {
                  final n = double.tryParse((value ?? '').replaceAll(',', '.'));
                  if (n == null || n <= 0) return "Insira sua altura!";
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: _calcular,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Calcular',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 22.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
