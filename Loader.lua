--════════════════════════════════════════════════════════════════════════════
--  ⚡ ThorUi — Loader.lua (untuk EXECUTOR)
--  ──────────────────────────────────────────────────────────────────────────
--  CARA PAKAI (pilih salah satu):
--
--  1) SATU BARIS (rekomendasi) — paste ke executor lalu Execute:
--     loadstring(game:HttpGet("https://raw.githubusercontent.com/dwisetyabudi15581/ThorUi/main/Loader.lua"))()
--
--  2) FILE INI PENUH — paste seluruh isi file ini ke executor, lalu Execute.
--
--  Loader akan otomatis mengunduh ThorUi.lua dari GitHub, memuatnya,
--  lalu memunculkan window demo untuk test SEMUA komponen.
--════════════════════════════════════════════════════════════════════════════

local GITHUB_RAW = "https://raw.githubusercontent.com/dwisetyabudi15581/ThorUi/main/ThorUi.lua"

--// ─── Notifikasi sistem bawaan Roblox (biar kelihatan walau UI gagal) ───
local function systemNotify(title, text, duration)
        pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title,
                        Text = text,
                        Duration = duration or 5,
                        Icon = "",
                })
        end)
end

--// ─── 1. Unduh source ThorUi dari GitHub ───────────────────────────────────
print("[ThorUi Loader] ⚡ Mengunduh library dari GitHub...")
systemNotify("⚡ ThorUi Loader", "Mengunduh library dari GitHub...", 3)

local okFetch, source = pcall(function()
        return game:HttpGet(GITHUB_RAW)
end)

if not okFetch or type(source) ~= "string" or #source < 100 then
        local reason = (not okFetch) and tostring(source) or "response tidak valid"
        warn("[ThorUi Loader] ❌ Gagal mengunduh: " .. reason)
        systemNotify("❌ ThorUi Gagal", "Download gagal: " .. tostring(reason), 7)
        error("[ThorUi Loader] Download gagal — cek koneksi internet / VPN executor kamu.")
end

--// ─── 2. Muat library (chunk di-compile lalu dieksekusi → table ThorUi) ───
print(("[ThorUi Loader] ✓ Terunduh (%d KB) — memuat library..."):format(#source // 1024))

local okLoad, ThorUi = pcall(function()
        return loadstring(source, "@ThorUi.lua")()
end)

if not okLoad or type(ThorUi) ~= "table" or type(ThorUi.CreateWindow) ~= "function" then
        local reason = (not okLoad) and tostring(ThorUi) or "return value bukan library ThorUi"
        warn("[ThorUi Loader] ❌ Gagal memuat: " .. reason)
        systemNotify("❌ ThorUi Gagal", "Load gagal: " .. tostring(reason), 7)
        error("[ThorUi Loader] Load gagal — " .. tostring(reason))
end

print("[ThorUi Loader] ✓ ThorUi v" .. tostring(ThorUi.Version) .. " berhasil dimuat!")
systemNotify("⚡ ThorUi dimuat!", "v" .. tostring(ThorUi.Version) .. " — window demo dibuka.", 4)

--// ─── 3. Window demo: test semua komponen ──────────────────────────────────
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = ThorUi:CreateWindow({
        Title = "ThorUi Test ⚡",
        MinSize = Vector2.new(400, 250),
        Keybind = Enum.KeyCode.RightControl, -- tekan RightControl untuk show/hide
})

-- ═══ TAB 1: Komponen dasar ═══
local Tab1 = Window:CreateTab({ Name = "Komponen", Icon = "⚡" })

-- v2.2.1: MENU (section) bisa DI-MINIMIZE — klik judulnya untuk melipat
-- semua fitur di dalamnya (chevron ▾ ↔ ▸):
Tab1:AddSection({ Name = "AKSI & PEMBERITAHUAN" })

Tab1:AddButton({
        Name = "Test Notify",
        Callback = function()
                ThorUi:Notify({
                        Title = "⚡ Petir Menyambar",
                        Content = "Ini test notifikasi. Ketuk untuk menutup.",
                        Duration = 4,
                })
        end,
})

Tab1:AddButton({
        Name = "Test Zap (efek kilat)",
        Callback = function()
                ThorUi:Notify({ Title = "🌩 KRAKOOM!", Content = "Efek kilat di kartu baru saja menyala.", Duration = 3 })
        end,
})

-- menu kedua: fitur di bawah baris ini otomatis jadi anggota menu ini
local menuSet = Tab1:AddSection({ Name = "PENGATURAN KARAKTER" })

local toggleRef = Tab1:AddToggle({
        Name = "Test Toggle",
        Description = "Keterangan kecil di bawah judul elemen.",
        Default = false,
        Callback = function(value)
                print("[TEST] Toggle =", value)
                ThorUi:Notify({ Title = "Toggle", Content = "Nilai: " .. tostring(value), Duration = 2 })
        end,
})

Tab1:AddSlider({
        Name = "WalkSpeed",
        Description = "Atur kecepatan jalan karakter (16 - 200).",
        Min = 16, Max = 200, Default = 16,
        Increment = 1, Suffix = " spd",
        Callback = function(value)
                local char = LocalPlayer and LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                        hum.WalkSpeed = value
                end
        end,
})

Tab1:AddDropdown({
        Name = "Test Dropdown (single)",
        Values = { "Mjolnir", "Stormbreaker", "Gungnir" },
        Default = "Mjolnir",
        Callback = function(value)
                print("[TEST] Dropdown single =", value)
        end,
})

Tab1:AddDropdown({
        Name = "Test Dropdown (multi)",
        Values = { "Thor", "Loki", "Odin", "Hela" },
        Multi = true,
        Callback = function(value)
                -- mode multi: value berupa table
                local list = table.concat(value, ", ")
                print("[TEST] Dropdown multi =", list)
                ThorUi:Notify({ Title = "Multi Select", Content = "Terpilih: " .. (list ~= "" and list or "(kosong)"), Duration = 3 })
        end,
})

Tab1:AddTextInput({
        Name = "Test TextInput",
        Placeholder = "Ketik sesuatu lalu Enter...",
        Callback = function(text, enterPressed)
                print("[TEST] TextInput =", text, "| Enter =", enterPressed)
        end,
})

Tab1:AddKeybind({
        Name = "Test Keybind",
        Default = Enum.KeyCode.R,
        Callback = function(bind)
                print("[TEST] Keybind aktif:", bind.Name)
        end,
})

Tab1:AddColorPicker({
        Name = "Test ColorPicker",
        Description = "Slider hue kini bisa digeser dengan jari juga.",
        Default = Color3.fromRGB(0, 195, 255),
        Callback = function(color)
                print("[TEST] Warna dipilih:", color)
        end,
})

Tab1:AddSection({ Name = "DIALOG" })

Tab1:AddButton({
        Name = "Test Confirm Dialog",
        Callback = function()
                Window:Confirm({
                        Title = "Hapus semua data?",
                        Content = "Ini cuma test dialog konfirmasi. Lanjutkan?",
                        ConfirmText = "Ya, lanjut",
                        CancelText = "Batal",
                        OnConfirm = function()
                                ThorUi:Notify({ Title = "✓ Dikonfirmasi", Content = "Kamu menekan tombol konfirmasi.", Duration = 3 })
                        end,
                        OnCancel = function()
                                ThorUi:Notify({ Title = "Dibatalkan", Content = "Kamu menekan tombol batal.", Duration = 3 })
                        end,
                })
        end,
})

-- ═══ TAB 2: Kontrol programatik ═══
local Tab2 = Window:CreateTab({ Name = "Kontrol", Icon = "🎮" })

Tab2:AddSection({ Name = "API PROGRAMATIK" })

Tab2:AddButton({
        Name = "toggleRef:Set(true)  → paksa toggle ON",
        Callback = function()
                toggleRef:Set(true)
        end,
})

Tab2:AddButton({
        Name = "toggleRef:Set(false, silent)  → tanpa callback",
        Callback = function()
                toggleRef:Set(false, true)
        end,
})

Tab2:AddButton({
        Name = "menuSet:SetCollapsed(true/false) — minimize menu",
        Callback = function()
                -- v2.2.1: minimize/buka menu 'PENGATURAN KARAKTER' di tab Komponen
                menuSet:SetCollapsed(true)
                task.delay(2.5, function()
                        menuSet:SetCollapsed(false)
                end)
        end,
})

Tab2:AddButton({
        Name = "Window:Hide() lalu tampil lagi (2 detik)",
        Callback = function()
                Window:Hide()
                task.delay(2, function()
                        Window:Show()
                end)
        end,
})

Tab2:AddButton({
        Name = "Window:SetCollapsed(true/false)",
        Callback = function()
                Window:SetCollapsed(true)
                task.delay(2.5, function()
                        Window:SetCollapsed(false)
                end)
        end,
})

Tab2:AddButton({
        Name = "Buka 3 Notify sekaligus (test stack)",
        Callback = function()
                for i = 1, 3 do
                        task.delay(0.15 * i, function()
                                ThorUi:Notify({ Title = "⚡ Notify #" .. i, Content = "Test stack notifikasi (" .. i .. "/3).", Duration = 4 })
                        end)
                end
        end,
})

Tab2:AddButton({
        Name = "🔴 Window:Destroy() — test cleanup memory",
        Callback = function()
                ThorUi:Notify({ Title = "💥 Destroy", Content = "Window dihancurkan. Execute loader lagi untuk reload.", Duration = 4 })
                task.delay(0.6, function()
                        Window:Destroy()
                end)
        end,
})

-- ═══ TAB 3: Checklist & info ═══
local Tab3 = Window:CreateTab({ Name = "Checklist", Icon = "✅" })

Tab3:AddParagraph({
        Title = "Cara Test Window",
        Text = "1) DRAG title bar dengan mouse/jari.\n"
                .. "2) RESIZE dari handle sudut kanan-bawah (min 400x250).\n"
                .. "3) Klik tab untuk ganti konten (perhatikan underline kilat).\n"
                .. "4) PC: tekan RightControl untuk show/hide.\n"
                .. "5) Mobile: GESER tombol ⚡ melayang ke mana saja — bebas!\n"
                .. "   (tetap di posisi terakhir; ketuk = buka/tutup UI)\n"
                .. "6) Minimize (tombol —) → muncul tombol + di sidebar\n"
                .. "   untuk membesarkan window kembali.\n"
                .. "7) v2.2.1: klik JUDUL SECTION (mis. 'PENGATURAN KARAKTER')\n"
                .. "   untuk MINIMIZE menu — semua fitur di dalamnya terlipat\n"
                .. "   biar daftar lebih rapi (chevron ▾ ↔ ▸).",
})

Tab3:AddParagraph({
        Title = "Yang Baru di v2",
        Text = "1) SPLASH SCREEN muncul saat load (logo ⚡ + progress bar).\n"
                .. "2) SIDEBAR TAB ber-ikon di kiri (auto icon-only saat window sempit).\n"
                .. "3) SEARCH BAR di atas: coba ketik 'toggle' atau 'slider' — elemen terfilter real-time.\n"
                .. "4) COLORPICKER & CONFIRM DIALOG di tab Komponen.\n"
                .. "5) Toggle sekarang berbentuk switch modern.\n"
                .. "6) v2.1.0: FIX ikon ⚡ loncat-loncat saat digeser; window\n"
                .. "   anti hilang dari layar; slider & tombol nyaman disentuh.\n"
                .. "7) v2.1.1: SEMUA elemen menerima Description = 'teks kecil'\n"
                .. "   di bawah judul (lihat slider/toggle/colorpicker di tab\n"
                .. "   Komponen) + FIX ikon ⚡ yang loncat saat baru diklik:\n"
                .. "   kini nol loncatan — ketuk langsung responsif, pop animasi\n"
                .. "   menyala simetris dari tengah; tombol minimize & posisi\n"
                .. "   ikon tab rapi di semua ukuran layar.\n"
                .. "8) v2.1.2: FIX keterangan/teks panjang KETIMPA (track slider\n"
                .. "   menimpa separuh bawah teks keterangan di sebagian HP) —\n"
                .. "   tinggi teks kini diukur sinkron (GetTextSize) lalu dipasang\n"
                .. "   eksplisit: keterangan, Label, Paragraph, isi notifikasi,\n"
                .. "   dan pesan Confirm SELALU utuh terbaca + auto re-ukur saat\n"
                .. "   window di-resize / layar dirotasi.\n"
                .. "9) v2.1.3: FIX error fatal \"'Value' is not a valid member of\n"
                .. "   UDim\" (v2.1.2) yang menggagalkan pembuatan elemen ber-\n"
                .. "   Description di semua perangkat — pengukur tinggi teks kini\n"
                .. "   memakai .Offset yang benar; elemen dibuat normal kembali.\n"
                .. "10) v2.1.4: FIX seluruh WARNA GRADIEN KOTOR — UIGradient ternyata\n"
                .. "    MENGALIKAN (menint) warna background, bukan menimpanya:\n"
                .. "    sidebar & header sempat nyaris HITAM dan fill slider tampak\n"
                .. "    HIJAU (emas tak pernah muncul). Kini semua frame ber-gradien\n"
                .. "    berlatar putih → warna tema tampil murni: sidebar & header\n"
                .. "    navy, fill slider biru listrik menyala + knob stroke EMAS,\n"
                .. "    garis petir & indikator tab emas→biru, tombol ⚡ terlihat.\n"
                .. "11) v2.1.5: KOTAK ABU-ABU DIHAPUS — nilai slider ('124 spd'),\n"
                .. "    pilihan dropdown ('Mjolnir'), panah ▾, keybind, dan hex\n"
                .. "    ColorPicker ternyata berkotak abu-abu default Roblox\n"
                .. "    (RGB 163,162,165) karena label-nya tak diberi\n"
                .. "    BackgroundTransparency. Kini SEMUA label nilai TRANSPARAN\n"
                .. "    — teks emas/biru tema langsung di atas kartu navy.\n"
                .. "12) v2.2.0: OPTIMASI PERFORMA — pengukur teks ber-cache +\n"
                .. "    re-ukur digabung maksimal 1 pass per frame, tween otomatis\n"
                .. "    keluar dari registry saat selesai, hover card hanya untuk\n"
                .. "    perangkat bermouse, search debounce 0.1s. UI jauh lebih\n"
                .. "    ringan & lancar (anti rendutan).\n"
                .. "13) v2.2.1: MENU BISA DI-MINIMIZE — klik judul section untuk\n"
                .. "    melipat semua fitur di dalamnya biar lebih rapi (chevron\n"
                .. "    ▾ ↔ ▸). AddSection({ Collapsed = true }) untuk mulai\n"
                .. "    terlipat, atau dari script: Section:Toggle() /\n"
                .. "    :SetCollapsed(bool) / :IsCollapsed().",
})

Tab3:AddSection({ Name = "INFO" })
Tab3:AddLabel({ Text = "ThorUi v" .. tostring(ThorUi.Version) .. " — MIT License" })
Tab3:AddLabel({ Text = "Repo: github.com/dwisetyabudi15581/ThorUi" })
Tab3:AddLabel({ Text = "Output lengkap di console (F9): cari [TEST]" })

--// ─── 4. Sinyal sukses ──────────────────────────────────────────────────────
print("[ThorUi Loader] 🎉 Demo v2 siap! Coba: splash, sidebar tab, search bar, ColorPicker, Confirm, minimize menu (klik judul section).")
print("[ThorUi Loader] Ctrl+M = console. RightControl = show/hide UI.")

ThorUi:Notify({
        Title = "⚡ ThorUi siap di-test!",
        Content = "Cek 3 tab: Komponen, Kontrol, Checklist.",
        Duration = 5,
})
