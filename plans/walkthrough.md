# Walkthrough: Tái cấu trúc Repository thành `self/` và `others/` & Tích hợp CV Su Hẹo

Đã hoàn tất tái cấu trúc toàn bộ repository `public-resources` phân định rõ ràng giữa tài nguyên của tác giả (**`self/`**) và tài nguyên của những người khác (**`others/`**).

---

## 1. Cấu trúc thư mục mới

```text
public-resources/
├── .gitignore                      # Cấu hình bỏ qua file tạm LaTeX & lock files
├── GEMINI.md                       # Tài liệu ngữ cảnh cho AI Agent
│
├── self/                           # TÀI NGUYÊN CỦA TÁC GIẢ (Trần Văn Còn)
│   └── cv-fullstack/               # CV Backend / Cloud
│       ├── convert.sh              # Script build đa định dạng (PDF, PNG, DOCX)
│       └── outputs/
│           ├── cv-fullstack-vi.tex # Bản tiếng Việt (XeLaTeX + Liberation Serif)
│           ├── cv-fullstack-en.tex # Bản tiếng Anh (pdflatex + Charter)
│           └── ...                 # File PDF, DOCX, PNG thành phẩm
│
└── others/                         # TÀI NGUYÊN CỦA NHÂN SỰ KHÁC
    └── suheo/                      # Võ Ngọc Khả Ái (Su Hẹo)
        ├── cv/                     # CV Kỹ sư Hóa học / QA/QC & R&D
        │   ├── build.sh            # Script build XeLaTeX & preview PNG
        │   ├── cv-khaai.tex        # Bản tiếng Việt chuẩn 1 trang A4
        │   ├── cv-khaai-en.tex     # Bản tiếng Anh chuẩn 1 trang A4
        │   ├── cv-vi.tex, cv-en.tex# Các bản chi tiết 2 trang
        │   ├── cvchem*.cls         # LaTeX class templates
        │   └── build/              # PDF & PNG thành phẩm
        │
        └── report/                 # Tài liệu thực tập tại Sơn Hải Vân
            ├── Báo cáo thực tập - Sơn Hải Vân.pptx
            ├── Góp ý của thầy.txt
            ├── Kịch bản thuyết trình (văn nói).docx
            └── pptx-work/
```

---

## 2. Các thay đổi chi tiết

| Mục tiêu | Thao tác thực hiện | Ghi chú |
| :--- | :--- | :--- |
| **CV tác giả** | `git mv cv-fullstack self/cv-fullstack` | Bảo toàn trọn vẹn lịch sử commit Git |
| **CV Su Hẹo** | Tích hợp từ `/home/tvconss/cv-nganh-hoa` vào `others/suheo/cv/` | Lọc sạch file rác `.aux`, `.log`, loại bỏ trùng lặp |
| **Báo cáo Su Hẹo** | `git mv SuHeo others/suheo/report` | Gom chung tài nguyên của Su Hẹo vào `others/suheo/` |
| **Cấu hình Git** | Tạo [`.gitignore`](file:///home/tvconss/Workspace/public-resources/.gitignore) | Tự động bỏ qua file tạm phát sinh khi gõ LaTeX |
| **Ngữ cảnh AI** | Cập nhật toàn diện [`GEMINI.md`](file:///home/tvconss/Workspace/public-resources/GEMINI.md) | Cập nhật cấu trúc thư mục, quy trình build và nguyên tắc |

---

## 3. Kết quả kiểm tra & xác minh

### Hoạt động của script biên dịch:
1. **CV tác giả (`self/cv-fullstack/`):**
   ```bash
   cd self/cv-fullstack && ./convert.sh vi pdf
   ```
   * Kết quả: Biên dịch thành công [`cv-fullstack-vi.pdf`](file:///home/tvconss/Workspace/public-resources/self/cv-fullstack/outputs/cv-fullstack-vi.pdf), **đúng 1 trang A4**.

2. **CV Su Hẹo (`others/suheo/cv/`):**
   ```bash
   cd others/suheo/cv && ./build.sh cv-khaai.tex cv-khaai-en.tex
   ```
   * Kết quả:
     * [`cv-khaai.pdf`](file:///home/tvconss/Workspace/public-resources/others/suheo/cv/build/cv-khaai.pdf): **Đúng 1 trang A4**.
     * [`cv-khaai-en.pdf`](file:///home/tvconss/Workspace/public-resources/others/suheo/cv/build/cv-khaai-en.pdf): **Đúng 1 trang A4**.
     * Tự động sinh ảnh preview: `cv-khaai-page-1.png`, `cv-khaai-en-page-1.png`.

---

## 4. Xem trước hình ảnh CV (Preview)

````carousel
![CV Su Hẹo - Tiếng Việt](/home/tvconss/.gemini/antigravity-cli/brain/84bf4ab4-b024-49c1-9199-bf1ffbd51354/cv-khaai-vi.png)
<!-- slide -->
![CV Su Hẹo - Tiếng Anh](/home/tvconss/.gemini/antigravity-cli/brain/84bf4ab4-b024-49c1-9199-bf1ffbd51354/cv-khaai-en.png)
````
