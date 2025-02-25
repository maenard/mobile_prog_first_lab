import 'package:email_validator/email_validator.dart';
import 'package:first_laboratory_exam/components/custom_circular_progress_indicator.dart';
import 'package:first_laboratory_exam/components/text_fields/outlined_text_field.dart';
import 'package:first_laboratory_exam/pages/auth/forgot_password.dart';
import 'package:first_laboratory_exam/pages/auth/register.dart';
import 'package:first_laboratory_exam/services/auth_service.dart';
import 'package:first_laboratory_exam/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();

  final formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.text = '';
    passwordController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/login_asset.png',
                    ),
                  ),
                  const Text(
                    "First Laboratory Exam",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Text(
                    'Keep you data safe',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OutlinedTextField(
                    controller: emailController,
                    labelText: 'Email',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    showVisibilityIcon: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 8) {
                        return 'Password must be greater than 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgotPassword(),
                      ),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final email = emailController.text;
                            final password = passwordController.text;

                            await authService.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                          } on AuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.message,
                                ),
                              ),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: Styles.primaryButton(),
                      child: isLoading
                          ? const CustomCircularProgressIndicator()
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: const Text(
                          ' Sign up',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Or connect with',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.tiktok),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.account_circle_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
