import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/usage_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    UsageService usageService = Provider.of<UsageService>(context);
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      authService.signInAnonymously();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Time Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          )
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: usageService.usageStream(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.data() as Map<String, dynamic>;
                int usageLimit = data['usageLimit'] ?? 0;
                int minutesUsed = data['minutesUsed'] ?? 0;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Usage Limit: $usageLimit minutes'),
                      Text('Minutes Used: $minutesUsed minutes'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => usageService.setUsageLimit(user.uid, usageLimit + 10),
                        child: Text('Increase Limit by 10 Minutes'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
