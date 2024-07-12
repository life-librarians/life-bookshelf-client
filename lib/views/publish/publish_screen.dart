import 'package:flutter/material.dart';
import 'package:life_bookshelf/viewModels/publish/publish_viewmodel.dart';
import 'package:life_bookshelf/views/base/base_screen.dart';
import 'package:life_bookshelf/views/publish/ticket.dart';

class PublishScreen extends BaseScreen<PublishViewModel> {
  const PublishScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: TicketPainter(),
        child: Container(
          width: 333,
          height: 394,
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('황현정', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('도로위의 무법자', style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2024.02.24', style: TextStyle(fontSize: 12)),
                      Text('첫 비행', style: TextStyle(fontSize: 16)),
                      Text('0페이지', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Icon(Icons.flight_takeoff, size: 30, color: Colors.blue),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('2024.03.24', style: TextStyle(fontSize: 12)),
                      Text('출판', style: TextStyle(fontSize: 16)),
                      Text('123페이지', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              // 나머지 내용 추가
            ],
          ),
        ),
      ),
    );
  }
}
