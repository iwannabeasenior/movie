//
// void main() {
//   Dio dio = Dio();
//   final cacheInterceptor1 = DioCacheInterceptor(
//     options: const CacheOptions(
//       store: MemCacheStore(), // Lưu cache trong bộ nhớ RAM
//       policy: CachePolicy.forceCache, // Bắt buộc sử dụng cache
//       hitCacheOnErrorExcept: [401, 403], // Bỏ qua cache nếu có lỗi 401 hoặc 403
//     ),
//   );
//   dio.interceptors.add(cacheInterceptor1);
// }