# ⚡ ThorUi v2 — Roblox UI Library bertema Dewa Petir

> UI library untuk Roblox dengan tema **Thor / Dewa Petir**: gelap, snappy, dan elektrik.
> **v2.3.0 — RILIS FITUR BESAR: STATE BINDING antar-elemen (ubah satu slider, elemen lain ikut — dua arah) + DEPENDS (baris otomatis muncul/sembunyi mengikuti nilai elemen lain) + SUB-ROW `Element:AddChild()` (elemen bertingkat di dalam kartu induk) + SLIDER MULTI-SATUAN dengan konversi otomatis (m ↔ km) & ketik nilai eksak + BUTTON klik dua tahap (ConfirmText) + DROPDOWN pencarian & mode Apply & kelola opsi runtime + LIST browser item (cari/grup/pilih/badge) + MODELVIEW etalase 3D dengan putaran otomatis + CANVAS dashboard mini + GROUP radio toggles + QUICK ACTION tombol melayang + `ThorUi:SetTheme()`** — semua tetap 100% murni script tanpa Asset ID. v2.2.3: ukuran default rada persegu dihitung dari dimensi layar aktual (dijamin muat di semua perangkat) + v2.2.2: panah digambar (fix kotak tofu), semua section mulai terlipat, drag window bebas tanpa batas + v2.2.1: menu (section) bisa di-minimize + v2.2.0: optimasi performa menyeluruh.
> Dukungan penuh **PC & Mobile** · Window *draggable* & *resizable* · **100% murni script** (tanpa Asset ID eksternal) · **Anti memory-leak**

| | |
|---|---|
| **Versi** | 2.3.0 |
| **Tipe** | ModuleScript tunggal (Luau), tanpa dependensi |
| **Platform** | PC (Mouse + Keyboard) & Mobile (Touch) |
| **Aset** | `Instance.new` / `UICorner` / `UIStroke` / `UIGradient` saja — anti asset takedown |

---

## 🌩️ Fitur Unggulan

### Baru di v2.0.0 (tampilan modern)

- **Splash screen** — layar pembuka dengan logo ⚡ memantul, progress bar petir, dan status menggemas ("Memanggil petir...", "Menempa Mjolnir..."). Muncul otomatis sekali per sesi, bisa dimatikan dengan `Splash = false`.
- **Sidebar tab vertikal** — tab ber-ikon di sisi kiri, dengan indikator petir yang "menyambar" saat tab aktif. Saat window sempit (< 430px), sidebar otomatis menyusut jadi icon-only.
- **Search bar** — kotak pencarian di header yang memfilter elemen tab aktif secara real-time. Ketik "toggle" → hanya elemen bernama toggle yang tampil.
- **ColorPicker** — picker warna lengkap: kotak Saturasi-Value + slider Hue pelangi + tampilan HEX/RGB, semuanya digambar murni dengan `UIGradient` (tanpa aset gambar).
- **Confirm dialog** — modal konfirmasi overlay dengan animasi pop + fade; klik area gelap = batal.
- **Toggle switch** — toggle didesain ulang jadi switch modern: track memanjang + knob bulat meluncur dengan easing Back.

### Perbaikan di v2.0.1

- **Ikon ⚡ bebas digeser** — drag ke mana pun, ikon **tetap di posisi terakhir** (tanpa snap ke tepi; hanya di-clamp agar tidak keluar layar). Ketuk = buka/tutup UI.
- **Fix minimize terkunci** — saat window di-minimize (tombol `—`), kini muncul tombol **`+` di bawah sidebar** untuk membesarkan kembali ke ukuran semula (ukuran & posisi tersimpan aman, tahan rotasi layar).
- **Fix error `SetToggleVisible`** — metode `ThorUi:SetToggleVisible()` / `SetKeybind()` / `Toggle()` yang hilang saat port v2 kini tersedia kembali.
- **Anti UI menumpuk saat re-execute** — ScreenGui ThorUi lama otomatis dibersihkan saat library dimuat ulang, jadi tombol ⚡ & window tidak dobel.

### Perbaikan di v2.1.0 (audit input menyeluruh)

- **FIX ikon ⚡ "loncat-loncat"** — akar masalahnya: posisi awal gesture dihitung dari objek `InputObject` yang **terus termutasi** di touch, sehingga delta selalu 0 — ikon tidak bergeser dan lepas jari malah memicu toggle window. Kini posisi di-*snapshot* sebagai nilai (`Vector3`/`Vector2`) → drag presisi & mulus di mouse maupun jari, anchor ikon tidak pernah diubah saat drag.
- **Window anti-hilang** — drag window kini di-*clamp*: minimal 56px sisi window dan 30px baris judul selalu tetap terlihat di layar, jadi window tidak bisa tersesat ke luar layar.
- **Tap beruntun makin responsif** — `Show`/`Hide`/`Toggle` kini pakai flag `_closing`: tap ⚡ saat window sedang menutup langsung membatalkan hide dan memunculkan kembali (dulu tap "tertelan").
- **Slider mobile-friendly** — baris slider ditinggikan 28px + *hit-area* transparan menutupi seluruh baris: tidak perlu membidik track 6px dengan jari; tap di mana pun pada baris langsung mengatur nilai.
- **Target sentuh lebih besar** — tombol kontrol header (—/✕) 28→32px, handle resize 28→34px, ukuran font ikon kontrol 14→16.
- **Hygiene memory** — koneksi `Completed` pada efek `Zap`/`popScale` kini ikut terlacak di `Registry` (auto-disconnect saat destroy).
- **Audit ulang seluruh handler input** — window drag, resize grip, slider, dan ColorPicker sudah benar (delta dihitung dari snapshot nilai); dropdown multi mem-*snapshot* nilai sebelum callback; toggle tap-entuh-card.

### Perbaikan di v2.1.1 (audit tata letak + keterangan elemen)

- **Description di SEMUA elemen** — sebelumnya config `Description` diabaikan total ("keterangan slider dll tidak kelihatan"). Kini setiap elemen (Button, Toggle, Slider, Dropdown, TextInput, Keybind, ColorPicker, Section) menerima `cfg.Description` → teks keterangan kecil terbaca di bawah judul, otomatis membungkus teks panjang, dan bisa diubah kapan pun lewat `Element:SetDescription("teks")`.
- **FIX ikon ⚡ loncat setiap kali diklik** — akar masalah: posisi awal gesture dibaca dari `AbsolutePosition` lalu ditulis ke `Position`; di sebagian lingkungan (CoreGui/executor/DPI mobile) keduanya berbeda basis koordinat → ikon melompat dulu baru bisa digeser. Kini konversinya meniru formula engine sendiri (`Scale × ukuran parent + Offset`) → identitas visual terjamin, **nol loncatan saat ditekan**. Anchor ikon dipindah ke pusat (0.5, 0.5) sehingga animasi pop & efek "digenggam" menyala simetris dari tengah (dulu membesar ke kanan-bawah, terlihat seperti terloncat).
- **FIX snapshot (0,0)** — sebagian executor melaporkan `InputBegan` sentuhan di (0,0) yang membuat ikon melayang lintas layar; snapshot mencurigakan kini otomatis diambil ulang dari gerakan pertama.
- **FIX tombol minimize "—" tidak pada tempatnya** — tepi kanan search bar dikurangi agar tidak menimpa area tombol kontrol; tombol `—` dan `✕` kini berdampingan rapi di ujung kanan header.
- **FIX ikon tab di sidebar icon-only** — saat window sempit, ikon tab otomatis di tengah tombol (dulu menempel di kiri); glyph emoji di-*nudge* +1-2px agar tidak "melayang" ke atas.
- **FIX ColorPicker slider hue via sentuhan** — dulu slider hue hanya bisa digeser mouse; kini jari juga bisa (filter gesture source-lock).
- **Gesture source-lock menyeluruh** — drag window, resize, slider, dan ikon ⚡ mengunci sumber input saat gesture dimulai: di perangkat *hybrid* (PC layar sentuh / tablet + mouse) posisi mouse yang menetap tidak lagi bikin UI meloncat; jari kedua tidak mengganggu drag yang sedang berjalan.
- **Sentuhan mobile makin nyaman** — nilai slider tidak terpotong (`TextTruncate`), baris opsi dropdown 24→28px, kartu Confirm dialog auto-fit di layar sempit.

### Baru di v2.3.0 (rilis fitur besar — semua tetap tema Thor, nol aset)

| Fitur | Ringkasan |
|---|---|
| **State + Binding** | `ThorUi:CreateState()` — satu nilai bersama untuk banyak elemen; ubah salah satu, semuanya ikut (dua arah, bebas echo/loop). Mendukung transformasi nilai per-elemen (`ToState`/`ToOption`). |
| **Depends** | Baris elemen muncul/sembunyi OTOMATIS mengikuti nilai elemen/state lain: `Depends = { Element = toggleX, Value = true }` — bisa dirantai & diganti runtime (`:SetDependency` / `:ClearDependency`). |
| **Sub-row `AddChild`** | Elemen bertingkat! `toggle:AddChild("Slider", {...})` — anak tampil terinden di dalam kartu induk dengan garis pemandu petir + chevron lipat; semua tipe elemen didukung. |
| **Slider multi-satuan** | `Units` dengan konversi otomatis (`FromBase`/`ToBase`, mis. m ↔ km), chip pemilih satuan, angka emas + satuan redup (RichText), **klik angka untuk mengetik nilai eksak**, setter runtime (`:SetRange` `:SetDecimals` `:SetIncrement` `:SetSuffix` `:SetUnit`). |
| **Button 2 tahap** | `ConfirmText` — klik pertama menegangkan (teks berubah jadi konfirmasi), klik kedua eksekusi; batal otomatis 2.5 detik. |
| **Dropdown ++** | `Search` (filter opsi), `ApplyButton` (mode aksi: pilih dulu lalu Apply → `callback(nilai, indeks)`), kelola opsi runtime (`:SetValues` `:AddValue` `:RemoveValue` `:Filter`). |
| **List (baru)** | Browser item: pencarian, grup, multi-pilih, badge kanan (`TopRight`), gambar opsional milik user, `OnItemClick`. |
| **ModelView (baru)** | Etalase 3D `ViewportFrame` — kamera auto-frame, putaran otomatis (Spin), objek dibersihkan dari efek/scripts. Tanpa model → **palu petir geometris bawaan** (murni Part — tetap nol aset!). |
| **Canvas (baru)** | Dashboard mini deklaratif: `Text` / `Bar` / `Button` / `Divider` + update runtime `dash:Set(nama, props)`. |
| **Group (radio)** | `ThorUi:CreateGroup()` + `AddToggle({..., Group = g})` — maksimal satu toggle aktif dalam grup. |
| **Quick Action** | `ThorUi:AddQuickAction({Icon, Name, Callback})` — deret tombol bundar melayang yang bisa digeser; pintasan selalu terlihat walau window tertutup. |
| **`SetTheme()`** | Pengganti edit `ThorUi.Theme` manual — merge patch tema (tetap dipanggil **sebelum** `CreateWindow`). |

### Baru di v2.2.3 (dari permintaan: "ukuran default bikin rada persegi, jangan terlalu wide; drag bebas belum work — window langsung kepotong padahal belum sampai pinggir layar")

- **Ukuran default RADA PERSEGU** — window tidak lagi terlalu lebar: rasio akhir selalu antara 1:1 dan 1.15:1, dihitung murni dari **dimensi layar aktual**: lebar = terkecil dari `440px` / 86% lebar layar / 62% tinggi layar; tinggi = terkecil dari `390px` / 62% tinggi layar / 1.15× lebar. Layar lebar (PC/landscape) terbuka di **440 × 390**, layar hp portrait proporsional mengikuti layar — tidak lagi memanjang seperti pita. Tetap bisa di-resize / di-minimize / diatur sendiri lewat `Size` & `MinSize`.
- **FIX "window langsung terpotong padahal belum sampai pinggir layar"** — akarnya **bukan** clamp drag (drag window memang sudah nol clamp sejak v2.2.2), melainkan ukuran default yang dipilih lewat **deteksi `MouseEnabled`**: sebagian Android / emulator / executor melaporkan `MouseEnabled = true` walau perangkat tanpa mouse → ThorUi salah mengambil default PC **540 px** yang lebih lebar dari layar HP → window tampak terpotong di kedua sisi sejak muncul. Kini ukuran default dihitung **murni dari dimensi viewport** → dijamin muat di semua perangkat, selalu menyisakan margin terlihat di semua sisi, dan `IsMobile()` dihapus dari logika sizing.
- **Margin anti-nempel** — auto-clamp `MinSize` untuk layar kecil diperlebar (margin 20 → 56px): window di layar kecil pun tetap berjarak nyaman dari tepi layar, jadi drag tidak langsung menabrak tepi.
- **Sidebar tetap menampilkan nama tab** — ambang icon-only diturunkan 520 → 430px: default persegu 440px tetap memunculkan nama tab; hanya layar benar-benar sempit (hp portrait) yang otomatis icon-only.

### Baru di v2.2.2 (dari permintaan: "AddSection jangan kotak — ganti anak panah; drag jangan ada batas; semua section tutup saat pertama execute; UI jangan terlalu gede")

- **Panah ASLI (DIGAMBAR, bukan glyph)** — akar "kotak" di judul section ternyata glyph unicode `▾` (U+25BE) yang **tidak tersedia di font Roblox (Gotham)**, sehingga dirender sebagai **kotak kosong (tofu)** di sebagian perangkat. Panah lipat section & panah dropdown kini **DIGAMBAR dari 2 batang miring** (geometri murni `Instance.new` — tanpa font, tanpa Asset ID): **dijamin tampil sebagai panah di semua perangkat**, tetap beranimasi berputar (0° = terbuka ↔ -90° = terlipat).
- **Semua section MULAI TERLIPAT** — saat pertama execute, semua menu tampil dalam keadaan TERTUTUP supaya daftar fitur langsung rapi; klik judulnya untuk membuka. Default `Collapsed` kini `true` — beri `Collapsed = false` agar menu tertentu mulai terbuka.
- **Drag window TANPA BATAS** — window bisa digeser bebas keluar layar (kiri/kanan/atas/bawah — nol clamp; dulu di-clamp minimal 56px terlihat). Tidak akan hilang selamanya: saat window dimunculkan lagi (tombol ⚡ / keybind), posisinya otomatis ditarik balik ke dalam layar.
- **Ukuran default ringkas** — window PC kini terbuka di **540 × 350 px** (dulu 620 × 430 — "kegedean" di layar kecil). *(Sejak v2.2.3 dipersegu menjadi 440 × 390 dan dihitung dari dimensi layar — lihat seksi v2.2.3 di atas.)* Tetap bisa di-resize / di-minimize / diatur sendiri lewat `Size` & `MinSize`.

### Baru di v2.2.1 (menu bisa di-minimize — dari permintaan: "di dalam menu ada fitur, tolong tambahkan minimize menu biar lebih rapi")

- **Judul section = tombol lipat** — klik judul menu (mis. "PENGATURAN KARAKTER") untuk menutup/membuka **semua fitur di dalamnya** sekaligus (sampai section berikutnya); panah lipat di kanan judul berputar sebagai penanda (sejak v2.2.2 panah DIGAMBAR — bukan glyph font), dan judul section lain tetap terlihat agar navigasi tidak terkunci. Cocok untuk tab dengan banyak fitur — daftar jadi jauh lebih rapi.
- **Anggota otomatis** — elemen apa pun (Button/Toggle/Slider/Dropdown/TextInput/Keybind/ColorPicker/Label/Paragraph) yang dibuat **setelah** `AddSection` otomatis menjadi anggota menu tersebut; tidak perlu mendaftarkan apa pun secara manual.
- **Mulai terlipat** — `Tab:AddSection({ Name = "..." })` kini otomatis mulai TERLIPAT (default `Collapsed = true` sejak v2.2.2); elemen yang ditambahkan belakangan pun ikut tersembunyi otomatis. `Collapsed = false` untuk mulai terbuka.
- **API programatik** — `Section:SetCollapsed(bool)`, `Section:Toggle()`, `Section:IsCollapsed()`, plus `SetDescription(teks)` seperti elemen lain.
- **Search-aware** — pencarian **tidak membuka lipatan**: anggota menu yang sedang di-minimize tetap tersembunyi walau cocok dengan kata kunci; judul menu tanpa anggota yang cocok ikut disembunyikan supaya hasil pencarian lebih rapat.
- **Tetap ringan** — lipatan diterapkan lewat satu pass `Visible` tanpa tween per elemen, hover judul hanya di perangkat bermouse, dan registry section ikut dibersihkan saat `Section:Remove()` / `Tab:Remove()` / `Window:Destroy()` (anti memory-leak).

### Optimasi di v2.2.0 (performa — dari laporan: "masih terasa berat, banyak rendutan")

- **Pengukur teks ber-cache** — sumber "rendutan" utama: sejak v2.1.2 setiap label keterangan/paragraf/notifikasi terhubung ke sinyal `AbsoluteSize` parent, sehingga **resize window / rotasi layar memicu `GetTextSize` per label per frame** untuk semua elemen, lalu penulisan `Size` memicu re-layout berantai (card `AutomaticSize.Y` → holder → `ScrollingFrame` `AutomaticCanvasSize`). Kini pengukuran **ber-cache**: teks & lebar tidak berubah = nol ukur ulang, dan `Size` hanya ditulis bila tinggi benar-benar berubah (memutus reaksi berantai layout ↔ signal).
- **Re-ukur terjadwal (batched)** — semua permintaan pengukuran ulang digabungkan maksimal **satu pass per frame** untuk seluruh label (`task.defer`), bukan per-label-per-frame seperti sebelumnya.
- **Registry otomatis bersih** — dulu setiap `Tween()` (hover, kilat Zap, animasi) menempel di daftar registry **sampai window dihancurkan** — sesi panjang menumpuk ribuan tween mati (memori bengkak + `Destroy()`/`:Remove()` makin lambat). Kini tween **otomatis keluar dari daftar begitu selesai** (`Completed` — termasuk saat `:Cancel()`), dan `Clean()` memproses snapshot daftar agar aman dari mutasi-tengah-iterasi.
- **Hover hemat di mobile** — efek hover card hanya dipasang di perangkat **bermouse**. Di layar sentuh, setiap ketukan ikut memicu `MouseEnter`/`MouseLeave` → 2-4 tween percuma per tap; kini nol. Umpan balik sentuh tetap terasa: kilat Zap, animasi switch/knob, splash tombol.
- **Search debounce 0.1s** — filter elemen saat mengetik dulu memicu re-layout penuh seluruh elemen tab **tiap huruf**; kini digabung satu kali per 0.1 detik.
- **Rebranding total** — semua referensi library eksternal dihapus dari kode, README, Loader, dan Example; desain, layout & tema **100% original ThorUi**.

### Perbaikan di v2.1.5 (hapus "kotak abu-abu" nilai slider & dropdown)

- **FIX kotak abu-abu di belakang nilai elemen (dari screenshot user: "tulisan 124 spd di dalam kotak abu abu... tulisan Mjolnir juga di dalam kotak abu abu")** — 5 `TextLabel` nilai (nilai slider "124 spd", pilihan dropdown "Mjolnir", panah dropdown "▾", keybind, dan kode HEX ColorPicker) tidak pernah diberi `BackgroundTransparency`, sehingga Roblox merender **background default abu-abu `RGB(163,162,165)`** di belakang teksnya — tampak seperti teks "dikotaki" abu-abu. Kini kelima label **transparan total**: teks emas/biru tema langsung di atas kartu navy, tanpa kotak apa pun.
- **Helper `Create` anti-kotak-abu permanen** — `TextLabel` yang dibuat tanpa `BackgroundTransparency` dan tanpa `BackgroundColor3` eksplisit kini **otomatis transparan** di helper pembuat instance, sehingga kelas bug "kotak abu-abu" ini tidak akan muncul lagi di elemen manapun yang akan datang (audit menyeluruh: tidak ada satu pun `TextLabel` ber-background di seluruh kodebase; swatch warna ColorPicker adalah `Frame` yang di-set `BackgroundColor3` dinamis, jadi tetap menampilkan warna terpilih).
- **Audit menyeluruh** — 31 instance tanpa transparansi eksplisit diperiksa: selain 5 label nilai di atas, sisanya adalah `Frame`/`TextButton`/`TextBox` dengan `BackgroundColor3` tema yang memang disengaja (track slider, pill toggle, swatch, dsb.) — tidak ada kotak abu tersisa.

### Perbaikan di v2.1.4 (fix warna gradien kotor — akar "warna abu-abu")

- **FIX UIGradient TINT (akar masalah "tulisannya ketimpa sama warna abu-abu")** — di Roblox, `UIGradient` **mengalikan (menint) warnanya dengan `BackgroundColor3`** — ia TIDAK menimpa warna background. Seluruh frame ber-gradien yang background-nya bukan putih selama ini (sejak v2.0.0) render salah dan tampak kotor/abu-abu: **sidebar & header nyaris hitam `RGB(1,2,4)`** (bukan navy), **fill slider biru redup → HIJAU** `RGB(0,145,9)` (emas tidak pernah muncul karena channel R background Accent = 0), tombol ⚡ melayang & lingkaran splash nyaris hitam, garis petir hijau gelap. Kini SEMUA frame ber-gradien diberi **latar putih** sehingga hasil kali = warna gradien murni persis tema.
- **FIX fill slider cerah "kilat menyala"** — selain tertint, gradien biru→emas secara inheren melintas zona **abu kehijauan** (interpolasi sRGB: titik tengah `(127,192,127)`). Diganti **gradien selaras-hue biru listrik → biru terang (vertikal)** yang selalu cerah tanpa "lumpur", plus **stroke knob emas**. Slider kini: bar biru menyala + bulatan putih bergaris emas — tidak ada lagi jejak abu-abu/kehijauan.
- **FIX tombol Confirm** — gradien biru→emas-nya dibuang (tertint oleh hover yang men-tween background ke CardHover + melintas abu kehijauan); kini solid Electric Blue + teks putih.
- **Elemen ikut pulih**: sidebar & header kini gradasi navy `(16,20,32)→(11,14,23)` sebagaimana desain; garis petir & indikator tab emas→biru; bar progress splash biru menyala; tombol ⚡ melayang & lingkaran splash tampil dengan gradasi navy yang benar.

### Perbaikan di v2.1.3 (hotfix error fatal — dari laporan log console)

- **FIX error `"'Value' is not a valid member of UDim"`** — helper pengukur tinggi teks yang baru di v2.1.2 (`fitTextHeight`) mengakses `.Value` pada `UIPadding.PaddingLeft/PaddingRight` — padahal member itu **tidak ada** (bertipe `UDim` yang hanya punya `.Scale` & `.Offset`). Akibatnya setiap elemen yang punya `Description` **gagal dibuat** dengan error di `AddToggle`/`AddSlider`/dll. (stack: `fitTextHeight → fit → autofitText → attachDescription → AddToggle`) dan script pemanggilnya ikut mati; notifikasi error juga terus muncul saat resize/ubah teks. Kini memakai `.Offset` yang benar — **semua elemen dibuat normal dan pengukuran anti-ketimpa v2.1.2 berjalan sebagaimana mestinya**.
- **Dampak perbaikan** — sekaligus memulihkan seluruh manfaat v2.1.2: keterangan semua elemen, Label, Paragraph, isi notifikasi, dan pesan Confirm terukur tingginya secara sinkron (`GetTextSize`) sehingga SELALU utuh terbaca, plus auto re-ukur saat teks berubah / window di-resize / layar dirotasi.

### Perbaikan di v2.1.2 (fix teks ketimpa — dari laporan screenshot)

- **FIX keterangan tertimpa track slider** — di sebagian perangkat (layar DPI tinggi / executor / `AutomaticSize` bersarang), pola `TextLabel TextWrapped + AutomaticSize.Y` memesan tinggi **lebih kecil** dari render teks asli → baris berikutnya (track slider, box input, tombol) **menimpa separuh bawah teks keterangan** (gejala: "keterangan slider ... (16 - 200) tidak kelihatan gara-gara ketimpa"). Kini tinggi SEMUA teks wrapped diukur **sinkron** via `TextService:GetTextSize` dengan lebar render sesungguhnya, lalu dipasang sebagai `Size` eksplisit — `UIListLayout` selalu memesan ruang yang pas dan tidak ada lagi ketimpa.
- **Cakupan menyeluruh** — perbaikan ini berlaku untuk: Description di semua elemen (Button, Toggle, Slider, Dropdown, TextInput, Keybind, ColorPicker, Section), `AddLabel`, `AddParagraph`, isi notifikasi (`Notify`), dan pesan `Confirm` dialog (dulu baris tombol bisa menimpa pesan).
- **Auto re-ukur** — tinggi teks dihitung ulang otomatis saat teks diubah (`SetText` / `SetDescription`), window di-*resize*, atau layar dirotasi — selalu pas di semua ukuran.
- **Aman memori** — koneksi re-ukur dipasang pada signal milik elemen itu sendiri, otomatis terputus saat elemen di-`Remove()`/window di-`Destroy()` (tetap patuh pola Registry anti memory-leak).

### Fitur inti

- **Tema Lightning & Thunder** — dasar *Midnight Blue* pekat dengan aksen *Electric Blue* (cyan neon) dan *Lightning Gold*, plus glow sederhana lewat `UIGradient` + layer transparan + stroke neon.
- **Animasi snappy ala kilat** — semua hover, klik, ganti tab, dan show/hide memakai `TweenService` dengan easing cepat (`Quad`, `Quart`, `Back`) supaya terasa responsif.
- **Window draggable** — dari baris logo sidebar atau header kanan, dengan **mouse maupun sentuhan** via `UserInputService`.
- **Window resizable** — drag-handle di **sudut kanan bawah** window, dilengkapi `UISizeConstraint` (default minimal `400 × 250`) + auto-clamp untuk layar kecil.
- **Responsif otomatis** — ukuran window default menyesuaikan viewport; sidebar auto icon-only saat sempit.
- **Menu (section) bisa di-minimize** — klik judulnya untuk melipat semua fitur di dalamnya; `Collapsed = true` untuk mulai terlipat.
- **Floating toggle ⚡** — tombol petir melayang yang bisa **digeser bebas ke mana pun** dan tetap di posisi terakhir (di-clamp agar tidak keluar layar; perfect untuk Mobile).
- **Keybind toggle UI** — default `RightControl`, bisa diganti kapan saja.
- **Konten tak terbatas** — tiap tab pakai `ScrollingFrame` + `AutomaticCanvasSize`.
- **11 komponen siap pakai** — Button, Toggle, Slider, Dropdown (single & multi-select), TextInput, Keybind, ColorPicker, Section, Label, Paragraph, dan Notify.
- **Notify system** — muncul dengan slide + fade dari kanan atas, bisa dituk untuk menutup cepat, maksimal 5 notifikasi bertumpuk.
- **Anti memory-leak** — *semua* koneksi event & tween disimpan ke *garbage table* (`Registry`) dan otomatis di-`:Disconnect()` / `:Cancel()` saat UI dihancurkan.

---

## 🚀 Instalasi

### A. Roblox Studio

1. Buat **ModuleScript** bernama `ThorUi` (misalnya di `ReplicatedStorage`).
2. Tempel seluruh isi [`ThorUi.lua`](ThorUi.lua) ke dalamnya.
3. Buat **LocalScript** di `StarterPlayer > StarterPlayerScripts`, lalu panggil:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ThorUi = require(ReplicatedStorage:WaitForChild("ThorUi"))

local Window = ThorUi:CreateWindow({ Title = "ThorUi ⚡" })
```

### B. Executor

Salin seluruh isi `ThorUi.lua` ke script executor Anda (ScreenGui otomatis mencoba `CoreGui`, fallback ke `PlayerGui`), atau muat via `loadstring` jika Anda host file-nya sendiri:

```lua
local ThorUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/dwisetyabudi15581/ThorUi/main/ThorUi.lua"))()
```

> ⚠️ **Penting:** ThorUi harus dijalankan dari **client** (LocalScript / executor). Jika dipanggil dari server, modul akan memberi peringatan dan tidak melakukan apa-apa.

---

## ⚡ Quick Start

```lua
local ThorUi = require(ReplicatedStorage:WaitForChild("ThorUi"))

local Window = ThorUi:CreateWindow({
    Title   = "ThorUi ⚡",
    Size    = UDim2.new(0, 440, 0, 390),   -- v2.2.3: default rada persegu; kosongkan agar otomatis responsif + selalu muat
    MinSize = Vector2.new(400, 250),       -- batas minimal saat resize
    Keybind = Enum.KeyCode.RightControl,   -- toggle buka/tutup UI (PC)
})

local Tab = Window:CreateTab({ Name = "Main", Icon = "⚡" })

Tab:AddButton({
    Name = "Kirim Petir!",
    Callback = function()
        ThorUi:Notify({
            Title   = "⚡ Petir Menyambar",
            Content = "BOOM! Petir berhasil dikirim ke target.",
            Duration = 3,
        })
    end,
})

ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "Script berhasil dimuat!", Duration = 3 })
```

Contoh implementasi **lengkap** (semua komponen) tersedia di [`Example.lua`](Example.lua) dan di blok comment **paling bawah** file `ThorUi.lua`.

---

## 📖 Referensi API

### `ThorUi` (Library)

| Method | Deskripsi |
|---|---|
| `ThorUi:CreateWindow(cfg)` | Membuat window utama. Mengembalikan objek `Window`. |
| `ThorUi:Notify(cfg)` | Menampilkan notifikasi di kanan atas layar. |
| `ThorUi:SetKeybind(key)` | Mengubah keybind toggle UI (default `Enum.KeyCode.RightControl`). |
| `ThorUi:Toggle()` | Buka/tutup window aktif secara programatik. |
| `ThorUi:SetToggleVisible(bool)` | Tampilkan / sembunyikan tombol ⚡ melayang. |
| `ThorUi:Destroy()` | Hancurkan seluruh UI + bersihkan semua memory. |
| `ThorUi.Theme` | Table tema — bisa di-override **sebelum** `CreateWindow`. |
| `ThorUi.Version` | String versi library. |

#### Konfigurasi `CreateWindow`

| Key | Tipe | Default | Deskripsi |
|---|---|---|---|
| `Title` | `string` | `"ThorUi ⚡"` | Judul di title bar. |
| `Size` | `UDim2` | responsif | Ukuran window. Kosongkan untuk otomatis (mobile: `0.92 x 0.62` skala; PC: `580 x 420` px). |
| `MinSize` | `Vector2` | `(400, 250)` | Ukuran minimal via `UISizeConstraint`. Auto-clamp di layar kecil. |
| `Position` | `UDim2` | tengah layar | Posisi awal window. |
| `Keybind` | `Enum.KeyCode` | `RightControl` | Tombol toggle UI (PC). |
| `ShowToggle` | `boolean` | `true` | Tampilkan tombol ⚡ melayang. |

#### Konfigurasi `Notify`

| Key | Tipe | Default | Deskripsi |
|---|---|---|---|
| `Title` | `string` | `"ThorUi"` | Judul notifikasi. |
| `Content` | `string` | — | Isi pesan. |
| `Duration` | `number` | `4` | Lama tampil (detik). Ketuk/sentuh untuk menutup lebih cepat. |
| `Icon` | `string` | `"⚡"` | Ikon di samping judul. |

---

### `Window`

| Method | Deskripsi |
|---|---|
| `Window:CreateTab({ Name, Icon })` | Membuat tab baru. `Icon` opsional (emoji/teks, mis. `"⚡"`). |
| `Window:Show()` / `Window:Hide()` | Tampilkan / sembunyikan window (dengan animasi pop). |
| `Window:Toggle()` | Buka/tutup window. |
| `Window:SetCollapsed(bool)` | Minimize window jadi sidebar saja (`true`) atau kembalikan ke ukuran semula (`false`). Saat minimized, tombol `+` muncul di bawah sidebar untuk expand. |
| `Window:SetKeybind(key)` | Alias `ThorUi:SetKeybind()`. |
| `Window:Destroy()` | Hancurkan window ini + bersihkan seluruh memory-nya. |

---

### `Tab` — Komponen

Semua komponen mengembalikan objek `Element` dengan method seragam:
**`Element:Set(...)`** (set nilai; param kedua `false` = tanpa memicu callback), **`Element:Get()`** (ambil nilai), **`Element:SetDescription(teks)`** (ubah keterangan di bawah judul), **`Element:Remove()`** (hapus elemen dari UI).

Semua komponen juga menerima **`Description`** (string opsional) — teks keterangan kecil yang tampil di bawah judul elemen:

```lua
Tab:AddSlider({
    Name = "WalkSpeed",
    Description = "Atur kecepatan jalan karakter (16 - 200).",  -- ← keterangan kecil
    Min = 16, Max = 200, Default = 16,
})
```

#### `Tab:AddButton({ Name, ConfirmText, Callback })`

**v2.3.0 — `ConfirmText` (opsional)**: klik dua tahap untuk aksi berisiko — klik pertama mengubah teks tombol menjadi konfirmasi (batal otomatis setelah 2.5 detik), klik kedua mengeksekusi.

```lua
Tab:AddButton({ Name = "Klik Aku", Callback = function() print("klik!") end })

-- aksi berisiko: wajib klik 2x (Reset Progress → "Yakin? Klik lagi!" → eksekusi)
Tab:AddButton({
    Name = "Reset Progress",
    ConfirmText = "Yakin? Klik lagi!",
    Callback = function() print("direset!") end,
})
```

#### `Tab:AddToggle({ Name, Default, Callback })`

```lua
local godMode = Tab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value) print("God Mode:", value) end,
})

godMode:Set(true)        -- set nilai + panggil callback
godMode:Set(true, false) -- set nilai TANPA callback
godMode:Get()            -- ambil nilai (bool)
```

**v2.3.0 — `Group` (opsional)**: perilaku radio — sekumpulan toggle dalam grup yang sama, maksimal satu aktif:

```lua
local mode = ThorUi:CreateGroup({ Name = "Mode Aim" }) -- KeepNone = true (default): semua boleh mati
Tab:AddToggle({ Name = "Aim: Kepala", Group = mode, Default = true })
Tab:AddToggle({ Name = "Aim: Dada",   Group = mode })
Tab:AddToggle({ Name = "Aim: Kaki",   Group = mode })
-- mode:Get() → toggle yang sedang aktif · mode:Set(el) · mode:Clear()
```

#### `Tab:AddSlider({ Name, Min, Max, Default, Increment, Precision, Suffix, Callback })`

| Key | Tipe | Deskripsi |
|---|---|---|
| `Min`, `Max` | `number` | Batas nilai slider. |
| `Default` | `number` | Nilai awal. |
| `Increment` | `number` | Kelipatan langkah (default `1`). |
| `Precision` | `number` | Jumlah desimal tampilan. |
| `Suffix` | `string` | Satuan tampilan, mis. `" spd"`. |
| `Prefix` | `string` | Awalan tampilan, mis. `"x"` (v2.3.0). |
| `Units` | `table`/`string` | **v2.3.0** — multi-satuan + konversi otomatis (lihat bawah). |
| `Depends` | `table` | **v2.3.0** — tampilkan baris ini hanya saat sumber bernilai tertentu (lihat bawah). |
| `Description` | `string` | Keterangan kecil di bawah judul (opsional). |

```lua
Tab:AddSlider({
    Name = "WalkSpeed", Min = 16, Max = 200, Default = 16,
    Increment = 1, Suffix = " spd",
    Callback = function(value) print("WalkSpeed:", value) end,
})
```

**v2.3.0 — klik ANGKA untuk mengetik nilai eksak** (kotak input muncul di tempat angka; Enter/klik-luar untuk menerapkan, otomatis di-clamp & snap ke increment).

**v2.3.0 — `Units` multi-satuan dengan konversi otomatis.** Nilai internal (dan callback) SELALU dalam satuan dasar; tampilan dikonversi via `FromBase`/`ToBase`:

```lua
local jarak = Tab:AddSlider({
    Name = "Jarak Serangan", Min = 0, Max = 10000, Default = 1000,
    Units = {
        Default = "m",
        Options = {
            { Name = "m",  Suffix = "m" },
            { Name = "km", Suffix = "km", Decimals = 2,
              FromBase = function(m)  return m / 1000 end,   -- meter → km (tampilan)
              ToBase   = function(km) return km * 1000 end }, -- km → meter (input user)
        },
        Callback = function(unitName) print("Satuan diganti:", unitName) end,
    },
    Callback = function(meters) print("Jarak (selalu meter):", meters) end,
})
-- Shorthand satuan tunggal: Units = "m"  ·  Units = { "m", "km" }
```

**v2.3.0 — setter runtime**:

```lua
slider:SetRange(0, 500)     -- ganti batas (nilai di-clamp ulang)
slider:SetDecimals(1)       -- jumlah desimal tampilan
slider:SetIncrement(5)      -- ganti kelipatan snap
slider:SetSuffix(" km/j")   -- ganti satuan tampilan
slider:SetUnit("km")        -- pindah satuan aktif (mode Units)
```

#### `Tab:AddDropdown({ Name, Values, Default, Multi, Callback })`

Mode single mengirim `value` (satu item); mode `Multi = true` mengirim **table** berisi item terpilih.

```lua
Tab:AddDropdown({
    Name = "Senjata",
    Values = { "Mjolnir", "Stormbreaker", "Gungnir" },
    Default = "Mjolnir",
    -- Multi = true,  -- aktifkan untuk multi-select
    Callback = function(value) print("Senjata:", value) end, -- Multi: table
})
```

**v2.3.0 — `Search = true`**: kotak pencarian muncul di atas daftar opsi (filter ketika mengetik). **`ApplyButton`** (string/`true`): mode aksi — memilih TIDAK langsung menembak callback; tombol Apply yang mengirimkannya sebagai `callback(nilai, indeks)`:

```lua
Tab:AddDropdown({
    Name = "Target Farm",
    Values = { "Mob Perum", "Mob Kuil", "Boss Petir", "Boss Es" },
    Multi = true, Search = true, ApplyButton = "Terapkan",
    Callback = function(values, indices) print("Farm:", table.concat(values, ", ")) end,
})
```

**v2.3.0 — kelola opsi saat runtime**:

```lua
dropdown:SetValues({ "A", "B", "C" }) -- ganti seluruh daftar (pilihan tak valid dibuang)
dropdown:AddValue("D")                -- tambah satu opsi
dropdown:RemoveValue("A")             -- hapus satu opsi
dropdown:Filter("boss")               -- filter tampilan (atau lewat search box)
```

#### `Tab:AddTextInput({ Name, Text, Placeholder, ClearOnFocus, Callback })`

Callback menerima `(text, enterPressed)` — dipanggil saat TextBox kehilangan fokus.

```lua
Tab:AddTextInput({
    Name = "Nama Target",
    Placeholder = "Ketik nama pemain...",
    Callback = function(text, enterPressed) print("Input:", text, "| Enter:", enterPressed) end,
})
```

#### `Tab:AddKeybind({ Name, Default, Callback })`

Klik pill untuk masuk mode "listening", lalu tekan tombol baru. Callback menerima `(bind, input)`.

```lua
Tab:AddKeybind({
    Name = "Skill Petir",
    Default = Enum.KeyCode.R,
    Callback = function(bind) print("Skill dipanggil dengan:", bind.Name) end,
})
```

#### `Tab:AddSection({ Name, Description, Collapsed })` · `Tab:AddLabel({ Text })` · `Tab:AddParagraph({ Title, Text })`

Elemen statis untuk menyusun halaman: judul seksi bergaris, label teks, dan paragraf multi-baris.

**v2.2.1 — Section kini berfungsi sebagai MENU yang bisa di-minimize**: klik judulnya untuk melipat/membuka semua elemen yang dibuat setelahnya (sampai `AddSection` berikutnya). Elemen apa pun yang dibuat setelah `AddSection` otomatis menjadi anggota menu itu. **v2.2.2 — semua section mulai TERLIPAT** (default `Collapsed = true`); beri `Collapsed = false` untuk menu yang ingin mulai terbuka.

```lua
local menu = Tab:AddSection({ Name = "PENGATURAN KARAKTER", Collapsed = false }) -- false = mulai TERBUKA (default kini terlipat)

menu:Toggle()              -- lipat/buka menu
menu:SetCollapsed(true)     -- minimize paksa
menu:IsCollapsed()          -- cek status lipatan
menu:SetDescription("teks keterangan di bawah judul menu")
```

| Konfigurasi `AddSection` | Tipe | Default | Keterangan |
|---|---|---|---|
| `Name` | `string` | `"Section"` | Judul menu (klik untuk minimize). |
| `Description` | `string` | `nil` | Keterangan kecil di bawah judul. |
| `Collapsed` | `boolean` | `true` | `true` (default sejak v2.2.2) → menu dibuat langsung terlipat · `false` → mulai terbuka. |

#### `Tab:AddList({ Name, Items|Groups, Multi, Search, Selected, MaxHeight, OnItemClick })` · **v2.3.0**

Browser item di dalam UI — daftar yang bisa **dilacak** (search), **dikelompokkan** (groups), dan **dipilih** (klik / multi). Setiap item boleh berupa string biasa atau table `{ Text, TopRight, Image, Id }` (badge kanan, gambar `rbxassetid` milik sendiri — opsional, Id untuk identifikasi stabil).

```lua
local gudang = Tab:AddList({
    Name = "Gudang Senjata",
    Search = true,          -- kotak pencarian di atas daftar
    Multi = false,          -- true = boleh pilih banyak
    MaxHeight = 170,        -- tinggi maksimum sebelum scroll
    Groups = {
        { Title = "Palu", Items = {
            { Text = "Mjolnir", TopRight = "Legendary" },
            { Text = "Stormbreaker", TopRight = "Mythic" },
        } },
        { Title = "Tombak", Items = { "Gungnir", "Trisula" } },
    },
    OnItemClick = function(item, index, selected)
        print("Pilih:", item.Text, "→", selected)
    end,
})

gudang:Get()            -- item terpilih (atau table item bila Multi)
gudang:Set("Mjolnir")   -- pilih dari script (string / table / Id)
gudang:SetItems(items, groups) -- ganti seluruh isi
gudang:Clear()          -- kosongkan pilihan
gudang:Filter("palu")   -- filter tampilan
```

#### `Tab:AddModelView({ Name, Model, Height, Spin })` · **v2.3.0**

Etalase objek 3D di dalam UI (`ViewportFrame`): kamera otomatis membingkai objek, opsi putar otomatis (`Spin`, default `true`), dan objek yang diklon otomatis dibersihkan dari scripts/partikel/suara. **Tanpa `Model` diberikan, etalase menampilkan palu petir geometris BAWAAN** — dibangun murni dari `Part` (tetap nol aset!).

```lua
local palu = Tab:AddModelView({ Name = "Etalase", Height = 150, Spin = true })
palu:SetModel(workspace:FindFirstChild("SomeModel")) -- Model/BasePart apa pun
palu:SetSpin(false)
palu:Get()   -- objek yang sedang dipajang
```

#### `Tab:AddCanvas({ Name, Widgets })` · **v2.3.0**

Dashboard mini yang dideklarasikan lewat tabel — baris teks (label + nilai), bar progress, tombol, dan pemisah — semuanya bisa diperbarui saat runtime lewat `:Set(nama, props)`:

```lua
local dash = Tab:AddCanvas({
    Name = "Statistik",
    Widgets = {
        { Type = "Text",   Name = "kills",  Text = "Kills",  Value = "0" },
        { Type = "Bar",    Name = "hp",     Text = "Health", Value = 1 }, -- 0..1
        { Type = "Button", Name = "rejoin", Text = "Rejoin",
          Callback = function() print("rejoin!") end },
        { Type = "Divider" },
    },
})

dash:Set("kills", { Value = "128" })  -- update dari script
dash:Set("hp",    { Value = 0.62, Color = Color3.fromRGB(255, 120, 0) })
dash:Get("kills")   -- { Text = "Kills", Value = "128" }
dash:Fire("rejoin") -- picu tombol dari script
dash:AddWidget({ Type = "Text", Name = "deaths", Text = "Deaths", Value = "0" })
```

---

### 🧲 State, Depends & Sub-row · **v2.3.0**

#### State + Binding — satu nilai untuk banyak elemen

```lua
local power = ThorUi:CreateState({
    Name = "PowerLevel", Default = 50,
    Normalize = function(v) return math.clamp(math.floor(v), 0, 100) end,
    Callback = function(v) print("Power berubah:", v) end,
})

local s1 = Tab:AddSlider({ Name = "Power (A)", Min = 0, Max = 100, Default = 50 })
local s2 = Tab:AddSlider({ Name = "Power (B)", Min = 0, Max = 100, Default = 50 })
power:Bind(s1)
power:Bind(s2)
-- Geser slider A → state berubah → slider B ikut (dan sebaliknya)

-- Transformasi nilai berbeda per elemen (slider 0..100 ↔ state 0..10):
power:Bind(s1, {
    ToState  = function(v) return v / 10 end,   -- elemen → state
    ToOption = function(v) return v * 10 end,   -- state → elemen
})

power:BindMany({ s1, s2, { Element = someToggle, ToOption = fn } })
power:Subscribe(function(v) end)  -- berlangganan perubahan (return fungsi unsubscribe)
power:Unbind(s1)
power:Get()  power:Set(80)
```

Binding bekerja untuk semua elemen bernilai (Toggle, Slider, Dropdown, TextInput, Keybind, ColorPicker, List).

#### Depends — baris muncul/sembunyi otomatis

```lua
local godMode = Tab:AddToggle({ Name = "God Mode", Default = false })

-- Slider ini HANYA tampil saat God Mode ON:
Tab:AddSlider({
    Name = "Regen / detik", Min = 0, Max = 100, Default = 10,
    Depends = { Element = godMode, Value = true },
})

-- Bentuk lain:
-- Depends = { State = stateKu,  Value = 25 }                       (via State)
-- Depends = { Element = slider, Predicate = function(v) return v > 50 end } (predikat bebas)

-- Runtime:
regenSlider:SetDependency({ Element = godMode, Value = true })
regenSlider:ClearDependency()
```

Dependensi bisa DIRANTAI (baris yang bergantung pada baris tersembunyi ikut sembunyi) dan tetap hormat lipatan section maupun hasil pencarian.

#### Sub-row — `Element:AddChild(kind, cfg)`

Setiap elemen inti bisa punya anak bertingkat (tampil terinden di dalam kartu induk, dibuka/ditutup lewat panah kecil di kiri judul):

```lua
local speedHack = Tab:AddToggle({ Name = "Speed Hack", Default = false })
speedHack:AddChild("Slider", { Name = "Nilai Speed", Min = 16, Max = 500, Default = 16 })
speedHack:AddChild("Toggle", { Name = "Saat Lompat Juga", Default = true })

speedHack:SetExpanded(true)   -- buka dari script
speedHack:IsExpanded()
-- Kind: "Toggle" "Slider" "Dropdown" "Button" "TextInput" "Keybind"
--       "ColorPicker" "Label" "Paragraph" "List" "ModelView" "Canvas"
```

---

### ⚡ Quick Action & Tema · **v2.3.0**

```lua
-- Tombol bundar melayang di pinggir layar — deretnya bisa DIGESER;
-- pintasan aksi yang tetap terlihat walau window tertutup:
ThorUi:AddQuickAction({
    Icon = "⚡", Name = "Sambar Sekarang",
    Callback = function() print("ZAP!") end,
})  -- → { Remove() }

-- Merge tema (panggil SEBELUM CreateWindow — elemen mengambil warna saat dibuat):
ThorUi:SetTheme({
    Accent     = Color3.fromRGB(170, 90, 255),
    AccentGold = Color3.fromRGB(255, 200, 60),
})
```

---

## 📱 Mobile & 🖥️ PC

| Perilaku | Mobile (Touch) | PC (Mouse + Keyboard) |
|---|---|---|
| Drag window | Sentuh & geser title bar | Klik & tarik title bar |
| Resize window | Sentuh & geser handle sudut kanan-bawah | Klik & tarik handle |
| Toggle UI | Ketuk tombol ⚡ melayang (bisa digeser bebas) | `RightControl` |
| Semua tombol | `Activated` event — bekerja untuk tap maupun klik | sama |
| Ukuran window | Default dari dimensi layar: 86% lebar / maks 1.15× lebar (rada persegu, muat pasti) | Default dari dimensi layar: `440 × 390` px (v2.2.3, rada persegu, muat pasti) |

---

## 🎨 Kustomisasi Tema

Semua warna & font berada di `ThorUi.Theme`. Ubah **sebelum** membuat window/elemen agar efeknya diterapkan:

```lua
local ThorUi = require(ReplicatedStorage.ThorUi)

-- v2.3.0: cara cepat — merge patch tema:
ThorUi:SetTheme({
    Accent     = Color3.fromRGB(170, 90, 255),  -- ungu badai
    AccentGold = Color3.fromRGB(255, 200, 60),  -- emas petir
})

-- (cara lama tetap didukung — edit langsung:)
-- ThorUi.Theme.Accent     = Color3.fromRGB(170, 90, 255)
-- ThorUi.Theme.AccentGold = Color3.fromRGB(255, 200, 60)

local Window = ThorUi:CreateWindow({ Title = "ThorUi ⚡" })
```

Palet bawaan:

| Key | Warna |
|---|---|
| `Background` / `BackgroundAlt` | `RGB(11,14,23)` / `RGB(16,20,32)` — midnight blue |
| `Card` / `CardHover` | `RGB(21,26,41)` / `RGB(28,36,56)` |
| `Accent` | `RGB(0,195,255)` — electric blue |
| `AccentGold` | `RGB(255,190,0)` — lightning gold |
| `Text` / `TextDim` | putih terang / abu kebiruan |
| `Stroke` / `StrokeDim` | garis aktif / pasif |
| `Danger` | merah peringatan |
| `FontMain` / `FontMedium` / `FontBold` | `Gotham` family |

---

## 🧠 Anti Memory-Leak

Setiap connection (`.Event:Connect`) dan tween disimpan ke *garbage table* milik `Registry` — per library, per window, per tab, dan per elemen. Saat Anda memanggil:

- `Element:Remove()` → registry elemen dibersihkan,
- `Tab` dihapus → registry tab dibersihkan,
- `Window:Destroy()` / `ThorUi:Destroy()` → **semua** koneksi & tween di-`:Disconnect()`/`:Cancel()`, instance `:Destroy()` (ini juga otomatis memutus sisa koneksi), dan `task.delay` notifikasi dibatalkan.

Jadi UI yang dibongkar tidak meninggalkan listener nyasar di `UserInputService` — aman untuk respawn, teleport, dan re-inject script.

---

## 📄 Contoh Lengkap

Lihat [`Example.lua`](Example.lua) — LocalScript siap tempel yang mendemokan semua komponen: window + 2 tab, section, button, toggle, slider (multi-satuan), dropdown (search + apply), textinput, keybind, colorpicker, **plus fitur v2.3.0: state binding, Depends, sub-row AddChild, List, ModelView, Canvas, grup radio, dan quick action**. Versi comment-nya juga tersedia di bagian paling bawah `ThorUi.lua`.

---

## 📜 Lisensi

[MIT](LICENSE) — bebas dipakai, dimodifikasi, dan didistribusikan ulang.
