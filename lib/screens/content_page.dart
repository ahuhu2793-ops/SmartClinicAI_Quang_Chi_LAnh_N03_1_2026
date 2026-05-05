import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 16.0;
    if (width < 1200) return 40.0;
    return 80.0;
  }

  static double getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 800) return 20.0;
    if (height < 1200) return 40.0;
    return 60.0;
  }

  static double getHeroPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 800) return 40.0;
    if (height < 1200) return 60.0;
    return 80.0;
  }

  static double getFooterPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 20.0;
    if (width < 1200) return 40.0;
    return 60.0;
  }

  static int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1;
    if (width < 1200) return 2;
    return 3;
  }

  static double getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1.0;
    if (width < 1200) return 1.2;
    return 1.5;
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Nha Khoa ABC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Dịch vụ'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Giải pháp'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Cộng đồng'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Tài nguyên'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Bảng giá'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Liên hệ'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
            child: const Text('Đăng nhập'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng ký'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveHelper.getHeroPadding(context)),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Dịch Vụ Nha Khoa Chuyên Nghiệp',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Khám phá các dịch vụ nha khoa chuyên nghiệp với công nghệ hiện đại và đội ngũ bác sĩ giàu kinh nghiệm',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            

            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
              child: Column(
                children: [
                  const Text(
                    'Dịch Vụ Nổi Bật',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Các dịch vụ nha khoa được ưa chuộng nhất tại phòng khám của chúng tôi',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildVerticalListItem(
                    'Niềng Răng Invisalign',
                    'Công nghệ niềng răng không mắc cài hiện đại, giúp bạn có nụ cười đẹp một cách kín đáo và hiệu quả. Phương pháp này sử dụng các khay trong suốt có thể tháo ra, mang lại sự thoải mái tối đa trong quá trình điều trị.',
                    'Chi tiết',
                  ),
                  const SizedBox(height: 20),
                  _buildVerticalListItem(
                    'Răng Sứ Thẩm Mỹ',
                    'Phục hình răng sứ thẩm mỹ cao cấp với độ bền vượt trội và thẩm mỹ tự nhiên. Răng sứ Cercon có khả năng chống mài mòn tốt, không gây đen viền nướu và có màu sắc giống răng thật.',
                    'Chi tiết',
                  ),
                  const SizedBox(height: 20),
                  _buildVerticalListItem(
                    'Cấy Ghép Implant',
                    'Giải pháp thay thế răng mất tiên tiến nhất hiện nay. Implant giúp phục hồi hoàn toàn chức năng nhai và thẩm mỹ, mang lại cảm giác như răng tự nhiên với độ bền lên đến 25 năm.',
                    'Chi tiết',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
              child: Column(
                children: [
                  const Text(
                    'Tất Cả Dịch Vụ',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Phòng khám của chúng tôi cung cấp đầy đủ các dịch vụ nha khoa từ cơ bản đến chuyên sâu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = ResponsiveHelper.getCrossAxisCount(context);
                      final isMobile = MediaQuery.of(context).size.width < 600;
                      
                      if (isMobile) {
                        return Column(
                          children: [
                            _buildGridItem(
                              'Whitening Răng Laser',
                              'Tẩy trắng răng laser công nghệ mới nhất giúp răng trắng sáng lên đến 8-10 tông màu chỉ trong 60 phút.',
                            ),
                            const SizedBox(height: 20),
                            _buildGridItem(
                              'Trám Răng Thẩm Mỹ',
                              'Trám răng bằng vật liệu composite cao cấp có màu sắc giống hệt răng thật.',
                            ),
                            const SizedBox(height: 20),
                            _buildGridItem(
                              'Vệ Sinh Răng Miệng',
                              'Dịch vụ vệ sinh răng miệng chuyên nghiệp giúp loại bỏ mảng bám và cao răng.',
                            ),
                            const SizedBox(height: 20),
                            _buildGridItem(
                              'Sâu Răng',
                              'Điều trị và trám răng sâu bằng vật liệu an toàn, bền đẹp.',
                            ),
                            const SizedBox(height: 20),
                            _buildGridItem(
                              'Hô Miệng',
                              'Phẫu thuật chỉnh hình hàm mặt để cải thiện chức năng và thẩm mỹ.',
                            ),
                          ],
                        );
                      } else {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            final services = [
                              {
                                'title': 'Whitening Răng Laser',
                                'description': 'Tẩy trắng răng laser công nghệ mới nhất giúp răng trắng sáng lên đến 8-10 tông màu chỉ trong 60 phút.',
                              },
                              {
                                'title': 'Trám Răng Thẩm Mỹ',
                                'description': 'Trám răng bằng vật liệu composite cao cấp có màu sắc giống hệt răng thật.',
                              },
                              {
                                'title': 'Vệ Sinh Răng Miệng',
                                'description': 'Dịch vụ vệ sinh răng miệng chuyên nghiệp giúp loại bỏ mảng bám và cao răng.',
                              },
                              {
                                'title': 'Sâu Răng',
                                'description': 'Điều trị và trám răng sâu bằng vật liệu an toàn, bền đẹp.',
                              },
                              {
                                'title': 'Hô Miệng',
                                'description': 'Phẫu thuật chỉnh hình hàm mặt để cải thiện chức năng và thẩm mỹ.',
                              },
                              {
                                'title': 'Nướu Răng',
                                'description': 'Điều trị các bệnh về nướu, phòng ngừa và phục hồi sức khỏe nướu răng.',
                              },
                            ];
                            return _buildGridItem(
                              services[index]['title']!,
                              services[index]['description']!,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 80),
            
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Tìm hiểu thêm'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildVerticalListItem(String title, String description, String buttonText) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.getFooterPadding(context)),
      color: Colors.grey[50],
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Nha Khoa ABC',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildSocialIcon(Icons.alternate_email),
                          const SizedBox(width: 12),
                          _buildSocialIcon(Icons.camera_alt),
                          const SizedBox(width: 12),
                          _buildSocialIcon(Icons.play_circle),
                          const SizedBox(width: 12),
                          _buildSocialIcon(Icons.work),
                        ],
                      ),
                    ],
                  ),
                ),
              if (!isMobile)
                Expanded(
                  child: _buildFooterColumn('Dịch vụ', [
                    'Niềng răng',
                    'Răng sứ thẩm mỹ',
                    'Cấy ghép implant',
                    'Trám răng',
                    'Vệ sinh răng miệng',
                    'Whitening răng',
                  ]),
                ),
              if (!isMobile)
                Expanded(
                  child: _buildFooterColumn('Khám phá', [
                    'Đội ngũ bác sĩ',
                    'Công nghệ',
                    'Hệ thống phòng khám',
                    'Quy trình',
                    'Chính sách bảo hành',
                    'Hỏi đáp',
                  ]),
                ),
              if (!isMobile)
                Expanded(
                  child: _buildFooterColumn('Tài nguyên', [
                    'Blog',
                    'Kiến thức nha khoa',
                    'Video hướng dẫn',
                    'Bảng giá',
                    'Hỗ trợ khách hàng',
                    'Liên hệ',
                  ]),
                ),
              
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Nha Khoa ABC',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.alternate_email),
                        const SizedBox(width: 12),
                        _buildSocialIcon(Icons.camera_alt),
                        const SizedBox(width: 12),
                        _buildSocialIcon(Icons.play_circle),
                        const SizedBox(width: 12),
                        _buildSocialIcon(Icons.work),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildFooterColumn('Dịch vụ', [
                      'Niềng răng',
                      'Răng sứ thẩm mỹ',
                      'Cấy ghép implant',
                      'Trám răng',
                      'Vệ sinh răng miệng',
                      'Whitening răng',
                    ]),
                    const SizedBox(height: 30),
                    _buildFooterColumn('Khám phá', [
                      'Đội ngũ bác sĩ',
                      'Công nghệ',
                      'Hệ thống phòng khám',
                      'Quy trình',
                      'Chính sách bảo hành',
                      'Hỏi đáp',
                    ]),
                    const SizedBox(height: 30),
                    _buildFooterColumn('Tài nguyên', [
                      'Blog',
                      'Kiến thức nha khoa',
                      'Video hướng dẫn',
                      'Bảng giá',
                      'Hỗ trợ khách hàng',
                      'Liên hệ',
                    ]),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              print('Navigate to: $item');
            },
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        )),
      ],
    );
  }
}
