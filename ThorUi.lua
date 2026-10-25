--════════════════════════════════════════════════════════════════════════════
--  ⚡  ThorUi v2.3.1 — Roblox UI Library bertema Dewa Petir (Thor / Petir)
--      Desain, layout & tema 100% original ThorUi ⚡
--  ──────────────────────────────────────────────────────────────────────────
--  Versi     : 2.3.1 (ModuleScript tunggal, tanpa dependensi eksternal)
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
--                         berikutnya) — panah lipat emas berputar sebagai
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
--  BARU DI v2.2.2 (permintaan user: "AddSection jangan kotak — ganti anak
--                  panah; drag UI jangan ada batas; semua section tutup saat
--                  pertama execute; UI jangan terlalu gede")
--  • Panah DIGAMBAR     : chevron section & panah dropdown kini DIGAMBAR
--                         dari 2 batang miring (geometri murni, tanpa
--                         font). Glyph unicode "▾" ternyata dirender Roblox
--                         sebagai KOTAK kosong (tofu) di sebagian perangkat
--                         — itulah "kotak" di judul section. Panah kini
--                         DIJAMIN tampil sebagai panah di semua perangkat.
--  • Section terlipat    : SEMUA section MULAI TERLIPAT saat pertama
--                         execute — daftar fitur langsung rapi; klik judul
--                         untuk membuka. Collapsed = false di AddSection
--                         untuk mulai terbuka (default kini TERLIPAT).
--  • Drag TANPA BATAS    : window bisa digeser bebas keluar layar ke kiri /
--                         kanan / atas / bawah — NOL clamp. Tidak akan
--                         hilang: saat dimunculkan lagi (tombol ⚡ /
--                         keybind) otomatis ditarik balik ke dalam layar.
--  • Default ringkas     : ukuran default window kini 540 x 350 (dulu
--                         620 x 430) — tampil langsung proporsional,
--                         tetap bisa di-resize / minimize sesuka hati.
--
--  BARU DI v2.3.0 (rilis fitur besar — semua tetap tema Thor, nol aset)
--  • STATE + BINDING      : ThorUi:CreateState — satu nilai bersama untuk
--                          banyak elemen; ubah salah satu, semuanya ikut
--                          (2 arah). st:Bind(el, {ToState, ToOption}),
--                          st:BindMany, st:Subscribe, st:Unbind
--  • DEPENDS              : baris muncul/sembunyi OTOMATIS mengikuti nilai
--                          sumber: AddSlider({..., Depends = {Element =
--                          toggleX, Value = true}}) · runtime
--                          Element:SetDependency / ClearDependency
--  • SUB-ROW (AddChild)   : elemen bertingkat! toggle:AddChild("Slider",
--                          {...}) — anak tampil di dalam kartu induk
--                          (terinden, garis pemandu petir, chevron lipat)
--  • SLIDER UNITS         : multi-satuan + konversi otomatis (m ↔ km),
--                          chip pemilih satuan, awalan/satuan berwarna
--                          (RichText), KLIK ANGKA untuk ketik nilai eksak,
--                          setter runtime :SetRange/:SetDecimals/
--                          :SetIncrement/:SetSuffix/:SetUnit
--  • BUTTON ConfirmText   : klik dua tahap untuk aksi berisiko (batal
--                          otomatis 2.5 dtk) + :ResetConfirm
--  • DROPDOWN ++          : Search (filter opsi), ApplyButton (mode aksi:
--                          pilih lalu Apply → callback(nilai, indeks)),
--                          :SetValues/:AddValue/:RemoveValue/:Filter
--  • LIST (baru)          : browser item — Search, Groups, Multi, badge
--                          TopRight, gambar opsional milik user, OnItemClick
--  • MODELVIEW (baru)     : etalase 3D ViewportFrame + kamera auto-frame
--                          + Spin; tanpa model diberikan → palu petir
--                          geometris BAWAAN (murni Part, tetap nol aset)
--  • CANVAS (baru)        : dashboard mini deklaratif — Text/Bar/Button/
--                          Divider + :Set(nama, props)/:Get(nama)/:Fire
--  • GROUP (radio)        : ThorUi:CreateGroup({KeepNone}) + AddToggle({...
--                          , Group = g}) — maksimal satu aktif
--  • QUICK ACTION         : ThorUi:AddQuickAction({Icon, Name, Callback})
--                          — deret tombol melayang yang bisa digeser
--  • SetTheme(patch)      : pengganti edit ThorUi.Theme manual (tetap
--                          dipanggil SEBELUM CreateWindow)
--
--  BARU DI v2.2.3 (permintaan user: "ukuran default bikin rada persegi, jangan
--                  terlalu wide; drag bebas belum work — window langsung
--                  terpotong padahal belum sampai pinggir layar")
--  • Rada persegu        : ukuran default window kini benar2 RADA PERSEGU
--                          (rasio akhir 1:1 s.d. 1.15:1), dihitung murni
--                          dari DIMENSI layar aktual: lebar = terkecil dari
--                          440px / 86% lebar layar / 62% tinggi layar;
--                          tinggi = terkecil dari 390px / 62% tinggi layar
--                          / 1.15x lebar (lihat CreateWindow)
--  • Fix "terpotong"     : AKARNYA BUKAN clamp drag (drag window memang
--                          sudah NOL clamp) — default lama dipilih lewat
--                          deteksi MouseEnabled: sebagian Android/emulator/
--                          executor melaporkan MouseEnabled = true walau
--                          perangkat TANPA mouse → salah mengambil default
--                          PC 540px yang LEBIH LEBAR dari layar HP →
--                          window tampak terpotong di kedua sisi SEJAK
--                          MUNCUL ("belum sampai pinggir layar" pun sudah
--                          kepotong). Kini default murni dari dimensi
--                          viewport → DIJAMIN muat + selalu menyisakan
--                          margin terlihat di semua sisi, jadi drag tidak
--                          langsung menabrak tepi layar
--  • Margin anti-nempel  : auto-clamp MinSize utk layar kecil diperlebar
--                          (margin 20 → 56px) — window kecil pun tetap
--                          berjarak nyaman dari tepi layar
--  • Sidebar tetap label : ambang icon-only diturunkan 520 → 430 px —
--                          default 440px tetap menampilkan NAMA tab;
--                          hanya layar benar2 sempit (hp) yang icon-only
--
--  BARU DI v2.3.1 (permintaan user: "ganti logonya ambil dari repo ThorHub")
--  • LOGO THORHUB       : logo ⚡ resmi diganti PALU MJOLNIR — identitas
--                          ThorHub (kepala emas ber-gradien + 2 paku keling
--                          + gagang biru ber-gradien + kilau). Digambar MURNI
--                          dari Frame (pola ChevronIcon): tanpa font & tanpa
--                          Asset ID → DIJAMIN tampil identik di semua
--                          perangkat (glyph ⚡ lama bergantung pada font
--                          perangkat & sering "melayang" dari garis dasar).
--                          Terpasang di 3 titik brand: lingkaran SPLASH,
--                          baris LOGO SIDEBAR (auto ke tengah saat sidebar
--                          icon-only), dan TOMBOL MELAYANG toggle window
--  • LOGO BISA DIGANTI  : pengguna library bisa memasang logo sendiri —
--                          ThorUi:SetLogo({ Image = "rbxassetid://...",
--                          Size = 26 }) SEBELUM CreateWindow, atau per-window
--                          via CreateWindow({ Logo = { Image, Size } }).
--                          Tanpa itu → palu ThorHub bawaan (tetap nol aset)
--  • Brand "ThorHub"    : judul default splash & sidebar kini "ThorHub"
--                          (tetap bisa dioverride lewat Title)
--  • Mjolnir 3D senada  : palu bawaan AddModelView dicat ulang persis
--                          logo — kepala emas + gagang biru
--
--  FITUR LANJUTAN
--  • Tema Lightning & Thunder : Midnight Blue + Electric Blue / Lightning Gold
--  • Animasi snappy ala kilat : TweenService (Back / Quart / Quad, cepat)
--  • Glow sederhana           : UIGradient + layer transparan + stroke neon
--  • Window draggable         : Mouse & Touch via UserInputService — BEBAS
--                               tanpa batas layar (v2.2.2; pulih otomatis di Show())
--  • Window resizable         : drag-handle di sudut kanan-bawah window
--  • UISizeConstraint         : ukuran minimal (default 400 x 250)
--  • Floating toggle (logo)   : tombol palu ThorHub — bisa digeser BEBAS ke
--                               mana pun (di-clamp ke layar)
--  • Keybind toggle UI        : default RightControl (bisa diganti)
--  • Konten ScrollingFrame    : AutomaticCanvasSize (elemen tak terbatas)
--  • 100% murni script        : Instance.new / UICorner / UIStroke — tanpa
--                               Asset ID gambar sama sekali (anti banned asset)
--  • Anti memory-leak         : semua connection & tween masuk garbage table
--                               (Registry), otomatis di-Clean saat Destroy
--
--  RINGKASAN API
--  ──────────────────────────────────────────────────────────────────────────
--  ThorUi:CreateWindow({Title, Logo, Size, MinSize, Position, Keybind,
--                       ShowToggle, Splash})
--  ThorUi:Notify({Title, Content, Duration, Icon})
--  ThorUi:SetKeybind(Enum.KeyCode.X)    ThorUi:Toggle()    ThorUi:Destroy()
--  ThorUi:SetToggleVisible(bool)
--  ThorUi:SetTheme({Accent = Color3...})        (v2.3.0, sebelum CreateWindow)
--  ThorUi:SetLogo({Image, Size})                (v2.3.1, logo custom, sebelum CreateWindow)
--  ThorUi:CreateState({Name, Default, Callback, Normalize})    (v2.3.0)
--     st:Get()  st:Set(v)  st:Subscribe(fn)  st:Bind(el,{ToState,ToOption})
--     st:BindMany({...})  st:Unbind(el)
--  ThorUi:CreateGroup({KeepNone})               (v2.3.0 — radio toggles)
--  ThorUi:AddQuickAction({Icon, Name, Callback}) (v2.3.0 — tombol melayang)
--
--  Window:CreateTab({Name, Icon})        Window:Show()/Hide()/Toggle()
--  Window:SetCollapsed(bool)             Window:Destroy()
--  Window:SetKeybind(Enum.KeyCode.X)     Window:SetTitle(text)
--  Window:Confirm({Title, Content, ConfirmText, CancelText, OnConfirm, OnCancel})
--
--  Tab:AddButton({Name, ConfirmText, Callback})        (v2.3.0: klik 2 tahap)
--  Tab:AddToggle({Name, Default, Callback, Group})     :Set(bool) / :Get()
--  Tab:AddSlider({Name, Min, Max, Default, Increment, Precision, Suffix,
--                 Prefix, Units, Callback})             :Set(n) / :Get()
--     Units = { Options = {{Name, Suffix, Prefix, FromBase, ToBase, Format,
--               Decimals}}, Default = "m", Callback = fn }
--     v2.3.0: klik ANGKA utk ketik eksak · :SetRange :SetDecimals
--             :SetIncrement :SetSuffix :SetUnit
--  Tab:AddDropdown({Name, Values, Default, Multi, Search, ApplyButton,
--                   Callback})                         :Set(v) / :Get()
--     v2.3.0: :SetValues :AddValue :RemoveValue :Filter
--  Tab:AddTextInput({Name, Text, Placeholder, ClearOnFocus, Callback(text, enter)})
--  Tab:AddKeybind({Name, Default, Callback})             :SetKey(enum) / :Get()
--  Tab:AddColorPicker({Name, Default, Callback})          :Set(Color3) / :Get()
--  Tab:AddList({Name, Items|Groups, Multi, Search, Selected, MaxHeight,
--               OnItemClick})                    (v2.3.0 — browser item)
--     :Get()  :Set(sel)  :SetItems(items, groups)  :Clear()  :Filter(q)
--  Tab:AddModelView({Name, Model, Height, Spin})  (v2.3.0 — etalase 3D)
--     :SetModel(inst)  :SetSpin(bool)  :Get()
--  Tab:AddCanvas({Name, Widgets})                 (v2.3.0 — dashboard mini)
--     Widgets: {Type="Text"|"Bar"|"Button"|"Divider", Name, Text, Value,
--               Color, Callback}
--     :Set(nama, props)  :Get(nama)  :AddWidget(spec)  :Fire(nama)
--  Tab:AddSection({Name, Description, Collapsed})   → Section (menu)
--     Collapsed default = true (v2.2.2) · false = mulai terbuka
--     Section:SetCollapsed(bool)  Section:Toggle()  Section:IsCollapsed()
--  Tab:AddLabel({Text})   Tab:AddParagraph({Title, Text})
--  Element:Set(...)         Element:Get()          Element:Remove()
--  Element:SetDescription(teks)   → ubah keterangan elemen kapan pun
--  v2.3.0 (semua elemen inti):
--  Element:AddChild(kind, cfg)  → anak bertingkat ("Toggle"/"Slider"/
--     "Dropdown"/"Button"/"TextInput"/"Keybind"/"ColorPicker"/"Label"/
--     "Paragraph"/"List"/"ModelView"/"Canvas")
--  Element:SetExpanded(bool)  Element:ToggleExpanded()  Element:IsExpanded()
--  Element:SetDependency({Element|State, Value|Predicate})
--  Element:ClearDependency()
--
--  Catatan: SEMUA elemen menerima Description = "keterangan kecil" yang
--  ditampilkan di bawah judul elemen. Ubah warna lewat ThorUi:SetTheme({...})
--  atau ThorUi.Theme SEBELUM CreateWindow untuk custom tema. Contoh
--  implementasi lengkap ada di BLOK PALING BAWAH file ini.
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
    Version = "2.3.1",
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

--  v2.3.0: putus SATU koneksi lebih awal (koneksi tetap aman bila lupa
--  dipanggil — Clean() tetap memutus semuanya saat elemen dihancurkan).
--  CATATAN: pencarian manual (bukan removeFrom) karena util tersebut
--  dideklarasikan lebih bawah di file ini.
function Registry:Disconnect(conn)
    if typeof(conn) == "RBXScriptConnection" then
        pcall(function()
            conn:Disconnect()
        end)
        for i, c in ipairs(self._conns) do
            if c == conn then
                table.remove(self._conns, i)
                break
            end
        end
    end
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

--  v2.2.2: Panah chevron DIGAMBAR, bukan glyph teks. Glyph unicode "▾"
--  (U+25BE) tidak tersedia di font Roblox (Gotham) sehingga dirender
--  sebagai KOTAK kosong (tofu) di sebagian perangkat — itulah "kotak"
--  yang user lihat di judul section. Dua batang miring murni geometri
--  (tanpa font / tanpa Asset ID) = panah yang DIJAMIN tampil di semua
--  perangkat. Rotasi container: 0 = panah bawah (terbuka) ·
--  -90 = panah kanan (terlipat). Warna via BackgroundColor3 kedua batang.
local function ChevronIcon(parent, props)
    props = props or {}
    local px = props.Size or 12
    local center = px * 0.5
    local arm = math.max(6, px * 0.66) -- panjang batang
    local half = arm * 0.3536         -- 1/2 proyeksi diagonal batang
    local color = props.Color or Theme.AccentGold
    local box = Create("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = UDim2.new(0, px, 0, px),
        Rotation = props.Rotation or 0,
        Parent = parent,
    })
    local function armFrame(offsetX, rot)
        return Create("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, math.floor(center + offsetX + 0.5), 0.5, 0),
            Size = UDim2.new(0, math.floor(arm + 0.5), 0, 2),
            Rotation = rot,
            Parent = box,
        })
    end
    local b1 = armFrame(-half, 45)  -- batang kiri ↘ (ujung bertemu di puncak)
    local b2 = armFrame(half, -45)  -- batang kanan ↗
    return box, b1, b2
end

--  LOGO THORHUB (v2.3.1): palu Mjolnir — identitas resmi ThorHub — DIGAMBAR
--  murni dari Frame (kepala emas ber-gradien 3 titik + 2 paku keling +
--  gagang biru ber-gradien + kilau), menelusuri jejak ChevronIcon: tanpa
--  font & tanpa Asset ID → DIJAMIN tampil identik di semua perangkat.
--  Spesifikasi logo 48x48: kepala (7,4) 34x17 · gagang (20.5,21) 7x23.
--  CATATAN v2.1.4: frame ber-gradien wajib berlatar PUTIH agar tint murni.
local function ThorHubLogo(parent, props)
    props = props or {}
    local S = props.Size or 24
    local function px(v)
        return math.max(1, math.floor(v / 48 * S + 0.5))
    end
    local root = Create("Frame", {
        Name = "ThorHubLogo",
        BackgroundTransparency = 1,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = UDim2.fromOffset(S, S),
        Parent = parent,
    })
    -- kepala palu: emas (3 titik gradien terang→tengah→gelap, diagonal)
    local head = Create("Frame", {
        Position = UDim2.fromOffset(px(7), px(4)),
        Size = UDim2.fromOffset(px(34), px(17)),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        Parent = root,
    })
    Corner(head, UDim.new(0, px(4.5)))
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(253, 230, 138)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(251, 191, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 83, 9)),
        }),
        Rotation = 45,
        Parent = head,
    })
    -- kilau permukaan atas kepala
    local shine = Create("Frame", {
        Position = UDim2.fromOffset(px(7) + 1, px(5)),
        Size = UDim2.fromOffset(px(34) - 2, px(6)),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        Parent = root,
    })
    Corner(shine, UDim.new(0, px(3)))
    -- paku keling kiri & kanan
    local function rivet(x)
        local r = Create("Frame", {
            Position = UDim2.fromOffset(px(x), px(9)),
            Size = UDim2.fromOffset(px(4), px(7)),
            BackgroundColor3 = Color3.fromRGB(120, 53, 15),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = root,
        })
        Corner(r, UDim.new(0, px(1.6)))
    end
    rivet(13)
    rivet(31)
    -- gagang: biru (terang→gelap, vertikal)
    local handle = Create("Frame", {
        Position = UDim2.fromOffset(px(20.5), px(21)),
        Size = UDim2.fromOffset(px(7), px(23)),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        Parent = root,
    })
    Corner(handle, UDim.new(0, px(3)))
    Gradient(handle, Color3.fromRGB(147, 197, 253), Color3.fromRGB(37, 99, 235), 90)
    -- kilau gagang
    local hShine = Create("Frame", {
        Position = UDim2.fromOffset(px(22.7), px(21)),
        Size = UDim2.fromOffset(px(2.6), px(23)),
        BackgroundColor3 = Theme.White,
        BackgroundTransparency = 0.72,
        BorderSizePixel = 0,
        Parent = root,
    })
    Corner(hShine, UDim.new(0, px(1.3)))
    return root
end

--  Render logo ke parent (v2.3.1). logoCfg = { Image = "rbxassetid://...",
--  Size = n } dari ThorUi:SetLogo / CreateWindow({ Logo = ... }):
--    • Image ada    → ImageLabel milik user sendiri (boleh Asset ID mereka)
--    • tanpa Image  → palu ThorHub geometris bawaan (default, nol aset)
--  props.Size = ukuran default per- lokasi (ditimpa logoCfg.Size bila ada).
local function MakeLogo(parent, props, logoCfg)
    props = props or {}
    logoCfg = (type(logoCfg) == "table") and logoCfg or {}
    local size = tonumber(logoCfg.Size) or props.Size or 24
    local img = logoCfg.Image
    if type(img) == "string" and img ~= "" then
        return Create("ImageLabel", {
            Name = "ThorHubLogo",
            BackgroundTransparency = 1,
            AnchorPoint = props.AnchorPoint,
            Position = props.Position,
            Size = UDim2.fromOffset(size, size),
            Image = img,
            ScaleType = Enum.ScaleType.Fit,
            Parent = parent,
        })
    end
    return ThorHubLogo(parent, {
        Size = size,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
    })
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
--  v2.2.3: fungsi IsMobile() DIHAPUS — ukuran default window kini dihitung
--  murni dari DIMENSI viewport (lihat CreateWindow). TouchEnabled /
--  MouseEnabled terbukti tidak andal di sebagian Android/emulator/executor
--  (sering melaporkan MouseEnabled = true di perangkat tanpa mouse →
--  default PC 540px pernah terpasang di layar HP yang lebih sempit →
--  window tampak langsung terpotong di kedua sisi).

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

--// ───────────── v2.3.0: RichText (angka berwarna pada nilai slider) ────────
--  Escape teks agar aman di dalam RichText, lalu bungkus dengan tag warna.
--  Dipakai slider: ANGKA tetap emas, awalan/satuan tampil redup kebiruan.
local function escapeRT(text)
    local s = tostring(text)
    s = s:gsub("&", "&amp;")
    s = s:gsub("<", "&lt;")
    s = s:gsub(">", "&gt;")
    return s
end

local function rtColor(color, text)
    return string.format(
        '<font color="rgb(%d,%d,%d)">%s</font>',
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5),
        escapeRT(text)
    )
end

--// ──────────────── v2.3.0: perbandingan nilai (rekursif aman) ──────────────
--  Dipakai State & Dependency untuk mendeteksi "nilai benar2 berubah"
--  (array multi-dropdown dibandingkan per-isinya, bukan per-referensi).
local function valuesEqual(a, b, seen)
    if a == b then
        return true
    end
    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end
    seen = seen or {}
    if seen[a] == b then
        return true
    end
    seen[a] = b
    for k, v in pairs(a) do
        if not valuesEqual(v, b[k], seen) then
            return false
        end
    end
    for k in pairs(b) do
        if a[k] == nil then
            return false
        end
    end
    return true
end

--// ───────────────── v2.3.0: SISTEM STATE + BINDING + DEPENDENCY ────────────
--  STATE   : satu nilai bersama yang bisa DIKAITKAN ke banyak elemen — ubah
--            salah satu, semuanya ikut (dua arah, bebas echo/loop).
--  DEPENDS : baris elemen muncul/sembunyi OTOMATIS mengikuti nilai sumber
--            (mis. slider "Kecepatan" hanya tampil saat toggle "Speed" ON).
--  GROUP   : perilaku radio — sekumpulan toggle, maksimal satu aktif.
local StateClass = {}
StateClass.__index = StateClass

local function isThorState(v)
    return type(v) == "table" and v._kind == "ThorState"
end

--  Dependensi: [sumber] = { {El = elemen}, ... } — sumber bisa elemen/state.
--  Weak-key: sumber yang sudah dihancurkan & GC tidak menahan memori.
local DepRegistry = setmetatable({}, { __mode = "k" })
local AllGroups = {} -- semua grup eksklusif (untuk pembersihan saat Remove)

--  Nilai terkini sebuah sumber (elemen → :Get(), state → .Value).
local function sourceValue(src)
    if isThorState(src) then
        return src.Value
    end
    if type(src) == "table" and type(src.Get) == "function" then
        local ok, v = pcall(src.Get, src)
        if ok then
            return v
        end
    end
    return nil
end

--  Terapkan visibilitas satu baris dependen (dengan kaskade ke turunannya).
local depApply
local function evaluateDepsOf(source)
    local deps = DepRegistry[source]
    if not deps then
        return
    end
    for i = #deps, 1, -1 do
        local entry = deps[i]
        local el = entry.El
        if type(el) ~= "table" or not el.Instance or not el.Instance.Parent then
            table.remove(deps, i)
        else
            depApply(el)
        end
    end
end

depApply = function(el)
    local src = el._depSource
    if not src then
        return
    end
    local visible
    if type(el._depPredicate) == "function" then
        local ok, result = pcall(el._depPredicate, sourceValue(src), src, el)
        visible = ok and result == true
    else
        visible = valuesEqual(sourceValue(src), el._depExpected)
    end
    -- rantai: sumber disembunyikan oleh dependensinya sendiri → ikut sembunyi
    if visible and src._depSource and src._depVisible == false then
        visible = false
    end
    el._depVisible = visible
    local show = visible
    if show and el.Section and el.Section.Collapsed then
        show = false -- section sedang terlipat: tetap ikut terlipat
    end
    if el.Instance then
        el.Instance.Visible = show
    end
    evaluateDepsOf(el)
end

--  Daftarkan ketergantungan sebuah elemen. Konfigurasi:
--    Depends = { Element = toggleX, Value = true }
--    Depends = { State   = stateY,  Value = 25 }
--    Depends = { Element = toggleX, Predicate = function(v) return v == true end }
local function registerDependency(el, cfg)
    if type(cfg) ~= "table" then
        return
    end
    local src = cfg.Element or cfg.State or cfg.Source
    if src == nil then
        return
    end
    -- lepas dependensi lama bila ada
    if el._depSource then
        local old = DepRegistry[el._depSource]
        if old then
            for i, entry in ipairs(old) do
                if entry.El == el then
                    table.remove(old, i)
                    break
                end
            end
        end
    end
    el._depSource = src
    el._depExpected = cfg.Value
    el._depPredicate = type(cfg.Predicate) == "function" and cfg.Predicate or nil
    local list = DepRegistry[src]
    if not list then
        list = {}
        DepRegistry[src] = list
    end
    table.insert(list, { El = el })
    depApply(el)
end

local function clearDependency(el)
    if el._depSource then
        local old = DepRegistry[el._depSource]
        if old then
            for i, entry in ipairs(old) do
                if entry.El == el then
                    table.remove(old, i)
                    break
                end
            end
        end
    end
    el._depSource = nil
    el._depExpected = nil
    el._depPredicate = nil
    el._depVisible = nil
    if el.Instance and el.Instance.Parent then
        local show = true
        if el.Section and el.Section.Collapsed then
            show = false
        end
        el.Instance.Visible = show
    end
end

--  Sinkronisasi grup eksklusif — dipanggil setiap nilai toggle berubah.
local function syncGroup(el)
    local g = el._group
    if type(g) ~= "table" then
        return
    end
    if el.Get and el:Get() == true then
        g.Active = el
        for _, other in ipairs(g.Options) do
            if other ~= el and other.Get and other:Get() == true then
                other:Set(false)
            end
        end
    elseif g.Active == el and g.KeepNone == false then
        -- grup mewajibkan satu aktif → nyalakan kembali
        el:Set(true)
    end
end

--  Pipeline perubahan nilai elemen: (1) dorong ke state terikat, (2) evaluasi
--  baris yang Depends pada elemen ini. Dipanggil pabrik elemen SETIAP kali
--  nilainya berubah — baik oleh aksi pengguna maupun :Set() programatik.
local function notifyChange(element)
    if type(element) ~= "table" or not element.Instance then
        return
    end
    for _, link in ipairs(element._links or {}) do
        if not link._pushing then
            local v = sourceValue(element)
            local mapped = v
            if type(link.ToState) == "function" then
                mapped = link.ToState(v, element)
            end
            link._pushing = true
            link.State:Set(mapped, true)
            link._pushing = false
        end
    end
    evaluateDepsOf(element)
end

--  Lepas elemen dari semua registry global (dipanggil :Remove() elemen).
local function unregisterElement(el)
    for _, link in ipairs(el._links or {}) do
        removeFrom(link.State._links, link)
    end
    el._links = nil
    if el._depSource then
        local old = DepRegistry[el._depSource]
        if old then
            for i, entry in ipairs(old) do
                if entry.El == el then
                    table.remove(old, i)
                    break
                end
            end
        end
    end
    DepRegistry[el] = nil
    el._depSource = nil
    for _, g in ipairs(AllGroups) do
        removeFrom(g.Options, el)
        if g.Active == el then
            g.Active = nil
        end
    end
    el._group = nil
end

--  ── State API publik ──
--  ThorUi:CreateState({ Name, Default, Callback, Normalize })
--  st:Get() / st:Set(v) / st:Subscribe(fn) / st:Bind(target, {ToState, ToOption})
--  / st:BindMany({...}) / st:Unbind(target)
function ThorUi:CreateState(cfg)
    cfg = cfg or {}
    local st = setmetatable({
        _kind = "ThorState",
        Name = tostring(cfg.Name or "State"),
        Value = cfg.Default,
        Normalize = type(cfg.Normalize) == "function" and cfg.Normalize or nil,
        Callback = type(cfg.Callback) == "function" and cfg.Callback or nil,
        _links = {},
        _subs = {},
    }, StateClass)
    return st
end

function StateClass:Get()
    return self.Value
end

--  Dorong nilai state ke satu target (elemen :Set silent / state lain :Set).
local function pushLink(link, stateValue)
    local mapped = stateValue
    if type(link.ToOption) == "function" then
        mapped = link.ToOption(stateValue, link.Target)
    end
    local t = link.Target
    if isThorState(t) then
        t:Set(mapped, true)
    elseif type(t) == "table" and type(t.Set) == "function" then
        pcall(t.Set, t, mapped, true)
    end
end

function StateClass:Set(value, fireCallback)
    if type(self.Normalize) == "function" then
        value = self.Normalize(value)
    end
    local changed = not valuesEqual(self.Value, value)
    self.Value = value
    if changed then
        for _, link in ipairs(self._links) do
            if not link._pushing then
                link._pushing = true
                pushLink(link, value)
                link._pushing = false
            end
        end
        evaluateDepsOf(self)
    end
    if fireCallback ~= false then
        if self.Callback then
            self.Callback(value)
        end
        for _, fn in ipairs(self._subs) do
            fn(value)
        end
    end
    return self
end

function StateClass:Subscribe(fn)
    if type(fn) ~= "function" then
        return function() end
    end
    table.insert(self._subs, fn)
    return function()
        removeFrom(self._subs, fn)
    end
end

function StateClass:Bind(target, opts)
    if target == nil then
        return nil
    end
    opts = opts or {}
    local link = {
        State = self,
        Target = target,
        ToState = type(opts.ToState) == "function" and opts.ToState or nil,
        ToOption = type(opts.ToOption) == "function" and opts.ToOption or nil,
        _pushing = false,
    }
    table.insert(self._links, link)
    if isThorState(target) then
        target._links = target._links or {}
        table.insert(target._links, link)
    elseif type(target) == "table" then
        target._links = target._links or {}
        table.insert(target._links, link)
    end
    -- sync awal: state menang; state kosong (nil) → adopsi nilai target
    if self.Value == nil then
        self.Value = sourceValue(target)
    end
    link._pushing = true
    pushLink(link, self.Value)
    link._pushing = false
    return link
end

--  BindMany({ elemA, elemB, {Element = elemC, ToOption = fn}, ... })
function StateClass:BindMany(list, opts)
    for _, t in ipairs(list or {}) do
        if type(t) == "table" and (t.Element or t.Target) and t.Get == nil and t.Set == nil then
            self:Bind(t.Element or t.Target, t)
        else
            self:Bind(t, opts)
        end
    end
end

function StateClass:Unbind(target)
    for i = #self._links, 1, -1 do
        local link = self._links[i]
        if link.Target == target then
            table.remove(self._links, i)
            if type(target) == "table" and target._links then
                removeFrom(target._links, link)
            end
        end
    end
end

--  ── Grup eksklusif (radio) ──
--  local mode = ThorUi:CreateGroup({ KeepNone = true })
--  Tab:AddToggle({ Name = "A", Group = mode }) ...
--  mode:Get() → toggle aktif · mode:Set(el) · mode:Clear()
function ThorUi:CreateGroup(cfg)
    cfg = cfg or {}
    local group = {
        _kind = "ThorGroup",
        Name = tostring(cfg.Name or "Group"),
        KeepNone = cfg.KeepNone ~= false,
        Options = {},
        Active = nil,
    }
    function group:Set(el)
        for _, other in ipairs(group.Options) do
            if other == el then
                other:Set(true)
            elseif other.Get and other:Get() == true then
                other:Set(false)
            end
        end
    end
    function group:Get()
        return group.Active
    end
    function group:Clear()
        for _, other in ipairs(group.Options) do
            if other.Get and other:Get() == true then
                other:Set(false)
            end
        end
        group.Active = nil
    end
    table.insert(AllGroups, group)
    return group
end

--// ────────────────────────── State library-level ───────────────────────────
local _state = {
    Gui           = nil,  -- ScreenGui utama (CoreGui → PlayerGui fallback)
    NotifyHolder  = nil,  -- kolom notifikasi (kanan atas)
    ToggleButton  = nil,  -- tombol melayang (logo palu)
    TogglePulse   = nil,  -- tween denyut tombol melayang
    Logo          = nil,  -- logo custom {Image, Size} via ThorUi:SetLogo (v2.3.1)
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
        Text = cfg.Title or "ThorHub",
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

--// ─────────── Tombol melayang (logo palu — drag bebas + ketuk) ───────────
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

    -- logo palu ThorHub (v2.3.1) / logo custom (ThorUi:SetLogo) — geometri
    -- murni: presisi persis di tengah, tanpa nudge +2px ala glyph emoji ⚡
    MakeLogo(btn, {
        Size = 26,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, _state.Logo)

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

--// ────────────────── v2.3.0: TEMA (merge sebelum CreateWindow) ─────────────
--  ThorUi:SetTheme({ Accent = Color3.fromRGB(...) }) — gabungkan patch ke
--  tema aktif. Panggil SEBELUM CreateWindow: elemen mengambil warna saat
--  dibuat, jadi perubahan setelah window ada tidak mengecat ulang.
function ThorUi:SetTheme(patch)
    if type(patch) == "table" then
        for k, v in pairs(patch) do
            Theme[k] = v
        end
    end
    return Theme
end

--// ────────────────── v2.3.1: LOGO (pasang sebelum CreateWindow) ─────────────
--  ThorUi:SetLogo({ Image = "rbxassetid://...", Size = 26 }) — pengguna
--  library bisa memasang LOGO SENDIRI; berlaku di splash, sidebar & tombol
--  melayang. Panggil SEBELUM CreateWindow. Tanpa dipanggil → palu ThorHub
--  geometris bawaan (nol Asset ID). Override per-window:
--  CreateWindow({ Logo = { Image = "...", Size = 26 } }).
function ThorUi:SetLogo(cfg)
    _state.Logo = (type(cfg) == "table") and cfg or nil
    return _state.Logo
end

--// ──────────── v2.3.0: QUICK ACTION (tombol aksi melayang) ────────────────
--  Tombol bundar kecil di deret pinggir layar — pintasan aksi favorit yang
--  selalu terlihat walau window tertutup. Seluruh deret bisa DIGESER
--  (drag), ketuk = eksekusi. Contoh:
--      ThorUi:AddQuickAction({ Icon = "⚡", Name = "Rejoin",
--          Callback = function() ... end })
local QUICK_SIZE = 36
local function ensureQuickDock()
    if _state.QuickDock and _state.QuickDock.Parent then
        return _state.QuickDock
    end
    local gui = ensureGui()
    local reg = _state.Registry

    local dock = Create("Frame", {
        Name = "ThorUi_QuickDock",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.28, 0),
        Size = UDim2.fromOffset(QUICK_SIZE, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 40,
        Parent = gui,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = dock,
    })
    _state.QuickDock = dock

    -- drag deret: posisi dikunci offset murni (formula engine, tanpa
    -- AbsolutePosition — anti-loncat di semua lingkungan, pola tombol ⚡)
    reg:Connect(dock:GetPropertyChangedSignal("AbsoluteSize"), function()
        -- ukuran berubah (tombol ditambah) → pastikan tetap di dalam layar
        local vp = GetViewport()
        local p = dock.Position
        local x = math.min(p.X.Offset, vp.X - 20)
        local y = math.clamp(p.Y.Offset, 40, math.max(40, vp.Y - 40))
        dock.Position = UDim2.new(0, x, 0, y)
    end)
    return dock
end

--  Handler drag + tap untuk satu tombol quick action (menggerakkan DERET).
local function bindQuickButton(reg, btn, onTap)
    local dragging = false
    local moved = false
    local startInput = nil
    local startVec = nil
    local startPos = nil -- posisi {x,y} TENGAH deret saat mulai

    reg:Connect(btn.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                return
            end
            dragging = true
            moved = false
            startInput = input
            startVec = input.Position
            local dock = btn.Parent
            local p = dock.Position
            local ps = (dock.Parent and dock.Parent.AbsoluteSize.X > 0)
                and dock.Parent.AbsoluteSize
                or GetViewport()
            startPos = Vector2.new(
                p.X.Scale * ps.X + p.X.Offset,
                p.Y.Scale * ps.Y + p.Y.Offset
            )
            dock.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
        end
    end)

    reg:Connect(UserInputService.InputChanged, function(input)
        if not dragging or not gestureInput(startInput, input) then
            return
        end
        if startVec.X == 0 and startVec.Y == 0 and startVec.Z == 0 then
            startVec = input.Position
        end
        local delta = input.Position - startVec
        if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
            moved = true
        end
        local dock = btn.Parent
        local vp = GetViewport()
        local halfX = QUICK_SIZE * 0.5
        local halfY = math.max(dock.AbsoluteSize.Y * 0.5, QUICK_SIZE * 0.5)
        local nx = math.clamp(startPos.X + delta.X, halfX + 4, math.max(halfX + 4, vp.X - halfX - 4))
        local ny = math.clamp(startPos.Y + delta.Y, halfY + 4, math.max(halfY + 4, vp.Y - halfY - 4))
        dock.Position = UDim2.new(0, math.floor(nx + 0.5), 0, math.floor(ny + 0.5))
    end)

    reg:Connect(UserInputService.InputEnded, function(input)
        if not dragging or not gestureEnded(startInput, input) then
            return
        end
        dragging = false
        if not moved then
            onTap()
        end
    end)
end

--  ThorUi:AddQuickAction({ Icon, Name, Callback }) → { Remove() }
function ThorUi:AddQuickAction(cfg)
    cfg = cfg or {}
    if type(cfg.Callback) ~= "function" then
        return nil
    end
    local dock = ensureQuickDock()
    local reg = _state.Registry

    local btn = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(QUICK_SIZE, QUICK_SIZE),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        LayoutOrder = #dock:GetChildren(),
        Parent = dock,
    })
    Corner(btn, UDim.new(1, 0))
    Stroke(btn, { Color = Theme.AccentGold, Thickness = 1, Transparency = 0.25 })
    local scale = Create("UIScale", { Parent = btn })
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 1),
        Size = UDim2.new(1, 0, 1, 0),
        Text = tostring(cfg.Icon or "⚡"),
        Font = Theme.FontBold,
        TextSize = 15,
        TextColor3 = Theme.AccentGold,
        Parent = btn,
    })

    -- tooltip nama (hanya perangkat bermouse)
    if HOVER_FOR_MOUSE then
        local tip = Create("TextLabel", {
            BackgroundColor3 = Theme.BackgroundAlt,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(0, -12, 0.5, 0),
            Size = UDim2.new(0, math.max(40, #tostring(cfg.Name or "Aksi") * 7 + 16), 0, 22),
            Text = tostring(cfg.Name or "Aksi"),
            Font = Theme.FontMedium,
            TextSize = 11,
            TextColor3 = Theme.Text,
            Visible = false,
            ZIndex = 6,
            Parent = btn,
        })
        Corner(tip, 6)
        Stroke(tip, { Color = Theme.StrokeDim, Transparency = 0.3 })
        reg:Connect(btn.MouseEnter, function()
            tip.Visible = true
            Tween(reg, btn, TI_HOVER, { BackgroundColor3 = Theme.CardHover })
        end)
        reg:Connect(btn.MouseLeave, function()
            tip.Visible = false
            Tween(reg, btn, TI_HOVER, { BackgroundColor3 = Theme.Card })
        end)
    end

    bindQuickButton(reg, btn, function()
        Tween(reg, scale, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1.2 })
        task.delay(0.08, function()
            if btn.Parent then
                Tween(reg, scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
            end
        end)
        Zap(reg, btn, Theme.AccentGold, UDim.new(1, 0))
        cfg.Callback()
    end)

    return {
        Remove = function()
            btn:Destroy()
            if _state.QuickDock and #_state.QuickDock:GetChildren() == 0 then
                _state.QuickDock:Destroy()
                _state.QuickDock = nil
            end
        end,
    }
end

--// ────────────────────────── SPLASH SCREEN (tema Thor) ─────────────────────────────
--  Layar pembuka: logo palu memantul + progress bar petir + status menggemas.
--  playSplash(onDone, brand) tidak memblokir; onDone dipanggil setelah
--  fade-out. brand = { Logo, Title } dari CreateWindow (v2.3.1) — tanpa itu
--  dipakai ThorUi:SetLogo / default palu ThorHub + judul "ThorHub".
local function playSplash(onDone, brand)
    local gui = ensureGui()
    local reg = Registry.new()
    _state.SplashActive = true
    local logoCfg = (type(brand) == "table" and brand.Logo) or _state.Logo
    local titleText = (type(brand) == "table" and brand.Title) or "ThorHub"

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

    -- lingkaran logo (pop memantul saat muncul) — v2.3.1: palu ThorHub
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
    MakeLogo(circle, {
        Size = 48,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, logoCfg)

    -- judul dengan teks gradien emas → cyan
    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Text = titleText,
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
        -- v2.3.0: anak2 (AddChild) dihapus dulu — registry & kaitan
        -- state/dependensi/grup mereka ikut bersih sebelum kartu hancur
        if self.Children then
            local kids = {}
            for _, c in ipairs(self.Children) do
                kids[#kids + 1] = c
            end
            for _, c in ipairs(kids) do
                if type(c.Remove) == "function" then
                    c:Remove()
                end
            end
        end
        -- v2.3.0: lepas dari registry State/Depends/Group
        unregisterElement(self)
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
            -- v2.3.0: disembunyikan oleh Depends → tetap sembunyi
            if el._depVisible == false then
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

--// ──────────────────── v2.3.0: SUB-ROW (Element:AddChild) ──────────────────
--  Setiap elemen interaktif bisa punya ANAK (elemen bertingkat):
--      toggle:AddChild("Slider", { Name = "Kecepatan", Min = 0, Max = 100 })
--  Anak tampil di dalam kartu induk, terinden 16px, dibuka/ditutup lewat
--  panah kecil di kiri judul (chevron tergambar — konsisten anti-tofu).
--  API induk: AddChild(kind, cfg) · SetExpanded(bool) · ToggleExpanded()
--             IsExpanded() · .Children
local CHILD_FACTORIES = {
    Button      = "AddButton",
    Toggle      = "AddToggle",
    Slider      = "AddSlider",
    Dropdown    = "AddDropdown",
    TextInput   = "AddTextInput",
    Keybind     = "AddKeybind",
    ColorPicker = "AddColorPicker",
    Label       = "AddLabel",
    Paragraph   = "AddParagraph",
    List        = "AddList",
    ModelView   = "AddModelView",
    Canvas      = "AddCanvas",
}

local function normalizeChildKind(kind)
    local k = tostring(kind or "")
    k = k:gsub("^%l", string.upper)
    return CHILD_FACTORIES[k] and k or nil
end

--  Dipanggil pabrik elemen SETELAH :_track(element):
--    EnableChildren(tab, element, cfg, row, titleLabel, "row"|"card", yCenter)
--  mode "row"  → chevron di tengah vertikal baris judul (row = Frame baris)
--  mode "card" → judul menempel langsung di kartu (chevron di yCenter px)
--  Sekaligus memasang kaitan Depends (visibilitas otomatis) dari cfg.
local function EnableChildren(tab, element, cfg, row, titleLabel, mode, yCenter)
    element.Children = {}

    local subHost = nil   -- wadah anak (dibuat malas saat anak pertama)
    local chevBtn = nil
    local chevron, chevA, chevB = nil, nil, nil
    local expanded = false

    local function buildSubUI()
        if subHost then
            return
        end
        -- panah kecil di kiri judul (digambar — tanpa glyph font)
        local parentRow = (mode == "card") and element.Instance or row
        chevBtn = Create("TextButton", {
            Name = "Expand",
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.fromOffset(16, 16),
            ZIndex = 5,
            Parent = parentRow,
        })
        if mode == "card" then
            chevBtn.Position = UDim2.new(0, -2, 0, yCenter or 9)
        else
            chevBtn.Position = UDim2.new(0, -2, 0.5, 0)
        end
        chevron, chevA, chevB = ChevronIcon(chevBtn, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = 9,
            Color = Theme.TextDim,
        })
        chevron.Rotation = -90 -- terlipat: panah menghadap kanan
        -- geser judul ke kanan agar tidak bertabrakan dengan panah
        if titleLabel then
            local p = titleLabel.Position
            titleLabel.Position = UDim2.new(p.X.Scale, p.X.Offset + 14, p.Y.Scale, p.Y.Offset)
            titleLabel.Size = UDim2.new(
                titleLabel.Size.X.Scale,
                titleLabel.Size.X.Offset - 14,
                titleLabel.Size.Y.Scale,
                titleLabel.Size.Y.Offset
            )
        end
        element.Registry:Connect(chevBtn.Activated, function()
            element:ToggleExpanded()
        end)
        -- wadah anak: terinden 16px + garis pemandu vertikal tipis di kiri
        subHost = Create("Frame", {
            Name = "SubRows",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            LayoutOrder = 40,
            Parent = element.Instance,
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = subHost,
        })
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 16),
            Parent = subHost,
        })
        local guide = Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 4, 0.5, 0),
            Size = UDim2.fromOffset(2, 0),
            BackgroundColor3 = Theme.White,
            BorderSizePixel = 0,
            Parent = subHost,
        })
        Corner(guide, UDim.new(1, 0))
        Gradient(guide, Theme.Accent, Theme.AccentGold, 90, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.55),
            NumberSequenceKeypoint.new(1, 0),
        }))
        -- garis pemandu mengikuti tinggi konten anak
        element.Registry:Connect(subHost:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            local lay = subHost:FindFirstChildOfClass("UIListLayout")
            local h = lay and lay.AbsoluteContentSize.Y or 0
            guide.Size = UDim2.fromOffset(2, math.max(0, h))
        end)
    end

    --  Proxy "tab" untuk membangun anak di dalam subHost: pabrik elemen
    --  (AddToggle dll.) bekerja normal, tapi kartu anak masuk ke subHost,
    --  tetap terdaftar di Elements/membership section tab asal (filter &
    --  lipatan section tetap berfungsi), dan :Remove() anak juga keluar
    --  dari daftar anak induk.
    local proxy = nil
    local function ensureProxy()
        if proxy then
            return proxy
        end
        proxy = setmetatable({
            Window = tab.Window,
            Container = subHost,
            Elements = tab.Elements,
            Sections = tab.Sections,
            Order = 0,
            FilterQuery = "",
            _parentElement = element,
        }, TabClass)
        function proxy:_track(child)
            table.insert(tab.Elements, child)
            tab:_own(child)
            child._parentElement = element
            table.insert(element.Children, child)
            function child:Remove()
                if self.Children then
                    local kids = {}
                    for _, c in ipairs(self.Children) do
                        kids[#kids + 1] = c
                    end
                    for _, c in ipairs(kids) do
                        if type(c.Remove) == "function" then
                            c:Remove()
                        end
                    end
                end
                unregisterElement(self)
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
                local sec = self.Section
                if sec and sec.Members then
                    for i, m in ipairs(sec.Members) do
                        if m == self then
                            table.remove(sec.Members, i)
                            break
                        end
                    end
                end
                for i, c in ipairs(element.Children) do
                    if c == self then
                        table.remove(element.Children, i)
                        break
                    end
                end
            end
        end
        return proxy
    end

    function element:AddChild(kind, childCfg)
        local k = normalizeChildKind(kind)
        if not k then
            return nil
        end
        buildSubUI()
        local p = ensureProxy()
        p._currentSection = tab._currentSection -- anak ikut section aktif
        local factory = TabClass[CHILD_FACTORIES[k]]
        local child = factory(p, childCfg or {})
        if child then
            child.Instance.LayoutOrder = #element.Children
        end
        return child
    end

    function element:SetExpanded(v)
        if not subHost then
            return
        end
        expanded = v == true
        subHost.Visible = expanded
        local c = expanded and Theme.Accent or Theme.TextDim
        if chevBtn then
            Tween(element.Registry, chevron, TI_HOVER, { Rotation = expanded and 0 or -90 })
            Tween(element.Registry, chevA, TI_HOVER, { BackgroundColor3 = c })
            Tween(element.Registry, chevB, TI_HOVER, { BackgroundColor3 = c })
        end
    end

    function element:ToggleExpanded()
        element:SetExpanded(not expanded)
    end

    function element:IsExpanded()
        return expanded
    end

    --  v2.3.0: Depends — baris ini muncul/hilang otomatis mengikuti sumber
    element.SetDependency = function(_, dep)
        registerDependency(element, dep)
    end
    element.ClearDependency = function(_)
        clearDependency(element)
    end
    if cfg and cfg.Depends then
        registerDependency(element, cfg.Depends)
    end
end

--// ─────────────────────────── Elemen: BUTTON ───────────────────────────────
--  v2.3.0: ConfirmText — klik dua tahap (klik 1 = "siapkan", klik 2 = eksekusi;
--  otomatis batal setelah 2.5 detik) untuk aksi berisiko.
function TabClass:AddButton(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card, stroke = self:_card("TextButton")

    local baseText = tostring(cfg.Name or "Button")
    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Text = baseText,
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        LayoutOrder = 1,
        Parent = card,
    })

    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    cardHover(reg, card, stroke)

    -- mode konfirmasi dua tahap
    local confirmText = cfg.ConfirmText ~= nil and tostring(cfg.ConfirmText)
        or (cfg.Confirm == true and "Yakin?" or nil)
    local armed = false
    local armToken = 0

    local function disarm()
        armed = false
        label.Text = baseText
        label.TextColor3 = Theme.Text
        Tween(reg, stroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.35 })
    end

    local function arm()
        armed = true
        armToken = armToken + 1
        label.Text = confirmText
        label.TextColor3 = Theme.AccentGold
        Tween(reg, stroke, TI_HOVER, { Color = Theme.AccentGold, Transparency = 0 })
        Zap(reg, card, Theme.AccentGold, 10)
        -- batal otomatis setelah 2.5 detik tanpa aktivitas
        local token = armToken
        task.delay(2.5, function()
            if armed and armToken == token and card.Parent then
                disarm()
            end
        end)
    end

    local function fire()
        if cfg.Callback then
            cfg.Callback()
        end
    end

    reg:Connect(card.Activated, function()
        if confirmText then
            if armed then
                disarm()
                Zap(reg, card, Theme.Accent, 10)
                fire()
                return
            end
            arm()
            return
        end
        Zap(reg, card, Theme.Accent, 10)
        fire()
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
            return baseText
        end,
        Set = function(_, name)
            baseText = tostring(name)
            if not armed then
                label.Text = baseText
            end
        end,
        Fire = function(_)
            fire()
        end,
        ResetConfirm = function(_)
            if confirmText and armed then
                disarm()
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, nil, label, "card", 9)
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
    local titleLabel = Create("TextLabel", {
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

    -- v2.3.0: nilai berubah (apa pun sumbernya) → grup radio + pipeline
    -- State/Depends. Dipisah dari callback user supaya :Set silent pun
    -- tetap menyinkronkan tampilan & dependensi.
    local function afterChange()
        syncGroup(element)
        notifyChange(element)
    end

    reg:Connect(card.Activated, function()
        state.Value = not state.Value
        render(false)
        Zap(reg, pill, Theme.AccentGold, UDim.new(1, 0))
        if state.Callback then
            state.Callback(state.Value)
        end
        afterChange()
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
            afterChange()
        end,
    }
    self:_track(element)
    -- v2.3.0: grup eksklusif (radio) — maksimal satu toggle aktif
    if type(cfg.Group) == "table" and cfg.Group.Options then
        element._group = cfg.Group
        table.insert(cfg.Group.Options, element)
        if state.Value then
            syncGroup(element)
        end
    end
    EnableChildren(self, element, cfg, row, titleLabel, "row")
    return element
end

--// ─────────────────────────── Elemen: SLIDER ───────────────────────────────
--  v2.3.0: UNITS multi-satuan + ketik nilai eksak + setter runtime.
--  Nilai internal (state.Value & callback) SELALU dalam satuan dasar;
--  tampilan dikonversi via FromBase/ToBase per satuan.
function TabClass:AddSlider(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card, stroke = self:_card()

    -- ── normalisasi konfigurasi UNITS ──
    --  Shorthand: Units = "m" · Units = { "m", "km" }
    --  Lengkap  : Units = { Options = { {Name="m", Suffix="m"},
    --      {Name="km", Suffix="km", FromBase=fn, ToBase=fn, Decimals=2} },
    --      Default = "km", Callback = fn(namaSatuan) }
    local unitOptions, unitCallback
    do
        local u = cfg.Units
        if type(u) == "string" then
            u = { Options = { u } }
        elseif type(u) == "table" and u.Options == nil and u.List == nil and #u > 0 then
            u = { Options = u }
        end
        if type(u) == "table" then
            unitCallback = type(u.Callback) == "function" and u.Callback or nil
            local rawList = u.Options or u.List
            unitOptions = {}
            if type(rawList) == "table" then
                for _, entry in ipairs(rawList) do
                    if type(entry) == "string" or type(entry) == "number" then
                        table.insert(unitOptions, {
                            Name = tostring(entry), Suffix = tostring(entry),
                        })
                    elseif type(entry) == "table" then
                        local name = tostring(entry.Name or entry.Text or entry.Suffix or "Unit")
                        table.insert(unitOptions, {
                            Name = name,
                            Suffix = entry.Suffix ~= nil and tostring(entry.Suffix) or name,
                            Prefix = entry.Prefix ~= nil and tostring(entry.Prefix) or nil,
                            Format = type(entry.Format) == "function" and entry.Format or nil,
                            FromBase = type(entry.FromBase) == "function" and entry.FromBase or nil,
                            ToBase = type(entry.ToBase) == "function" and entry.ToBase or nil,
                            Decimals = tonumber(entry.Decimals),
                        })
                    end
                end
            end
        end
    end
    local unitCount = unitOptions and #unitOptions or 0
    local currentUnit = nil
    if unitCount > 0 then
        local wanted = (type(cfg.Units) == "table" and cfg.Units.Default ~= nil)
            and tostring(cfg.Units.Default) or ""
        for _, uo in ipairs(unitOptions) do
            if uo.Name == wanted then
                currentUnit = uo
                break
            end
        end
        currentUnit = currentUnit or unitOptions[1]
    end
    local hasChip = unitCount > 1

    local row1 = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 1,
        Parent = card,
    })
    local titleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, hasChip and -130 or -90, 1, 0),
        Text = cfg.Name or "Slider",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row1,
    })
    --  v2.3.0: nilai RichText — ANGKA emas, awalan/satuan redup kebiruan
    local valueLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, hasChip and -38 or 0, 0, 0),
        Size = UDim2.new(0, hasChip and 80 or 90, 1, 0),
        Text = "",
        RichText = true,
        Font = Theme.FontMedium,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row1,
    })

    -- chip pemilih satuan (hanya bila ada >1 satuan)
    local unitChip, chipStroke
    if hasChip then
        unitChip = Create("TextButton", {
            Text = currentUnit.Name,
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(34, 16),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Font = Theme.FontMedium,
            TextSize = 10,
            TextColor3 = Theme.TextDim,
            Parent = row1,
        })
        Corner(unitChip, 4)
        chipStroke = Stroke(unitChip, { Color = Theme.StrokeDim, Transparency = 0.3 })
    end

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
    -- gradien selaras-hue 'kilat menyala' (biru pekat -> biru terang)
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
    Stroke(knob, { Color = Theme.AccentGold, Thickness = 1, Transparency = 0.1 })
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

    local element -- didefinisi di bawah; apply/render merujuk via upvalue

    -- angka dalam SATUAN TAMPILAN saat ini (sudah dikonversi)
    local function displayNumber()
        local v = state.Value
        local u = currentUnit
        if u then
            if u.FromBase then
                v = u.FromBase(v)
            end
            if u.Format then
                return tostring(u.Format(v))
            end
            return formatValue(v, u.Decimals or state.Precision)
        end
        return formatValue(v, state.Precision)
    end

    local function render()
        local span = state.Max - state.Min
        local rel = span > 0 and (state.Value - state.Min) / span or 0
        rel = math.clamp(rel, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        -- angka emas + satuan/awalan redup (RichText)
        local u = currentUnit
        local prefix = (u and u.Prefix) or cfg.Prefix or ""
        local suffix = (u and u.Suffix) or state.Suffix or ""
        local parts = {}
        if prefix ~= "" then
            parts[#parts + 1] = rtColor(Theme.TextDim, prefix)
        end
        parts[#parts + 1] = rtColor(Theme.AccentGold, displayNumber())
        if suffix ~= "" then
            parts[#parts + 1] = rtColor(Theme.TextDim, suffix)
        end
        valueLabel.Text = #parts > 1 and table.concat(parts, " ") or parts[1]
    end

    local function apply(raw, silent)
        local v = tonumber(raw)
        if v == nil then
            return
        end
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
        notifyChange(element)
    end

    -- ── v2.3.0: ketik nilai eksak — klik angka → TextBox ──
    local editBox = Create("TextBox", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, hasChip and -38 or 0, 0, -1),
        Size = UDim2.new(0, hasChip and 80 or 90, 1, 2),
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "angka",
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        Font = Theme.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Right,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 5,
        Parent = row1,
    })
    Corner(editBox, 4)
    local editStroke = Stroke(editBox, { Color = Theme.Accent, Transparency = 0 })
    reg:Connect(editBox.FocusLost, function()
        editBox.Visible = false
        valueLabel.Visible = true
        local n = tonumber(editBox.Text)
        if n then
            local u = currentUnit
            if u and u.ToBase then
                n = u.ToBase(n)
            end
            if math.abs(n - state.Value) > 1e-9 then
                apply(n, false)
            end
        end
    end)
    local valueHit = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, hasChip and -38 or 0, 0, 0),
        Size = UDim2.new(0, hasChip and 80 or 90, 1, 0),
        ZIndex = 4,
        Parent = row1,
    })
    reg:Connect(valueHit.Activated, function()
        if editBox.Visible then
            return
        end
        editBox.Text = displayNumber()
        valueLabel.Visible = false
        editBox.Visible = true
        task.defer(function()
            if editBox.Visible and editBox.Parent then
                editBox:CaptureFocus()
            end
        end)
    end)

    -- ── v2.3.0: daftar pilihan satuan (di dalam kartu, ala dropdown) ──
    local unitHolder
    local unitExpanded = false
    local function setUnit(uo, silent)
        if uo == currentUnit then
            return
        end
        currentUnit = uo
        if unitChip then
            unitChip.Text = uo.Name
        end
        render()
        if silent ~= true and unitCallback then
            unitCallback(uo.Name)
        end
    end
    if hasChip then
        unitHolder = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            LayoutOrder = 4,
            Parent = card,
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = unitHolder,
        })
        for idx, uo in ipairs(unitOptions) do
            local ubtn = Create("TextButton", {
                Text = "",
                AutoButtonColor = false,
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                BorderSizePixel = 0,
                LayoutOrder = idx,
                Parent = unitHolder,
            })
            Corner(ubtn, 6)
            local udot = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.fromOffset(6, 6),
                BackgroundColor3 = Theme.TextDim,
                BackgroundTransparency = 0.6,
                BorderSizePixel = 0,
                Parent = ubtn,
            })
            Corner(udot, UDim.new(1, 0))
            local ulabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Text = uo.Name,
                Font = Theme.FontMain,
                TextSize = 12,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = ubtn,
            })
            local function paintUnit()
                local sel = (uo == currentUnit)
                udot.BackgroundColor3 = sel and Theme.Accent or Theme.TextDim
                udot.BackgroundTransparency = sel and 0 or 0.6
                ulabel.TextColor3 = sel and Theme.Text or Theme.TextDim
            end
            paintUnit()
            reg:Connect(ubtn.MouseEnter, function()
                Tween(reg, ubtn, TI_HOVER, { BackgroundTransparency = 0.6, BackgroundColor3 = Theme.CardHover })
            end)
            reg:Connect(ubtn.MouseLeave, function()
                Tween(reg, ubtn, TI_HOVER, { BackgroundTransparency = 1, BackgroundColor3 = Theme.Card })
            end)
            reg:Connect(ubtn.Activated, function()
                setUnit(uo)
                paintUnit()
                unitExpanded = false
                unitHolder.Visible = false
                if chipStroke then
                    Tween(reg, chipStroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.3 })
                end
                Zap(reg, ubtn, Theme.Accent, 6)
            end)
            -- repainting saat satuan berubah dari jalur lain
            uo._paint = paintUnit
        end
        reg:Connect(unitChip.Activated, function()
            unitExpanded = not unitExpanded
            unitHolder.Visible = unitExpanded
            for _, uo in ipairs(unitOptions) do
                if uo._paint then
                    uo._paint()
                end
            end
            Tween(reg, chipStroke, TI_HOVER, {
                Color = unitExpanded and Theme.Accent or Theme.StrokeDim,
                Transparency = unitExpanded and 0 or 0.3,
            })
            Zap(reg, unitChip, Theme.AccentGold, 4)
        end)
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

    element = {
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
        -- ── v2.3.0: setter runtime ──
        SetDecimals = function(_, n)
            state.Precision = math.max(0, math.floor(tonumber(n) or 0))
            render()
        end,
        SetIncrement = function(_, n)
            state.Increment = tonumber(n)
        end,
        SetRange = function(_, mn, mx)
            state.Min = tonumber(mn) or state.Min
            state.Max = tonumber(mx) or state.Max
            if state.Min > state.Max then
                state.Min, state.Max = state.Max, state.Min
            end
            apply(state.Value, true)
        end,
        SetSuffix = function(_, s)
            state.Suffix = tostring(s or "")
            render()
        end,
        SetUnit = function(_, name)
            local wanted = tostring(name)
            for _, uo in ipairs(unitOptions or {}) do
                if uo.Name == wanted then
                    setUnit(uo)
                    if uo._paint then
                        uo._paint()
                    end
                    return
                end
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, row1, titleLabel, "row")
    return element
end

--// ─────────────────────────── Elemen: DROPDOWN ─────────────────────────────
--  v2.3.0: Search (filter opsi), ApplyButton (mode aksi: pilih lalu terapkan),
--  SetValues/AddValue/RemoveValue (kelola opsi saat runtime).
function TabClass:AddDropdown(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    local multi = cfg.Multi == true
    local state = {
        Value = multi and {} or nil,
        Callback = cfg.Callback,
    }
    local element -- upvalue untuk pipeline notifyChange

    -- mode aksi: pilihan TIDAK langsung menembak callback; tombol "Apply"
    -- yang mengirimkannya (callback(nilai, indeks))
    local applyLabel = nil
    if cfg.ApplyButton then
        applyLabel = (cfg.ApplyButton == true) and "Apply"
            or tostring(cfg.ApplyButton)
    end
    local applyMode = applyLabel ~= nil

    -- header (klik untuk expand/collapse)
    local header = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        LayoutOrder = 1,
        Parent = card,
    })
    local titleLabel = Create("TextLabel", {
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
        BackgroundTransparency = 1, -- tanpa kotak abu di belakang nilai
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
    -- panah DIGAMBAR (2 batang miring) — glyph "▾" dirender Roblox sebagai
    -- KOTAK kosong (tofu) di sebagian perangkat (lihat ChevronIcon)
    local arrow, arrowA, arrowB = ChevronIcon(header, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -1, 0.5, 0),
        Size = 10,
        Color = Theme.TextDim,
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

    -- ── v2.3.0: kotak pencarian opsional di atas daftar opsi ──
    local searchBox
    if cfg.Search == true then
        searchBox = Create("TextBox", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Text = "",
            PlaceholderText = "Cari...",
            PlaceholderColor3 = Theme.TextDim,
            TextSize = 12,
            TextColor3 = Theme.Text,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ClipsDescendants = true,
            LayoutOrder = 0,
            Parent = holder,
        })
        Corner(searchBox, 6)
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = searchBox,
        })
        Stroke(searchBox, { Color = Theme.StrokeDim, Transparency = 0.3 })
    end

    local options = {}
    local expanded = false
    local applyBtn

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

    --  v2.3.0: filter daftar opsi (dipakai search box & :Filter)
    local function filterOptions(query)
        local needle = tostring(query or ""):lower()
        for _, opt in ipairs(options) do
            if opt.Btn then
                if needle == "" then
                    opt.Btn.Visible = true
                else
                    opt.Btn.Visible = string.find(
                        tostring(opt.Value):lower(), needle, 1, true) ~= nil
                end
            end
        end
    end

    local function setExpanded(v)
        expanded = v
        holder.Visible = v
        local c = v and Theme.Accent or Theme.TextDim
        Tween(reg, arrowA, TI_HOVER, { BackgroundColor3 = c })
        Tween(reg, arrowB, TI_HOVER, { BackgroundColor3 = c })
    end

    --  v2.3.0: bangun ulang baris opsi (dipakai saat create & SetValues)
    local function buildOptions(values)
        -- bersihkan baris lama (kecuali search box LayoutOrder 0)
        for _, opt in ipairs(options) do
            if opt.Btn then
                opt.Btn:Destroy()
            end
        end
        options = {}
        if applyBtn then
            applyBtn:Destroy()
            applyBtn = nil
        end

        for _, value in ipairs(values or {}) do
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
                    if not applyMode then
                        if state.Callback then
                            local snapshot = {}
                            for i, v in ipairs(state.Value) do
                                snapshot[i] = v
                            end
                            state.Callback(snapshot)
                        end
                        notifyChange(element)
                    end
                else
                    state.Value = value
                    refresh()
                    updateHeader()
                    if not applyMode then
                        setExpanded(false)
                    end
                    Zap(reg, btn, Theme.Accent, 6)
                    if not applyMode then
                        if state.Callback then
                            state.Callback(state.Value)
                        end
                        notifyChange(element)
                    end
                end
            end)

            table.insert(options, opt)
        end

        -- tombol Apply (mode aksi) di ujung daftar
        if applyMode then
            applyBtn = Create("TextButton", {
                Text = "",
                AutoButtonColor = false,
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                BorderSizePixel = 0,
                LayoutOrder = #options + 1,
                Parent = holder,
            })
            Corner(applyBtn, 6)
            local applyStroke = Stroke(applyBtn, { Color = Theme.Accent, Transparency = 0.4 })
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = applyLabel,
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.Accent,
                Parent = applyBtn,
            })
            reg:Connect(applyBtn.MouseEnter, function()
                Tween(reg, applyBtn, TI_HOVER, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.CardHover })
                Tween(reg, applyStroke, TI_HOVER, { Transparency = 0 })
            end)
            reg:Connect(applyBtn.MouseLeave, function()
                Tween(reg, applyBtn, TI_HOVER, { BackgroundTransparency = 1, BackgroundColor3 = Theme.Card })
                Tween(reg, applyStroke, TI_HOVER, { Transparency = 0.4 })
            end)
            reg:Connect(applyBtn.Activated, function()
                Zap(reg, applyBtn, Theme.AccentGold, 6)
                setExpanded(false)
                if state.Callback then
                    if multi then
                        local snapshot, indices = {}, {}
                        for i, v in ipairs(state.Value) do
                            snapshot[i] = v
                        end
                        for i, opt in ipairs(options) do
                            if contains(state.Value, opt.Value) then
                                indices[#indices + 1] = i
                            end
                        end
                        state.Callback(snapshot, indices)
                    else
                        local idx = nil
                        for i, opt in ipairs(options) do
                            if state.Value == opt.Value then
                                idx = i
                                break
                            end
                        end
                        state.Callback(state.Value, idx)
                    end
                end
                notifyChange(element)
            end)
        end

        filterOptions(searchBox and searchBox.Text or "")
    end

    buildOptions(cfg.Values or {})

    if searchBox then
        reg:Connect(searchBox:GetPropertyChangedSignal("Text"), function()
            filterOptions(searchBox.Text)
        end)
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

    element = {
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
            notifyChange(element)
        end,
        -- ── v2.3.0: kelola opsi saat runtime ──
        SetValues = function(_, values)
            local valid = {}
            for _, v in ipairs(values or {}) do
                valid[#valid + 1] = v
            end
            buildOptions(valid)
            -- buang pilihan yang tidak lagi valid
            if multi then
                local kept = {}
                for _, v in ipairs(state.Value) do
                    if contains(valid, v) then
                        kept[#kept + 1] = v
                    end
                end
                state.Value = kept
            elseif state.Value ~= nil and not contains(valid, state.Value) then
                state.Value = nil
            end
            refresh()
            updateHeader()
        end,
        AddValue = function(_, value)
            for _, opt in ipairs(options) do
                if opt.Value == value then
                    return -- sudah ada
                end
            end
            local list = {}
            for _, opt in ipairs(options) do
                list[#list + 1] = opt.Value
            end
            list[#list + 1] = value
            buildOptions(list)
            refresh()
            updateHeader()
        end,
        RemoveValue = function(_, value)
            local list = {}
            for _, opt in ipairs(options) do
                if opt.Value ~= value then
                    list[#list + 1] = opt.Value
                end
            end
            buildOptions(list)
            if multi then
                removeFrom(state.Value, value)
            elseif state.Value == value then
                state.Value = nil
            end
            refresh()
            updateHeader()
        end,
        Filter = function(_, query)
            if searchBox then
                searchBox.Text = tostring(query or "")
            else
                filterOptions(query)
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, header, titleLabel, "row")
    return element
end
--// ────────────────────────── Elemen: TEXTINPUT ─────────────────────────────
function TabClass:AddTextInput(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    local titleLabel = Create("TextLabel", {
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
        notifyChange(element)
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
            notifyChange(element)
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, nil, titleLabel, "card", 8)
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
    local titleLabel = Create("TextLabel", {
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
            notifyChange(element)
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
        Set = function(_, enumItem, silent)
            if typeof(enumItem) == "EnumItem" or typeof(enumItem) == "EnumItemType" then
                state.Bind = enumItem
                display()
                if silent ~= true and state.Callback then
                    state.Callback(state.Bind, nil)
                end
                notifyChange(element)
            end
        end,
        SetKey = function(_, enumItem)
            if typeof(enumItem) == "EnumItem" then
                state.Bind = enumItem
                display()
                notifyChange(element)
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, row, titleLabel, "row")
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
    local titleLabel = Create("TextLabel", {
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
        notifyChange(element)
    end

    local function updateHue(x)
        local rel = math.clamp((x - hueBar.AbsolutePosition.X) / math.max(hueBar.AbsoluteSize.X, 1), 0, 1)
        state.H = rel
        render()
        if state.Callback then
            state.Callback(currentColor())
        end
        notifyChange(element)
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
                notifyChange(element)
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, header, titleLabel, "row")
    return element
end

--// ─────────────────────────── Elemen: SECTION ──────────────────────────────
--  MENU BISA DI-MINIMIZE — klik judul section untuk menutup/membuka semua
--  fitur di dalamnya (sampai section berikutnya). Panah lipat DIGAMBAR
--  (bukan glyph — v2.2.2) berputar sebagai penanda. Elemen yang dibuat
--  SETELAH AddSection otomatis menjadi anggota menu tersebut (via
--  _own / _track).
--  v2.2.2: section MULAI TERLIPAT saat pertama execute (biar rapi) —
--  beri Collapsed = false untuk membuatnya dalam keadaan TERBUKA.
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
    -- v2.2.2: panah penanda lipatan DIGAMBAR (2 batang miring emas) —
    -- glyph "▾" tampil sebagai KOTAK kosong (tofu) di sebagian perangkat.
    -- Rotasi ikon: 0 = panah bawah (terbuka) ↔ -90 = panah kanan (terlipat)
    local chevron, chevA, chevB = ChevronIcon(row, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -3, 0.5, 0),
        Size = 12,
        Color = Theme.AccentGold,
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
        Collapsed = true, -- v2.2.2: TERLIPAT adalah default awal
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
                    and m._depVisible ~= false -- v2.3.0: hormati Depends
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
            Tween(reg, chevA, TI_HOVER, { BackgroundColor3 = Theme.Text })
            Tween(reg, chevB, TI_HOVER, { BackgroundColor3 = Theme.Text })
        end)
        reg:Connect(row.MouseLeave, function()
            Tween(reg, title, TI_HOVER, { TextColor3 = Theme.AccentGold })
            Tween(reg, chevA, TI_HOVER, { BackgroundColor3 = Theme.AccentGold })
            Tween(reg, chevB, TI_HOVER, { BackgroundColor3 = Theme.AccentGold })
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

    -- v2.2.2: SEMUA section MULAI TERLIPAT saat pertama execute (permintaan:
    -- "semua section di tutup biar rapi"). cfg.Collapsed = false → menu
    -- dibuat dalam keadaan TERBUKA; anggota yang dibuat kemudian tetap
    -- terdaftar ke menu ini dan mengikuti status lipatnya.
    if cfg.Collapsed == false then
        el.Collapsed = false
    else
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

--// ──────────────────── Elemen: LIST (v2.3.0 — browser item) ────────────────
--  Daftar item yang bisa DILACAK (Search), DIKELOMPOKKAN (Groups), dan
--  DIPILIH (klik / Multi). Setiap item boleh punya badge kanan (TopRight),
--  gambar sendiri (Image, rbxassetid milik pengguna — opsional), dan Id.
--      Tab:AddList({ Name = "Inventaris", Search = true, Multi = false,
--          Items = { "Stormbreaker",
--              { Text = "Mjolnir", TopRight = "Legendary" } },
--          OnItemClick = function(item, index, selected) end })
function TabClass:AddList(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()
    local element -- upvalue untuk notifyChange

    local multi = cfg.Multi == true
    local selected = {} -- array item (normalisasi) yang terpilih
    local itemRows = {} -- { {Item, Btn, Dot, Label, Badge, GroupFrame} }
    local maxH = tonumber(cfg.MaxHeight) or 180

    -- ── normalisasi item ──
    local function normalizeItem(item)
        if type(item) == "table" then
            return {
                Text = tostring(item.Text or item.Name or ""),
                TopRight = item.TopRight ~= nil and tostring(item.TopRight) or nil,
                Image = item.Image ~= nil and tostring(item.Image) or nil,
                ImageColor = typeof(item.ImageColor) == "Color3" and item.ImageColor or nil,
                Id = item.Id,
            }
        end
        return { Text = tostring(item) }
    end

    local function itemMatchesSel(it, sel)
        if it == sel then
            return true
        end
        if type(sel) == "table" then
            if sel.Id ~= nil then
                return it.Id == sel.Id
            end
            return it.Text == tostring(sel.Text or sel)
        end
        return it.Text == tostring(sel)
    end

    local function isSelected(it)
        for _, s in ipairs(selected) do
            if itemMatchesSel(it, s) then
                return true
            end
        end
        return false
    end

    -- ── baris judul ──
    local titleRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        LayoutOrder = 1,
        Parent = card,
    })
    local titleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -90, 1, 0),
        Text = cfg.Name or "List",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = titleRow,
    })
    local countLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 90, 1, 0),
        Text = "",
        Font = Theme.FontMain,
        TextSize = 11,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = titleRow,
    })

    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    -- ── kotak pencarian (opsional) ──
    local searchBox
    if cfg.Search == true then
        searchBox = Create("TextBox", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Text = "",
            PlaceholderText = "Cari...",
            PlaceholderColor3 = Theme.TextDim,
            TextSize = 12,
            TextColor3 = Theme.Text,
            Font = Theme.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ClipsDescendants = true,
            LayoutOrder = 3,
            Parent = card,
        })
        Corner(searchBox, 6)
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = searchBox,
        })
        Stroke(searchBox, { Color = Theme.StrokeDim, Transparency = 0.3 })
    end

    -- ── scroll daftar item ──
    local scroll = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        BorderSizePixel = 0,
        LayoutOrder = 5,
        Parent = card,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scroll,
    })
    -- tinggi scroll mengikuti konten (maks maxH) — card ikut memanjang
    reg:Connect(scroll:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        local lay = scroll:FindFirstChildOfClass("UIListLayout")
        local h = lay and lay.AbsoluteContentSize.Y or 0
        scroll.Size = UDim2.new(1, 0, 0, math.clamp(h, 0, maxH))
    end)

    local function updateCount()
        local total = 0
        for _, r in ipairs(itemRows) do
            if not r.IsHeader then
                total = total + 1
            end
        end
        if multi then
            countLabel.Text = #selected .. "/" .. total
        else
            countLabel.Text = (#selected > 0 and selected[1].Text or "...")
        end
    end

    local function paintRow(r)
        -- FIX v2.3.0: baris judul GRUP tidak punya Item — jangan dinilai
        if r.IsHeader or r.Item == nil then
            return
        end
        local sel = isSelected(r.Item)
        if r.Dot then
            r.Dot.BackgroundColor3 = sel and Theme.Accent or Theme.TextDim
            r.Dot.BackgroundTransparency = sel and 0 or 0.6
        end
        if r.Label then
            r.Label.TextColor3 = sel and Theme.Text or Theme.TextDim
        end
        if r.Btn then
            if sel then
                r.Btn.BackgroundColor3 = Theme.CardHover
                r.Btn.BackgroundTransparency = 0.35
            else
                r.Btn.BackgroundColor3 = Theme.Card
                r.Btn.BackgroundTransparency = 1
            end
        end
    end

    local function repaint()
        for _, r in ipairs(itemRows) do
            paintRow(r)
        end
    end

    --  Filter tampilan (dipakai search box & :Filter) — group tanpa anak
    --  yang cocok ikut disembunyikan.
    local function applyFilter(query)
        local needle = tostring(query or ""):lower()
        local groupVisible = {}
        for _, r in ipairs(itemRows) do
            if r.IsHeader then
                r.Btn.Visible = needle == ""
                groupVisible[r.Btn] = false
            else
                local match = needle == ""
                    or string.find(r.Item.Text:lower(), needle, 1, true) ~= nil
                r.Btn.Visible = match
                if match and r.GroupFrame then
                    groupVisible[r.GroupFrame] = true
                end
            end
        end
        for btn, vis in pairs(groupVisible) do
            if needle ~= "" then
                btn.Visible = vis
            end
        end
    end

    local function onItemClick(r)
        local it = r.Item
        if multi then
            -- keluarkan bila sudah terpilih, masukkan bila belum
            for i, s in ipairs(selected) do
                if itemMatchesSel(it, s) then
                    table.remove(selected, i)
                    repaint()
                    updateCount()
                    Zap(reg, r.Btn, Theme.Accent, 6)
                    if cfg.OnItemClick then
                        cfg.OnItemClick(it, r.Index, false)
                    end
                    notifyChange(element)
                    return
                end
            end
            table.insert(selected, it)
        else
            selected = { it }
        end
        repaint()
        updateCount()
        Zap(reg, r.Btn, Theme.Accent, 6)
        if cfg.OnItemClick then
            cfg.OnItemClick(it, r.Index, true)
        end
        notifyChange(element)
    end

    --  Bangun ulang seluruh daftar (dipakai saat create & :SetItems)
    local function buildAll(items, groups)
        for _, r in ipairs(itemRows) do
            if r.Btn then
                r.Btn:Destroy()
            end
        end
        itemRows = {}
        selected = {}
        local order = 0
        local index = 0

        local function addHeader(text)
            order = order + 1
            local h = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Text = tostring(text or ""),
                Font = Theme.FontBold,
                TextSize = 11,
                TextColor3 = Theme.AccentGold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                LayoutOrder = order,
                Parent = scroll,
            })
            itemRows[#itemRows + 1] = { IsHeader = true, Btn = h }
        end

        local function addItem(it)
            order = order + 1
            index = index + 1
            local btn = Create("TextButton", {
                Text = "",
                AutoButtonColor = false,
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                BorderSizePixel = 0,
                LayoutOrder = order,
                Parent = scroll,
            })
            Corner(btn, 6)
            local xOff = 8
            local dot = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.fromOffset(6, 6),
                BackgroundColor3 = Theme.TextDim,
                BackgroundTransparency = 0.6,
                BorderSizePixel = 0,
                Parent = btn,
            })
            Corner(dot, UDim.new(1, 0))
            xOff = 20
            -- gambar opsional milik pengguna (rbxassetid) — ThorUi sendiri
            -- tetap 100% tanpa aset
            if it.Image then
                local img = Create("ImageLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, xOff, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    BackgroundTransparency = 1,
                    Image = it.Image,
                    ImageColor3 = it.ImageColor or Theme.Text,
                    Parent = btn,
                })
                Corner(img, 4)
                xOff = xOff + 24
            end
            local label = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, xOff, 0, 0),
                Size = UDim2.new(1, -xOff - (it.TopRight and 64 or 0), 1, 0),
                Text = it.Text,
                Font = Theme.FontMain,
                TextSize = 12,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = btn,
            })
            if it.TopRight then
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -8, 0, 0),
                    Size = UDim2.new(0, 60, 1, 0),
                    Text = it.TopRight,
                    Font = Theme.FontBold,
                    TextSize = 10,
                    TextColor3 = Theme.AccentGold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = btn,
                })
            end
            reg:Connect(btn.MouseEnter, function()
                Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.CardHover })
            end)
            reg:Connect(btn.MouseLeave, function()
                paintRow({ Item = it, Btn = btn, Dot = dot, Label = label })
            end)
            reg:Connect(btn.Activated, function()
                onItemClick({ Item = it, Btn = btn, Dot = dot, Label = label, Index = index })
            end)
            itemRows[#itemRows + 1] = { Item = it, Btn = btn, Dot = dot, Label = label, Index = index }
        end

        if type(groups) == "table" then
            for _, g in ipairs(groups) do
                if type(g) == "table" then
                    addHeader(g.Title or g.Name or "")
                    local groupBtn = itemRows[#itemRows].Btn
                    for _, raw in ipairs(g.Items or {}) do
                        addItem(normalizeItem(raw))
                        itemRows[#itemRows].GroupFrame = groupBtn
                    end
                end
            end
        else
            for _, raw in ipairs(items or {}) do
                addItem(normalizeItem(raw))
            end
        end

        -- terapkan pilihan awal (Selected)
        if cfg.Selected ~= nil then
            local function markSel(sel)
                for _, r in ipairs(itemRows) do
                    if not r.IsHeader and itemMatchesSel(r.Item, sel) then
                        if multi then
                            local already = false
                            for _, s in ipairs(selected) do
                                if itemMatchesSel(r.Item, s) then
                                    already = true
                                end
                            end
                            if not already then
                                table.insert(selected, r.Item)
                            end
                        else
                            selected = { r.Item }
                        end
                    end
                end
            end
            if multi and type(cfg.Selected) == "table" then
                for _, s in ipairs(cfg.Selected) do
                    markSel(s)
                end
            else
                markSel(cfg.Selected)
            end
        end

        repaint()
        updateCount()
        if searchBox then
            applyFilter(searchBox.Text)
        end
    end

    buildAll(cfg.Items, cfg.Groups)

    if searchBox then
        reg:Connect(searchBox:GetPropertyChangedSignal("Text"), function()
            applyFilter(searchBox.Text)
        end)
    end

    element = {
        Type = "List",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            if multi then
                local copy = {}
                for i, s in ipairs(selected) do
                    copy[i] = s
                end
                return copy
            end
            return selected[1]
        end,
        Set = function(_, sel, silent)
            selected = {}
            local function mark(selOne)
                for _, r in ipairs(itemRows) do
                    if not r.IsHeader and itemMatchesSel(r.Item, selOne) then
                        if multi then
                            selected[#selected + 1] = r.Item
                        else
                            selected = { r.Item }
                        end
                    end
                end
            end
            if multi and type(sel) == "table" then
                for _, s in ipairs(sel) do
                    mark(s)
                end
            elseif sel ~= nil then
                mark(sel)
            end
            repaint()
            updateCount()
            if silent ~= true and cfg.OnItemClick then
                cfg.OnItemClick(element.Get and element:Get(), nil, true)
            end
            notifyChange(element)
        end,
        SetItems = function(_, items, groups)
            buildAll(items, groups)
            notifyChange(element)
        end,
        Clear = function(_)
            selected = {}
            repaint()
            updateCount()
        end,
        Filter = function(_, query)
            if searchBox then
                searchBox.Text = tostring(query or "")
            else
                applyFilter(query)
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, titleRow, titleLabel, "row")
    return element
end

--// ─────────────── Elemen: MODELVIEW (v2.3.0 — etalase 3D) ──────────────────
--  ViewportFrame untuk memajangkan Model/Part 3D langsung di dalam UI.
--  Kamera otomatis membingkai objek + opsi putar (Spin). Tanpa model yang
--  diberikan, etalase menampilkan palu petir geometris BAWAAN (murni Part —
--  tetap nol aset gambar).
--      Tab:AddModelView({ Name = "Palu", Model = someModel, Spin = true })
function TabClass:AddModelView(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    local height = math.clamp(tonumber(cfg.Height) or 150, 90, 400)
    local spinEnabled = cfg.Spin ~= false

    local titleRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 1,
        Parent = card,
    })
    local titleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -90, 1, 0),
        Text = cfg.Name or "Model",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = titleRow,
    })
    local spinBtn = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(64, 16),
        Font = Theme.FontBold,
        TextSize = 10,
        TextColor3 = Theme.TextDim,
        Text = spinEnabled and "SPIN ON" or "SPIN OFF",
        Parent = titleRow,
    })

    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    local vp = Create("ViewportFrame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        LayoutOrder = 3,
        Ambient = Color3.fromRGB(70, 78, 100),
        LightColor = Color3.fromRGB(255, 240, 200),
        LightDirection = Vector3.new(-0.6, -1, -0.8),
        Parent = card,
    })
    Corner(vp, 8)
    Stroke(vp, { Color = Theme.StrokeDim, Transparency = 0.35 })
    local camera = Instance.new("Camera")
    camera.FieldOfView = 45
    camera.Parent = vp
    vp.CurrentCamera = camera

    --  Bersihkan klon dari efek/scripts/suara; jangkar semua part.
    local function cleanClone(inst)
        local ok, copy = pcall(function()
            return inst:Clone()
        end)
        if not ok or not copy then
            return nil
        end
        for _, d in ipairs(copy:GetDescendants()) do
            if d:IsA("LuaSourceContainer")
                or d:IsA("ParticleEmitter")
                or d:IsA("Trail")
                or d:IsA("Beam")
                or d:IsA("Light")
                or d:IsA("Sound")
                or d:IsA("Fire")
                or d:IsA("Smoke")
                or d:IsA("Sparkles") then
                d:Destroy()
            elseif d:IsA("BasePart") then
                d.Anchored = true
                d.CanCollide = false
                d.CastShadow = false
            end
        end
        if copy:IsA("BasePart") then
            copy.Anchored = true
            copy.CanCollide = false
            copy.CastShadow = false
        end
        return copy
    end

    --  Bingkai kamera agar objek selalu pas di tengah viewport.
    local function frameCamera(shown)
        local size
        local center
        if shown:IsA("Model") then
            local cf, sz = nil, nil
            local ok = pcall(function()
                cf, sz = shown:GetBoundingBox()
            end)
            if ok and cf then
                center, size = cf.Position, sz
            end
        end
        if not center then
            -- Part tunggal / fallback: pakai ukuran & posisi langsung
            size = shown:IsA("BasePart") and shown.Size or Vector3.new(4, 4, 4)
            center = shown:IsA("BasePart") and shown.Position or Vector3.zero
        end
        local dist = math.max(size.X, size.Y, size.Z) * 2.1 + 2
        camera.CFrame = CFrame.lookAt(
            center + Vector3.new(0, size.Y * 0.3, dist),
            center
        )
    end

    local currentModel = nil

    local function setModel(inst)
        for _, child in ipairs(vp:GetChildren()) do
            if child ~= camera then
                child:Destroy()
            end
        end
        if typeof(inst) ~= "Instance" then
            currentModel = nil
            return
        end
        local shown = inst
        if not inst:IsDescendantOf(vp) then
            shown = cleanClone(inst) or inst
        end
        shown.Parent = vp
        currentModel = shown
        frameCamera(shown)
    end

    -- ── palu petir geometris bawaan (nol aset — murni Part box);
    --    v2.3.1: warna SENADA LOGO THORHUB — kepala emas + gagang biru ──
    local function buildDefaultMjolnir()
        local m = Instance.new("Model")
        m.Name = "Mjolnir"
        local function part(size, color, material, pos)
            local p = Instance.new("Part")
            p.Size = size
            p.Color = color
            p.Material = material
            p.Anchored = true
            p.CanCollide = false
            p.CastShadow = false
            p.CFrame = CFrame.new(pos)
            p.Parent = m
            return p
        end
        local gold      = Color3.fromRGB(251, 191, 36)  -- kepala (persis logo)
        local goldDeep  = Color3.fromRGB(180, 83, 9)    -- plat pengikat kepala
        local blue      = Color3.fromRGB(37, 99, 235)   -- gagang (persis logo)
        local blueLight = Color3.fromRGB(147, 197, 253) -- balutan gagang
        -- kepala palu emas
        part(Vector3.new(0.9, 1.5, 1.5), gold, Enum.Material.Metal, Vector3.new(0, 2.55, 0))
        part(Vector3.new(0.5, 1.62, 1.62), gold, Enum.Material.Metal, Vector3.new(0, 2.55, 0))
        -- plat emas tua pengikat atas & bawah kepala
        part(Vector3.new(0.96, 0.18, 1.56), goldDeep, Enum.Material.Metal, Vector3.new(0, 3.22, 0))
        part(Vector3.new(0.96, 0.18, 1.56), goldDeep, Enum.Material.Metal, Vector3.new(0, 1.88, 0))
        -- gagang biru + balutan biru muda
        part(Vector3.new(0.42, 1.9, 0.42), blue, Enum.Material.Metal, Vector3.new(0, 1.0, 0))
        part(Vector3.new(0.5, 0.14, 0.5), blueLight, Enum.Material.Metal, Vector3.new(0, 1.85, 0))
        part(Vector3.new(0.5, 0.14, 0.5), blueLight, Enum.Material.Metal, Vector3.new(0, 0.28, 0))
        -- pommel emas
        part(Vector3.new(0.56, 0.3, 0.56), gold, Enum.Material.Metal, Vector3.new(0, 0.06, 0))
        return m
    end

    setModel(cfg.Model or buildDefaultMjolnir())

    -- rotasi halus (bisa dimatikan)
    local spinConn
    local function startSpin()
        if spinConn then
            return
        end
        spinConn = reg:Connect(RunService.Heartbeat, function(dt)
            if currentModel then
                currentModel:PivotTo(
                    currentModel:GetPivot() * CFrame.Angles(0, math.rad(42 * dt), 0)
                )
            end
        end)
    end
    local function stopSpin()
        if spinConn then
            spinConn:Disconnect()
            reg:Disconnect(spinConn)
            spinConn = nil
        end
    end

    reg:Connect(spinBtn.Activated, function()
        spinEnabled = not spinEnabled
        spinBtn.Text = spinEnabled and "SPIN ON" or "SPIN OFF"
        spinBtn.TextColor3 = spinEnabled and Theme.Accent or Theme.TextDim
        if spinEnabled then
            startSpin()
        else
            stopSpin()
        end
        Zap(reg, spinBtn, Theme.AccentGold, 4)
    end)
    if spinEnabled then
        spinBtn.TextColor3 = Theme.Accent
        startSpin()
    end

    local element = {
        Type = "ModelView",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_)
            return currentModel
        end,
        Set = function(_, inst)
            setModel(inst)
        end,
        SetModel = function(_, inst)
            setModel(inst)
        end,
        SetSpin = function(_, on)
            spinEnabled = on == true
            spinBtn.Text = spinEnabled and "SPIN ON" or "SPIN OFF"
            spinBtn.TextColor3 = spinEnabled and Theme.Accent or Theme.TextDim
            if spinEnabled then
                startSpin()
            else
                stopSpin()
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, titleRow, titleLabel, "row")
    return element
end

--// ─────────────── Elemen: CANVAS (v2.3.0 — dashboard deklaratif) ───────────
--  Widget mini-dashboard yang dideklarasikan lewat tabel — baris teks
--  (label + nilai), bar progress, tombol, dan pemisah — semuanya bisa
--  diperbarui saat runtime lewat :Set(nama, props).
--      local dash = Tab:AddCanvas({ Name = "Statistik", Widgets = {
--          { Type = "Text", Name = "kills", Text = "Kills", Value = "0" },
--          { Type = "Bar",  Name = "hp",    Text = "Health", Value = 1 },
--          { Type = "Button", Name = "rejoin", Text = "Rejoin", Callback = fn },
--      } })
--      dash:Set("kills", { Value = "128" })
function TabClass:AddCanvas(cfg)
    cfg = cfg or {}
    local reg = Registry.new()
    local card = self:_card()

    local titleRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 1,
        Parent = card,
    })
    local titleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = cfg.Name or "Canvas",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = titleRow,
    })

    local setDesc = attachDescription(card, 2)
    setDesc(cfg.Description)

    local body = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 3,
        Parent = card,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = body,
    })

    local handles = {}
    local order = 0

    local function buildWidget(w)
        order = order + 1
        local wtype = string.lower(tostring(w.Type or "text"))
        local name = tostring(w.Name or wtype .. order)

        if wtype == "text" then
            local row = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                LayoutOrder = order,
                Parent = body,
            })
            local lbl = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -90, 1, 0),
                Text = tostring(w.Text or name),
                Font = Theme.FontMain,
                TextSize = 12,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = row,
            })
            local val = Create("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 90, 1, 0),
                Text = tostring(w.Value or ""),
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.AccentGold,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = row,
            })
            handles[name] = {
                Type = "Text",
                Set = function(props)
                    if props.Text ~= nil then
                        lbl.Text = tostring(props.Text)
                    end
                    if props.Value ~= nil then
                        val.Text = tostring(props.Value)
                    end
                end,
                Get = function()
                    return { Text = lbl.Text, Value = val.Text }
                end,
            }

        elseif wtype == "bar" then
            local row = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 24),
                LayoutOrder = order,
                Parent = body,
            })
            local lbl = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.38, -6, 1, 0),
                Text = tostring(w.Text or name),
                Font = Theme.FontMain,
                TextSize = 12,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = row,
            })
            local barTrack = Create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0.62, 0, 6, 0),
                BackgroundColor3 = Theme.Track,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(barTrack, UDim.new(1, 0))
            local barFill = Create("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Theme.White, -- PUTIH → gradien murni
                BorderSizePixel = 0,
                Parent = barTrack,
            })
            Corner(barFill, UDim.new(1, 0))
            Gradient(barFill, Color3.fromRGB(0, 170, 235), Color3.fromRGB(90, 220, 255), 90)
            local function setBar(v)
                local rel = math.clamp(tonumber(v) or 0, 0, 1)
                barFill.Size = UDim2.new(rel, 0, 1, 0)
            end
            setBar(w.Value)
            handles[name] = {
                Type = "Bar",
                Set = function(props)
                    if props.Text ~= nil then
                        lbl.Text = tostring(props.Text)
                    end
                    if props.Value ~= nil then
                        setBar(props.Value)
                    end
                    if typeof(props.Color) == "Color3" then
                        barFill.BackgroundColor3 = props.Color
                    end
                end,
                Get = function()
                    return { Text = lbl.Text, Value = barFill.Size.X.Scale }
                end,
            }

        elseif wtype == "button" then
            local btn = Create("TextButton", {
                Text = "",
                AutoButtonColor = false,
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                BorderSizePixel = 0,
                LayoutOrder = order,
                Parent = body,
            })
            Corner(btn, 6)
            local bStroke = Stroke(btn, { Color = Theme.Accent, Transparency = 0.4 })
            local bLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = tostring(w.Text or name),
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.Accent,
                Parent = btn,
            })
            reg:Connect(btn.MouseEnter, function()
                Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.CardHover })
                Tween(reg, bStroke, TI_HOVER, { Transparency = 0 })
            end)
            reg:Connect(btn.MouseLeave, function()
                Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 1, BackgroundColor3 = Theme.Card })
                Tween(reg, bStroke, TI_HOVER, { Transparency = 0.4 })
            end)
            reg:Connect(btn.Activated, function()
                Zap(reg, btn, Theme.AccentGold, 6)
                if type(w.Callback) == "function" then
                    w.Callback()
                end
            end)
            handles[name] = {
                Type = "Button",
                Set = function(props)
                    if props.Text ~= nil then
                        bLabel.Text = tostring(props.Text)
                    end
                end,
                Get = function()
                    return { Text = bLabel.Text }
                end,
                Fire = function()
                    if type(w.Callback) == "function" then
                        w.Callback()
                    end
                end,
            }

        elseif wtype == "divider" then
            local line = Create("Frame", {
                BackgroundColor3 = Theme.White,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1),
                LayoutOrder = order,
                Parent = body,
            })
            Gradient(line, Theme.AccentGold, Theme.Accent, 0, NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.85),
            }))
            handles[name] = {
                Type = "Divider",
                Set = function() end,
                Get = function()
                    return {}
                end,
            }
        end
    end

    for _, w in ipairs(cfg.Widgets or {}) do
        buildWidget(w)
    end

    local element = {
        Type = "Canvas",
        Name = cfg.Name,
        Instance = card,
        Registry = reg,
        SetDescription = function(_, t)
            setDesc(t)
        end,
        Get = function(_, name)
            local h = handles[tostring(name or "")]
            return h and h.Get and h.Get() or nil
        end,
        Set = function(_, name, props)
            local h = handles[tostring(name or "")]
            if h and h.Set then
                h.Set(props or {})
            end
        end,
        AddWidget = function(_, w)
            buildWidget(w)
        end,
        Fire = function(_, name)
            local h = handles[tostring(name or "")]
            if h and h.Fire then
                h.Fire()
            end
        end,
    }
    self:_track(element)
    EnableChildren(self, element, cfg, titleRow, titleLabel, "row")
    return element
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
    -- v2.2.3: margin auto-clamp diperlebar 20 → 56 px — window di layar kecil
    -- pun tetap punya ruang napas dari tepi layar (tidak menempel/terpotong).
    local minSize = cfg.MinSize or Vector2.new(400, 250)
    minSize = Vector2.new(
        math.min(minSize.X, math.max(viewport.X - 56, 220)),
        math.min(minSize.Y, math.max(viewport.Y - 56, 160))
    )

    -- v2.2.3: ukuran default RADA PERSEGU + DIJAMIN MUAT di layar apa pun
    -- perangkatnya — dihitung murni dari DIMENSI viewport aktual, bukan lagi
    -- dari deteksi MouseEnabled (sebagian Android/emulator/executor
    -- melaporkan MouseEnabled = true walau perangkat tanpa mouse → dulu
    -- salah mengambil default PC 540px yang LEBIH LEBAR dari layar HP →
    -- window tampak "langsung terpotong" di kedua sisi padahal belum
    -- diseret ke tepi layar).
    --   • lebar  : terkecil dari 440px / 86% lebar layar / 62% tinggi layar
    --   • tinggi : terkecil dari 390px / 62% tinggi layar / 1.15x lebar
    --   → rasio akhir selalu 1:1 s.d. 1.15:1 (rada persegu) DAN selalu
    --     menyisakan margin terlihat di semua sisi layar.
    local size = cfg.Size
    if not size then
        local w = math.min(440, viewport.X * 0.86, viewport.Y * 0.62)
        local h = math.min(390, viewport.Y * 0.62, w * 1.15)
        w = math.min(w, viewport.X - 24)
        h = math.min(h, viewport.Y - 24)
        size = UDim2.fromOffset(math.floor(w + 0.5), math.floor(h + 0.5))
    end

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
    -- v2.3.1: logo palu ThorHub geometris (atau logo custom via cfg.Logo /
    -- ThorUi:SetLogo) — presisi di tengah baris, tanpa nudge glyph emoji.
    -- cfg.Logo MENIMPA config global sepenuhnya (termasuk Size) supaya
    -- ukuran render (MakeLogo) dan offset teks selalu KONSISTEN.
    local effLogo = cfg.Logo or _state.Logo
    local logoSize = tonumber(effLogo and effLogo.Size) or 22
    local logoMark = MakeLogo(logoRow, {
        Size = 22,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 12 + logoSize / 2, 0.5, 0),
    }, effLogo)
    local logoText = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12 + logoSize + 6, 0, 0),
        Size = UDim2.new(1, -(logoSize + 26), 1, 0),
        Text = cfg.Title or "ThorHub",
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
        LogoMark = logoMark,
        LogoText = logoText,
        _logoSize = logoSize,
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
            local vp = GetViewport()
            -- v2.2.2: drag SEPENUHNYA BEBAS — TANPA BATAS (permintaan user:
            -- "tidak ada batas ketika geser ke kiri kanan"). Window boleh
            -- dibawa keluar layar ke kiri/kanan/atas/bawah; tidak akan
            -- hilang selamanya — Window:Show() menariknya balik ke layar.
            frame.Position = UDim2.new(
                0, startPos.X.Scale * vp.X + startPos.X.Offset + delta.X,
                0, startPos.Y.Scale * vp.Y + startPos.Y.Offset + delta.Y
            )
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
        end, { Logo = cfg.Logo, Title = cfg.Title })
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
    -- v2.2.2: window boleh digeser BEBAS keluar layar (drag tanpa batas).
    -- Saat DIMUNCULKAN kembali (tombol ⚡ / keybind), tarik balik ke dalam
    -- layar — minimal 56px sisi kiri/kanan & 30px baris judul terlihat —
    -- agar window tidak "hilang" selamanya.
    local f = self.Frame
    local size = f.AbsoluteSize
    if size.X > 0 and size.Y > 0 then
        local vp = GetViewport()
        local center = Vector2.new(
            f.Position.X.Scale * vp.X + f.Position.X.Offset,
            f.Position.Y.Scale * vp.Y + f.Position.Y.Offset
        )
        local loX = 56 - size.X * 0.5
        local hiX = math.max(loX, vp.X - 56 + size.X * 0.5)
        local loY = 30 - size.Y * 0.5
        local hiY = math.max(loY, vp.Y - 30 + size.Y * 0.5)
        f.Position = UDim2.new(
            0, math.clamp(center.X, loX, hiX),
            0, math.clamp(center.Y, loY, hiY)
        )
    end
    f.Visible = true
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

--  Sidebar responsif: window sempit (< 430px) → icon-only (lebar 48px).
--  v2.2.3: ambang diturunkan 520 → 430 — default persegu 440px tetap
--  menampilkan NAMA tab; hanya layar benar-benar sempit (hp portrait)
--  yang otomatis icon-only.
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
    local narrow = width < 430
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
    -- v2.3.1: logo palu/custom ikut ke TENGAH saat sidebar icon-only
    -- (pola penempatan ikon tab v2.1.1)
    self.LogoMark.Position = narrow
        and UDim2.new(0.5, 0, 0.5, 0)
        or UDim2.new(0, 12 + (self._logoSize or 22) / 2, 0.5, 0)
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
    _state.QuickDock = nil -- v2.3.0: deret quick action ikut hancur bersama Gui
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
        -- ThorUi:SetTheme({ Accent = Color3.fromRGB(170, 90, 255),
        --                    AccentGold = Color3.fromRGB(255, 200, 60) })

        -- (Opsional) pasang LOGO SENDIRI — pengguna library bisa mengganti
        -- palu ThorHub bawaan (v2.3.1). Berlaku di splash + sidebar +
        -- tombol melayang; atau per-window: CreateWindow({ Logo = {...} }):
        -- ThorUi:SetLogo({ Image = "rbxassetid://123456789", Size = 26 })

        local Window = ThorUi:CreateWindow({
                Title   = "ThorHub ⚡",
                Size    = UDim2.new(0, 440, 0, 390),  -- v2.2.3: default rada persegu; kosongkan agar otomatis responsif + SELALU muat di layar
                MinSize = Vector2.new(400, 250),       -- batas minimal saat resize
                Keybind = Enum.KeyCode.RightControl,  -- toggle buka/tutup UI (PC)
                Splash = true,                        -- splash screen (default: window pertama)
                -- ShowToggle = false,                 -- sembunyikan tombol ⚡ melayang
        })

        local Tab  = Window:CreateTab({ Name = "Main",  Icon = "⚡" })
        local Tab2 = Window:CreateTab({ Name = "Info",  Icon = "🌩" })

        -- v2.2.2: SEMUA section (menu) MULAI TERLIPAT saat pertama execute
        -- biar daftar rapi — klik judulnya untuk membuka; atau beri
        -- Collapsed = false agar menu ini mulai TERBUKA:
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

        -- v2.3.0: SUB-ROW — toggle ini punya ANAK (buka panah kecil di kiri)
        local speedToggle = Tab:AddToggle({
                Name = "Speed Hack",
                Default = false,
                Callback = function(v) print("Speed Hack:", v) end,
        })
        speedToggle:AddChild("Slider", {
                Name = "Nilai Speed",
                Min = 16, Max = 500, Default = 16, Suffix = " spd",
                Callback = function(v) print("Speed:", v) end,
        })
        speedToggle:AddChild("Toggle", {
                Name = "Saat Lompat Juga",
                Default = true,
                Callback = function(v) print("Jump boost:", v) end,
        })

        -- v2.3.0: DEPENDS — slider ini HANYA tampil saat God Mode ON
        local regenSlider = Tab:AddSlider({
                Name = "Regen / detik",
                Min = 0, Max = 100, Default = 10,
                Depends = { Element = godMode, Value = true },
                Callback = function(v) print("Regen:", v) end,
        })

        -- v2.3.0: STATE + BINDING — 2 slider berbagi SATU nilai (0..100):
        -- geser salah satu, yang lain ikut
        local st = ThorUi:CreateState({
                Name = "PowerLevel", Default = 50,
                Callback = function(v) print("Power:", v) end,
        })
        local s1 = Tab:AddSlider({ Name = "Power (A)", Min = 0, Max = 100, Default = 50 })
        local s2 = Tab:AddSlider({ Name = "Power (B)", Min = 0, Max = 100, Default = 50 })
        st:Bind(s1)
        st:Bind(s2)

        -- v2.3.0: SLIDER UNITS — konversi m ↔ km otomatis (nilai internal
        -- selalu meter); klik ANGKA untuk mengetik nilai eksak
        Tab:AddSlider({
                Name = "Jarak Serangan",
                Min = 0, Max = 10000, Default = 1000,
                Units = {
                        Default = "m",
                        Options = {
                                { Name = "m",  Suffix = "m" },
                                { Name = "km", Suffix = "km", Decimals = 2,
                                  FromBase = function(m) return m / 1000 end,
                                  ToBase   = function(km) return km * 1000 end },
                        },
                },
                Callback = function(m) print("Jarak (meter):", m) end,
        })

        -- v2.3.0: BUTTON dua tahap (ConfirmText)
        Tab:AddButton({
                Name = "Reset Progress",
                ConfirmText = "Yakin? Klik lagi!",
                Callback = function() print("Progress direset!") end,
        })

        -- v2.3.0: DROPDOWN + Search + ApplyButton
        Tab:AddDropdown({
                Name = "Target Farm",
                Values = { "Mob Perum", "Mob Kuil", "Boss Petir", "Boss Es", "Mini Boss" },
                Multi = true, Search = true, ApplyButton = "Terapkan",
                Callback = function(values, indices)
                        print("Farm:", table.concat(values, ", "))
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
        -- melipat semua fitur di dalamnya (panah lipat berputar).
        -- v2.2.2: TERLIPAT kini default — Collapsed = false untuk terbuka:
        local menuLanjutan = Tab:AddSection({
                Name = "MENU LANJUTAN (klik untuk minimize)",
                Collapsed = true, -- eksplisit (sama dengan default v2.2.2)
        })
        Tab:AddLabel({ Text = "Menu ini dibuat TERLIPAT — klik judulnya untuk membuka." })

        -- ── v2.3.0: WIDGET BARU ──

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
                        print("Pilih:", item.Text, "→", selected)
                end,
        })

        -- MODELVIEW: etalase 3D (tanpa model → palu petir bawaan, murni Part)
        local palu = Tab:AddModelView({ Name = "Etalase", Height = 150, Spin = true })
        -- palu:SetModel(workspace.SomeModel)  → ganti objek kapan pun

        -- CANVAS: dashboard mini + update runtime
        local dash = Tab:AddCanvas({
                Name = "Statistik",
                Widgets = {
                        { Type = "Text", Name = "kills", Text = "Kills", Value = "0" },
                        { Type = "Bar",  Name = "hp",    Text = "Health", Value = 1 },
                        { Type = "Button", Name = "rejoin", Text = "Rejoin",
                          Callback = function() print("rejoin!") end },
                },
        })
        -- dash:Set("kills", { Value = "128" })  → update dari script

        -- GROUP (radio): maksimal satu mode aktif
        local modeGroup = ThorUi:CreateGroup({ Name = "Mode Aim" })
        Tab:AddToggle({ Name = "Aim: Kepala", Group = modeGroup, Default = true })
        Tab:AddToggle({ Name = "Aim: Dada",   Group = modeGroup })
        Tab:AddToggle({ Name = "Aim: Kaki",   Group = modeGroup })

        -- QUICK ACTION: tombol melayang yang bisa digeser
        ThorUi:AddQuickAction({
                Icon = "⚡", Name = "Sambar Sekarang",
                Callback = function() print("ZAP!") end,
        })

        Tab2:AddParagraph({
                Title = "Tentang ThorHub v2.3",
                Text = "UI library Dewa Petir: sidebar tab ber-ikon, search bar, "
                        .. "splash screen, ColorPicker, Confirm dialog, section yang "
                        .. "bisa di-minimize, PLUS v2.3: State binding antar-elemen, "
                        .. "Depends (baris otomatis muncul/sembunyi), sub-row AddChild, "
                        .. "slider multi-satuan, List browser item, etalase 3D "
                        .. "ModelView, dashboard Canvas, grup radio, dan quick "
                        .. "action melayang.",
        })

        ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "Script berhasil dimuat!", Duration = 3 })

        -- Kontrol programatik:
        -- godMode:Set(true)         → set nilai + panggil callback
        -- godMode:Set(true, false)  → set nilai TANPA callback
        -- godMode:Get()             → ambil nilai
        -- godMode:SetDescription("teks keterangan baru")
        -- menuLanjutan:Toggle()  → minimize/buka menu dari script
        -- menuLanjutan:SetCollapsed(false) → buka paksa
        -- speedToggle:SetExpanded(true)  → buka anak2 sub-row dari script
        -- regenSlider:SetDependency({ Element = godMode, Value = true })
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
