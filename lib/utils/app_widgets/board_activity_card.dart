import 'package:flutter/material.dart';

class TaskCardData {
  final String title;
  final String? subtitle;
  final String timestamp;
  final String? workingTime;
  final String userInitial;
  final String? linkText;
  final bool isCompleted;

  TaskCardData({
    required this.title,
    this.subtitle,
    required this.timestamp,
    this.workingTime,
    this.userInitial = 'T',
    this.linkText,
    this.isCompleted = false,
  });
}

class BoardActivityCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String timestamp;
  final String? workingTime;
  final String userInitial;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final bool isCompleted;

  const BoardActivityCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.timestamp,
    this.workingTime,
    this.userInitial = 'T',
    this.linkText,
    this.onLinkTap,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // gray-800
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF374151), // gray-700
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {}, // Add your tap handler here
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4B5563), // gray-600
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      // Subtitle with link
                      if (subtitle != null || linkText != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: const TextStyle(
                                  color: Color(0xFFD1D5DB), // gray-300
                                  fontSize: 14,
                                ),
                              ),
                            if (linkText != null)
                              GestureDetector(
                                onTap: onLinkTap,
                                child: Text(
                                  linkText!,
                                  style: const TextStyle(
                                    color: Color(0xFF60A5FA), // blue-400
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      
                      // Working time
                      if (workingTime != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Color(0xFF9CA3AF), // gray-400
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Total working time: $workingTime',
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF), // gray-400
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      // Timestamp
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Color(0xFF6B7280), // gray-500
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              color: Color(0xFF6B7280), // gray-500
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Status indicator
                if (isCompleted)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981), // green-500
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage in a screen
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = [
      TaskCardData(
        title: 'tes self-assigned this on Apr 9, 2025',
        timestamp: 'Apr 09, 01:31 PM',
        userInitial: 'T',
      ),
      TaskCardData(
        title: 'tes self-assigned this on Apr 9, 2025',
        timestamp: 'Apr 09, 01:32 PM',
        userInitial: 'T',
      ),
      TaskCardData(
        title: 'Testing on ',
        linkText: 'dl 1',
        workingTime: '00:00:03',
        timestamp: 'Apr 10, 04:04 PM',
        userInitial: 'T',
      ),
      TaskCardData(
        title: 'Testing on ',
        linkText: 'dl 2',
        workingTime: '00:00:04',
        timestamp: 'Apr 10, 04:05 PM',
        userInitial: 'T',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111827), // gray-900
      appBar: AppBar(
        title: const Text(
          'Task Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return BoardActivityCard(
              title: task.title,
              subtitle: task.subtitle,
              timestamp: task.timestamp,
              workingTime: task.workingTime,
              userInitial: task.userInitial,
              linkText: task.linkText,
              onLinkTap: () {
                // Handle link tap
                print('Link tapped: ${task.linkText}');
              },
              isCompleted: task.isCompleted,
            );
          },
        ),
      ),
    );
  }
}

// Data model for task card

