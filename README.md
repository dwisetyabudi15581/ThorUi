# ⚡ ThorUi v2 — Roblox UI Library bertema Dewa Petir

> UI library untuk Roblox dengan tema **Thor / Dewa Petir**: gelap, snappy, dan elektrik.
> **v2.1.2: FIX teks keterangan/paragraf yang ketimpa elemen di bawahnya (di sebagian perangkat) + Description ala Wind UI di semua elemen** — sidebar tab, search bar, splash screen, ColorPicker, Confirm dialog.
> Dukungan penuh **PC & Mobile** · Window *draggable* & *resizable* · **100% murni script** (tanpa Asset ID eksternal) · **Anti memory-leak**

| | |
|---|---|
| **Versi** | 2.1.2 |
| **Tipe** | ModuleScript tunggal (Luau), tanpa dependensi |
| **Platform** | PC (Mouse + Keyboard) & Mobile (Touch) |
| **Aset** | `Instance.new` / `UICorner` / `UIStroke` / `UIGradient` saja — anti asset takedown |

---

## 🌩️ Fitur Unggulan

### Baru di v2.0.0 (terinspirasi Wind UI)

- **Splash screen** — layar pembuka dengan logo ⚡ memantul, progress bar petir, dan status menggemas ("Memanggil petir...", "Menempa Mjolnir..."). Muncul otomatis sekali per sesi, bisa dimatikan dengan `Splash = false`.
- **Sidebar tab vertikal** — tab ber-ikon di sisi kiri ala Wind UI, dengan indikator petir yang "menyambar" saat tab aktif. Saat window sempit (< 520px), sidebar otomatis menyusut jadi icon-only.
- **Search bar** — kotak pencarian di header yang memfilter elemen tab aktif secara real-time. Ketik "toggle" → hanya elemen bernama toggle yang tampil.
- **ColorPicker** — picker warna lengkap: kotak Saturasi-Value + slider Hue pelangi + tampilan HEX/RGB, semuanya digambar murni dengan `UIGradient` (tanpa aset gambar).
- **Confirm dialog** — modal konfirmasi overlay dengan animasi pop + fade; klik area gelap = batal.
- **Toggle switch** — toggle didesain ulang jadi switch ala Wind UI: track memanjang + knob bulat meluncur dengan easing Back.

### Perbaikan di v2.0.1

- **Ikon ⚡ bebas digeser** — drag ke mana pun, ikon **tetap di posisi terakhir** (tanpa snap ke tepi; hanya di-clamp agar tidak keluar layar). Ketuk = buka/tutup UI.
- **Fix minimize terkunci** — saat window di-minimize (tombol `—`), kini muncul tombol **`+` di bawah sidebar** untuk membesarkan kembali ke ukuran semula (ukuran & posisi tersimpan aman, tahan rotasi layar).
- **Fix error `SetToggleVisible`** — metode `ThorUi:SetToggleVisible()` / `SetKeybind()` / `Toggle()` yang hilang saat port v2 kini tersedia kembali.
- **Anti UI menumpuk saat re-execute** — ScreenGui ThorUi lama otomatis dibersihkan saat library dimuat ulang, jadi tombol ⚡ & window tidak dobel.

### Perbaikan di v2.1.0 (audit input menyeluruh)

- **FIX ikon ⚡ "loncat-loncat"** — akar masalahnya: posisi awal gesture dihitung dari objek `InputObject` yang **terus termutasi** di touch, sehingga delta selalu 0 — ikon tidak bergeser dan lepas jari malah memicu toggle window. Kini posisi di-*snapshot* sebagai nilai (`Vector3`/`Vector2`) → drag presisi & mulus di mouse maupun jari, anchor ikon tidak pernah diubah saat drag.
- **Window anti-hilang** — drag window kini di-*clamp*: minimal 56px sisi window dan 30px baris judul selalu tetap terlihat di layar, jadi window tidak bisa tersesat ke luar layar (ala Wind UI).
- **Tap beruntun makin responsif** — `Show`/`Hide`/`Toggle` kini pakai flag `_closing`: tap ⚡ saat window sedang menutup langsung membatalkan hide dan memunculkan kembali (dulu tap "tertelan").
- **Slider mobile-friendly** — baris slider ditinggikan 28px + *hit-area* transparan menutupi seluruh baris: tidak perlu membidik track 6px dengan jari; tap di mana pun pada baris langsung mengatur nilai.
- **Target sentuh lebih besar** — tombol kontrol header (—/✕) 28→32px, handle resize 28→34px, ukuran font ikon kontrol 14→16.
- **Hygiene memory** — koneksi `Completed` pada efek `Zap`/`popScale` kini ikut terlacak di `Registry` (auto-disconnect saat destroy).
- **Audit ulang seluruh handler input** — window drag, resize grip, slider, dan ColorPicker sudah benar (delta dihitung dari snapshot nilai); dropdown multi mem-*snapshot* nilai sebelum callback; toggle tap-entuh-card.

### Perbaikan di v2.1.1 (audit tata letak + keterangan elemen)

- **Description ala Wind UI di SEMUA elemen** — sebelumnya config `Description` diabaikan total ("keterangan slider dll tidak kelihatan"). Kini setiap elemen (Button, Toggle, Slider, Dropdown, TextInput, Keybind, ColorPicker, Section) menerima `cfg.Description` → teks keterangan kecil terbaca di bawah judul, otomatis membungkus teks panjang, dan bisa diubah kapan pun lewat `Element:SetDescription("teks")`.
- **FIX ikon ⚡ loncat setiap kali diklik** — akar masalah: posisi awal gesture dibaca dari `AbsolutePosition` lalu ditulis ke `Position`; di sebagian lingkungan (CoreGui/executor/DPI mobile) keduanya berbeda basis koordinat → ikon melompat dulu baru bisa digeser. Kini konversinya meniru formula engine sendiri (`Scale × ukuran parent + Offset`) → identitas visual terjamin, **nol loncatan saat ditekan**. Anchor ikon dipindah ke pusat (0.5, 0.5) sehingga animasi pop & efek "digenggam" menyala simetris dari tengah (dulu membesar ke kanan-bawah, terlihat seperti terloncat).
- **FIX snapshot (0,0)** — sebagian executor melaporkan `InputBegan` sentuhan di (0,0) yang membuat ikon melayang lintas layar; snapshot mencurigakan kini otomatis diambil ulang dari gerakan pertama.
- **FIX tombol minimize "—" tidak pada tempatnya** — tepi kanan search bar dikurangi agar tidak menimpa area tombol kontrol; tombol `—` dan `✕` kini berdampingan rapi di ujung kanan header.
- **FIX ikon tab di sidebar icon-only** — saat window sempit, ikon tab otomatis di tengah tombol (dulu menempel di kiri); glyph emoji di-*nudge* +1-2px agar tidak "melayang" ke atas.
- **FIX ColorPicker slider hue via sentuhan** — dulu slider hue hanya bisa digeser mouse; kini jari juga bisa (filter gesture source-lock).
- **Gesture source-lock menyeluruh** — drag window, resize, slider, dan ikon ⚡ mengunci sumber input saat gesture dimulai: di perangkat *hybrid* (PC layar sentuh / tablet + mouse) posisi mouse yang menetap tidak lagi bikin UI meloncat; jari kedua tidak mengganggu drag yang sedang berjalan.
- **Sentuhan mobile makin nyaman** — nilai slider tidak terpotong (`TextTruncate`), baris opsi dropdown 24→28px, kartu Confirm dialog auto-fit di layar sempit.

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
    Size    = UDim2.new(0, 620, 0, 430),   -- kosongkan agar otomatis responsif
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

Semua komponen juga menerima **`Description`** (string opsional) — teks keterangan kecil yang tampil di bawah judul elemen, ala Wind UI:

```lua
Tab:AddSlider({
    Name = "WalkSpeed",
    Description = "Atur kecepatan jalan karakter (16 - 200).",  -- ← keterangan kecil
    Min = 16, Max = 200, Default = 16,
})
```

#### `Tab:AddButton({ Name, Callback })`

```lua
Tab:AddButton({ Name = "Klik Aku", Callback = function() print("klik!") end })
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

#### `Tab:AddSlider({ Name, Min, Max, Default, Increment, Precision, Suffix, Callback })`

| Key | Tipe | Deskripsi |
|---|---|---|
| `Min`, `Max` | `number` | Batas nilai slider. |
| `Default` | `number` | Nilai awal. |
| `Increment` | `number` | Kelipatan langkah (default `1`). |
| `Precision` | `number` | Jumlah desimal tampilan. |
| `Suffix` | `string` | Satuan tampilan, mis. `" spd"`. |
| `Description` | `string` | Keterangan kecil di bawah judul (opsional). |

```lua
Tab:AddSlider({
    Name = "WalkSpeed", Min = 16, Max = 200, Default = 16,
    Increment = 1, Suffix = " spd",
    Callback = function(value) print("WalkSpeed:", value) end,
})
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

#### `Tab:AddSection({ Name })` · `Tab:AddLabel({ Text })` · `Tab:AddParagraph({ Title, Text })`

Elemen statis untuk menyusun halaman: judul seksi bergaris, label teks, dan paragraf multi-baris.

---

## 📱 Mobile & 🖥️ PC

| Perilaku | Mobile (Touch) | PC (Mouse + Keyboard) |
|---|---|---|
| Drag window | Sentuh & geser title bar | Klik & tarik title bar |
| Resize window | Sentuh & geser handle sudut kanan-bawah | Klik & tarik handle |
| Toggle UI | Ketuk tombol ⚡ melayang (bisa digeser bebas) | `RightControl` |
| Semua tombol | `Activated` event — bekerja untuk tap maupun klik | sama |
| Ukuran window | Default `0.92 × 0.62` skala layar, auto-clamp | Default `580 × 420` px |

---

## 🎨 Kustomisasi Tema

Semua warna & font berada di `ThorUi.Theme`. Ubah **sebelum** membuat window/elemen agar efeknya diterapkan:

```lua
local ThorUi = require(ReplicatedStorage.ThorUi)

ThorUi.Theme.Accent     = Color3.fromRGB(170, 90, 255)  -- ungu badai
ThorUi.Theme.AccentGold = Color3.fromRGB(255, 200, 60)  -- emas petir

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

Lihat [`Example.lua`](Example.lua) — LocalScript siap tempel yang mendemokan semua komponen: window + 2 tab, section, button, toggle, slider, dropdown, textinput, keybind, paragraph, dan notify. Versi comment-nya juga tersedia di bagian paling bawah `ThorUi.lua`.

---

## 📜 Lisensi

[MIT](LICENSE) — bebas dipakai, dimodifikasi, dan didistribusikan ulang.
