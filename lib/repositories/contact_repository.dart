import 'package:first_laboratory_exam/models/contact.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactRepository {
  final _supabase = Supabase.instance.client;
  final String _tblName = 'contacts';

  Future<PostgrestList> getContacts({
    String query = "",
  }) async {
    final userId = _supabase.auth.currentSession!.user.id;
    if (query.isNotEmpty) {
      return await _supabase
          .from(_tblName)
          .select()
          .or(
            'first_name.ilike.%$query%,middle_name.ilike.%$query%,last_name.ilike.%$query%',
          )
          .eq('user_id', userId);
    } else {
      return await _supabase.from(_tblName).select().eq('user_id', userId);
    }
  }

  Future<void> createContact({required Contact contact}) async {
    await _supabase.from(_tblName).insert(contact.toMap());
  }

  Future<void> updateContact({
    required Contact oldContact,
    required Contact newContact,
  }) async {
    await _supabase
        .from(_tblName)
        .update(
          newContact.toMap(),
        )
        .eq('id', oldContact.id!);
  }

  Future<void> deleteContact({
    required Contact contact,
  }) async {
    await _supabase.from(_tblName).delete().eq('id', contact.id!);
  }

  Future<int> getContactCountForLoggedUser() async {
    final userId = _supabase.auth.currentSession!.user.id;

    final res = await _supabase.from(_tblName).select().eq('user_id', userId);

    return res.length;
  }
}
