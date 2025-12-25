import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const PlantDiseaseApp());
}

class PlantDiseaseApp extends StatelessWidget {
  const PlantDiseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تشخیص بیماری گیاهان',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  String _result = '';
  bool _isAnalyzing = false;
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();

  // لیست کلاس‌های بیماری‌ها (باید با مدل خودت تطبیق بدی)
  final List<String> _labels = [
    'سالم',
    'لکه برگی',
    'زنگ زدگی',
    'پژمردگی',
    'بیماری قارچی',
    // لیبل‌های دیگر رو اضافه کن
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/plant_disease_model_float16.tflite',
      );
      print('✅ مدل با موفقیت بارگذاری شد');
    } catch (e) {
      print('❌ خطا در بارگذاری مدل: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در بارگذاری مدل: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _result = '';
        });
      }
    } catch (e) {
      _showError('خطا در باز کردن دوربین: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _result = '';
        });
      }
    } catch (e) {
      _showError('خطا در باز کردن گالری: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null || _interpreter == null) {
      _showError('لطفاً ابتدا یک تصویر انتخاب کنید');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = '';
    });

    try {
      // خواندن و پردازش تصویر
      final imageBytes = await _selectedImage!.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('نمی‌توان تصویر را پردازش کرد');
      }

      // تغییر اندازه تصویر به سایز ورودی مدل (معمولاً 224x224)
      final resizedImage = img.copyResize(image, width: 224, height: 224);

      // تبدیل به فرمت ورودی مدل
      var input = _imageToByteListFloat32(resizedImage, 224);

      // آماده‌سازی خروجی
      var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

      // اجرای مدل
      _interpreter!.run(input, output);

      // پیدا کردن بیشترین احتمال
      List<double> probabilities = output[0];
      int maxIndex = 0;
      double maxProb = probabilities[0];

      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      // نمایش نتیجه
      String labelName = maxIndex < _labels.length 
          ? _labels[maxIndex] 
          : 'کلاس $maxIndex';
      
      setState(() {
        _isAnalyzing = false;
        _result = '''
🌱 نتیجه تشخیص:

📊 بیماری شناسایی شده: $labelName

📈 میزان اطمینان: ${(maxProb * 100).toStringAsFixed(1)}%

${maxProb > 0.7 ? '✅ تشخیص با اطمینان بالا' : '⚠️ لطفاً تصویر واضح‌تری ارسال کنید'}

${_getRecommendation(labelName)}
        ''';
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      _showError('خطا در تحلیل تصویر: $e');
    }
  }

  List<List<List<List<double>>>> _imageToByteListFloat32(
    img.Image image, 
    int inputSize,
  ) {
    var convertedBytes = List.generate(
      1,
      (index) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = image.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );
    return convertedBytes;
  }

  String _getRecommendation(String disease) {
    switch (disease) {
      case 'سالم':
        return '💚 گیاه سالم است! ادامه دهید.';
      case 'لکه برگی':
        return '💊 توصیه: استفاده از قارچ‌کش مناسب و حذف برگ‌های آلوده';
      case 'زنگ زدگی':
        return '💊 توصیه: سمپاشی با مس و بهبود تهویه';
      case 'پژمردگی':
        return '💊 توصیه: بررسی آبیاری و سیستم ریشه';
      default:
        return '📖 مراجعه به متخصص کشاورزی توصیه می‌شود';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تشخیص بیماری گیاهان',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Icon Section
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 60,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 30),

                // Image Preview Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'هنوز تصویری انتخاب نشده',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _pickFromCamera,
                        icon: const Icon(Icons.camera_alt, size: 28),
                        label: const Text(
                          'دوربین',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _pickFromGallery,
                        icon: const Icon(Icons.photo_library, size: 28),
                        label: const Text(
                          'گالری',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Analyze Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _selectedImage != null && !_isAnalyzing
                        ? _analyzeImage
                        : null,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search, size: 28),
                    label: Text(
                      _isAnalyzing ? 'در حال تحلیل...' : 'تحلیل تصویر',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Result Section
                if (_result.isNotEmpty)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: Colors.green.shade700,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'نتیجه تحلیل:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Text(
                            _result,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}