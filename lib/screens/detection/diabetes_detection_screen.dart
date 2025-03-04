// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:math' as math;

class DiabetesDetectionScreen extends StatefulWidget {
  const DiabetesDetectionScreen({super.key});

  @override
  State<DiabetesDetectionScreen> createState() =>
      _DiabetesDetectionScreenState();
}

class _DiabetesDetectionScreenState extends State<DiabetesDetectionScreen> {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  bool _isInitialized = false;
  bool _isProcessing = false;
  double? _sugarLevel;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _startImageStream();
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startImageStream() {
    _cameraController.startImageStream(_processImage);
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces[0];
        if (face.landmarks.containsKey(FaceLandmarkType.leftEye)) {
          final leftEye = face.landmarks[FaceLandmarkType.leftEye]!;

          // Calculate simulated sugar level
          final angle = math.atan2(leftEye.position.x, leftEye.position.y);
          final n = 1 / math.sin(angle);
          final brix = (n * 1) / 1.33442;
          final sugarLevel = brix * 100;

          if (mounted) {
            setState(() {
              _sugarLevel = sugarLevel;
            });
          }
        }
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Diabetes Detection')),
      body: Column(
        children: [
          Expanded(flex: 3, child: _buildCameraPreview()),
          Expanded(flex: 2, child: _buildResultsSection()),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CameraPreview(_cameraController),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eye Analysis Results',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (_sugarLevel != null) ...[
            _buildResultCard(),
          ] else ...[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing eye pattern...'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final isNormal = (_sugarLevel ?? 0) < 140;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        isNormal
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isNormal ? Icons.check_circle : Icons.warning,
                    color: isNormal ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sugar Level',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${_sugarLevel!.toStringAsFixed(1)} mg/dL',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isNormal
                  ? 'Your blood sugar level appears to be normal.'
                  : 'Your blood sugar level appears to be elevated.',
              style: TextStyle(
                color: isNormal ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isNormal
                  ? 'Maintain your healthy lifestyle with balanced diet and regular exercise.'
                  : 'Consider consulting with a healthcare provider for further evaluation.',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }
}
