import 'package:flutter/material.dart';
import 'package:travelfile/services/user_service.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  bool _isLoading = true;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    // Garantir que a flag exista, e depois buscar o status
    await UserService.ensurePremiumFlagExists();
    final isPremium = await UserService.isUserPremium();

    setState(() {
      _isPremium = isPremium;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelFile Premium'),
        backgroundColor: Colors.amber,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.star, size: 80, color: Colors.amber),
                    const SizedBox(height: 20),
                    if (_isPremium)
                      const Text(
                        'Bem-vindo ao Premium!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else
                      const Text(
                        'Desbloqueie o potencial máximo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 10),
                    if (_isPremium)
                      const Text(
                        'Você tem acesso a todas as ferramentas exclusivas do aplicativo. Aproveite ao máximo sua experiência de viagem!',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      )
                    else
                      const Text(
                        'Assine o Premium e libere todas as ferramentas exclusivas do aplicativo.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 40),
                    if (_isPremium) ...[
                      const Card(
                        color: Colors.greenAccent,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Você já é um usuário Premium!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Você ainda não possui acesso Premium.\n\nVerifique com sua Agência de Viagens se você é um cliente Premium para liberar os recursos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Verificar Status Novamente'),
                        onPressed: _fetchData,
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
