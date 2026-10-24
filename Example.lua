--════════════════════════════════════════════════════════════════════════════
--  ⚡ ThorUi — Example.lua (LocalScript)
--  Tempel file ini sebagai LocalScript di StarterPlayer > StarterPlayerScripts,
--  pastikan ModuleScript "ThorUi" sudah ada di ReplicatedStorage.
--════════════════════════════════════════════════════════════════════════════

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ThorUi = require(ReplicatedStorage:WaitForChild("ThorUi"))

-- (Opsional) kustomisasi tema SEBELUM membuat window:
-- ThorUi.Theme.Accent     = Color3.fromRGB(170, 90, 255)
-- ThorUi.Theme.AccentGold = Color3.fromRGB(255, 200, 60)

local Window = ThorUi:CreateWindow({
        Title = "ThorUi ⚡",
        Size = UDim2.new(0, 620, 0, 430),  -- kosongkan agar otomatis responsif mobile
        MinSize = Vector2.new(400, 250),   -- batas minimal saat resize
        Keybind = Enum.KeyCode.RightControl, -- toggle buka/tutup UI (PC)
        Splash = true,                      -- splash screen (default: window pertama)
        -- ShowToggle = false,              -- sembunyikan tombol ⚡ melayang
})

local Tab = Window:CreateTab({ Name = "Main", Icon = "⚡" })
local Tab2 = Window:CreateTab({ Name = "Info", Icon = "🌩" })

-- v2.2.1: judul menu (section) bisa DIKLIK untuk minimize/membuka isinya:
Tab:AddSection({ Name = "MENU UTAMA" })

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

-- v2.2.1: menu kedua — Collapsed = true → dibuat langsung TERLIPAT; klik
-- judulnya untuk membuka. Elemen setelah baris ini jadi anggota menu ini.
local menuLanjutan = Tab:AddSection({ Name = "MENU LANJUTAN", Collapsed = true })
Tab:AddLabel({ Text = "Menu ini dibuat terlipat — klik judulnya untuk membuka." })

Tab2:AddParagraph({
        Title = "Tentang ThorUi v2",
        Text = "Layout modern dengan tema Dewa Petir: sidebar tab "
                .. "ber-ikon, search bar untuk filter elemen, splash screen, "
                .. "ColorPicker, dan Confirm dialog. Drag window dari logo/sidebar "
                .. "atau header, resize dari sudut kanan bawah.",
})

ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "Script berhasil dimuat!", Duration = 3 })

-- Kontrol programatik:
-- godMode:Set(true)         -> set nilai + panggil callback
-- menuLanjutan:Toggle()     -> minimize/buka menu dari script
-- godMode:Set(true, false)  -> set nilai TANPA callback
-- godMode:Get()             -> ambil nilai
-- Window:Toggle() / Window:Destroy()
-- ThorUi:Destroy()          -> hancurkan seluruh UI + bersihkan memory
