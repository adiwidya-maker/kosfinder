import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/kos_service.dart';
import '../services/notification_service.dart';
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
  final KosService _kosService = KosService();
  late Future<List<Map<String, dynamic>>> _kosFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
    _kosFuture = _kosService.fetchAll();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await NotificationService.instance.init();
        await NotificationService.instance.setupInteractedMessage();
      } catch (e) {
        debugPrint('Firebase Notification Init: $e');
      }
    });
  }

  void _refreshKos() {
    setState(() {
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

  Future<void> _showAddKosDialog() async {
    final nameC = TextEditingController();
    final addressC = TextEditingController();
    final priceC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kos Baru'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: 'Nama Kos'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                ),
                TextFormField(
                  controller: addressC,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Alamat wajib diisi' : null,
                ),
                TextFormField(
                  controller: priceC,
                  decoration: const InputDecoration(labelText: 'Harga / Bulan'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Harga wajib diisi' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await _kosService.add(
                  name: nameC.text.trim(),
                  address: addressC.text.trim(),
                  price: int.tryParse(priceC.text.trim()) ?? 0,
                );
                if (mounted) {
                  Navigator.pop(ctx);
                  _refreshKos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kos berhasil ditambahkan!')),
                  );
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

  Future<void> _runSecurityTest(String targetKosId) async {
    final updated =
        await _kosService.update(targetKosId, {'name': 'DIUBAH USER LAIN'});
    final deleted = await _kosService.delete(targetKosId);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hasil Security Testing RLS'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              updated
                  ? '[FAIL] UPDATE data orang lain berhasil!'
                  : '[PASS] UPDATE ditolak oleh RLS (Aman)',
              style: TextStyle(
                color: updated ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deleted
                  ? '[FAIL] DELETE data orang lain berhasil!'
                  : '[PASS] DELETE ditolak oleh RLS (Aman)',
              style: TextStyle(
                color: deleted ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
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
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final p = snap.data;
        if (snap.hasError || p == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('KosFinder')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat profil atau sesi habis'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Kembali ke Login'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role.toUpperCase()})'),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: _refreshKos,
              ),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // Kartu Profil Pengguna
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: const Icon(Icons.person, color: Colors.indigo),
                        ),
                        title: Text(
                          p.name.isEmpty ? p.email : p.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${p.email}\nRole: ${p.role}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Menu Otorisasi Berdasarkan Role
              const Text(
                'Menu Utama',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const ListTile(
                leading: Icon(Icons.search),
                title: Text('Pencarian Kos'),
                subtitle: Text('Jelajahi kos di sekitar kampus'),
              ),
              if (p.isOwner || p.isAdmin)
                const ListTile(
                  leading: Icon(Icons.home_work),
                  title: Text('My Kos'),
                  subtitle: Text('Kelola kos milik Anda'),
                ),
              if (p.isAdmin)
                const ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Kelola Data (Admin)'),
                  subtitle: Text('Hak akses penuh database'),
                ),

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Kos Tersedia',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Muat Ulang'),
                    onPressed: _refreshKos,
                  ),
                ],
              ),

              // List Kos Real-time dari Supabase
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _kosFuture,
                builder: (context, kosSnap) {
                  if (kosSnap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final list = kosSnap.data ?? [];
                  if (list.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('Belum ada data kos.'),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) {
                      final item = list[i];
                      final isMine = item['owner_id'] == currentUserId;
                      final kosId = item['id'].toString();

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.apartment, color: Colors.indigo),
                          title: Text(item['name'] ?? '-'),
                          subtitle: Text(
                            '${item['address'] ?? '-'}\nRp ${item['price'] ?? 0} / bulan',
                          ),
                          isThreeLine: true,
                          trailing: isMine
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Hapus Kos Saya',
                                      onPressed: () async {
                                        final ok = await _kosService.delete(kosId);
                                        if (ok) {
                                          _refreshKos();
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Kos berhasil dihapus')),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : IconButton(
                                  icon: const Icon(Icons.shield_outlined, color: Colors.orange),
                                  tooltip: 'Tes RLS (Coba manipulasi data orang lain)',
                                  onPressed: () => _runSecurityTest(kosId),
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),

          // Tombol Tambah Kos HANYA muncul untuk Owner dan Admin
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
