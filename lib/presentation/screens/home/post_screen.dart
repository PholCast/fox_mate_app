import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/presentation/screens/create/create_post_screen.dart';
import 'package:fox_mate_app/presentation/screens/home/widgets/post_card.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';
import 'package:fox_mate_app/providers/post_provider.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String selectedFilter = 'Todos';
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool _isRefreshing = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Set<String> getAllTags(List<PostEntity> posts) {
    Set<String> allTags = {'Académico', 'Social'};
    for (var post in posts) {
      allTags.addAll(post.tags);
    }
    return allTags;
  }

  List<PostEntity> getFilteredPosts(List<PostEntity> posts) {
    List<PostEntity> filtered = posts;

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((post) {
        final contentLower = post.content.toLowerCase();
        final authorLower = post.authorName.toLowerCase();
        final queryLower = searchQuery.toLowerCase();
        return contentLower.contains(queryLower) ||
            authorLower.contains(queryLower);
      }).toList();
    }

    if (selectedFilter != 'Todos') {
      filtered = filtered
          .where((post) => post.tags.contains(selectedFilter))
          .toList();
    }

    return filtered;
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Esperar un momento para que Firebase sincronice los datos
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _showFilterMenu(List<PostEntity> posts) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Todos', ...getAllTags(posts)].map((tag) {
                      return _buildFilterChipForMenu(tag);
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE4E6) : Colors.grey[100],
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: Spacing.padding),
          child: const Text(
            'FoxMate',
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return IconButton(
                icon: const Icon(
                  Icons.logout_outlined,
                  color: CustomColors.primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  await authProvider.signOut();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_sharp,
              color: CustomColors.primaryColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePostScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.status == PostStatus.loading &&
              postProvider.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.status == PostStatus.error &&
              postProvider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar publicaciones',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      postProvider.clearError();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final filteredPosts = getFilteredPosts(postProvider.posts);

          return Column(
            children: [
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.padding,
                  vertical: 12,
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar en FoxMate...',
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.padding,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _showFilterMenu(postProvider.posts),
                          icon: const Icon(Icons.tune, size: 18),
                          label: const Text('Filtros'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      _buildFilterChip('Todos'),
                      ...getAllTags(postProvider.posts)
                          .map((tag) => _buildFilterChip(tag)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filteredPosts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.post_add,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isNotEmpty
                                  ? 'No se encontraron publicaciones'
                                  : selectedFilter != 'Todos'
                                      ? 'No hay publicaciones con este filtro'
                                      : 'No hay publicaciones aún',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (searchQuery.isEmpty && selectedFilter == 'Todos')
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreatePostScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Crear primera publicación'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: CustomColors.primaryColor,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.padding,
                            vertical: 8,
                          ),
                          itemCount: filteredPosts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return PostCard(post: filteredPosts[index]);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE4E6) : Colors.white,
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

}