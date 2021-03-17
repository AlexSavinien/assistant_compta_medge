import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signup/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldInputDecoration.copyWith(hintText: 'Email'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  decoration: kTextFieldInputDecoration.copyWith(hintText: 'Mot de passe'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    print('button pressed');
                    context.read(signUpViewModelProvider).signUp(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  },
                  child: Text('S\'inscrire'),
                ),
                GestureDetector(
                  onTap: () {
                    context.read(signUpViewModelProvider).navigateToSignIn();
                    print('Navigate to signin view');
                  },
                  child: Text(
                    'Vous avez déjà un compte ? Cliquez ici pour vous connecter !',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
