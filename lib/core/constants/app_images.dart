class AppImages {
  AppImages._();

  // Placeholder images from Unsplash (coffee themed)
  static const String placeholder1 =
      'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400';
  static const String placeholder2 =
      'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=400';
  static const String placeholder3 =
      'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400';
  static const String placeholder4 =
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400';
  static const String placeholder5 =
      'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400';
  static const String placeholder6 =
      'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400';
  static const String placeholder7 =
      'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=400';
  static const String placeholder8 =
      'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400';
  static const String placeholder9 =
      'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400';
  static const String placeholder10 =
      'https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?w=400';

  // Branding
  static const String logo =
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200';

  // Illustrations for empty states
  static const String emptyCart =
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300';
  static const String emptyOrders =
      'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300';

  // Map product IDs to images
  static String getProductImage(String productId) {
    final images = [
      placeholder1,
      placeholder2,
      placeholder3,
      placeholder4,
      placeholder5,
      placeholder6,
      placeholder7,
      placeholder8,
      placeholder9,
      placeholder10,
    ];

    // Use product ID hash to consistently assign images
    final index = productId.hashCode.abs() % images.length;
    return images[index];
  }
}
