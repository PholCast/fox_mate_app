import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/data/models/event_model.dart';
import 'package:fox_mate_app/presentation/screens/create/create_event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String selectedFilter = 'Todos';
  List<Event> events = getDummyEvents();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Set<String> getAllCategories() {
    Set<String> allCategories = {};
    for (var event in events) {
      allCategories.add(event.category);
    }
    return allCategories;
  }

  List<Event> getFilteredEvents() {
    List<Event> filtered = events;
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        final titleLower = event.title.toLowerCase();
        final descriptionLower = event.description.toLowerCase();
        final creatorLower = event.creatorName.toLowerCase();
        final queryLower = searchQuery.toLowerCase();
        return titleLower.contains(queryLower) || 
               descriptionLower.contains(queryLower) || 
               creatorLower.contains(queryLower);
      }).toList();
    }
    
    if (selectedFilter != 'Todos') {
      filtered = filtered.where((event) => event.category == selectedFilter).toList();
    }
    
    return filtered;
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
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
                    'Filtros',
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
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Todos', ...getAllCategories()].map((category) {
                      return _buildFilterChipForMenu(category);
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChipForMenu(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
        Navigator.pop(context);
      },
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

  @override
  Widget build(BuildContext context) {
    final filteredEvents = getFilteredEvents();
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          'Parchate',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              child: Icon(
                Icons.add_circle_outline_sharp,
                color: CustomColors.primaryColor,
                size: 30,
                weight: 700
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEventScreen()),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: Spacing.padding, vertical: 12),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar Evento',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
            ),
          ),

          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: Spacing.padding, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: OutlinedButton.icon(
                      onPressed: _showFilterMenu,
                      icon: Icon(Icons.tune, size: 18),
                      label: Text('Filtros'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  
                  _buildFilterChip('Todos'),
                  ...getAllCategories().map((category) => _buildFilterChip(category)),
                ],
              ),
            ),
          ),

          SizedBox(height: 8),

          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Text(
                      'No hay eventos con este filtro',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: Spacing.padding, vertical: 8),
                    itemCount: filteredEvents.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildEventCard(filteredEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFFFE4E6) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey[300]!,
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
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                event.imageUrl!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Creado por ${event.creatorName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 6),
                    Text(
                      _formatEventDate(event.eventDate),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Unirse',
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
        ],
      ),
    );
  }

  String _formatEventDate(DateTime date) {
    final now = DateTime.now();
    
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    const weekdays = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    
    // Si es hoy
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Hoy a las ${_formatTime(date)}';
    }
    
    // Si es mañana
    final tomorrow = now.add(Duration(days: 1));
    if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Mañana a las ${_formatTime(date)}';
    }
    
    // Formato completo
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} de $month a las ${_formatTime(date)}';
  }
  
  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}