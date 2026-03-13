import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              _buildPage(
                  color: Colors.deepPurple[50]!,
                  title: 'Welcome to Sanctuary',
                  subtitle: 'Personalize your yoga journey for mindfulness and strength.'),
              _buildPage(
                  color: Colors.indigo[50]!,
                  title: 'Select Your Level',
                  subtitle: 'Whether beginner or advanced, find flows that match your body.'),
              _buildPage(
                  color: Colors.teal[50]!,
                  title: 'Set Your Goals',
                  subtitle: 'Focus on flexibility, core strength, or finding peace of mind.'),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text('Skip')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: onLastPage && index == 2
                            ? Colors.deepPurple
                            : (!onLastPage && _controller.hasClients && (_controller.page?.round() == index || (_controller.page == null && index == 0)))
                                ? Colors.deepPurple
                                : Colors.grey,
                      ),
                    ),
                  ),
                ),
                onLastPage
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Done'))
                    : TextButton(
                        onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                        child: const Text('Next')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage(
      {required Color color, required String title, required String subtitle}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.self_improvement, size: 100, color: Colors.deepPurple[800]),
          const SizedBox(height: 40),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54)),
        ],
      ),
    );
  }
}
