import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../common_widgets/primary_button.dart';
import 'location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboard1.png',
      'title': 'Sync with Nature’s Rhythm',
      'subtitle':
          'Experience a peaceful transition into the evening with an alarm that aligns with the sunset.*\nYour perfect reminder, always 15 minutes before sundown',
    },
    {
      'image': 'assets/images/onboard2.png',
      'title': 'Effortless & Automatic',
      'subtitle':
          'No need to set alarms manually. Wakey calculates the sunset time for your location and alerts you on time.',
    },
    {
      'image': 'assets/images/onboard3.png',
      'title': 'Relax & Unwind',
      'subtitle': 'Hope to take the courage to pursue your dreams.',
    },
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LocationScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              final item = onboardingData[index];
              return Column(
                children: [
                  // Skip button (manual padding instead of SafeArea)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48, right: 20),
                      child: TextButton(
                        onPressed: _skip,
                        child: const Text(
                          "Skip",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  // Top image (full bleed)
                  ClipRRect(
  borderRadius: const BorderRadius.vertical(
    bottom: Radius.circular(40),
  ),
  child: SizedBox(
    height: MediaQuery.of(context).size.height * 0.55, // Fill 55% of the screen
    width: double.infinity,
    child: Image.asset(
      item['image']!,
      fit: BoxFit.cover,
    ),
  ),
),


                  // Bottom text + button area
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title, subtitle, and dots
                          Column(
                            children: [
                              Text(
                                item['title']!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.title.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item['subtitle']!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.subtitle.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  onboardingData.length,
                                  (dotIndex) => AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    height: 8,
                                    width:
                                        _currentIndex == dotIndex ? 20 : 8,
                                    decoration: BoxDecoration(
                                      color: _currentIndex == dotIndex
                                          ? Colors.white
                                          : Colors.white38,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Fixed position button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: PrimaryButton(
                              text: _currentIndex ==
                                      onboardingData.length - 1
                                  ? "Get Started"
                                  : "Next",
                              onPressed: _nextPage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
