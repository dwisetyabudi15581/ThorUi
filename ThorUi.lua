--════════════════════════════════════════════════════════════════════════════
--  ⚡  ThorUi v2.2.1 — Roblox UI Library bertema Dewa Petir (Thor / Petir)
--      Desain, layout & tema 100% original ThorUi ⚡
--  ──────────────────────────────────────────────────────────────────────────
--  Versi     : 2.2.1 (ModuleScript tunggal, tanpa dependensi eksternal)
--  Platform  : PC & Mobile — draggable, resizable, cross-platform
--
--  BARU DI v2.0.0 (tampilan modern)
--  • Splash screen      : logo ⚡ + progress bar + status "memanggil petir"
--  • Sidebar tab        : tab vertikal ber-ikon di sisi kiri (auto icon-only
--                         saat window sempit / mobile)
--  • Search bar         : cari & filter elemen di tab aktif secara real-time
--  • ColorPicker        : kotak SV + slider hue + tampilan HEX/RGB
--  • Confirm dialog     : modal konfirmasi modern (overlay + pop)
--  • Toggle switch      : pill + knob meluncur ala kilat
--
--  BARU & FIX DI v2.1.1 (audit ulang tata letak + keterangan elemen)
--  • Description        : SEMUA elemen (Button/Toggle/Slider/Dropdown/
--                         TextInput/Keybind/ColorPicker/Section) menerima
--                         cfg.Description → teks keterangan kecil di bawah
--                         judul, terbaca jelas di mobile & desktop +
--                         Element:SetDescription(teks) untuk ubah kapan pun
--  • FIX tombol minimize : tombol "—" tidak lagi menimpa search bar
--  • FIX ikon            : ikon tab otomatis DI TENGAH saat sidebar
--                         icon-only; glyph emoji dinudge agar tidak
--                         "melayang" ke atas
--  • FIX drag ikon ⚡    : sumber input (touch/mouse) DIKUNCI saat gesture
--                         → tidak loncat di perangkat hybrid (PC layar
--                         sentuh / tablet + mouse); jari kedua aman
--  • FIX ikon ⚡ klik    : TIDAK LAGI LONCAT saat ditekan — konversi posisi
--                         kini meniru formula engine (bukan AbsolutePosition
--                         yang beda basis koordinat di sebagian executor) +
--                         anchor pusat → animasi pop simetris dari tengah;
--                         snapshot (0,0) dari executor juga diamankan
--  • FIX ColorPicker     : slider HUE kini bisa digeser dengan JARI
--                         (dulu hanya mouse); drag window/resize/slider
--                         juga sudah source-lock & multi-touch aman
--  • FIX slider          : nilai (angka + suffix) tidak terpotong
--  • Confirm dialog      : lebar kartu auto-fit di layar sempit (mobile)
--
--  FIX DI v2.1.2 (dari screenshot user: keterangan slider tertimpa track)
--  • FIX ketimpa teks    : SEMUA teks panjang/wrapped (Description semua
--                         elemen, Label, Paragraph, isi notifikasi, pesan
--                         Confirm) kini diukur tingginya secara SINKRON
--                         (TextService:GetTextSize) → Size eksplisit.
--                         Dulu AutomaticSize.Y di sebagian perangkat (DPI
--                         tinggi / executor) memesan tinggi lebih kecil
--                         dari render asli → track slider / tombol / box
--                         input MENIMPA separuh bawah teks keterangan
--  • Re-ukur otomatis    : tinggi teks dihitung ulang saat teks berubah /
--                         window di-resize / layar dirotasi — selalu pas
--
--  FIX DI v2.1.3 (dari log error user: "'Value' is not a valid member of UDim")
--  • FIX crash fatal     : helper pengukur v2.1.2 mengakses .Value pada
--                         UDim (member itu TIDAK ADA — UDim hanya punya
--                         .Scale & .Offset) → error di fitTextHeight yang
--                         MENGGAGALKAN pembuatan elemen ber-Description
--                         (stack: AddToggle → attachDescription →
--                         autoFitText → fit → fitTextHeight) di SEMUA
--                         perangkat. Kini memakai .Offset yang benar —
--                         elemen dibuat normal & pengukuran anti-ketimpa
--                         v2.1.2 berjalan sebagaimana mestinya.
--
--  FIX DI v2.1.4 (dari screenshot user: "masih ketimpa warna abu-abu")
--  • FIX UIGradient TINT : UIGradient MENGALIKAN warna dengan
--                         BackgroundColor3 (tint — BUKAN menimpa!). Semua
--                         frame ber-gradien yang background-nya BUKAN
--                         putih selama ini render SALAH: sidebar & header
--                         NYARIS HITAM RGB(1,2,4), fill slider BIRU
--                         REDUP→HIJAU (emas tak pernah muncul karena R
--                         background = 0), tombol ⚡ & lingkaran splash
--                         nyaris hitam, garis petir hijau gelap. Kini
--                         SEMUA frame ber-gradien berlatar PUTIH → warna
--                         gradien tampil persis tema (navy, emas, biru).
--  • FIX fill slider      : gradien biru→emas selalu melintas zona abu
--                         kehijauan (interpolasi sRGB) — diganti gradien
--                         selaras-hue biru→biru muda vertikal (efek
--                         "kilat menyala") + stroke KNOB emas. Slider
--                         kini cerah, tanpa jejak abu-abu/kehijauan.
--  • FIX tombol Confirm   : gradien biru→emas (berefek kotor sama)
--                         diganti solid Electric Blue + teks putih.
--
--  FIX DI v2.1.5 (dari screenshot user: nilai slider "124 spd" & pilihan
--                  dropdown "Mjolnir" tampak DI DALAM KOTAK ABU-ABU)
--  • FIX kotak abu-abu   : TextLabel nilai — slider ("124 spd"), dropdown
--                         ("Mjolnir ▾"), keybind, hex ColorPicker — tidak
--                         diberi BackgroundTransparency, sehingga Roblox
--                         merender background DEFAULT abu-abu
--                         RGB(163,162,165) di belakang teksnya. Kini SEMUA
--                         label nilai TRANSPARAN: teks emas/biru tema
--                         langsung di atas kartu navy — tanpa kotak.
--  • Helper Create        : kini mencegah kotak abu serupa di masa depan —
--                         TextLabel tanpa background eksplisit otomatis
--                         transparan (audit: tidak ada TextLabel
--                         ber-background di seluruh kodebase; swatch warna
--                         ColorPicker adalah Frame, bukan TextLabel).
--
--  OPTIMASI DI v2.2.0 (permintaan user: "masih terasa berat banyak
--                      rendutan — bikin seringan mungkin")
--  • Cache pengukuran    : pengukur tinggi teks (GetTextSize) kini ber-
--                         cache — teks & lebar tidak berubah = NOL ukur
--                         ulang; Size hanya ditulis bila tinggi benar2
--                         berubah (memutus reaksi berantai layout↔signal)
--  • Refit terjadwal     : semua re-ukur digabung maksimal SATU pass per
--                         frame utk SELURUH label (dulu: per label per
--                         frame saat resize/rotasi → sumber rendutan)
--  • Registry otomatis    : tween yang SELESAI otomatis keluar dari daftar
--                         — dulu tiap hover/tap menumpuk tween mati sampai
--                         window dihancurkan (ribuan entri di sesi panjang
--                         → memori bengkak + Destroy/Remove makin lambat)
--  • Hover hemat mobile  : efek hover card hanya dipasang di perangkat
--                         bermouse — sentuhan mobile tak lagi membuat 2-4
--                         tween percuma per ketukan (feedback tetap ada:
--                         kilat Zap, animasi switch, splash tombol)
--  • Search debounce     : filter elemen digabung 0.1s sekali saat mengetik
--                         (dulu re-layout penuh tiap huruf)
--  • Rebranding          : semua referensi library luar dihapus — desain,
--                         layout & tema kini 100% original ThorUi
--
--  BARU DI v2.2.1 (permintaan user: "di dalam menu ada fitur — tolong
--                  tambahkan minimize menu biar lebih rapi")
--  • Menu minimizable    : judul section kini bisa DIKLIK untuk menutup /
--                         membuka SEMUA fitur di dalamnya (sampai section
--                         berikutnya) — chevron ▾ berputar jadi ▸ sebagai
--                         penanda; judul section lain tetap terlihat
--  • AddSection(cfg)     : Collapsed = true → menu dibuat langsung terlipat
--  • API programatik     : Section:SetCollapsed(bool) · :Toggle() ·
--                         :IsCollapsed() · SetDescription(teks)
--  • Search-aware        : pencarian TIDAK membuka lipatan menu — anggota
--                         menu yang di-minimize tetap tersembunyi, dan
--                         judul menu tanpa hasil cocok ikut disembunyikan
--  • Hemat performa      : lipatan diterapkan TANPA tween per elemen (satu
--                         pass visibility) — setia pada optimasi v2.2.0
--
--  FITUR LANJUTAN
--  • Tema Lightning & Thunder : Midnight Blue + Electric Blue / Lightning Gold
--  • Animasi snappy ala kilat : TweenService (Back / Quart / Quad, cepat)
--  • Glow sederhana           : UIGradient + layer transparan + stroke neon
--  • Window draggable         : Mouse & Touch via UserInputService
--  • Window resizable         : drag-handle di sudut kanan-bawah window
--  • UISizeConstraint         : ukuran minimal (default 400 x 250)
--  • Floating toggle ⚡        : bisa digeser BEBAS ke mana pun (di-clamp ke layar)
--  • Keybind toggle UI        : default RightControl (bisa diganti)
--  • Konten ScrollingFrame    : AutomaticCanvasSize (elemen tak terbatas)
--  • 100% murni script        : Instance.new / UICorner / UIStroke — tanpa
--                               Asset ID gambar sama sekali (anti banned asset)
--  • Anti memory-leak         : semua connection & tween masuk garbage table
--                               (Registry), otomatis di-Clean saat Destroy
--
--  RINGKASAN API
--  ──────────────────────────────────────────────────────────────────────────
--  ThorUi:CreateWindow({Title, Size, MinSize, Position, Keybind, ShowToggle,
--                       Splash})
--  ThorUi:Notify({Title, Content, Duration, Icon})
--  ThorUi:SetKeybind(Enum.KeyCode.X)    ThorUi:Toggle()    ThorUi:Destroy()
--  ThorUi:SetToggleVisible(bool)
--
--  Window:CreateTab({Name, Icon})        Window:Show()/Hide()/Toggle()
--  Window:SetCollapsed(bool)             Window:Destroy()
--  Window:SetKeybind(Enum.KeyCode.X)     Window:SetTitle(text)
--  Window:Confirm({Title, Content, ConfirmText, CancelText, OnConfirm, OnCancel})
--
--  Tab:AddButton({Name, Callback})
--  Tab:AddToggle({Name, Default, Callback})              :Set(bool) / :Get()
--  Tab:AddSlider({Name, Min, Max, Default, Increment, Precision, Suffix, Callback})
--  Tab:AddDropdown({Name, Values, Default, Multi, Callback})
--  Tab:AddTextInput({Name, Text, Placeholder, ClearOnFocus, Callback(text, enter)})
--  Tab:AddKeybind({Name, Default, Callback})             :SetKey(enum) / :Get()
--  Tab:AddColorPicker({Name, Default, Callback})          :Set(Color3) / :Get()
--  Tab:AddSection({Name, Description, Collapsed})  → Section (menu)
--     Section:SetCollapsed(bool)  Section:Toggle()  Section:IsCollapsed()
--  Tab:AddLabel({Text})   Tab:AddParagraph({Title, Text})
--  Element:Set(...)         Element:Get()          Element:Remove()
--  Element:SetDescription(teks)   → ubah keterangan elemen kapan pun
--
--  Catatan: SEMUA elemen menerima Description = "keterangan kecil" yang
--  ditampilkan di bawah judul elemen. Ubah warna di ThorUi.Theme
--  SEBELUM CreateWindow untuk custom tema. Contoh implementasi lengkap ada
--  di BLOK PALING BAWAH file ini.
--════════════════════════════════════════════════════════════════════════════

--// ───────────────────────────── Services ──────────────────────────────────
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local TextService      = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

--// ─────────────────────────────── Library ──────────────────────────────────
local ThorUi = {
    Version = "2.2.1",
}

--// ──────────────────────────────── Tema ────────────────────────────────────
--  Midnight Blue pekat sebagai dasar; Electric Blue & Lightning Gold sebagai
--  aksen tombol aktif, toggle, slider, dan UIStroke.
local Theme = {
    Background    = Color3.fromRGB(11, 14, 23),   -- midnight blue pekat
    BackgroundAlt = Color3.fromRGB(16, 20, 32),
    Card          = Color3.fromRGB(21, 26, 41),   -- background elemen
    CardHover     = Color3.fromRGB(28, 36, 56),
    Track         = Color3.fromRGB(36, 44, 66),   -- slider / toggle OFF
    Accent        = Color3.fromRGB(0, 195, 255),  -- electric blue (cyan neon)
    AccentGold    = Color3.fromRGB(255, 190, 0),  -- petir emas (lightning gold)
    Text          = Color3.fromRGB(240, 244, 255),
    TextDim       = Color3.fromRGB(145, 155, 180),
    White         = Color3.fromRGB(255, 255, 255),
    Stroke        = Color3.fromRGB(0, 150, 200),  -- garis tepi aktif
    StrokeDim     = Color3.fromRGB(45, 58, 88),   -- garis tepi pasif
    Danger        = Color3.fromRGB(255, 84, 84),
    FontMain      = Enum.Font.Gotham,
    FontMedium    = Enum.Font.GothamMedium,
    FontBold      = Enum.Font.GothamBold,
}
ThorUi.Theme = Theme

--// ─────────────────────── Easing "kilat petir" (snappy) ────────────────────
local TI_HOVER  = TweenInfo.new(0.12, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_SNAP   = TweenInfo.new(0.18, Enum.EasingStyle.Quart,  Enum.EasingDirection.Out)
local TI_STRIKE = TweenInfo.new(0.28, Enum.EasingStyle.Back,   Enum.EasingDirection.Out)
local TI_EXIT   = TweenInfo.new(0.16, Enum.EasingStyle.Quart,  Enum.EasingDirection.In)

--// ──────────────── Registry: garbage table anti memory-leak ────────────────
--  Semua RBXScriptConnection & Tween disimpan ke dalam satu table sampah,
--  lalu diputus (:Disconnect() / :Cancel()) otomatis oleh Registry:Clean()
--  saat window / elemen / UI dihancurkan.
local Registry = {}
Registry.__index = Registry

function Registry.new()
    return setmetatable({ _conns = {}, _tweens = {} }, Registry)
end

function Registry:Connect(signal, handler)
    local conn = signal:Connect(handler)
    table.insert(self._conns, conn)
    return conn
end

--  OPTIMASI v2.2.0: tween yang SUDAH SELESAI otomatis keluar dari daftar.
--  Dulu setiap Tween() (hover, zap, animasi) menempel di _tweens SAMPAI
--  registry di-Clean — di sesi panjang menumpuk RIBUAN tween mati (memori
--  bengkak + Clean/Destroy makin lambat). Completed juga terpicu oleh
--  :Cancel(), jadi entri ikut bersih saat Clean.
function Registry:Track(tween)
    local list = self._tweens
    list[#list + 1] = tween
    local function release()
        local t = self._tweens
        local n = #t
        for i = 1, n do
            if t[i] == tween then
                t[i] = t[n]
                t[n] = nil
                break
            end
        end
    end
    tween.Completed:Connect(release)
    return tween
end

function Registry:Clean()
    -- OPTIMASI v2.2.0: kosongkan daftar DULU, baru proses snapshot —
    -- menghindari mutasi-tengah-iterasi saat :Cancel() memicu Completed
    -- (yang kini melepas tween dari daftar).
    local conns = self._conns
    local tweens = self._tweens
    self._conns = {}
    self._tweens = {}
    for _, conn in ipairs(conns) do
        if conn.Connected then
            pcall(function()
                conn:Disconnect()
            end)
        end
    end
    for _, tween in ipairs(tweens) do
        pcall(function()
            tween:Cancel()
        end)
    end
end

--// ───────────────────────── Helper inti (murni script) ─────────────────────
--  Instance builder: properti dipasang dulu, Parent paling akhir.
local function Create(className, props)
    local inst = Instance.new(className)
    if props then
        -- FIX v2.1.5: TextLabel tanpa BackgroundTransparency & tanpa
        -- BackgroundColor3 eksplisit merender KOTAK ABU-ABU default Roblox
        -- (RGB 163,162,165) di belakang teksnya — inilah "kotak abu abu"
        -- yang menimpa nilai slider "124 spd" & pilihan dropdown "Mjolnir".
        -- Default-kan transparan (audit: TIDAK ada TextLabel ber-background
        -- di kodebase; swatch warna ColorPicker adalah Frame, bukan TextLabel).
        if className == "TextLabel"
            and props.BackgroundTransparency == nil
            and props.BackgroundColor3 == nil then
            inst.BackgroundTransparency = 1
        end
        for key, value in pairs(props) do
            if key ~= "Parent" and value ~= nil then
                inst[key] = value
            end
        end
        if props.Parent ~= nil then
            inst.Parent = props.Parent
        end
    end
    return inst
end

local function Corner(parent, radius)
    if typeof(radius) == "UDim" then
        return Create("UICorner", { CornerRadius = radius, Parent = parent })
    end
    return Create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function Stroke(parent, props)
    props = props or {}
    return Create("UIStroke", {
        Color = props.Color or Theme.StrokeDim,
        Thickness = props.Thickness or 1,
        Transparency = props.Transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function Gradient(parent, colorA, colorB, rotation, transparency)
    local props = {
        Color = ColorSequence.new(colorA, colorB),
        Rotation = rotation or 0,
        Parent = parent,
    }
    if transparency then
        props.Transparency = transparency
    end
    return Create("UIGradient", props)
end

--  Buat & mainkan tween langsung; otomatis masuk garbage table.
local function Tween(registry, object, info, goal)
    local tween = TweenService:Create(object, info, goal)
    if registry then
        registry:Track(tween)
    end
    tween:Play()
    return tween
end

--  Kilatan petir: overlay cepat memudar saat elemen diklik.
local function Zap(registry, parent, color, radius)
    local flash = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = color or Theme.AccentGold,
        BackgroundTransparency = 0.62,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = parent,
    })
    Corner(flash, radius or 8)
    local tween = TweenService:Create(
        flash,
        TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundTransparency = 1 }
    )
    if registry then
        registry:Track(tween)
    end
    tween:Play()
    local function onZapDone()
        flash:Destroy()
    end
    if registry then
        registry:Connect(tween.Completed, onZapDone)
    else
        tween.Completed:Connect(onZapDone)
    end
end

--  Efek hover standar untuk card interaktif (stroke neon menyala).
--  OPTIMASI v2.2.0: hover hanya dipasang di perangkat BERMOUSE. Di layar
--  sentuh, tiap tap ikut memicu MouseEnter/Leave → 2-4 tween percuma per
--  ketukan. Umpan balik sentuh tetap ada: kilat Zap & animasi switch/knob.
local HOVER_FOR_MOUSE = UserInputService.MouseEnabled

local function cardHover(registry, card, stroke)
    if not HOVER_FOR_MOUSE then
        return
    end
    registry:Connect(card.MouseEnter, function()
        Tween(registry, card, TI_HOVER, { BackgroundColor3 = Theme.CardHover })
        Tween(registry, stroke, TI_HOVER, { Color = Theme.Stroke, Transparency = 0.05 })
    end)
    registry:Connect(card.MouseLeave, function()
        Tween(registry, card, TI_HOVER, { BackgroundColor3 = Theme.Card })
        Tween(registry, stroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.35 })
    end)
end

--// ──────────────────────── Util platform & angka ───────────────────────────
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local function GetViewport()
    local camera = workspace.CurrentCamera
    if camera then
        return camera.ViewportSize
    end
    return Vector2.new(1280, 720)
end

--  Filter gerakan untuk gesture yang sedang berjalan (drag/geser).
--  FIX v2.1.1 "loncat-loncat" di perangkat HYBRID (mouse + layar sentuh):
--  begitu gesture dimulai dari SENTUHAN, hanya InputObject sentuhan YANG
--  SAMA yang boleh menggerakkan UI; begitu dari MOUSE, hanya MouseMovement.
--  Tanpa ini, posisi mouse yang menetap di tempat lain ikut terbaca →
--  ikon / jendela / slider meloncat ke posisi aneh.
local function gestureInput(startInput, input)
    if not startInput then
        return false
    end
    if startInput.UserInputType == Enum.UserInputType.Touch then
        return input == startInput
    end
    return input.UserInputType == Enum.UserInputType.MouseMovement
end

--  Filter akhir gesture: hanya input yang MEMULAI gesture (atau lepasnya
--  klik kiri mouse) yang boleh mengakhirinya — jari kedua / tombol lain
--  tidak mengganggu drag yang sedang berjalan.
local function gestureEnded(startInput, input)
    if startInput and startInput.UserInputType == Enum.UserInputType.Touch then
        return input == startInput
    end
    return input.UserInputType == Enum.UserInputType.MouseButton1
end

--// ── FIX v2.1.2: pengukuran tinggi teks SINKRON (anti ketimpa teks) ─────
--  Pola "TextLabel TextWrapped + AutomaticSize.Y" TIDAK AKURAT di sebagian
--  perangkat (layar DPI tinggi / executor / AutomaticSize bersarang dalam
--  kartu yang juga automatic): tinggi yang dipesan untuk UIListLayout LEBIH
--  KECIL dari tinggi render teks → baris setelahnya (track slider, box
--  input, tombol, garis section) MENIMPA separuh bawah teks keterangan.
--  (Gejala dari screenshot user: keterangan slider "...karakter (16 - 200)"
--  terpotong track slider.) Solusi: ukur tinggi teks secara EKSPLISIT via
--  TextService:GetTextSize — sinkron, memakai lebar render sesungguhnya —
--  lalu set Size eksplisit. UIListLayout selalu memesan ruang yang PAS.
--// ── OPTIMASI v2.2.0: cache + refit terjadwal (anti rendutan) ───────────
--  GetTextSize itu MAHAL bila dipanggil per-frame. Pola v2.1.2 menghubung-
--  kan tiap label ke sinyal AbsoluteSize parent → saat window di-resize /
--  layar dirotasi, pengukuran menyeruak PER FRAME untuk SEMUA label, lalu
--  tulisan Size memicu re-layout berantai (card AutomaticSize.Y → holder
--  → ScrollingFrame AutomaticCanvasSize) — inilah sumber "rendutan".
--  Solusi dua lapis:
--    (1) CACHE   : teks & lebar tak berubah → NOL ukur ulang; Size hanya
--                 ditulis bila tinggi benar-benar berubah (memutus reaksi
--                 berantai layout ↔ signal).
--    (2) BATCHED: semua permintaan re-ukur digabung maksimal SATU pass
--                 per frame (task.defer) untuk seluruh label.
--  Tabel ber-key LEMAH (weak) → label yang di-:Destroy() otomatis ke-GC.
local FitCache = setmetatable({}, { __mode = "k" })
local FitQueue = setmetatable({}, { __mode = "k" })
local fitIdle = true

local function fitTextHeight(label, minH)
    local parent = label.Parent
    if not parent then
        return
    end
    local pad = 0
    for _, ch in ipairs(parent:GetChildren()) do
        if ch:IsA("UIPadding") then
            pad = ch.PaddingLeft.Offset + ch.PaddingRight.Offset
            break
        end
    end
    -- lebar render label (semua teks fit ini lebar penuh: Scale X = 1 dari
    -- area konten parent = lebar parent - padding kiri/kanan)
    local w = math.max(parent.AbsoluteSize.X - pad, 60)
    -- OPTIMASI v2.2.0: teks & lebar tidak berubah → skip GetTextSize
    local c = FitCache[label]
    if c and c.Text == label.Text and c.W == w and c.H == label.Size.Y.Offset then
        return
    end
    local bounds = TextService:GetTextSize(label.Text or "", label.TextSize, label.Font, Vector2.new(w, 10000))
    local h = math.max(minH or 14, math.ceil(bounds.Y) + 3)
    FitCache[label] = { Text = label.Text, W = w, H = h }
    if label.Size.Y.Offset ~= h then
        label.Size = UDim2.new(1, 0, 0, h)
    end
end

local function scheduleFit(label, minH)
    FitQueue[label] = minH
    if fitIdle then
        fitIdle = false
        task.defer(function()
            fitIdle = true
            local queue = FitQueue
            FitQueue = setmetatable({}, { __mode = "k" })
            for l, mh in pairs(queue) do
                if l.Parent then
                    pcall(fitTextHeight, l, mh)
                end
            end
        end)
    end
end

--  Pasang pengukuran otomatis: hitung ulang saat teks berubah / lebar
--  parent berubah (resize window, rotasi layar, pass layout pertama).
--  Koneksi signal mati sendiri saat label / parent di-:Destroy() → aman memori.
local function autoFitText(label, minH)
    label:GetPropertyChangedSignal("Text"):Connect(function()
        scheduleFit(label, minH)
    end)
    if label.Parent then
        label.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            scheduleFit(label, minH)
        end)
    end
    fitTextHeight(label, minH)
    scheduleFit(label, minH) -- re-cek sekali setelah pass layout pertama
end

local function decimalsOf(n)
    local s = tostring(n)
    local dot = string.find(s, ".", 1, true)
    return dot and (#s - dot) or 0
end

local function formatValue(value, precision)
    precision = precision or 0
    if precision <= 0 then
        return tostring(math.floor(value + 0.5))
    end
    return string.format("%." .. precision .. "f", value)
end

local function contains(list, value)
    for _, v in ipairs(list) do
        if v == value then
            return true
        end
    end
    return false
end

local function removeFrom(list, value)
    for i, v in ipairs(list) do
        if v == value then
            table.remove(list, i)
            return true
        end
    end
    return false
end

local function hexFromColor3(c)
    return string.format(
        "#%02X%02X%02X",
        math.floor(c.R * 255 + 0.5),
        math.floor(c.G * 255 + 0.5),
        math.floor(c.B * 255 + 0.5)
    )
end

--// ────────────────────────── State library-level ───────────────────────────
local _state = {
    Gui           = nil,  -- ScreenGui utama (CoreGui → PlayerGui fallback)
    NotifyHolder  = nil,  -- kolom notifikasi (kanan atas)
    ToggleButton  = nil,  -- tombol melayang ⚡
    TogglePulse   = nil,  -- tween denyut tombol ⚡
    ToggleKey     = Enum.KeyCode.RightControl,
    ToggleVisible = true,
    KeyConn       = nil,
    Windows       = {},
    Notifs        = {},
    Registry      = Registry.new(), -- garbage table level library
    SplashDone    = false, -- splash hanya sekali per sesi (window pertama)
    SplashActive  = false,
}

local TOGGLE_SIZE = 48

--// ─────────────────── Parenting (CoreGui → PlayerGui) ──────────────────────
local function ensureGui()
    if _state.Gui and _state.Gui.Parent then
        return _state.Gui
    end
    -- bersihkan sisa UI ThorUi dari eksekusi sebelumnya (hindari tombol ⚡
    -- dan window LAMA menumpuk di atas UI yang baru — penting saat re-execute)
    local function purgeOld(container)
        if not container then
            return
        end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("ScreenGui") and string.sub(child.Name, 1, 7) == "ThorUi_" then
                child:Destroy()
            end
        end
    end
    pcall(purgeOld, game:GetService("CoreGui"))
    if LocalPlayer then
        pcall(purgeOld, LocalPlayer:FindFirstChild("PlayerGui"))
    end
    local gui = Create("ScreenGui", {
        Name = "ThorUi_" .. tostring(math.floor(os.clock() * 1000)),
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 99999,
    })
    local ok = pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)
    if not ok or not gui.Parent then
        gui.Parent = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")
    end
    _state.Gui = gui
    return gui
end

--// ───────────────────────── Notifikasi (⚡ slide) ───────────────────────────
local function ensureNotifyHolder()
    if _state.NotifyHolder and _state.NotifyHolder.Parent then
        return _state.NotifyHolder
    end
    local gui = ensureGui()
    local holder = Create("Frame", {
        Name = "ThorUi_NotifyStack",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 10),
        Size = UDim2.new(0, 300, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 60,
        Parent = gui,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = holder,
    })
    _state.NotifyHolder = holder
    return holder
end

local function despawnNotification(entry, instant)
    if not entry or entry.Dead then
        return
    end
    entry.Dead = true
    if entry.Task then
        pcall(function()
            task.cancel(entry.Task)
        end)
    end
    for i, e in ipairs(_state.Notifs) do
        if e == entry then
            table.remove(_state.Notifs, i)
            break
        end
    end
    if instant or not entry.Container.Parent then
        entry.Container:Destroy()
        return
    end
    local out = TweenService:Create(entry.Notif, TI_EXIT, {
        Position = UDim2.new(1, 0, 0, 0),
        GroupTransparency = 1,
    })
    out:Play()
    out.Completed:Connect(function()
        entry.Container:Destroy()
    end)
end

--  ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "...", Duration = 3 })
--  Muncul dari sudut kanan atas layar dengan animasi menyambar + fade cepat.
function ThorUi:Notify(cfg)
    if not LocalPlayer then
        warn("[ThorUi] Notify hanya bisa dipanggil dari client.")
        return nil
    end
    cfg = cfg or {}
    local holder = ensureNotifyHolder()

    -- container (diatur UIListLayout, tinggi otomatis)
    local container = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = #_state.Notifs + 1,
        Parent = holder,
    })

    -- badan notifikasi (CanvasGroup agar bisa fade GroupTransparency)
    local notif = Create("CanvasGroup", {
        Position = UDim2.new(1, 0, 0, 0), -- mulai offscreen kanan
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        GroupTransparency = 1,
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        Parent = container,
    })
    Corner(notif, 10)
    Stroke(notif, { Color = Theme.Stroke, Transparency = 0.3 })

    -- bar petir di sisi kiri
    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        -- PUTIH: UIGradient menint/mengalikan → warna gradien tampil murni
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = notif,
    })
    Corner(bar, UDim.new(1, 0))
    Gradient(bar, Theme.AccentGold, Theme.Accent, 90)

    -- konten dibungkus inner frame agar bar tidak ikut UIListLayout
    local inner = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notif,
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 12),
        Parent = inner,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = inner,
    })

    local row1 = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        LayoutOrder = 1,
        Parent = inner,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 14, 1, 0),
        Text = cfg.Icon or "⚡",
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row1,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 0),
        Size = UDim2.new(1, -18, 1, 0),
        Text = cfg.Title or "ThorUi",
        Font = Theme.FontBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row1,
    })
    local contentLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        -- FIX v2.1.2: tinggi eksplisit terukur (autoFitText) — bukan
        -- AutomaticSize.Y yang bisa memesan tinggi kurang dari teks →
        -- teks notifikasi terpotong di dasar kartu
        Text = cfg.Content or "",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2,
        Parent = inner,
    })
    autoFitText(contentLabel, 0)

    local entry = { Container = container, Notif = notif, Dead = false, Task = nil }
    table.insert(_state.Notifs, entry)

    -- batasi jumlah notifikasi yang tampil (max 5)
    if #_state.Notifs > 5 then
        despawnNotification(_state.Notifs[1], true)
    end

    -- animasi masuk: tunggu layout selesai (2 frame), lalu menyambar masuk
    task.spawn(function()
        RunService.RenderStepped:Wait()
        RunService.RenderStepped:Wait()
        if not container.Parent or entry.Dead then
            return
        end
        Tween(_state.Registry, notif, TI_STRIKE, { Position = UDim2.new(0, 0, 0, 0) })
        Tween(_state.Registry, notif, TI_SNAP, { GroupTransparency = 0 })
    end)

    -- auto-tutup sesuai Duration
    entry.Task = task.delay((cfg.Duration or 4) + 0.45, function()
        despawnNotification(entry, false)
    end)

    -- ketuk / sentuh untuk menutup lebih cepat
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            despawnNotification(entry, false)
        end
    end)

    return entry
end

--// ─────────────────── Toggle semua window (⚡ / keybind) ────────────────────
local function toggleWindows()
    if #_state.Windows == 0 then
        return
    end
    -- window yang sedang proses menutup (_closing) dihitung "tidak terlihat"
    -- supaya tap cepat berturut-turut langsung membatalkan hide & pop kembali
    local anyVisible = false
    for _, w in ipairs(_state.Windows) do
        if w.Frame.Visible and not w._closing then
            anyVisible = true
            break
        end
    end
    for _, w in ipairs(_state.Windows) do
        if anyVisible then
            w:Hide()
        else
            w:Show()
        end
    end
end

local function bindToggleKey(key)
    if key then
        _state.ToggleKey = key
    end
    if _state.KeyConn then
        return
    end
    -- satu koneksi global; key dibaca dinamis saat runtime
    _state.KeyConn = _state.Registry:Connect(UserInputService.InputBegan, function(input, processed)
        if processed then
            return
        end
        if input.KeyCode == _state.ToggleKey then
            toggleWindows()
        end
    end)
end

--// ────────────────── Tombol melayang ⚡ (drag bebas + ketuk) ──────────────────
local function ensureToggleButton()
    if _state.ToggleButton and _state.ToggleButton.Parent then
        _state.ToggleButton.Visible = _state.ToggleVisible
        return _state.ToggleButton
    end
    local gui = ensureGui()
    local reg = _state.Registry

    local btn = Create("TextButton", {
        Name = "ThorUi_Toggle",
        Text = "",
        AutoButtonColor = false,
        ZIndex = 50,
        -- anchor TENGAH (0.5,0.5) permanen: animasi pop & efek "digenggam"
        -- menyala SIMETRIS dari pusat. (Dengan anchor 0,0 ikon membesar ke
        -- kanan-bawah → tampak seperti terloncat setiap kali diketuk.)
        -- Anchor tidak pernah diubah saat drag → tidak ada loncatan anchor.
        AnchorPoint = Vector2.new(0.5, 0.5),
        -- posisi awal = titik TENGAH ikon: tepi kanan 16px, 72% tinggi layar
        Position = UDim2.new(1, -16 - TOGGLE_SIZE * 0.5, 0.72, 0),
        Size = UDim2.fromOffset(TOGGLE_SIZE, TOGGLE_SIZE),
        -- PUTIH: agar gradien Card→Alt tampil murni (bukan tertint gelap)
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        Visible = _state.ToggleVisible,
        Parent = gui,
    })
    Corner(btn, UDim.new(1, 0))
    Gradient(btn, Theme.Card, Theme.BackgroundAlt, 45)
    Stroke(btn, { Color = Theme.Accent, Thickness = 1.5, Transparency = 0.1 })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 2), -- +2px: glyph ⚡ emoji cenderung melayang ke atas
        Size = UDim2.new(1, 0, 1, 0),
        Text = "⚡",
        Font = Theme.FontBold,
        TextSize = 26,
        TextColor3 = Theme.White,
        Parent = btn,
    })

    -- halo berdenyut (glow petir sederhana via transparansi)
    local glow = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1.18, 0, 1.18, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.86,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = btn,
    })
    Corner(glow, UDim.new(1, 0))
    local pulse = TweenService:Create(
        glow,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { BackgroundTransparency = 0.94 }
    )
    reg:Track(pulse)
    pulse:Play()
    _state.TogglePulse = pulse

    local scale = Create("UIScale", { Parent = btn })

    local function popScale()
        local t1 = Tween(reg, scale, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1.22 })
        reg:Connect(t1.Completed, function(playback)
            if playback == Enum.PlaybackState.Completed and btn.Parent then
                Tween(reg, scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
            end
        end)
    end

    -- drag BEBAS + klik (responsif mouse & sentuhan, aman multi-touch)
    --  FIX v2.1.1: sumber input DIKUNCI saat gesture (touch → InputObject
    --  yang sama; mouse → MouseMovement) + snapshot NILAI posisi awal.
    --  FIX "loncat setiap kali diklik": dulu posisi awal drag dibaca dari
    --  AbsolutePosition lalu ditulis ke Position — di beberapa lingkungan
    --  (CoreGui/executor/DPI mobile) keduanya berbeda basis koordinat,
    --  sehingga SETIAP tekanan ikon melompat dulu baru bisa digeser.
    --  Kini konversi scale→offset meniru formula engine sendiri
    --  (posisi = Scale × ukuran parent + Offset) → identitas visual
    --  TERJAMIN di semua perangkat: nol loncatan saat ditekan.
    --  • geser → ikon mengikuti jari/mouse & TETAP di posisi terakhir
    --  • ketuk (tanpa bergeser > 6px) → buka/tutup semua window
    --  • jari kedua yang menumpuk di ikon TIDAK me-reset anchor drag
    local dragging = false
    local moved = false
    local startInput = nil
    local startVec = nil      -- snapshot NILAI posisi input saat gesture mulai
    local startOffset = nil   -- snapshot NILAI titik TENGAH ikon saat mulai

    reg:Connect(btn.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                return
            end
            dragging = true
            moved = false
            startInput = input
            startVec = input.Position -- Vector3 disalin PER NILAI saat dibaca
            -- kunci posisi jadi offset murni TANPA AbsolutePosition:
            -- tiru persis formula yang dipakai engine menempatkan elemen,
            -- sehingga hasilnya 100% identik secara visual (tidak meloncat)
            local p = btn.Position
            local ps = (btn.Parent and btn.Parent.AbsoluteSize.X > 0)
                and btn.Parent.AbsoluteSize
                or GetViewport()
            startOffset = Vector2.new(
                p.X.Scale * ps.X + p.X.Offset,
                p.Y.Scale * ps.Y + p.Y.Offset
            )
            btn.Position = UDim2.new(0, startOffset.X, 0, startOffset.Y)
        end
    end)

    reg:Connect(UserInputService.InputChanged, function(input)
        if not dragging then
            return
        end
        -- FIX v2.1.1: hanya gerakan dari sumber input yang MEMULAI gesture
        if not gestureInput(startInput, input) then
            return
        end
        -- sebagian executor melaporkan InputBegan sentuhan di (0,0) → delta
        -- awal jadi raksasa & ikon melayang lintas layar. Jika snapshot
        -- mencurigakan, ambil ulang dari gerakan pertama (ikon tetap di
        -- tempatnya, lalu mengikuti jari dari titik ini — tidak meloncat).
        if startVec.X == 0 and startVec.Y == 0 and startVec.Z == 0 then
            startVec = input.Position
        end
        local delta = input.Position - startVec
        if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
            if not moved then
                moved = true
                -- angkat sedikit saat mulai digeser (efek "dicengkeram petir")
                Tween(reg, scale, TI_HOVER, { Scale = 1.15 })
            end
        end
        -- posisi bebas + clamp: SELURUH ikon tetap terlihat (margin 4px).
        -- startOffset = titik TENGAH ikon (anchor 0.5,0.5), jadi batas clamp
        -- dihitung dari setengah ukuran — ikon yang sedang membesar saat
        -- digenggam (×1.15) pun tidak pernah keluar dari layar.
        local vp = GetViewport()
        local halfX = (btn.AbsoluteSize.X > 0 and btn.AbsoluteSize.X or TOGGLE_SIZE) * 0.5
        local halfY = (btn.AbsoluteSize.Y > 0 and btn.AbsoluteSize.Y or TOGGLE_SIZE) * 0.5
        local nx = math.clamp(startOffset.X + delta.X, 4 + halfX, math.max(4 + halfX, vp.X - halfX - 4))
        local ny = math.clamp(startOffset.Y + delta.Y, 4 + halfY, math.max(4 + halfY, vp.Y - halfY - 4))
        -- offset dibulatkan agar ikon tidak "getar" di antara pixel
        btn.Position = UDim2.new(0, math.floor(nx + 0.5), 0, math.floor(ny + 0.5))
    end)

    reg:Connect(UserInputService.InputEnded, function(input)
        if not dragging then
            return
        end
        -- hanya jari/klik yang MEMULAI drag yang boleh mengakhirinya
        if not gestureEnded(startInput, input) then
            return
        end
        dragging = false
        if moved then
            -- tetap di posisi terakhir dilepas (tidak di-snap ke tepi)
            Tween(reg, scale, TI_SNAP, { Scale = 1 })
        else
            -- dianggap ketuk → buka/tutup UI
            popScale()
            toggleWindows()
        end
    end)

    _state.ToggleButton = btn
    return btn
end

--// ────────────── Metode publik level-library (⚡ / keybind) ─────────────
--  ThorUi:Toggle()             — tampilkan/sembunyikan semua window
--  ThorUi:SetKeybind(key)      — ganti keybind toggle global (mis. Enum.KeyCode.K)
--  ThorUi:SetToggleVisible(b)  — tampil/sembunyikan tombol ⚡ melayang
function ThorUi:Toggle()
    toggleWindows()
end

function ThorUi:SetKeybind(key)
    bindToggleKey(key)
end

function ThorUi:SetToggleVisible(visible)
    _state.ToggleVisible = visible and true or false
    local btn = _state.ToggleButton
    if _state.ToggleVisible and not (btn and btn.Parent) then
        ensureToggleButton()
        btn = _state.ToggleButton
    end
    if btn and btn.Parent then
        btn.Visible = _state.ToggleVisible
    end
end

--// ────────────────────────── SPLASH SCREEN (tema Thor) ─────────────────────────────
--  Layar pembuka: logo ⚡ memantul + progress bar petir + status menggemas.
--  playSplash(onDone) tidak memblokir; onDone dipanggil setelah fade-out.
local function playSplash(onDone)
    local gui = ensureGui()
    local reg = Registry.new()
    _state.SplashActive = true

    local overlay = Create("Frame", {
        Name = "ThorUi_Splash",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = gui,
    })

    -- konten tengah (diatur UIListLayout, center)
    local holder = Create("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.44, 0),
        Size = UDim2.new(0, 260, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = overlay,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = holder,
    })

    -- lingkaran logo ⚡ (pop memantul saat muncul)
    local circle = Create("Frame", {
        Size = UDim2.fromOffset(88, 88),
        -- PUTIH: agar gradien Card→BackgroundAlt tampil murni (bukan tertint)
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        Parent = holder,
    })
    Corner(circle, UDim.new(1, 0))
    Gradient(circle, Theme.Card, Theme.BackgroundAlt, 45)
    Stroke(circle, { Color = Theme.Accent, Thickness = 1.5, Transparency = 0.05 })
    local circleScale = Create("UIScale", { Scale = 0.3, Parent = circle })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "⚡",
        Font = Theme.FontBold,
        TextSize = 46,
        TextColor3 = Theme.AccentGold,
        Parent = circle,
    })

    -- judul dengan teks gradien emas → cyan
    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Text = "ThorUi",
        Font = Theme.FontBold,
        TextSize = 22,
        TextColor3 = Theme.White,
        LayoutOrder = 2,
        Parent = holder,
    })
    Gradient(title, Theme.AccentGold, Theme.Accent, 25)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Text = "v" .. ThorUi.Version .. " — Dewa Petir",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        LayoutOrder = 3,
        Parent = holder,
    })

    -- progress bar petir
    local barTrack = Create("Frame", {
        Size = UDim2.new(0, 220, 0, 4),
        BackgroundColor3 = Theme.Track,
        BorderSizePixel = 0,
        LayoutOrder = 4,
        Parent = holder,
    })
    Corner(barTrack, UDim.new(1, 0))
    local barFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.White, -- PUTIH: UIGradient menint -> gradien murni
        BorderSizePixel = 0,
        Parent = barTrack,
    })
    Corner(barFill, UDim.new(1, 0))
    -- FIX v2.1.4: gradien selaras-hue biru->biru muda (vertikal); gradien
    -- biru->emas lama ternyata tertint Accent sehingga tampak HIJAU
    Gradient(barFill, Color3.fromRGB(0, 170, 235), Color3.fromRGB(90, 220, 255), 90)

    local status = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Text = "...",
        Font = Theme.FontMain,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        LayoutOrder = 5,
        Parent = holder,
    })

    -- fade-in cepat lalu logo memantul
    Tween(reg, overlay, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 })
    Tween(reg, circleScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })

    -- urutan animasi (async, tidak memblokir caller)
    task.spawn(function()
        local statuses = { "Menghubungkan ke Valhalla...", "Memanggil petir...", "Menempa Mjolnir..." }
        for _, s in ipairs(statuses) do
            if not overlay.Parent or not _state.SplashActive then
                return
            end
            status.Text = s
            task.wait(0.33)
        end

        local fill = Tween(reg, barFill, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0),
        })
        fill.Completed:Wait()
        if not overlay.Parent or not _state.SplashActive then
            return
        end

        status.Text = "⚡ Siap!"
        task.wait(0.18)

        local fade = Tween(reg, overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
        })
        fade.Completed:Wait()
        reg:Clean()
        if overlay.Parent then
            overlay:Destroy()
        end
        _state.SplashActive = false
        if onDone then
            onDone()
        end
    end)
end

--// ──────────────────────────────── Tab ─────────────────────────────────────
--  v2: tombol tab vertikal di SIDEBAR (ikon + nama), bukan lagi tab horizontal.
local TabClass = {}
TabClass.__index = TabClass

function TabClass.new(window, cfg)
    cfg = cfg or {}
    local reg = Registry.new()

    -- tombol tab di sidebar (vertikal, ber-ikon)
    local btn = Create("TextButton", {
        Name = "Tab_" .. tostring(cfg.Name or "Tab"),
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        BorderSizePixel = 0,
        LayoutOrder = #window.Tabs + 1,
        Parent = window.TabList,
    })
    Corner(btn, 8)

    -- indikator petir di sisi kiri (menyambar saat tab aktif)
    local indicator = Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 3, 0, 0),
        BackgroundColor3 = Theme.White, -- PUTIH: gradien emas->biru murni
        BorderSizePixel = 0,
        Parent = btn,
    })
    Corner(indicator, UDim.new(1, 0))
    Gradient(indicator, Theme.AccentGold, Theme.Accent, 90)

    local icon = Create("TextLabel", {
        BackgroundTransparency = 1,
        -- +1px: glyph emoji bawaan Roblox cenderung "melayang" ke atas;
        -- saat sidebar icon-only posisi digeser ke tengah oleh _updateResponsive
        Position = UDim2.new(0, 10, 0, 1),
        Size = UDim2.new(0, 18, 1, 0),
        Text = tostring(cfg.Icon or "⚡"),
        Font = Theme.FontBold,
        TextSize = 13,
        TextColor3 = Theme.TextDim,
        Parent = btn,
    })
    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -36, 1, 0),
        Text = tostring(cfg.Name or "Tab"),
        Font = Theme.FontMedium,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = btn,
    })

    -- konten tab: langsung ditaruh di ScrollingFrame utama (AutomaticCanvasSize)
    local container = Create("Frame", {
        Name = "TabContent_" .. tostring(cfg.Name or "Tab"),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = window.Content,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container,
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = container,
    })

    local self = setmetatable({
        Window = window,
        Registry = reg,
        Button = btn,
        Icon = icon,
        Label = label,
        Indicator = indicator,
        Container = container,
        Elements = {},
        Sections = {}, -- v2.2.1: daftar menu (section) — bisa di-minimize
        Order = 0,
        Active = false,
        FilterQuery = "",
    }, TabClass)

    reg:Connect(btn.Activated, function()
        window:SelectTab(self)
    end)
    reg:Connect(btn.MouseEnter, function()
        if not self.Active then
            Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 0.75 })
            Tween(reg, label, TI_HOVER, { TextColor3 = Theme.Text })
            Tween(reg, icon, TI_HOVER, { TextColor3 = Theme.Text })
        end
    end)
    reg:Connect(btn.MouseLeave, function()
        if not self.Active then
            Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 1 })
            Tween(reg, label, TI_HOVER, { TextColor3 = Theme.TextDim })
            Tween(reg, icon, TI_HOVER, { TextColor3 = Theme.TextDim })
        end
    end)

    return self
end

function TabClass:_nextOrder()
    self.Order = self.Order + 1
    return self.Order
end

--  Daftarkan elemen ke tab + pasang :Remove() yang membersihkan registry-nya.
function TabClass:_track(element)
    local tab = self
    table.insert(tab.Elements, element)
    -- v2.2.1: elemen otomatis menjadi ANGGOTA menu (section) aktif terakhir
    tab:_own(element)
    function element:Remove()
        if self.Registry then
            self.Registry:Clean()
        end
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
        for i, el in ipairs(tab.Elements) do
            if el == self then
                table.remove(tab.Elements, i)
                break
            end
        end
        -- v2.2.1: keluar juga dari daftar anggota menu (section)-nya
        local sec = self.Section
        if sec and sec.Members then
            for i, m in ipairs(sec.Members) do
                if m == self then
                    table.remove(sec.Members, i)
                    break
                end
            end
        end
    end
end

--  v2.2.1: daftarkan elemen sebagai anggota menu (section) yang sedang aktif.
--  Dipanggil oleh _track (elemen interaktif) dan AddLabel/AddParagraph
--  (elemen statis) — semua fitur yang dibuat SETELAH AddSection otomatis
--  tergabung ke menu itu, sehingga bisa di-minimize bersama dengan satu klik
--  pada judul section-nya.
function TabClass:_own(element)
    local sec = self._currentSection
    if sec and sec.Members then
        element.Section = sec
        table.insert(sec.Members, element)
        -- menu sedang di-minimize → elemen baru langsung tersembunyi
        if sec.Collapsed and element.Instance then
            element.Instance.Visible = false
        end
    end
end

--  Filter pencarian: sembunyikan elemen yang namanya tidak cocok.
--  Dipanggil oleh search bar window (hanya memengaruhi tab aktif).
function TabClass:ApplyFilter(query)
    query = tostring(query or "")
    self.FilterQuery = query
    local needle = query:lower()
    local filtering = needle ~= ""
    for _, el in ipairs(self.Elements) do
        if el.Instance then
            local name = el.Name
            local visible
            if not filtering or name == nil or name == "" then
                visible = true
            else
                visible = string.find(tostring(name):lower(), needle, 1, true) ~= nil
            end
            -- v2.2.1: menu sedang di-minimize → anggotanya TETAP tersembunyi
            -- (pencarian tidak membuka lipatan menu)
            if el.Section and el.Section.Collapsed then
                visible = false
            end
            el.Instance.Visible = visible
        end
    end
    -- v2.2.1: saat mencari, judul menu tanpa anggota yang cocok ikut
    -- disembunyikan supaya hasil pencarian lebih rapat
    for _, sec in ipairs(self.Sections) do
        if sec.Instance then
            if not filtering then
                sec.Instance.Visible = true
            else
                local anyVisible = false
                for _, m in ipairs(sec.Members) do
                    if m.Instance and m.Instance.Visible then
                        anyVisible = true
                        break
                    end
                end
                sec.Instance.Visible = anyVisible
            end
        end
    end
end

--  Card dasar semua elemen: bg + UICorner + UIStroke + padding + UIListLayout
function TabClass:_card(className)
    className = className or "Frame"
    local props = {
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self:_nextOrder(),
        Parent = self.Container,
    }
    if className == "TextButton" then
        props.Text = ""
        props.AutoButtonColor = false
    end
    local card = Create(className, props)
    Corner(card, 10)
    local stroke = Stroke(card, { Color = Theme.StrokeDim, Transparency = 0.35 })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = card,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = card,
    })
    return card, stroke
end

function TabClass:Remove()
    local elements = {}
    for _, el in ipairs(self.Elements) do
        table.insert(elements, el)
    end
    for _, el in ipairs(elements) do
        el:Remove()
    end
    -- v2.2.1: bersihkan registry semua menu (section) di tab ini
    local sections = {}
    for _, sec in ipairs(self.Sections) do
        table.insert(sections, sec)
    end
    for _, sec in ipairs(sections) do
        sec:Remove()
    end
    self.Registry:Clean()
    if self.Button and self.Button.Parent then
        self.Button:Destroy()
    end
    if self.Container and self.Container.Parent then
        self.Container:Destroy()
    end
    local tabs = self.Window.Tabs
    for i, t in ipairs(tabs) do
        if t == self then
            table.remove(tabs, i)
            break
        end
    end
    if self.Window._activeTab == self then
        self.Window._activeTab = nil
        if tabs[1] then
            self.Window:SelectTab(tabs[1])
        end
    end
end

--// ───────────── Elemen: keterangan/Description (modern) ────────────
--  Teks kecil redup di bawah judul elemen. Dibuat SECARA MALAS (hanya saat
--  ada isinya) supaya jarak antar-baris tidak berubah saat tidak dipakai.
--  FIX v2.1.1: sebelumnya config Description diabaikan total → "keterangan
--  slider dll tidak kelihatan".
--  FIX v2.1.2 (dari screenshot user): tinggi keterangan kini DIUKUR SINKRON
--  (autoFitText → TextService:GetTextSize → Size eksplisit). Dulu memakai
--  AutomaticSize.Y yang di sebagian perangkat memesan tinggi lebih kecil
--  dari render → baris setelahnya (track slider, box input, garis section)
--  MENIMPA separuh bawah teks keterangan. Pemakaian:
--      local setDesc = attachDescription(card, 2)  -- urutan setelah judul
--      setDesc(cfg.Description)                     -- boleh nil/kosong
--      setDesc("teks baru")                         -- dipanggil ulang kapan pun
local function attachDescription(card, order)
    local label = nil
    return function(text)
        if text == nil or tostring(text) == "" then
            if label then
                label.Visible = false
            end
            return
        end
        if not label then
            label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Font = Theme.FontMain,
                TextSize = 12, -- cukup besar untuk dibaca di mobile, tetap halus
                TextColor3 = Theme.TextDim,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                LayoutOrder = order,
                Parent = card,
            })
            -- FIX v2.1.2: ukur tinggi teks eksplisit + re-ukur saat teks /
            -- lebar kartu berubah — keterangan TIDAK PERNAH lagi tertimpa
            autoFitText(label, 14)
        end
        label.Visible = true
        label.Text = tostring(text)
    end
end

--// ─────────────────────────── Elemen: BUTTON ───────────────────────────────
function TabClass:AddButton(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card, stroke = self:_card("TextButton")

    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Text = cfg.Name or "Button",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        LayoutOrder = 1,
        Parent = card,
    })

    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    cardHover(reg, card, stroke)

    reg:Connect(card.Activated, function()
        Zap(reg, card, Theme.Accent, 10)
        if cfg.Callback then
            cfg.Callback()
        end
    end)

    local element = {
        Type = "Button",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return label.Text
        end,
        Set = function(_, name)
            label.Text = tostring(name)
        end,
        Fire = function(_)
            if cfg.Callback then
                cfg.Callback()
            end
        end,
    }
    self:_track(element)
    return element
end

--// ─────────────────────────── Elemen: TOGGLE ───────────────────────────────
--  v2: switch modern — track memanjang + knob bulat meluncur kilat.
function TabClass:AddToggle(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card, stroke = self:_card("TextButton")

    local row = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 1,
        Parent = card,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -64, 1, 0),
        Text = cfg.Name or "Toggle",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })

    -- switch: track 40x20 + knob 16 bulat
    local pill = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(40, 20),
        BackgroundColor3 = Theme.Track,
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(pill, UDim.new(1, 0))
    local pillStroke = Stroke(pill, { Color = Theme.StrokeDim, Transparency = 0.2 })
    local knob = Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 2, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = Theme.TextDim,
        BorderSizePixel = 0,
        Parent = pill,
    })
    Corner(knob, UDim.new(1, 0))
    Stroke(knob, { Color = Theme.Background, Thickness = 1, Transparency = 0.4 })

    -- keterangan kecil di bawah judul
    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    local state = { Value = cfg.Default == true, Callback = cfg.Callback }

    local function render(instant)
        local goalFill = state.Value and Theme.Accent or Theme.Track
        local goalKnobPos = state.Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        local goalKnobColor = state.Value and Theme.White or Theme.TextDim
        local goalStrokeColor = state.Value and Theme.Accent or Theme.StrokeDim
        if instant then
            pill.BackgroundColor3 = goalFill
            knob.Position = goalKnobPos
            knob.BackgroundColor3 = goalKnobColor
            pillStroke.Color = goalStrokeColor
        else
            Tween(reg, pill, TI_SNAP, { BackgroundColor3 = goalFill })
            Tween(reg, knob, TI_STRIKE, { Position = goalKnobPos, BackgroundColor3 = goalKnobColor })
            Tween(reg, pillStroke, TI_SNAP, { Color = goalStrokeColor })
        end
    end

    render(true)
    cardHover(reg, card, stroke)

    reg:Connect(card.Activated, function()
        state.Value = not state.Value
        render(false)
        Zap(reg, pill, Theme.AccentGold, UDim.new(1, 0))
        if state.Callback then
            state.Callback(state.Value)
        end
    end)

    local element = {
        Type = "Toggle",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return state.Value
        end,
        Set = function(_, value, silent)
            state.Value = value == true
            render(true)
            if silent ~= true and state.Callback then
                state.Callback(state.Value)
            end
        end,
    }
    self:_track(element)
    return element
end

--// ─────────────────────────── Elemen: SLIDER ───────────────────────────────
function TabClass:AddSlider(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card, stroke = self:_card()

    local row1 = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 1,
        Parent = card,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -90, 1, 0),
        Text = cfg.Name or "Slider",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row1,
    })
    local valueLabel = Create("TextLabel", {
        BackgroundTransparency = 1, -- FIX v2.1.5: hilangkan kotak abu-abu di belakang "124 spd"
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 90, 1, 0),
        Text = "",
        Font = Theme.FontMedium,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row1,
    })

    -- keterangan kecil di bawah judul
    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    -- baris slider ditinggikan (28px) + hit-area transparan supaya nyaman
    -- disentuh jari — bukan cuma track 6px yang harus dibidik (mobile-friendly)
    local row2 = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        LayoutOrder = 3,
        Parent = card,
    })
    local track = Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Theme.Track,
        BorderSizePixel = 0,
        Parent = row2,
    })
    Corner(track, UDim.new(1, 0))
    local fill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.White, -- PUTIH: UIGradient menint -> gradien murni
        BorderSizePixel = 0,
        Parent = track,
    })
    Corner(fill, UDim.new(1, 0))
    -- FIX v2.1.4: gradien biru->emas (a) tertint background Accent sehingga
    -- emas tak pernah muncul & bar tampak biru redup->HIJAU (terverifikasi
    -- piksel screenshot user), (b) interpolasi sRGB biru->emas selalu
    -- melintas abu kehijauan. Diganti gradien selaras-hue 'kilat menyala'.
    Gradient(fill, Color3.fromRGB(0, 170, 235), Color3.fromRGB(90, 220, 255), 90)
    local knob = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = track,
    })
    Corner(knob, UDim.new(1, 0))
    Stroke(knob, { Color = Theme.AccentGold, Thickness = 1, Transparency = 0.1 }) -- v2.1.4: emas
    local knobScale = Create("UIScale", { Parent = knob })

    -- area sentuh transparan menutupi SELURUH baris slider (ZIndex di atas
    -- track & knob) — drag/ tap dari mana pun di baris tetap terbaca
    local hit = Create("TextButton", {
        Name = "SliderHit",
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 3,
        Parent = row2,
    })

    local state = {
        Min = cfg.Min or 0,
        Max = cfg.Max or 100,
        Value = cfg.Default,
        Increment = cfg.Increment,
        Precision = cfg.Precision or (cfg.Increment and decimalsOf(cfg.Increment)) or 0,
        Suffix = cfg.Suffix or "",
        Callback = cfg.Callback,
    }
    if state.Min > state.Max then
        state.Min, state.Max = state.Max, state.Min
    end
    if state.Value == nil then
        state.Value = state.Min
    end

    local function render()
        local span = state.Max - state.Min
        local rel = span > 0 and (state.Value - state.Min) / span or 0
        rel = math.clamp(rel, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        valueLabel.Text = formatValue(state.Value, state.Precision) .. state.Suffix
    end

    local function apply(raw, silent)
        local v = raw
        local inc = state.Increment
        if inc and inc > 0 then
            v = math.floor(v / inc + 0.5) * inc
        end
        v = math.clamp(v, state.Min, state.Max)
        state.Value = v
        render()
        if silent ~= true and state.Callback then
            state.Callback(state.Value)
        end
    end

    -- interaksi: mouse & sentuhan (UserInputService)
    local sliding = false
    local slideInput = nil

    local function updateFromX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        apply(state.Min + rel * (state.Max - state.Min), false)
    end

    local function beginSlide(input)
        if sliding then
            return
        end
        sliding = true
        slideInput = input
        Tween(reg, knobScale, TI_HOVER, { Scale = 1.3 })
        Tween(reg, stroke, TI_HOVER, { Color = Theme.Stroke, Transparency = 0.05 })
        updateFromX(input.Position.X)
    end

    reg:Connect(hit.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            beginSlide(input)
        end
    end)
    reg:Connect(UserInputService.InputChanged, function(input)
        if sliding and gestureInput(slideInput, input) then
            updateFromX(input.Position.X)
        end
    end)
    reg:Connect(UserInputService.InputEnded, function(input)
        if sliding and gestureEnded(slideInput, input) then
            sliding = false
            slideInput = nil
            Tween(reg, knobScale, TI_HOVER, { Scale = 1 })
            Tween(reg, stroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.35 })
        end
    end)

    apply(state.Value, true)

    local element = {
        Type = "Slider",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return state.Value
        end,
        Set = function(_, value, silent)
            apply(tonumber(value) or state.Min, silent)
        end,
    }
    self:_track(element)
    return element
end

--// ─────────────────────────── Elemen: DROPDOWN ─────────────────────────────
function TabClass:AddDropdown(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    local multi = cfg.Multi == true
    local state = {
        Value = multi and {} or nil,
        Callback = cfg.Callback,
    }

    -- header (klik untuk expand/collapse)
    local header = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        LayoutOrder = 1,
        Parent = card,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -150, 1, 0),
        Text = cfg.Name or "Dropdown",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })
    local selectLabel = Create("TextLabel", {
        BackgroundTransparency = 1, -- FIX v2.1.5: hilangkan kotak abu-abu di belakang "Mjolnir"
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 0),
        Size = UDim2.new(0, 120, 1, 0),
        Text = "Pilih...",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })
    local arrow = Create("TextLabel", {
        BackgroundTransparency = 1, -- FIX v2.1.5: tanpa ini panah "▾" juga berkotak abu
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        Text = "▾",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        Parent = header,
    })

    -- keterangan kecil di bawah judul
    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    -- daftar opsi (card otomatis memanjang via AutomaticSize)
    local holder = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        LayoutOrder = 3,
        Parent = card,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = holder,
    })

    local options = {}
    local expanded = false

    local function updateHeader()
        if multi then
            local n = #state.Value
            if n == 0 then
                selectLabel.Text = "Pilih..."
            elseif n == 1 then
                selectLabel.Text = tostring(state.Value[1])
            else
                selectLabel.Text = tostring(n) .. " dipilih"
            end
        else
            selectLabel.Text = state.Value ~= nil and tostring(state.Value) or "Pilih..."
        end
    end

    local function refresh()
        for _, opt in ipairs(options) do
            local selected
            if multi then
                selected = contains(state.Value, opt.Value)
            else
                selected = (state.Value == opt.Value)
            end
            if selected then
                opt.Dot.BackgroundColor3 = Theme.Accent
                opt.Dot.BackgroundTransparency = 0
                opt.Label.TextColor3 = Theme.Text
            else
                opt.Dot.BackgroundColor3 = Theme.TextDim
                opt.Dot.BackgroundTransparency = 0.6
                opt.Label.TextColor3 = Theme.TextDim
            end
        end
    end

    local function setExpanded(v)
        expanded = v
        holder.Visible = v
        Tween(reg, arrow, TI_HOVER, { TextColor3 = v and Theme.Accent or Theme.TextDim })
    end

    for _, value in ipairs(cfg.Values or {}) do
        local opt = { Value = value }
        local btn = Create("TextButton", {
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 28), -- 28px: area sentuh nyaman di jari
            BorderSizePixel = 0,
            LayoutOrder = #options + 1,
            Parent = holder,
        })
        Corner(btn, 6)
        opt.Btn = btn
        opt.Dot = Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 8, 0.5, 0),
            Size = UDim2.fromOffset(6, 6),
            BackgroundColor3 = Theme.TextDim,
            BackgroundTransparency = 0.6,
            BorderSizePixel = 0,
            Parent = btn,
        })
        Corner(opt.Dot, UDim.new(1, 0))
        opt.Label = Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Text = tostring(value),
            Font = Theme.FontMain,
            TextSize = 12,
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = btn,
        })

        reg:Connect(btn.MouseEnter, function()
            Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 0.6, BackgroundColor3 = Theme.CardHover })
        end)
        reg:Connect(btn.MouseLeave, function()
            Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 1, BackgroundColor3 = Theme.Card })
        end)

        reg:Connect(btn.Activated, function()
            if multi then
                if contains(state.Value, value) then
                    removeFrom(state.Value, value)
                else
                    table.insert(state.Value, value)
                end
                refresh()
                updateHeader()
                Zap(reg, btn, Theme.Accent, 6)
                if state.Callback then
                    local snapshot = {}
                    for i, v in ipairs(state.Value) do
                        snapshot[i] = v
                    end
                    state.Callback(snapshot)
                end
            else
                state.Value = value
                refresh()
                updateHeader()
                setExpanded(false)
                Zap(reg, btn, Theme.Accent, 6)
                if state.Callback then
                    state.Callback(state.Value)
                end
            end
        end)

        table.insert(options, opt)
    end

    reg:Connect(header.Activated, function()
        setExpanded(not expanded)
        Zap(reg, header, Theme.AccentGold, 6)
    end)

    -- nilai default
    if multi and type(cfg.Default) == "table" then
        for _, v in ipairs(cfg.Default) do
            table.insert(state.Value, v)
        end
    elseif not multi and cfg.Default ~= nil then
        state.Value = cfg.Default
    end
    refresh()
    updateHeader()

    local element = {
        Type = "Dropdown",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            if multi then
                local copy = {}
                for i, v in ipairs(state.Value) do
                    copy[i] = v
                end
                return copy
            end
            return state.Value
        end,
        Set = function(_, value, silent)
            if multi and type(value) == "table" then
                state.Value = {}
                for _, v in ipairs(value) do
                    table.insert(state.Value, v)
                end
            elseif not multi then
                state.Value = value
            end
            refresh()
            updateHeader()
            if silent ~= true and state.Callback then
                if multi then
                    local copy = {}
                    for i, v in ipairs(state.Value) do
                        copy[i] = v
                    end
                    state.Callback(copy)
                else
                    state.Callback(state.Value)
                end
            end
        end,
    }
    self:_track(element)
    return element
end

--// ────────────────────────── Elemen: TEXTINPUT ─────────────────────────────
function TabClass:AddTextInput(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Text = cfg.Name or "Input",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        Parent = card,
    })

    -- keterangan kecil di bawah judul
    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    local box = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Text = cfg.Text or "",
        PlaceholderText = cfg.Placeholder or "Ketik di sini...",
        PlaceholderColor3 = Theme.TextDim,
        TextSize = 12,
        TextColor3 = Theme.Text,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = cfg.ClearOnFocus == true,
        ClipsDescendants = true,
        LayoutOrder = 3,
        Parent = card,
    })
    Corner(box, 8)
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = box,
    })
    local boxStroke = Stroke(box, { Color = Theme.StrokeDim, Transparency = 0.3 })

    reg:Connect(box.Focused, function()
        Tween(reg, boxStroke, TI_HOVER, { Color = Theme.Accent, Transparency = 0 })
        Tween(reg, box, TI_HOVER, { BackgroundColor3 = Theme.BackgroundAlt })
    end)
    reg:Connect(box.FocusLost, function(enterPressed)
        Tween(reg, boxStroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.3 })
        Tween(reg, box, TI_HOVER, { BackgroundColor3 = Theme.Background })
        if enterPressed then
            Zap(reg, box, Theme.Accent, 8)
        end
        if cfg.Callback then
            cfg.Callback(box.Text, enterPressed == true)
        end
    end)

    local element = {
        Type = "TextInput",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return box.Text
        end,
        Set = function(_, text)
            box.Text = tostring(text)
        end,
    }
    self:_track(element)
    return element
end

--// ─────────────────────────── Elemen: KEYBIND ──────────────────────────────
function TabClass:AddKeybind(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card, stroke = self:_card("TextButton")

    local row = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        LayoutOrder = 1,
        Parent = card,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -140, 1, 0),
        Text = cfg.Name or "Keybind",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })
    local bindLabel = Create("TextLabel", {
        BackgroundTransparency = 1, -- FIX v2.1.5: keybind juga tanpa kotak abu
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 135, 1, 0),
        Text = "...",
        Font = Theme.FontMedium,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })

    -- keterangan kecil di bawah judul
    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    local state = {
        Bind = cfg.Default,
        Callback = cfg.Callback,
        Listening = false,
        LastCapture = 0,
    }

    local function display()
        if state.Listening then
            bindLabel.Text = "[ tekan tombol ]"
            bindLabel.TextColor3 = Theme.AccentGold
        elseif state.Bind then
            bindLabel.Text = state.Bind.Name
            bindLabel.TextColor3 = Theme.Accent
        else
            bindLabel.Text = "kosong"
            bindLabel.TextColor3 = Theme.TextDim
        end
    end

    reg:Connect(UserInputService.InputBegan, function(input, processed)
        if state.Listening then
            if processed then
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                state.Bind = input.KeyCode
                state.Listening = false
                state.LastCapture = os.clock()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.MouseButton2 then
                state.Bind = input.UserInputType
                state.Listening = false
                state.LastCapture = os.clock()
            else
                return
            end
            display()
            return
        end
        -- mode normal: panggil callback saat tombol terikat ditekan
        if not state.Bind or processed then
            return
        end
        local matched
        if state.Bind.EnumType == Enum.KeyCode then
            matched = (input.KeyCode == state.Bind)
        else
            matched = (input.UserInputType == state.Bind)
        end
        if matched then
            Zap(reg, card, Theme.Accent, 10)
            if state.Callback then
                state.Callback(state.Bind, input)
            end
        end
    end)

    reg:Connect(card.Activated, function()
        -- jeda 0.4s agar klik penangkap mouse tidak langsung re-listen
        if os.clock() - state.LastCapture < 0.4 then
            return
        end
        state.Listening = not state.Listening
        display()
    end)

    cardHover(reg, card, stroke)
    display()

    local element = {
        Type = "Keybind",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return state.Bind
        end,
        SetKey = function(_, enumItem)
            if typeof(enumItem) == "EnumItem" then
                state.Bind = enumItem
                display()
            end
        end,
    }
    self:_track(element)
    return element
end

--// ────────────────────────── Elemen: COLORPICKER (v2) ──────────────────────
--  Picker warna modern: kotak Saturasi-Value + slider Hue + HEX/RGB.
--  Semua elemen digambar murni script (UIGradient), tanpa aset gambar.
function TabClass:AddColorPicker(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    local state = {
        H = 0.55, S = 1, V = 1,
        Callback = cfg.Callback,
    }
    do
        local d = cfg.Default or Theme.Accent
        if typeof(d) == "Color3" then
            local h, s, v = Color3.toHSV(d)
            state.H, state.S, state.V = h, s, v
        end
    end

    -- ── header: nama + hex + swatch preview ──
    local header = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 1,
        Parent = card,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -130, 1, 0),
        Text = cfg.Name or "Warna",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    })
    local hexLabel = Create("TextLabel", {
        BackgroundTransparency = 1, -- FIX v2.1.5: hex code tanpa kotak abu
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -36, 0.5, 0),
        Size = UDim2.new(0, 76, 1, 0),
        Text = "#00C3FF",
        Font = Theme.FontMain,
        TextSize = 11,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = header,
    })
    local swatch = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(24, 24),
        BorderSizePixel = 0,
        Parent = header,
    })
    Corner(swatch, 6)
    local swatchStroke = Stroke(swatch, { Color = Theme.White, Thickness = 1, Transparency = 0.45 })

    -- keterangan kecil di bawah judul
    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    -- ── panel picker (expand/collapse seperti dropdown) ──
    local panel = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        LayoutOrder = 3,
        Parent = card,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = panel,
    })

    -- kotak Saturation-Value
    local svBox = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 110),
        BackgroundColor3 = Color3.fromHSV(state.H, 1, 1),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true, -- FIX v2.1.1: serap sentuhan agar tidak ikut menggulir konten saat menggeser warna
        LayoutOrder = 1,
        Parent = panel,
    })
    Corner(svBox, 8)
    local svStroke = Stroke(svBox, { Color = Theme.StrokeDim, Transparency = 0.3 })

    -- gradient putih → transparan (kiri→kanan) = saturasi
    local whiteLayer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        Parent = svBox,
    })
    Create("UIGradient", {
        Color = ColorSequence.new(Theme.White, Theme.White),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 0,
        Parent = whiteLayer,
    })
    -- gradient transparan → hitam (atas→bawah) = value
    local blackLayer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Parent = svBox,
    })
    Create("UIGradient", {
        Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
        Parent = blackLayer,
    })
    local svCursor = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(state.S, 0, 1 - state.V, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = svBox,
    })
    Corner(svCursor, UDim.new(1, 0))
    Stroke(svCursor, { Color = Theme.Background, Thickness = 2, Transparency = 0 })

    -- slider HUE (pelangi)
    local hueBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        Active = true, -- FIX v2.1.1: serap sentuhan (drag di mobile tidak menggulir konten)
        LayoutOrder = 2,
        Parent = panel,
    })
    Corner(hueBar, UDim.new(1, 0))
    Stroke(hueBar, { Color = Theme.Background, Thickness = 1, Transparency = 0.2 })
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
        }),
        Parent = hueBar,
    })
    local hueCursor = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(state.H, 0, 0.5, 0),
        Size = UDim2.fromOffset(4, 18),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = hueBar,
    })
    Corner(hueCursor, UDim.new(1, 0))
    Stroke(hueCursor, { Color = Theme.Background, Thickness = 1, Transparency = 0 })

    -- baris info RGB
    local rgbLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Text = "RGB 0, 195, 255",
        Font = Theme.FontMain,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 3,
        Parent = panel,
    })

    local function currentColor()
        return Color3.fromHSV(state.H, state.S, state.V)
    end

    local function render()
        local color = currentColor()
        swatch.BackgroundColor3 = color
        hexLabel.Text = hexFromColor3(color)
        rgbLabel.Text = string.format("RGB %d, %d, %d",
            math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5),
            math.floor(color.B * 255 + 0.5))
        svBox.BackgroundColor3 = Color3.fromHSV(state.H, 1, 1)
        svCursor.Position = UDim2.new(state.S, 0, 1 - state.V, 0)
        hueCursor.Position = UDim2.new(state.H, 0, 0.5, 0)
    end

    -- interaksi drag (mouse & sentuhan) — pola sama seperti slider
    local svDragging = false
    local hueDragging = false
    local svInput = nil
    local hueInput = nil

    local function updateSV(x, y)
        local relX = math.clamp((x - svBox.AbsolutePosition.X) / math.max(svBox.AbsoluteSize.X, 1), 0, 1)
        local relY = math.clamp((y - svBox.AbsolutePosition.Y) / math.max(svBox.AbsoluteSize.Y, 1), 0, 1)
        state.S = relX
        state.V = 1 - relY
        render()
        if state.Callback then
            state.Callback(currentColor())
        end
    end

    local function updateHue(x)
        local rel = math.clamp((x - hueBar.AbsolutePosition.X) / math.max(hueBar.AbsoluteSize.X, 1), 0, 1)
        state.H = rel
        render()
        if state.Callback then
            state.Callback(currentColor())
        end
    end

    reg:Connect(svBox.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if svDragging or hueDragging then
                return
            end
            svDragging = true
            svInput = input
            Tween(reg, svStroke, TI_HOVER, { Color = Theme.Stroke, Transparency = 0 })
            updateSV(input.Position.X, input.Position.Y)
        end
    end)
    reg:Connect(hueBar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if svDragging or hueDragging then
                return
            end
            hueDragging = true
            hueInput = input
            updateHue(input.Position.X)
        end
    end)
    reg:Connect(UserInputService.InputChanged, function(input)
        if svDragging and gestureInput(svInput, input) then
            updateSV(input.Position.X, input.Position.Y)
        elseif hueDragging and gestureInput(hueInput, input) then
            -- FIX v2.1.1: slider HUE kini mengikuti JARI juga — dulu filter
            -- hanya memeriksa svInput sehingga drag hue via sentuhan MATI total
            updateHue(input.Position.X)
        end
    end)
    reg:Connect(UserInputService.InputEnded, function(input)
        if svDragging and gestureEnded(svInput, input) then
            svDragging = false
            svInput = nil
            Tween(reg, svStroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.3 })
            Zap(reg, swatch, Theme.AccentGold, 6)
        end
        if hueDragging and gestureEnded(hueInput, input) then
            hueDragging = false
            hueInput = nil
        end
    end)

    -- expand/collapse
    local expanded = false
    reg:Connect(header.Activated, function()
        expanded = not expanded
        panel.Visible = expanded
        Tween(reg, swatchStroke, TI_HOVER, {
            Color = expanded and Theme.Accent or Theme.White,
            Transparency = expanded and 0 or 0.45,
        })
        Zap(reg, header, Theme.AccentGold, 6)
    end)

    render()

    local element = {
        Type = "ColorPicker",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return currentColor()
        end,
        Set = function(_, color, silent)
            if typeof(color) == "Color3" then
                local h, s, v = Color3.toHSV(color)
                state.H, state.S, state.V = h, s, v
                render()
                if silent ~= true and state.Callback then
                    state.Callback(currentColor())
                end
            end
        end,
    }
    self:_track(element)
    return element
end

--// ─────────────────────────── Elemen: SECTION ──────────────────────────────
--  v2.2.1: MENU BISA DI-MINIMIZE — klik judul section untuk menutup/membuka
--  semua fitur di dalamnya (sampai section berikutnya). Chevron ▾ berputar
--  jadi ▸ sebagai penanda. Elemen yang dibuat SETELAH AddSection otomatis
--  menjadi anggota menu tersebut (via _own / _track).
function TabClass:AddSection(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local holder = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self:_nextOrder(),
        Parent = self.Container,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = holder,
    })

    -- baris judul = TextButton — area ketuk selarik judul, nyaman di mobile
    local row = Create("TextButton", {
        Name = "SectionHeader",
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 20),
        Text = "",
        LayoutOrder = 1,
        Parent = holder,
    })
    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, -18, 1, 0),
        Text = cfg.Name or "Section",
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })
    -- chevron penanda lipatan: ▾ (terbuka) ↔ ▸ (termiminize, rotasi -90°)
    local chevron = Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -2, 0.5, 0),
        Size = UDim2.new(0, 14, 1, 0),
        Text = "▾",
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        Parent = row,
    })

    -- keterangan kecil di bawah judul section
    local setDesc = attachDescription(holder, 2)
    setDesc(cfg.Description)
    local line = Create("Frame", {
        BackgroundColor3 = Theme.White, -- PUTIH: gradien emas->biru murni
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        LayoutOrder = 3,
        Parent = holder,
    })
    Gradient(line, Theme.AccentGold, Theme.Accent, 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.85),
    }))

    local el = {
        Type = "Section",
        Name = cfg.Name,
        Instance = holder,
        Registry = reg,
        Members = {}, -- elemen yang dibuat setelah section ini
        Collapsed = false,
    }

    -- Terapkan lipatan: sembunyikan/tampilkan semua anggota dalam SATU pass
    -- (tanpa tween per elemen — hemat performa). Daftar anggota yang sudah
    -- di-Remove dibersihkan otomatis saat lewat.
    local function applyVisibility()
        local members = el.Members
        for i = #members, 1, -1 do
            local m = members[i]
            if not m.Instance or not m.Instance.Parent then
                table.remove(members, i) -- anggota sudah dihancurkan
            else
                m.Instance.Visible = not el.Collapsed
            end
        end
    end

    function el:SetCollapsed(collapsed)
        collapsed = collapsed == true
        if el.Collapsed == collapsed then
            return
        end
        el.Collapsed = collapsed
        Tween(reg, chevron, TI_HOVER, { Rotation = collapsed and -90 or 0 })
        applyVisibility()
    end

    function el:Toggle()
        self:SetCollapsed(not el.Collapsed)
    end

    function el:IsCollapsed()
        return el.Collapsed
    end

    el.SetDescription = function(_, text)
        setDesc(text)
    end

    reg:Connect(row.Activated, function()
        el:Toggle()
    end)

    -- hover hemat: hanya di perangkat bermouse (mobile tak buat tween percuma)
    if HOVER_FOR_MOUSE then
        reg:Connect(row.MouseEnter, function()
            Tween(reg, title, TI_HOVER, { TextColor3 = Theme.Text })
            Tween(reg, chevron, TI_HOVER, { TextColor3 = Theme.Text })
        end)
        reg:Connect(row.MouseLeave, function()
            Tween(reg, title, TI_HOVER, { TextColor3 = Theme.AccentGold })
            Tween(reg, chevron, TI_HOVER, { TextColor3 = Theme.AccentGold })
        end)
    end

    function el:Remove()
        -- anggota dikembalikan terlihat & lepas dari menu ini
        el.Collapsed = false
        applyVisibility()
        for _, m in ipairs(el.Members) do
            m.Section = nil
        end
        el.Members = {}
        reg:Clean()
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
    end

    -- section baru = menu aktif: elemen SELANJUTNYA jadi anggotanya
    self._currentSection = el
    table.insert(self.Sections, el)

    -- cfg.Collapsed = true → menu dibuat langsung terlipat
    if cfg.Collapsed then
        el.Collapsed = true
        chevron.Rotation = -90
    end

    return el
end

--// ─────────────────────────── Elemen: LABEL ────────────────────────────────
function TabClass:AddLabel(cfg)
    cfg = cfg or {}
    local lbl = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        -- FIX v2.1.2: tinggi eksplisit terukur (autoFitText) — bukan
        -- AutomaticSize.Y yang bisa memesan tinggi kurang dari teks →
        -- elemen berikutnya menimpa teks Label
        Text = cfg.Text or cfg.Name or "Label",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = self:_nextOrder(),
        Parent = self.Container,
    })
    autoFitText(lbl, 0)
    local el = { Type = "Label", Instance = lbl }
    el.SetText = function(text) -- dipanggil: el.SetText("teks baru")
        lbl.Text = tostring(text)
    end
    function el:Remove()
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
    end
    -- v2.2.1: label ikut menjadi anggota menu (section) aktif → bisa
    -- di-minimize bersama fitur lain di menu yang sama
    self:_own(el)
    return el
end

--// ────────────────────────── Elemen: PARAGRAPH ─────────────────────────────
function TabClass:AddParagraph(cfg)
    cfg = cfg or {}
    local holder = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self:_nextOrder(),
        Parent = self.Container,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = holder,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Text = cfg.Title or "Paragraph",
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        Parent = holder,
    })
    local body = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        -- FIX v2.1.2: tinggi eksplisit terukur (autoFitText) — bukan
        -- AutomaticSize.Y (dapat memesan tinggi kurang dari teks →
        -- teks paragraph tumpah keluar kartu / tertimpa elemen bawahnya)
        Text = cfg.Text or "",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2,
        Parent = holder,
    })
    autoFitText(body, 0)
    local el = { Type = "Paragraph", Instance = holder }
    el.SetText = function(text) -- dipanggil: el.SetText("teks baru")
        body.Text = tostring(text)
    end
    function el:Remove()
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
    end
    -- v2.2.1: paragraph ikut menjadi anggota menu (section) aktif
    self:_own(el)
    return el
end

--// ──────────────────────────────── Window ──────────────────────────────────
--  v2: layout modern — sidebar vertikal (logo + tab ber-ikon + versi)
--  di kiri, header dengan SEARCH BAR di kanan atas, konten scroll di bawah.
local WindowClass = {}
WindowClass.__index = WindowClass

local SIDEBAR_W   = 156  -- lebar sidebar penuh (nama tab tampil)
local SIDEBAR_MIN = 48   -- lebar sidebar sempit (hanya ikon, window kecil)
local HEADER_H    = 46   -- tinggi header (search + tombol kontrol)

--  Ubah ukuran frame tetapi sisi kiri-atas dipertahankan (aman untuk anchor 0.5)
local function setSizeKeepTopLeft(frame, targetSize)
    local oldAbs = frame.AbsoluteSize
    frame.Size = UDim2.fromOffset(targetSize.X, targetSize.Y)
    frame.Position = UDim2.new(
        frame.Position.X.Scale, frame.Position.X.Offset + (targetSize.X - oldAbs.X) * 0.5,
        frame.Position.Y.Scale, frame.Position.Y.Offset + (targetSize.Y - oldAbs.Y) * 0.5
    )
end

function ThorUi:CreateWindow(cfg)
    if not LocalPlayer then
        warn("[ThorUi] CreateWindow hanya bisa dipanggil dari client (LocalScript).")
        return nil
    end
    cfg = cfg or {}
    local gui = ensureGui()
    local reg = Registry.new()
    local viewport = GetViewport()

    -- batas minimal ukuran (UISizeConstraint) + auto-clamp untuk layar kecil
    local minSize = cfg.MinSize or Vector2.new(400, 250)
    minSize = Vector2.new(
        math.min(minSize.X, math.max(viewport.X - 20, 220)),
        math.min(minSize.Y, math.max(viewport.Y - 20, 160))
    )

    -- ukuran default responsif mobile jika tidak ditentukan
    local size = cfg.Size or (IsMobile() and UDim2.new(0.92, 0, 0.62, 0) or UDim2.new(0, 620, 0, 430))

    -- ── Frame utama ──
    local frame = Create("Frame", {
        Name = "ThorUi_Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = cfg.Position or UDim2.new(0.5, 0, 0.5, 0),
        Size = size,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        Visible = false, -- muncul setelah splash (atau langsung jika tanpa splash)
        Parent = gui,
    })
    Corner(frame, 12)
    Stroke(frame, { Color = Theme.Stroke, Thickness = 1, Transparency = 0.15 })
    local sizeConstraint = Create("UISizeConstraint", { MinSize = minSize, Parent = frame })
    local uiScale = Create("UIScale", { Parent = frame })

    -- ── SIDEBAR (logo + tab vertikal + versi) ──
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, SIDEBAR_W, 1, 0),
        BackgroundColor3 = Theme.White, -- PUTIH: gradien navy murni (bukan RGB(1,2,4)!)
        BorderSizePixel = 0,
        Active = true,
        Parent = frame,
    })
    Gradient(sidebar, Theme.BackgroundAlt, Theme.Background, 90)

    -- baris logo (juga area drag)
    local logoRow = Create("Frame", {
        Name = "LogoRow",
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundTransparency = 1,
        Active = true,
        Parent = sidebar,
    })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 1), -- +1px: glyph ⚡ emoji cenderung melayang ke atas
        Size = UDim2.new(0, 20, 1, 0),
        Text = "⚡",
        Font = Theme.FontBold,
        TextSize = 18,
        TextColor3 = Theme.AccentGold,
        Parent = logoRow,
    })
    local logoText = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(1, -44, 1, 0),
        Text = cfg.Title or "ThorUi",
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.White,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = logoRow,
    })
    Gradient(logoText, Theme.AccentGold, Theme.Accent, 15)

    -- pembatas bawah logo
    local logoDivider = Create("Frame", {
        Position = UDim2.new(0, 10, 0, 54),
        Size = UDim2.new(1, -20, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        Parent = sidebar,
    })

    -- daftar tab (scrollable vertikal)
    local tabList = Create("ScrollingFrame", {
        Name = "TabList",
        Position = UDim2.new(0, 0, 0, 62),
        -- ruang bawah disisakan untuk tombol expand "+" & label versi
        Size = UDim2.new(1, 0, 1, -120),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.4,
        Parent = sidebar,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList,
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = tabList,
    })

    -- versi di pojok bawah sidebar
    local versionLabel = Create("TextLabel", {
        Position = UDim2.new(0, 0, 1, -24),
        Size = UDim2.new(1, 0, 0, 16),
        Text = "v" .. ThorUi.Version,
        Font = Theme.FontMain,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        BackgroundTransparency = 1,
        Parent = sidebar,
    })

    -- ── SISI KANAN: header (search + kontrol) + konten ──
    local right = Create("Frame", {
        Name = "Right",
        Position = UDim2.new(0, SIDEBAR_W, 0, 0),
        Size = UDim2.new(1, -SIDEBAR_W, 1, 0),
        BackgroundTransparency = 1,
        Parent = frame,
    })

    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER_H),
        BackgroundColor3 = Theme.White, -- PUTIH: gradien navy murni
        BorderSizePixel = 0,
        Parent = right,
    })
    Gradient(header, Theme.BackgroundAlt, Theme.Background, 90)

    -- strip drag di belakang konten header (search & tombol kontrol Active
    -- sehingga tidak ikut ter-drag saat diklik)
    local dragStrip = Create("Frame", {
        Name = "DragStrip",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Active = true,
        Parent = header,
    })

    -- SEARCH BAR (filter elemen di tab aktif, real-time)
    local searchWrap = Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        -- FIX v2.1.1: lebar dikurangi agar TIDAK menimpa tombol minimize "—"
        -- (dulu tepi kanan search masuk ke area tombol kontrol → tombol "—"
        -- tampak menempel di atas search bar / "tidak pada tempatnya")
        Size = UDim2.new(1, -90, 0, 30),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Active = true, -- serap klik agar tidak memicu drag window
        Parent = header,
    })
    Corner(searchWrap, 8)
    local searchStroke = Stroke(searchWrap, { Color = Theme.StrokeDim, Transparency = 0.35 })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 1), -- +1px nudge glyph 🔍
        Size = UDim2.new(0, 16, 1, 0),
        Text = "🔍",
        Font = Theme.FontMain,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        Parent = searchWrap,
    })
    local searchBox = Create("TextBox", {
        Position = UDim2.new(0, 28, 0, 0),
        Size = UDim2.new(1, -34, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Cari elemen...",
        PlaceholderColor3 = Theme.TextDim,
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        Parent = searchWrap,
    })

    -- objek window (dibuat lebih awal agar bisa dipakai closure tombol kontrol)
    local self = setmetatable({
        Frame = frame,
        Gui = gui,
        Registry = reg,
        UiScale = uiScale,
        SizeConstraint = sizeConstraint,
        Sidebar = sidebar,
        LogoRow = logoRow,
        LogoText = logoText,
        VersionLabel = versionLabel,
        TabList = tabList,
        Right = right,
        Header = header,
        SearchBox = searchBox,
        Tabs = {},
        Collapsed = false,
        _closing = false,
        _activeTab = nil,
        _minSize = minSize,
        _savedAbs = nil,
        _narrow = nil,
        _sidebarW = SIDEBAR_W,
        _searchQuery = "",
        _overlays = {},
        CollapseLabel = nil,
    }, WindowClass)

    reg:Connect(searchBox:GetPropertyChangedSignal("Text"), function()
        -- OPTIMASI v2.2.0: debounce 0.1s — filter per ketikan memicu
        -- re-layout penuh seluruh elemen tab; kini digabung satu kali.
        local text = searchBox.Text
        self._searchTick = (self._searchTick or 0) + 1
        local tick = self._searchTick
        task.delay(0.1, function()
            if self._searchTick == tick and self.Frame.Parent then
                self:_applySearch(text)
            end
        end)
    end)
    reg:Connect(searchBox.Focused, function()
        Tween(reg, searchStroke, TI_HOVER, { Color = Theme.Accent, Transparency = 0 })
    end)
    reg:Connect(searchBox.FocusLost, function()
        Tween(reg, searchStroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.35 })
    end)

    -- ── Tombol kontrol (— collapse, ✕ close) ──
    local function makeControl(text, offsetX, hoverColor, onClick)
        local btn = Create("TextButton", {
            Text = "",
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, offsetX, 0.5, 0),
            Size = UDim2.fromOffset(32, 32),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            ZIndex = 3,
            Parent = header,
        })
        Corner(btn, 8)
        local lbl = Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 1), -- +1px: glyph — / ✕ agar pas di tengah
            Size = UDim2.new(1, 0, 1, 0),
            Text = text,
            Font = Theme.FontBold,
            TextSize = 16,
            TextColor3 = Theme.TextDim,
            Parent = btn,
        })
        reg:Connect(btn.MouseEnter, function()
            Tween(reg, lbl, TI_HOVER, { TextColor3 = hoverColor })
        end)
        reg:Connect(btn.MouseLeave, function()
            Tween(reg, lbl, TI_HOVER, { TextColor3 = Theme.TextDim })
        end)
        reg:Connect(btn.Activated, onClick)
        return btn, lbl
    end

    -- posisi tombol kontrol (dari kanan header):
    --   "—" tepi kanan di -44 (rentang -76..-44)   "✕" tepi kanan di -6
    --   (rentang -38..-6) → search bar berhenti di -80, tidak ada yang bertumpuk
    local collapseBtn, collapseLabel = makeControl("—", -44, Theme.AccentGold, function()
        Zap(reg, collapseBtn, Theme.AccentGold, 8)
        self:SetCollapsed(not self.Collapsed)
    end)
    self.CollapseLabel = collapseLabel
    local closeBtn = makeControl("✕", -6, Theme.Danger, function()
        Zap(reg, closeBtn, Theme.Danger, 8)
        self:Hide()
    end)

    -- ── Tombol expand "+" di sidebar (hanya tampil saat window MINIMIZED) ──
    --  Saat collapse, panel kanan (termasuk tombol "—" di header) disembunyikan,
    --  jadi tombol ini satu-satunya cara membesarkan window kembali.
    local expandBtn = Create("TextButton", {
        Name = "ExpandBtn",
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -24),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 4,
        Parent = sidebar,
    })
    Corner(expandBtn, 9)
    local expandStroke = Stroke(expandBtn, { Color = Theme.AccentGold, Thickness = 1, Transparency = 0.25 })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "+",
        Font = Theme.FontBold,
        TextSize = 20,
        TextColor3 = Theme.AccentGold,
        Parent = expandBtn,
    })
    reg:Connect(expandBtn.MouseEnter, function()
        Tween(reg, expandBtn, TI_HOVER, { BackgroundTransparency = 0.1 })
        Tween(reg, expandStroke, TI_HOVER, { Transparency = 0 })
    end)
    reg:Connect(expandBtn.MouseLeave, function()
        Tween(reg, expandBtn, TI_HOVER, { BackgroundTransparency = 0.35 })
        Tween(reg, expandStroke, TI_HOVER, { Transparency = 0.25 })
    end)
    reg:Connect(expandBtn.Activated, function()
        Zap(reg, expandBtn, Theme.AccentGold, 9)
        self:SetCollapsed(false)
    end)
    self.ExpandBtn = expandBtn

    -- garis petir di bawah header (aksen emas → cyan)
    local thunderLine = Create("Frame", {
        Position = UDim2.new(0, 0, 0, HEADER_H),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.White, -- PUTIH: garis petir emas->biru murni
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = right,
    })
    Gradient(thunderLine, Theme.AccentGold, Theme.Accent, 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.9),
    }))

    -- ── Konten: ScrollingFrame + AutomaticCanvasSize (elemen tak terbatas) ──
    local content = Create("ScrollingFrame", {
        Name = "Content",
        Position = UDim2.new(0, 0, 0, HEADER_H + 1),
        Size = UDim2.new(1, 0, 1, -(HEADER_H + 1)),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.2,
        Parent = right,
    })
    self.Content = content

    -- ── Corner resize handle (drag di sudut kanan-bawah) ──
    local grip = Create("TextButton", {
        Name = "ResizeGrip",
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -2, 1, -2),
        Size = UDim2.fromOffset(34, 34),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = frame,
    })
    self.Grip = grip
    local gripLines = {}
    for i = 0, 2 do
        local line = Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 4 - i * 5, 0.5, 4 - i * 5),
            Size = UDim2.new(0, 10, 0, 2),
            Rotation = 45,
            BackgroundColor3 = Theme.TextDim,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Parent = grip,
        })
        Corner(line, UDim.new(1, 0))
        table.insert(gripLines, line)
    end
    reg:Connect(grip.MouseEnter, function()
        for _, line in ipairs(gripLines) do
            Tween(reg, line, TI_HOVER, { BackgroundColor3 = Theme.Accent })
        end
    end)
    reg:Connect(grip.MouseLeave, function()
        for _, line in ipairs(gripLines) do
            Tween(reg, line, TI_HOVER, { BackgroundColor3 = Theme.TextDim })
        end
    end)

    -- ── Drag window: Mouse & Touch via UserInputService ──
    -- (area drag: baris logo sidebar + header kanan)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local function beginDrag(input, handle)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                return
            end
            -- bawa window ini ke depan
            for _, w in ipairs(_state.Windows) do
                w.Frame.ZIndex = 1
            end
            frame.ZIndex = 2
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = frame.Position
        end
    end
    reg:Connect(logoRow.InputBegan, function(input)
        beginDrag(input, logoRow)
    end)
    reg:Connect(dragStrip.InputBegan, function(input)
        beginDrag(input, dragStrip)
    end)
    reg:Connect(UserInputService.InputChanged, function(input)
        if dragging and gestureInput(dragInput, input) then
            local delta = input.Position - dragStart
            -- clamp: minimal 56px sisi window & 30px baris judul tetap
            -- terlihat — window tidak bisa "hilang" ke luar layar
            local vp = GetViewport()
            local size = frame.AbsoluteSize
            local center = Vector2.new(
                startPos.X.Scale * vp.X + startPos.X.Offset + delta.X,
                startPos.Y.Scale * vp.Y + startPos.Y.Offset + delta.Y
            )
            local loX = 56 - size.X * 0.5
            local hiX = math.max(loX, vp.X - 56 + size.X * 0.5)
            local loY = 30 - size.Y * 0.5
            local hiY = math.max(loY, vp.Y - 30 + size.Y * 0.5)
            center = Vector2.new(
                math.clamp(center.X, loX, hiX),
                math.clamp(center.Y, loY, hiY)
            )
            frame.Position = UDim2.new(0, center.X, 0, center.Y)
        end
    end)
    reg:Connect(UserInputService.InputEnded, function(input)
        if dragging and gestureEnded(dragInput, input) then
            dragging = false
            dragInput = nil
        end
    end)

    -- ── Resize window: tahan & geser handle sudut (Mouse & Touch) ──
    local resizing = false
    local resizeInput = nil
    local resizeStartPos = nil
    local resizeStartSize = nil
    local resizeFramePos = nil
    reg:Connect(grip.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if self.Collapsed then
                return
            end
            if resizing then
                return
            end
            resizing = true
            resizeInput = input
            resizeStartPos = input.Position
            resizeStartSize = frame.AbsoluteSize
            resizeFramePos = frame.Position
            for _, line in ipairs(gripLines) do
                Tween(reg, line, TI_HOVER, { BackgroundColor3 = Theme.AccentGold })
            end
        end
    end)
    reg:Connect(UserInputService.InputChanged, function(input)
        if resizing and gestureInput(resizeInput, input) then
            local delta = input.Position - resizeStartPos
            local vp = GetViewport()
            local target = Vector2.new(
                math.clamp(resizeStartSize.X + delta.X, self._minSize.X, vp.X - 12),
                math.clamp(resizeStartSize.Y + delta.Y, self._minSize.Y, vp.Y - 12)
            )
            frame.Size = UDim2.fromOffset(target.X, target.Y)
            -- kompensasi posisi agar sisi kiri-atas tidak bergeser (anchor 0.5,0.5)
            frame.Position = UDim2.new(
                resizeFramePos.X.Scale, resizeFramePos.X.Offset + (target.X - resizeStartSize.X) * 0.5,
                resizeFramePos.Y.Scale, resizeFramePos.Y.Offset + (target.Y - resizeStartSize.Y) * 0.5
            )
        end
    end)
    reg:Connect(UserInputService.InputEnded, function(input)
        if resizing and gestureEnded(resizeInput, input) then
            resizing = false
            resizeInput = nil
            for _, line in ipairs(gripLines) do
                Tween(reg, line, TI_HOVER, { BackgroundColor3 = Theme.TextDim })
            end
        end
    end)

    -- ── Responsif: sidebar auto icon-only saat window sempit ──
    reg:Connect(frame:GetPropertyChangedSignal("AbsoluteSize"), function()
        self:_updateResponsive()
    end)

    -- daftarkan window
    table.insert(_state.Windows, self)

    -- keybind toggle + tombol ⚡ melayang
    bindToggleKey(cfg.Keybind)
    if cfg.ShowToggle ~= false then
        _state.ToggleVisible = true
        ensureToggleButton()
        ThorUi:SetToggleVisible(true)
    end

    -- tata layout awal (sidebar lebar/sembunyi sesuai lebar window)
    self:_updateResponsive()

    -- ── Splash screen (sekali per sesi) lalu window pop muncul ──
    local useSplash = cfg.Splash
    if useSplash == nil then
        useSplash = not _state.SplashDone
    end
    if useSplash then
        _state.SplashDone = true
        playSplash(function()
            self:Show()
        end)
    else
        self:Show()
    end

    return self
end

--// ────────────────────────── Metode Window ─────────────────────────────────
function WindowClass:CreateTab(cfg)
    local tab = TabClass.new(self, cfg)
    table.insert(self.Tabs, tab)
    if not self._activeTab then
        self:SelectTab(tab)
    end
    return tab
end

function WindowClass:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        if t ~= tab then
            t.Active = false
            t.Container.Visible = false
            t.Label.TextColor3 = Theme.TextDim
            t.Icon.TextColor3 = Theme.TextDim
            t.Button.BackgroundTransparency = 1
            t.Indicator.Size = UDim2.new(0, 3, 0, 0)
        end
    end
    self._activeTab = tab
    tab.Active = true
    tab.Container.Visible = true
    tab.Label.TextColor3 = Theme.Text
    tab.Icon.TextColor3 = Theme.AccentGold
    tab.Button.BackgroundTransparency = 0.55
    tab.Button.BackgroundColor3 = Theme.Card
    -- animasi indikator petir "menyambar" + konten slide-in kilat
    tab.Indicator.Size = UDim2.new(0, 3, 0, 0)
    Tween(self.Registry, tab.Indicator, TI_STRIKE, { Size = UDim2.new(0, 3, 0, 18) })
    tab.Container.Position = UDim2.new(0, 0, 0, 8)
    Tween(self.Registry, tab.Container, TI_SNAP, { Position = UDim2.new(0, 0, 0, 0) })
    self.Content.CanvasPosition = Vector2.new(0, 0)
    -- terapkan filter pencarian yang sedang aktif
    tab:ApplyFilter(self._searchQuery or "")
end

function WindowClass:Show()
    self._closing = false -- batalkan hide yang sedang berjalan
    if self.Frame.Visible and (self.UiScale.Scale or 1) >= 0.99 then
        return
    end
    self.Frame.Visible = true
    self.UiScale.Scale = 0.75
    Tween(self.Registry, self.UiScale, TI_STRIKE, { Scale = 1 })
end

function WindowClass:Hide()
    if self._closing or not self.Frame.Visible then
        return
    end
    self._closing = true
    local tween = Tween(self.Registry, self.UiScale, TI_EXIT, { Scale = 0.7 })
    self.Registry:Connect(tween.Completed, function(playback)
        if playback == Enum.PlaybackState.Completed and self._closing then
            self.Frame.Visible = false
            self.UiScale.Scale = 0.75
            self._closing = false
        end
    end)
end

function WindowClass:Toggle()
    -- window yang sedang menutup dianggap "tersembunyi":
    -- tap beruntun membatalkan hide & langsung memunculkan kembali
    if self._closing or not self.Frame.Visible then
        self:Show()
    else
        self:Hide()
    end
end

--  v2: collapse = window menyusut jadi sidebar saja (kanan disembunyikan).
--  Tombol "+" di bawah sidebar muncul saat minimized untuk memperbesar kembali.
function WindowClass:SetCollapsed(collapsed)
    if self.Collapsed == collapsed then
        return
    end
    self.Collapsed = collapsed
    local sideW = self._sidebarW or SIDEBAR_W
    if collapsed then
        self._savedAbs = self.Frame.AbsoluteSize
        self.Right.Visible = false
        self.Grip.Visible = false
        self.SizeConstraint.MinSize = Vector2.new(SIDEBAR_MIN, 120)
        setSizeKeepTopLeft(self.Frame, Vector2.new(sideW, self.Frame.AbsoluteSize.Y))
    else
        self.Right.Visible = true
        self.Grip.Visible = true
        -- kembalikan ukuran SEBELUM MinSize dipulihkan, agar frame sempit
        -- (48-156px) tidak sempat di-clamp ke atas oleh UISizeConstraint;
        -- clamp juga ke viewport saat ini (aman saat rotasi layar mobile)
        if self._savedAbs then
            local vp = GetViewport()
            local target = Vector2.new(
                math.max(self._minSize.X, math.min(self._savedAbs.X, vp.X - 12)),
                math.max(self._minSize.Y, math.min(self._savedAbs.Y, vp.Y - 12))
            )
            setSizeKeepTopLeft(self.Frame, target)
        end
        self.SizeConstraint.MinSize = self._minSize
    end
    if self.CollapseLabel then
        self.CollapseLabel.Text = collapsed and "+" or "—"
    end
    -- tombol expand "+" di sidebar hanya tampil saat minimized;
    -- label versi disembunyikan agar tidak bertabrakan
    if self.ExpandBtn then
        self.ExpandBtn.Visible = collapsed
    end
    if self.VersionLabel then
        self.VersionLabel.Visible = not collapsed and not self._narrow
    end
    Zap(self.Registry, self.Header, Theme.AccentGold, 8)
end

function WindowClass:SetKeybind(key)
    ThorUi:SetKeybind(key)
end

function WindowClass:SetTitle(text)
    self.LogoText.Text = tostring(text or "ThorUi")
end

--  Sidebar responsif: window sempit (< 520px) → icon-only (lebar 48px).
function WindowClass:_updateResponsive()
    -- saat collapsed, ukur "lebar logis" (ukuran sebelum minimize) supaya
    -- sidebar tidak ikut menyempit hanya karena window sedang dikecilkan;
    -- jika AbsoluteSize belum ter-layout (0), perkirakan dari Size x viewport
    local width = self.Frame.AbsoluteSize.X
    if self.Collapsed and self._savedAbs then
        width = self._savedAbs.X
    elseif width <= 0 then
        local vp = GetViewport()
        width = self.Frame.Size.X.Scale * vp.X + self.Frame.Size.X.Offset
    end
    local narrow = width < 520
    if narrow == self._narrow then
        return
    end
    self._narrow = narrow
    local w = narrow and SIDEBAR_MIN or SIDEBAR_W
    self._sidebarW = w
    self.Sidebar.Size = UDim2.new(0, w, 1, 0)
    self.Right.Position = UDim2.new(0, w, 0, 0)
    self.Right.Size = UDim2.new(1, -w, 1, 0)
    self.LogoText.Visible = not narrow
    self.VersionLabel.Visible = not narrow and not self.Collapsed
    for _, t in ipairs(self.Tabs) do
        t.Label.Visible = not narrow
        -- FIX v2.1.1: saat sidebar icon-only, ikon diletakkan PERSIS di tengah
        -- tombol (dulu tetap menempel di kiri → ikon terlihat "tidak di tempatnya")
        t.Icon.Position = narrow
            and UDim2.new(0.5, -9, 0, 1)
            or UDim2.new(0, 10, 0, 1)
    end
    if self.Collapsed then
        setSizeKeepTopLeft(self.Frame, Vector2.new(w, self.Frame.AbsoluteSize.Y))
    end
end

--  Search bar: filter elemen di tab aktif secara real-time.
function WindowClass:_applySearch(text)
    self._searchQuery = tostring(text or "")
    if self._activeTab then
        self._activeTab:ApplyFilter(self._searchQuery)
    end
end

--// ──────────────── CONFIRM DIALOG (modal modern) ──────────────────────
--  Window:Confirm({
--      Title = "Hapus semua data?",
--      Content = "Tindakan ini tidak bisa dibatalkan.",
--      ConfirmText = "Ya, hapus", CancelText = "Batal",
--      OnConfirm = function() ... end, OnCancel = function() ... end,
--  })
function WindowClass:Confirm(cfg)
    cfg = cfg or {}
    local gui = self.Gui or self.Frame.Parent
    if not gui then
        return
    end
    local reg = Registry.new()

    -- overlay gelap + tombol latar (klik di luar kartu = batal)
    local overlay = Create("Frame", {
        Name = "ThorUi_Confirm",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 80,
        Parent = gui,
    })
    local bgBtn = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 80,
        Parent = overlay,
    })

    -- kartu dialog (CanvasGroup agar bisa fade)
    -- FIX v2.1.1: lebar auto-fit agar tidak keluar layar di mobile
    local vp = GetViewport()
    local card = Create("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, math.min(320, math.max(220, math.floor(vp.X - 30))), 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        GroupTransparency = 1,
        Active = true, -- serap klik agar bgBtn tidak terpicu
        ZIndex = 81,
        Parent = overlay,
    })
    Corner(card, 12)
    Stroke(card, { Color = Theme.Stroke, Transparency = 0.25 })
    local cardScale = Create("UIScale", { Scale = 0.85, Parent = card })

    local inner = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        Parent = inner,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = inner,
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Text = cfg.Title or "Konfirmasi",
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        Parent = inner,
    })
    local msgLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        -- FIX v2.1.2: tinggi eksplisit terukur — dulu AutomaticSize.Y bisa
        -- memesan tinggi kurang dari teks → baris TOMBOL menimpa pesan
        Text = cfg.Content or "",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2,
        Parent = inner,
    })
    autoFitText(msgLabel, 0)

    -- baris tombol: Batal | Konfirmasi
    local btnRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        LayoutOrder = 3,
        Parent = inner,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = btnRow,
    })

    local function makeDialogBtn(order, bg, txtColor, text, onClick)
        local btn = Create("TextButton", {
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(0.5, -4, 1, 0),
            BackgroundColor3 = bg,
            BorderSizePixel = 0,
            LayoutOrder = order,
            Parent = btnRow,
        })
        Corner(btn, 8)
        local lbl = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = text,
            Font = Theme.FontBold,
            TextSize = 12,
            TextColor3 = txtColor,
            Parent = btn,
        })
        reg:Connect(btn.MouseEnter, function()
            Tween(reg, btn, TI_HOVER, { BackgroundColor3 = Theme.CardHover })
        end)
        reg:Connect(btn.Activated, function()
            Zap(reg, btn, Theme.Accent, 8)
            onClick()
        end)
        _ = lbl
        return btn
    end

    local entry = { Overlay = overlay, Reg = reg, Closed = false }
    table.insert(self._overlays, entry)

    local function close(result)
        if entry.Closed then
            return
        end
        entry.Closed = true
        for i, e in ipairs(self._overlays) do
            if e == entry then
                table.remove(self._overlays, i)
                break
            end
        end
        local out = Tween(reg, card, TI_EXIT, { GroupTransparency = 1 })
        Tween(reg, cardScale, TI_EXIT, { Scale = 0.9 })
        Tween(reg, bgBtn, TI_EXIT, { BackgroundTransparency = 1 })
        out.Completed:Connect(function()
            reg:Clean()
            if overlay.Parent then
                overlay:Destroy()
            end
            if result and cfg.OnConfirm then
                cfg.OnConfirm()
            elseif not result and cfg.OnCancel then
                cfg.OnCancel()
            end
        end)
    end

    makeDialogBtn(1, Theme.Card, Theme.TextDim, cfg.CancelText or "Batal", function()
        close(false)
    end)
    local confirmBtn = makeDialogBtn(2, Theme.Accent, Theme.White, cfg.ConfirmText or "Konfirmasi", function()
        close(true)
    end)
    -- FIX v2.1.4: gradien confirmBtn DIHAPUS — selain tertint (hover
    -- men-tween bg ke CardHover -> gradien ikut berubah kotor), interpolasi
    -- biru->emas juga melintas abu kehijauan. Solid Electric Blue: bersih.

    reg:Connect(bgBtn.Activated, function()
        close(false)
    end)

    -- animasi masuk
    Tween(reg, bgBtn, TI_SNAP, { BackgroundTransparency = 0.45 })
    Tween(reg, card, TI_SNAP, { GroupTransparency = 0 })
    Tween(reg, cardScale, TI_STRIKE, { Scale = 1 })
end

function WindowClass:Destroy()
    -- tutup semua dialog Confirm yang masih terbuka
    for _, o in ipairs(self._overlays) do
        o.Reg:Clean()
        if o.Overlay.Parent then
            o.Overlay:Destroy()
        end
    end
    self._overlays = {}
    -- putuskan SEMUA koneksi milik window ini (anti memory-leak)
    self.Registry:Clean()
    for _, tab in ipairs(self.Tabs) do
        tab.Registry:Clean()
    end
    local elements = {}
    for _, tab in ipairs(self.Tabs) do
        for _, el in ipairs(tab.Elements) do
            table.insert(elements, el)
        end
    end
    for _, el in ipairs(elements) do
        el:Remove()
    end
    if self.Frame and self.Frame.Parent then
        self.Frame:Destroy()
    end
    for i, w in ipairs(_state.Windows) do
        if w == self then
            table.remove(_state.Windows, i)
            break
        end
    end
    -- sembunyikan tombol ⚡ jika sudah tidak ada window tersisa
    if #_state.Windows == 0 then
        ThorUi:SetToggleVisible(false)
    end
end

--// ──────────────────────── Hancurkan SELURUH UI ────────────────────────────
function ThorUi:Destroy()
    -- 1) hancurkan semua window (memicu Clean semua registry window/tab/elemen)
    local windows = {}
    for _, w in ipairs(_state.Windows) do
        table.insert(windows, w)
    end
    for _, w in ipairs(windows) do
        w:Destroy()
    end
    -- 2) tutup semua notifikasi (cancel task.delay yang masih berjalan)
    local notifs = {}
    for _, n in ipairs(_state.Notifs) do
        table.insert(notifs, n)
    end
    for _, n in ipairs(notifs) do
        despawnNotification(n, true)
    end
    -- 3) hentikan splash jika sedang berjalan
    _state.SplashActive = false
    -- 4) bersihkan garbage table level library (semua connection & tween)
    _state.Registry:Clean()
    _state.KeyConn = nil
    _state.TogglePulse = nil
    -- 5) hancurkan ScreenGui
    if _state.Gui then
        _state.Gui:Destroy()
    end
    _state.Gui = nil
    _state.NotifyHolder = nil
    _state.ToggleButton = nil
    _state.Windows = {}
    _state.Notifs = {}
end

return ThorUi

--[[ ═════════════════════════════════════════════════════════════════════════
        CONTOH IMPLEMENTASI
        ═══════════════════════════════════════════════════════════════════════

        A. CARA PEMAKAIAN DI ROBLOX STUDIO
           1. Buat ModuleScript bernama "ThorUi" (misalnya di ReplicatedStorage),
              lalu tempel seluruh isi file ini ke dalamnya.
           2. Buat LocalScript di StarterPlayer > StarterPlayerScripts.
           3. Tulis kode berikut di LocalScript tersebut:

        ──────────────────────────── potong di sini ────────────────────────────

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")

        local ThorUi = require(ReplicatedStorage:WaitForChild("ThorUi"))

        -- (Opsional) kustomisasi tema SEBELUM membuat window:
        -- ThorUi.Theme.Accent     = Color3.fromRGB(170, 90, 255)
        -- ThorUi.Theme.AccentGold = Color3.fromRGB(255, 200, 60)

        local Window = ThorUi:CreateWindow({
                Title   = "ThorUi ⚡",
                Size    = UDim2.new(0, 620, 0, 430),  -- kosongkan agar otomatis responsif mobile
                MinSize = Vector2.new(400, 250),       -- batas minimal saat resize
                Keybind = Enum.KeyCode.RightControl,  -- toggle buka/tutup UI (PC)
                Splash = true,                        -- splash screen (default: window pertama)
                -- ShowToggle = false,                 -- sembunyikan tombol ⚡ melayang
        })

        local Tab  = Window:CreateTab({ Name = "Main",  Icon = "⚡" })
        local Tab2 = Window:CreateTab({ Name = "Info",  Icon = "🌩" })

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

        local godMode = Tab:AddToggle({
                Name = "God Mode",
                Description = "Kamu jadi kebal dari semua damage selama aktif.",
                Default = false,
                Callback = function(value)
                        print("God Mode:", value)
                end,
        })

        Tab:AddSlider({
                Name = "WalkSpeed",
                Description = "Atur kecepatan jalan karakter (16 - 200).",
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
                Description = "Pilih senjata andalan Sang Dewa Petir.",
                Values = { "Mjolnir", "Stormbreaker", "Gungnir" },
                Default = "Mjolnir",
                -- Multi = true,  -- aktifkan untuk multi-select
                Callback = function(value)
                        print("Senjata:", value)
                end,
        })

        Tab:AddColorPicker({
                Name = "Warna Petir",
                Default = Color3.fromRGB(0, 195, 255),
                Callback = function(color)
                        print("Warna:", color)
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

        -- v2.2.1: MENU (section) BISA DI-MINIMIZE — klik judulnya untuk
        -- melipat semua fitur di dalamnya (chevron ▾ ↔ ▸):
        local menuLanjutan = Tab:AddSection({
                Name = "MENU LANJUTAN (klik untuk minimize)",
                Collapsed = true, -- dibuat dalam keadaan terlipat
        })
        Tab:AddLabel({ Text = "Menu ini dibuat TERLIPAT — klik judulnya untuk membuka." })

        Tab2:AddParagraph({
                Title = "Tentang ThorUi v2",
                Text = "Layout modern dengan tema Dewa Petir: sidebar tab "
                        .. "ber-ikon, search bar untuk filter elemen, splash screen, "
                        .. "ColorPicker, Confirm dialog, dan judul section (menu) yang "
                        .. "bisa DIKLIK untuk minimize. Drag window dari logo/sidebar "
                        .. "atau header, resize dari sudut kanan bawah.",
        })

        ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "Script berhasil dimuat!", Duration = 3 })

        -- Kontrol programatik:
        -- godMode:Set(true)         → set nilai + panggil callback
        -- godMode:Set(true, false)  → set nilai TANPA callback
        -- godMode:Get()             → ambil nilai
        -- godMode:SetDescription("teks keterangan baru")
        -- menuLanjutan:Toggle()  → minimize/buka menu dari script
        -- menuLanjutan:SetCollapsed(false) → buka paksa
        -- Window:Toggle() / Window:Destroy()
        -- Window:SetTitle("Judul Baru")
        -- ThorUi:Destroy()          → hancurkan seluruh UI + bersihkan memory

        ──────────────────────────── potong di sini ────────────────────────────

        B. CARA PEMAKAIAN DI EXECUTOR
           Satu baris (loader otomatis dari GitHub):
               loadstring(game:HttpGet("https://raw.githubusercontent.com/dwisetyabudi15581/ThorUi/main/Loader.lua"))()
           Atau salin seluruh file ini ke executor, bungkus sebagai module,
           lalu panggil seperti contoh di atas. ScreenGui otomatis mencoba
           CoreGui, fallback ke PlayerGui.
]]
