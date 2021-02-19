import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signin/sigin_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class SignInView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('SignInView');
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    kTextFieldInputDecoration.copyWith(hintText: 'Email'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: kTextFieldInputDecoration.copyWith(
                    hintText: 'Mot de passe'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  print('button pressed');
                  context.read(signInViewModelProvider).signIn(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                },
                child: Text('Se connecter'),
              ),
              GestureDetector(
                onTap: () {
                  context.read(signInViewModelProvider).navigateToSignUp();
                  print('Navigate to signin view');
                },
                child: Text(
                  'Vous n\'avez pas de compte ? Cliquez ici pour vous inscrire !',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
