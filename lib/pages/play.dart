import 'package:flutter/material.dart';
import 'solo_play.dart';  // Import your new pages
// import 'pvp_options_page.dart';
// import 'daily_challenges_page.dart';
// import 'learning_training_page.dart';
// import 'events_page.dart';
// import 'leaderboard_page.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF776B5D),
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Play Offline Section
            _buildClickableSection(
              context,
              title: 'Solo Play',
              description: 'Solve cryptarithm puzzles by difficulty levels.',
              page: const SoloPlayPage(),
            ),
            const SizedBox(height: 16),

            // PvP Options Section
            // _buildClickableSection(
            //   context,
            //   title: 'PvP Options',
            //   description: 'Includes Ranked and Classic modes.',
            //   page: const PvpOptionsPage(),
            // ),
            const SizedBox(height: 16),

            // // Daily Challenges Section
            // _buildClickableSection(
            //   context,
            //   title: 'Daily Challenges',
            //   description: 'Complete daily challenges to earn rewards.',
            //   page: const DailyChallengesPage(),
            // ),
            const SizedBox(height: 16),

            // Learning/Training Section
            // _buildClickableSection(
            //   context,
            //   title: 'Learning/Training',
            //   description: 'Improve your skills with learning resources.',
            //   page: const LearningTrainingPage(),
            // ),
            const SizedBox(height: 16),

            // Events Section
            // _buildClickableSection(
            //   context,
            //   title: 'Events',
            //   description: 'Check out any upcoming events.',
            //   page: const EventsPage(),
            // ),
            const SizedBox(height: 24),

            // Leaderboard Section
            // _buildClickableSection(
            //   context,
            //   title: 'Leaderboard',
            //   description: 'Top scores and rankings will be displayed here.',
            //   page: const LeaderboardPage(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableSection(
      BuildContext context, {
        required String title,
        required String description,
        required Widget page,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
