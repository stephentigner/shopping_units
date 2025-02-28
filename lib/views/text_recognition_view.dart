import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shopping_units/utils/application_strings.dart';
import 'package:shopping_units/utils/unit_recognition.dart';

class TextRecognitionView extends StatefulWidget {
  final File imageFile;
  final RecognitionResult recognitionResult;
  final Function(UnitMeasurement) onMeasurementSelected;
  final VoidCallback onRetry;
  final VoidCallback onNewPhoto;

  const TextRecognitionView({
    Key? key,
    required this.imageFile,
    required this.recognitionResult,
    required this.onMeasurementSelected,
    required this.onRetry,
    required this.onNewPhoto,
  }) : super(key: key);

  @override
  State<TextRecognitionView> createState() => _TextRecognitionViewState();
}

class _TextRecognitionViewState extends State<TextRecognitionView> {
  TextBlock? _selectedBlock;
  final GlobalKey _imageKey = GlobalKey();
  Size? _imageSize;
  UnitMeasurement? _selectedMeasurement;

  @override
  void initState() {
    super.initState();
    // If we have a measurement, pre-select its block and set it as selected measurement
    if (widget.recognitionResult.measurement?.textBlock != null) {
      _selectedBlock = widget.recognitionResult.measurement!.textBlock;
      _selectedMeasurement = widget.recognitionResult.measurement;
    }

    // Load image to get its size
    Image image = Image.file(widget.imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          _imageSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        });
      }),
    );
  }

  void _updateSelectedBlock(TextBlock block) {
    setState(() {
      _selectedBlock = block;
      // Try to find a measurement in this block
      _selectedMeasurement = UnitRecognition.extractMeasurement(block.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ApplicationStrings.selectMeasurementTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // The image
                Image.file(
                  widget.imageFile,
                  key: _imageKey,
                  fit: BoxFit.contain,
                ),

                // Custom overlay with holes for text
                if (_imageSize != null)
                  CustomPaint(
                    painter: TextRegionPainter(
                      textBlocks: widget.recognitionResult.allBlocks,
                      selectedBlock: _selectedBlock,
                      originalImageSize: _imageSize!,
                      imageKey: _imageKey,
                    ),
                    child: Container(),
                  ),

                // Clickable regions
                if (_imageSize != null)
                  ...widget.recognitionResult.allBlocks.map((block) {
                    final rect = _getScaledRect(block.boundingBox, _imageSize!);
                    return Positioned(
                      left: rect.left,
                      top: rect.top,
                      width: rect.width,
                      height: rect.height,
                      child: GestureDetector(
                        onTap: () {
                          _updateSelectedBlock(block);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: block == _selectedBlock
                                ? Border.all(color: Colors.green, width: 2)
                                : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
          // Measurement preview
          if (_selectedBlock != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedMeasurement != null)
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ApplicationStrings.detectedMeasurementLabel,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            '${_selectedMeasurement!.value} ${_selectedMeasurement!.unit.abbreviation}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        ApplicationStrings.noMeasurementsInSelectionMessage,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                TextButton(
                  onPressed: widget.onRetry,
                  child: const Text(ApplicationStrings.retryButton),
                ),
                TextButton(
                  onPressed: widget.onNewPhoto,
                  child: const Text(ApplicationStrings.newPhotoButton),
                ),
                if (_selectedBlock != null && _selectedMeasurement != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onMeasurementSelected(_selectedMeasurement!);
                    },
                    child:
                        const Text(ApplicationStrings.acceptMeasurementButton),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Rect _getScaledRect(Rect original, Size imageSize) {
    if (_imageKey.currentContext == null) return original;

    final RenderBox renderBox =
        _imageKey.currentContext!.findRenderObject() as RenderBox;
    final Size widgetSize = renderBox.size;

    // Calculate scaling factors
    double scale = widgetSize.width / imageSize.width;
    if (imageSize.height * scale > widgetSize.height) {
      scale = widgetSize.height / imageSize.height;
    }

    // Calculate offset to center the image
    double dx = (widgetSize.width - imageSize.width * scale) / 2;
    double dy = (widgetSize.height - imageSize.height * scale) / 2;

    return Rect.fromLTWH(
      original.left * scale + dx,
      original.top * scale + dy,
      original.width * scale,
      original.height * scale,
    );
  }
}

class TextRegionPainter extends CustomPainter {
  final List<TextBlock> textBlocks;
  final TextBlock? selectedBlock;
  final Size originalImageSize;
  final GlobalKey imageKey;

  TextRegionPainter({
    required this.textBlocks,
    required this.selectedBlock,
    required this.originalImageSize,
    required this.imageKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageKey.currentContext == null) return;
    final RenderBox renderBox =
        imageKey.currentContext!.findRenderObject() as RenderBox;
    final Size widgetSize = renderBox.size;

    final paint = Paint()
      ..color = Colors.black.withAlpha(128)
      ..style = PaintingStyle.fill;

    // Create a path for the entire canvas
    final backgroundPath = Path()..addRect(Offset.zero & widgetSize);

    // Create a path for all text blocks
    final holesPath = Path();

    // Calculate scaling factors
    double scale = widgetSize.width / originalImageSize.width;
    if (originalImageSize.height * scale > widgetSize.height) {
      scale = widgetSize.height / originalImageSize.height;
    }

    // Calculate offset to center the image
    double dx = (widgetSize.width - originalImageSize.width * scale) / 2;
    double dy = (widgetSize.height - originalImageSize.height * scale) / 2;

    for (var block in textBlocks) {
      final Rect scaledRect = Rect.fromLTWH(
        block.boundingBox.left * scale + dx,
        block.boundingBox.top * scale + dy,
        block.boundingBox.width * scale,
        block.boundingBox.height * scale,
      );
      holesPath.addRect(scaledRect);
    }

    // Cut out the holes from the background
    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holesPath,
    );

    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(TextRegionPainter oldDelegate) {
    return oldDelegate.selectedBlock != selectedBlock ||
        oldDelegate.textBlocks != textBlocks;
  }
}
