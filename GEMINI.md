# GEMINI.md - Hướng dẫn ngữ cảnh cho AI Agent

Tài liệu này cung cấp bối cảnh tổng quan về repository `public-resources` và các quy ước kỹ thuật quan trọng để AI Agent (như Gemini / Antigravity) hiểu và làm việc chính xác ngay từ đầu.

---

## 1. Giới thiệu Repository (`public-resources`)

* **Chủ sở hữu:** Trần Văn Còn (`tvconss` / `tranconcoder` | `tranvanconkg@gmail.com`).
* **Mục đích:** Kho lưu trữ các tài nguyên công khai cá nhân, bao gồm CV chuyên nghiệp (Backend Developer), báo cáo thực tập, slide thuyết trình và các tài nguyên liên quan của tác giả và các nhân sự liên quan.

### Cấu trúc phân vùng chính (`self/` & `others/`):
* **`self/`**: Tài nguyên cá nhân của tác giả (Trần Văn Còn).
  * `self/cv-fullstack/`: Mã nguồn LaTeX của CV Backend Developer, kịch bản build đa định dạng và các sản phẩm đầu ra (PDF, PNG, DOCX).
* **`others/`**: Tài nguyên của những người khác ("mấy người kia").
  * `others/suheo/`: Tài nguyên của Võ Ngọc Khả Ái (Su Hẹo):
    * `others/suheo/cv/`: Mã nguồn LaTeX của CV Kỹ sư Công nghệ Kỹ thuật Hóa học / QA/QC & R&D, kịch bản build và sản phẩm PDF/PNG.
    * `others/suheo/report/`: Tài liệu báo cáo thực tập tại công ty Sơn Hải Vân (slide PPTX, kịch bản thuyết trình, ghi chú).

---

## 2. Dự án CV Fullstack / Backend (`self/cv-fullstack`)

Hồ sơ chuyên môn của tác giả định vị ở vai trò **Backend Developer (Node.js / TypeScript)** với kinh nghiệm thực tế về Serverless trên AWS, High-Concurrency, DDD, Hexagonal Architecture.

### Hai phiên bản ngôn ngữ (EN & VI):
CV bắt buộc phải duy trì và hỗ trợ build song song **2 phiên bản riêng biệt**:

1. **Phiên bản Tiếng Anh (English - EN):**
   * File nguồn: `self/cv-fullstack/outputs/cv-fullstack-en.tex` (đồng bộ với `self/cv-fullstack/outputs/cv-fullstack.tex`).
   * Engine biên dịch: `pdflatex`.
   * Bộ font: Bitstream Charter (`\usepackage{charter}`), `microtype`.
   * Tên ứng viên: *Tran Van Con*.

2. **Phiên bản Tiếng Việt (Vietnamese - VI):**
   * File nguồn: `self/cv-fullstack/outputs/cv-fullstack-vi.tex`.
   * Engine biên dịch: `xelatex` (bắt buộc dùng XeLaTeX vì pdflatex trên môi trường NixOS hiện tại thiếu gói T5 vntex).
   * Bộ font: `Liberation Serif` qua gói `fontspec` (đảm bảo hiển thị chuẩn xác 100% tiếng Việt có dấu, không thiếu glyphs).
   * Tên ứng viên: *Trần Văn Còn*.

> [!IMPORTANT]
> **Quy chuẩn hiển thị:**
> Cả 2 phiên bản bắt buộc phải được căn chỉnh độ dài text và khoảng cách để nằm trọn vẹn trong **đúng 1 trang A4** (không để tràn sang trang thứ 2). Giữ nguyên bảng màu nhận diện thương hiệu cá nhân (`accentcolor`: RGB `0, 100, 100`).

---

## 3. Quy trình Build & Chuyển đổi (`self/cv-fullstack/convert.sh`)

Script `self/cv-fullstack/convert.sh` chịu trách nhiệm biên dịch và chuyển đổi mã nguồn LaTeX thành các định dạng:
* **PDF** (via `pdflatex` / `xelatex`)
* **PNG** (ảnh trang chất lượng cao via `pdftoppm`)
* **Word (.docx)** (via `pandoc`, có strip các TeX-isms không tương thích)

### Hướng dẫn sử dụng `convert.sh`:
Chạy từ thư mục `self/cv-fullstack/`:

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

### File đầu ra trong `self/cv-fullstack/outputs/`:
* **Tiếng Việt:** `cv-fullstack-vi.pdf`, `cv-fullstack-vi.docx`, `cv-fullstack-vi-1.png`.
* **Tiếng Anh:** `cv-fullstack-en.pdf` (và `cv-fullstack.pdf`), `cv-fullstack-en.docx`, `cv-fullstack-en-1.png`.

---

## 4. Dự án CV Ngành Hóa / QA/QC & R&D (`others/suheo/cv`)

Hồ sơ chuyên môn của **Võ Ngọc Khả Ái (Su Hẹo)** định vị ở vai trò **Kỹ sư Công nghệ Kỹ thuật Hóa học --- QA/QC & R&D**, chuyên ngành hóa hữu cơ, có kinh nghiệm thực tế tại nhà máy Sơn Hải Vân (vận hành thiết bị đo cơ lý tính màng sơn, quy trình IQC/IPQC/FQC theo ISO 9001:2015).

### Các phiên bản chính:
1. **Phiên bản Tiếng Việt chuẩn 1 trang:**
   * File nguồn: `others/suheo/cv/cv-khaai.tex`.
   * Engine biên dịch: `xelatex`.
   * Bộ font: `Liberation Serif` qua gói `fontspec` (hiển thị chuẩn tiếng Việt).
   * Layout: 1 cột tinh gọn chuẩn ATS, co giãn tự động lấp đầy trọn vẹn đúng **1 trang A4** (`plus ...fil`).
   * Tên ứng viên: *Võ Ngọc Khả Ái*.
   * Màu nhấn: `#0E7C6B` (lục thẫm).

2. **Phiên bản Tiếng Anh chuẩn 1 trang:**
   * File nguồn: `others/suheo/cv/cv-khaai-en.tex`.
   * Engine biên dịch: `xelatex` hoặc `pdflatex`.
   * Bộ font: Bitstream Charter (`\usepackage{charter}`).
   * Layout: Tương tự bản tiếng Việt, chuẩn 1 trang A4.
   * Tên ứng viên: *Vo Ngoc Kha Ai*.

3. **Các biến thể khác:**
   * `cv-vi.tex`, `cv-en.tex`: Bản chi tiết 2 trang theo phong cách tạp chí hóa học (dùng class `cvchem.cls`).
   * `cv-v1-blue.tex` đến `cv-v5-minimal.tex`, `cv-classic.tex`: Các phiên bản biến thể thiết kế, sidebar và bảng màu.

### Hướng dẫn sử dụng `build.sh`:
Chạy từ thư mục `others/suheo/cv/`:

```bash
# Build tất cả các file cv-*.tex sang PDF và PNG preview
./build.sh

# Chỉ build bản Tiếng Việt chuẩn 1 trang
./build.sh cv-khaai.tex

# Chỉ build bản Tiếng Anh chuẩn 1 trang
./build.sh cv-khaai-en.tex

# Chế độ watch tự động re-build khi lưu file (cần entr hoặc cơ chế poll tự động)
./build.sh -w cv-khaai
```

### File đầu ra trong `others/suheo/cv/build/`:
* File PDF: `cv-khaai.pdf`, `cv-khaai-en.pdf`, `cv-vi.pdf`, ...
* Ảnh PNG preview: `cv-khaai-page-1.png`, `cv-khaai-en-page-1.png`, ...

---

## 5. Nguyên tắc dành cho AI Agent khi can thiệp mã nguồn

1. **Đồng bộ song ngữ:** Khi có yêu cầu cập nhật thông tin kinh nghiệm, kỹ năng hoặc dự án mới trong CV (cả `self/cv-fullstack` lẫn `others/suheo/cv`), hãy chủ động cập nhật cả 2 file tiếng Anh và tiếng Việt tương ứng.
2. **Kiểm tra độ dài trang:** Luôn biên dịch thử và kiểm tra số trang (`pdfinfo outputs/*.pdf | grep Pages` hoặc `pdfinfo others/suheo/cv/build/cv-khaai*.pdf | grep Pages`). Các bản chuẩn (`cv-fullstack-*.tex`, `cv-khaai*.tex`) bắt buộc phải nằm trọn vẹn trong **đúng 1 trang A4**.
3. **Engine tương thích:** Các file tiếng Việt luôn dùng gói `fontspec` và biên dịch bằng `xelatex` để hiển thị đầy đủ dấu tiếng Việt Unicode không bị lỗi font.
4. **Sinh lại artifact & dọn dẹp:**
   * Với `self/cv-fullstack/`: Chạy `./convert.sh all` sau khi sửa mã nguồn `.tex`.
   * Với `others/suheo/cv/`: Chạy `./build.sh <file.tex>` sau khi sửa mã nguồn `.tex`.
   * Không commit các file phụ trợ của LaTeX (`.aux`, `.log`, `.build.log`) hay lock file vào Git.
