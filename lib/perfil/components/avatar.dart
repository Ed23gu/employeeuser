import 'package:cached_network_image/cached_network_image.dart';
import 'package:employee_attendance/constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;
  var altoPerfil = 130.0;
  var anchoPerfil = 120.0;
  var altoBoton50 = 50.0;
  var altofoto = 130.0;
  var anchofoto = 120.0;
  var tamanoDeicono = 110.0;

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            height: altoPerfil,
            width: anchoPerfil,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.blue),
            child: Center(
              child: Icon(
                Icons.person,
                size: tamanoDeicono,
                color: Colors.white,
              ),
            ),
          )
        else
          Container(
            height: altofoto,
            width: anchofoto,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: CachedNetworkImageProvider(
                  widget.imageUrl!,
                ),
              ),
            ),
          ),
        gapH8,
        ElevatedButton(
          onPressed: _isLoading ? null : _upload,
          child: const Text('Cargar'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 320,
      maxHeight: 320,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last.toLowerCase();
      final userId = _supabase.auth.currentUser!.id;
      final filePath = '$userId/profile.$fileExt';
      await _supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions:
                FileOptions(upsert: true, contentType: 'imageFile/$fileExt'),
          );
      final imageUrlResponse = await _supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }
}
