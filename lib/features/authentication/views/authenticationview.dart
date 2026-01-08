import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/features/authentication/viewmodels/authviewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;
  String? error;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final auth = ref.read(authViewModelProvider);
      final email = emailController.text.trim();
      final pass = passController.text;

      if (isLogin) {
        await auth.signIn(email, pass);
      } else {
        await auth.signUp(email, pass);
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Connexion' : 'Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction
                  .next, //permet de mettre un bouton next field sur le clavier
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: passController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 16),
            if (error != null) ...[
              Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: Text(
                  isLoading
                      ? '...'
                      : (isLogin ? 'Se connecter' : 'Créer un compte'),
                ),
              ),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? "Pas de compte ? S'inscrire"
                    : "Déjà un compte ? Se connecter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
