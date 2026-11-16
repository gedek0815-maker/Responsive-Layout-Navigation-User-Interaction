import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/kos_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile?> _profileFuture;
  late Future<List<Map<String, dynamic>>> _kosFuture;
  final KosService _kosService = KosService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _profileFuture = ProfileService().getMyProfile();
      _kosFuture = _kosService.fetchAll();
    });
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _showAddKosDialog() {
    final nameC = TextEditingController();
    final addressC = TextEditingController();
    final priceC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kos Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
              ),
              TextField(
                controller: addressC,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga / bulan (Rp)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameC.text.trim().isEmpty) return;
              final price = int.tryParse(priceC.text.trim()) ?? 0;
              Navigator.pop(ctx);
              try {
                await _kosService.add(
                  name: nameC.text.trim(),
                  address: addressC.text.trim(),
                  price: price,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kos berhasil ditambahkan!')),
                  );
                  _loadData();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambah kos: $e')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditKosDialog(Map<String, dynamic> kos) {
    final nameC = TextEditingController(text: kos['name'] ?? '');
    final addressC = TextEditingController(text: kos['address'] ?? '');
    final priceC = TextEditingController(text: (kos['price'] ?? 0).toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Kos Milik Anda'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
              ),
              TextField(
                controller: addressC,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga / bulan (Rp)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final price = int.tryParse(priceC.text.trim()) ?? 0;
              final success = await _kosService.update(kos['id'], {
                'name': nameC.text.trim(),
                'address': addressC.text.trim(),
                'price': price,
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Kos berhasil diperbarui!'
                        : 'Ditolak: Anda bukan pemilik kos ini'),
                  ),
                );
                _loadData();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteKos(String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kos'),
        content: Text('Apakah Anda yakin ingin menghapus "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _kosService.delete(id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Kos berhasil dihapus!'
                        : 'Ditolak: Anda bukan pemilik kos ini'),
                  ),
                );
                _loadData();
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapProfile) {
        if (snapProfile.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snapProfile.data;
        if (snapProfile.hasError || p == null) {
          return const Scaffold(
            body: Center(child: Text('Gagal memuat profil')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role})'),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: [
                // Identitas Pengguna
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(p.name.isEmpty ? p.email : p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${p.email} • Role: ${p.role.toUpperCase()}'),
                ),
                const Divider(),

                // Header Daftar Kos
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Daftar Kos Tersedia',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                // List Data Kos dari Supabase
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _kosFuture,
                  builder: (context, snapKos) {
                    if (snapKos.connectionState != ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapKos.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Gagal memuat data kos: ${snapKos.error}'),
                      );
                    }
                    final items = snapKos.data ?? [];
                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Belum ada data kos.\nOwner dapat menambahkan kos baru.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final kos = items[i];
                        final isMine = kos['owner_id'] == currentUserId;

                        return ListTile(
                          leading: const Icon(Icons.home, color: Colors.indigo),
                          title: Text(
                            kos['name'] ?? '-',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${kos['address'] ?? '-'} • Rp ${kos['price'] ?? 0}/bln\n'
                            'Owner: ${isMine ? "Milik Anda" : "Owner Lain"}',
                          ),
                          isThreeLine: true,
                          // Tombol Edit & Hapus HANYA muncul pada kos milik sendiri
                          trailing: isMine
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      tooltip: 'Edit Kos Milik Saya',
                                      onPressed: () => _showEditKosDialog(kos),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: 'Hapus Kos',
                                      onPressed: () => _confirmDeleteKos(
                                          kos['id'], kos['name'] ?? ''),
                                    ),
                                  ],
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // Tombol Tambah Kos hanya muncul untuk Owner dan Admin
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: _showAddKosDialog,
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}
