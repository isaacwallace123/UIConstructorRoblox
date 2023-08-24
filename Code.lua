local Tween = game:GetService("TweenService")

local Main = script.Parent.Parent

local function OpenDefault(Path)
	Path.Position = UDim2.fromScale(0.5,1.5)
	Path.Size = UDim2.fromScale(0,0)
	Path.Visible = true
	Tween:Create(Path, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromScale(0.5,0.6)}):Play()
end

local function CloseDefault(Path)
	Tween:Create(Path, TweenInfo.new(0.2), {Position = UDim2.fromScale(0.5,1.5), Size = UDim2.fromScale(0,0)}):Play()
	wait(0.2)
	Path.Visible = false
end

local UI = {
	ToggledUI = nil,

	List = {
		[Main.Output.SettingsContainer] = {
			Open = OpenDefault,
			Close = CloseDefault,
		},
		[Main.Output.ShopContainer] = {
			Open = OpenDefault,
			Close = CloseDefault,
		},
		[Main.Output.TipMenu] = {
			Open = OpenDefault,
			Close = CloseDefault,
		}
	}
}

local function CheckUI(Path)
	if Path == UI.ToggledUI then
		return false
	else
		for i,v in pairs(Path.Parent:GetChildren()) do
			if UI.ToggledUI == nil then
				return true
			else
				return UI.ToggledUI
			end
		end
	end
end

local UIDebounce = false

function UI.Receive(Path)
	if UIDebounce or not Path or not UI.List[Path] then
		return
	end
	UIDebounce = true
	
	local Check = CheckUI(Path)
	
	if Check == true then
		UI.List[Path].Open(Path)
		UI.ToggledUI = Path
	elseif Check == false then
		UI.List[Path].Close(Path)
		wait(0.3)
		for i,v in pairs(Main.Output:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		UI.ToggledUI = nil
	else
		UI.List[UI.ToggledUI].Close(UI.ToggledUI)
		UI.List[Path].Open(Path)
		UI.ToggledUI = Path
	end
	wait(0.1)
	UIDebounce = false
	
	return
end

return UI