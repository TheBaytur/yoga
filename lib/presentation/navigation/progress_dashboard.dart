import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:confetti/confetti.dart';

class ProgressDashboard extends StatefulWidget {
  const ProgressDashboard({super.key});

  @override
  State<ProgressDashboard> createState() => _ProgressDashboardState();
}

class _ProgressDashboardState extends State<ProgressDashboard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('Your Progress', style: TextStyle(color: Color(0xFF4A5D53))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A5D53)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStreakCard(),
                const SizedBox(height: 24),
                const Text(
                  'Weekly Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6B8A7A)),
                ),
                const SizedBox(height: 16),
                _buildActivityChart(),
                const SizedBox(height: 32),
                _buildMilestoneList(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [Color(0xFF6B8A7A), Color(0xFFA67B5B), Color(0xFFC49A94)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6B8A7A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('7 Day Streak!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('You are in the top 5% this week.', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _confettiController.play(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Celebrate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 60,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 45),
            _makeGroupData(1, 30),
            _makeGroupData(2, 55),
            _makeGroupData(3, 20),
            _makeGroupData(4, 40),
            _makeGroupData(5, 10),
            _makeGroupData(6, 0),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF6B8A7A),
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildMilestoneList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Achieved Milestones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6B8A7A))),
        const SizedBox(height: 16),
        _buildMilestoneTile('Early Bird', 'First session before 7 AM', Icons.wb_sunny),
        _buildMilestoneTile('Pose Master', 'Held Warrior II for 2 minutes', Icons.accessibility_new),
        _buildMilestoneTile('Zen Master', 'Completed 10 meditation sessions', Icons.self_improvement),
      ],
    );
  }

  Widget _buildMilestoneTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE5D5C5),
        child: Icon(icon, color: const Color(0xFFA67B5B)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.check_circle, color: Color(0xFF6B8A7A)),
    );
  }
}
