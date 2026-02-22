import 'package:flutter/material.dart';
import 'onboarding_page_model.dart';

class OnboardingFlow extends StatefulWidget {
  final List<OnboardingPageModel> pages;

  final VoidCallback onDone;
  final VoidCallback? onSkip;
  final String skipText;
  final String nextText;
  final String doneText;

  const OnboardingFlow({
    super.key,
    required this.pages,
    required this.onDone,
    this.onSkip,
    this.skipText = 'Skip',
    this.nextText = 'Next',
    this.doneText = 'Start',
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late final PageController _pageController;
  int _index = 0;

  bool get _isLast => _index == widget.pages.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_isLast) {
      widget.onDone();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _goBack() {
    if (_index == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.pages;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), 
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onSkip ?? widget.onDone,
                    child: Text(
                      widget.skipText,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _OnboardingSlide(page: pages[i]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
              child: Row(
                children: [
                  _NavButton(
                    icon: Icons.arrow_back,
                    enabled: _index != 0,
                    onTap: _goBack,
                    filled: false,
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Center(
                      child: _Dots(
                        count: pages.length,
                        index: _index,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),
                  _NavButton(
                    icon: Icons.arrow_forward,
                    enabled: true,
                    onTap: _goNext,
                    filled: true,
                    tooltip: _isLast ? widget.doneText : widget.nextText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final OnboardingPageModel page;
  const _OnboardingSlide({required this.page});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Image.asset(
              page.imageAsset,
              width: page.imageWidth,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // bottom sheet card
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleWithHighlight(
                  title: page.title,
                  highlight: page.highlight,
                ),
                const SizedBox(height: 10),
                Text(
                  page.description,
                  style: const TextStyle(
                    color: Colors.black54,
                    height: 1.35,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 60), 
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleWithHighlight extends StatelessWidget {
  final String title;
  final String? highlight;
  const _TitleWithHighlight({required this.title, this.highlight});

  @override
  Widget build(BuildContext context) {
    if (highlight == null || highlight!.trim().isEmpty) {
      return Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      );
    }

    // لو title يحتوي highlight، نلوّن highlight بس
    final h = highlight!;
    final idx = title.indexOf(h);
    if (idx == -1) {
      return Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      );
    }

    final before = title.substring(0, idx);
    final after = title.substring(idx + h.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: h,
            style: const TextStyle(color: Color(0xFFC9A227)), 
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 10 : 7,
          height: active ? 10 : 7,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.black26,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool filled;
  final String? tooltip;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.filled,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? Colors.black : Colors.white;
    final fg = filled ? Colors.white : Colors.black;

    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Opacity(
          opacity: enabled ? 1 : 0.35,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: filled ? null : Border.all(color: Colors.black12),
            ),
            child: Icon(icon, color: fg),
          ),
        ),
      ),
    );
  }
}
