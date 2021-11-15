import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class CaptchaSliderWidget extends StatefulWidget {
  final CaptchaChallenge captchaChallenge;
  final Image backgroundImage;
  final Image foregroundImage;
  final Function(String attempt) onValidate;

  const CaptchaSliderWidget({
    Key? key,
    required this.backgroundImage,
    required this.foregroundImage,
    required this.onValidate,
    required this.captchaChallenge,
  }) : super(key: key);

  @override
  _CaptchaSliderWidgetState createState() => _CaptchaSliderWidgetState();
}

class _CaptchaSliderWidgetState extends State<CaptchaSliderWidget> {
  TextEditingController _controller = TextEditingController();
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: Color.fromARGB(255, 238, 238, 238),
            )),
            Positioned(
              left: _sliderValue * 200 - 50,
              child: Container(
                width: widget.captchaChallenge.backgroundImageWidth.toDouble(),
                child: widget.backgroundImage,
              ),
            ),
            Container(
              width: widget.captchaChallenge.foregroundImageWidth.toDouble(),
              height: widget.captchaChallenge.foregroundImageHeight.toDouble(),
              child: widget.foregroundImage,
            ),
          ],
        ),
        Slider(
          value: _sliderValue,
          onChanged: (newValue) {
            setState(() {
              _sliderValue = newValue;
            });
          },
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: type_captcha_here.tr(),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => widget.onValidate(
                _controller.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
