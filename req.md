# LAB 2 (PRM392) — Xây dựng UI ứng dụng MoMo (Flutter)

**Nguyên văn yêu cầu của giảng viên:**

> Xây dựng UI cho một số màn hình (tối thiểu 4 màn hình) tương tự như các dịch vụ có trong MoMo.
> VD:
> 1/ Home screen: liệt kê các dịch vụ và cho phép chuyển tiếp tới screen ứng với dịch vụ
> 2/ Chọn dịch vụ "Thanh toán hóa đơn" chuyển tiếp screen liệt kê danh sách các dịch vụ thanh toán hóa đơn
> 3/ Chọn dịch vụ thanh toán hóa đơn điện => chuyển tiếp screen tương ứng; chọn dịch vụ thanh toán hóa đơn nước => chuyển tiếp screen tương ứng
> Yêu cầu: Phải có text và image icon tương ứng cho mỗi dịch vụ. Cho phép quay lui (back) về screen trước.
> * Thời gian: 11:15

---

## 1. Phân tích yêu cầu — các điểm gốc còn mơ hồ và cách chốt

| # | Yêu cầu gốc | Vấn đề | Chốt cho bài lab |
| :-- | :-- | :-- | :-- |
| 1 | "tối thiểu 4 màn hình" | không nói là 4 màn hình nào | Làm **5 màn hình**, bám đúng luồng ví dụ của đề (bảng mục 3) |
| 2 | "image icon tương ứng cho mỗi dịch vụ" | chưa rõ ảnh asset hay icon font | Dùng **`Icon` (Material Icons)** + nền tròn màu → đủ text + icon, **không cần file ảnh**. Nếu giảng viên bắt buộc ảnh thật: thêm `assets/images/<service>.png` + khai báo `assets:` trong `pubspec.yaml` (chỉ đổi 2 dòng, không đổi cấu trúc) |
| 3 | "screen tương ứng" | chưa rõ trong màn hình đó có gì | Mỗi màn hình dịch vụ là **form nhập liệu giả lập** (mã khách hàng, kỳ hóa đơn, số tiền) + nút Thanh toán → màn hình kết quả |
| 4 | Nguồn dữ liệu | chưa nói | **Dữ liệu giả lập dạng `const List` trong Dart**, không gọi API, không backend |
| 5 | "Thanh toán" | chưa rõ có xử lý thật không | Chỉ **mô phỏng**: bấm nút → chuyển sang màn hình kết quả thành công, không trừ tiền, không lưu DB |
| 6 | Không nói sản phẩm nộp gì | thiếu deliverable | Code + ảnh chụp từng màn hình + `docs/Lab2_Report.md` (theo format Lab 1) |

**Ngoài phạm vi (không làm):** đăng nhập/OTP, gọi API thật, ví điện tử thật, animation phức tạp, localization, test tích hợp.

---

## 2. Phạm vi & tiêu chí nghiệm thu

- App Flutter (Material 3), chạy được trên emulator/Chrome: `flutter run`.
- Có **≥ 5 màn hình**, mỗi dịch vụ có **text + icon**, mọi màn hình con **back được** về màn hình trước (AppBar Back + nút Back cứng Android).
- `flutter analyze` **0 warning/error**.
- Không thêm package bên thứ ba (chỉ dùng SDK + `cupertino_icons` có sẵn).

---

## 3. Sơ đồ màn hình & điều hướng

| # | Màn hình | Route | Nội dung | Từ đâu tới |
| :-- | :-- | :-- | :-- | :-- |
| 1 | Home | `/` | Số dư ví (giả lập), ô tìm kiếm, **grid dịch vụ** (icon + text): Thanh toán hóa đơn, Nạp tiền điện thoại, Chuyển tiền, Nạp thẻ, Vé tàu, Vay tiền... | App khởi động |
| 2 | Danh sách dịch vụ thanh toán hóa đơn | `/bill-payment` | **list** các dịch vụ: Điện, Nước, Internet, Truyền hình, Điện thoại trả sau, Học phí | Chọn "Thanh toán hóa đơn" ở Home |
| 3 | Thanh toán hóa đơn **Điện** | `/bill-payment/electricity` | Form: mã khách hàng (EVN), kỳ hóa đơn, số tiền; nút "Thanh toán" | Chọn "Điện" ở màn 2 |
| 4 | Thanh toán hóa đơn **Nước** | `/bill-payment/water` | Form: mã khách hàng (cấp nước), kỳ hóa đơn, số tiền; nút "Thanh toán" | Chọn "Nước" ở màn 2 |
| 5 | Kết quả thanh toán | `/result` | Icon thành công, số tiền, mã giao dịch, thời gian; nút "Về trang chủ" | Bấm "Thanh toán" ở màn 3 hoặc 4 |

Luồng: `Home → BillPayment → Electricity|Water → Result → (Home)`. Màn 2,3,4 chọn đúng dịch vụ nào thì mở màn tương ứng (dùng **một** widget form dùng chung, truyền tham số tên/icon/đơn vị — không copy-paste 2 màn hình).

**Điều hướng:** `Navigator.pushNamed` + `routes` trong `MaterialApp` (không cần `go_router` cho bài này). Tham số truyền qua `ModalRoute`/`arguments`.

---

## 4. Quy ước UI

- **Màu:** lấy từ quy chuẩn MoMo đã crawl về `docs/momo-design-guideline/tokens.md` — Primary `#D82D8B`, Secondary `#FFD6E7`, chữ `#303233`, hint `#727272`, nền/disable `#F9F9F9`, success `#52C41A`, error `#F5222D`. Khai báo trong `theme/app_theme.dart` dưới dạng hằng số, không hard-code rải rác.
- **Spacing:** bội số của 4 — lề ngang màn hình 16, khoảng cách phần tử 12 (đúng quy chuẩn MoMo).
- **Style:** card bo góc 12–16, icon trong hình tròn nền nhạt `#FFD6E7`, tiêu đề đậm 16–18sp, phụ đề xám 12–13sp.
- **Icon:** mỗi dịch vụ là 1 `IconData` khác nhau, ví dụ Điện `Icons.bolt`, Nước `Icons.water_drop`, Internet `Icons.wifi`, Truyền hình `Icons.tv`, Điện thoại `Icons.phone_android`, Học phí `Icons.school`, Chuyển tiền `Icons.send`, Nạp thẻ `Icons.credit_card`.
- **Touch target ≥ 44×44dp**, có phản hồi khi nhấn (`InkWell`).
- Chi tiết style/UX: dùng skill `ui-ux-pro-max` (đã cài) khi cần tra guideline.

---

## 5. Cấu trúc mã nguồn

Tạo project Flutter **tại thư mục gốc repo** (tên package `momo_ui_lab`): `flutter create .`

```
lib/
  main.dart                     # MaterialApp + routes + theme MoMo
  models/service_item.dart      # ServiceItem(icon, label, route)
  data/mock_services.dart       # danh sách dịch vụ Home + danh sách hóa đơn
  theme/app_theme.dart          # màu, hằng số style
  screens/home_screen.dart
  screens/bill_payment_screen.dart
  screens/bill_form_screen.dart # dùng chung cho Điện/Nước (nhận tham số)
  screens/result_screen.dart
test/navigation_test.dart       # 1 test: tap "Thanh toán hóa đơn" → thấy màn danh sách
docs/Lab2_Report.md
docs/screenshots/
```

Skill `flutter-apply-architecture-best-practices` (đã cài) chỉ áp dụng phần UI + data tách lớp ở mức vừa đủ; **không** dựng thêm lớp Logic/Repository vì không có API.

---

## 6. Deliverables

1. Source code chạy được: `flutter run` (khuyến nghị evidence trên Chrome + Android emulator).
2. `docs/screenshots/` với **đúng các tên file**:
   `home_screen.png`, `bill_payment_list.png`, `electricity_screen.png`, `water_screen.png`, `result_screen.png`, `back_navigation.png`.
3. `docs/Lab2_Report.md`: mục tiêu, sơ đồ điều hướng, mô tả từng màn hình, ảnh nhúng, phần "khó khăn & cách xử lý".
4. README ngắn ở gốc: cách chạy app.

---

## 6.1. Tham chiếu thiết kế MoMo (đã crawl)

Toàn bộ Quy chuẩn thiết kế Mini App của MoMo đã lưu offline tại `docs/momo-design-guideline/`:

- `tokens.md` — **đọc file này trước** khi code UI (màu, spacing, lưới, kích thước icon).
- 11 trang gốc dạng markdown + 31 ảnh spec trong `assets/` + `assets/design-guideline-checklist.pdf`.
- Lưu ý: đây là quy chuẩn cho **Mini App đối tác** — dùng làm chuẩn tham chiếu cho bài lab, không phải design system nội bộ của app MoMo.

---

## 7. Checklist kiểm thử (tự chấm trước khi nộp)

- [ ] App mở ra màn Home, thấy đủ dịch vụ, mỗi ô có **text + icon**.
- [ ] Tap "Thanh toán hóa đơn" → màn danh sách hóa đơn (Điện, Nước, Internet...).
- [ ] Tap "Điện" → màn thanh toán điện; tap "Nước" → màn thanh toán nước (khác nhau về tên/icon/đơn vị).
- [ ] Bấm "Thanh toán" → màn kết quả, số tiền hiển thị đúng như đã nhập.
- [ ] Từ màn kết quả/màn form, nút Back (và phím Back Android) quay lui **từng bước** về Home, không thoát app giữa đường.
- [ ] Không có overflow đỏ khi xoay ngang hoặc màn nhỏ.
- [ ] `flutter analyze` sạch; `flutter test` pass.

---

## 8. Thời gian

- Slot thực hành/ báo cáo: **11:15**. Nộp: code + `docs/` trước khi hết slot.

---

## 9. Skill đã cài cho bài này (project-level, `.agents/skills/`)

| Skill | Dùng khi |
| :-- | :-- |
| `flutter-apply-architecture-best-practices` | Chia lớp UI/data, đặt tên thư mục |
| `flutter-build-responsive-layout` | Grid Home co giãn theo màn hình (điện thoại/tablet/web) |
| `flutter-fix-layout-issues` | Sửa `RenderFlex overflowed`, `unbounded height` |
| `flutter-add-widget-test` | Viết `test/navigation_test.dart` |
| `dart-run-static-analysis` | Chạy/đọc kết quả `flutter analyze` |
| `ui-ux-pro-max` (global) | Tra palette, guideline UX, checklist trước khi nộp |
