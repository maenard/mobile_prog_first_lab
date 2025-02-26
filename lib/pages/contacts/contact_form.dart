import 'dart:io';

import 'package:first_laboratory_exam/components/avatar.dart';
import 'package:first_laboratory_exam/components/custom_circular_progress_indicator.dart';
import 'package:first_laboratory_exam/components/text_fields/outlined_text_field.dart';
import 'package:first_laboratory_exam/models/contact.dart';
import 'package:first_laboratory_exam/pages/home.dart';
import 'package:first_laboratory_exam/repositories/contact_repository.dart';
import 'package:first_laboratory_exam/services/auth_service.dart';
import 'package:first_laboratory_exam/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;
  const ContactForm({
    super.key,
    this.contact,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late TextEditingController _fnameController;
  late TextEditingController _mnameController;
  late TextEditingController _lnameController;
  late TextEditingController _emailController;
  late TextEditingController _contactNumController;
  final formKey = GlobalKey<FormState>();
  final ContactRepository contactRepository = ContactRepository();
  final AuthService authService = AuthService();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fnameController = TextEditingController();
    _mnameController = TextEditingController();
    _lnameController = TextEditingController();
    _emailController = TextEditingController();
    _contactNumController = TextEditingController();

    if (widget.contact != null) {
      _fnameController.text = widget.contact!.firstName;
      _mnameController.text = widget.contact!.middleName ?? '';
      _lnameController.text = widget.contact!.lastName;
      _emailController.text = widget.contact!.email;
      _contactNumController.text = widget.contact!.contactNum;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _contactNumController.dispose();
    _mnameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          if (widget.contact != null)
            IconButton(
              color: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('This action is irreversible.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final nav = Navigator.of(context);
                          nav.pop();
                        },
                        style: Styles.secondaryButton(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await contactRepository.deleteContact(
                            contact: widget.contact!,
                          );
                          final nav = Navigator.of(context);
                          nav.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                            (route) => false,
                          );
                        },
                        style: Styles.primaryButton(),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Avatar(
                  imgUrl: widget.contact?.imgUrl != null
                      ? _supabase.storage.from('images').getPublicUrl(
                            widget.contact!.imgUrl!,
                          )
                      : null,
                  onUpload: (img) {
                    setState(() {
                      _selectedImage = img;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                OutlinedTextField(
                  controller: _fnameController,
                  labelText: 'First Name',
                  validator: (value) {
                    return value!.isEmpty ? 'First name is required' : null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedTextField(
                  controller: _mnameController,
                  labelText: 'Middle Name (optional)',
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedTextField(
                  controller: _lnameController,
                  labelText: 'Last Name',
                  validator: (value) {
                    return value!.isEmpty ? 'Last name is required' : null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  validator: (value) {
                    return value!.isEmpty ? 'Email is required' : null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedTextField(
                  controller: _contactNumController,
                  labelText: 'Contact Number',
                  validator: (value) {
                    return value!.isEmpty ? 'Contact Number is required' : null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            _isLoading = true;
                          });

                          final firstName = _fnameController.text;
                          final middleName = _mnameController.text;
                          final lastName = _lnameController.text;
                          final email = _emailController.text;
                          final contactNum = _contactNumController.text;

                          String fileName = "";
                          String path = "";
                          // String publicUrl = "";

                          if (_selectedImage != null) {
                            fileName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            path = widget.contact?.imgUrl != null
                                ? widget.contact!.imgUrl!
                                : "contactAvatars/$fileName";

                            if (widget.contact?.imgUrl != null) {
                              await _supabase.storage.from('images').update(
                                    path,
                                    _selectedImage!,
                                  );
                            } else {
                              await _supabase.storage.from('images').upload(
                                    path,
                                    _selectedImage!,
                                  );
                            }

                            // publicUrl = _supabase.storage
                            //     .from('images')
                            //     .getPublicUrl(path);
                          }

                          if (widget.contact != null) {
                            await contactRepository.updateContact(
                              oldContact: widget.contact!,
                              newContact: Contact(
                                firstName: firstName,
                                middleName: middleName,
                                lastName: lastName,
                                email: email,
                                contactNum: contactNum,
                                imgUrl: path.isEmpty ? null : path,
                              ),
                            );
                          } else {
                            await contactRepository.createContact(
                              contact: Contact(
                                firstName: firstName,
                                middleName: middleName,
                                lastName: lastName,
                                email: email,
                                contactNum: contactNum,
                                imgUrl: path.isEmpty ? null : path,
                              ),
                            );
                          }

                          setState(() {
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                widget.contact != null
                                    ? 'Contact updated successfully'
                                    : 'Contact added successfully',
                              ),
                            ),
                          );

                          final nav = Navigator.of(context);
                          nav.pop();
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      }
                    },
                    style: Styles.primaryButton(),
                    child: _isLoading
                        ? const CustomCircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
