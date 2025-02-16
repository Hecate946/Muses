import 'package:flutter/material.dart';
import '../components/muses_app_bar.dart';

class LessonPlanScreen extends StatelessWidget {
  final String songId;
  final String title;

  const LessonPlanScreen({
    Key? key,
    required this.songId,
    required this.title,
  }) : super(key: key);

  Widget _buildMoonlightSonataLesson() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moonlight Sonata - First Movement',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'By Ludwig van Beethoven',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildSection('Introduction',
              'The first movement of Beethoven\'s "Moonlight" Sonata is one of the most famous pieces in classical piano repertoire. Written in 1801, it creates a dreamy, mysterious atmosphere through its flowing triplet accompaniment.'),
          _buildSection('Step 1: Understanding the Structure',
              '• Written in C# minor\n• Time signature: 4/4\n• Tempo: Adagio sostenuto (slow and sustained)\n• Three-voice texture: melody, triplet accompaniment, and bass line'),
          _buildSection('Step 2: Right Hand Technique',
              '• Practice the melody line separately\n• Focus on maintaining consistent finger pressure\n• Use minimal finger movement for a smooth legato\n• Pay attention to the subtle dynamic changes'),
          _buildSection('Step 3: Left Hand Technique',
              '• Master the rolling triplet figures\n• Keep wrist relaxed and flexible\n• Practice slowly to ensure even timing\n• Use finger substitution for smooth transitions'),
          _buildSection('Step 4: Pedaling',
              '• Use half-pedaling technique\n• Change pedal with each harmony change\n• Listen carefully for clarity vs. resonance\n• Avoid over-pedaling'),
          _buildSection('Practice Tips',
              '• Start at a very slow tempo\n• Practice hands separately until comfortable\n• Record yourself and listen critically\n• Focus on one section at a time'),
        ],
      ),
    );
  }

  Widget _buildLoseYourselfLesson() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lose Yourself - Piano Arrangement',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'By Eminem',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildSection('Introduction',
              'Eminem\'s "Lose Yourself" features a memorable piano riff that underlies the track\'s intense energy. This lesson will teach you how to play the main piano part and understand its role in hip-hop production.'),
          _buildSection('Step 1: The Main Riff',
              '• Key: D minor\n• Basic pattern: D - F - A - D (ascending)\n• Rhythm: Sixteenth notes\n• Focus on sharp, precise articulation'),
          _buildSection('Step 2: Left Hand Bass',
              '• Learn the bass line pattern\n• Practice with a metronome\n• Focus on timing and groove\n• Maintain steady rhythm'),
          _buildSection('Step 3: Adding Dynamics',
              '• Build intensity gradually\n• Use accent marks for emphasis\n• Incorporate slight tempo variations\n• Match the energy of the original'),
          _buildSection('Step 4: Performance Tips',
              '• Start slowly and build speed\n• Focus on rhythmic precision\n• Add personal interpretation\n• Practice with the original track'),
          _buildSection('Additional Notes',
              '• Record yourself playing\n• Practice with a drum beat\n• Experiment with different articulations\n• Study the original production'),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ...content.split('\n').map((line) {
            if (line.trim().startsWith('•')) {
              return Padding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        line.substring(1).trim(),
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  line,
                  style: TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              );
            }
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBachPreludeLesson() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prelude in C Major (BWV 846)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'By Johann Sebastian Bach',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildSection('Introduction',
              "This prelude opens Book I of Bach's Well-Tempered Clavier. Its elegant simplicity and repeating pattern make it an excellent piece for beginners while teaching fundamental piano techniques."),
          _buildSection('Step 1: Understanding the Pattern',
              "• Basic pattern: Broken chords in sixteenth notes\n• Each measure outlines one harmony\n• Right hand plays the arpeggiated pattern\n• Left hand plays single bass notes"),
          _buildSection('Step 2: Basic Technique',
              "• Keep your hand relaxed and curved\n• Use fingering: 1-2-3-5 for most patterns\n• Maintain even spacing between notes\n• Practice slowly at first to build muscle memory"),
          _buildSection('Step 3: Expression and Flow',
              "• Aim for a smooth, flowing sound\n• Keep dynamics consistent within patterns\n• Let the harmonies guide dynamic changes\n• Use minimal pedal - just enough to connect"),
          _buildSection('Step 4: Common Challenges',
              "• Maintaining steady rhythm\n• Achieving evenness in the pattern\n• Balancing melody and harmony\n• Smooth transitions between measures"),
          _buildSection('Practice Strategy',
              "• Start at 50% tempo with metronome\n• Practice hands separately first\n• Focus on 2-4 measures at a time\n• Record yourself to check evenness"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MusesAppBar(
        title: title,
        showLogo: true,
      ),
      backgroundColor: Color(0xFFF8F8F8),
      body: songId == 'moonlight_sonata'
          ? _buildMoonlightSonataLesson()
          : songId == 'bach_prelude'
              ? _buildBachPreludeLesson()
              : _buildLoseYourselfLesson(),
    );
  }
}
