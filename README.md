# ⚡ ThorUi — Roblox UI Library bertema Dewa Petir

> UI library untuk Roblox dengan tema **Thor / Dewa Petir**: gelap, snappy, dan elektrik.
> Dukungan penuh **PC & Mobile** · Window *draggable* & *resizable* · **100% murni script** (tanpa Asset ID eksternal) · **Anti memory-leak**

| | |
|---|---|
| **Versi** | 1.0.0 |
| **Tipe** | ModuleScript tunggal (Luau), tanpa dependensi |
| **Platform** | PC (Mouse + Keyboard) & Mobile (Touch) |
| **Aset** | `Instance.new` / `UICorner` / `UIStroke` / `UIGradient` saja — anti asset takedown |

---

## 🌩️ Fitur Unggulan

- **Tema Lightning & Thunder** — dasar *Midnight Blue* pekat dengan aksen *Electric Blue* (cyan neon) dan *Lightning Gold*, plus glow sederhana lewat `UIGradient` + layer transparan + stroke neon.
- **Animasi snappy ala kilat** — semua hover, klik, ganti tab, dan show/hide memakai `TweenService` dengan easing cepat (`Quad`, `Quart`, `Back`) supaya terasa responsif.
- **Window draggable** — title bar bisa ditarik dengan **mouse maupun sentuhan** via `UserInputService`.
- **Window resizable** — drag-handle di **sudut kanan bawah** window, dilengkapi `UISizeConstraint` (default minimal `400 × 250`) + auto-clamp untuk layar kecil.
- **Responsif otomatis** — ukuran window default menyesuaikan viewport; jika layar lebih kecil dari batas minimal, ukuran di-clamp otomatis.
- **Floating toggle ⚡** — tombol petir melayang yang bisa digeser ke mana pun dan **snap otomatis ke tepi layar** (perfect untuk Mobile).
- **Keybind toggle UI** — default `RightControl`, bisa diganti kapan saja.
- **Tab system** — konten tiap tab pakai `ScrollingFrame` + `AutomaticCanvasSize`, jadi panjang konten bebas tanpa scroll manual.
- **10 komponen siap pakai** — Button, Toggle, Slider, Dropdown (single & multi-select), TextInput, Keybind, Section, Label, Paragraph, dan Notify.
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
    Size    = UDim2.new(0, 580, 0, 420),   -- kosongkan agar otomatis responsif
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
| `Window:SetCollapsed(bool)` | Lipat window jadi title bar saja (`true`) atau kembalikan (`false`). |
| `Window:SetKeybind(key)` | Alias `ThorUi:SetKeybind()`. |
| `Window:Destroy()` | Hancurkan window ini + bersihkan seluruh memory-nya. |

---

### `Tab` — Komponen

Semua komponen mengembalikan objek `Element` dengan method seragam:
**`Element:Set(...)`** (set nilai; param kedua `false` = tanpa memicu callback), **`Element:Get()`** (ambil nilai), **`Element:Remove()`** (hapus elemen dari UI).

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
| Toggle UI | Ketuk tombol ⚡ melayang (bisa digeser, snap ke tepi) | `RightControl` |
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
