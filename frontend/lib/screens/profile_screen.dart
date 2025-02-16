import 'package:flutter/material.dart';
import '../services/api_service.dart';
 
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
      // TODO: Replace with actual user ID from auth system
      const userId = 1;

      // Fetch user profile data
      final profileData = await _apiService.fetchUserProfile(userId);
      final historyData = await _apiService.fetchUserHistory(userId);

      setState(() {
        _username = profileData['username'] ?? 'User';
        _joinDate = profileData['join_date'] ?? 'January 2024';
        _songsLearned = profileData['songs_learned'] ?? 0;
        _instruments = List<String>.from(profileData['instruments'] ?? []);
        _recentActivity = historyData.take(5).toList(); // Show only last 5 activities
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
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
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, size: 40, color: Colors.grey[500]),
                      ),
                      SizedBox(height: 12),
                      Text(
                        _username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Joined $_joinDate',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
 
                // Statistics Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: constraints.maxWidth > 400 ? 1.8 : 1.5,
                      children: [
                        _buildStatCard(
                          context,
                          'Songs Learned',
                          _songsLearned.toString(),
                          Icons.music_note,
                        ),
                        _buildStatCard(
                          context,
                          'Instruments',
                          _instruments.length.toString(),
                          Icons.piano,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
 
                // Recent Activity
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                _buildActivityList(),
              ],
            ),
          ),
        ),
      ),
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
 
  Widget _buildActivityList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

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
          IconData icon;
          switch (activity['type']) {
            case 'song_started':
              icon = Icons.music_note;
              break;
            case 'instrument_added':
              icon = Icons.piano;
              break;
            default:
              icon = Icons.check_circle;
          }

          return Column(
            children: [
              _buildActivityItem(
                activity['description'],
                activity['time_ago'],
                icon,
              ),
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
      title: Text(
        title,
        style: TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        time,
        style: TextStyle(fontSize: 12),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}