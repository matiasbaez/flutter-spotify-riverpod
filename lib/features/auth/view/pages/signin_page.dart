import 'package:client/core/utils.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/core.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch only the isLoading for this page
    final isLoading = ref.watch(
      authViewModelProvider.select(
        (value) => value?.isLoading == true,
      ),
    );

    ref.listen(authViewModelProvider, (prev, next) {
      next?.when(
        data: (data) {
          showSnackBar(
            context,
            'Signed in successfully!',
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<HomePage>(
              builder: (context) => const HomePage(),
            ),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(
            context,
            error.toString(),
          );
        },
        loading: () {
          showSnackBar(
            context,
            'Signing in...',
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : SigninContent(
              formKey: formKey,
              emailController: emailController,
              passwordController: passwordController,
              ref: ref,
            ),
    );
  }
}

class SigninContent extends StatelessWidget {
  const SigninContent({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.ref,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Signin',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomField(
                controller: emailController,
                hintText: 'Email',
              ),
              const SizedBox(height: 15),
              CustomField(
                controller: passwordController,
                hintText: 'Password',
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              AuthGradientButton(
                buttonText: 'Sign In',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await ref.read(authViewModelProvider.notifier).signin(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<SignupPage>(
                    builder: (context) => const SignupPage(),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Pallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
