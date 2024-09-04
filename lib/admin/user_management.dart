import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Modèle de données pour un utilisateur
class UserModel {
  final String id;
  final String userName;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      userName: data['userName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }
}

// Fonction pour récupérer les utilisateurs avec le rôle "owner" depuis Firestore
Future<List<UserModel>> fetchOwners() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'owner')
      .get();

  return querySnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
}



class ManageOwnersPage extends StatefulWidget {
  @override
  _ManageOwnersPageState createState() => _ManageOwnersPageState();
}

class _ManageOwnersPageState extends State<ManageOwnersPage> {
  late Future<List<UserModel>> _owners;

  @override
  void initState() {
    super.initState();
    _owners = fetchOwners();
  }

  void _showUserDetails(UserModel owner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(owner.userName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${owner.email}'),
              Text('Role: ${owner.role}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Ferme le dialogue
                await _deleteUser(owner.id);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );

      setState(() {
        _owners = fetchOwners();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Manage Owners'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<UserModel>>(
          future: _owners,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No owners found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserModel owner = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        owner.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${owner.email}\nRole: ${owner.role}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      onTap: () => _showUserDetails(owner),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
