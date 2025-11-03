import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/data/models/user_model.dart';
import 'dart:ui';
//import 'dart:math' as math;

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with TickerProviderStateMixin {
  List<UserProfile> allUsers = getDummyUsers();
  List<UserProfile> filteredUsers = [];
  int currentIndex = 0;
  
  String? selectedCareer;
  String? selectedSemester;
  String? selectedInterest;

  // Variables para el swipe
  Offset dragPosition = Offset.zero;
  bool isDragging = false;
  AnimationController? _swipeAnimationController;

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(allUsers);
    _swipeAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _swipeAnimationController?.dispose();
    super.dispose();
  }

  Set<String> getAllCareers() {
    return allUsers.map((user) => user.career).toSet();
  }

  Set<String> getAllSemesters() {
    return allUsers.map((user) => user.semester).toSet();
  }

  Set<String> getAllInterests() {
    Set<String> interests = {};
    for (var user in allUsers) {
      interests.addAll(user.interests);
    }
    return interests;
  }

  void applyFilters() {
    setState(() {
      filteredUsers = allUsers.where((user) {
        bool matchesCareer = selectedCareer == null || user.career == selectedCareer;
        bool matchesSemester = selectedSemester == null || user.semester == selectedSemester;
        bool matchesInterest = selectedInterest == null || user.interests.contains(selectedInterest);
        
        return matchesCareer && matchesSemester && matchesInterest;
      }).toList();
      
      currentIndex = 0;
    });
  }

  void _showFilterModal(String filterType) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        Set<String> options;
        String? selectedValue;
        String title;
        bool isSemesterFilter = filterType == 'semester';

        switch (filterType) {
          case 'career':
            options = getAllCareers();
            selectedValue = selectedCareer;
            title = 'Carrera';
            break;
          case 'semester':
            options = getAllSemesters();
            selectedValue = selectedSemester;
            title = 'Semestre';
            break;
          case 'interest':
            options = getAllInterests();
            selectedValue = selectedInterest;
            title = 'Intereses';
            break;
          default:
            options = {};
            title = '';
        }

        List<String> sortedOptions = options.toList();
        if (isSemesterFilter) {
          sortedOptions.sort((a, b) {
            int numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            int numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            return numA.compareTo(numB);
          });
        }

        return Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: isSemesterFilter
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterOptionList(
                              'Todos',
                              selectedValue == null,
                              () {
                                setState(() {
                                  selectedSemester = null;
                                });
                                applyFilters();
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: 8),
                            ...sortedOptions.map((option) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: _buildFilterOptionList(
                                  option,
                                  selectedValue == option,
                                  () {
                                    setState(() {
                                      selectedSemester = option;
                                    });
                                    applyFilters();
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFilterOption(
                              'Todos',
                              selectedValue == null,
                              () {
                                setState(() {
                                  switch (filterType) {
                                    case 'career':
                                      selectedCareer = null;
                                      break;
                                    case 'interest':
                                      selectedInterest = null;
                                      break;
                                  }
                                });
                                applyFilters();
                                Navigator.pop(context);
                              },
                            ),
                            ...sortedOptions.map((option) {
                              return _buildFilterOption(
                                option,
                                selectedValue == option,
                                () {
                                  setState(() {
                                    switch (filterType) {
                                      case 'career':
                                        selectedCareer = option;
                                        break;
                                      case 'interest':
                                        selectedInterest = option;
                                        break;
                                    }
                                  });
                                  applyFilters();
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFE4E6) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CustomColors.primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptionList(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFE4E6) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CustomColors.primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _handleSwipe(bool isLike) {
    if (filteredUsers.isEmpty || currentIndex >= filteredUsers.length) return;

    final currentUser = filteredUsers[currentIndex];
    
    setState(() {
      if (currentIndex < filteredUsers.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      dragPosition = Offset.zero;
      isDragging = false;
    });

    if (isLike) {
      _showMatchDialog(currentUser);
    }
  }

  void _showMatchDialog(UserProfile matchedUser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡Nuevo Match!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'A ti y a ${matchedUser.name.split(' ')[0]} les gusta el perfil del otro.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  // Avatar con corazón
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(matchedUser.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: CustomColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Botón Enviar mensaje
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Aquí iría la navegación al chat
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Enviar mensaje',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Botón Seguir buscando
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Seguir buscando',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasUsers = filteredUsers.isNotEmpty && currentIndex < filteredUsers.length;
    final currentUser = hasUsers ? filteredUsers[currentIndex] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Match',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.padding, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    selectedCareer ?? 'Carrera',
                    () => _showFilterModal('career'),
                    selectedCareer != null,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildFilterButton(
                    selectedSemester ?? 'Semestre',
                    () => _showFilterModal('semester'),
                    selectedSemester != null,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildFilterButton(
                    selectedInterest ?? 'Intereses',
                    () => _showFilterModal('interest'),
                    selectedInterest != null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Spacing.padding),
              child: hasUsers && currentUser != null
                  ? _buildSwipeableCard(currentUser)
                  : Center(
                      child: Text(
                        'No hay más usuarios con estos filtros',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableCard(UserProfile user) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;
    
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          isDragging = true;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          dragPosition += details.delta;
        });
      },
      onPanEnd: (details) {
        if (dragPosition.dx.abs() > threshold) {
          // Swipe significativo
          if (dragPosition.dx > 0) {
            // Swipe a la derecha (like)
            _handleSwipe(true);
          } else {
            // Swipe a la izquierda (dislike)
            _handleSwipe(false);
          }
        } else {
          // Volver a la posición original
          setState(() {
            dragPosition = Offset.zero;
            isDragging = false;
          });
        }
      },
      child: Transform.translate(
        offset: dragPosition,
        child: Transform.rotate(
          angle: dragPosition.dx / 1000,
          child: _buildProfileCard(user),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFE4E6) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? CustomColors.primaryColor : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: isSelected ? CustomColors.primaryColor : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProfile user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              user.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.person, size: 100, color: Colors.grey[500]),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${user.name}, ${user.age}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${user.career}, ${user.semester}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.interests.map((interest) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getInterestIcon(interest),
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                interest,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _handleSwipe(false),
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black87,
                              size: 35,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        GestureDetector(
                          onTap: () => _handleSwipe(true),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: CustomColors.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getInterestIcon(String interest) {
    switch (interest.toLowerCase()) {
      case 'fotografía':
        return Icons.camera_alt;
      case 'cine':
        return Icons.movie;
      case 'senderismo':
        return Icons.hiking;
      case 'programación':
        return Icons.code;
      case 'videojuegos':
        return Icons.sports_esports;
      case 'música':
        return Icons.music_note;
      case 'lectura':
        return Icons.book;
      case 'yoga':
        return Icons.self_improvement;
      case 'café':
        return Icons.local_cafe;
      case 'emprendimiento':
        return Icons.business;
      case 'deportes':
        return Icons.sports_soccer;
      case 'networking':
        return Icons.people;
      case 'redes sociales':
        return Icons.share;
      case 'arte':
        return Icons.palette;
      default:
        return Icons.star;
    }
  }
}