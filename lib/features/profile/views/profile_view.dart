import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/features/authentication/viewmodels/authviewmodel.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailChanged = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authViewModelProvider).currentUser;
    if (user?.email != null) {
      _emailController.text = user!.email!;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 246, 237, 240),
      child: Column(
        children: [
          SizedBox(height: 80),
          CircleAvatar(
            radius: 60,
            backgroundImage: const AssetImage('assets/images/profile.png'),
            //backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: const Text(
                    "Pour modifier ton adresse email, renseigne ton nouvel email ci-dessous.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction
                      .next, //permet de mettre un bouton next field sur le clavier
                  autofillHints: const [
                    AutofillHints.email,
                  ], //propose un remplissage automatique avec AppeKeyChain ou Android
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'ex: nom@domaine.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(15))),
                  ),
                  onChanged: (value) {
                    if (!_initialized) return;
                    setState(() {
                      _emailChanged = true;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: const Text(
                    "Pour valider cette modification, saisis ton mot de passe actuel.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(15))),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _emailChanged
                        ? () async {
                            final newEmail = _emailController.text.trim();
                            final currentEmail = ref
                                .read(authViewModelProvider)
                                .currentUser
                                ?.email;
                            final password = _passwordController.text;

                            if (newEmail.isEmpty || currentEmail == null || newEmail == currentEmail) {
                              return;
                            }
                            try {
                              // 1️⃣ Re-auth
                              await ref
                                  .read(authViewModelProvider)
                                  .reauthenticateWithPassword(
                                    email: currentEmail,
                                    password: password,
                                  );

                              // 2️⃣ Verify before update email
                              await ref
                                  .read(authViewModelProvider)
                                  .updateEmail(newEmail);

                              setState(() => _emailChanged = false);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Un email de confirmation a été envoyé. '
                                      'Valide-le pour finaliser le changement.',
                                    ),
                                  ),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              final msg = switch (e.code) {
                                'requires-recent-login' =>
                                  "Reconnecte-toi pour modifier l'email.",
                                'invalid-email' => "Email invalide.",
                                'email-already-in-use' =>
                                  "Cet email est déjà utilisé.",
                                'wrong-password' => "Mot de passe incorrect.",
                                _ => e.message ?? 'Erreur inconnue',
                              };

                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(msg)));
                              }
                            }
                          }
                        : null,
                    child: const Text('Enregistrer le nouvel email'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
