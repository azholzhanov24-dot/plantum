import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import '../models/greenhouse_state.dart';

class GreenhouseWebView extends StatefulWidget {
  const GreenhouseWebView({super.key});

  @override
  State<GreenhouseWebView> createState() => _GreenhouseWebViewState();
}

class _GreenhouseWebViewState extends State<GreenhouseWebView> {
  late final html.IFrameElement _iframeElement;
  final String _viewType = 'greenhouse-html-view';

  @override
  void initState() {
    super.initState();

    _iframeElement = html.IFrameElement()
      ..src = 'assets/images/greenhouse.html'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = GreenhouseScope.of(context);
      
      controller.setIframeSender((action, value) {
        // Передаем value как реальный булев тип (без кавычек), чтобы JSON был валидным: {"action": "...", "value": false}
        final message = '{"action": "$action", "value": $value}';
        
        if (_iframeElement.contentWindow != null) {
          _iframeElement.contentWindow?.postMessage(message, '*');
          print("📤 Успешно отправлено в 3D-сцену: $message");
        } else {
          print("⚠️ Ошибка: contentWindow у iframe недоступно");
        }
      });
    });

    return HtmlElementView(viewType: _viewType);
  }
}