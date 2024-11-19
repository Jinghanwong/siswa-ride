import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String bookingId;
  final String senderId;
  final String receiverId;

  const ChatPage({
    Key? key,
    required this.bookingId,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  late Stream<DatabaseEvent> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = _databaseRef
        .child('bookings')
        .child(widget.bookingId)
        .child('messages')
        .orderByChild('timestamp')
        .onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text("No chat yet."));
                }

                final messages = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
                    .entries
                    .map((entry) => Message.fromMap(entry.value))
                    .toList();

                // Sort messages by timestamp in ascending order
                messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                return ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message.senderId == widget.senderId;
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(formatTimestamp(message.timestamp)),
                      textColor: isSender ? Colors.blue : Colors.black,
                      tileColor: isSender ? Colors.blue[50] : Colors.grey[200],
                      leading: isSender ? null : const Icon(Icons.person),
                      trailing: isSender ? const Icon(Icons.person) : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    final newMessageRef = _databaseRef
        .child('bookings')
        .child(widget.bookingId)
        .child('messages')
        .push();

    newMessageRef.set({
      'text': text,
      'senderId': widget.senderId,
      'timestamp': ServerValue.timestamp,
    });
  }

  String formatTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}

class Message {
  final String text;
  final String senderId;
  final int timestamp;

  Message({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory Message.fromMap(Map<dynamic, dynamic> map) {
    return Message(
      text: map['text'],
      senderId: map['senderId'],
      timestamp: map['timestamp'],
    );
  }
}
