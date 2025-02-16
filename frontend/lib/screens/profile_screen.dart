import 'package:flutter/material.dart';
 
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
 
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
 
class _ProfileScreenState extends State<ProfileScreen> {
  // Sample data for demonstration
  final List<Map<String, String>> _likedSongs = [
    {'title': 'Song 1', 'genre': 'Genre'},
    {'title': 'Song 2', 'genre': 'Genre'},
    {'title': 'Song 3', 'genre': 'Genre'},
    {'title': 'Song 4', 'genre': 'Genre'},
  ];
 
  final List<String> _instruments = ['Instrument 1', 'Instrument 2', 'Instrument 3'];
 
  final List<Map<String, String>> _yourSongs = [
    {'title': 'Song 1', 'genre': 'Genre'},
    {'title': 'Song 2', 'genre': 'Genre'},
    {'title': 'Song 3', 'genre': 'Genre'},
  ];
 
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
        child: SingleChildScrollView(
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
                        'John Doe',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Joined January 2024',
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
                          '12',
                          Icons.music_note,
                        ),
                        _buildStatCard(
                          context,
                          'Practice Hours',
                          '24',
                          Icons.timer,
                        ),
                        _buildStatCard(
                          context,
                          'Achievements',
                          '5',
                          Icons.star,
                        ),
                        _buildStatCard(
                          context,
                          'Instruments',
                          '2',
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
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActivityItem(
            'Started learning Moonlight Sonata',
            '2 hours ago',
            Icons.music_note,
          ),
          Divider(height: 1),
          _buildActivityItem(
            'Completed daily practice goal',
            '1 day ago',
            Icons.check_circle,
          ),
          Divider(height: 1),
          _buildActivityItem(
            'Added new instrument: Piano',
            '3 days ago',
            Icons.piano,
          ),
        ],
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