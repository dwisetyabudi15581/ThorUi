--════════════════════════════════════════════════════════════════════════════
--  ⚡  ThorUi — Roblox UI Library bertema Dewa Petir (Thor / Petir)
--  ──────────────────────────────────────────────────────────────────────────
--  Versi     : 1.0.0   (ModuleScript tunggal, tanpa dependensi eksternal)
--  Platform  : PC & Mobile — draggable, resizable, cross-platform
--
--  FITUR
--  • Tema Lightning & Thunder : Midnight Blue + Electric Blue / Lightning Gold
--  • Animasi snappy ala kilat : TweenService (Back / Quart / Quad, cepat)
--  • Glow sederhana           : UIGradient + layer transparan + stroke neon
--  • Window draggable         : Mouse & Touch via UserInputService
--  • Window resizable         : drag-handle di sudut kanan-bawah window
--  • UISizeConstraint         : ukuran minimal (default 400 x 250)
--  • Floating toggle ⚡        : bisa digeser + snap otomatis ke tepi layar
--  • Keybind toggle UI        : default RightControl (bisa diganti)
--  • Tab system               : ScrollingFrame + AutomaticCanvasSize
--  • Komponen                 : Button, Toggle, Slider, Dropdown, TextInput,
--                               Keybind, Section, Label, Paragraph, Notify
--  • 100% murni script        : Instance.new / UICorner / UIStroke — tanpa
--                               Asset ID gambar sama sekali (anti banned asset)
--  • Anti memory-leak         : semua connection & tween masuk garbage table
--                               (Registry), otomatis di-Clean saat Destroy
--
--  RINGKASAN API
--  ──────────────────────────────────────────────────────────────────────────
--  ThorUi:CreateWindow({Title, Size, MinSize, Position, Keybind, ShowToggle})
--  ThorUi:Notify({Title, Content, Duration, Icon})
--  ThorUi:SetKeybind(Enum.KeyCode.X)    ThorUi:Toggle()    ThorUi:Destroy()
--  ThorUi:SetToggleVisible(bool)
--
--  Window:CreateTab({Name, Icon})        Window:Show()/Hide()/Toggle()
--  Window:SetCollapsed(bool)             Window:Destroy()
--  Window:SetKeybind(Enum.KeyCode.X)
--
--  Tab:AddButton({Name, Callback})
--  Tab:AddToggle({Name, Default, Callback})              :Set(bool) / :Get()
--  Tab:AddSlider({Name, Min, Max, Default, Increment, Precision, Suffix, Callback})
--  Tab:AddDropdown({Name, Values, Default, Multi, Callback})
--  Tab:AddTextInput({Name, Text, Placeholder, ClearOnFocus, Callback(text, enter)})
--  Tab:AddKeybind({Name, Default, Callback})             :SetKey(enum) / :Get()
--  Tab:AddSection({Name})   Tab:AddLabel({Text})   Tab:AddParagraph({Title, Text})
--  Element:Set(...)         Element:Get()          Element:Remove()
--
--  Catatan: ubah warna di ThorUi.Theme SEBELUM CreateWindow untuk custom tema.
--  Contoh implementasi lengkap ada di BLOK PALING BAWAH file ini.
--════════════════════════════════════════════════════════════════════════════

--// ───────────────────────────── Services ──────────────────────────────────
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

--// ─────────────────────────────── Library ──────────────────────────────────
local ThorUi = {
    Version = "1.0.0",
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
local TI_SNAP   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_STRIKE = TweenInfo.new(0.28, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
local TI_EXIT   = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

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

function Registry:Track(tween)
    table.insert(self._tweens, tween)
    return tween
end

function Registry:Clean()
    for _, conn in ipairs(self._conns) do
        if conn.Connected then
            pcall(function()
                conn:Disconnect()
            end)
        end
    end
    for _, tween in ipairs(self._tweens) do
        pcall(function()
            tween:Cancel()
        end)
    end
    self._conns = {}
    self._tweens = {}
end

--// ───────────────────────── Helper inti (murni script) ─────────────────────
--  Instance builder: properti dipasang dulu, Parent paling akhir.
local function Create(className, props)
    local inst = Instance.new(className)
    if props then
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
    tween.Completed:Connect(function()
        flash:Destroy()
    end)
end

--  Efek hover standar untuk card interaktif (stroke neon menyala).
local function cardHover(registry, card, stroke)
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
}

local TOGGLE_SIZE = 48

--// ─────────────────── Parenting (CoreGui → PlayerGui) ──────────────────────
local function ensureGui()
    if _state.Gui and _state.Gui.Parent then
        return _state.Gui
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
    Corner(notif, 8)
    Stroke(notif, { Color = Theme.Stroke, Transparency = 0.3 })

    -- bar petir di sisi kiri
    local bar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = Theme.Accent,
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
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
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
    local anyVisible = false
    for _, w in ipairs(_state.Windows) do
        if w.Frame.Visible then
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

--// ────────────────── Tombol melayang ⚡ (drag + snap tepi) ──────────────────
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
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0.72, 0),
        Size = UDim2.fromOffset(TOGGLE_SIZE, TOGGLE_SIZE),
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        Visible = _state.ToggleVisible,
        Parent = gui,
    })
    Corner(btn, UDim.new(1, 0))
    Gradient(btn, Theme.Card, Theme.BackgroundAlt, 45)
    Stroke(btn, { Color = Theme.Accent, Thickness = 1.5, Transparency = 0.1 })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "⚡",
        Font = Theme.FontBold,
        TextSize = 24,
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
        t1.Completed:Connect(function(playback)
            if playback == Enum.PlaybackState.Completed and btn.Parent then
                Tween(reg, scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
            end
        end)
    end

    -- drag + snap + klik (responsif mouse & sentuhan)
    local dragging = false
    local moved = false
    local startInput = nil
    local startPos = nil

    reg:Connect(btn.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            startInput = input
            startPos = btn.Position
        end
    end)

    reg:Connect(UserInputService.InputChanged, function(input)
        if dragging and (input == startInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - startInput.Position
            if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
                moved = true
            end
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    reg:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if not dragging then
            return
        end
        dragging = false
        if moved then
            -- snap ke tepi kiri/kanan terdekat
            local vp = GetViewport()
            local abs = btn.AbsolutePosition
            local y = math.clamp(abs.Y, 8, math.max(8, vp.Y - TOGGLE_SIZE - 8))
            local target
            if abs.X + TOGGLE_SIZE * 0.5 < vp.X * 0.5 then
                target = UDim2.new(0, 10 + TOGGLE_SIZE, 0, y) -- kompensasi AnchorPoint (1,0)
            else
                target = UDim2.new(1, -10, 0, y)
            end
            Tween(reg, btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = target })
        else
            -- dianggap klik → buka/tutup UI
            popScale()
            toggleWindows()
        end
    end)

    _state.ToggleButton = btn
    return btn
end

--// ───────────────────────────── API publik kecil ───────────────────────────
function ThorUi:SetKeybind(key)
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        bindToggleKey(key)
    else
        warn("[ThorUi] SetKeybind: gunakan Enum.KeyCode (contoh: Enum.KeyCode.RightControl)")
    end
end

function ThorUi:Toggle()
    toggleWindows()
end

function ThorUi:SetToggleVisible(visible)
    _state.ToggleVisible = visible == true
    local btn = _state.ToggleButton
    if btn then
        btn.Visible = _state.ToggleVisible
    end
    local pulse = _state.TogglePulse
    if pulse then
        if _state.ToggleVisible then
            pcall(function() pulse:Play() end)
        else
            pcall(function() pulse:Pause() end)
        end
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
    -- 3) bersihkan garbage table level library (semua connection & tween)
    _state.Registry:Clean()
    _state.KeyConn = nil
    _state.TogglePulse = nil
    -- 4) hancurkan ScreenGui
    if _state.Gui then
        _state.Gui:Destroy()
    end
    _state.Gui = nil
    _state.NotifyHolder = nil
    _state.ToggleButton = nil
    _state.Windows = {}
    _state.Notifs = {}
end

--// ──────────────────────────────── Tab ─────────────────────────────────────
local TabClass = {}
TabClass.__index = TabClass

function TabClass.new(window, cfg)
    cfg = cfg or {}
    local reg = Registry.new()

    local btn = Create("TextButton", {
        Name = "Tab_" .. tostring(cfg.Name or "Tab"),
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(0, 0, 1, -8),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        Parent = window.TabBar,
    })
    Corner(btn, 6)
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = btn,
    })
    local label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = (cfg.Icon and (tostring(cfg.Icon) .. " ") or "") .. tostring(cfg.Name or "Tab"),
        Font = Theme.FontMedium,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        Parent = btn,
    })
    local underline = Create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 10, 1, -2),
        Size = UDim2.new(1, -20, 0, 2),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = btn,
    })
    Gradient(underline, Theme.Accent, Theme.AccentGold, 0)

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
        Label = label,
        Underline = underline,
        Container = container,
        Elements = {},
        Order = 0,
        Active = false,
    }, TabClass)

    reg:Connect(btn.Activated, function()
        window:SelectTab(self)
    end)
    reg:Connect(btn.MouseEnter, function()
        if not self.Active then
            Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 0.88 })
            Tween(reg, label, TI_HOVER, { TextColor3 = Theme.Text })
        end
    end)
    reg:Connect(btn.MouseLeave, function()
        if not self.Active then
            Tween(reg, btn, TI_HOVER, { BackgroundTransparency = 1 })
            Tween(reg, label, TI_HOVER, { TextColor3 = Theme.TextDim })
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
    Corner(card, 8)
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

    cardHover(reg, card, stroke)

    reg:Connect(card.Activated, function()
        Zap(reg, card, Theme.Accent, 8)
        if cfg.Callback then
            cfg.Callback()
        end
    end)

    local element = {
        Type = "Button",
        Instance = card,
        Registry = reg,
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
function TabClass:AddToggle(cfg)
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
        Size = UDim2.new(1, -60, 1, 0),
        Text = cfg.Name or "Toggle",
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = row,
    })

    -- pill toggle dengan knob meluncur ala kilat
    local pill = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(36, 18),
        BackgroundColor3 = Theme.Track,
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(pill, UDim.new(1, 0))
    local pillStroke = Stroke(pill, { Color = Theme.StrokeDim, Transparency = 0.2 })
    local knob = Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(0, 15, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Theme.TextDim,
        BorderSizePixel = 0,
        Parent = pill,
    })
    Corner(knob, UDim.new(1, 0))

    local state = { Value = cfg.Default == true, Callback = cfg.Callback }

    local function render(instant)
        local goalFill = state.Value and Theme.Accent or Theme.Track
        local goalKnobPos = state.Value and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 15, 0.5, 0)
        local goalKnobColor = state.Value and Theme.White or Theme.TextDim
        local goalStrokeColor = state.Value and Theme.Accent or Theme.StrokeDim
        if instant then
            pill.BackgroundColor3 = goalFill
            knob.Position = goalKnobPos
            knob.BackgroundColor3 = goalKnobColor
            pillStroke.Color = goalStrokeColor
        else
            Tween(reg, pill, TI_SNAP, { BackgroundColor3 = goalFill })
            Tween(reg, knob, TI_SNAP, { Position = goalKnobPos, BackgroundColor3 = goalKnobColor })
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
        Instance = card,
        Registry = reg,
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
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 90, 1, 0),
        Text = "",
        Font = Theme.FontMedium,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row1,
    })

    local row2 = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 2,
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
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    Corner(fill, UDim.new(1, 0))
    Gradient(fill, Theme.Accent, Theme.AccentGold, 0)
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
    Stroke(knob, { Color = Theme.Accent, Thickness = 1, Transparency = 0.1 })
    local knobScale = Create("UIScale", { Parent = knob })

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

    reg:Connect(track.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            beginSlide(input)
        end
    end)
    reg:Connect(knob.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            beginSlide(input)
        end
    end)
    reg:Connect(UserInputService.InputChanged, function(input)
        if sliding and (input == slideInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateFromX(input.Position.X)
        end
    end)
    reg:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if sliding then
                sliding = false
                slideInput = nil
                Tween(reg, knobScale, TI_HOVER, { Scale = 1 })
                Tween(reg, stroke, TI_HOVER, { Color = Theme.StrokeDim, Transparency = 0.35 })
            end
        end
    end)

    apply(state.Value, true)

    local element = {
        Type = "Slider",
        Instance = card,
        Registry = reg,
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
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        Text = "▼",
        Font = Theme.FontMain,
        TextSize = 10,
        TextColor3 = Theme.TextDim,
        Parent = header,
    })

    -- daftar opsi (card otomatis memanjang via AutomaticSize)
    local holder = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        LayoutOrder = 2,
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
        arrow.Text = v and "▲" or "▼"
        Tween(reg, arrow, TI_HOVER, { TextColor3 = v and Theme.Accent or Theme.TextDim })
    end

    for _, value in ipairs(cfg.Values or {}) do
        local opt = { Value = value }
        local btn = Create("TextButton", {
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
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
        Instance = card,
        Registry = reg,
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
        LayoutOrder = 2,
        Parent = card,
    })
    Corner(box, 6)
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
            Zap(reg, box, Theme.Accent, 6)
        end
        if cfg.Callback then
            cfg.Callback(box.Text, enterPressed == true)
        end
    end)

    local element = {
        Type = "TextInput",
        Instance = card,
        Registry = reg,
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
            Zap(reg, card, Theme.Accent, 8)
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
        Instance = card,
        Registry = reg,
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

--// ─────────────────────────── Elemen: SECTION ──────────────────────────────
function TabClass:AddSection(cfg)
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
        Text = cfg.Name or "Section",
        Font = Theme.FontBold,
        TextSize = 12,
        TextColor3 = Theme.AccentGold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        Parent = holder,
    })
    local line = Create("Frame", {
        BackgroundColor3 = Theme.AccentGold,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        LayoutOrder = 2,
        Parent = holder,
    })
    Gradient(line, Theme.AccentGold, Theme.Accent, 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.85),
    }))

    local el = { Type = "Section", Instance = holder }
    function el:Remove()
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
    end
    return el
end

--// ─────────────────────────── Elemen: LABEL ────────────────────────────────
function TabClass:AddLabel(cfg)
    cfg = cfg or {}
    local lbl = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = cfg.Text or cfg.Name or "Label",
        Font = Theme.FontMain,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = self:_nextOrder(),
        Parent = self.Container,
    })
    local el = { Type = "Label", Instance = lbl }
    el.SetText = function(text) -- dipanggil: el.SetText("teks baru")
        lbl.Text = tostring(text)
    end
    function el:Remove()
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
    end
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
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
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
    local el = { Type = "Paragraph", Instance = holder }
    el.SetText = function(text) -- dipanggil: el.SetText("teks baru")
        body.Text = tostring(text)
    end
    function el:Remove()
        if self.Instance and self.Instance.Parent then
            self.Instance:Destroy()
        end
    end
    return el
end

--// ──────────────────────────────── Window ──────────────────────────────────
local WindowClass = {}
WindowClass.__index = WindowClass

local TITLE_H     = 42
local TABBAR_H    = 32
local CONTENT_TOP = TITLE_H + TABBAR_H + 1
local COLLAPSED_H = TITLE_H + 4

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
    local size = cfg.Size or (IsMobile() and UDim2.new(0.92, 0, 0.62, 0) or UDim2.new(0, 580, 0, 420))

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
        Parent = gui,
    })
    Corner(frame, 10)
    Stroke(frame, { Color = Theme.Stroke, Thickness = 1, Transparency = 0.15 })
    Create("UISizeConstraint", { MinSize = minSize, Parent = frame })
    local uiScale = Create("UIScale", { Parent = frame })

    -- ── Title bar (area drag) ──
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, TITLE_H),
        Active = true,
        Parent = frame,
    })
    Corner(titleBar, 10)
    Gradient(titleBar, Theme.BackgroundAlt, Theme.Background, 90)
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -140, 1, 0),
        Text = cfg.Title or "ThorUi ⚡",
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = titleBar,
    })

    -- garis petir di bawah title bar (aksen emas → cyan)
    local thunderLine = Create("Frame", {
        Position = UDim2.new(0, 0, 0, TITLE_H),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = frame,
    })
    Gradient(thunderLine, Theme.AccentGold, Theme.Accent, 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.9),
    }))

    -- objek window (dibuat lebih awal agar bisa dipakai closure tombol kontrol)
    local self = setmetatable({
        Frame = frame,
        Registry = reg,
        UiScale = uiScale,
        TitleBar = titleBar,
        Tabs = {},
        Collapsed = false,
        _activeTab = nil,
        _minSize = minSize,
        _savedAbs = nil,
        CollapseLabel = nil,
    }, WindowClass)

    -- ── Tombol kontrol (— collapse, ✕ close) ──
    local function makeControl(text, offsetX, hoverColor, onClick)
        local btn = Create("TextButton", {
            Text = "",
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, offsetX, 0, 7),
            Size = UDim2.fromOffset(28, 28),
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            ZIndex = 3,
            Parent = frame,
        })
        Corner(btn, 6)
        local lbl = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = text,
            Font = Theme.FontBold,
            TextSize = 14,
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

    local collapseBtn, collapseLabel = makeControl("—", -64, Theme.AccentGold, function()
        Zap(reg, collapseBtn, Theme.AccentGold, 6)
        self:SetCollapsed(not self.Collapsed)
    end)
    self.CollapseLabel = collapseLabel
    local closeBtn = makeControl("✕", -34, Theme.Danger, function()
        Zap(reg, closeBtn, Theme.Danger, 6)
        self:Hide()
    end)

    -- ── Tab bar (horizontal, bisa scroll saat tab banyak) ──
    local tabBar = Create("ScrollingFrame", {
        Name = "TabBar",
        Position = UDim2.new(0, 0, 0, CONTENT_TOP - TABBAR_H),
        Size = UDim2.new(1, 0, 0, TABBAR_H),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 0,
        Parent = frame,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = tabBar,
    })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = tabBar,
    })
    self.TabBar = tabBar

    -- ── Konten: ScrollingFrame + AutomaticCanvasSize (elemen tak terbatas) ──
    local content = Create("ScrollingFrame", {
        Name = "Content",
        Position = UDim2.new(0, 0, 0, CONTENT_TOP),
        Size = UDim2.new(1, 0, 1, -CONTENT_TOP),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.2,
        Parent = frame,
    })
    self.Content = content

    -- ── Corner resize handle (drag di sudut kanan-bawah) ──
    local grip = Create("TextButton", {
        Name = "ResizeGrip",
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -2, 1, -2),
        Size = UDim2.fromOffset(28, 28),
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
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    reg:Connect(titleBar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
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
    end)
    reg:Connect(UserInputService.InputChanged, function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    reg:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
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
        if resizing and (input == resizeInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
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
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if resizing then
                resizing = false
                resizeInput = nil
                for _, line in ipairs(gripLines) do
                    Tween(reg, line, TI_HOVER, { BackgroundColor3 = Theme.TextDim })
                end
            end
        end
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

    -- animasi kemunculan (kilat!)
    uiScale.Scale = 0.82
    Tween(reg, uiScale, TI_STRIKE, { Scale = 1 })

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
            t.Underline.BackgroundTransparency = 1
            t.Button.BackgroundTransparency = 1
        end
    end
    self._activeTab = tab
    tab.Active = true
    tab.Container.Visible = true
    tab.Label.TextColor3 = Theme.Text
    tab.Underline.BackgroundTransparency = 0
    tab.Button.BackgroundTransparency = 0.88
    tab.Button.BackgroundColor3 = Theme.Card
    -- animasi underline "menyambar"
    tab.Underline.Size = UDim2.new(0, 0, 0, 2)
    Tween(self.Registry, tab.Underline, TI_STRIKE, { Size = UDim2.new(1, -20, 0, 2) })
    -- konten slide-in kilat
    tab.Container.Position = UDim2.new(0, 0, 0, 8)
    Tween(self.Registry, tab.Container, TI_SNAP, { Position = UDim2.new(0, 0, 0, 0) })
    self.Content.CanvasPosition = Vector2.new(0, 0)
end

function WindowClass:Show()
    if self.Frame.Visible then
        return
    end
    self.Frame.Visible = true
    self.UiScale.Scale = 0.75
    Tween(self.Registry, self.UiScale, TI_STRIKE, { Scale = 1 })
end

function WindowClass:Hide()
    if not self.Frame.Visible then
        return
    end
    local tween = Tween(self.Registry, self.UiScale, TI_EXIT, { Scale = 0.7 })
    tween.Completed:Connect(function(playback)
        if playback == Enum.PlaybackState.Completed then
            self.Frame.Visible = false
            self.UiScale.Scale = 0.75
        end
    end)
end

function WindowClass:Toggle()
    if self.Frame.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function WindowClass:SetCollapsed(collapsed)
    if self.Collapsed == collapsed then
        return
    end
    self.Collapsed = collapsed
    if collapsed then
        self._savedAbs = self.Frame.AbsoluteSize
        self.TabBar.Visible = false
        self.Content.Visible = false
        self.Grip.Visible = false
        setSizeKeepTopLeft(self.Frame, Vector2.new(self.Frame.AbsoluteSize.X, COLLAPSED_H))
    else
        self.TabBar.Visible = true
        self.Content.Visible = true
        self.Grip.Visible = true
        if self._savedAbs then
            setSizeKeepTopLeft(self.Frame, self._savedAbs)
        end
    end
    if self.CollapseLabel then
        self.CollapseLabel.Text = collapsed and "+" or "—"
    end
    Zap(self.Registry, self.TitleBar, Theme.AccentGold, 10)
end

function WindowClass:SetKeybind(key)
    ThorUi:SetKeybind(key)
end

function WindowClass:Destroy()
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

return ThorUi

--[[ ═════════════════════════════════════════════════════════════════════════
        CONTOH IMPLEMENTASI
        ════════════════════════════════════════════════════════════════════════

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
                Size    = UDim2.new(0, 580, 0, 420),  -- kosongkan agar otomatis responsif mobile
                MinSize = Vector2.new(400, 250),      -- batas minimal saat resize
                Keybind = Enum.KeyCode.RightControl,  -- toggle buka/tutup UI (PC)
                -- ShowToggle = false,                -- sembunyikan tombol ⚡ melayang
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

        Tab2:AddParagraph({
                Title = "Tentang ThorUi",
                Text = "UI library bertema Dewa Petir: gelap, snappy, dan responsif. "
                        .. "Drag window dari title bar, resize dari sudut kanan bawah, "
                        .. "dan geser tombol ⚡ melayang ke mana pun (snap otomatis ke tepi).",
        })

        ThorUi:Notify({ Title = "⚡ Petir Menyambar", Content = "Script berhasil dimuat!", Duration = 3 })

        -- Kontrol programatik:
        -- godMode:Set(true)         → set nilai + panggil callback
        -- godMode:Set(true, false)  → set nilai TANPA callback
        -- godMode:Get()             → ambil nilai
        -- Window:Toggle() / Window:Destroy()
        -- ThorUi:Destroy()          → hancurkan seluruh UI + bersihkan memory

        ──────────────────────────── potong di sini ────────────────────────────

        B. CARA PEMAKAIAN DI EXECUTOR
           Salin seluruh file ini ke script executor, bungkus sebagai module
           (atau gabungkan dengan blok contoh di atas), lalu jalankan.
           ScreenGui otomatis mencoba CoreGui, fallback ke PlayerGui.
]]
