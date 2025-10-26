import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  File? _selectedImage;
  String _selectedCategory = 'Académico';
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _publishPost() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor escribe algo antes de publicar')),
      );
      return;
    }

    // Aquí iría la lógica para publicar el post
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡Publicación creada exitosamente!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),  
        ),
        centerTitle: true,
        title: Text(
          'Crear Publicación',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey[300],
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Spacing.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contenido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _contentController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Comparte algo con la comunidad...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              SizedBox(height: 24),

              if (_selectedImage == null)
                GestureDetector(
                  onTap: _pickImage,
                  child: DashedBorder(
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey[600],
                            size: 50,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Añadir una imagen (opcional)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Toca para subir una imagen',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _removeImage,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 24),

              Text(
                'Etiquetas (ayuda a otros a encontrar tu post)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  hintText: 'Añade etiquetas separadas por comas',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              SizedBox(height: 24),

              Text(
                '¿De qué trata tu publicación?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryButton(
                      label: 'Académico',
                      icon: Icons.school_outlined,
                      isSelected: _selectedCategory == 'Académico',
                      onTap: () {
                        setState(() {
                          _selectedCategory = 'Académico';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildCategoryButton(
                      label: 'Social',
                      icon: Icons.celebration_outlined,
                      isSelected: _selectedCategory == 'Social',
                      onTap: () {
                        setState(() {
                          _selectedCategory = 'Social';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _publishPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Publicar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.secondaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? CustomColors.secondaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black87,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para guiones
class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double gap;

  const DashedBorder({
    super.key,
    required this.child,
    this.color = const Color(0xFFBDBDBD),
    this.strokeWidth = 2.0,
    this.gap = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        gap: gap,
      ),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(12),
        ),
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashWidth = 8.0;
    final dashSpace = gap;
    var distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final start = metric.getTangentForOffset(distance);
        final end = metric.getTangentForOffset(distance + dashWidth);
        
        if (start != null && end != null) {
          canvas.drawLine(start.position, end.position, paint);
        }
        
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) => false;
}