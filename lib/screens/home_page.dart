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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveHelper.getHeroPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Nụ Cười Rạng Rỡ - Sức Khỏe Toàn Diện',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Chúng tôi mang đến dịch vụ nha khoa chuyên nghiệp, hiện đại và đáng tin cậy cho toàn bộ gia đình bạn',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Đặt lịch hẹn'),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Tìm hiểu thêm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Image Sections
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
              child: Image.asset(
                'assets/images/3.jpg',
                fit: BoxFit.cover,
              ),
            ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 80),
            
            // Heading Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
              child: Column(
                children: [
                  const Text(
                    'Dịch Vụ Nha Khoa Chuyên Nghiệp',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Với đội ngũ bác sĩ giàu kinh nghiệm và trang thiết bị hiện đại, chúng tôi cam kết mang đến cho bạn nụ cười hoàn hảo',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Service Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = ResponsiveHelper.getCrossAxisCount(context);
                  final childAspectRatio = ResponsiveHelper.getChildAspectRatio(context);
                  
                  if (crossAxisCount == 1) {
                    // Mobile layout - vertical column
                    return Column(
                      children: [
                        _buildServiceCard(
                          'Niềng Răng',
                          'Sửa chữa răng miệng chuyên nghiệp với công nghệ hiện đại, giúp bạn có nụ cười tự tin.',
                          'Chi tiết',
                        ),
                        const SizedBox(height: 20),
                        _buildServiceCard(
                          'Răng Sứ Thẩm Mỹ',
                          'Phục hình răng sứ thẩm mỹ cao cấp, mang lại vẻ đẹp tự nhiên và bền đẹp.',
                          'Chi tiết',
                        ),
                        const SizedBox(height: 20),
                        _buildServiceCard(
                          'Cấy Ghép Implant',
                          'Giải pháp thay thế răng mất tiên tiến, phục hồi chức năng nhai và thẩm mỹ.',
                          'Chi tiết',
                        ),
                      ],
                    );
                  } else {
                    // Tablet/Desktop layout - row
                    return Row(
                      children: [
                        Expanded(
                          child: _buildServiceCard(
                            'Niềng Răng',
                            'Sửa chữa răng miệng chuyên nghiệp với công nghệ hiện đại, giúp bạn có nụ cười tự tin.',
                            'Chi tiết',
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: _buildServiceCard(
                            'Răng Sứ Thẩm Mỹ',
                            'Phục hình răng sứ thẩm mỹ cao cấp, mang lại vẻ đẹp tự nhiên và bền đẹp.',
                            'Chi tiết',
                          ),
                        ),
                        if (crossAxisCount == 3) const SizedBox(width: 40),
                        if (crossAxisCount == 3)
                          Expanded(
                            child: _buildServiceCard(
                              'Cấy Ghép Implant',
                              'Giải pháp thay thế răng mất tiên tiến, phục hồi chức năng nhai và thẩm mỹ.',
                              'Chi tiết',
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
            
            const SizedBox(height: 80),
            
            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String description, String buttonText) {
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
            child: Center(
              child: Image.asset(
                'assets/images/1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
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
            child: Text(buttonText),
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
              // Logo and Social Icons
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
              // Use Cases
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
              // Explore
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
              // Resources
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
              
              // Mobile layout - stacked columns
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and Social Icons
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
                    // Mobile columns
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
              // Handle navigation to respective pages
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
