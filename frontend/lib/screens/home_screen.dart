import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../services/api_service.dart';
import 'provider_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();

  List<ServiceProvider> _providers = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = '';

  final _categories = const [
    {'label': 'All', 'value': ''},
    {'label': 'Vet', 'value': 'vet'},
    {'label': 'Groomer', 'value': 'groomer'},
    {'label': 'Walker', 'value': 'walker'},
    {'label': 'Boarding', 'value': 'boarding'},
    {'label': 'Trainer', 'value': 'trainer'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _apiService.getProviders(
        category: _selectedCategory,
        search: _searchController.text.trim(),
      );
      setState(() {
        _providers = data.map((e) => ServiceProvider.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetCare Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProviders,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search vets, groomers, walkers...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSubmitted: (_) => _fetchProviders(),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final selected = _selectedCategory == cat['value'];
                  return ChoiceChip(
                    label: Text(cat['label']!),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat['value']!);
                      _fetchProviders();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load providers: $_error'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _fetchProviders, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_providers.isEmpty) {
      return const Center(child: Text('No providers found. Try a different search.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _providers.length,
      itemBuilder: (context, index) {
        final p = _providers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                p.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.pets),
                ),
              ),
            ),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${p.category.toUpperCase()} · ${p.location}'),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${p.avgRating} (${p.reviewCount})'),
                    const Spacer(),
                    Text('₹${p.pricePerSession.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProviderDetailScreen(providerId: p.id)),
              );
            },
          ),
        );
      },
    );
  }
}
