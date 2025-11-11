import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/animation_curves.dart';

class ContentItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final ContentType type;

  ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.type,
  });
}

enum ContentType {
  video,
  article,
  guide,
}

class ContentGrid extends StatefulWidget {
  final List<ContentItem> items;
  final ValueChanged<ContentItem>? onItemTap;

  const ContentGrid({
    super.key,
    required this.items,
    this.onItemTap,
  });

  @override
  State<ContentGrid> createState() => _ContentGridState();
}

class _ContentGridState extends State<ContentGrid> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<ContentItem> get _filteredItems {
    return widget.items.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == null ||
          item.category == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Set<String> get _categories {
    return widget.items.map((item) => item.category).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildCategoryFilters(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildMasonryGrid(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: AppCurves.geometricMorph,
        decoration: BoxDecoration(
          gradient: _isSearchFocused
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                    theme.colorScheme.secondaryContainer.withOpacity(0.3),
                  ],
                )
              : null,
          color: _isSearchFocused
              ? null
              : theme.colorScheme.surface.withOpacity(0.5),
          border: Border.all(
            color: _isSearchFocused
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search content...',
            prefixIcon: Icon(
              Icons.search,
              color: _isSearchFocused
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('All', null),
          const SizedBox(width: 12),
          ..._categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildCategoryChip(category, category),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;

    return GeometricCategoryChip(
      label: label,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  Widget _buildMasonryGrid() {
    final filteredItems = _filteredItems;

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No content found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return ContentCard(
          item: filteredItems[index],
          onTap: () => widget.onItemTap?.call(filteredItems[index]),
        );
      },
    );
  }
}

/// Geometric category chip with floating design
class GeometricCategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GeometricCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<GeometricCategoryChip> createState() => _GeometricCategoryChipState();
}

class _GeometricCategoryChipState extends State<GeometricCategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(GeometricCategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ChipPainter(
              progress: _controller.value,
              isSelected: widget.isSelected,
              isDark: theme.brightness == Brightness.dark,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
              surfaceColor: theme.colorScheme.surfaceContainerHighest,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: widget.isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChipPainter extends CustomPainter {
  final double progress;
  final bool isSelected;
  final bool isDark;
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceColor;

  ChipPainter({
    required this.progress,
    required this.isSelected,
    required this.isDark,
    required this.primaryColor,
    required this.secondaryColor,
    required this.surfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createChipShape(size, progress);

    if (isSelected) {
      final gradient = LinearGradient(
        colors: [
          primaryColor,
          secondaryColor,
        ],
      );

      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      final bgPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, bgPaint);
    } else {
      final bgPaint = Paint()
        ..color = surfaceColor.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, bgPaint);
    }

    final borderPaint = Paint()
      ..color = isSelected
          ? primaryColor
          : primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);
  }

  Path _createChipShape(Size size, double morphProgress) {
    final path = Path();
    final cornerSize = 8.0 + morphProgress * 4;

    path.moveTo(cornerSize, 0);
    path.lineTo(size.width - cornerSize, 0);
    path.lineTo(size.width, cornerSize);
    path.lineTo(size.width, size.height - cornerSize);
    path.lineTo(size.width - cornerSize, size.height);
    path.lineTo(cornerSize, size.height);
    path.lineTo(0, size.height - cornerSize);
    path.lineTo(0, cornerSize);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(ChipPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isSelected != isSelected;
  }
}

/// Content card with minimal design
class ContentCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback? onTap;

  const ContentCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large, clear thumbnail
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: _getTypeColor(item.type, theme.colorScheme).withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  _getTypeIcon(item.type),
                  size: 56,
                  color: _getTypeColor(item.type, theme.colorScheme),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtle category label
                  Text(
                    item.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title in 18px font
                  Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(ContentType type, ColorScheme colorScheme) {
    switch (type) {
      case ContentType.video:
        return colorScheme.secondary;
      case ContentType.article:
        return colorScheme.primary;
      case ContentType.guide:
        return colorScheme.tertiary;
    }
  }

  IconData _getTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.article:
        return Icons.article_outlined;
      case ContentType.guide:
        return Icons.menu_book_outlined;
    }
  }
}
