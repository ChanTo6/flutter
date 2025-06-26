import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadBookScreen extends StatefulWidget {
  final void Function({required String title, required String author, required String genre, required String description, required String filePath}) onUpload;
  const UploadBookScreen({super.key, required this.onUpload});

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _filePath;
  bool _uploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) => value == null || value.isEmpty ? 'Enter author' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre'),
                validator: (value) => value == null || value.isEmpty ? 'Enter genre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: Text(_filePath == null ? 'Pick PDF File' : 'PDF Selected'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(160, 48)),
                onPressed: _pickFile,
              ),
              if (_filePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_filePath!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              const SizedBox(height: 24),
              _uploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && _filePath != null) {
                          setState(() => _uploading = true);
                          try {
                            widget.onUpload(
                              title: _titleController.text.trim(),
                              author: _authorController.text.trim(),
                              genre: _genreController.text.trim(),
                              description: _descriptionController.text.trim(),
                              filePath: _filePath!,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Upload failed: \\${e.toString()}')),
                            );
                          }
                          setState(() => _uploading = false);
                        } else if (_filePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a PDF file.')),
                          );
                        }
                      },
                      child: const Text('Upload Book'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
