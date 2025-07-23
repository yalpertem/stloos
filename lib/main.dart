import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';
import 'env/env.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables
  await Env.initialize();
  
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shittheyleaveonourstreets',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    
    return StreamBuilder<AuthState>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final session = snapshot.hasData ? snapshot.data!.session : null;
        
        if (session != null) {
          return const MyHomePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> images = [];
  bool isLoading = true;
  String? error;
  
  int currentPage = 1;
  final int pageSize = 5;
  int totalImages = 0;
  int get totalPages => (totalImages / pageSize).ceil();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // Get total count for pagination
      final countResponse = await Supabase.instance.client
          .from('stloos_images')
          .select('*')
          .count(CountOption.exact);
      
      // Get paginated images
      final startIndex = (currentPage - 1) * pageSize;
      final endIndex = startIndex + pageSize - 1;
      
      final response = await Supabase.instance.client
          .from('stloos_images')
          .select('*')
          .order('created_at')
          .range(startIndex, endIndex);
      
      setState(() {
        images = List<Map<String, dynamic>>.from(response);
        totalImages = countResponse.count;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _changePage(int newPage) {
    if (newPage >= 1 && newPage <= totalPages && newPage != currentPage) {
      setState(() {
        currentPage = newPage;
        isLoading = true;
        error = null;
      });
      _loadImages();
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  String _buildImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    
    final baseUrl = AppConfig.imageBaseUrl;
    if (baseUrl.isEmpty) {
      return path;
    }
    
    return '$baseUrl$path';
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          final pageNumber = index + 1;
          return GestureDetector(
            onTap: () => _changePage(pageNumber),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: currentPage == pageNumber ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  color: currentPage == pageNumber ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('shittheyleaveonourstreets'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: _buildImagesList(),
      ),
    );
  }

  Widget _buildImagesList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading images: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  error = null;
                  isLoading = true;
                });
                _loadImages();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (images.isEmpty) {
      return const Center(
        child: Text('No images found'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: images.map((image) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      _buildImageUrl(image['path']),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 64),
                                Text('Failed to load image'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Created: ${_formatDate(image['created_at'])}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        if (totalPages > 1) _buildPaginationControls(),
      ],
    );
  }
}
