# GEMINI.md - Hướng dẫn ngữ cảnh cho AI Agent

Tài liệu này cung cấp bối cảnh tổng quan về repository `public-resources` và các quy ước kỹ thuật quan trọng để AI Agent (như Gemini / Antigravity) hiểu và làm việc chính xác ngay từ đầu.

---

## 1. Giới thiệu Repository (`public-resources`)

* **Chủ sở hữu:** Trần Văn Còn (`tvconss` / `tranconcoder` | `tranvanconkg@gmail.com`).
* **Mục đích:** Kho lưu trữ các tài nguyên công khai cá nhân, bao gồm CV chuyên nghiệp (Backend Developer), báo cáo thực tập, slide thuyết trình và các tài nguyên liên quan.

### Cấu trúc thư mục chính:
* `cv-fullstack/`: Mã nguồn LaTeX của CV, kịch bản build đa định dạng và các sản phẩm đầu ra (PDF, PNG, DOCX).
* `SuHeo/`: Tài liệu báo cáo thực tập tại công ty Sơn Hải Vân (slide PPTX, kịch bản thuyết trình, ghi chú).

---

## 2. Dự án CV Fullstack / Backend (`cv-fullstack`)

Hồ sơ chuyên môn của tác giả định vị ở vai trò **Backend Developer (Node.js / TypeScript)** với kinh nghiệm thực tế về Serverless trên AWS, High-Concurrency, DDD, Hexagonal Architecture.

### Hai phiên bản ngôn ngữ (EN & VI):
CV bắt buộc phải duy trì và hỗ trợ build song song **2 phiên bản riêng biệt**:

1. **Phiên bản Tiếng Anh (English - EN):**
   * File nguồn: `cv-fullstack/outputs/cv-fullstack-en.tex` (đồng bộ với `cv-fullstack/outputs/cv-fullstack.tex`).
   * Engine biên dịch: `pdflatex`.
   * Bộ font: Bitstream Charter (`\usepackage{charter}`), `microtype`.
   * Tên ứng viên: *Tran Van Con*.

2. **Phiên bản Tiếng Việt (Vietnamese - VI):**
   * File nguồn: `cv-fullstack/outputs/cv-fullstack-vi.tex`.
   * Engine biên dịch: `xelatex` (bắt buộc dùng XeLaTeX vì pdflatex trên môi trường NixOS hiện tại thiếu gói T5 vntex).
   * Bộ font: `Liberation Serif` qua gói `fontspec` (đảm bảo hiển thị chuẩn xác 100% tiếng Việt có dấu, không thiếu glyphs).
   * Tên ứng viên: *Trần Văn Còn*.

> [!IMPORTANT]
> **Quy chuẩn hiển thị:**
> Cả 2 phiên bản bắt buộc phải được căn chỉnh độ dài text và khoảng cách để nằm trọn vẹn trong **đúng 1 trang A4** (không để tràn sang trang thứ 2). Giữ nguyên bảng màu nhận diện thương hiệu cá nhân (`accentcolor`: RGB `0, 100, 100`).

---

## 3. Quy trình Build & Chuyển đổi (`convert.sh`)

Script `cv-fullstack/convert.sh` chịu trách nhiệm biên dịch và chuyển đổi mã nguồn LaTeX thành các định dạng:
* **PDF** (via `pdflatex` / `xelatex`)
* **PNG** (ảnh trang chất lượng cao via `pdftoppm`)
* **Word (.docx)** (via `pandoc`, có strip các TeX-isms không tương thích)

### Hướng dẫn sử dụng `convert.sh`:
Chạy từ thư mục `cv-fullstack/`:

```bash
# Build cả 2 phiên bản (EN & VI) sang toàn bộ định dạng (PDF, PNG, DOCX)
./convert.sh all

# Mặc định không tham số tương đương với './convert.sh all'
./convert.sh

# Chỉ build bản Tiếng Việt
./convert.sh vi

# Chỉ build bản Tiếng Anh
./convert.sh en

# Build phiên bản cụ thể với định dạng mong muốn (pdf | png | docx | all)
./convert.sh vi pdf    # Chỉ tạo PDF tiếng Việt
./convert.sh vi docx   # Chỉ tạo Word tiếng Việt
./convert.sh en png    # Chỉ tạo ảnh PNG tiếng Anh

# Build file .tex tùy biến
./convert.sh outputs/cv-fullstack-vi.tex all
```

### File đầu ra trong `cv-fullstack/outputs/`:
* **Tiếng Việt:** `cv-fullstack-vi.pdf`, `cv-fullstack-vi.docx`, `cv-fullstack-vi-1.png`.
* **Tiếng Anh:** `cv-fullstack-en.pdf` (và `cv-fullstack.pdf`), `cv-fullstack-en.docx`, `cv-fullstack-en-1.png`.

---

## 4. Nguyên tắc dành cho AI Agent khi can thiệp mã nguồn

1. **Đồng bộ song ngữ:** Khi có yêu cầu cập nhật thông tin kinh nghiệm, kỹ năng hoặc dự án mới trong CV, hãy chủ động cập nhật cả 2 file `cv-fullstack-en.tex` và `cv-fullstack-vi.tex`.
2. **Kiểm tra độ dài trang:** Luôn biên dịch thử và kiểm tra số trang (`pdfinfo outputs/*.pdf | grep Pages`). Nếu bị nhảy sang trang 2, phải cô đọng lại từ ngữ hoặc tinh chỉnh `vspace`/`parskip` để đưa về đúng 1 trang A4.
3. **Engine tương thích:** Bản tiếng Việt luôn giữ gói `fontspec` và biên dịch bằng `xelatex`. Không đổi sang `pdflatex` cho bản tiếng Việt để tránh lỗi font chữ tiếng Việt Unicode.
4. **Sinh lại artifact:** Sau khi sửa mã nguồn `.tex`, chạy `./convert.sh all` để cập nhật đồng bộ các file `.pdf`, `.png` và `.docx`.
