// import 'package:clinicapp/core/data/remote/socket_io.dart';
// import 'package:flutter/material.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final SocketService socketService = SocketService();
//   final TextEditingController _controller = TextEditingController();
//   final String userId = 'user123'; // Example user ID
//   final String token = 'your_jwt_token'; // Replace with actual JWT token
//
//   @override
//   void initState() {
//     super.initState();
//     socketService.connect(token);
//   }
//
//   @override
//   void dispose() {
//     socketService.disconnect();
//     super.dispose();
//   }
//
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       socketService.sendMessage(userId, _controller.text);
//       _controller.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: socketService.messageStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   List<String> messages = snapshot.data;
//                   return ListView.builder(
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(messages[index]),
//                       );
//                     },
//                   );
//                 } else {
//                   return Center(child: Text('No messages yet'));
//                 }
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(hintText: 'Enter message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
