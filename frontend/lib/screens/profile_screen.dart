import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _username = '';
  String _joinDate = '';
  int _songsLearned = 0;
  List<String> _instruments = [];
  List<Map<String, dynamic>> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey("user_id")) {
        print('❌ No user ID found.');
        setState(() => _isLoading = false);
        return;
      }

      final userId = prefs.getInt("user_id")!;

      final profileData = await _apiService.fetchUserProfile(userId);
      final historyData = await _apiService.fetchUserHistory(userId);

      setState(() {
        _username = profileData['username'] ?? 'User';
        _joinDate = profileData['join_date']?.toString() ?? 'January 2024';
        _songsLearned = (profileData['songs_learned'] ?? 0) as int;

        _instruments = (profileData['instruments'] as List<dynamic>?)
                ?.map((i) => i.toString())
                .toList() ??
            [];

        _recentActivity = historyData
            .take(5)
            .map((activity) => {
                  "track_id": activity["track_id"]?.toString() ?? "Unknown Track",
                  "action": activity["action"]?.toString() ?? "Unknown Action",
                  "timestamp": activity["timestamp"]?.toString() ?? "",
                })
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _handleLogout() async {
    await _apiService.logoutUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _handleDeleteAccount() async {
    await _apiService.deleteAccount();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person,
                                  size: 40, color: Colors.grey[500]),
                            ),
                            SizedBox(height: 12),
                            Text(
                              _username,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Joined $_joinDate',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildStatsSection(),
                      SizedBox(height: 20),
                      _buildActivitySection(),
                      SizedBox(height: 24),
                      _buildLogoutButton(),
                      SizedBox(height: 12),
                      _buildDeleteAccountButton(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: constraints.maxWidth > 400 ? 1.8 : 1.5,
          children: [
            _buildStatCard(context, 'Songs Learned', _songsLearned.toString(),
                Icons.music_note),
            _buildStatCard(
                context, 'Instruments', _instruments.length.toString(), Icons.piano),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 12),
        _buildActivityList(),
      ],
    );
  }

  Widget _buildActivityList() {
    if (_recentActivity.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No recent activity'),
        ),
      );
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _recentActivity.map((activity) {
          return Column(
            children: [
              _buildActivityItem(activity['action'], activity['timestamp'],
                  Icons.music_note),
              if (activity != _recentActivity.last) Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title, style: TextStyle(fontSize: 14)),
      subtitle: Text(time, style: TextStyle(fontSize: 12)),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: _handleLogout,
      icon: Icon(Icons.logout, color: Colors.red[700]),
      label: Text(
        'Logout',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.red[700],
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[50],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Account'),
              content: Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _handleDeleteAccount();
                    Navigator.pop(context);
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
      },
      icon: Icon(Icons.delete_forever, color: Colors.grey[700]),
      label: Text('Delete Account',
          style: TextStyle(fontSize: 14, color: Colors.grey[700])),
    );
  }
}
