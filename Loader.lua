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

-- MENU (section) bisa DI-MINIMIZE — klik judulnya untuk melipat semua
-- fitur di dalamnya. v2.2.2: SEMUA section mulai TERLIPAT biar rapi
-- saat pertama execute; beri Collapsed = false agar mulai terbuka:
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

-- ═══ TAB 2.5: Fitur baru v2.3.0 ═══
local Tab4 = Window:CreateTab({ Name = "v2.3 Fitur", Icon = "🧲" })

Tab4:AddSection({ Name = "STATE BINDING — geser salah satu, keduanya ikut", Collapsed = false })

local powerState = ThorUi:CreateState({
        Name = "PowerLevel",
        Default = 50,
        Callback = function(v)
                print("[TEST][v2.3] Power state =", v)
        end,
})
local sliderA = Tab4:AddSlider({ Name = "Power (A)", Min = 0, Max = 100, Default = 50 })
local sliderB = Tab4:AddSlider({ Name = "Power (B)", Min = 0, Max = 100, Default = 50 })
powerState:Bind(sliderA)
powerState:Bind(sliderB)

Tab4:AddSection({ Name = "DEPENDS — baris muncul/sembunyi otomatis", Collapsed = false })

local depToggle = Tab4:AddToggle({
        Name = "Tampilkan Pengaturan Lanjutan",
        Default = false,
        Callback = function(v)
                print("[TEST][v2.3] Depends source =", v)
        end,
})
Tab4:AddSlider({
        Name = "Regen / detik (muncul saat toggle ON)",
        Min = 0, Max = 100, Default = 10,
        Depends = { Element = depToggle, Value = true },
        Callback = function(v)
                print("[TEST][v2.3] Regen =", v)
        end,
})
Tab4:AddDropdown({
        Name = "Mode Regen (muncul saat toggle ON)",
        Values = { "Perlahan", "Sedang", "Kilat" },
        Depends = { Element = depToggle, Value = true },
})

Tab4:AddSection({ Name = "SUB-ROW — elemen bertingkat (klik panah kiri judul)", Collapsed = false })

local speedParent = Tab4:AddToggle({
        Name = "Speed Hack (punya anak)",
        Default = false,
        Callback = function(v)
                print("[TEST][v2.3] Speed Hack =", v)
        end,
})
speedParent:AddChild("Slider", {
        Name = "Nilai Speed", Min = 16, Max = 500, Default = 16, Suffix = " spd",
        Callback = function(v)
                print("[TEST][v2.3] Child slider =", v)
        end,
})
speedParent:AddChild("Toggle", {
        Name = "Terapkan saat lompat juga",
        Default = true,
})

Tab4:AddSection({ Name = "SLIDER MULTI-SATUAN + ketik nilai eksak", Collapsed = false })

Tab4:AddSlider({
        Name = "Jarak Serangan (klik angkanya!)",
        Description = "Klik ANGKA untuk mengetik nilai eksak. Ganti satuan lewat chip kanan.",
        Min = 0, Max = 10000, Default = 1000,
        Units = {
                Default = "m",
                Options = {
                        { Name = "m", Suffix = "m" },
                        { Name = "km", Suffix = "km", Decimals = 2,
                          FromBase = function(m)
                                return m / 1000
                          end,
                          ToBase = function(km)
                                return km * 1000
                          end },
                },
                Callback = function(unitName)
                        print("[TEST][v2.3] Satuan diganti:", unitName)
                end,
        },
        Callback = function(meters)
                print("[TEST][v2.3] Jarak (selalu meter) =", meters)
        end,
})

Tab4:AddSection({ Name = "DROPDOWN: Search + Apply + opsi runtime", Collapsed = false })

local dd = Tab4:AddDropdown({
        Name = "Target Farm (Search + Apply)",
        Values = { "Mob Perum", "Mob Kuil", "Boss Petir", "Boss Es", "Mini Boss", "Boss Api" },
        Multi = true,
        Search = true,
        ApplyButton = "Terapkan",
        Callback = function(values, indices)
                print("[TEST][v2.3] Farm apply:", table.concat(values, ", "))
                ThorUi:Notify({ Title = "Apply", Content = "Terpilih: " .. #values .. " target", Duration = 3 })
        end,
})
Tab4:AddButton({
        Name = "dd:AddValue('Boss Bayangan')",
        Callback = function()
                dd:AddValue("Boss Bayangan")
        end,
})

Tab4:AddSection({ Name = "LIST — browser item (cari / grup / pilih)", Collapsed = false })

Tab4:AddList({
        Name = "Gudang Senjata",
        Search = true,
        Groups = {
                { Title = "Palu", Items = {
                        { Text = "Mjolnir", TopRight = "Legendary" },
                        { Text = "Stormbreaker", TopRight = "Mythic" },
                } },
                { Title = "Tombak", Items = { "Gungnir", "Trisula" } },
                { Title = "Lainnya", Items = { "Perisai Aegis", "Sarung Besi" } },
        },
        OnItemClick = function(item, index, selected)
                print("[TEST][v2.3] List pilih:", item.Text, "→", selected)
        end,
})

Tab4:AddSection({ Name = "MODELVIEW — etalase 3D + CANVAS dashboard", Collapsed = false })

Tab4:AddModelView({ Name = "Palu Petir (bawaan)", Height = 150, Spin = true })

local dash = Tab4:AddCanvas({
        Name = "Statistik",
        Widgets = {
                { Type = "Text", Name = "kills", Text = "Kills", Value = "0" },
                { Type = "Bar", Name = "hp", Text = "Health", Value = 1 },
                { Type = "Button", Name = "rejoin", Text = "Rejoin", Callback = function()
                        print("[TEST][v2.3] rejoin!")
                end },
                { Type = "Divider" },
                { Type = "Text", Name = "ping", Text = "Ping", Value = "42 ms" },
        },
})
task.spawn(function()
        -- simulasi update dashboard tiap detik (berhenti sendiri saat
        -- elemen dihancurkan / window di-destroy)
        local kills = 0
        while dash and dash.Instance and dash.Instance.Parent do
                task.wait(1)
                kills = kills + 1
                pcall(function()
                        dash:Set("kills", { Value = tostring(kills) })
                        dash:Set("hp", { Value = 0.4 + 0.6 * math.abs(math.sin(kills / 5)) })
                end)
        end
end)

Tab4:AddSection({ Name = "GROUP RADIO + QUICK ACTION", Collapsed = false })

local aimGroup = ThorUi:CreateGroup({ Name = "Mode Aim" })
Tab4:AddToggle({ Name = "Aim: Kepala", Group = aimGroup, Default = true })
Tab4:AddToggle({ Name = "Aim: Dada", Group = aimGroup })
Tab4:AddToggle({ Name = "Aim: Kaki", Group = aimGroup })

ThorUi:AddQuickAction({
        Icon = "⚡",
        Name = "Sambar Sekarang",
        Callback = function()
                ThorUi:Notify({ Title = "⚡ ZAP!", Content = "Quick action ditekan.", Duration = 2 })
        end,
})

-- ═══ TAB 3: Checklist & info ═══
local Tab3 = Window:CreateTab({ Name = "Checklist", Icon = "✅" })

Tab3:AddParagraph({
        Title = "Cara Test Window",
        Text = "1) DRAG title bar dengan mouse/jari — kini BEBAS TANPA batas:\n"
                .. "   window boleh dibawa keluar layar kiri/kanan/atas/bawah!\n"
                .. "   Jika 'hilang': ketuk tombol ⚡ (window tertutup) lalu ketuk\n"
                .. "   ⚡ lagi — window otomatis ditarik balik ke dalam layar.\n"
                .. "2) RESIZE dari handle sudut kanan-bawah (min 400x250).\n"
                .. "3) Klik tab untuk ganti konten (perhatikan underline kilat).\n"
                .. "4) PC: tekan RightControl untuk show/hide.\n"
                .. "5) Mobile: GESER tombol ⚡ melayang ke mana saja — bebas!\n"
                .. "   (tetap di posisi terakhir; ketuk = buka/tutup UI)\n"
                .. "6) Minimize (tombol —) → muncul tombol + di sidebar\n"
                .. "   untuk membesarkan window kembali.\n"
                .. "7) v2.2.1: klik JUDUL SECTION (mis. 'PENGATURAN KARAKTER')\n"
                .. "   untuk MINIMIZE menu — semua fitur di dalamnya terlipat\n"
                .. "   biar daftar lebih rapi (panah di kanan judul berputar).\n"
                .. "8) v2.2.2: SEMUA section mulai TERLIPAT saat pertama execute;\n"
                .. "   panah lipat & panah dropdown DIGAMBAR (bukan glyph font).\n"
                .. "9) v2.2.3: ukuran default window RADA PERSEGU & DIJAMIN\n"
                .. "   MUAT di layar apa pun perangkat — fix 'window langsung\n"
                .. "   terpotong padahal belum diseret ke tepi layar' (akarnya:\n"
                .. "   default lama 540px lebih lebar dari layar hp karena\n"
                .. "   deteksi device keliru melaporkan adanya mouse).",
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
                .. "    pilihan dropdown ('Mjolnir'), panah, keybind, dan hex\n"
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
                .. "    melipat semua fitur di dalamnya biar lebih rapi (panah\n"
                .. "    di kanan judul berputar). Dari script: Section:Toggle()\n"
                .. "    / :SetCollapsed(bool) / :IsCollapsed().\n"
                .. "14) v2.2.2: PANAH ASLI + RAPI + BEBAS — panah section & panah\n"
                .. "    dropdown kini DIGAMBAR dari 2 batang miring (glyph\n"
                .. "    unicode lama ternyata tampil KOTAK kosong di sebagian\n"
                .. "    perangkat — itu 'kotak' yang dulu terlihat); SEMUA\n"
                .. "    section mulai TERLIPAT biar rapi (Collapsed = false\n"
                .. "    untuk mulai terbuka); DRAG window bebas TANPA batas\n"
                .. "    layar; ukuran default window diringkas jadi 540x350.\n"
                .. "15) v2.2.3: UKURAN DEFAULT RADA PERSEGU + SELALU MUAT DI LAYAR\n"
                .. "    (440x390 di layar lebar; proporsional di layar hp).\n"
                .. "    FIX 'drag bebas belum work — window langsung terpotong\n"
                .. "    padahal belum sampai pinggir layar': akarnya default\n"
                .. "    lama 540px LEBIH LEBAR dari layar hp (deteksi\n"
                .. "    MouseEnabled keliru di sebagian Android/emulator) —\n"
                .. "    kini default dihitung murni dari dimensi layar aktual,\n"
                .. "    jadi tak mungkin terpotong lagi. Ambang sidebar\n"
                .. "    icon-only turun 520 → 440px (default persegu tetap\n"
                .. "    menampilkan NAMA tab).\n"
                .. "16) v2.3.0: RILIS FITUR BESAR — tab 'v2.3 Fitur' berisi:\n"
                .. "    STATE BINDING (2 slider berbagi 1 nilai), DEPENDS\n"
                .. "    (baris muncul/sembunyi otomatis), SUB-ROW AddChild\n"
                .. "    (elemen bertingkat — panah kecil di kiri judul),\n"
                .. "    SLIDER MULTI-SATUAN (m ↔ km, klik angka utk ketik\n"
                .. "    eksak), DROPDOWN Search+Apply+opsi runtime, LIST\n"
                .. "    browser item, MODELVIEW etalase 3D (palu petir\n"
                .. "    bawaan murni Part), CANVAS dashboard, GROUP radio,\n"
                .. "    dan QUICK ACTION melayang di pinggir layar.",
})

Tab3:AddSection({ Name = "INFO" })
Tab3:AddLabel({ Text = "ThorUi v" .. tostring(ThorUi.Version) .. " — MIT License" })
Tab3:AddLabel({ Text = "Repo: github.com/dwisetyabudi15581/ThorUi" })
Tab3:AddLabel({ Text = "Output lengkap di console (F9): cari [TEST]" })

--// ─── 4. Sinyal sukses ──────────────────────────────────────────────────────
print("[ThorUi Loader] 🎉 Demo v2.3 siap! Cek tab BARU 'v2.3 Fitur': State binding, Depends, sub-row AddChild, slider multi-satuan, dropdown search+apply, List, ModelView 3D, Canvas, grup radio, quick action. Plus: drag bebas, section terlipat, splash, search bar.")
print("[ThorUi Loader] Ctrl+M = console. RightControl = show/hide UI.")

ThorUi:Notify({
        Title = "⚡ ThorUi v2.3 siap!",
        Content = "Cek 4 tab: Komponen, Kontrol, v2.3 Fitur, Checklist.",
        Duration = 5,
})
