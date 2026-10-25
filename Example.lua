--════════════════════════════════════════════════════════════════════════════
--  ⚡ ThorUi — Example.lua (LocalScript)
--  Tempel file ini sebagai LocalScript di StarterPlayer > StarterPlayerScripts,
--  pastikan ModuleScript "ThorUi" sudah ada di ReplicatedStorage.
--════════════════════════════════════════════════════════════════════════════

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ThorUi = require(ReplicatedStorage:WaitForChild("ThorUi"))

-- (Opsional) kustomisasi tema SEBELUM membuat window (v2.3.0: pakai SetTheme):
-- ThorUi:SetTheme({ Accent = Color3.fromRGB(170, 90, 255), AccentGold = Color3.fromRGB(255, 200, 60) })
-- (cara lama tetap bisa: ThorUi.Theme.Accent = ...)

-- (Opsional, v2.3.1) pasang LOGO SENDIRI — menggantikan palu ThorHub
-- bawaan; berlaku di splash + sidebar + tombol melayang. Panggil SEBELUM
-- CreateWindow, atau per-window: CreateWindow({ Logo = { ... } }):
-- ThorUi:SetLogo({ Image = "rbxassetid://123456789", Size = 26 })

local Window = ThorUi:CreateWindow({
        Title = "ThorHub ⚡",
        Size = UDim2.new(0, 440, 0, 390),  -- v2.2.3: default rada persegu; kosongkan agar otomatis responsif + SELALU muat di layar
        MinSize = Vector2.new(400, 250),   -- batas minimal saat resize
        Keybind = Enum.KeyCode.RightControl, -- toggle buka/tutup UI (PC)
        Splash = true,                      -- splash screen (default: window pertama)
        -- ShowToggle = false,              -- sembunyikan tombol logo melayang
})

local Tab = Window:CreateTab({ Name = "Main", Icon = "⚡" })
local Tab2 = Window:CreateTab({ Name = "Info", Icon = "🌩" })

-- v2.2.1: judul menu (section) bisa DIKLIK untuk minimize/membuka isinya:
Tab:AddSection({ Name = "MENU UTAMA" }) -- v2.2.2: TERLIPAT default; beri Collapsed = false untuk mulai terbuka

Tab:AddButton({
        Name = "Kirim Petir!",
        Callback = function()
                ThorUi:Notify({
                        Title = "⚡ Petir Menyambar",
                        Content = "BOOM! Petir berhasil dikirim ke target.",
                        Duration = 3,
                })
        end,
})

local godMode = Tab:AddToggle({
        Name = "God Mode",
        Default = false,
        Callback = function(value)
                print("God Mode:", value)
        end,
})

-- ═══ v2.3.0: SUB-ROW — toggle dengan anak (klik panah kecil di kiri judul) ═══
local speedHack = Tab:AddToggle({
        Name = "Speed Hack (punya anak)",
        Default = false,
        Callback = function(v)
                print("Speed Hack:", v)
        end,
})
speedHack:AddChild("Slider", {
        Name = "Nilai Speed",
        Min = 16, Max = 500, Default = 16, Suffix = " spd",
        Callback = function(v)
                print("Speed:", v)
        end,
})
speedHack:AddChild("Toggle", { Name = "Terapkan saat lompat juga", Default = true })

-- ═══ v2.3.0: DEPENDS — slider ini hanya tampil saat God Mode ON ═══
Tab:AddSlider({
        Name = "Regen / detik (muncul saat God Mode ON)",
        Min = 0, Max = 100, Default = 10,
        Depends = { Element = godMode, Value = true },
        Callback = function(v)
                print("Regen:", v)
        end,
})

-- ═══ v2.3.0: STATE BINDING — 2 slider berbagi satu nilai ═══
local powerState = ThorUi:CreateState({
        Name = "PowerLevel",
        Default = 50,
        Callback = function(v)
                print("Power state:", v)
        end,
})
local powerA = Tab:AddSlider({ Name = "Power (A)", Min = 0, Max = 100, Default = 50 })
local powerB = Tab:AddSlider({ Name = "Power (B)", Min = 0, Max = 100, Default = 50 })
powerState:Bind(powerA)
powerState:Bind(powerB) -- geser salah satu, keduanya ikut

-- ═══ v2.3.0: SLIDER MULTI-SATUAN — konversi m <-> km otomatis;
-- klik ANGKA untuk mengetik nilai eksak ═══
Tab:AddSlider({
        Name = "Jarak Serangan",
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
        },
        Callback = function(meters)
                print("Jarak (selalu meter):", meters)
        end,
})

-- ═══ v2.3.0: BUTTON dua tahap (ConfirmText) ═══
Tab:AddButton({
        Name = "Reset Progress",
        ConfirmText = "Yakin? Klik lagi!",
        Callback = function()
                print("Progress direset!")
        end,
})

Tab:AddSlider({
        Name = "WalkSpeed",
        Min = 16, Max = 200, Default = 16,
        Increment = 1, Suffix = " spd",
        Callback = function(value)
                local char = Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                        hum.WalkSpeed = value
                end
        end,
})

Tab:AddDropdown({
        Name = "Senjata",
        Values = { "Mjolnir", "Stormbreaker", "Gungnir" },
        Default = "Mjolnir",
        -- Multi = true,  -- aktifkan untuk multi-select
        Callback = function(value)
                print("Senjata:", value)
        end,
})

-- ═══ v2.3.0: DROPDOWN + Search + ApplyButton (pilih dulu, Apply mengirim) ═══
Tab:AddDropdown({
        Name = "Target Farm",
        Values = { "Mob Perum", "Mob Kuil", "Boss Petir", "Boss Es" },
        Multi = true,
        Search = true,
        ApplyButton = "Terapkan",
        Callback = function(values, indices)
                print("Farm:", table.concat(values, ", "))
        end,
})

Tab:AddTextInput({
        Name = "Nama Target",
        Placeholder = "Ketik nama pemain...",
        Callback = function(text, enterPressed)
                print("Input:", text, "| Enter:", enterPressed)
        end,
})

Tab:AddKeybind({
        Name = "Skill Petir",
        Default = Enum.KeyCode.R,
        Callback = function(bind)
                print("Skill dipanggil dengan:", bind.Name)
        end,
})

Tab:AddColorPicker({
        Name = "Warna Petir",
        Default = Color3.fromRGB(0, 195, 255),
        Callback = function(color)
                print("Warna:", color)
        end,
})

Tab:AddButton({
        Name = "Hapus Semua (pakai Confirm)",
        Callback = function()
                Window:Confirm({
                        Title = "Hapus semua data?",
                        Content = "Tindakan ini tidak bisa dibatalkan. Lanjutkan?",
                        ConfirmText = "Ya, hapus",
                        CancelText = "Batal",
                        OnConfirm = function()
                                ThorUi:Notify({ Title = "💥 Dihapus", Content = "Data telah dibersihkan." })
                        end,
                })
        end,
})

-- v2.2.2: TERLIPAT kini DEFAULT semua section — klik judulnya untuk
-- membuka; Collapsed = false untuk mulai TERBUKA. Elemen setelah
-- baris ini jadi anggota menu ini.
local menuLanjutan = Tab:AddSection({ Name = "MENU LANJUTAN", Collapsed = true })
Tab:AddLabel({ Text = "Menu ini dibuat terlipat — klik judulnya untuk membuka." })

-- ═══ v2.3.0: WIDGET BARU ═══

-- LIST: browser item — cari, pilah per grup, klik untuk pilih
Tab:AddList({
        Name = "Gudang Senjata",
        Search = true,
        Groups = {
                { Title = "Palu", Items = {
                        { Text = "Mjolnir", TopRight = "Legendary" },
                        { Text = "Stormbreaker", TopRight = "Mythic" },
                } },
                { Title = "Tombak", Items = { "Gungnir", "Trisula" } },
        },
        OnItemClick = function(item, index, selected)
                print("Pilih:", item.Text, "->", selected)
        end,
})

-- MODELVIEW: etalase 3D (tanpa model -> palu petir bawaan, murni Part)
local etalase = Tab:AddModelView({ Name = "Etalase Palu", Height = 150, Spin = true })
-- etalase:SetModel(workspace.SomeModel)  -> ganti objek kapan pun

-- CANVAS: dashboard mini + update runtime
local dash = Tab:AddCanvas({
        Name = "Statistik",
        Widgets = {
                { Type = "Text", Name = "kills", Text = "Kills", Value = "0" },
                { Type = "Bar", Name = "hp", Text = "Health", Value = 1 },
                { Type = "Button", Name = "rejoin", Text = "Rejoin", Callback = function()
                        print("rejoin!")
                end },
        },
})
-- dash:Set("kills", { Value = "128" })  -> update dari script

-- GROUP (radio): maksimal satu mode aktif
local aimGroup = ThorUi:CreateGroup({ Name = "Mode Aim" })
Tab:AddToggle({ Name = "Aim: Kepala", Group = aimGroup, Default = true })
Tab:AddToggle({ Name = "Aim: Dada", Group = aimGroup })
Tab:AddToggle({ Name = "Aim: Kaki", Group = aimGroup })

-- QUICK ACTION: tombol melayang yang bisa digeser (tetap terlihat
-- walau window tertutup)
ThorUi:AddQuickAction({
        Icon = "⚡",
        Name = "Sambar Sekarang",
        Callback = function()
                print("ZAP!")
        end,
})

Tab2:AddParagraph({
        Title = "Tentang ThorHub v2.3",
        Text = "UI library Dewa Petir: sidebar tab ber-ikon, search bar, "
                .. "splash screen, ColorPicker, Confirm dialog, section yang "
                .. "bisa di-minimize — plus v2.3.0: state binding antar-elemen, "
                .. "Depends (baris otomatis muncul/sembunyi), sub-row AddChild, "
                .. "slider multi-satuan, List browser item, etalase 3D ModelView, "
                .. "dashboard Canvas, grup radio, dan quick action melayang.",
})

ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "Script berhasil dimuat!", Duration = 3 })

-- Kontrol programatik:
-- godMode:Set(true)         -> set nilai + panggil callback
-- menuLanjutan:Toggle()     -> minimize/buka menu dari script
-- godMode:Set(true, false)  -> set nilai TANPA callback
-- godMode:Get()             -> ambil nilai
-- speedHack:SetExpanded(true) -> buka sub-row dari script (v2.3.0)
-- powerState:Set(80)        -> ubah state -> semua elemen terikat ikut (v2.3.0)
-- Window:Toggle() / Window:Destroy()
-- ThorUi:Destroy()          -> hancurkan seluruh UI + bersihkan memory
