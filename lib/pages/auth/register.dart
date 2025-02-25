import 'package:email_validator/email_validator.dart';
import 'package:first_laboratory_exam/components/custom_circular_progress_indicator.dart';
import 'package:first_laboratory_exam/components/text_fields/outlined_text_field.dart';
import 'package:first_laboratory_exam/models/user_metadata.dart';
import 'package:first_laboratory_exam/pages/auth/login.dart';
import 'package:first_laboratory_exam/services/auth_service.dart';
import 'package:first_laboratory_exam/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool obscureTextPw = true;
  bool obscureTextCPw = true;

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                    height: 200,
                    width: double.infinity,
                    child: Image.asset('assets/images/register_asset.png'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Sign Up Now!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.deepPurple,
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
                    controller: nameController,
                    labelText: 'Name',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedTextField(
                    controller: emailController,
                    labelText: 'Email',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email.';
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
                    height: 20,
                  ),
                  OutlinedTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    showVisibilityIcon: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final pw = passwordController.text;

                      if (value!.isEmpty) {
                        return 'Please confirm your password.';
                      } else if (value != pw) {
                        return 'Confirm password should be equal to your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
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
                            final name = nameController.text;
                            final email = emailController.text;
                            final pw = passwordController.text;

                            final res =
                                await authService.signUpWithEmailAndPassword(
                              email: email,
                              password: pw,
                              userMetaData: UserMetadata(
                                name: name,
                              ),
                            );

                            final session = res.session;

                            if (session != null) {
                              Navigator.pop(context);
                            }
                          } on AuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.message),
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
                              'Sign up',
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
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var nav = Navigator.of(context);

                          if (nav.canPop()) {
                            nav.pop();
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          ' Login',
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
