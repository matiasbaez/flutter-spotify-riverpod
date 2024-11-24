import 'package:client/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/core/core.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Account created successfully! Please sign in.',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<SigninPage>(
              builder: (context) => const SigninPage(),
            ),
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
            'Creating account...',
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : SignupContent(
              formKey: formKey,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              ref: ref,
            ),
    );
  }
}

class SignupContent extends StatelessWidget {
  const SignupContent({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.ref,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
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
                'Signup',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomField(
                controller: nameController,
                hintText: 'Name',
              ),
              const SizedBox(height: 15),
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
                buttonText: 'Sign Up',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await ref.read(authViewModelProvider.notifier).signup(
                          name: nameController.text,
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
                  MaterialPageRoute<SigninPage>(
                    builder: (context) => const SigninPage(),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: const [
                      TextSpan(
                        text: 'Sign In',
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
