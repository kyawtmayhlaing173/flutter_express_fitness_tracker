import 'package:flutter/material.dart';

class ApiConfigCard extends StatelessWidget {
  final String baseUrl;
  final String? authToken;

  const ApiConfigCard({
    super.key,
    required this.baseUrl,
    this.authToken,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Configuration (for Backend Testing)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Base URL: $baseUrl',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Auth Token: ${authToken != null && authToken!.isNotEmpty ? 'Present' : 'Not Set / Missing'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: authToken != null && authToken!.isNotEmpty
                        ? Colors.green
                        : Colors.red,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure your backend is running at this URL and your token is valid for testing.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
