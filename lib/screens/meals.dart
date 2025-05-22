import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

enum SortOption { duration, complexity, title }
enum SortOrder { ascending, descending }

class MealsScreen extends StatefulWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.onToggleFavorite,
    required this.favoriteMeals,
  });

  final String? title;
  final List<Meal> meals;
  final List<Meal> favoriteMeals;
  final void Function(Meal meal) onToggleFavorite;

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  String _searchQuery = '';
  SortOption _selectedSort = SortOption.title;
  SortOrder _sortOrder = SortOrder.ascending;

  List<Meal> _getSortedFilteredMeals() {
    List<Meal> filteredMeals = widget.meals.where((meal) {
      return meal.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    int sortFactor = _sortOrder == SortOrder.ascending ? 1 : -1;

    switch (_selectedSort) {
      case SortOption.duration:
        filteredMeals.sort((a, b) => sortFactor * a.duration.compareTo(b.duration));
        break;
      case SortOption.complexity:
        filteredMeals.sort((a, b) => sortFactor * a.complexity.index.compareTo(b.complexity.index));
        break;
      case SortOption.title:
        filteredMeals.sort((a, b) => sortFactor * a.title.compareTo(b.title));
        break;
    }

    return filteredMeals;
  }

  void _toggleSortOrder() {
    setState(() {
      _sortOrder = _sortOrder == SortOrder.ascending ? SortOrder.descending : SortOrder.ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = _getSortedFilteredMeals();

    Widget content = meals.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Uh oh ... nothing here!',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Try selecting a different category!',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: meals.length,
            itemBuilder: (ctx, index) => MealItem(
              meal: meals[index],
              onSelectMeal: (meal) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => MealDetailsScreen(
                      meal: meal,
                      onToggleFavorite: widget.onToggleFavorite,
                      isFavorite: widget.favoriteMeals.contains(meal),
                    ),
                  ),
                );
              },
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: MealSearchDelegate(onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                }),
              );
              if (result != null) {
                setState(() {
                  _searchQuery = result;
                });
              }
            },
          ),
          PopupMenuButton<dynamic>(
            onSelected: (value) {
              if (value is SortOption) {
                setState(() {
                  _selectedSort = value;
                });
              } else if (value == 'toggleOrder') {
                _toggleSortOrder();
              }
            },
            icon: const Icon(Icons.sort),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: SortOption.title,
                child: Text('Сортувати за назвою'),
              ),
              const PopupMenuItem(
                value: SortOption.duration,
                child: Text('Сортувати за тривалістю'),
              ),
              const PopupMenuItem(
                value: SortOption.complexity,
                child: Text('Сортувати за складністю'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggleOrder',
                child: Text(_sortOrder == SortOrder.ascending
                    ? 'Змінити на спадання'
                    : 'Змінити на зростання'),
              ),
            ],
          ),
        ],
      ),
      body: content,
    );
  }
}

// Delegate для пошуку
class MealSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  MealSearchDelegate({required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, ''), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
