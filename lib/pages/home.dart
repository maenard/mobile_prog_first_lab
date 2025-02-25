import 'dart:async';

import 'package:first_laboratory_exam/models/contact.dart';
import 'package:first_laboratory_exam/models/user_metadata.dart';
import 'package:first_laboratory_exam/pages/contacts/contact_form.dart';
import 'package:first_laboratory_exam/repositories/contact_repository.dart';
import 'package:first_laboratory_exam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController searchController;
  final AuthService authService = AuthService();
  final _supabase = Supabase.instance.client;
  final ContactRepository contactRepository = ContactRepository();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void _onSearchChange(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _query = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _supabase.auth.currentSession!.user;
    final UserMetadata userMetadata = UserMetadata.fromMap(user.userMetadata!);

    var streamBuilder = RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: StreamBuilder(
        stream: _supabase
            .from('contacts')
            .stream(primaryKey: ['id'])
            .eq(
              'user_id',
              user.id,
            )
            .order(
              'last_name',
              ascending: true,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(),
                    title: Text('Item number $index as title'),
                    subtitle: const Text('Subtitle here'),
                    trailing: const Icon(Icons.ac_unit),
                  );
                },
              ),
            );
          }

          final List<Contact> contacts =
              snapshot.data!.map((data) => Contact.fromMap(data)).toList();

          if (contacts.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          return _buildContactList(contacts);
        },
      ),
    );

    var futureBuilder = RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
        future: contactRepository.getContacts(query: _query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(),
                    title: Text('Item number $index as title'),
                    subtitle: const Text('Subtitle here'),
                    trailing: const Icon(Icons.ac_unit),
                  );
                },
              ),
            );
          }

          final List<Contact> contacts =
              snapshot.data!.map((data) => Contact.fromMap(data)).toList();

          if (contacts.isEmpty) {
            return Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              width: double.infinity,
              color: Colors.deepPurple[50],
              child: const Text(
                textAlign: TextAlign.center,
                'No data found.',
              ),
            );
          }

          return _buildContactList(contacts);
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextFormField(
          style: const TextStyle(
            fontSize: 12,
          ),
          controller: searchController,
          onChanged: _onSearchChange,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: Colors.grey[300],
            hintText: 'Search...',
            hintStyle: const TextStyle(fontWeight: FontWeight.bold),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8, right: 4),
              child: Icon(Icons.search, size: 16),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          ),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await authService.signOut();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final nav = Navigator.of(context);
          nav.push(
            MaterialPageRoute(
              builder: (context) => const ContactForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: contactRepository.getContactCountForLoggedUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Skeletonizer(
                  child: _buildProfileTile(
                    userMetadata: userMetadata,
                    user: user,
                  ),
                );
              }
              final count = snapshot.data.toString();

              return _buildProfileTile(
                userMetadata: userMetadata,
                user: user,
                contactCount: count,
              );
            },
          ),
          Expanded(
            child: _query.isEmpty
                ? streamBuilder
                : futureBuilder, // streamBuilder,
          ),
        ],
      ),
    );
  }

  ListView _buildContactList(List<Contact> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (
        context,
        index,
      ) {
        final Contact contact = contacts[index];

        final String currentLetter = contact.lastName[0].toUpperCase();

        final String prevLetter =
            index == 0 ? '' : contacts[index - 1].lastName[0].toUpperCase();

        bool separate = currentLetter != prevLetter;

        final String fname = contact.firstName;
        final String mname = contact.middleName!.isNotEmpty
            ? contact.middleName![0].toUpperCase()
            : '';
        final String lname = contact.lastName;
        return Column(
          children: [
            if (separate)
              Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                ),
                child: Text(
                  currentLetter,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ListTile(
              dense: true,
              onTap: () {
                final nav = Navigator.of(context);

                nav.push(
                  MaterialPageRoute(
                    builder: (context) => ContactForm(
                      contact: contact,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                child: Text(
                  contact.middleName!.isNotEmpty
                      ? contact.lastName[0].toUpperCase()
                      : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                "$lname, $fname $mname.",
              ),
            ),
          ],
        );
      },
    );
  }

  ListTile _buildProfileTile({
    required UserMetadata userMetadata,
    required User user,
    String contactCount = '0',
  }) {
    return ListTile(
      dense: true,
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        userMetadata.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.email_outlined,
            size: 15,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: Text(
              user.email!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const Icon(
            Icons.contact_emergency_outlined,
            size: 15,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            '$contactCount contacts',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 30,
      ),
    );
  }
}
