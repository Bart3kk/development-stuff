--[[
╭━╮╱╭╮╱╱╱╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╱╱╭━━━╮╱╭╮            |
┃┃╰╮┃┃╱╱╱╱╱╱╱╱┃┃╱╱╱╱╱╱╱╱╱╱┃╭━╮┃╱┃┃            |
┃╭╮╰╯┣━━┳╮╭┳━━┫┃╭━━┳━━┳━━╮┃┃╱┃┣━╯┣╮╭┳┳━╮     | Welcome to the Nameless Admin source, feel free to take a look around.
┃┃╰╮┃┃╭╮┃╰╯┃┃━┫┃┃┃━┫━━┫━━┫┃╰━╯┃╭╮┃╰╯┣┫╭╮╮    | Enjoy.
┃┃╱┃┃┃╭╮┃┃┃┃┃━┫╰┫┃━╋━━┣━━┃┃╭━╮┃╰╯┃┃┃┃┃┃┃┃    |
╰╯╱╰━┻╯╰┻┻┻┻━━┻━┻━━┻━━┻━━╯╰╯╱╰┻━━┻┻┻┻┻╯╰╯    |
--]]

 -- Waits until game is loaded
 local game = game
 local GetService = game.GetService
 if (not game.IsLoaded(game)) then
	 local Loaded = game.Loaded
	 Loaded.Wait(Loaded);
	 wait(1.5)
 end
 
 -- Notification library
local Notifications = [[
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local TextService = game:GetService("TextService");

local Player = game:GetService("Players").LocalPlayer;

local NotifGui = Instance.new("ScreenGui");
NotifGui.Name = "AkaliNotif";
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui");

local Container = Instance.new("Frame");
Container.Name = "Container";
Container.Position = UDim2.new(0, 20, 0.5, -20);
Container.Size = UDim2.new(0, 300, 0.5, 0);
Container.BackgroundTransparency = 1;
Container.Parent = NotifGui;

local function Image(ID, Button)
    local NewImage = Instance.new(string.format("Image%s", Button and "Button" or "Label"));
    NewImage.Image = ID;
    NewImage.BackgroundTransparency = 1;
    return NewImage;
end

local function Round2px()
    local NewImage = Image("http://www.roblox.com/asset/?id=5761488251");
    NewImage.ScaleType = Enum.ScaleType.Slice;
    NewImage.SliceCenter = Rect.new(2, 2, 298, 298);
    NewImage.ImageColor3 = Color3.fromRGB(12, 4, 20);
    NewImage.ImageTransparency = 0.14
    return NewImage;
end

local function Shadow2px()
    local NewImage = Image("http://www.roblox.com/asset/?id=5761498316");
    NewImage.ScaleType = Enum.ScaleType.Slice;
    NewImage.SliceCenter = Rect.new(17, 17, 283, 283);
    NewImage.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30);
    NewImage.Position = -UDim2.fromOffset(15, 15);
    NewImage.ImageColor3 = Color3.fromRGB(26, 26, 26);
    return NewImage;
end

local Padding = 10;
local DescriptionPadding = 10;
local InstructionObjects = {};
local TweenTime = 1;
local TweenStyle = Enum.EasingStyle.Sine;
local TweenDirection = Enum.EasingDirection.Out;

local LastTick = tick();

local function CalculateBounds(TableOfObjects)
    local TableOfObjects = typeof(TableOfObjects) == "table" and TableOfObjects or {};
    local X, Y = 0, 0;
    for _, Object in next, TableOfObjects do
        X += Object.AbsoluteSize.X;
        Y += Object.AbsoluteSize.Y;
    end
    return {X = X, Y = Y, x = X, y = Y};
end

local CachedObjects = {};

local function Update()
    local DeltaTime = tick() - LastTick;
    local PreviousObjects = {};
    for CurObj, Object in next, InstructionObjects do
        local Label, Delta, Done = Object[1], Object[2], Object[3];
        if (not Done) then
            if (Delta < TweenTime) then
                Object[2] = math.clamp(Delta + DeltaTime, 0, 1);
                Delta = Object[2];
            else
                Object[3] = true;
            end
        end
        local NewValue = TweenService:GetValue(Delta, TweenStyle, TweenDirection);
        local CurrentPos = Label.Position;
        local PreviousBounds = CalculateBounds(PreviousObjects);
        local TargetPos = UDim2.new(0, 0, 0, PreviousBounds.Y + (Padding * #PreviousObjects));
        Label.Position = CurrentPos:Lerp(TargetPos, NewValue);
        table.insert(PreviousObjects, Label);
    end
    CachedObjects = PreviousObjects;
    LastTick = tick();
end

RunService:BindToRenderStep("UpdateList", 0, Update);

local TitleSettings = {
    Font = Enum.Font.GothamSemibold;
    Size = 14;
}

local DescriptionSettings = {
    Font = Enum.Font.Gotham;
    Size = 14;
}

local MaxWidth = (Container.AbsoluteSize.X - Padding - DescriptionPadding);

local function Label(Text, Font, Size, Button)
    local Label = Instance.new(string.format("Text%s", Button and "Button" or "Label"));
    Label.Text = Text;
    Label.Font = Font;
    Label.TextSize = Size;
    Label.BackgroundTransparency = 1;
    Label.TextXAlignment = Enum.TextXAlignment.Left;
    Label.RichText = true;
    Label.TextColor3 = Color3.fromRGB(255, 255, 255);
    return Label;
end

local function TitleLabel(Text)
    return Label(Text, TitleSettings.Font, TitleSettings.Size);
end

local function DescriptionLabel(Text)
    return Label(Text, DescriptionSettings.Font, DescriptionSettings.Size);
end

local PropertyTweenOut = {
    Text = "TextTransparency",
    Fram = "BackgroundTransparency",
    Imag = "ImageTransparency"
}

local function FadeProperty(Object)
    local Prop = PropertyTweenOut[string.sub(Object.ClassName, 1, 4)];
    TweenService:Create(Object, TweenInfo.new(0.25, TweenStyle, TweenDirection), {
        [Prop] = 1;
    }):Play();
end

local function SearchTableFor(Table, For)
    for _, v in next, Table do
        if (v == For) then
            return true;
        end
    end
    return false;
end

local function FindIndexByDependency(Table, Dependency)
    for Index, Object in next, Table do
        if (typeof(Object) == "table") then
            local Found = SearchTableFor(Object, Dependency);
            if (Found) then
                return Index;
            end
        else
            if (Object == Dependency) then
                return Index;
            end
        end
    end
end

local function ResetObjects()
    for _, Object in next, InstructionObjects do
        Object[2] = 0;
        Object[3] = false;
    end
end

local function FadeOutAfter(Object, Seconds)
    wait(Seconds);
    FadeProperty(Object);
    for _, SubObj in next, Object:GetDescendants() do
        FadeProperty(SubObj);
    end
    wait(0.25);
    table.remove(InstructionObjects, FindIndexByDependency(InstructionObjects, Object));
    ResetObjects();
    Object.Visible = false
end

return {
    Notify = function(Properties)
        local Properties = typeof(Properties) == "table" and Properties or {};
        local Title = Properties.Title;
        local Description = Properties.Description;
        local Duration = Properties.Duration or 5;
        if (Title) or (Description) then -- Check that user has provided title and/or description
            local Y = Title and 26 or 0;
            if (Description) then
                local TextSize = TextService:GetTextSize(Description, DescriptionSettings.Size, DescriptionSettings.Font, Vector2.new(0, 0));
                for i = 1, math.ceil(TextSize.X / MaxWidth) do
                    Y += TextSize.Y;
                end
                Y += 8;
            end
            local NewLabel = Round2px();
            NewLabel.Size = UDim2.new(1, 0, 0, Y);
            NewLabel.Position = UDim2.new(-1, 20, 0, CalculateBounds(CachedObjects).Y + (Padding * #CachedObjects));
            if (Title) then
                local NewTitle = TitleLabel(Title);
                NewTitle.Size = UDim2.new(1, -10, 0, 26);
                NewTitle.Position = UDim2.fromOffset(10, 0);
                NewTitle.Parent = NewLabel;
            end
            if (Description) then
                local NewDescription = DescriptionLabel(Description);
                NewDescription.TextWrapped = true;
                NewDescription.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(-DescriptionPadding, Title and -26 or 0);
                NewDescription.Position = UDim2.fromOffset(10, Title and 26 or 0);
                NewDescription.TextYAlignment = Enum.TextYAlignment[Title and "Top" or "Center"];
                NewDescription.Parent = NewLabel;
            end
            Shadow2px().Parent = NewLabel;
            NewLabel.Parent = Container;
            table.insert(InstructionObjects, {NewLabel, 0, false});
            coroutine.wrap(FadeOutAfter)(NewLabel, Duration);
        end
    end,
}
]]
local Notify = Notifications.Notify;

Notify({
	Description = "If you ever see an admin script made by the name GrimEx, please don't use it. All the owner did was rename our admin, plus never asked for permission.";
	Title = "Nameless Admin - WARNING";
	Duration = 5;
});

wait(7)

Notify({
	Description = "Fixed by cocof_word. (cuz rob is too fucking lazy to do it himself)";
	Title = "Nameless Admin";
	Duration = 5;
});
 
 -- Custom file functions checker checker
 local CustomFunctionSupport = isfile and isfolder and writefile and readfile and listfiles
 local FileSupport = isfile and isfolder and writefile and readfile
 
 -- Creates folder & files for Prefix & Plugins
 if FileSupport then
 if not isfolder('Nameless-Admin') then
 makefolder('Nameless-Admin')
 end
 
 if not isfolder('Nameless-Admin/Plugins') then
	 makefolder('Nameless-Admin/Plugins')
 end
 
 if not isfile("Nameless-Admin/Prefix.txt") then
 writefile("Nameless-Admin/Prefix.txt", ';')
 else
 end
 end
 
 -- [[ PREFIX AND OTHER STUFF. ]] -- 
 local opt = {
	 prefix = readfile("Nameless-Admin/Prefix.txt", ';'), -- If player's executor has the custom file function support it reads the prefix file to get prefix
	 tupleSeparator = ',',	-- ;ff me,others,all | ;ff me/others/all
	 ui = {					-- never did anything with this
		 
	 },
	 keybinds = {			-- never did anything with this
		 
	 },
 }
 
 -- [[ Version ]] -- 
 currentversion = 1.13
 
 --[[ VARIABLES ]]--
 PlaceId, JobId = game.PlaceId, game.JobId
 local Players = game:GetService("Players")
 local UserInputService = game:GetService("UserInputService")
 local TweenService = game:GetService("TweenService")
 local RunService = game:GetService("RunService")
 local TeleportService = game:GetService("TeleportService")
 local RunService2 = game:FindService("RunService")
 local StarterGui = game:GetService("StarterGui")
 local SoundService = game:GetService("SoundService")
 sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
 local Player = game.Players.LocalPlayer
 local IYLOADED = false -- This is used for the ;iy command that executes infinite yield commands using this admin command script (BTW)
 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
 local Character = game.Players.LocalPlayer.Character
 local Clicked = true
 _G.Spam = false
 --[[ FOR LOOP COMMANDS ]]--
 view = false
 anniblockspam = false
 control = false
 FakeLag = false
 Loopvoid = false
 Loopkill = false
 Loopbring = false
 Loopbanish = false
 Loopvoid = false
 Loopcuff = false
 loopgrab = false
 Loopstand = false
 Looptornado = false
 Loopmute = false
 Loopglitch = false
 Watch = false
 local Admin = {}
 
 -- [[ HAT ORBIT (PATCHED IN MOST GAMES) ]]
 local Offset = 10
 local Rotation = 0
 local Speed = 1
 local Height = 2
 
 local EditingPos = false
 
 local Power = 50000
 local Damping = 500
 
 local Mode = 1
 
 local NormalSpin = true
 
 
 --[[ Some more variables ]]--
 
 local localPlayer = Players.LocalPlayer
 local LocalPlayer = Players.LocalPlayer
 local character = localPlayer.Character
 local mouse = localPlayer:GetMouse()
 local camera = workspace.CurrentCamera
 local camtype = camera.CameraType
 local Commands, Aliases = {}, {}
 player, plr, lp = localPlayer, localPlayer, localPlayer, localPlayer
 
 localPlayer.CharacterAdded:Connect(function(c)
	 character = c
 end)
 
 local bringc = {}
 
 --[[ COMMAND FUNCTIONS ]]--
 commandcount = 0
 cmd = {}
 cmd.add = function(...)
	 local vars = {...}
	 local aliases, info, func = vars[1], vars[2], vars[3]
	 for i, cmdName in pairs(aliases) do
		 if i == 1 then
			 Commands[cmdName:lower()] = {func, info}
		 else
			 Aliases[cmdName:lower()] = {func, info}
		 end
	 end
	 commandcount = commandcount + 1
 end

 cmd.run = function(args)
	 local caller, arguments = args[1], args; table.remove(args, 1);
	 local success, msg = pcall(function()
		 if Commands[caller:lower()] then
			 Commands[caller:lower()][1](unpack(arguments))
		 elseif Aliases[caller:lower()] then
			 Aliases[caller:lower()][1](unpack(arguments))
		 end
	 end)
	 if not success then
	 end
 end
 
 --[[ LIBRARY FUNCTIONS ]]--
 lib = {}
 lib.wrap = function(f)
	 return coroutine.wrap(f)()
 end
 
 wrap = lib.wrap
 
 local wait = function(int)
	 if not int then int = 0 end
	 local t = tick()
	 repeat
		 RunService.Heartbeat:Wait(0)
	 until (tick() - t) >= int
	 return (tick() - t), t
 end
 
	 function r15(plr)
		 if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
			 return true
		 end
	 end
	 
	 function getRoot(character)
	 local root = game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') or game.Players.LocalPlayer.Character:FindFirstChild('Torso') or game.Players.LocalPlayer.Character:FindFirstChild('UpperTorso')
	 return root
 end
 
 -- [[ FUNCTION TO GET A PLAYER ]] --
 local getPlr = function(Name)
	 if Name:lower() == "random" then
		 return Players:GetPlayers()[math.random(#Players:GetPlayers())]
	 else
		 Name = Name:lower():gsub("%s", "")
		 for _, x in next, Players:GetPlayers() do
			 if x.Name:lower():match(Name) then
				 return x
			 elseif x.DisplayName:lower():match("^" .. Name) then
				 return x
			 end
		 end
	 end
 end
 
 -- [[ MORE VARIABLES ]] --
 plr = game.Players.LocalPlayer
 COREGUI = game:GetService("CoreGui")
 speaker = game.Players.LocalPlayer
 char = plr.Character
 RunService = game:GetService("RunService")
 
 game:GetService('RunService').Stepped:connect(function()
 if anniblockspam then
 game.workspace.Tools.Chest_Invisibility_Cloak.Part.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
 
 if game.Players.LocalPlayer.Backpack:FindFirstChild("InvisibilityCloak") then
 game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.InvisibilityCloak)
 end
 
 for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
 if (v:IsA("Tool")) then
 v.Handle.Mesh:Destroy()
 end
 end
 
 for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
 if (v:IsA("Tool")) then
 v.Parent = workspace
 end
 end
 
 end
 end)
 
 function mobilefly(speed)
	 local controlModule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild('PlayerModule'):WaitForChild("ControlModule"))
	 local bv = Instance.new("BodyVelocity")
	 bv.Name = "VelocityHandler"
	 bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
	 bv.MaxForce = Vector3.new(0,0,0)
	 bv.Velocity = Vector3.new(0,0,0)
	 
	 local bg = Instance.new("BodyGyro")
	 bg.Name = "GyroHandler"
	 bg.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
	 bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	 bg.P = 1000
	 bg.D = 50
	 
	 local Signal1
	 Signal1 = game.Players.LocalPlayer.CharacterAdded:Connect(function(NewChar)
	 local bv = Instance.new("BodyVelocity")
	 bv.Name = "VelocityHandler"
	 bv.Parent = NewChar:WaitForChild("Humanoid").RootPart
	 bv.MaxForce = Vector3.new(0,0,0)
	 bv.Velocity = Vector3.new(0,0,0)
	 
	 local bg = Instance.new("BodyGyro")
	 bg.Name = "GyroHandler"
	 bg.Parent = NewChar:WaitForChild("Humanoid").HumanoidRootPart
	 bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	 bg.P = 1000
	 bg.D = 50
	 end)
	 
	 local camera = game.Workspace.CurrentCamera
	 
	 local Signal2
	 Signal2 = game:GetService"RunService".RenderStepped:Connect(function()
	 if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
	 
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9,9e9,9e9)
	 game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9,9e9,9e9)
	 game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
	 
	 game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.CFrame = camera.CoordinateFrame
	 local direction = controlModule:GetMoveVector()
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new()
	 if direction.X > 0 then
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + camera.CFrame.RightVector*(direction.X*speed)
	 end
	 if direction.X < 0 then
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + camera.CFrame.RightVector*(direction.X*speed)
	 end
	 if direction.Z > 0 then
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - camera.CFrame.LookVector*(direction.Z*speed)
	 end
	 if direction.Z < 0 then
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - camera.CFrame.LookVector*(direction.Z*speed)
	 end
	 end
	 end)
 end
 
 function unmobilefly()
	 game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
	 game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler:Destroy()
	 game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	 Signal1:Disconnect()
	 Signal2:Disconnect()
 end
 
 function x(v)
	 if v then
		 for _,i in pairs(workspace:GetDescendants()) do
			 if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChild("Humanoid") then
				 i.LocalTransparencyModifier = 0.5
			 end
		 end
	 else
		 for _,i in pairs(workspace:GetDescendants()) do
			 if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChild("Humanoid") then
				 i.LocalTransparencyModifier = 0
			 end
		 end
	 end
 end
 
 local function getChar()
	 return game.Players.LocalPlayer.Character
 end
 
 local function getBp()
	 return game.Players.LocalPlayer.Backpack
 end
 
 local cmdlp = game.Players.LocalPlayer
 
 plr = cmdlp
 
 workspace = game.workspace
 
 cmdm = plr:GetMouse()
 
 function sFLY(vfly)
	 FLYING = false
	 speedofthefly = 10
	 speedofthevfly = 10
	 while not cmdlp or not cmdlp.Character or not cmdlp.Character:FindFirstChild('HumanoidRootPart') or not cmdlp.Character:FindFirstChild('Humanoid') or not cmdm do
		  wait()
	 end 
	 local T = cmdlp.Character.HumanoidRootPart
	 local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	 local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	 local SPEED = 0
	 local function FLY()
		 FLYING = true
		 local BG = Instance.new('BodyGyro', T)
		 local BV = Instance.new('BodyVelocity', T)
		 BG.P = 9e4
		 BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		 BG.cframe = T.CFrame
		 BV.velocity = Vector3.new(0, 0, 0)
		 BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		 spawn(function()
			 while FLYING do
				 if not vfly then
					 cmdlp.Character:FindFirstChild("Humanoid").PlatformStand = true
				 end
				 if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					 SPEED = 50
				 elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					 SPEED = 0
				 end
				 if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					 BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					 lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				 elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					 BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				 else
					 BV.velocity = Vector3.new(0, 0, 0)
				 end
				 BG.cframe = workspace.CurrentCamera.CoordinateFrame
				 wait()
			 end
			 CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			 lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			 SPEED = 0
			 BG:destroy()
			 BV:destroy()
			 cmdlp.Character.Humanoid.PlatformStand = false
		 end)
	 end
	 cmdm.KeyDown:connect(function(KEY)
		 if KEY:lower() == 'w' then
			 if vfly then
				 CONTROL.F = speedofthevfly
			 else
				 CONTROL.F = speedofthefly
			 end
		 elseif KEY:lower() == 's' then
			 if vfly then
				 CONTROL.B = - speedofthevfly
			 else
				 CONTROL.B = - speedofthefly
			 end
		 elseif KEY:lower() == 'a' then
			 if vfly then
				 CONTROL.L = - speedofthevfly
			 else
				 CONTROL.L = - speedofthefly
			 end
		 elseif KEY:lower() == 'd' then
			 if vfly then
				 CONTROL.R = speedofthevfly
			 else
				 CONTROL.R = speedofthefly
			 end
		 elseif KEY:lower() == 'y' then
			 if vfly then
				 CONTROL.Q = speedofthevfly*2
			 else
				 CONTROL.Q = speedofthefly*2
			 end
		 elseif KEY:lower() == 't' then
			 if vfly then
				 CONTROL.E = -speedofthevfly*2
			 else
				 CONTROL.E = -speedofthefly*2
			 end
		 end
	 end)
	 cmdm.KeyUp:connect(function(KEY)
		 if KEY:lower() == 'w' then
			 CONTROL.F = 0
		 elseif KEY:lower() == 's' then
			 CONTROL.B = 0
		 elseif KEY:lower() == 'a' then
			 CONTROL.L = 0
		 elseif KEY:lower() == 'd' then
			 CONTROL.R = 0
		 elseif KEY:lower() == 'y' then
			 CONTROL.Q = 0
		 elseif KEY:lower() == 't' then
			 CONTROL.E = 0
		 end
	 end)
	 FLY()
 end
 
 
 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
 
 local function attachTool(tool,cf)
	 for i,v in pairs(tool:GetDescendants()) do
		 if not (v:IsA("BasePart") or v:IsA("Mesh") or v:IsA("SpecialMesh")) then
			 v:Destroy()
		 end
	 end
	 wait()
 game.Players.LocalPlayer.Character.Humanoid.Name = 1
 local l = game.Players.LocalPlayer.Character["1"]:Clone()
 l.Parent = game.Players.LocalPlayer.Character
 l.Name = "Humanoid"
			 
 game.Players.LocalPlayer.Character["1"]:Destroy()
 game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
 game.Players.LocalPlayer.Character.Animate.Disabled = true
 wait()
 game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"
 
 tool.Parent = getChar()
 end
 
 local nc = false
 local ncLoop
 ncLoop = game:GetService("RunService").Stepped:Connect(function()
	 if nc and getChar() ~= nil then
		 for _, v in pairs(getChar():GetDescendants()) do
			 if v:IsA("BasePart") and v.CanCollide == true then
				 v.CanCollide = false
			 end
		 end
	 end
 end)
 
 local netsleepTargets = {}
 local nsLoop
 nsLoop = game:GetService("RunService").Stepped:Connect(function()
	 if #netsleepTargets == 0 then return end
	 for i,v in pairs(netsleepTargets) do
		 if v.Character then
			 for i,v in pairs(v.Character:GetChildren()) do
				 if v:IsA("BasePart") == false and v:IsA("Accessory") == false then continue end
				 if v:IsA("BasePart") then
					 sethiddenproperty(v,"NetworkIsSleeping",true)
				 elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
					 sethiddenproperty(v.Handle,"NetworkIsSleeping",true)
				 end
			 end
		 end
	 end
 end)
 
 function getTorso(x)
	 x = x or game.Players.LocalPlayer.Character
	 return x:FindFirstChild("Torso") or x:FindFirstChild("UpperTorso") or x:FindFirstChild("LowerTorso") or x:FindFirstChild("HumanoidRootPart")
 end
 
 function getRoot(char)
	 local rootPart = game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') or game.Players.LocalPlayer.Character:FindFirstChild('Torso') or game.Players.LocalPlayer.Character:FindFirstChild('UpperTorso')
	 return rootPart
 end
 
 local lp = game:GetService("Players").LocalPlayer
 
 
 -- [[ LIB FUNCTIONS ]] --
 lib.lock = function(instance, par)
	 locks[instance] = true
	 instance.Parent = par or instance.Parent
	 instance.Name = "RightGrip"
 end
 lock = lib.lock
 locks = {}
 
 lib.find = function(t, v)	-- mmmmmm
	 for i, e in pairs(t) do
		 if i == v or e == v then
			 return i
		 end
	 end
	 return nil
 end
 
 lib.parseText = function(text, watch)
	 local parsed = {}
	 if not text then return nil end
	 for arg in text:gmatch("[^" .. watch .. "]+") do
		 arg = arg:gsub("-", "%%-")
		 local pos = text:find(arg)
		 arg = arg:gsub("%%", "")
		 if pos then
			 local find = text:sub(pos - opt.prefix:len(), pos - 1)
			 if (find == opt.prefix and watch == opt.prefix) or watch ~= opt.prefix then
				 table.insert(parsed, arg)
			 end
		 else
			 table.insert(parsed, nil)
		 end
	 end
	 return parsed
 end
 
 lib.parseCommand = function(text)
	 wrap(function()
		 local commands = lib.parseText(text, opt.prefix)
		 for _, parsed in pairs(commands) do
			 local args = {}
			 for arg in parsed:gmatch("[^ ]+") do
				 table.insert(args, arg)
			 end
			 cmd.run(args)
		 end
	 end)
 end
 
 local connections = {}
 
 lib.connect = function(name, connection)	-- no :(
	 connections[name .. tostring(math.random(1000000, 9999999))] = connection
	 return connection
 end
 
 lib.disconnect = function(name)
	 for title, connection in pairs(connections) do
		 if title:find(name) == 1 then
			 connection:Disconnect()
		 end
	 end
 end
 
 m = math			-- prepare for annoying and unnecessary tool grip math
 rad = m.rad
 clamp = m.clamp
 sin = m.sin
 tan = m.tan
 cos = m.cos
 
 --[[ PLAYER FUNCTIONS ]]--
 argument = {}
 argument.getPlayers = function(str)
	 local playerNames, players = lib.parseText(str, opt.tupleSeparator), {}
	 for _, arg in pairs(playerNames or {"me"}) do
		 arg = arg:lower()
		 local playerList = Players:GetPlayers()
		 if arg == "me" or arg == nil then
			 table.insert(players, localPlayer)
			 
		 elseif arg == "all" then
			 for _, plr in pairs(playerList) do
				 table.insert(players, plr)
			 end
			 
		 elseif arg == "others" then
			 for _, plr in pairs(playerList) do
				 if plr ~= localPlayer then
					 table.insert(players, plr)
				 end
			 end
			 
		 elseif arg == "random" then
			 table.insert(players, playerList[math.random(1, #playerList)])
			 
		 elseif arg:find("%%") == 1 then
			 local teamName = arg:sub(2)
			 for _, plr in pairs(playerList) do
				 if tostring(plr.Team):lower():find(teamName) == 1 then
					 table.insert(players, plr)
				 end
			 end
			 
		 else
			 for _, plr in pairs(playerList) do
				 if plr.Name:lower():find(arg) == 1 or (plr.DisplayName and plr.DisplayName:lower():find(arg) == 1) or (tostring(plr.UserId):lower():find(arg) == 1) then
					 table.insert(players, plr)
				 end
			 end
		 end
	 end
	 return players
 end

 --[[ COMMANDS ]]--
 cmd.add({"stand"}, {"stand <player>", "Makes a player your stand"}, function(...)
		   Username = (...)
  
 local target = getPlr(Username)
 local THumanoidPart
 local plrtorso
 local TargetCharacter = target.Character
	if TargetCharacter:FindFirstChild("Torso") then
			plrtorso = TargetCharacter.Torso
		elseif TargetCharacter:FindFirstChild("UpperTorso") then
			plrtorso = TargetCharacter.UpperTorso
		end
		 local old = getChar().HumanoidRootPart.CFrame
		 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
		 if target == nil or tool == nil then return end
		 local attWeld = attachTool(tool,CFrame.new(0,0,0))
		 attachTool(tool,CFrame.new(0,0,0.2) * CFrame.Angles(math.rad(-90),0,0))
			tool.Grip = plrtorso.CFrame
	 wait(0.07)
		 tool.Grip = CFrame.new(0, 3, -1) 
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,0)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,1)
	  wait(1.3)
 end)
 
 cmd.add({"valk"}, {"valk", "Only works on dollhouse"}, function()
 repeat game:GetService("RunService").Stepped:wait()
 until game:IsLoaded() and game:GetService("Players").LocalPlayer
 
 pcall(function()
	local plr = game:GetService("Players").LocalPlayer
	local giver = workspace:WaitForChild("Valkyrie Helm giver")
 
	local head = plr.Character:WaitForChild("Head")
	firetouchinterest(head, giver, 0)
 
	plr.CharacterAdded:Connect(function(char)
		head = char:WaitForChild("Head")
		firetouchinterest(head, giver, 0)
	end)
 end)
 end)
 
 cmd.add({"resizechat", "rc"}, {"resizechat (rc)", "Makes chat resizable and draggable"}, function()
 require(game:GetService("Chat").ClientChatModules.ChatSettings).WindowResizable = true
 require(game:GetService("Chat").ClientChatModules.ChatSettings).WindowDraggable = true
 end)
 
 alreadyantilag = false
 cmd.add({"lag"}, {"lag <player>", "Chat lag"}, function()
	 
	 local Message = "a" 
	 local Unicode = " "
	 Message = Message .. Unicode:rep(200 - #Message)
 
	 local SayMessageRequest = game:GetService("ReplicatedStorage"):FindFirstChild("SayMessageRequest", true)
	 
		 for i = 1, 7 do
			 SayMessageRequest:FireServer(Message, "All")
		 end
 
		 if alreadyantilag == false then
		 local Players = game:GetService("Players")
		 
		 local Player = Players.LocalPlayer
		 local PlayerGui = Player.PlayerGui
		 
		 local Chat = PlayerGui:FindFirstChild("Chat") 
		 local MessageDisplay = Chat and Chat:FindFirstChild("Frame_MessageLogDisplay", true)
		 local Scroller = MessageDisplay and MessageDisplay:FindFirstChild("Scroller")
		 
		 local Gsub = string.gsub
		 local Lower = string.lower
		 
		 if not Scroller then return end
		 
		 for _, x in next, Scroller:GetChildren() do
			 local MessageTextLabel = x:FindFirstChildWhichIsA("TextLabel")
				 
			 if MessageTextLabel then
				 local Message = Gsub(MessageTextLabel.Text, "^%s+", "")
				 
				 if Message:match(" ") then
					 x:Destroy()
				 end
			 end
		 end
		 
		 local ChatAdded = Scroller.ChildAdded:Connect(function(x)
			 local MessageTextLabel = x:FindFirstChildWhichIsA("TextLabel")
			 local SenderTextButton = MessageTextLabel and MessageTextLabel:FindFirstChildWhichIsA("TextButton")
			 if MessageTextLabel and SenderTextButton then
				 repeat task.wait() until not MessageTextLabel.Text:match("__+")
				 local Message = Gsub(MessageTextLabel.Text, "^%s+", "")
				 
				 if Message:match(" ") then
					 x:Destroy()
				 end
			 end
		 end)
		 alreadyantilag = true
	 else
	 end
 end)
  
 cmd.add({"prefix"}, {"prefix <prefix>", "Changes the admin prefix"}, function(...)
 PrefixChange = (...)
 
 if PrefixChange == nil then
 Notify({
 Description = "Please enter a valid prefix";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 elseif PrefixChange == "p" or PrefixChange == "[" or PrefixChange == "P" then
	 Notify({
		 Description = "idk why but this prefix breaks changing the prefix so pick smthing else alr?";
		 Title = "Nameless Admin";
		 Duration = 5;
		 
		 });
	 else
 opt.prefix = PrefixChange
 Notify({
 Description = "Prefix set to " .. PrefixChange .. "";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end
 end)
 
 
 cmd.add({"saveprefix"}, {"saveprefix <prefix>", "Saves the prefix to what u want"}, function(...)
 PrefixChange = (...)
 
 if PrefixChange == nil then
 Notify({
 Description = "Please enter a valid prefix";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 elseif PrefixChange == "p" or PrefixChange == "[" or PrefixChange == "P" then
	 Notify({
		 Description = "idk why but this prefix breaks changing the prefix so pick smthing else alr?";
		 Title = "Nameless Admin";
		 Duration = 5;
		 
		 });
	 else
 writefile("Nameless-Admin\\Prefix.txt", PrefixChange)
 opt.prefix = PrefixChange
 Notify({
 Description = "Prefix saved to '" .. PrefixChange .. "'";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end
 end)
 
 --[ UTILITY ]--
 
 cmd.add({"chatlogs", "clogs"}, {"chatlogs (clogs)", "Open the chat logs"}, function()
	 gui.chatlogs()
 end)
 
 cmd.add({"gotocampos", "tocampos", "tcp"}, {"gotocampos (tocampos, tcp)", "Teleports you to your camera position works with free cam but freezes you"}, function()
 local player = game.Players.LocalPlayer
 local UserInputService = game:GetService("UserInputService")
  local function teleportPlayer()
	 local character = player.Character or player.CharacterAdded:wait(1)
	 local camera = game.Workspace.CurrentCamera
	 local cameraPosition = camera.CFrame.Position
	 character:SetPrimaryPartCFrame(CFrame.new(cameraPosition))
 end
		 local camera = game.Workspace.CurrentCamera
		 repeat wait() until camera.CFrame ~= CFrame.new()
 
		 teleportPlayer()
 end)
 
 cmd.add({"kanye"}, {"kanye", "Random kanye quote"}, function()
	local check = "https://api.kanye.rest/"
		 local final = game:HttpGet(check)
		 local final2 = string.gsub(final,'"quote"',"")
		 local final3 = string.gsub(final2,"[%{%:%}]","")
		  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(final3.." - Kanye West", 'All')
 end)
 
 -- [[ HAT ORBIT COMMANDS ]] --
 cmd.add({"hatorbit", "ho"}, {"hatorbit (ho)", "Hat orbit"}, function()
	-- [[ patched theres no point in using it ]] --
 wait();
 
 Notify({
 Description = "Hat orbit loaded, if you wanna orbit other people type in the chat .orbit playername";
 Title = "Nameless Admin";
 Duration = 10;
 
 });
	 local LC = game.Players.LocalPlayer
 local Name = LC.Name
 local Char = LC.Character
 
 local Humanoid = Char:FindFirstChildWhichIsA("Humanoid")
 local Root = Humanoid.RootPart
 
 local Accessories = Humanoid:GetAccessories()
 
 local Target = Char
 local TargetPos = Target.Humanoid.RootPart.Position
 
		 function findName(pname)
			 for i, v in ipairs(game.Players:GetPlayers()) do
				 if pname then
					 if string.match(v.Name:lower(), pname:lower()) or string.match(v.Character.Humanoid.DisplayName:lower(), pname:lower()) then
						 return v.Name
					 end
				 else
				 end
			 end
		 end
	 
		 function findChar(pname)
			 return game.Players:FindFirstChild(findName(pname)).Character
		 end
	 
		 local hats = {}
	 
		 if Target then
			 -- Loop through each hat in the target player's character
			 local character = Target
			 for _, hat in ipairs(character:GetChildren()) do
				 if hat:IsA("Accessory") then
					 hats[#hats+1] = hat
				 end
			 end
		 end
	 
		 local hatCount = #hats
		 if hatCount > 0 then
			 local angle = math.pi * 2 / hatCount
			 -- Loop through each hat again to add bodyposition and move hats
			 for i, hat in ipairs(hats) do
				 -- Add bodyposition to the handle and make it massless
				 local handle = hat.Handle
				 handle.AccessoryWeld:Remove()
	 
				 if handle then
					 local bodyPosition = Instance.new("BodyPosition", handle)
					 bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					 bodyPosition.P = Power
					 bodyPosition.D = Damping
	 
					 local bodyGyro = Instance.new("BodyGyro", handle)
					 bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					 bodyGyro.P = Power
					 bodyGyro.D = Damping
	 
					 -- Calculate position based on angle and Offset
					 local x = math.sin(Rotation + angle * (i-1)) * Offset
					 local z = math.cos(Rotation + angle * (i-1)) * Offset
	 
					 -- Set position of bodyposition
					 bodyPosition.Position = TargetPos + Vector3.new(x, Height, z)
				 end
			 end
	 
			 -- Rotate hats around target player
			 local function myCoroutine()
				 while wait(-9e999) do
					 Rotation = Rotation + (Speed / 20)
					 if Rotation >= math.pi * 2 then
						 Rotation = 0
					 end
	 
					 for i, hat in ipairs(hats) do
						 local handle = hat.Handle
						 local x = math.sin(Rotation + angle * (i-1)) * Offset
						 local z = math.cos(Rotation + angle * (i-1)) * Offset
	 
						 handle.BodyPosition.P = Power
						 handle.Velocity = Vector3.new(0, 5, 0)
						 handle.Massless = true
						 handle.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	 
						 handle.BodyGyro.CFrame = CFrame.lookAt(handle.Position + Vector3.new(0, handle.Position.Y, 0), Root.Position)
	 
						 if NormalSpin == true then
							 handle.BodyPosition.Position = TargetPos + Vector3.new(x + Target.Humanoid.MoveDirection.X, Height, z + Target.Humanoid.MoveDirection.Z)
						 end
	 
						 if EditingPos == false then
							 TargetPos = Target.Humanoid.RootPart.Position
						 end
					 end
				 end
			 end
	 
			 local myWrappedCoroutine = coroutine.wrap(myCoroutine)
	 
			 myWrappedCoroutine()
		 end
	 
		 function Mode2()
			 if Mode == 2 then
				 local Angle = math.pi * 2 / #hats -- number of hats in the circle
	 
				 function Loop()
					 if Mode == 2 then
						 -- Get the orientation of the root part
						 local RootOrientation = Target.Humanoid.RootPart.CFrame - Target.Humanoid.RootPart.Position
						 local RootRotation = RootOrientation
	 
						 for i, Hat in ipairs(hats) do
							 local HatRotation = RootRotation.Y + Angle * (i - 1) + Speed * tick()
							 local x = math.sin(HatRotation) * Offset
							 local z = math.cos(HatRotation) * Offset
	 
							 local HatPos = TargetPos + RootOrientation * Vector3.new(x, z, -Height)
							 Hat.Handle.BodyPosition.Position = HatPos
						 end
	 
						 wait()
						 Loop()
					 end
				 end
	 
				 Loop()
	 
				 for i, Hat in ipairs(hats) do
					 local Handle = Hat.Handle
	 
					 Hat.Handle.BodyPosition.Position = TargetPos
				 end
			 end
		 end
	 
	 
		 function Mode3()
			 if Mode == 3 then
				 for i = 1, #Accessories do
					 Accessories[i].Handle.BodyPosition.Position = TargetPos + Vector3.new(0, Height, 0)
					 wait(.1)
				 end
				 wait()
				 Mode3()
			 end
		 end
	 
		 function Mode4 ()
			 if Mode == 4 then
				 if not LC:GetMouse().Target then else
					 TargetPos = LC:GetMouse().Hit.Position
				 end
				 wait(-9e999)
				 Mode4()
			 end
		 end
	 
		 function Mode5 ()
			 local spiralPitch = 0
			 local spiralAngle = 0
	 
			 function Loop ()
				 if Mode == 5 then
					 spiralAngle = spiralAngle + Speed / 300
					 if spiralAngle >= math.pi * 10 then
						 spiralAngle = 0
					 end
	 
					 for i, hat in ipairs(hats) do
						 local handle = hat.Handle
						 if handle then
							 local x = math.sin(spiralAngle + i * spiralPitch) * (i * Offset / 8)
							 local y = i * (Height / 3)
							 local z = math.cos(spiralAngle + i * spiralPitch) * (i * Offset / 8)
							 handle.BodyPosition.Position = TargetPos - Vector3.new(0, 2, 0) + Vector3.new(x, y, z)
						 end
					 end
				 end
				 spiralPitch += Speed / 70
				 wait(-9e999)
				 Loop()
			 end
	 
			 Loop()
		 end
	 
		 function Mode6 ()
			 local stack1 = {}
			 local stack2 = {}
	 
			 for i = 1, #Accessories do
				 if i <= #Accessories / 2 then
					 stack1[#stack1 + 1] = Accessories[i]
				 else
					 stack2[#stack2 + 1] = Accessories[i]
				 end
			 end
	 
			 function Loop()
				 if Mode == 6 then
					 local angle = tick() * Speed
					 local x = math.sin(angle) * Offset
					 local z = math.cos(angle) * Offset
	 
					 for i, v in ipairs(stack1) do
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, i+Height,-z)
					 end
	 
					 for i, v in ipairs(stack2) do
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(-x, i+Height,z)
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode7()
			 local stack1 = {}
			 local stack2 = {}
			 local stack3 = {}
	 
			 for i = 1, #Accessories do
				 if i < #Accessories / 3 then
					 stack1[#stack1 + 1] = Accessories[i]
				 elseif i < #Accessories / 3 * 2 or i == #Accessories then
					 stack2[#stack2 + 1] = Accessories[i]
				 else
					 stack3[#stack3 + 1] = Accessories[i]
				 end
			 end
	 
	 
			 function Loop()
				 if Mode == 7 then
					 local angle = tick() * Speed
					 local x = math.sin(angle) * Offset
					 local z = math.cos(angle) * Offset
	 
					 for i, v in ipairs(stack1) do
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, i+Height, -z)
					 end
	 
					 for i, v in ipairs(stack2) do
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, i+Height, z)
					 end
	 
					 for i, v in ipairs(stack3) do
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(-x, i+Height, -z)
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode8()
			 if Mode == 8 then
				 local forward = workspace.CurrentCamera.CFrame.LookVector
				 local right = workspace.CurrentCamera.CFrame.RightVector
				 local up = workspace.CurrentCamera.CFrame.UpVector
				 local angle = math.pi * 2 / #hats * tick()
	 
				 for i, hat in ipairs(hats) do
					 local handle = hat.Handle
					 local x = right * (math.sin(angle * (i-1)) * Offset)
					 local y = up * (math.cos(angle * (i-1)) * Offset)
					 local z = forward * (Height+10)
					 local pos = workspace.CurrentCamera.CFrame.LookVector + z + x + y
					 local look = (workspace.CurrentCamera.CFrame.LookVector - pos).unit
	 
					 handle.BodyPosition.Position = pos + TargetPos + Vector3.new(0, 2, 0)
				 end
	 
				 wait()
				 Mode8()
			 end
		 end
	 
		 function Mode9 ()
			 local Left = {}
			 local Right = {}
	 
			 for i, v in pairs(Accessories) do
				 if (#Left < #Accessories / 2) then
					 Left[#Left + 1] = v
				 else
					 Right[#Right + 1] = v
				 end
			 end
	 
	 
			 function Loop ()
				 if Mode == 9 then
					 for i, v in ipairs(Left) do
						 local angle = tick() * Speed
						 local x = math.sin(angle + i) * Offset
						 local z = math.cos(angle + i) * Offset
	 
	 
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, Height, z)
					 end
	 
					 for i, v in ipairs(Right) do
						 local angle = tick() * Speed
						 local x = math.sin(angle + i) * Offset
						 local z = math.cos(angle + i) * Offset
	 
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(z, Height, x)
					 end
	 
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode10 ()
			 local Left = {}
			 local Right = {}
	 
			 for i, v in pairs(Accessories) do
				 if (#Left < #Accessories / 2) then
					 Left[#Left + 1] = v
				 else
					 Right[#Right + 1] = v
				 end
			 end
	 
	 
			 function Loop ()
				 if Mode == 10 then
					 for i, v in ipairs(Left) do
						 local angle = tick() * Speed
						 local x = math.sin(angle + i) * Offset
						 local z = math.cos(angle + i) * Offset
	 
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(z, x + Height, -x)
					 end
	 
					 for i, v in ipairs(Right) do
						 local angle = tick() * Speed
						 local x = math.sin(angle + i) * Offset
						 local z = math.cos(angle + i) * Offset
	 
						 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(-x, x + Height, -z)
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode11 ()
			 local OldOffset = Offset
	 
			 local Circle1 = {}
			 local Circle2 = {}
			 for i, v in pairs(Accessories) do
				 if (#Circle1 < #Accessories / 2) then
					 Circle1[#Circle1 + 1] = v
				 else
					 Circle2[#Circle2 + 1] = v
				 end
			 end
	 
			 function Loop ()
				 if Mode == 11 then
					 for i = 1, #Circle1 do
						 local angle = tick() * Speed
						 local x = -math.sin(angle + (i * angle)) * Offset
						 local y = math.cos(angle) / 2 * OldOffset
						 local z = math.cos(angle + (i * -angle)) * Offset
	 
						 Offset = math.sin(angle) / 2 * OldOffset
	 
						 local offset = CFrame.Angles(0,math.rad( Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x, Height+y, z)
						 Circle1[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
	 
					 for i = 1, #Circle2 do
						 local angle = tick() * Speed
						 local x = -math.sin(angle + (i * angle)) * Offset
						 local y = -math.cos(angle) / 2 * OldOffset
						 local z = math.cos(angle + (i * angle)) * Offset
	 
						 Offset = math.sin(angle) / 2 * OldOffset
	 
						 local offset = CFrame.Angles(0, math.rad(Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x, Height+y, z)
						 Circle2[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode12 ()
			 local Circle1 = {}
			 local Circle2 = {}
			 for i, v in pairs(Accessories) do
				 if (#Circle1 < #Accessories / 2) then
					 Circle1[#Circle1 + 1] = v
				 else
					 Circle2[#Circle2 + 1] = v
				 end
			 end
	 
			 function Loop ()
				 if Mode == 12 then
					 for i = 1, #Circle1 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * 5)) * Offset
						 local z = math.cos(angle + (i * 5)) * Offset
						 local offset = CFrame.Angles(0, math.rad(Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x, Height, z)
						 Circle1[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
	 
					 for i = 1, #Circle2 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * 5)) * Offset
						 local z = math.cos(angle + (i * 5)) * Offset
						 local offset = CFrame.Angles(0, math.rad(-Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x, Height + 2, z)
						 Circle2[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode13 ()
			 local Circle1 = {}
			 local Circle2 = {}
			 for i, v in pairs(Accessories) do
				 if (#Circle1 < #Accessories / 2) then
					 Circle1[#Circle1 + 1] = v
				 else
					 Circle2[#Circle2 + 1] = v
				 end
			 end
	 
			 function Loop ()
				 if Mode == 13 then
					 for i = 1, #Circle1 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * 5)) * Offset
						 local z = math.cos(angle + (i * 5)) * Offset
						 local offset = CFrame.Angles(0, math.rad(Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x + Offset * 2, Height, z)
						 Circle1[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
	 
					 for i = 1, #Circle2 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * 5)) * Offset
						 local z = math.cos(angle + (i * 5)) * Offset
						 local offset = CFrame.Angles(0, math.rad(Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x - Offset * 2, Height, z)
						 Circle2[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode14 ()
			 local Circle1 = {}
			 local Circle2 = {}
			 for i, v in pairs(Accessories) do
				 if (#Circle1 < #Accessories / 2) then
					 Circle1[#Circle1 + 1] = v
				 else
					 Circle2[#Circle2 + 1] = v
				 end
			 end
	 
			 function Loop ()
				 if Mode == 14 then
					 for i = 1, #Circle1 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * 5)) * Offset
						 local z = math.cos(angle + (i * 5)) * Offset
						 local offset = CFrame.Angles(0, math.rad(Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x + Offset * 2, Height, z)
						 Circle1[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
	 
					 for i = 1, #Circle2 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * 5)) * Offset
						 local z = math.cos(angle + (i * 5)) * Offset
						 local offset = CFrame.Angles(0, math.rad(-Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(x - Offset * 2, Height, z)
						 Circle2[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 function Mode15()
			 Height = -1
			 function Loop ()
				 if Mode == 15 then
					 for i = 1, #Accessories do
						 local offset = CFrame.Angles(0, math.rad(Target.Humanoid.RootPart.Orientation.Y), 0) * Vector3.new(0, Height, -i * Offset / 5)
						 Accessories[i].Handle.BodyPosition.Position = TargetPos + offset
					 end
	 
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
			 wait()
		 end
	 
		 function Mode16()
			 local function Loop()
				 if Mode == 16 then
					 for i, v in pairs(Accessories) do
						 local x = math.cos(math.random(1, 255) + (i + 1)) * Offset
						 local z = math.sin(math.random(1, 255) + (i + 1)) * Offset
	 
						 local m = math.random(1, 13)
						 if m == 1 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, Height, z)
						 elseif m == 2 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(z, Height, x)
						 elseif m == 3 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(-x, Height, z)
						 elseif m == 4 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, Height, -z)
						 elseif m == 5 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, z, z)
						 elseif m == 6 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, x, z)
						 elseif m == 7 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(-x, x, z)
						 elseif m == 8 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, -x, z)
						 elseif m == 9 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, x, -z)
						 elseif m == 10 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(-x, z, z)	
						 elseif m == 11 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, -z, z)	
						 elseif m == 12 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(x, z, -z)	
						 elseif m == 13 then
							 v.Handle.BodyPosition.Position = TargetPos + Vector3.new(z, z, z)		
						 end
					 end
				 end
				 wait()
				 Loop()
			 end
	 
			 Loop()
		 end
	 
		 function Mode17()
			 local OldOffset = Offset
			 local OldHeight = Height
	 
			 local Circle1 = {}
			 local Circle2 = {}
			 for i, v in pairs(Accessories) do
				 if (#Circle1 < #Accessories / 2) then
					 Circle1[#Circle1 + 1] = v
				 else
					 Circle2[#Circle2 + 1] = v
				 end
			 end
	 
			 function Loop ()
				 if Mode == 17 then
					 for i = 1, #Circle1 do
						 local angle = tick() * Speed
						 local x = math.sin(angle + (i * #hats)) * Offset
						 local z = math.cos(angle + (i * #hats)) * Offset
	 
						 Offset = math.sin(angle) * OldOffset
						 Height = math.cos(angle) * OldHeight
	 
						 Circle1[i].Handle.BodyPosition.Position = TargetPos + Vector3.new(x, -Height, z)
					 end
	 
					 for i = 1, #Circle2 do
						 local angle = tick() * Speed+1
						 local x = math.cos(angle + (i * #hats)) * Offset
						 local z = math.sin(angle + (i * #hats)) * Offset
	 
						 Offset = math.sin(angle ) * OldOffset
						 Height = math.cos(angle) * OldHeight
	 
						 Circle2[i].Handle.BodyPosition.Position = TargetPos + Vector3.new(x, Height, z)
					 end
					 wait()
					 Loop()
				 end
			 end
	 
			 Loop()
		 end
	 
		 local connect = LC.Chatted:Connect(function(chat)
			 local Split = chat:lower():split(" ")
	 
			 local C1 = Split[1]
			 local C2 = Split[2]
	 
			 if C1 == ".mode" then
				 Mode = tonumber(C2)
				 if C2 == "1" then
					 EditingPos = false
					 NormalSpin = true
				 elseif C2 == "2" then
					 EditingPos = false
					 NormalSpin = false
					 Mode2()		
				 elseif C2 == "3" then
					 EditingPos = false
					 NormalSpin = false
					 Mode3()
				 elseif C2 == "4" then
					 EditingPos = true
					 NormalSpin = true
					 Mode4()
				 elseif C2 == "5" then
					 EditingPos = false
					 NormalSpin = false
					 Mode5()
				 elseif C2 == "6" then
					 EditingPos = false
					 NormalSpin = false
					 Mode6()
				 elseif C2 == "7" then
					 EditingPos = false
					 NormalSpin = false
					 Mode7()
				 elseif C2 == "8" then
					 EditingPos = false
					 NormalSpin = false
					 Mode8()
				 elseif C2 == "9" then
					 EditingPos = false
					 NormalSpin = false
					 Mode9()
				 elseif C2 == "10" then
					 EditingPos = false
					 NormalSpin = false
					 Mode10()
				 elseif C2 == "11" then
					 EditingPos = false
					 NormalSpin = false
					 Mode11()
				 elseif C2 == "12" then
					 EditingPos = false
					 NormalSpin = false
					 Mode12()
				 elseif C2 == "13" then
					 EditingPos = false
					 NormalSpin = false
					 Mode13()
				 elseif C2 == "14" then
					 EditingPos = false
					 NormalSpin = false
					 Mode14()
				 elseif C2 == "15" then
					 EditingPos = false
					 NormalSpin = false
					 Mode15()
				 elseif C2 == "16" then
					 EditingPos = false
					 NormalSpin = false
					 Mode16()
				 elseif C2 == "17" then
					 EditingPos = false
					 NormalSpin = false
					 Mode17()
				 end
	 
			 elseif C1 == ".offset" then
				 Offset = tonumber(C2)
			 elseif C1 == ".speed" then
				 Speed = tonumber(C2)
			 elseif C1 == ".height" then
				 Height = tonumber(C2)
			 elseif C1 == ".power" then
				 Power = tonumber(C2)
			 elseif C1 == ".orbit" then
				 if C2 == "me" then
					 Target = Char
				 elseif C2 == "random" then
					 local randomPlayer = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())]
					 Target = randomPlayer.Character	
				 elseif C2 == "nearest" then
					 local minDistance = math.huge
					 for _, player in pairs(game.Players:GetPlayers()) do
						 if player.Character and player.Character ~= Char then
							 local distance = (player.Character.HumanoidRootPart.Position - Char.HumanoidRootPart.Position).magnitude
							 if distance < minDistance then
								 minDistance = distance
								 Target = player.Character
							 end
						 end
					 end
				 elseif C2 == "farthest" then
					 local maxDistance = -math.huge
					 for _, player in pairs(game.Players:GetPlayers()) do
						 if player.Character and player.Character ~= Char then
							 local distance = (player.Character.HumanoidRootPart.Position - Char.HumanoidRootPart.Position).magnitude
							 if distance > maxDistance then
								 maxDistance = distance
								 Target = player.Character
							 end
						 end
					 end
				 else
					 Target = findChar(C2)
				 end
			 elseif C1 == ".blockhats" then
				 for i, v in pairs(Accessories) do
					 if v.Handle:FindFirstChild("Mesh") then
						 v.Handle:FindFirstChild("Mesh"):Remove()
					 else
						 v.Handle:FindFirstChild("SpecialMesh"):Remove()
					 end
				 end
			 elseif C1 == ".cmds" then
				 for i = 1, #Commands do
					 print(Commands[i])
					 wait()
				 end
			 end
		 end)
	 
		 Humanoid.Died:Connect(function()
			 connect:Disconnect()
		 end)
	 
		 Root.CFrame += Vector3.new(0, 10, 0)
		 Root.Anchored = true
		 for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then game:GetService("RunService").Heartbeat:connect(function() v.Velocity = Vector3.new(-30, 0, 0) v.Massless = true end) end  end
		 wait(1)
		 Root.Anchored = false
 end)
 
 cmd.add({"ospeed", "orbitspeed"}, {"orbitspeed <speed> (ospeed)", "Hat orbit command"}, function(...)
		 Speed = tonumber(...)
 end)
 
 cmd.add({"omode", "orbitmode"}, {"orbitmode <1-17> (omode)", "Hat orbit command"}, function(...)
		 Mode = tonumber(...)
		 if (...) == "1" then
			 EditingPos = false
			 NormalSpin = true
		 elseif (...) == "2" then
			 EditingPos = false
			 NormalSpin = false
			 Mode2()		
		 elseif (...) == "3" then
			 EditingPos = false
			 NormalSpin = false
			 Mode3()
		 elseif (...) == "4" then
			 EditingPos = true
			 NormalSpin = true
			 Mode4()
		 elseif (...) == "5" then
			 EditingPos = false
			 NormalSpin = false
			 Mode5()
		 elseif (...) == "6" then
			 EditingPos = false
			 NormalSpin = false
			 Mode6()
		 elseif (...) == "7" then
			 EditingPos = false
			 NormalSpin = false
			 Mode7()
		 elseif (...) == "8" then
			 EditingPos = false
			 NormalSpin = false
			 Mode8()
		 elseif (...) == "9" then
			 EditingPos = false
			 NormalSpin = false
			 Mode9()
		 elseif (...) == "10" then
			 EditingPos = false
			 NormalSpin = false
			 Mode10()
		 elseif (...) == "11" then
			 EditingPos = false
			 NormalSpin = false
			 Mode11()
		 elseif (...) == "12" then
			 EditingPos = false
			 NormalSpin = false
			 Mode12()
		 elseif (...) == "13" then
			 EditingPos = false
			 NormalSpin = false
			 Mode13()
		 elseif (...) == "14" then
			 EditingPos = false
			 NormalSpin = false
			 Mode14()
		 elseif (...) == "15" then
			 EditingPos = false
			 NormalSpin = false
			 Mode15()
		 elseif (...) == "16" then
			 EditingPos = false
			 NormalSpin = false
			 Mode16()
		 elseif (...) == "17" then
			 EditingPos = false
			 NormalSpin = false
			 Mode17()
		 end
 end)
 
 cmd.add({"orbitpower", "opower"}, {"orbitpower <power> (opower)", "Hat orbit command"}, function(...)
		 Power = tonumber(...)
 end)
 
 cmd.add({"orbitheight", "oheight"}, {"orbitheight <height> (oheight)", "Hat orbit command"}, function(...)
		 Height = tonumber(...)
 end)
 
 cmd.add({"orbitoffset", "offset"}, {"orbitoffset <height> (offset)", "Hat orbit command"}, function(...)
		 Offset = tonumber(...)
 end)
 
 cmd.add({"clickfling", "mousefling"}, {"mousefling (clickfling)", "Fling a player by clicking them"}, function()
	 local Players = game:GetService("Players")
	 local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	 
	 Mouse.Button1Down:Connect(function()
		 local Target = Mouse.Target
		 if Target and Target.Parent and Target.Parent:IsA("Model") and Players:GetPlayerFromCharacter(Target.Parent) then
			 local PlayerName = Players:GetPlayerFromCharacter(Target.Parent).Name
	 local player = game.Players.LocalPlayer
	 local Targets = {PlayerName}
	 
	 local Players = game:GetService("Players")
	 local Player = Players.LocalPlayer
	 
	 local AllBool = false
	 
	 local GetPlayer = function(Name)
		Name = Name:lower()
		if Name == "all" or Name == "others" then
			AllBool = true
			return
		elseif Name == "random" then
			local GetPlayers = Players:GetPlayers()
			if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
			return GetPlayers[math.random(#GetPlayers)]
		elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
			for _,x in next, Players:GetPlayers() do
				if x ~= Player then
					if x.Name:lower():match("^"..Name) then
						return x;
					elseif x.DisplayName:lower():match("^"..Name) then
						return x;
					end
				end
			end
		else
			return
		end
	 end
	 
	 local Message = function(_Title, _Text, Time)
print(_Title)
print(_Text)
print(Time)
	 end
	 
	 local SkidFling = function(TargetPlayer)
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Humanoid and Humanoid.RootPart
	 
		local TCharacter = TargetPlayer.Character
		local THumanoid
		local TRootPart
		local THead
		local Accessory
		local Handle
	 
		if TCharacter:FindFirstChildOfClass("Humanoid") then
			THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
		end
		if THumanoid and THumanoid.RootPart then
			TRootPart = THumanoid.RootPart
		end
		if TCharacter:FindFirstChild("Head") then
			THead = TCharacter.Head
		end
		if TCharacter:FindFirstChildOfClass("Accessory") then
			Accessory = TCharacter:FindFirstChildOfClass("Accessory")
		end
		if Accessoy and Accessory:FindFirstChild("Handle") then
			Handle = Accessory.Handle
		end
	 
		if Character and Humanoid and RootPart then
			if RootPart.Velocity.Magnitude < 50 then
				getgenv().OldPos = RootPart.CFrame
			end
			if THumanoid and THumanoid.Sit and not AllBool then
			end
			if THead then
				workspace.CurrentCamera.CameraSubject = THead
			elseif not THead and Handle then
				workspace.CurrentCamera.CameraSubject = Handle
			elseif THumanoid and TRootPart then
				workspace.CurrentCamera.CameraSubject = THumanoid
			end
			if not TCharacter:FindFirstChildWhichIsA("BasePart") then
				return
			end
			
			local FPos = function(BasePart, Pos, Ang)
				RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
				Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
				RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
				RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
			end
			
			local SFBasePart = function(BasePart)
				local TimeToWait = 2
				local Time = tick()
				local Angle = 0
	 
				repeat
					if RootPart and THumanoid then
						if BasePart.Velocity.Magnitude < 50 then
							Angle = Angle + 100
	 
							FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
						else
							FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()
							
							FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
							task.wait()
	 
							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
							task.wait()
						end
					else
						break
					end
				until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
			end
			
			workspace.FallenPartsDestroyHeight = 0/0
			
			local BV = Instance.new("BodyVelocity")
			BV.Name = "EpixVel"
			BV.Parent = RootPart
			BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
			BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
			
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			
			if TRootPart and THead then
				if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
					SFBasePart(THead)
				else
					SFBasePart(TRootPart)
				end
			elseif TRootPart and not THead then
				SFBasePart(TRootPart)
			elseif not TRootPart and THead then
				SFBasePart(THead)
			elseif not TRootPart and not THead and Accessory and Handle then
				SFBasePart(Handle)
			else
			end
			
			BV:Destroy()
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			workspace.CurrentCamera.CameraSubject = Humanoid
			
			repeat
				RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
				Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
				Humanoid:ChangeState("GettingUp")
				table.foreach(Character:GetChildren(), function(_, x)
					if x:IsA("BasePart") then
						x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
					end
				end)
				task.wait()
			until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
			workspace.FallenPartsDestroyHeight = getgenv().FPDH
		else
		end
	 end
	 
	 getgenv().Welcome = true
	 if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
	 
	 if AllBool then
		for _,x in next, Players:GetPlayers() do
			SkidFling(x)
		end
	 end
	 
	 for _,x in next, Targets do
		if GetPlayer(x) and GetPlayer(x) ~= Player then
			if GetPlayer(x).UserId ~= 1414978355 then
				local TPlayer = GetPlayer(x)
				if TPlayer then
					SkidFling(TPlayer)
				end
			else
			end
		elseif not GetPlayer(x) and not AllBool then
		end
	 end
		 end
	 end)
 end)
 
 cmd.add({"ping"}, {"ping", "Shows your ping"}, function()
 -- Gui to Lua
 -- Version: 3.2
 
 -- Instances:
 
 local Ping = Instance.new("ScreenGui")
 local Pingtext = Instance.new("TextLabel")
 local UICorner = Instance.new("UICorner")
 local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
 
 
 --Properties:
 
 Ping.Name = "Ping"
 Ping.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
 Ping.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 Ping.ResetOnSpawn = false
 
 Pingtext.Name = "Pingtext"
 Pingtext.Parent = Ping
 Pingtext.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
 Pingtext.BackgroundTransparency = 0.140
 Pingtext.Position = UDim2.new(0, 0, 0, 48)
 Pingtext.Size = UDim2.new(0, 201, 0, 35)
 Pingtext.Font = Enum.Font.SourceSans
 Pingtext.Text = "FPS:"
 Pingtext.TextColor3 = Color3.fromRGB(255, 255, 255)
 Pingtext.TextScaled = true
 Pingtext.TextSize = 14.000
 Pingtext.TextWrapped = true
 
 UICorner.CornerRadius = UDim.new(1, 0)
 UICorner.Parent = Pingtext
 
 UIAspectRatioConstraint.Parent = Pingtext
 UIAspectRatioConstraint.AspectRatio = 5.743
 
 local script = Instance.new('LocalScript', Pingtext)
 local RunService = game:GetService("RunService")
 RunService.RenderStepped:Connect(function(ping) 
 script.Parent.Text = ("Ping: " ..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(math.round(2/ping))) -- your ping
 end)
		 end)
 
		 cmd.add({"fps"}, {"fps", "Shows your fps"}, function()
 -- Gui to Lua
 -- Version: 3.2
 
 -- Instances:
 
 local Fps = Instance.new("ScreenGui")
 local Fpstext = Instance.new("TextLabel")
 local UICorner = Instance.new("UICorner")
 local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
 
 
 --Properties:
 
 Fps.Name = "Fps"
 Fps.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
 Fps.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 Fps.ResetOnSpawn = false
 
 Fpstext.Name = "Fpstext"
 Fpstext.Parent = Fps
 Fpstext.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
 Fpstext.BackgroundTransparency = 0.140
 Fpstext.Position = UDim2.new(0, 0, 0, 6)
 Fpstext.Size = UDim2.new(0, 201, 0, 35)
 Fpstext.Font = Enum.Font.SourceSans
 Fpstext.Text = "FPS:"
 Fpstext.TextColor3 = Color3.fromRGB(255, 255, 255)
 Fpstext.TextScaled = true
 Fpstext.TextSize = 14.000
 Fpstext.TextWrapped = true
 
 UICorner.CornerRadius = UDim.new(1, 0)
 UICorner.Parent = Fpstext
 
 UIAspectRatioConstraint.Parent = Fpstext
 UIAspectRatioConstraint.AspectRatio = 5.743
 
 local script = Instance.new('LocalScript', Fpstext)
 local RunService = game:GetService("RunService")
 RunService.RenderStepped:Connect(function(frame) 
 script.Parent.Text = ("FPS: "..math.round(1/frame)) 
 end)
		 end)
 
 cmd.add({"commands", "cmds"}, {"commands (cmds)", "Open the command list"}, function()
	 gui.commands()
 end)
 
 cmd.add({"commandcount", "cc"}, {"commandcount (cc)", "Counds how many commands NA has"}, function()
 
 Notify({
	 Description = "Nameless Admin currently has ".. commandcount .. " commands";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
	 });
 end)
 
 hiddenfling = false
 cmd.add({"walkfling", "wfling"}, {"walkfling (wfling) [THANKS TO X]", "probably the best fling lol"}, function()
	 Notify({
		 Description = "Walkfling enabled";
		 Title = "Nameless Admin";
		 Duration = 5;
		 
		 });
	 if game:GetService("ReplicatedStorage"):FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		 hiddenfling = true
	 else
		 hiddenfling = true
		 detection = Instance.new("Decal")
		 detection.Name = "juisdfj0i32i0eidsuf0iok"
		 detection.Parent = game:GetService("ReplicatedStorage")
		 local function fling()
			 local hrp, c, vel, movel = nil, nil, nil, 0.1
			 while true do
				 game:GetService("RunService").Heartbeat:Wait()
				 if hiddenfling then
					 local lp = game.Players.LocalPlayer
					 while hiddenfling and not (c and c.Parent and hrp and hrp.Parent) do
						 game:GetService("RunService").Heartbeat:Wait()
						 c = lp.Character
						 hrp = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
					 end
					 if hiddenfling then
						 vel = hrp.Velocity
						 hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
						 game:GetService("RunService").RenderStepped:Wait()
						 if c and c.Parent and hrp and hrp.Parent then
							 hrp.Velocity = vel
						 end
						 game:GetService("RunService").Stepped:Wait()
						 if c and c.Parent and hrp and hrp.Parent then
							 hrp.Velocity = vel + Vector3.new(0, movel, 0)
							 movel = movel * -1
						 end
					 end
				 end
			 end
		 end
		 
		 fling()
	 end
 end)
 
 cmd.add({"unwalkfling", "unwfling"}, {"unwalkfling (unwfling)", "stop the walkfling command"}, function()
	 Notify({
		 Description = "Walkfling disabled";
		 Title = "Nameless Admin";
		 Duration = 5;
		 
		 });
		 hiddenfling = false
 end)
 
 cmd.add({"fling3"}, {"fling3 <player>", "another variant of fling"}, function(...)
	 oldcframe = Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	 
 User = (...)
 Target = getPlr(User)
	 
			 hiddenfling = true
			 
 if game:GetService("ReplicatedStorage"):FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		 hiddenfling = true
	 else
		 detection = Instance.new("Decal")
		 detection.Name = "juisdfj0i32i0eidsuf0iok"
		 detection.Parent = game:GetService("ReplicatedStorage")
		 local function fling()
			 local hrp, c, vel, movel = nil, nil, nil, 0.1
			 while true do
				 game:GetService("RunService").Heartbeat:Wait()
				 if hiddenfling then
					 local lp = game.Players.LocalPlayer
					 while hiddenfling and not (c and c.Parent and hrp and hrp.Parent) do
						 game:GetService("RunService").Heartbeat:Wait()
						 c = lp.Character
						 hrp = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
					 end
					 if hiddenfling then
						 vel = hrp.Velocity
						 hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
						 game:GetService("RunService").RenderStepped:Wait()
						 if c and c.Parent and hrp and hrp.Parent then
							 hrp.Velocity = vel
						 end
						 game:GetService("RunService").Stepped:Wait()
						 if c and c.Parent and hrp and hrp.Parent then
							 hrp.Velocity = vel + Vector3.new(0, movel, 0)
							 movel = movel * -1
						 end
					 end
				 end
			 end
		 end
		 fling()
			 end
			 Player.Character.Humanoid:SetStateEnabled("Seated", false)
			 Player.Character.Humanoid.Sit = true
			 if User == "all" or User == "others" then
				 for _,x in next, game.Players:GetPlayers() do
					 for i=1, 10 do
						 wait(0.017)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
						 wait(0.01)
						 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
						 end
					 end
			 else
		 for i=1, 10 do
		 wait(0.017)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
		 wait(0.01)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
		 end
		 end
		 sFLY(true)
		 speedofthevfly = 1
		 wait(0.3)
		 Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
		 wait(0.13)
				 Player.Character.Humanoid:SetStateEnabled("Seated", true)
					 Player.Character.Humanoid.Sit = false
		 FLYING = false
			 game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
			 hiddenfling = false
 end)
 
 cmd.add({"rjre", "rejoinrefresh"}, {"rjre (rejoinrefresh)", "Rejoins and teleports you to the position where you were before"}, function()
 
	 queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
 
	 
	 if not DONE then
	   DONE = true
	   local qot = print("a")
	   local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	   if hrp then
		 qot = "task.spawn(function() end) repeat wait() until game and game:IsLoaded() local lp = game:GetService('Players').LocalPlayer local char = lp.Character or lp.CharacterAdded:Wait() repeat char:WaitForChild('HumanoidRootPart').CFrame = CFrame.new("..tostring(hrp.CFrame)..") wait() until (Vector3.new("..tostring(hrp.Position)..") - char:WaitForChild('HumanoidRootPart').Position).Magnitude < 10"
	   end
	   queueteleport(qot)
	   game:GetService("TeleportService"):TeleportCancel()
		 game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	 end
		 end)
 
 cmd.add({"rejoin", "rj"}, {"rejoin (rj)", "Rejoin the game"}, function()
	 game:GetService("TeleportService"):Teleport(game.PlaceId)
	 wait()
	 
 
 
 wait();
 
 Notify({
 Description = "Rejoining...";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end)
 
 wrap(function()
	 --i am so not putting an emulator as a command here
 end)
 
 --[ LOCALPLAYER ]--
 local function respawn()
 cf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
 game.Players.LocalPlayer.Character.Humanoid.Health = 0
 player.CharacterAdded:wait(1); wait(0.2);
	 character:WaitForChild("HumanoidRootPart").CFrame = cf
	 end
 
 local function refresh()
 cf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
 game.Players.LocalPlayer.Character.Humanoid.Health = 0
 player.CharacterAdded:wait(1); wait(0.2);
	 character:WaitForChild("HumanoidRootPart").CFrame = cf
 end
 
 local abort = 0
 local function getTools(amt)
	 if not amt then amt = 1 end
	 local toolAmount, grabbed = 0, {}
	 local lastCF = character.PrimaryPart.CFrame
	 local ab = abort
	 
	 for i, v in pairs(localPlayer:FindFirstChildWhichIsA("Backpack"):GetChildren()) do
		 if v:IsA("BackpackItem") then
			 toolAmount = toolAmount + 1
		 end
	 end
	 if toolAmount >= amt then return localPlayer:FindFirstChildWhichIsA("Backpack"):GetChildren() end
	 if not localPlayer:FindFirstChildWhichIsA("Backpack"):FindFirstChildWhichIsA("BackpackItem") then return end
	 
	 repeat
		 repeat wait() until localPlayer:FindFirstChildWhichIsA("Backpack") or ab ~= abort
		 backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
		 wrap(function()
			 repeat wait() until backpack:FindFirstChildWhichIsA("BackpackItem")
			 for _, tool in pairs(backpack:GetChildren()) do
				 if #grabbed >= amt or ab ~= abort then break end
				 if tool:IsA("BackpackItem") then
					 tool.Parent = localPlayer
					 table.insert(grabbed, tool)
				 end
			 end
		 end)
		 
		 respawn()
		 wait(.1)
	 until
		 #grabbed >= amt or ab ~= abort
	 
	 repeat wait() until localPlayer.Character and tostring(localPlayer.Character) ~= "respawn_" and localPlayer.Character == character
	 wait(.2)
	 
	 repeat wait() until localPlayer:FindFirstChildWhichIsA("Backpack") or ab ~= abort
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 for _, tool in pairs(grabbed) do
		 if tool:IsA("BackpackItem") then
			 tool.Parent = backpack
		 end
	 end
	 wrap(function()
		 repeat wait() until character.PrimaryPart
		 wait(.2)
		 character:SetPrimaryPartCFrame(lastCF)
	 end)
	 wait(.2)
	 return grabbed
 end
 
 cmd.add({"joke"}, {"joke", "Random joke generator"}, function()
   coroutine.wrap(function()
		 local HttpService = game:GetService('HttpService')
		 local check = "https://official-joke-api.appspot.com/jokes/programming/random"
		 local final1 = game:HttpGet(check)
		 local final = string.gsub(final1, "[%[%]]", "")
		 local decoded = HttpService:JSONDecode(final)
		 
			  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(decoded.setup, 'All')
		 wait(2)
			  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(decoded.punchline, 'All')
   end)()
 
 end)
 cmd.add({"idiot"}, {"idiot <player>", "Tell someone that they are an idiot"}, function(...)
			 local old = getChar().HumanoidRootPart.CFrame
 
 Username = (...)
 
	 Players = game:GetService("Players")
		 HRP = game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored
		 
 
 target = getPlr(Username)
 
	 getChar().HumanoidRootPart.CFrame = target.Character.Humanoid.RootPart.CFrame * CFrame.new(0, 1, 4)
 local message = "Hey " .. target.Name .. ""
  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, 'All')
 wait(1)
  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('Sorry to tell you this, but..', 'All')
 wait(1)
  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('You are an idiot!', 'All')
  wait(1)
   game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('HAHAHA!', 'All')
 wait(1)
	 getChar():WaitForChild("HumanoidRootPart").CFrame = old
 
 
 end)
 
 cmd.add({"bringto"}, {"bringto (playertobring) [playertobringto]", "Brings a player to another player"}, function(h, d)
 local target1 = getPlr(h)
 local target2 = getPlr(d)
 
 local old = getChar().HumanoidRootPart.CFrame
 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
 
 local distance = 1
 local gripPosition = target2.Character.HumanoidRootPart.Position - target2.Character.HumanoidRootPart.CFrame.lookVector * distance
 wait(0.2)
 
 local Target = target1
 local Character = Player.Character        
 local PlayerGui = Player:waitForChild("PlayerGui")
 local Backpack = Player:waitForChild("Backpack")
 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
 local RootPart = Character and Humanoid and Humanoid.RootPart or false
 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
 if not Humanoid or not RootPart or not RightArm then
	 return
 end
 Humanoid:UnequipTools()
 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
 if not MainTool or not MainTool:FindFirstChild("Handle") then
	 return
 end
 local TPlayer = getPlr(Target)
 local TCharacter = TPlayer and TPlayer.Character
 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
 if not THumanoid or not TRootPart then
	 return
 end
 Character.Humanoid.Name = "DAttach"
 local l = Character["DAttach"]:Clone()
 l.Parent = Character
 l.Name = "Humanoid"
 wait()
 Character["DAttach"]:Destroy()
 game.Workspace.CurrentCamera.CameraSubject = Character
 Character.Animate.Disabled = true
 wait()
 Character.Animate.Disabled = false
 Character.Humanoid:EquipTool(MainTool)
 wait()
 CF = Player.Character.PrimaryPart.CFrame
 if firetouchinterest then
	 local flag = false
	 task.defer(function()
		 MainTool.Handle.AncestryChanged:wait()
		 flag = true
	 end)
	 repeat
		 firetouchinterest(MainTool.Handle, TRootPart, 0)
		 firetouchinterest(MainTool.Handle, TRootPart, 1)
		 wait()
		 Player.Character.HumanoidRootPart.CFrame = CF
	 until flag
 else
	 Player.Character.HumanoidRootPart.CFrame =
	 TCharacter.HumanoidRootPart.CFrame
	 wait()
	 Player.Character.HumanoidRootPart.CFrame =
	 TCharacter.HumanoidRootPart.CFrame
	 wait()
	 Player.Character.HumanoidRootPart.CFrame = CF
	 wait()
 end
 wait(.3)
 Player.Character:SetPrimaryPartCFrame(CF)
 if Humanoid.RigType == Enum.HumanoidRigType.R6 then
	 Character["Right Arm"].RightGrip:Destroy()
 else
	 Character["RightHand"].RightGrip:Destroy()
	 Character["RightHand"].RightGripAttachment:Destroy()
 end
	 
 wait(4)
 CF = Player.Character.HumanoidRootPart.CFrame
 player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 
 -- Teleport the first player to the position next to the second player
 getChar().HumanoidRootPart.CFrame = CFrame.new(gripPosition) + Vector3.new(0, 3, 0)
 
 -- Tween the first player to the second player's position
 local tween = game:GetService("TweenService"):Create(getChar().HumanoidRootPart, TweenInfo.new(1), {CFrame = target2.Character.HumanoidRootPart.CFrame})
 tween:Play()
 
 tool.AncestryChanged:Wait() 
 if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
	 --plr.Character["Right Arm"]:Destroy()
	 game.Players.LocalPlayer.Character["Right Arm"].RightGrip:Destroy() --r6
 elseif plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
	 --plr.Character["RightHand"]:Destroy()
	 game.Players.LocalPlayer.Character.RightHand.RightGrip:Destroy() --r15
 end
 wait(0.07)
 respawn()
 end)
 
 cmd.add({"accountage", "accage"}, {"accountage <player> (accage)", "Tells the account age of a player in the server"}, function(...)
 Username = (...)
 
 target = getPlr(Username)
 teller = target.AccountAge
 accountage = "The account age of " .. target.Name .. " is " .. teller
 
 
		 
 
 
 wait();
 
 Notify({
 Description = accountage;
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 end)
 
 cmd.add({"notoolscripts", "nts"}, {"notoolscripts (nts)", "Destroy all scripts in backpack"}, function()
	 print("test")
	 local bp = player:FindFirstChildWhichIsA("Backpack")
	 for _, item in pairs(bp:GetChildren()) do
		 for _, obj in pairs(item:GetDescendants()) do
			 if obj:IsA("LocalScript") or obj:IsA("Script") then
				 obj.Disabled = true
				 obj:Destroy()
			 end
		 end
	 end
 end)
 
 cmd.add({"spblockspam", "starterblockscam"}, {"spblockspam (starterblockspam)", "Spam blocks in any game that has the starter place"}, function()
 anniblockspam = true
 end)
 
 cmd.add({"febtools"}, {"febtools", "Move parts that are your hats"}, function()
 -- [[ THANKS TO ROUXHAVER FOR THIS ]] --
 -- check out his github - https://github.com/rouxhaver
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local LocalPlayer = Players.LocalPlayer
 
 if not getgenv().Network then
	 getgenv().Network = {
		 BaseParts = {};
		 FakeConnections = {};
		 Connections = {};
		 Output = {
			 Enabled = true;
			 Prefix = "[NETWORK] ";
			 Send = function(Type,Output,BypassOutput)
				 if typeof(Type) == "function" and (Type == print or Type == warn or Type == error) and typeof(Output) == "string" and (typeof(BypassOutput) == "nil" or typeof(BypassOutput) == "boolean") then
					 if Network["Output"].Enabled == true or BypassOutput == true then
						 Type(Network["Output"].Prefix..Output);
					 end;
				 elseif Network["Output"].Enabled == true then
					 error(Network["Output"].Prefix.."Output Send Error : Invalid syntax.");
				 end;
			 end;
		 };
		 CharacterRelative = false;
	 }
 
	 Network["Output"].Send(print,": Loading.")
	 Network["Velocity"] = Vector3.new(14.46262424,14.46262424,14.46262424); --exactly 25.1 magnitude
	 Network["RetainPart"] = function(Part,ReturnFakePart) --function for retaining ownership of unanchored parts
		 assert(typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(workspace),Network["Output"].Prefix.."RetainPart Error : Invalid syntax: Arg1 (Part) must be a BasePart which is a descendant of workspace.")
		 assert(typeof(ReturnFakePart) == "boolean" or typeof(ReturnFakePart) == "nil",Network["Output"].Prefix.."RetainPart Error : Invalid syntax: Arg2 (ReturnFakePart) must be a boolean or nil.")
		 if not table.find(Network["BaseParts"],Part) then
			 if Network.CharacterRelative == true then
				 local Character = LocalPlayer.Character
				 if Character and Character.PrimaryPart then
					 local Distance = (Character.PrimaryPart.Position-Part.Position).Magnitude
					 if Distance > 1000 then
						 Network["Output"].Send(warn,"RetainPart Warning : PartOwnership not applied to BasePart "..Part:GetFullName()..", as it is more than "..gethiddenproperty(LocalPlayer,"MaximumSimulationRadius").." studs away.")
						 return false
					 end
				 else
					 Network["Output"].Send(warn,"RetainPart Warning : PartOwnership not applied to BasePart "..Part:GetFullName()..", as the LocalPlayer Character's PrimaryPart does not exist.")
					 return false
				 end
			 end
			 table.insert(Network["BaseParts"],Part)
			 Part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
			 Network["Output"].Send(print,"PartOwnership Output : PartOwnership applied to BasePart "..Part:GetFullName()..".")
			 if ReturnFakePart == true then
				 return FakePart
			 end
		 else
			 Network["Output"].Send(warn,"RetainPart Warning : PartOwnership not applied to BasePart "..Part:GetFullName()..", as it already active.")
			 return false
		 end
	 end
 
	 Network["RemovePart"] = function(Part) --function for removing ownership of unanchored part
		 assert(typeof(Part) == "Instance" and Part:IsA("BasePart"),Network["Output"].Prefix.."RemovePart Error : Invalid syntax: Arg1 (Part) must be a BasePart.")
		 local Index = table.find(Network["BaseParts"],Part)
		 if Index then
			 table.remove(Network["BaseParts"],Index)
			 Network["Output"].Send(print,"RemovePart Output: PartOwnership removed from BasePart "..Part:GetFullName()..".")
		 else
			 Network["Output"].Send(warn,"RemovePart Warning : BasePart "..Part:GetFullName().." not found in BaseParts table.")
		 end
	 end
 
	 Network["SuperStepper"] = Instance.new("BindableEvent") --make super fast event to connect to
	 for _,Event in pairs({RunService.Stepped,RunService.Heartbeat}) do
		 Event:Connect(function()
			 return Network["SuperStepper"]:Fire(Network["SuperStepper"],tick())
		 end)
	 end
 
	 Network["PartOwnership"] = {};
	 Network["PartOwnership"]["PreMethodSettings"] = {};
	 Network["PartOwnership"]["Enabled"] = false;
	 Network["PartOwnership"]["Enable"] = coroutine.create(function() --creating a thread for network stuff
		 if Network["PartOwnership"]["Enabled"] == false then
			 Network["PartOwnership"]["Enabled"] = true --do cool network stuff before doing more cool network stuff
			 Network["PartOwnership"]["PreMethodSettings"].ReplicationFocus = LocalPlayer.ReplicationFocus
			 LocalPlayer.ReplicationFocus = workspace
			 Network["PartOwnership"]["PreMethodSettings"].SimulationRadius = gethiddenproperty(LocalPlayer,"SimulationRadius")
			 Network["PartOwnership"]["Connection"] = Network["SuperStepper"].Event:Connect(function() --super fast asynchronous loop
				 sethiddenproperty(LocalPlayer,"SimulationRadius",1/0)
				 for _,Part in pairs(Network["BaseParts"]) do --loop through parts and do network stuff
					 coroutine.wrap(function()
						 if Part:IsDescendantOf(workspace) then
							 if Network.CharacterRelative == true then
								 local Character = LocalPlayer.Character;
								 if Character and Character.PrimaryPart then
									 local Distance = (Character.PrimaryPart.Position - Part.Position).Magnitude
									 if Distance > 1000 then
										 Network["Output"].Send(warn,"PartOwnership Warning : PartOwnership not applied to BasePart "..Part:GetFullName()..", as it is more than "..gethiddenproperty(LocalPlayer,"MaximumSimulationRadius").." studs away.")
										 Lost = true;
										 Network["RemovePart"](Part)
									 end
								 else
									 Network["Output"].Send(warn,"PartOwnership Warning : PartOwnership not applied to BasePart "..Part:GetFullName()..", as the LocalPlayer Character's PrimaryPart does not exist.")
								 end
							 end
							 Part.Velocity = Network["Velocity"]+Vector3.new(0,math.cos(tick()*10)/100,0) --keep network by sending physics packets of 30 magnitude + an everchanging addition in the y level so roblox doesnt get triggered and fuck your ownership
						 else
							 Network["RemovePart"](Part)
						 end
					 end)()
				 end
			 end)
			 Network["Output"].Send(print,"PartOwnership Output : PartOwnership enabled.")
		 else
			 Network["Output"].Send(warn,"PartOwnership Output : PartOwnership already enabled.")
		 end
	 end)
	 Network["PartOwnership"]["Disable"] = coroutine.create(function()
		 if Network["PartOwnership"]["Connection"] then
			 Network["PartOwnership"]["Connection"]:Disconnect()
			 LocalPlayer.ReplicationFocus = Network["PartOwnership"]["PreMethodSettings"].ReplicationFocus
			 sethiddenproperty(LocalPlayer,"SimulationRadius",Network["PartOwnership"]["PreMethodSettings"].SimulationRadius)
			 Network["PartOwnership"]["PreMethodSettings"] = {}
			 for _,Part in pairs(Network["BaseParts"]) do
				 Network["RemovePart"](Part)
			 end
			 Network["PartOwnership"]["Enabled"] = false
			 Network["Output"].Send(print,"PartOwnership Output : PartOwnership disabled.")
		 else
			 Network["Output"].Send(warn,"PartOwnership Output : PartOwnership already disabled.")
		 end
	 end)
	 Network["Output"].Send(print,": Loaded.")
 end
 
 coroutine.resume(Network["PartOwnership"]["Enable"])
 
 
 
 local lp = game.Players.LocalPlayer -- local player var
 local char = lp.Character -- char var
 
 lp.Character = nil -- nil character for pdeath
 lp.Character = char -- newvar
 
 local hrp = char:FindFirstChild("HumanoidRootPart") -- hrp check
 if hrp == nil then return end -- return if no hrp
 
 wait(game.Players.RespawnTime + .3) -- nil wait
 
 hrp:Destroy() -- rip hrp
 char.Torso:Destroy() -- rip torso
 local clone = char["Body Colors"]:Clone() -- body colors clone
 char["Body Colors"]:Destroy() -- delete any instances from char that replicates deletion
 clone.Parent = char -- parent back in clone in case some script uses it
 
 
 
 
 player = game:GetService("Players").LocalPlayer
 Gui = player.PlayerGui
 Backpack = player.Backpack
 Mouse = player:GetMouse()
 
 Parts_Folder = Instance.new("Folder",workspace)
 
 for i,v in pairs(player.Character:GetChildren()) do
	 if v:IsA("Accessory") then
		 local Part = Instance.new("Part",Parts_Folder)
		 Part.Name = v.Name
		 Part.Anchored = true
		 Part.Size = v.Handle.Size - Vector3.new(0.001,0.001,0.001)
		 Part.Position = player.Character.Head.Position + Vector3.new(math.random(-5,5),math.random(-1,1),math.random(-5,5))
		 Part:SetAttribute("Moveable",true)
		 Part.Material = Enum.Material.SmoothPlastic
		 Part.CanCollide = false
		 Part.Color = Color3.new(1,0,0)
		 
		 local Hat = v.Handle
		 local vbreak = false
		 Network.RetainPart(Hat)
		 Hat.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
		 coroutine.wrap(function()
			 while task.wait() do
				 if vbreak == true then break end
				 Hat.CFrame = Part.CFrame
			 end
		 end)()
		 Hat:FindFirstChildWhichIsA("SpecialMesh"):Destroy()
	 end
 end
 
 
 Move_Tool = Instance.new("Tool",Backpack)
 Rotate_Tool = Instance.new("Tool",Backpack)
 MHandle = Instance.new("Part",Move_Tool)
 RHandle = Instance.new("Part",Rotate_Tool)
 Mgrabs = Instance.new("Handles",Gui)
 Rgrabs = Instance.new("ArcHandles",Gui)
 Outline = Instance.new("Highlight")
 
 Move_Tool.Name = "Move"
 Move_Tool.CanBeDropped = false
 
 Rotate_Tool.Name = "Rotate"
 Rotate_Tool.CanBeDropped = false
 
 MHandle.Name = "Handle"
 MHandle.Transparency = 1
 
 RHandle.Name = "Handle"
 RHandle.Transparency = 1
 
 Mgrabs.Visible = false
 Mgrabs.Color3 = Color3.new(1, 0.8, 0)
 Mgrabs.Style = "Movement"
 
 Rgrabs.Visible = false
 
 Outline.FillTransparency = 1
 Outline.OutlineTransparency = 0
 Outline.OutlineColor = Color3.new(1, 0.8, 0)
 
 Active_Part = nil
 
 Move_Tool.AncestryChanged:Connect(function()
	 if Move_Tool.Parent == char and Active_Part ~= nil then
		 Mgrabs.Visible = true
		 Mgrabs.Adornee = Active_Part
	 end
 end)
 
 Move_Tool.AncestryChanged:Connect(function()
	 if Move_Tool.Parent ~= char then
		 Mgrabs.Visible = false
		 Mgrabs.Adornee = nil
	 end
 end)
 
 Mouse.Button1Down:Connect(function()
	 if Move_Tool.Parent == char and Mouse.Target:GetAttribute("Moveable") then
		 Active_Part = Mouse.Target
		 Mgrabs.Visible = true
		 Mgrabs.Adornee = Active_Part
		 Outline.Parent = Active_Part
	 end
	 if Rotate_Tool.Parent == char and Mouse.Target:GetAttribute("Moveable") then
		 Active_Part = Mouse.Target
		 Rgrabs.Visible = true
		 Rgrabs.Adornee = Active_Part
		 Outline.Parent = Active_Part
	 end
 end)
 
 Rotate_Tool.AncestryChanged:Connect(function()
	 if Rotate_Tool.Parent == char and Active_Part ~= nil then
		 Rgrabs.Visible = true
		 Rgrabs.Adornee = Active_Part
	 end
 end)
 
 Rotate_Tool.AncestryChanged:Connect(function()
	 if Rotate_Tool.Parent ~= char then
		 Rgrabs.Visible = false
		 Rgrabs.Adornee = nil
	 end
 end)
 
 MOGCFrame = CFrame.new()
 
 Mgrabs.MouseButton1Down:Connect(function()
	 MOGCFrame = Active_Part.CFrame
 end)
 
 Mgrabs.MouseDrag:Connect(function(knob, pos)
	 if knob == Enum.NormalId.Front then
		 Active_Part.CFrame = MOGCFrame + MOGCFrame.LookVector * pos
	 end
	 if knob == Enum.NormalId.Back then
		 Active_Part.CFrame = MOGCFrame + MOGCFrame.LookVector * -pos
	 end
	 if knob == Enum.NormalId.Top then
		 Active_Part.CFrame = MOGCFrame + MOGCFrame.UpVector * pos
	 end
	 if knob == Enum.NormalId.Bottom then
		 Active_Part.CFrame = MOGCFrame + MOGCFrame.UpVector * -pos
	 end
	 if knob == Enum.NormalId.Left then
		 Active_Part.CFrame = MOGCFrame + MOGCFrame.RightVector * -pos
	 end
	 if knob == Enum.NormalId.Right then
		 Active_Part.CFrame = MOGCFrame + MOGCFrame.RightVector * pos
	 end
 end)
 
 ROGCFrame = CFrame.new()
 
 Rgrabs.MouseButton1Down:Connect(function()
	 ROGCFrame = Active_Part.CFrame
 end)
 
 Rgrabs.MouseDrag:Connect(function(knob, angle)
	 if knob == Enum.Axis.Y then
		 Active_Part.CFrame = ROGCFrame * CFrame.Angles(0,angle,0)
	 end
	 if knob == Enum.Axis.X then
		 Active_Part.CFrame = ROGCFrame * CFrame.Angles(angle,0,0)
	 end
	 if knob == Enum.Axis.Z then
		 Active_Part.CFrame = ROGCFrame * CFrame.Angles(0,0,angle)
	 end
 end)
 
 
 
 Mouse.TargetFilter = player.Character
 
 
 
 camera = workspace.CurrentCamera
 input = game:GetService("UserInputService")
 
 Camera_Part = Instance.new("Part",workspace)
 Camera_Part.Anchored = true
 Camera_Part.Transparency = 0.85
 Camera_Part.Shape = Enum.PartType.Ball
 Camera_Part.Size = Vector3.new(0.5,0.5,0.5)
 Camera_Part.Material = Enum.Material.SmoothPlastic
 
 current_position = char.Head.Position
 
 camera.CameraSubject = Camera_Part
 
 
 
 for i,v in pairs(char:GetDescendants()) do
	 if v:IsA("BasePart") and v.Parent:IsA("Accessory") == false then
		 v:Destroy()
	 end
 end

 
 while wait() do
	 if vbreak == true then
		 break
	 end
	 if input:IsKeyDown(Enum.KeyCode.D) then
		 current_position += camera.CFrame.RightVector * speed
	 end
	 if input:IsKeyDown(Enum.KeyCode.A) then
		 current_position += camera.CFrame.RightVector * -speed
	 end
	 if input:IsKeyDown(Enum.KeyCode.W) then
		 current_position += camera.CFrame.LookVector * speed
	 end
	 if input:IsKeyDown(Enum.KeyCode.S) then
		 current_position += camera.CFrame.LookVector * -speed
	 end
	 if input:IsKeyDown(Enum.KeyCode.E) then
		 current_position += camera.CFrame.UpVector * speed
	 end
	 if input:IsKeyDown(Enum.KeyCode.Q) then
		 current_position += camera.CFrame.UpVector * -speed
	 end
	 if input:IsKeyDown(Enum.KeyCode.LeftShift) then do
			 speed = 1.5
		 end else
		 speed = 0.75
	 end
	 Camera_Part.Position = current_position
 end
	 end)
 
 cmd.add({"unspblockspam", "unstarterblockscam"}, {"unspblockspam (unstarterblockspam)", "Stops the starterblockspam command"}, function()
 anniblockspam = false
 end)
 
 cmd.add({"blockspam"}, {"blockspam [amount]", "Spawn blocks by the given amount"}, function(amt)
	 amt = tonumber(amt) or 1
	 local hatAmount, grabbed = 0, {}
	 local lastCF = character.PrimaryPart.CFrame
	 character:ClearAllChildren()
	 respawn()
	 repeat
		 if character.Name ~= "respawn_" then
			 local c = character
			 repeat wait() until c:FindFirstChildWhichIsA("Accoutrement")
			 c:MoveTo(lastCF.p)
			 wait(1)
			 for i, v in pairs(c:GetChildren()) do
				 if v:IsA("Accoutrement") then
					 v:WaitForChild("Handle")
					 v.Handle.CanCollide = true
					 if v:FindFirstChildWhichIsA("DataModelMesh", true) then
						 v:FindFirstChildWhichIsA("DataModelMesh", true):Destroy()
					 end
					 v.Parent = workspace
					 table.insert(grabbed, v)
				 end
			 end
			 hatAmount = hatAmount + 1
		 end
		 character:ClearAllChildren()
		 respawn()
		 wait()
	 until
		 hatAmount >= amt
	 
	 repeat wait() until tostring(localPlayer.Character) ~= "respawn_" and localPlayer.Character
	 wait(0.5)
	 
	 spawn(function()
		 repeat wait() until character.PrimaryPart
		 wait(0.2)
		 character:SetPrimaryPartCFrame(lastCF)
		 
		 for _, item in pairs(grabbed) do
			 if item:IsA("Accoutrement") and item:FindFirstChild("Handle") then
				 item.Parent = workspace
				 wait()
			 end
		 end
	 end)
 end)
 
 cmd.add({"hitboxes"}, {"hitboxes", "shows all the hitboxes"}, function()
 settings():GetService("RenderSettings").ShowBoundingBoxes = true
 end)
 
 cmd.add({"unhitboxes"}, {"unhitboxes", "removes the hitboxes outline"}, function()
 settings():GetService("RenderSettings").ShowBoundingBoxes = false
 end)
  
 cmd.add({"vfly", "vehiclefly"}, {"vehiclefly (vfly)", "be able to fly vehicles"}, function(...)
 FLYING = false
	 cmdlp.Character.Humanoid.PlatformStand = false
	 wait()
 
		 
		 
		 wait();
		 
		 Notify({
		 Description = "Vehicle fly enabled";
		 Title = "Nameless Admin";
		 Duration = 5;
	 
 });
	 sFLY(true)
	 speedofthevfly = (...)
	 if (...) == nil then
		 speedofthevfly = 2
		 end
 end)
 
 cmd.add({"unvfly", "unvehiclefly"}, {"unvehiclefly (unvfly)", "disable vehicle fly"}, function()
 
		 
		 
		 wait();
		 
		 Notify({
		 Description = "Vehicle fly disabled";
		 Title = "Nameless Admin";
		 Duration = 5;
	 
 });
 FLYING = false
	 cmdlp.Character.Humanoid.PlatformStand = false
 end)
 
 cmd.add({"trap"}, {"trap", "makes your tool be away from you making it look like its dropped"}, function()
 
 local function Kill(humanoid)
	 if not humanoid then
		 return
	 end
	 local function getPlr(Name)
		 if Name:lower() == "random" then
			 return game.Players:GetPlayers()[math.random(#game.Players:GetPlayers())]
		 else
			 Name = Name:lower():gsub("%s", "")
			 for _, x in next, game.Players:GetPlayers() do
				 if x.Name:lower():match(Name) then
					 return x
				 elseif x.DisplayName:lower():match("^" .. Name) then
					 return x
				 end
			 end
		 end
	 end
 
	 local Character = game.Players.LocalPlayer.Character
	 local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	 local RootPart = Character.HumanoidRootPart
	 local Tool = Character:FindFirstChildOfClass("Tool")
	 local Handle = Tool and Tool:FindFirstChild("Handle")
 
	 if not Handle then
		 return
	 end
 
	 local TPlayer = getPlr(humanoid.Parent.Name)
	 local TCharacter = TPlayer and TPlayer.Character
	 local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
	 local TRootPart = THumanoid and THumanoid.RootPart
 
	 if not TPlayer or not TCharacter or not THumanoid or not TRootPart then
		 return
	 end
 
	 if THumanoid.Sit then
		 return
	 end
 
	 local OldCFrame = RootPart.CFrame
 
	 Humanoid:Destroy()
	 local NewHumanoid = Humanoid:Clone()
	 NewHumanoid.Parent = Character
	 NewHumanoid:UnequipTools()
	 NewHumanoid:EquipTool(Tool)
	 Tool.Parent = workspace
 
	 local Timer = os.time()
 
	 repeat
		 if (TRootPart.CFrame.p - RootPart.CFrame.p).Magnitude < 500 then
			 Tool.Grip = CFrame.new()
			 Tool.Grip = Handle.CFrame:ToObjectSpace(TRootPart.CFrame):Inverse()
		 end
		 firetouchinterest(Handle, TRootPart, 0)
		 firetouchinterest(Handle, TRootPart, 1)
		 game:FindService("RunService").Heartbeat:wait()
	game:FindService("RunService").Heartbeat:wait()
		   until Tool.Parent ~= Character or not TPlayer or not TRootPart or THumanoid.Health <= 0 or os.time() > Timer + .20
			wait(0.4)
			 Player.Character = nil
			 NewHumanoid.Health = 0
			 player.CharacterAdded:wait(1)
			 repeat game:FindService("RunService").Heartbeat:wait() until Player.Character:FindFirstChild("HumanoidRootPart")
			 Player.Character.HumanoidRootPart.CFrame = OldCFrame
 end
	   
		 if not LoopKill then
			 Kill()
		 else
			 while LoopKill do
				 Kill()
			 end
		 end
 
 local function equipRandomTool()
	 local player = game.Players.LocalPlayer
	 local backpack = player.Backpack
	 local tools = backpack and backpack:GetChildren()
	 if not tools or #tools == 0 then
		 return
	 end
	 local randomTool = tools[math.random(#tools)]
	 randomTool.Grip = CFrame.new(0, 2, 19)
	 player.Character.Humanoid:EquipTool(randomTool)
	 randomTool.Parent = player.Character
	 local handle = randomTool:FindFirstChild("Handle")
	 if handle then
		 handle.Touched:Connect(Kill)
	 end
 end
 
 equipRandomTool()
 end)
 
 cmd.add({"kill"}, {"kill <player>", "after a while i have added a working kill script thats almost instant to this admin"}, function(...)
	 Target = (...)
 
 if Target == "all" or Target == "others" then
	 print("Patched")
 else
 local function Kill()
			 if not getPlr(Target) then
			 end
			 
			 repeat game:FindService("RunService").Heartbeat:wait() until getPlr(Target).Character and getPlr(Target).Character:FindFirstChildOfClass("Humanoid") and getPlr(Target).Character:FindFirstChildOfClass("Humanoid").Health > 0
			 local Character
			 local Humanoid
			 local RootPart
			 local Tool
			 local Handle
			 
			 local TPlayer = getPlr(Target)
			 local TCharacter = TPlayer.Character
			 local THumanoid
			 local TRootPart
			 
			 if Player.Character and Player.Character and Player.Character.Name == Player.Name then
				 Character = Player.Character
			 else
			 end
			 if Character:FindFirstChildOfClass("Humanoid") then
				 Humanoid = Character:FindFirstChildOfClass("Humanoid")
			 else
			 end
			 if Humanoid and Humanoid.RootPart then
				 RootPart = Humanoid.RootPart
			 else
			 end
			 if Character:FindFirstChildOfClass("Tool") then
				 Tool = Character:FindFirstChildOfClass("Tool")
			 elseif Player.Backpack:FindFirstChildOfClass("Tool") and Humanoid then
				 Tool = Player.Backpack:FindFirstChildOfClass("Tool")
				 Humanoid:EquipTool(Player.Backpack:FindFirstChildOfClass("Tool"))
			 else
			 end
			 if Tool and Tool:FindFirstChild("Handle") then
				 Handle = Tool.Handle
			 else
			 end
			 
			 --Target
			 if TCharacter:FindFirstChildOfClass("Humanoid") then
				 THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
			 else
				 return Message("Error",">   Missing Target Humanoid")
			 end
			 if THumanoid.RootPart then
				 TRootPart = THumanoid.RootPart
			 else
				 return Message("Error",">   Missing Target RootPart")
			 end
			 
			 if THumanoid.Sit then
				 return Message("Error",">   Target is seated")
			 end
			 
			 local OldCFrame = RootPart.CFrame
			 
			 Humanoid:Destroy()
			 local NewHumanoid = Humanoid:Clone()
			 NewHumanoid.Parent = Character
			 NewHumanoid:UnequipTools()
			 NewHumanoid:EquipTool(Tool)
			 Tool.Parent = workspace
		 
			 local Timer = os.time()
		 
			 repeat
				 if (TRootPart.CFrame.p - RootPart.CFrame.p).Magnitude < 500 then
					 Tool.Grip = CFrame.new()
					 Tool.Grip = Handle.CFrame:ToObjectSpace(TRootPart.CFrame):Inverse()
				 end
				 firetouchinterest(Handle,TRootPart,0)
				 firetouchinterest(Handle,TRootPart,1)
				 game:FindService("RunService").Heartbeat:wait()
			 until Tool.Parent ~= Character or not TPlayer or not TRootPart or THumanoid.Health <= 0 or os.time() > Timer + .20
			 Player.Character = nil
			 NewHumanoid.Health = 0
			 player.CharacterAdded:wait(1)
			 repeat game:FindService("RunService").Heartbeat:wait() until Player.Character:FindFirstChild("HumanoidRootPart")
			 Player.Character.HumanoidRootPart.CFrame = OldCFrame
 end
	   
		 if not LoopKill then
			 Kill()
		 else
			 while LoopKill do
				 Kill()
			 end
		 end
		  end
 end)
 
 cmd.add({"toolblockspam"}, {"toolblockspam [amount]", "Spawn blocks by the given amount"}, function(amt)
	 if not amt then amt = 1 end
	 amt = tonumber(amt)
	 local tools = getTools(amt)
	 for i, tool in pairs(tools) do
		 wait()
		 spawn(function()
			 wait(0.1)
			 tool.Parent = character
			 tool.CanBeDropped = true
			 wait(0.1)
			 for _, mesh in pairs(tool:GetDescendants()) do
				 if mesh:IsA("DataModelMesh") then
					 mesh:Destroy()
				 end
			 end
			 for _, weld in pairs(character:GetDescendants()) do
				 if weld.Name == "RightGrip" then
					 weld:Destroy()
				 end
			 end
			 wait(0.1)
			 tool.Parent = workspace
			 wait(0.1)
			 local cf, p = CFrame.new(), character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
	 if p then
		 cf = p.CFrame
	 end
	 respawn()
	 player.CharacterAdded:wait(1); wait(0.2);
	 character:WaitForChild("HumanoidRootPart").CFrame = cf
		 end)
	 end
 end)
 
 cmd.add({"equiptools", "equipall"}, {"equiptools", "Equip all of your tools"}, function()
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 if backpack then
		 for _, tool in pairs(backpack:GetChildren()) do
			 if tool:IsA("Tool") then
				 tool.Parent = character
			 end
		 end
	 end
 end)
 
 cmd.add({"tweento", "tweengoto"}, {"tweengoto (tweento)", "Teleportation method that bypassses some anticheats"}, function(...)
 local Username = (...)
 
 
 char = game.Players.LocalPlayer
 
 TweenService = game:GetService("TweenService")
 
 speaker = game.Players.LocalPlayer
 Players = game:GetService("Players")
	 
	 local players = getPlr(Username)
			 TweenService:Create(getRoot(speaker.Character), TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = getRoot(players.Character).CFrame + Vector3.new(3,1,0)}):Play()
	 
 end)
 
 cmd.add({"reach"}, {"reach {number}", "Sword reach"}, function(reachsize)
	 local reachsize = reachsize or 25
	 local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
	 if Tool:FindFirstChild("OGSize3") then
		 Tool.Handle.Size = Tool.OGSize3.Value
		 Tool.OGSize3:Destroy()
		 Tool.Handle.FunTIMES:Destroy()
	 end
	 local val = Instance.new("Vector3Value",Tool)
	 val.Name = "OGSize3"
	 val.Value = Tool.Handle.Size
	 local sb = Instance.new("SelectionBox")
	 sb.Adornee = Tool.Handle
	 sb.Name = "FunTIMES"
	 sb.Parent = Tool.Handle
	 Tool.Handle.Massless = true
	 Tool.Handle.Size = Vector3.new(Tool.Handle.Size.X,Tool.Handle.Size.Y,reachsize)
 end)
 
 cmd.add({"aura"}, {"aura {number}", "Sword aura"}, function(reachsize)
	 local reachsize = reachsize or 25
	 local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
	 if Tool:FindFirstChild("OGSize3") then
		 Tool.Handle.Size = Tool.OGSize3.Value
		 Tool.OGSize3:Destroy()
		 Tool.Handle.FunTIMES:Destroy()
	 end
	 local val = Instance.new("Vector3Value",Tool)
	 val.Name = "OGSize3"
	 val.Value = Tool.Handle.Size
	 local sb = Instance.new("SelectionBox")
	 sb.Adornee = Tool.Handle
	 sb.Name = "FunTIMES"
	 sb.Transparency = 0.5
	 sb.Parent = Tool.Handle
	 Tool.Handle.Massless = true
	 Tool.Handle.Size = Vector3.new(reachsize,reachsize,reachsize)
 end)
 
 cmd.add({"droptools"}, {"dropalltools", "Drop all of your tools"}, function()
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 if backpack then
		 for _, tool in pairs(backpack:GetChildren()) do
			 if tool:IsA("Tool") then
				 tool.Parent = character
			 end
		 end
	 end
	 wait()
	 for _, tool in pairs(character:GetChildren()) do
		 if tool:IsA("Tool") then
			 tool.Parent = workspace
		 end
	 end
	 end)
 
 cmd.add({"notools"}, {"notools", "Remove your tools"}, function()
	 for _, tool in pairs(character:GetChildren()) do
		 if tool:IsA("Tool") then
			 tool:Destroy()
		 end
	 end
	 for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
		 if tool:IsA("Tool") then
			 tool:Destroy()
		 end
	 end
 end)

 cmd.add({"fpsbooster", "lowgraphics", "boostfps", "lowg"}, {"fpsbooster (lowgraphics, boostfps, lowg)", "Low graphics mode if the game is laggy"}, function()
	 local decalsyeeted = true
	 local g = game
	 local w = g.Workspace
	 local l = g.Lighting
	 local t = w.Terrain
	 sethiddenproperty(l,"Technology",2)
	 sethiddenproperty(t,"Decoration",false)
	 t.WaterWaveSize = 0
	 t.WaterWaveSpeed = 0
	 t.WaterReflectance = 0
	 t.WaterTransparency = 0
	 l.GlobalShadows = 0
	 l.FogEnd = 9e9
	 l.Brightness = 0
	 settings().Rendering.QualityLevel = "Level01"
	 for i, v in pairs(w:GetDescendants()) do
		 if v:IsA("BasePart") and not v:IsA("MeshPart") then
			 v.Material = "Plastic"
			 v.Reflectance = 0
		 elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
			 v.Transparency = 1
		 elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			 v.Lifetime = NumberRange.new(0)
		 elseif v:IsA("Explosion") then
			 v.BlastPressure = 1
			 v.BlastRadius = 1
		 elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
			 v.Enabled = false
		 elseif v:IsA("MeshPart") and decalsyeeted then
			 v.Material = "Plastic"
			 v.Reflectance = 0
			 v.TextureID = 10385902758728957
		 elseif v:IsA("SpecialMesh") and decalsyeeted  then
			 v.TextureId=0
		 elseif v:IsA("ShirtGraphic") and decalsyeeted then
			 v.Graphic=0
		 elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
			 v[v.ClassName.."Template"]=0
		 end
	 end
	 for i = 1,#l:GetChildren() do
		 e=l:GetChildren()[i]
		 if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
			 e.Enabled = false
		 end
	 end
	 w.DescendantAdded:Connect(function(v)
		 wait()--prevent errors and shit
		if v:IsA("BasePart") and not v:IsA("MeshPart") then
			 v.Material = "Plastic"
			 v.Reflectance = 0
		 elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
			 v.Transparency = 1
		 elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			 v.Lifetime = NumberRange.new(0)
		 elseif v:IsA("Explosion") then
			 v.BlastPressure = 1
			 v.BlastRadius = 1
		 elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
			 v.Enabled = false
		 elseif v:IsA("MeshPart") and decalsyeeted then
			 v.Material = "Plastic"
			 v.Reflectance = 0
			 v.TextureID = 10385902758728957
		 elseif v:IsA("SpecialMesh") and decalsyeeted then
			 v.TextureId=0
		 elseif v:IsA("ShirtGraphic") and decalsyeeted then
			 v.ShirtGraphic=0
		 elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
			 v[v.ClassName.."Template"]=0
		 end
	 end)
 end)
 
 cmd.add({"vr", "clovr", "vrscript", "fevr"}, {"vr (clovr, vrscript, fevr)", "FE VR SCRIPT AKA CLOVR"}, function()
	Notify({
		Description = "Patched.";
		Title = "Nameless Admin";
		Duration = 5;
	});
 end)
 
 cmd.add({"flash"}, {"flash <player>", "Flashes the targets screen"}, function(...)
			 local oldCF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
 
 Target = (...)
 local TPlayer = getPlr(Target)
				TRootPart = TPlayer.Character.HumanoidRootPart
				local Character = Player.Character
				local PlayerGui = Player:WaitForChild("PlayerGui")
				local Backpack = Player:WaitForChild("Backpack")
				local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
				local RootPart = Character and Humanoid and Humanoid.RootPart or false
				local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
				if not Humanoid or not RootPart or not RightArm then
					return
				end
				Humanoid:UnequipTools()
				local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
				if not MainTool or not MainTool:FindFirstChild("Handle") then
					return
				end
				Humanoid.Name = "DAttach"
				local l = Character["DAttach"]:Clone()
				l.Parent = Character
				l.Name = "Humanoid"
				wait()
				Character["DAttach"]:Destroy()
				game.Workspace.CurrentCamera.CameraSubject = Character
				Character.Animate.Disabled = true
				wait()
				Character.Animate.Disabled = false
				Character.Humanoid:EquipTool(MainTool)
				wait()
				CF = Player.Character.PrimaryPart.CFrame
				if firetouchinterest then
					local flag = false
					task.defer(function()
						MainTool.Handle.AncestryChanged:wait()
						flag = true
					end)
					repeat
						firetouchinterest(MainTool.Handle, TRootPart, 0)
						firetouchinterest(MainTool.Handle, TRootPart, 1)
						wait()
					until flag
							 for i= 1,50,1 do
				 print('pee'..i)
				 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,9e+18,0)
				 wait(.04)
				 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
				 wait(.04)
				 end
				else
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
				end
				player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 end)
 
 cmd.add({"void"}, {"void <player>", "Kill the given players without FE god"}, function(...)
	 Target = (...)
 local Character = Player.Character
 local PlayerGui = Player:waitForChild("PlayerGui")
 local Backpack = Player:waitForChild("Backpack")
 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
 local RootPart = Character and Humanoid and Humanoid.RootPart or false
 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
 if not Humanoid or not RootPart or not RightArm then
 return
 end
 
 Humanoid:UnequipTools()
 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
 if not MainTool or not MainTool:FindFirstChild("Handle") then
 return
 end
 
 local TPlayer = getPlr(Target)
 local TCharacter = TPlayer and TPlayer.Character
 
 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
 if not THumanoid or not TRootPart then
 return
 end
 
 Character.Humanoid.Name = "DAttach"
 local l = Character["DAttach"]:Clone()
 l.Parent = Character
 l.Name = "Humanoid"
 wait()
 Character["DAttach"]:Destroy()
 game.Workspace.CurrentCamera.CameraSubject = Character
 Character.Animate.Disabled = true
 wait()
 Character.Animate.Disabled = false
 Character.Humanoid:EquipTool(MainTool)
 wait()
 CF = Player.Character.PrimaryPart.CFrame
 XC = TCharacter.HumanoidRootPart.CFrame.X
 ZC = TCharacter.HumanoidRootPart.CFrame.Z
 if firetouchinterest then
 local flag = false
 task.defer(function()
	 MainTool.Handle.AncestryChanged:wait()
	 flag = true
 end)
 repeat
	 firetouchinterest(MainTool.Handle, TRootPart, 0)
	 firetouchinterest(MainTool.Handle, TRootPart, 1)
	 wait()
 until flag
				 wait(0.2)
 Player.Character.HumanoidRootPart.CFrame = CFrame.new(0,-1000,0)
 else
 Player.Character.HumanoidRootPart.CFrame =
 TCharacter.HumanoidRootPart.CFrame
 wait()
 Player.Character.HumanoidRootPart.CFrame =
 TCharacter.HumanoidRootPart.CFrame
 wait()
 Player.Character.HumanoidRootPart.CFrame = CFrame.new(XC,-99,ZC)
 wait()
 end
 wait(.3)
 Player.Character:SetPrimaryPartCFrame(CF)
 if Humanoid.RigType == Enum.HumanoidRigType.R6 then
 Character["Right Arm"].RightGrip:Destroy()
 else
 Character["RightHand"].RightGrip:Destroy()
 Character["RightHand"].RightGripAttachment:Destroy()
 end
 wait(0.02)
 respawn()
 end)
 
 annoyloop = false
 cmd.add({"annoy"}, {"annoy <player>", "Annoys the given player"}, function(...)
	 annoyloop = true
	 User = (...)
	 Target = getPlr(User)
			   local SaveCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
 repeat wait()
					   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-2,2),math.random(0,2),math.random(-2,2))
					   game:GetService('RunService').RenderStepped:Wait()
					   wait(.1)
			   until annoyloop == false
			   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SaveCFrame
 
 end)
 
 cmd.add({"unannoy"}, {"unannoy", "Stops the annoy command"}, function()
	 annoyloop = false
 end)
 
 cmd.add({"seat"}, {"seat", "Finds a seat and automatically sits on it"}, function()
		local seats = {}
		 for i,v in next, game:GetDescendants() do
				 if v:IsA'Seat' then
						 table.insert(seats, v)
				 end
		 end
		 wait(0.07)
		 for i=1, 8 do
		 seats[math.random(1, #seats)]:Sit(game.Players.LocalPlayer.Character.Humanoid)
		 end
		 end)
 
 cmd.add({"banish", "punish", "jail"}, {"punish <player> (banish, jail)", "Banishes the player using a void script, can make them not respawn if the game is old"}, function(...)
   Target = (...)
 local TPlayer = getPlr(Target)
				TRootPart = TPlayer.Character.HumanoidRootPart
				local Character = Player.Character
				local PlayerGui = Player:WaitForChild("PlayerGui")
				local Backpack = Player:WaitForChild("Backpack")
				local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
				local RootPart = Character and Humanoid and Humanoid.RootPart or false
				local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
				if not Humanoid or not RootPart or not RightArm then
					return
				end
				Humanoid:UnequipTools()
				local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
				if not MainTool or not MainTool:FindFirstChild("Handle") then
					return
				end
				Humanoid.Name = "DAttach"
				local l = Character["DAttach"]:Clone()
				l.Parent = Character
				l.Name = "Humanoid"
				wait()
				Character["DAttach"]:Destroy()
				game.Workspace.CurrentCamera.CameraSubject = Character
				Character.Animate.Disabled = true
				wait()
				Character.Animate.Disabled = false
				Character.Humanoid:EquipTool(MainTool)
				wait()
				CF = Player.Character.PrimaryPart.CFrame
				if firetouchinterest then
					local flag = false
					task.defer(function()
						MainTool.Handle.AncestryChanged:wait()
						flag = true
					end)
					repeat
						firetouchinterest(MainTool.Handle, TRootPart, 0)
						firetouchinterest(MainTool.Handle, TRootPart, 1)
						wait()
					until flag
								 Player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-100000, 1000000000000000000000, -100000))
				else
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
				end
				player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 end)
 
 massplay = false
 cmd.add({"sync"}, {"sync", "Syncs all in-game audios"}, function()
 massplay = true
 if game:GetService("SoundService").RespectFilteringEnabled == false then
 repeat wait() do 
 for _, sound in next, game.Workspace:GetDescendants() do
 if sound:IsA("Sound") then
 sound.Volume = 10
 sound:Play()
 end
 end
 end
 until massplay == false
 else
 Notify({
 Description = "Sorry, wont replicate for this game, try another game.";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end
 end)
 
 cmd.add({"unsync"}, {"unsync", "Unsyncs all in-game audios"}, function()
	 massplay = false
 end)
 
 cmd.add({"infvoid"}, {"infvoid <player>", "Makes a players avatar glitch"}, function(...)
	 Target = (...)
	 local TPlayer = getPlr(Target)
				TRootPart = TPlayer.Character.HumanoidRootPart
				local Character = Player.Character
				local PlayerGui = Player:WaitForChild("PlayerGui")
				local Backpack = Player:WaitForChild("Backpack")
				local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
				local RootPart = Character and Humanoid and Humanoid.RootPart or false
				local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
				if not Humanoid or not RootPart or not RightArm then
					return
				end
				Humanoid:UnequipTools()
				local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
				if not MainTool or not MainTool:FindFirstChild("Handle") then
					return
				end
				Humanoid.Name = "DAttach"
				local l = Character["DAttach"]:Clone()
				l.Parent = Character
				l.Name = "Humanoid"
				wait()
				Character["DAttach"]:Destroy()
				game.Workspace.CurrentCamera.CameraSubject = Character
				Character.Animate.Disabled = true
				wait()
				Character.Animate.Disabled = false
				Character.Humanoid:EquipTool(MainTool)
				wait()
				CF = Player.Character.PrimaryPart.CFrame
				if firetouchinterest then
					local flag = false
					task.defer(function()
						MainTool.Handle.AncestryChanged:wait()
						flag = true
					end)
					repeat
						firetouchinterest(MainTool.Handle, TRootPart, 0)
						firetouchinterest(MainTool.Handle, TRootPart, 1)
						wait()
					until flag
				else
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
				end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(111111110, 11111110, 11111110)
 end)
 
 cmd.add({"attach"}, {"attach <player>", "Attach the given player(s)"}, function(...)
	 Target = (...)
	 local TPlayer = getPlr(Target)
				TRootPart = TPlayer.Character.HumanoidRootPart
				local Character = Player.Character
				local PlayerGui = Player:WaitForChild("PlayerGui")
				local Backpack = Player:WaitForChild("Backpack")
				local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
				local RootPart = Character and Humanoid and Humanoid.RootPart or false
				local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
				if not Humanoid or not RootPart or not RightArm then
					return
				end
				Humanoid:UnequipTools()
				local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
				if not MainTool or not MainTool:FindFirstChild("Handle") then
					return
				end
				Humanoid.Name = "DAttach"
				local l = Character["DAttach"]:Clone()
				l.Parent = Character
				l.Name = "Humanoid"
				wait()
				Character["DAttach"]:Destroy()
				game.Workspace.CurrentCamera.CameraSubject = Character
				Character.Animate.Disabled = true
				wait()
				Character.Animate.Disabled = false
				Character.Humanoid:EquipTool(MainTool)
				wait()
				CF = Player.Character.PrimaryPart.CFrame
				if firetouchinterest then
					local flag = false
					task.defer(function()
						MainTool.Handle.AncestryChanged:wait()
						flag = true
					end)
					repeat
						firetouchinterest(MainTool.Handle, TRootPart, 0)
						firetouchinterest(MainTool.Handle, TRootPart, 1)
						wait()
					until flag
				else
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
				end
				player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
	
 end)
 
 cmd.add({"enableinventory", "enableinv"}, {"enableinv (enableinventory)", "Lets you see what you have in your inventory since some games hide it"}, function(...)
	 game.StarterGui:SetCoreGuiEnabled(2, true)
 end)
 
 cmd.add({"copytools", "ctools"}, {"copytools <player> (ctools)", "Copies the tools the given player has"}, function(...)
	 PLAYERNAMEHERE = (...)
	 Target = getPlr(PLAYERNAMEHERE)
	 for i, v in pairs(Target.Backpack:GetChildren()) do
		 if v:IsA("Tool") or v:IsA('HopperBin') then
			 v:Clone().Parent = game.Players.LocalPlayer:FindFirstChildOfClass("Backpack")
		 end
		 end
	 end)
 
 cmd.add({"bring"}, {"bring <player>", "Bring the given player(s)"}, function(...)
	 local Target = (...) 
	 if Target == "all" or Target == "others" then
 print("Patched")
 end
			 local Character = Player.Character        
			 local PlayerGui = Player:waitForChild("PlayerGui")
			 local Backpack = Player:waitForChild("Backpack")
			 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
			 local RootPart = Character and Humanoid and Humanoid.RootPart or false
			 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
			 if not Humanoid or not RootPart or not RightArm then
				 return
			 end
			 Humanoid:UnequipTools()
			 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
			 if not MainTool or not MainTool:FindFirstChild("Handle") then
				 return
			 end
			 local TPlayer = getPlr(Target)
			 local TCharacter = TPlayer and TPlayer.Character
			 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
			 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
			 if not THumanoid or not TRootPart then
				 return
			 end
			 Character.Humanoid.Name = "DAttach"
			 local l = Character["DAttach"]:Clone()
			 l.Parent = Character
			 l.Name = "Humanoid"
			 wait()
			 Character["DAttach"]:Destroy()
			 game.Workspace.CurrentCamera.CameraSubject = Character
			 Character.Animate.Disabled = true
			 wait()
			 Character.Animate.Disabled = false
			 Character.Humanoid:EquipTool(MainTool)
			 wait()
			 CF = Player.Character.PrimaryPart.CFrame
			 if firetouchinterest then
				 local flag = false
				 task.defer(function()
					 MainTool.Handle.AncestryChanged:wait()
					 flag = true
				 end)
				 repeat
					 firetouchinterest(MainTool.Handle, TRootPart, 0)
					 firetouchinterest(MainTool.Handle, TRootPart, 1)
					 wait()
					 Player.Character.HumanoidRootPart.CFrame = CF
				 until flag
			 else
				 Player.Character.HumanoidRootPart.CFrame =
				 TCharacter.HumanoidRootPart.CFrame
				 wait()
				 Player.Character.HumanoidRootPart.CFrame =
				 TCharacter.HumanoidRootPart.CFrame
				 wait()
				 Player.Character.HumanoidRootPart.CFrame = CF
				 wait()
			 end
			 wait(.3)
			 Player.Character:SetPrimaryPartCFrame(CF)
			 if Humanoid.RigType == Enum.HumanoidRigType.R6 then
				 Character["Right Arm"].RightGrip:Destroy()
			 else
				 Character["RightHand"].RightGrip:Destroy()
				 Character["RightHand"].RightGripAttachment:Destroy()
			 end
				 
			 wait(4)
			 CF = Player.Character.HumanoidRootPart.CFrame
			 player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 end)
 
 cmd.add({"skydive", "sky"}, {"skydive <player> (sky)", "Skydives the player"}, function(...)
	 local Target = (...)
			 local Character = Player.Character
			 local PlayerGui = Player:waitForChild("PlayerGui")
			 local Backpack = Player:waitForChild("Backpack")
			 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
			 local RootPart = Character and Humanoid and Humanoid.RootPart or false
			 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
			 if not Humanoid or not RootPart or not RightArm then
				 return
			 end
			 
			 local getPlr = function(Name)
				 for x in string.gmatch(Name, "[%a%d%p]+") do
					 Name = x:lower()
					 break
				 end
				 local TPlayer = nil
				 for _, x in next, Players:GetPlayers() do
					 if tostring(x):lower():match(Name) or x["DisplayName"]:lower():match(Name) then
						 TPlayer = x
						 break
					 end
				 end
				 return TPlayer
			 end
			 
			 Humanoid:UnequipTools()
			 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
			 if not MainTool or not MainTool:FindFirstChild("Handle") then
				 return
			 end
			 
			 local TPlayer = getPlr(Target)
			 local TCharacter = TPlayer and TPlayer.Character
			 
			 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
			 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
			 if not THumanoid or not TRootPart then
				 return
			 end
			 
			 Character.Humanoid.Name = "DAttach"
			 local l = Character["DAttach"]:Clone()
			 l.Parent = Character
			 l.Name = "Humanoid"
			 wait()
			 Character["DAttach"]:Destroy()
			 game.Workspace.CurrentCamera.CameraSubject = Character
			 Character.Animate.Disabled = true
			 wait()
			 Character.Animate.Disabled = false
			 Character.Humanoid:EquipTool(MainTool)
			 wait()
			 CF = Player.Character.PrimaryPart.CFrame
			 XC = TCharacter.HumanoidRootPart.CFrame.X
			 ZC = TCharacter.HumanoidRootPart.CFrame.Z
			 if firetouchinterest then
				 local flag = false
				 task.defer(function()
					 MainTool.Handle.AncestryChanged:wait()
					 flag = true
				 end)
				 repeat
					 firetouchinterest(MainTool.Handle, TRootPart, 0)
					 firetouchinterest(MainTool.Handle, TRootPart, 1)
					 wait()
					 Player.Character.HumanoidRootPart.CFrame = CFrame.new(XC,10000,ZC)
				 until flag
			 else
				 Player.Character.HumanoidRootPart.CFrame =
				 TCharacter.HumanoidRootPart.CFrame
				 wait()
				 Player.Character.HumanoidRootPart.CFrame =
				 TCharacter.HumanoidRootPart.CFrame
				 wait()
				 Player.Character.HumanoidRootPart.CFrame = CFrame.new(XC,1000,ZC)
				 wait()
			 end
			 wait(.3)
			 Player.Character:SetPrimaryPartCFrame(CF)
			 if Humanoid.RigType == Enum.HumanoidRigType.R6 then
				 Character["Right Arm"].RightGrip:Destroy()
			 else
				 Character["RightHand"].RightGrip:Destroy()
				 Character["RightHand"].RightGripAttachment:Destroy()
			 end
				 
			 wait(4)
			 CF = Player.Character.HumanoidRootPart.CFrame
			 player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 end)
 
 cmd.add({"localtime", "yourtime"}, {"localtime (yourtime)", "Chats your current time"}, function()
   local hour = os.date("*t")['hour']
		 if hour < 10 then
				 hour = "0"..hour
		 end
		 local min = os.date("*t")['min']
		 if min < 10 then
				 min = "0"..min
		 end
		 local sec = os.date("*t")['sec']
		 if sec < 10 then
				 sec = "0"..sec
		 end
		 local clock = hour..":"..min..":"..sec
 
				  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(clock, 'All')
 
 end)
 
 cmd.add({"cartornado", "ctornado"}, {"cartornado (ctornado)", "Tornados a car just sit in the car"}, function(...)
 local SPart = Instance.new("Part");
 local Player = game:GetService('Players').LocalPlayer;
 repeat game:GetService('RunService').RenderStepped:Wait() until Player.Character;
 local Character = Player.Character;
 SPart.Anchored, SPart.CanCollide = true, true;
 SPart.Parent = workspace;
 SPart.Size = Vector3.new(1, 100, 1)
 SPart.Transparency = 0.4
 game:GetService('RunService').Stepped:Connect(function()
	 local Ray = Ray.new(Character.PrimaryPart.Position + Character.PrimaryPart.CFrame.LookVector * 6, Vector3.new(0,-1,0) * 4);
	 local FPOR = workspace:FindPartOnRayWithIgnoreList(Ray, {Character});
	 if (FPOR) then
		 SPart.CFrame = Character.PrimaryPart.CFrame + Character.PrimaryPart.CFrame.LookVector * 6;
	 end
 if SPart == nil then
 Ray:destroy()
 FPOR:destroy()
 end
 end)
 
 SPart.Touched:Connect(function(hit)
	if hit:IsA("Seat") then
	   local IsFlying = False
 local flyv
 local flyg
 local Player = game.Players.LocalPlayer
 local Speed = 50
 local LastSpeed = Speed
 local maxspeed = 100
 local IsRunning = false
 local f = 0
 
 IsFlying = true
	 flyv = Instance.new("BodyVelocity")
  
	flyv.Parent = Player.Character:FindFirstChild('Torso') or Player.Character:FindFirstChild('UpperTorso')
	 flyv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
  
	 flyg = Instance.new("BodyGyro")
	flyg.Parent = Player.Character:FindFirstChild('Torso') or Player.Character:FindFirstChild('UpperTorso')
	 flyg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	 flyg.P = 1000
	 flyg.D = 50
 
 Player.Character:WaitForChild('Humanoid').PlatformStand = true
 
 Player.Character.Humanoid.Changed:Connect(function(Prop)
   
	if Player.Character.Humanoid.MoveDirection == Vector3.new(0,0,0) then
	 IsRunning = false
	else
	 IsRunning = true
	end 
  end)
 
 spawn(function()
   while true do
	wait()
   if IsFlying then
	
	 flyg.CFrame = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((f+0)*50*Speed/maxspeed),0,0) 
	  flyv.Velocity = workspace.CurrentCamera.CoordinateFrame.LookVector * Speed
	  wait(0.1)
	  
	  if Speed < 0 then
	  Speed = 0
	  f = 0
 end
 end
	if IsRunning then
	Speed = LastSpeed
   else
	if not Speed == 0 then
	 LastSpeed = Speed
	end 
	Speed = 0
   end
   end
 end)
 Speed = 0.1
 wait(0.3)
 hit:Sit(game:GetService("Players").LocalPlayer.Character.Humanoid)
 SPart:Destroy()
 wait(0.3)
 local speaker = game.Players.LocalPlayer
 local seat = speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart
  local vehicleModel = seat.Parent
  repeat
   if vehicleModel.ClassName ~= "Model" then
	vehicleModel = vehicleModel.Parent
   end
  until vehicleModel.ClassName == "Model"
  wait(0.1)
  for i,v in pairs(vehicleModel:GetDescendants()) do
   if v:IsA("BasePart") and v.CanCollide then
	v.CanCollide = false
   end
  end
 
 wait(0.2)
 Speed = 80
 local Spin = Instance.new("BodyAngularVelocity")
 Spin.Name = "Spinning"
 Spin.Parent = getRoot(speaker.Character)
 Spin.MaxTorque = Vector3.new(0, math.huge, 0) 
 Spin.AngularVelocity = Vector3.new(0,2000,0)
 end
 end)
 end)
 
 
 cmd.add({"tornado"}, {"tornado <player>", "Tornados the player to be in the sky"}, function(...)
						 
						 Username = (...)
  
 local target = getPlr(Username)
 local THumanoidPart
 local plrtorso
 local TargetCharacter = target.Character
	if TargetCharacter:FindFirstChild("Torso") then
			plrtorso = TargetCharacter.Torso
		elseif TargetCharacter:FindFirstChild("UpperTorso") then
			plrtorso = TargetCharacter.UpperTorso
		end
		 local old = getChar().HumanoidRootPart.CFrame
		 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
		 if target == nil or tool == nil then return end
		 local attWeld = attachTool(tool,CFrame.new(0,0,0))
		 attachTool(tool,CFrame.new(0,0,0.2) * CFrame.Angles(math.rad(-90),0,0))
		 tool.Grip = plrtorso.CFrame
		 wait(0.07)
 tool.Grip = CFrame.new(0, -7, -3)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,0)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,1)
		 local Spin = Instance.new("BodyAngularVelocity")
	 Spin.Name = "Spinning"
	 Spin.Parent = getRoot(game.Players.LocalPlayer.Character)
	 Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	 Spin.AngularVelocity = Vector3.new(0,40,0)
 end)

 
 cmd.add({"unspam", "unlag", "unchatspam", "unanimlag", "unremotespam"}, {"unspam", "Stop all attempts to lag/spam"}, function()
	 lib.disconnect("spam")
 end)
 
 cmd.add({"respawn", "re"}, {"respawn", "Respawn your character"}, function()
	 local old = getChar().HumanoidRootPart.CFrame
	 respawn()
	 wait()
	 plr.CharacterAdded:Wait()
	 getChar():WaitForChild("HumanoidRootPart").CFrame = old
 end)
 
 cmd.add({"seizure"}, {"seizure", "Gives you a seizure"}, function()
	 
	 spawn(function()
		 local Anim = Instance.new("Animation")
		 if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") then
		 Anim.AnimationId = "rbxassetid://507767968"
		 else
			 Anim.AnimationId = "rbxassetid://180436148"
			 end
		 local k = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	  getgenv().ssss = game.Players.LocalPlayer:GetMouse()
	  getgenv().Lzzz = false
	  
	  if Lzzz == false then
	  getgenv().Lzzz = true
		 if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") then
		 Anim.AnimationId = "rbxassetid://507767968"
		 else
			 Anim.AnimationId = "rbxassetid://180436148"
			 end
	  getgenv().currentnormal = game:GetService("Workspace").Gravity
	  game:GetService("Workspace").Gravity = 196.2
	  game:GetService("Players").LocalPlayer.Character:PivotTo(game:GetService("Players").LocalPlayer.Character:GetPivot() * CFrame.Angles(2, 0, 0))
	  wait(0.5)
	  game:GetService("Players").LocalPlayer.Character.Humanoid.PlatformStand = true
	  game.Players.LocalPlayer.Character.Animate.Disabled = true
	  
		 k:Play()
		 k:AdjustSpeed(10)
		 
	  game.Players.LocalPlayer.Character.Animate.Disabled = true
		 else
	  getgenv().Lzzz = false
		 if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") then
		 Anim.AnimationId = "rbxassetid://507767968"
		 else
			 Anim.AnimationId = "rbxassetid://180436148"
			 end
	  game:GetService("Workspace").Gravity = currentnormal
	  game:GetService("Players").LocalPlayer.Character.Humanoid.PlatformStand = false
	  game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
		 k:Stop()
	   
	  game.Players.LocalPlayer.Character.Animate.Disabled = false
	  game:GetService'RunService'.Heartbeat:Wait()
	  for i = 1,10 do
		  
	  game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		 wait(0.1)
		 end
		  end
	  game:GetService("RunService").RenderStepped:Connect(function()
	  if Lzzz == true then
				  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(.075*math.sin(45*tick()), .075*math.sin(45*tick()),.075*math.sin(45*tick())) --angle*math.sin(velocity*tick())
	  end
	  end)
	  end)
	  
 end)
 
 cmd.add({"unseizure"}, {"unseizure", "Stops you from having a seizure not in real life noob"}, function(n)
 
	 spawn(function()
		 local Anim = Instance.new("Animation")
		 if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") then
		 Anim.AnimationId = "rbxassetid://507767968"
		 else
			 Anim.AnimationId = "rbxassetid://180436148"
			 end
		 local k = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	  getgenv().ssss = game.Players.LocalPlayer:GetMouse()
	  getgenv().Lzzz = true
	  
	  if Lzzz == false then
	  getgenv().Lzzz = true
		 if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") then
		 Anim.AnimationId = "rbxassetid://507767968"
		 else
			 Anim.AnimationId = "rbxassetid://180436148"
			 end
	  getgenv().currentnormal = game:GetService("Workspace").Gravity
	  game:GetService("Workspace").Gravity = 196.2
	  game:GetService("Players").LocalPlayer.Character:PivotTo(game:GetService("Players").LocalPlayer.Character:GetPivot() * CFrame.Angles(2, 0, 0))
	  wait(0.5)
	  game:GetService("Players").LocalPlayer.Character.Humanoid.PlatformStand = true
	  game.Players.LocalPlayer.Character.Animate.Disabled = true
	  
		 k:Play()
		 k:AdjustSpeed(10)
		 
	  game.Players.LocalPlayer.Character.Animate.Disabled = true
		 else
	  getgenv().Lzzz = false
		 if game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso") then
		 Anim.AnimationId = "rbxassetid://507767968"
		 else
			 Anim.AnimationId = "rbxassetid://180436148"
			 end
	  game:GetService("Workspace").Gravity = currentnormal
	  game:GetService("Players").LocalPlayer.Character.Humanoid.PlatformStand = false
	  game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
		 k:Stop()
	   
	  game.Players.LocalPlayer.Character.Animate.Disabled = false
	  game:GetService'RunService'.Heartbeat:Wait()
	  for i = 1,10 do
		  
	  game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		 wait(0.1)
		 end
		  end
	  game:GetService("RunService").RenderStepped:Connect(function()
	  if Lzzz == true then
				  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(.075*math.sin(45*tick()), .075*math.sin(45*tick()),.075*math.sin(45*tick())) --angle*math.sin(velocity*tick())
	  end
	  end)
	  end)
	  
 end)
 
 cmd.add({"antisit"}, {"antisit", "Antisit"}, function()
			 Player.Character.Humanoid:SetStateEnabled("Seated", false)
					 Player.Character.Humanoid.Sit = true
					 
					 
					 
					 wait();
					 
					 Notify({
					 Description = "Anti sit enabled";
					 Title = "Nameless Admin";
					 Duration = 5;
					 
 });
 end)
 
 cmd.add({"unantisit"}, {"unantisit", "Disable antisit command"}, function()
		 Player.Character.Humanoid:SetStateEnabled("Seated", true)
					 Player.Character.Humanoid.Sit = false
					 
					 
					 
					 wait();
					 
					 Notify({
					 Description = "Anti sit disabled";
					 Title = "Nameless Admin";
					 Duration = 5;
					 
 });
 end)
 
 cmd.add({"lay"}, {"lay", "zzzzzzzz"}, function()
	 local Human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid
	 if not Human then
		 return
	 end
	 Human.Sit = true
	 task.wait(.1)
	 Human.RootPart.CFrame = Human.RootPart.CFrame * CFrame.Angles(math.pi * .5, 0, 0)
	 for _, v in ipairs(Human:GetPlayingAnimationTracks()) do
		 v:Stop()
	 end
 end)
 
 cmd.add({"trip"}, {"trip", "get up NOW"}, function()
	game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(0)
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 25
 end)
 
 cmd.add({"checkrfe"}, {"checkrfe", "Checks if the game has respect filtering enabled off"}, function()
		 if game:GetService("SoundService").RespectFilteringEnabled == true then
 
			 Notify({
				 Description = "Respect Filtering Enabled is on";
				 Title = "Nameless Admin";
				 Duration = 5;
				 
				 });
			 else
				 
 Notify({
	 Description = "Respect Filtering Enabled is off";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
	 });
 end
 end)
 
 cmd.add({"sit"}, {"sit", "Sit your player"}, function()
	 local hum = character:FindFirstChildWhichIsA("Humanoid")
	 if hum then
		 hum.Sit = true
	 end
 end)
 
 cmd.add({"spin"}, {"spin", "Spin yourself at the speed you want"}, function(d)
	 local spinSpeed = tonumber(d)
	 if d and isNumber(d) then
		 spinSpeed = (d)
	 end
	 for i,v in pairs(getRoot(game.Players.LocalPlayer.Character):GetChildren()) do
		 if v.Name == "Spinning" then
			 v:Destroy()
		 end
	 end
	 local Spin = Instance.new("BodyAngularVelocity")
	 Spin.Name = "Spinning"
	 Spin.Parent = getRoot(speaker.Character)
	 Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	 Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
 end)
 
 cmd.add({"oldroblox"}, {"oldroblox", "Old skybox and studs"}, function()
	 for i,v in pairs(workspace:GetDescendants()) do
		 if v:IsA("BasePart") then
			 local dec = Instance.new("Texture", v)
			 dec.Texture = "rbxassetid://48715260"
			 dec.Face = "Top"
			 dec.StudsPerTileU = "1"
			 dec.StudsPerTileV = "1"
			 dec.Transparency = v.Transparency
			 v.Material = "Plastic"
			 local dec2 = Instance.new("Texture", v)
			 dec2.Texture = "rbxassetid://20299774"
			 dec2.Face = "Bottom"
			 dec2.StudsPerTileU = "1"
			 dec2.StudsPerTileV = "1"
			 dec2.Transparency = v.Transparency
			 v.Material = "Plastic"
		 end
	 end
	 game.Lighting.ClockTime = 12
	 game.Lighting.GlobalShadows = false
	 game.Lighting.Outlines = false
	 for i,v in pairs(game.Lighting:GetDescendants()) do
		 if v:IsA("Sky") then
			 v:Destroy()
		 end
	 end
	 local sky = Instance.new("Sky", game.Lighting)
	 sky.SkyboxBk = "rbxassetid://161781263"
	 sky.SkyboxDn = "rbxassetid://161781258"
	 sky.SkyboxFt = "rbxassetid://161781261"
	 sky.SkyboxLf = "rbxassetid://161781267"
	 sky.SkyboxRt = "rbxassetid://161781268"
	 sky.SkyboxUp = "rbxassetid://161781260"
 end)
 
			 cmd.add({"triggerbot", "tbot"}, {"triggerbot (tbot)", "Executes a script that automatically clicks the mouse when the mouse is on a player"}, function()
 local ToggleKey = Enum.KeyCode.Q
 
 
 local Player = game:GetService("Players").LocalPlayer
 local Char = Player.Character or player.CharacterAdded:wait(1)
 local Root = Char.HumanoidRootPart or Char:WaitForChild("HumanoidRootPart")
 local Camera = game.Workspace.CurrentCamera
 local Mouse = Player:GetMouse()
 local PlayerTeam = Player.Team
 local Neutral = Player.Neutral
 local UIS = game:GetService("UserInputService")
 local Toggled = false
 
 ---==GUI==---
 local GUI = Instance.new("ScreenGui")
 local On = Instance.new("TextLabel")
 local uicorner = Instance.new("UICorner")
 GUI.Name = "GUI"
 GUI.Parent = game.CoreGui --game.Players.LocalPlayer:WaitForChild("PlayerGui")
 On.Name = "On"
 On.Parent = GUI
 On.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
 On.BackgroundTransparency = 0.14
 On.BorderSizePixel = 0
 On.Position = UDim2.new(0.880059958, 0, 0.328616381, 0)
 On.Size = UDim2.new(0, 160, 0, 20)
 On.Font = Enum.Font.SourceSans
 On.Text = "TriggerBot On: false"
 On.TextColor3 = Color3.new(1, 1, 1)
 On.TextScaled = true
 On.TextSize = 14
 On.TextWrapped = true
 uicorner.Parent = On
 ---End Gui--
 
 local FindTeams = function()
	 local CC1 = false
	 local CC2 = false
	 
 if PlayerTeam ~= nil and Neutral == false then
		 if #game:GetService("Teams"):GetTeams() > 0 then
		 CC1 = true
		 for i, v in pairs(game:GetService("Teams"):GetTeams()) do
			 if #v:GetPlayers() > 0 and v ~= PlayerTeam and CC1 == true then
				 CC2 = true
			 elseif #v:GetPlayers() <= 0 and CC1 == true then
				 return "FFA"
			 end
		 end
		 elseif #game:GetService("Teams"):GetTeams() <= 0 then
			 return "FFA"
		 end
 elseif Neutral == true then
	 return "FFA"	
 elseif PlayerTeam == nil then
	 return "FFA"
 end
 if CC1 == true and CC2 == true then
	 return "TEAMS"
 end
 end
 --{[/| Functions |\]}--
 
 function Click()
	 mouse1click()
	 --print("Tripped")
 end
 function CastRay(Mode)
	 local RaySPTR = Camera:ScreenPointToRay(Mouse.X, Mouse.Y) --Hence the var name, the magnitude of this is 1.
	 local NewRay = Ray.new(RaySPTR.Origin, RaySPTR.Direction * 9999)
	 local Target, Position = workspace:FindPartOnRayWithIgnoreList(NewRay, {Char,workspace.CurrentCamera})
	 if Target and Position and game:GetService("Players"):GetPlayerFromCharacter(Target.Parent) and Target.Parent.Humanoid.Health > 0 or Target and Position and game:GetService("Players"):GetPlayerFromCharacter(Target.Parent.Parent) and Target.Parent.Parent.Humanoid.Health > 0 then
		 local TPlayer = game:GetService("Players"):GetPlayerFromCharacter(Target.Parent) or game:GetService("Players"):GetPlayerFromCharacter(Target.Parent.Parent)
		 if TPlayer.Team ~= PlayerTeam and Mode ~= "FFA" and TPlayer ~= Player then
			 Click()
		 elseif TPlayer.Team == PlayerTeam and TPlayer ~= Player then
			 if Mode == "FFA" then
				 Click()
			 end
		 end
	 end
 end
 --End Functions--
 UIS.InputBegan:Connect(function(Input)
	 if Input.KeyCode == ToggleKey then
		 Toggled = not Toggled
		 On.Text = "Trigger Bot On: ".. tostring(Toggled)
	 end
 end)
 
 local PreMode = FindTeams()
 local O = false
 game:GetService("RunService").Stepped:Connect(function()
		 local Mode = FindTeams()
	 if O == false then
		 O = true
		 print(Mode)
	 end
	 if Mode ~= PreMode then
		 PreMode = Mode
		 print(Mode)
	 end
	 if Toggled == true then
 
	 CastRay(Mode)
 end
 end)
 
 print("BrokenCoding's Trigger Bot V4 Loaded")
 spawn(function()
	 wait(2)
	 Loaded:Destroy()
 end)
 
 
 
 wait();
 
 Notify({
 Description = "Keybind: Q";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
				 end)
 
			 
		 cmd.add({"nofog"}, {"nofog", "Removes all fog from the game"}, function()
			 local Lighting = game.Lighting
			 Lighting.FogEnd = 100000
			 for i,v in pairs(Lighting:GetDescendants()) do
				 if v:IsA("Atmosphere") then
					 v:Destroy()
				 end
			 end
			 end)
 
			 cmd.add({"antiafk", "noafk"}, {"antiafk (noafk)", "Makes you not be kicked for being afk for 20 mins"}, function()
				 
				 
				 
				 wait();
				 
				 Notify({
				 Description = "Anti AFK has been enabled";
				 Title = "Nameless Admin";
				 Duration = 5;
				 
 });
				 ANTIAFK = game.Players.LocalPlayer.Idled:connect(function()
					 game:FindService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
					 task.wait(1)
					 game:FindService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
					 end)
				 end)
	 
 
				 cmd.add({"antiattach", "noattach"}, {"antiattach (noattach)", "Makes you not be able to be attached by using a item"}, function()
					 local Tools = {}
					 for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
						 if v:IsA("Tool") then
							 table.insert(Tools,v:GetDebugId())
						 end
					 end
					 for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
						 if v:IsA("Tool") then
							 table.insert(Tools,v:GetDebugId())
						 end
					 end
					 AAttach = game.Players.LocalPlayer.Character.ChildAdded:Connect(function(instance)
						 if instance:IsA("Tool") and not table.find(Tools,instance:GetDebugId()) then
							 task.wait()
							 instance.Parent = nil
						 end
						 end)
						 
						 
						 
						 wait();
						 
						 Notify({
						 Description = "Anti attach enabled";
						 Title = "Nameless Admin";
						 Duration = 5;
						 
 });
					 end)
 
					 cmd.add({"unantiattach", "unnoattach"}, {"unantiattach (unnoattach)", "Makes you to be able for others to attach you"}, function()
						 if AAttach then
							 AAttach:Disconnect()
							 
							 
							 
							 wait();
							 
							 Notify({
							 Description = "Anti attach disabled";
							 Title = "Nameless Admin";
							 Duration = 5;
							 
 });
						 else
							 
							 
							 
							 wait();
							 
							 Notify({
							 Description = "Anti attach already disabled";
							 Title = "Nameless Admin";
							 Duration = 5;
							 
 });
						 end
						 end)
 
						 cmd.add({"setspawn", "spawnpoint", "ss"}, {"setspawn (spawnpoint, ss)", "Makes your spawn point be in the place where your character is"}, function()
							 
							 
							 
							 wait();
							 
							 Notify({
							 Description = "Spawn has been set";
							 Title = "Nameless Admin";
							 Duration = 5;
							 
 });
							 local stationaryrespawn = true
 local needsrespawning = false
 local haspos = false
 local pos = CFrame.new()
 
 game:GetService("UserInputService").InputBegan:connect(StatRespawn)
 
 game:GetService('RunService').Stepped:connect(function()
 
 if stationaryrespawn == true and game.Players.LocalPlayer.Character.Humanoid.Health == 0 then
 if haspos == false then
 pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
 haspos = true
 end
 needsrespawning = true
 end
 
 if needsrespawning == true then
 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
 end
 end)

 game.Players.LocalPlayer.CharacterAdded:connect(function()
 wait(0.6)
 needsrespawning = false
 haspos = false
 end)
							 end)
							 
 cmd.add({"hamster"}, {"hamster <speed>", "Hamster ball"}, function(...)
	-- [[ skidded ]] --
 local UserInputService = game:GetService("UserInputService")
 local RunService = game:GetService("RunService")
 local Camera = workspace.CurrentCamera
 
 local SPEED_MULTIPLIER = (...)
 local JUMP_POWER = 60
 local JUMP_GAP = 0.3
 
 if (...) == nil then
	 SPEED_MULTIPLIER = 30
	 end
 
 local character = game.Players.LocalPlayer.Character
 
 for i,v in ipairs(character:GetDescendants()) do
	if v:IsA("BasePart") then
		v.CanCollide = false
	end
 end
 
 local ball = character.HumanoidRootPart
 ball.Shape = Enum.PartType.Ball
 ball.Size = Vector3.new(5,5,5)
 local humanoid = character:WaitForChild("Humanoid")
 local params = RaycastParams.new()
 params.FilterType = Enum.RaycastFilterType.Blacklist
 params.FilterDescendantsInstances = {character}
 
 local tc = RunService.RenderStepped:Connect(function(delta)
	ball.CanCollide = true
	humanoid.PlatformStand = true
 if UserInputService:GetFocusedTextBox() then return end
 if UserInputService:IsKeyDown("W") then
 ball.RotVelocity -= Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
 end
 if UserInputService:IsKeyDown("A") then
 ball.RotVelocity -= Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
 end
 if UserInputService:IsKeyDown("S") then
 ball.RotVelocity += Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
 end
 if UserInputService:IsKeyDown("D") then
 ball.RotVelocity += Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
 end
 end)
 
 UserInputService.JumpRequest:Connect(function()
 local result = workspace:Raycast(
 ball.Position,
 Vector3.new(
 0,
 -((ball.Size.Y/2)+JUMP_GAP),
 0
 ),
 params
 )
 if result then
 ball.Velocity = ball.Velocity + Vector3.new(0,JUMP_POWER,0)
 end
 end)
 
 Camera.CameraSubject = ball
 humanoid.Died:Connect(function() tc:Disconnect() end)
 end)
 
				 cmd.add({"unantiafk", "unnoafk"}, {"unantiafk (unnoafk)", "Makes you able to be kicked for being afk for 20 mins"}, function()
					 if ANTIAFK then
						 ANTIAFK:Disconnect()
						 wait();
						 
						 Notify({
						 Description = "Anti AFK disabled";
						 Title = "Nameless Admin";
						 Duration = 5;
						 
 });
					 else 
						 wait();
						 
						 Notify({
						 Description = "Anti AFK already disabled";
						 Title = "Nameless Admin";
						 Duration = 5;
						 
 });
					 end
					 end)
 
			 cmd.add({"toolgui"}, {"toolgui", "cool tool ui aka replication ui made by 0866"}, function()
				Notify({
					Description = "Possible, but too lazy and I'm making this at 11PM so.";
					Title = "Nameless Admin";
					Duration = 5;
				});
 wait();
 
 Notify({
 Description = "For a better experience, use R6 if you want tools do ;dupetools 5";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
				 end)
 
				 cmd.add({"clicktp"}, {"clicktp", "Teleport where your mouse is"}, function()
					 mouse = game.Players.LocalPlayer:GetMouse()
 tool = Instance.new("Tool")
 tool.RequiresHandle = false
 tool.Name = "Click TP"
 tool.Activated:connect(function()
 local pos = mouse.Hit+Vector3.new(0,2.5,0)
 pos = CFrame.new(pos.X,pos.Y,pos.Z)
 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
 end)
 tool.Parent = game.Players.LocalPlayer.Backpack
 wait(0.07)
 local TweenService = game:GetService("TweenService")
 local UserInputService = game:GetService("UserInputService")
 local Players = game:GetService("Players")
 
 local tool = Instance.new("Tool")
 tool.RequiresHandle = false
 tool.Name = "Tween Click TP"
 local function onActivated()
	 local mouse = Players.LocalPlayer:GetMouse()
	 local pos = mouse.Hit + Vector3.new(0,2.5,0)
	 local humanoidRootPart = Players.LocalPlayer.Character.HumanoidRootPart
 
	 local tweenInfo = TweenInfo.new(
		 1,
		 Enum.EasingStyle.Quad,
		 Enum.EasingDirection.Out,
		 0,
		 false,
		 0
	 )
 
	 local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
		 CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
	 })
 
	 tween:Play()
 end
 
 tool.Activated:Connect(onActivated)
 tool.Parent = Players.LocalPlayer.Backpack
					 end)
 
 cmd.add({"dex"}, {"dex", "Using this you can see the parts / guis / scripts etc with this. A really good and helpful script."}, function()
	Notify({
		Description = "Possible, but too lazy and I'm making this at 11PM so.";
		Title = "Nameless Admin";
		Duration = 5;
	});
 end)
		 
			 cmd.add({"antikill"}, {"antikill", "Makes exploiters not be able to kill you"}, function()
					 Player.Character.Humanoid:SetStateEnabled("Seated", false)
					 Player.Character.Humanoid.Sit = true
					 wait();
					 
					 Notify({
					 Description = "Anti kill enabled";
					 Title = "Nameless Admin";
					 Duration = 5;
					 
 });
			 end)
			 
 cmd.add({"gayrate"}, {"gayrate <player>", "Gay scale of a player"}, function(...)
 Username = (...)
 target = getPlr(Username)
	 local coolPercentage = math.random(1, 100)
	 rate = target.Name .. ' is ' .. coolPercentage .. '% gay'
	  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(rate, 'All')
 end)
 
 cmd.add({"coolrate"}, {"coolrate <player>", "Cool scale of a player"}, function(...)
 Username = (...)
 target = getPlr(Username)
	 local coolPercentage = math.random(1, 100)
	 rate = target.Name .. ' is ' .. coolPercentage .. '% cool'
	  game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(rate, 'All')
 end)
 
			 cmd.add({"unantikill"}, {"unantikill", "Makes exploiters to be able to kill you"}, function()
				 Player.Character.Humanoid:SetStateEnabled("Seated", true)
				 Player.Character.Humanoid.Sit = false
				 
				 
				 
				 wait();
				 
				 Notify({
				 Description = "Anti kill disabled";
				 Title = "Nameless Admin";
				 Duration = 5;
				 
 });
		 end)

		 AntiFling = false
			 cmd.add({"antifling"}, {"antifling", "makes it so you cant collide with others"}, function()
 AntiFling = true

 local function NoCollision(PLR)
	 if AntiFling and PLR.Character then
		 for _,x in pairs(PLR.Character:GetDescendants()) do
			 if x:IsA("BasePart") and x.CanCollide then
				 x.CanCollide = false
			 end
		 end
	 end
 end
 for _,v in pairs(game.Players:GetPlayers()) do
	 if v ~= game.Players then
		 local antifling = game:GetService('RunService').Stepped:connect(function()
			 NoCollision(v)
		 end)
	 end
 end
 game.Players.PlayerAdded:Connect(function()
	 if v ~= game.Players.LocalPlayer and antifling then
		 local antifling = game:GetService('RunService').Stepped:connect(function()
			NoCollision(v)
		 end)
	 end
 end)
 
 wait();
 Notify({
 Description = "Anti fling enabled";
 Title = "Nameless Admin";
 Duration = 5;
 
});
			 end)

			 cmd.add({"unantifling"}, {"unantifling", "removes antifling"}, function()
AntiFling = true

wait();
Notify({
Description = "Anti fling disabled";
Title = "Nameless Admin";
Duration = 5;

});

for _,v in pairs(game.Players:GetPlayers()) do
	if v ~= game.Players then
char = v.Character
for _,x in pairs(char:GetDescendants()) do
	if x:IsA("BasePart") then
		x.CanCollide = true
	end
end
	end
end
			 end)

			 cmd.add({"flingnpcs"}, {"flingnpcs", "Flings NPCs"}, function()
 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
		   hum.HipHeight = 1024
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
			 cmd.add({"voidnpcs"}, {"voidnpcs", "Voids NPCs"}, function()
 
 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
		   hum.HipHeight = -1024
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
 cmd.add({"npcfollow"}, {"npcfollow", "Makes NPCS follow you"}, function()
	 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
   local rootPart = hum.Parent:FindFirstChild("HumanoidRootPart")
				 local targetPos = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
				 hum:MoveTo(targetPos)
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
npcfollowloop = false
 cmd.add({"loopnpcfollow"}, {"loopnpcfollow", "Makes NPCS follow you in a loop"}, function()
npcfollowloop = true

	repeat wait(0.1)
	local npcs = {}
 
	local function disappear(hum)
	  if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		table.insert(npcs,{hum,hum.HipHeight})
  local rootPart = hum.Parent:FindFirstChild("HumanoidRootPart")
				local targetPos = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
				hum:MoveTo(targetPos)
		end
	end
	for _,hum in pairs(workspace:GetDescendants()) do
	  disappear(hum)
	end
until npcfollowloop == false
 end)

 cmd.add({"unloopnpcfollow"}, {"unloopnpcfollow", "Makes NPCS not follow you in a loop"}, function()
	npcfollowloop = false
 end)

 cmd.add({"sitnpcs"}, {"sitnpcs", "Makes NPCS sit"}, function()
	 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
   local rootPart = hum.Parent:FindFirstChild("HumanoidRootPart")
		 if rootPart then
			 hum.Sit = true
		 end      
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
 cmd.add({"unsitnpcs"}, {"unsitnpcs", "Makes NPCS unsit"}, function()
	 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
   local rootPart = hum.Parent:FindFirstChild("HumanoidRootPart")
		 if rootPart then
			 hum.Sit = true
		 end      
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
 cmd.add({"vehiclespeed", "vspeed"}, {"vehiclespeed <amount> (vspeed)", "Change the vehicle speed"}, function(...)
	 if vehicleloopspeed then
		 vehicleloopspeed:Disconnect()
	 end
	 local UserInputService = game:GetService("UserInputService")
	 local GuiService = game:GetService("GuiService")
	 local LocalPlayer = game:GetService("Players").LocalPlayer
	 
	 local intens = (...)
	 
	 vehicleloopspeed = game:GetService("RunService").Stepped:Connect(function()
			local Humanoid = workspace.CurrentCamera.CameraSubject;
			if Humanoid:IsA("Humanoid") then
				Humanoid.SeatPart:ApplyImpulse(Humanoid.SeatPart.CFrame.LookVector * Vector3.new(intens, intens, intens))
			elseif Humanoid:IsA("BasePart") then
				Humanoid:ApplyImpulse(Humanoid.CFrame.LookVector * Vector3.new(intens, intens, intens))
			end
	 end)
 end)
 
 cmd.add({"unvehiclespeed", "unvspeed"}, {"unvehiclespeed (unvspeed)", "Stops the vehiclespeed command"}, function()
	 vehicleloopspeed = vehicleloopspeed:Disconnect()
 end)
 
 cmd.add({"killnpcs"}, {"killnpcs", "Kills NPCs"}, function()
	 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
   local rootPart = hum.Parent:FindFirstChild("HumanoidRootPart")
		 if rootPart then
			 hum.Health = 0
		 end      
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
 cmd.add({"bringnpcs"}, {"bringnpcs", "Brings NPCs"}, function()
 local npcs = {}
 
	 local function disappear(hum)
	   if hum:IsA("Humanoid") and not game.Players:GetPlayerFromCharacter(hum.Parent) then
		 table.insert(npcs,{hum,hum.HipHeight})
   local rootPart = hum.Parent:FindFirstChild("HumanoidRootPart")
		 if rootPart then
			 rootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		 end      
		 end
	 end
	 for _,hum in pairs(workspace:GetDescendants()) do
	   disappear(hum)
	 end
 end)
 
 cmd.add({"controlnpcs", "cnpcs"}, {"controlnpcs (cnpcs)", "Keybind: CTRL + LEFTCLICK"}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "ControlNPCs executed, CTRL + Click on an NPC";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 --- made by joshclark756#7155
 local mouse = game.Players.LocalPlayer:GetMouse()
 local uis = game:GetService("UserInputService")
 mouse.Button1Down:Connect(function()
	if mouse.Target and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
 local npc = mouse.target.Parent
 local npcRootPart = npc.HumanoidRootPart
 local PlayerCharacter = game:GetService("Players").LocalPlayer.Character
 local PlayerRootPart = PlayerCharacter.HumanoidRootPart
 local A0 = Instance.new("Attachment")
 local AP = Instance.new("AlignPosition")
 local AO = Instance.new("AlignOrientation")
 local A1 = Instance.new("Attachment")
 for _, v in pairs(npc:GetDescendants()) do
 if v:IsA("BasePart") then
 game:GetService("RunService").Stepped:Connect(function()
 v.CanCollide = false
 end)
 end
 end
 PlayerRootPart:BreakJoints()
 for _, v in pairs(PlayerCharacter:GetDescendants()) do
 if v:IsA("BasePart") then
 if v.Name == "HumanoidRootPart" or v.Name == "UpperTorso" or v.Name == "Head" then
 else
 v:Destroy()
 end
 end
 end
 PlayerRootPart.Position = PlayerRootPart.Position+Vector3.new(5, 0, 0)
 PlayerCharacter.Head.Anchored = true
 PlayerCharacter.UpperTorso.Anchored = true
 A0.Parent = npcRootPart
 AP.Parent = npcRootPart
 AO.Parent = npcRootPart
 AP.Responsiveness = 200
 AP.MaxForce = math.huge
 AO.MaxTorque = math.huge
 AO.Responsiveness = 200
 AP.Attachment0 = A0
 AP.Attachment1 = A1
 AO.Attachment1 = A1
 AO.Attachment0 = A0
 A1.Parent = PlayerRootPart
 end
 end)
	 end)
 
 cmd.add({"attachpart"}, {"attachpart", "Keybind: CTRL + LEFTCLICK"}, function()

 wait();
 
 Notify({
 Description = "AttachPart executed, CTRL + Click on a part";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 -- made by joshclark756#7155
 -- Variables
 local mouse = game.Players.LocalPlayer:GetMouse()
 local uis = game:GetService("UserInputService")
 
 -- Connect
 mouse.Button1Down:Connect(function()
	-- Check for Target & Left Shift
	if mouse.Target and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
 local npc = mouse.target
 local npcparts = mouse.target.Parent
 local PlayerCharacter = game:GetService("Players").LocalPlayer.Character
 local PlayerRootPart = PlayerCharacter.HumanoidRootPart
 local A0 = Instance.new("Attachment")
 local AP = Instance.new("AlignPosition")
 local AO = Instance.new("AlignOrientation")
 local A1 = Instance.new("Attachment")
 for _, v in pairs(npcparts:GetDescendants()) do
 if v:IsA("BasePart") or v:IsA("Part") and v.Name ~= "HumanoidRootPart" then
 do
 v.CanCollide = false
 
 end
 end
 end
 -- Variables
 local mouse = game.Players.LocalPlayer:GetMouse()
 local uis = game:GetService("UserInputService")
 
 -- Connect
 mouse.Button1Down:Connect(function()
	if mouse.Target and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
 local npc = mouse.target
 local npcparts = mouse.target.Parent
 local PlayerCharacter = game:GetService("Players").LocalPlayer.Character
 local PlayerRootPart = PlayerCharacter.HumanoidRootPart
 local A0 = Instance.new("Attachment")
 local AP = Instance.new("AlignPosition")
 local AO = Instance.new("AlignOrientation")
 local A1 = Instance.new("Attachment")
 for _, v in pairs(npcparts:GetDescendants()) do
 if v:IsA("BasePart") or v:IsA("Part") and v.Name ~= "HumanoidRootPart" then
 do
 v.CanCollide = false
 
 wait(0)
 local player = game.Players.LocalPlayer
 local mouse = player:GetMouse()
 bind = "e" -- has to be lowercase
 mouse.KeyDown:connect(function(key)
 if key == bind then do
 v.CanCollide = true
 end
 end
 end)
 end
 end
 end
 for _, v in pairs(PlayerCharacter:GetDescendants()) do
 if v:IsA("BasePart") then
 if v.Name == "HumanoidRootPart" or v.Name == "UpperTorso" or v.Name == "Head" then
 
 end
 end
 end
 PlayerRootPart.Position = PlayerRootPart.Position+Vector3.new(0, 0, 0)
 PlayerCharacter.Head.Anchored = false
 PlayerCharacter.Torso.Anchored = false
 A0.Parent = npc
 AP.Parent = npc
 AO.Parent = npc
 AP.Responsiveness = 200
 AP.MaxForce = math.huge
 AO.MaxTorque = math.huge
 AO.Responsiveness = 200
 AP.Attachment0 = A0
 AP.Attachment1 = A1
 AO.Attachment1 = A1
 AO.Attachment0 = A0
 A1.Parent = PlayerRootPart
 end
 end)
 for _, v in pairs(PlayerCharacter:GetDescendants()) do
 if v:IsA("BasePart") then
 if v.Name == "HumanoidRootPart" or v.Name == "UpperTorso" or v.Name == "Head" then
 
 end
 end
 end
 PlayerRootPart.Position = PlayerRootPart.Position+Vector3.new(0, 0, 0)
 PlayerCharacter.Head.Anchored = false
 PlayerCharacter.Torso.Anchored = false
 A0.Parent = npc
 AP.Parent = npc
 AO.Parent = npc
 AP.Responsiveness = 200
 AP.MaxForce = math.huge
 AO.MaxTorque = math.huge
 AO.Responsiveness = 200
 AP.Attachment0 = A0
 AP.Attachment1 = A1
 AO.Attachment1 = A1
 AO.Attachment0 = A0
 A1.Parent = PlayerRootPart
 end
 end)
	 end)

	 active = false
	 local MobileCameraFramework = {}
	local players = game:GetService("Players")
	local runservice = game:GetService("RunService")
	local CAS = game:GetService("ContextActionService")
	local camera = workspace.CurrentCamera
	
	uis = game:GetService("UserInputService")
	ismobile = uis.TouchEnabled
	
	local MAX_LENGTH = 900000
	local active = false
	local ENABLED_OFFSET = CFrame.new(1.7, 0, 0)
	local DISABLED_OFFSET = CFrame.new(-1.7, 0, 0)
	local function UpdateAutoRotate(BOOL)
		humanoid.AutoRotate = BOOL
	end
	local function GetUpdatedCameraCFrame(ROOT, CAMERA)
		return CFrame.new(root.Position, Vector3.new(CAMERA.CFrame.LookVector.X * MAX_LENGTH, root.Position.Y, CAMERA.CFrame.LookVector.Z * MAX_LENGTH))
	end
	local function EnableShiftlock()
		local player = players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character.Humanoid
		UpdateAutoRotate(false)
		root.CFrame = GetUpdatedCameraCFrame(root, camera)
		camera.CFrame = camera.CFrame * ENABLED_OFFSET
	end
	local function DisableShiftlock()
		local player = players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character.Humanoid
		UpdateAutoRotate(true)
		camera.CFrame = camera.CFrame * DISABLED_OFFSET
		pcall(function()
			active:Disconnect()
			active = nil
		end)
	end
	active = false
	function ShiftLock()
		local player = players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character.Humanoid
		if not active then
			active = runservice.RenderStepped:Connect(function()
				EnableShiftlock()
			end)
		else
			DisableShiftlock()
		end
	end
cmd.add({"shiftlock", "sl"}, {"shiftlock (sl)", "Enable shiftlock"}, function()
	EnableShiftlock()	
end)
 
cmd.add({"unshiftlock", "unsl"}, {"unshiftlock (unsl)", "Disables shiftlock if you're on mobile"}, function()
	DisableShiftlock()
end)

cmd.add({"ctrlshiftlock", "ctrlsl"}, {"ctrlshiftlock (ctrlsl)", "Enables shift lock if you press Control"}, function()
	game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule.CameraModule.MouseLockController.BoundKeys.Value = "LeftControl,RightControl"
end)

	 cmd.add({"esp"}, {"esp", "ESP"}, function()
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local LP = Players.LocalPlayer
 local roles
 function CreateAllHighlight(p)
	 for i, v in pairs(game.Players:GetChildren()) do
		 if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
			 Instance.new("Highlight", v.Character)           
		 end
	 end
 end
 function UpdateAllHighlights()
	 for _, v in pairs(game.Players:GetChildren()) do
		 if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") then
			 Highlight = v.Character:FindFirstChild("Highlight")
				 Highlight.FillColor = Color3.fromRGB(0, 225, 0)
			 end
		 end
	 end

	 function CreateHighlight(p)
		for i, v in pairs(p:GetChildren()) do
			if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
				Instance.new("Highlight", v.Character)           
			end
		end
	end
	function UpdateHighlights(p)
		for _, v in pairs(p:GetChildren()) do
			if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") then
				Highlight = v.Character:FindFirstChild("Highlight")
					Highlight.FillColor = Color3.fromRGB(0, 225, 0)
				end
			end
		end

 function IsAlive(Player)
	 for i, v in pairs(roles) do
		 if Player.Name == i then
			 if not v.Killed and not v.Dead then
				 return true
			 else
				 return false
			 end
		 end
	 end
 end
 CreateAllHighlight()
	 UpdateAllHighlights(game.Players)

	 Players = game.Players
COREGUI = game.CoreGui

for i,plr in pairs(game.Players:GetChildren()) do
for i,v in pairs(COREGUI:GetChildren()) do
			if v.Name == plr.Name..'_ESP' then
				v:Destroy()
			end
if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not COREGUI:FindFirstChild(plr.Name..'_ESP') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name..'_ESP'
			ESPholder.Parent = COREGUI

			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = plr.Character.Head
				BillboardGui.Name = plr.Name
				BillboardGui.Parent = ESPholder
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = UDim2.new(0, 100, 0, 100)
				TextLabel.Font = Enum.Font.SourceSansSemibold
				TextLabel.TextSize = 17
				TextLabel.TextColor3 = Color3.new(12, 4, 20)
				TextLabel.TextStrokeTransparency = 0.3
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = '@'..plr.Name .. ' | ' .. plr.DisplayName .. ''
				TextLabel.ZIndex = 10
				local espLoopFunc
				local teamChange
				local addedFunc
				end
end
end

	addedFunc = plr.CharacterAdded:Connect(function()
		wait(2)
		CreateHighlight(plr)
		UpdateHighlights(plr)
					if ESPenabled then
						espLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until plr.Character.HumanoidRootPart and plr.Character:FindFirstChildOfClass("Humanoid")
						ESP(plr)
					else
						addedFunc:Disconnect()
					end
				end)
end
	 end)
 
		 cmd.add({"unesp"}, {"unesp", "Disables esp"}, function()
			addedFunc:Disconnect()
 for _, player in ipairs(game.Players:GetPlayers()) do
	 local character = player.Character
	 if character then
		 local highlight = character:FindFirstChild("Highlight")
		 if highlight then
			 highlight:Destroy()
		 end
	 end
 end
 
 game.Players.PlayerAdded:Connect(function(player)
	 player.CharacterAdded:Connect(function(character)
		 local highlight = character:FindFirstChild("Highlight")
		 if highlight then
			 highlight:Destroy()
		 end
	 end)
 end)

 for i,b in pairs(game.CoreGui:GetChildren()) do
if b:IsA("Folder") then
		b:Destroy()
end
 end
		 end)
 
	 cmd.add({"creep", "ctp", "scare"}, {"ctp <player> (creep, scare)", "Teleports from a player behind them and under the floor to the top"}, function(...)
		 Players = game:GetService("Players")
		 HRP = game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored
		 
		 Username = (...)
		 
		 local target = getPlr(Username)
		 
			 getChar().HumanoidRootPart.CFrame = target.Character.Humanoid.RootPart.CFrame * CFrame.new(0, -10, 4)
			 wait()
			 if connections["noclip"] then lib.disconnect("noclip") return end
			 lib.connect("noclip", RunService.Stepped:Connect(function()
				 if not character then return end
				 for i, v in pairs(character:GetDescendants()) do
					 if v:IsA("BasePart") then
						 v.CanCollide = false
					 end
				 end
			 end))
			 wait()
			 game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
			 wait()
							  tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(1000, Enum.EasingStyle.Linear)
					  
				 tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(0, 10000, 0)})
				 tween:Play()
				 wait(1.5)
				 tween:Pause()
				 game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
				 wait()
				 lib.disconnect("noclip")
				 
	 end)
	 cmd.add({"netless", "net"}, {"netless (net)", "Executes netless which makes scripts more stable"}, function()
 for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
	 if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
	 game:GetService("RunService").Heartbeat:connect(function()
	 v.Velocity = Vector3.new(-30,0,0)
	 end)
	 end
	 end

 wait();
 
 Notify({
 Description = "Netless has been activated, re-run this script if you die";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end)
 
 cmd.add({"rocket"}, {"rocket <player>", "rockets a player"}, function(...)
	 
 
 
 wait();
 
 Notify({
 Description = "Get ready to launch...";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 wait(0.2)
						   local OldPos = getRoot().CFrame
	 tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(70, Enum.EasingStyle.Linear)
			  
	 tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(0, 10000, 0)})
	 tween:Play()
	 Username = (...)
 
	 Target = (...)
	 local TPlayer = getPlr(Target)
				TRootPart = TPlayer.Character.HumanoidRootPart
				local Character = Player.Character
				local PlayerGui = Player:WaitForChild("PlayerGui")
				local Backpack = Player:WaitForChild("Backpack")
				local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
				local RootPart = Character and Humanoid and Humanoid.RootPart or false
				local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
				if not Humanoid or not RootPart or not RightArm then
					return
				end
				Humanoid:UnequipTools()
				local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
				if not MainTool or not MainTool:FindFirstChild("Handle") then
					return
				end
				Humanoid.Name = "DAttach"
				local l = Character["DAttach"]:Clone()
				l.Parent = Character
				l.Name = "Humanoid"
				wait()
				Character["DAttach"]:Destroy()
				game.Workspace.CurrentCamera.CameraSubject = Character
				Character.Animate.Disabled = true
				wait()
				Character.Animate.Disabled = false
				Character.Humanoid:EquipTool(MainTool)
				wait()
				CF = Player.Character.PrimaryPart.CFrame
				if firetouchinterest then
					local flag = false
					task.defer(function()
						MainTool.Handle.AncestryChanged:wait()
						flag = true
					end)
					repeat
						firetouchinterest(MainTool.Handle, TRootPart, 0)
						firetouchinterest(MainTool.Handle, TRootPart, 1)
						wait()
					until flag
				else
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
				end
				 CF = Player.Character.HumanoidRootPart.CFrame
			 player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 end)
 
	 cmd.add({"kidnap"}, {"kidnap <player>", "Kidnaps a player"}, function(...)
 Username = (...)
	 Target = getPlr(Username)
		 local currentCFrame = Target.Character.Head.CFrame
	   local offset = Vector3.new(0, 0, -50)
	   local newPosition = currentCFrame.p + offset
	   local newCFrame = CFrame.new(newPosition, currentCFrame.lookVector)
		 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = newCFrame
		 wait(1)
	   local player = game.Players.LocalPlayer
	 local targetPlayer = Target

	 local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	 	 local teleportTween = game:GetService("TweenService"):Create(player.Character.HumanoidRootPart, tweenInfo, {
	   CFrame = CFrame.new()
	 })

	 	 function startTeleportTween()
	   if targetPlayer then
		 teleportTween:Cancel()
		 teleportTween = game:GetService("TweenService"):Create(player.Character.HumanoidRootPart, tweenInfo, {
		   CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
		 })
		 teleportTween:Play()
	   end
	 end
	 
		 startTeleportTween()
	  wait(2)
		  local TPlayer = Target
					TRootPart = TPlayer.Character.HumanoidRootPart
					local Character = Player.Character
					local PlayerGui = Player:WaitForChild("PlayerGui")
					local Backpack = Player:WaitForChild("Backpack")
					local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
					local RootPart = Character and Humanoid and Humanoid.RootPart or false
					local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
					if not Humanoid or not RootPart or not RightArm then
						return
					end
					Humanoid:UnequipTools()
					local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
					if not MainTool or not MainTool:FindFirstChild("Handle") then
						return
					end
					Humanoid.Name = "DAttach"
					local l = Character["DAttach"]:Clone()
					l.Parent = Character
					l.Name = "Humanoid"
					wait()
					Character["DAttach"]:Destroy()
					game.Workspace.CurrentCamera.CameraSubject = Character
					Character.Animate.Disabled = true
					wait()
					Character.Animate.Disabled = false
					Character.Humanoid:EquipTool(MainTool)
					wait()
					CF = Player.Character.PrimaryPart.CFrame
					if firetouchinterest then
						local flag = false
						task.defer(function()
							MainTool.Handle.AncestryChanged:wait()
							flag = true
						end)
						repeat
							firetouchinterest(MainTool.Handle, TRootPart, 0)
							firetouchinterest(MainTool.Handle, TRootPart, 1)
							wait()
						until flag
					else
						Player.Character.HumanoidRootPart.CFrame =
						TCharacter.HumanoidRootPart.CFrame
						wait()
						Player.Character.HumanoidRootPart.CFrame =
						TCharacter.HumanoidRootPart.CFrame
						wait()
					end
					wait(0.7)
	 local targetPosition = player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 1000)
	 
	 local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	 
	 local teleportTween = game:GetService("TweenService"):Create(player.Character.HumanoidRootPart, tweenInfo, {
	   CFrame = CFrame.new(targetPosition)
	 })
	 
		 teleportTween:Play()	
 end)
 
	 cmd.add({"quicksand"}, {"quicksand <player>", "Quicksands a player"}, function(...)
 wait();
 
 Notify({
 Description = "Kidnapping... next time take a van, or not";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
						   local OldPos = getRoot().CFrame
 wait()
		 tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(160, Enum.EasingStyle.Linear)
			  
		 tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(0, -1000, 0)})
		 tween:Play()
		 wait()
		 Username = (...)
 
		 Target = (...)
		 local TPlayer = getPlr(Target)
					TRootPart = TPlayer.Character.HumanoidRootPart
					local Character = Player.Character
					local PlayerGui = Player:WaitForChild("PlayerGui")
					local Backpack = Player:WaitForChild("Backpack")
					local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
					local RootPart = Character and Humanoid and Humanoid.RootPart or false
					local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
					if not Humanoid or not RootPart or not RightArm then
						return
					end
					Humanoid:UnequipTools()
					local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
					if not MainTool or not MainTool:FindFirstChild("Handle") then
						return
					end
					Humanoid.Name = "DAttach"
					local l = Character["DAttach"]:Clone()
					l.Parent = Character
					l.Name = "Humanoid"
					wait()
					Character["DAttach"]:Destroy()
					game.Workspace.CurrentCamera.CameraSubject = Character
					Character.Animate.Disabled = true
					wait()
					Character.Animate.Disabled = false
					Character.Humanoid:EquipTool(MainTool)
					wait()
					CF = Player.Character.PrimaryPart.CFrame
					if firetouchinterest then
						local flag = false
						task.defer(function()
							MainTool.Handle.AncestryChanged:wait()
							flag = true
						end)
						repeat
							firetouchinterest(MainTool.Handle, TRootPart, 0)
							firetouchinterest(MainTool.Handle, TRootPart, 1)
							wait()
						until flag
					else
						Player.Character.HumanoidRootPart.CFrame =
						TCharacter.HumanoidRootPart.CFrame
						wait()
						Player.Character.HumanoidRootPart.CFrame =
						TCharacter.HumanoidRootPart.CFrame
						wait()
					end
	 CF = Player.Character.HumanoidRootPart.CFrame
			 player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
	end)
 
 cmd.add({"hatsleash", "hl"}, {"hatsleash", "Makes you be able to carry your hats"}, function()
		-- [[ PROBABLY PATCHED ]] -- 
	 for _, v in pairs(game.Players.LocalPlayer.Character:getChildren()) do
		 if v.ClassName == "Accessory" then
		  for i, k in pairs(v:GetDescendants()) do
		   if k.ClassName == "Attachment" then
			s = Instance.new("RopeConstraint")
			k.Parent.CanCollide = true
			s.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
			s.Attachment1 = k
			s.Attachment0 = game.Players.LocalPlayer.Character.Head.FaceCenterAttachment
			s.Visible = true
			s.Length = 10
			v.Handle.AccessoryWeld:Destroy()
		   end
		  end
		 end
		end
 end)
 
 cmd.add({"toolleash", "tl"}, {"toolleash", "Makes you be able to carry your tools"}, function()
	-- [[ PROBABLY PATCHED ]] -- 
	 for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		 v.Parent = game.Players.LocalPlayer.Character
	 end
	 
	 for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		 if v.ClassName == "Tool" then
	 x = Instance.new("Attachment")
	 s = Instance.new("RopeConstraint")
	 v.Handle.CanCollide = true
	 x.Parent = v.Handle
	 s.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
	 s.Attachment1 = game.Players.LocalPlayer.Character["Right Arm"].RightGripAttachment
	 s.Attachment0 = v.Handle.Attachment
	 s.Length = 100
	 s.Visible = true
	 wait()
	 end
	 end
	 for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		 if v.Name == "RightGrip" then
			 v:Destroy()
		 end
	 end
	 
	 while wait() do
		 for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			 if v.ClassName == "Tool" then
				 v.Handle.Velocity = Vector3.new(math.random(-100, 100), 5, math.random(-100, 100))
			 end
		 end
	 end
 end)
 
 cmd.add({"control"}, {"control <player>", "Control a player"}, function(...)
 Target = (...)
 Control = true
 repeat wait()
	 local TPlayer = getPlr(Target)
				TRootPart = TPlayer.Character.HumanoidRootPart
				local Character = Player.Character
				local PlayerGui = Player:WaitForChild("PlayerGui")
				local Backpack = Player:WaitForChild("Backpack")
				local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
				local RootPart = Character and Humanoid and Humanoid.RootPart or false
				local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
				if not Humanoid or not RootPart or not RightArm then
					return
				end
				Humanoid:UnequipTools()
				local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
				if not MainTool or not MainTool:FindFirstChild("Handle") then
					return
				end
				Humanoid.Name = "DAttach"
				local l = Character["DAttach"]:Clone()
				l.Parent = Character
				l.Name = "Humanoid"
				wait()
				Character["DAttach"]:Destroy()
				game.Workspace.CurrentCamera.CameraSubject = Character
				Character.Animate.Disabled = true
				wait()
				Character.Animate.Disabled = false
				Character.Humanoid:EquipTool(MainTool)
				wait()
				CF = Player.Character.PrimaryPart.CFrame
				if firetouchinterest then
					local flag = false
					task.defer(function()
						MainTool.Handle.AncestryChanged:wait()
						flag = true
					end)
					repeat
						firetouchinterest(MainTool.Handle, TRootPart, 0)
						firetouchinterest(MainTool.Handle, TRootPart, 1)
						wait()
					until flag
				else
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
					Player.Character.HumanoidRootPart.CFrame =
					TCharacter.HumanoidRootPart.CFrame
					wait()
				end
				player.CharacterAdded:wait(1)
				wait(0.2)
 getRoot().CFrame= getPlr(Target).Character.Head.CFrame
 wait(0.05)
 until Control == false
 end)
 
 cmd.add({"uncontrol"}, {"uncontrol", "Uncontrol a player"}, function()
 Control = false
 end)
 
 cmd.add({"reset"}, {"reset", "Makes your health be 0"}, function()
	 game.Players.LocalPlayer.Character.Humanoid.Health = 0
 end)
 
 cmd.add({"admin"}, {"admin", "whitelist someone to allow them to use commands"}, function(...)
	 function ChatMessage(Message, Whisper)	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, Whisper or "ALl")
	 end
	 local Player = getPlr(...)
	 if Player ~= nil and not Admin[Player.UserId] then
		 Admin[Player.UserId] = {Player = Player}
		 ChatMessage("/w "..Player.Name.." [Nameless Admin] You've got admin. Prefix: ';'")
		 wait(0.2)
		 ChatMessage("/w "..Player.Name.." [Nameless Admin Commands] glue, unglue, fling, fling2, spinfling, unspinfling, fcd, fti, fpp, fireremotes, holdhat")
		 ChatMessage("/w "..Player.Name.." reset, commitoof, seizure, unseizure, toolorbit, lay, fall, toolspin, hatspin, sit, joke, kanye")
		 Notify({
			 Description = "" .. Player.Name .. " has now been whitelisted to use commands";
			 Title = "Nameless Admin";
			 Duration = 15;
			 
			 });
	 else
		 Notify({
			 Description = "No player found";
			 Title = "Nameless Admin";
			 Duration = 15;
			 
			 });
	 end
 end)
 
 cmd.add({"unadmin"}, {"unadmin <player>", "removes someone from being admin"}, function(...)
	 function ChatMessage(Message, Whisper)	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, Whisper or "All")
	 end
	 local Player = getPlr(...)
			 if Player ~= nil and Admin[Player.UserId] then
				 Admin[Player.UserId] = nil
				 ChatMessage("/w "..Player.Name.." You can no longer use commands")
					 Notify({
				 Description = "" .. Player.Name .. " is no longer an admin";
				 Title = "Nameless Admin";
				 Duration = 15;
				 
				 });
			 else
						 Notify({
				 Description = "Player not found";
				 Title = "Nameless Admin";
				 Duration = 15;
				 
				 });
			 end
	 end)
 
 cmd.add({"removedn", "nodn", "nodpn"}, {"removedn (nodn, nodpn)", "Removes all display names"}, function()

	-- [[ IM NOT SURE WHO MADE THIS ]] --

 wait();
 Notify({
 Description = "Display names successfully removed";
 Title = "Nameless Admin";
 Duration = 5;
 
 });

	 local Players = game:FindService("Players")
 require(game:GetService("Chat"):WaitForChild("ClientChatModules").ChatSettings).PlayerDisplayNamesEnabled = false
 local function rename(character,name)
	 repeat task.wait() until character:FindFirstChildWhichIsA("Humanoid")
	 character:FindFirstChildWhichIsA("Humanoid").DisplayName = name
 end
 for i,v in next, Players:GetPlayers() do
	 if v.Character then
		 v.DisplayName = v.Name
		 rename(v.Character,v.Name)
	 end
	 v.CharacterAdded:Connect(function(char)
		 rename(char,v.Name)
	 end)
 end
 Players.PlayerAdded:Connect(function(plr)
	 plr.DisplayName = plr.Name
	 plr.CharacterAdded:Connect(function(char)
		 rename(char,plr.Name)
	 end)
 end)
 end)
 
 cmd.add({"anticlientkick", "antickick"}, {"anticlientkick (antickick)", "Makes local scripts not able to kick you"}, function()
	if not hookmetamethod then 
		Notify({
			Description = "Your executor does not support anticlientkick";
			Title = "Nameless Admin";
			Duration = 5;
			
			});
			end
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
		if self == LocalPlayer and method:lower() == "kick" then
			return print("Expected ':' not '.' calling member function Kick")
		end
		return oldhmmi(self, method)
	end)
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
		if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
			return
			Notify({
				Description = "A kick was just attempted but was blocked";
				Title = "Nameless Admin";
				Duration = 5;
				
				});
		end
		return oldhmmnc(self, ...)
			end)
 Notify({
 Description = "Anti kick executed";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end)
 
 cmd.add({"jobid"}, {"jobid", "Copies your job id"}, function()
	 local jobId = 'Roblox.GameLauncher.joinGameInstance('..PlaceId..', "'..JobId..'")'
	 setclipboard(jobId)
	 wait();
 
 Notify({
 Description = "Copied your jobid (" .. jobId .. ")";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end)
 
 cmd.add({"joinjobid", "jjobid"}, {"joinjobid <jobid> (jjid)", "Joins the job id you put in"}, function(id)
 TeleportService:TeleportToPlaceInstance(game.PlaceId,id)
 end)
 
 cmd.add({"serverhop", "shop"}, {"serverhop (shop)", "Serverhop"}, function()
				 wait();
 
 Notify({
 Description = "Searching";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
				 local Number = 0
				 local SomeSRVS = {}
				 for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
					 if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
						 if v.playing > Number then
							 Number = v.playing
							 SomeSRVS[1] = v.id
						 end
					 end
				 end
				 if #SomeSRVS > 0 then
				 Notify({
 Description = "Searched, please wait while we are teleporting you";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
					 game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, SomeSRVS[1])
				 end
 end)
 
 cmd.add({"autorejoin", "autorj"}, {"autorejoin", "Rejoins the server if you get kicked / disconnected"}, function()
	Players = game.Players

	game.CoreGui:FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay").DescendantAdded:Connect(function(Err)
			if Err.Name == "ErrorTitle" then
				Err:GetPropertyChangedSignal("Text"):Connect(function()
					if Err.Text:sub(0, 12) == "Disconnected" then
						if #Players:GetPlayers() <= 1 then
							Players.LocalPlayer:Kick("\nRejoining...")
							wait()
							game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
						else
							game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
						end
					end
				end)
			end
		end)

		Notify({
			Description = "Auto Rejoin is now on!";
			Title = "Nameless Admin";
			Duration = 5;
			
			}); end)
 
 cmd.add({"functionspy"}, {"functionspy", "Check console"}, function()
	 local toLog = {
		 debug.getconstants;
		 getconstants;
		 debug.getconstant;
		 getconstant;
		 debug.setconstant;
		 setconstant;
		 debug.getupvalues;
		 debug.getupvalue;
		 getupvalues;
		 getupvalue;
		 debug.setupvalue;
		 setupvalue;
		 getsenv;
		 getreg;
		 getgc;
		 getconnections;
		 firesignal;
		 fireclickdetector;
		 fireproximityprompt;
		 firetouchinterest;
		 gethiddenproperty;
		 sethiddenproperty;
		 hookmetamethod;
		 setnamecallmethod;
		 getrawmetatable;
		 setrawmetatable;
		 setreadonly;
		 isreadonly;
		 debug.setmetatable;
	 }
	 
	 local FunctionSpy = Instance.new("ScreenGui")
	 local Main = Instance.new("Frame")
	 local LeftPanel = Instance.new("ScrollingFrame")
	 local UIListLayout = Instance.new("UIListLayout")
	 local example = Instance.new("TextButton")
	 local name = Instance.new("TextLabel")
	 local UIPadding = Instance.new("UIPadding")
	 local FakeTitle = Instance.new("TextButton")
	 local Title = Instance.new("TextLabel")
	 local clear = Instance.new("ImageButton")
	 local RightPanel = Instance.new("ScrollingFrame")
	 local output = Instance.new("TextLabel")
	 local clear_2 = Instance.new("TextButton")
	 local copy = Instance.new("TextButton")
	
	 FunctionSpy.Name = "FunctionSpy"
	 FunctionSpy.Parent = game.CoreGui
	 FunctionSpy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	 
	 Main.Name = "Main"
	 Main.Parent = FunctionSpy
	 Main.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	 Main.BorderSizePixel = 0
	 Main.Position = UDim2.new(0, 10, 0, 36)
	 Main.Size = UDim2.new(0, 536, 0, 328)
	 
	 LeftPanel.Name = "LeftPanel"
	 LeftPanel.Parent = Main
	 LeftPanel.Active = true
	 LeftPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	 LeftPanel.BorderSizePixel = 0
	 LeftPanel.Size = UDim2.new(0.349999994, 0, 1, 0)
	 LeftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
	 LeftPanel.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	 LeftPanel.ScrollBarThickness = 3
	 
	 UIListLayout.Parent = LeftPanel
	 UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	 UIListLayout.Padding = UDim.new(0, 7)
	 
	 example.Name = "example"
	 example.Parent = LeftPanel
	 example.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	 example.BorderSizePixel = 0
	 example.Position = UDim2.new(4.39481269e-08, 0, 0, 0)
	 example.Size = UDim2.new(0, 163, 0, 19)
	 example.Visible = false
	 example.Font = Enum.Font.SourceSans
	 example.Text = ""
	 example.TextColor3 = Color3.fromRGB(0, 0, 0)
	 example.TextSize = 14.000
	 example.TextXAlignment = Enum.TextXAlignment.Left
	 
	 name.Name = "name"
	 name.Parent = example
	 name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	 name.BackgroundTransparency = 1.000
	 name.BorderSizePixel = 0
	 name.Position = UDim2.new(0, 10, 0, 0)
	 name.Size = UDim2.new(1, -10, 1, 0)
	 name.Font = Enum.Font.SourceSans
	 name.TextColor3 = Color3.fromRGB(255, 255, 255)
	 name.TextSize = 14.000
	 name.TextXAlignment = Enum.TextXAlignment.Left
	 
	 UIPadding.Parent = LeftPanel
	 UIPadding.PaddingBottom = UDim.new(0, 7)
	 UIPadding.PaddingLeft = UDim.new(0, 7)
	 UIPadding.PaddingRight = UDim.new(0, 7)
	 UIPadding.PaddingTop = UDim.new(0, 7)
	 
	 FakeTitle.Name = "FakeTitle"
	 FakeTitle.Parent = Main
	 FakeTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	 FakeTitle.BorderSizePixel = 0
	 FakeTitle.Position = UDim2.new(0, 225, 0, -26)
	 FakeTitle.Size = UDim2.new(0.166044772, 0, 0, 26)
	 FakeTitle.Font = Enum.Font.GothamMedium
	 FakeTitle.Text = "FunctionSpy"
	 FakeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	 FakeTitle.TextSize = 14.000
	 
	 Title.Name = "Title"
	 Title.Parent = Main
	 Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	 Title.BorderSizePixel = 0
	 Title.Position = UDim2.new(0, 0, 0, -26)
	 Title.Size = UDim2.new(1, 0, 0, 26)
	 Title.Font = Enum.Font.GothamMedium
	 Title.Text = "FunctionSpy"
	 Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	 Title.TextSize = 14.000
	 Title.TextWrapped = true
	 
	 clear.Name = "clear"
	 clear.Parent = Title
	 clear.BackgroundTransparency = 1.000
	 clear.Position = UDim2.new(1, -28, 0, 2)
	 clear.Size = UDim2.new(0, 24, 0, 24)
	 clear.ZIndex = 2
	 clear.Image = "rbxassetid://3926305904"
	 clear.ImageRectOffset = Vector2.new(924, 724)
	 clear.ImageRectSize = Vector2.new(36, 36)
	 
	 RightPanel.Name = "RightPanel"
	 RightPanel.Parent = Main
	 RightPanel.Active = true
	 RightPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	 RightPanel.BorderSizePixel = 0
	 RightPanel.Position = UDim2.new(0.349999994, 0, 0, 0)
	 RightPanel.Size = UDim2.new(0.649999976, 0, 1, 0)
	 RightPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
	 RightPanel.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	 RightPanel.ScrollBarThickness = 3
	 
	 output.Name = "output"
	 output.Parent = RightPanel
	 output.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	 output.BackgroundTransparency = 1.000
	 output.BorderColor3 = Color3.fromRGB(27, 42, 53)
	 output.BorderSizePixel = 0
	 output.Position = UDim2.new(0, 10, 0, 10)
	 output.Size = UDim2.new(1, -10, 0.75, -10)
	 output.Font = Enum.Font.GothamMedium
	 output.Text = ""
	 output.TextColor3 = Color3.fromRGB(255, 255, 255)
	 output.TextSize = 14.000
	 output.TextXAlignment = Enum.TextXAlignment.Left
	 output.TextYAlignment = Enum.TextYAlignment.Top
	 
	 clear_2.Name = "clear"
	 clear_2.Parent = RightPanel
	 clear_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	 clear_2.BorderSizePixel = 0
	 clear_2.Position = UDim2.new(0.0631457642, 0, 0.826219559, 0)
	 clear_2.Size = UDim2.new(0, 140, 0, 33)
	 clear_2.Font = Enum.Font.SourceSans
	 clear_2.Text = "Clear logs"
	 clear_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	 clear_2.TextSize = 14.000
	 
	 copy.Name = "copy"
	 copy.Parent = RightPanel
	 copy.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	 copy.BorderSizePixel = 0
	 copy.Position = UDim2.new(0.545350134, 0, 0.826219559, 0)
	 copy.Size = UDim2.new(0, 140, 0, 33)
	 copy.Font = Enum.Font.SourceSans
	 copy.Text = "Copy info"
	 copy.TextColor3 = Color3.fromRGB(255, 255, 255)
	 copy.TextSize = 14.000
	 
	 -- Scripts:
	 
	 local function AKIHDI_fake_script() -- Main.Main 
		 local script = Instance.new('LocalScript', Main)
	 
		 _G.functionspy = {
			 instance = script.Parent.Parent;
			 logging = true;
			 connections = {};
		 }
		 
		 _G.functionspy.shutdown = function()
			 for i,v in pairs(_G.functionspy.connections) do
				 v:Disconnect()
			 end
			 _G.functionspy.connections = {}
			 _G.functionspy = nil
			 script.Parent.Parent:Destroy()
		 end
		 
		 local connections = {}
		 
		 local currentInfo = nil
		 
		 function log(name, text)
			 local btn = script.Parent.LeftPanel.example:Clone()
			 btn.Parent = script.Parent.LeftPanel
			 btn.Name = name
			 btn.name.Text = name
			 btn.Visible = true
			 table.insert(connections, btn.MouseButton1Click:Connect(function()
				 script.Parent.RightPanel.output.Text = text
				 currentInfo = text
			 end))
		 end
		 
		 script.Parent.RightPanel.copy.MouseButton1Click:Connect(function()
			 if currentInfo ~= nil then
				 setclipboard(currentInfo)
			 end
		 end)
		 
		 script.Parent.RightPanel.clear.MouseButton1Click:Connect(function()
			 for i,v in pairs(connections) do
				 v:Disconnect()
			 end
			 for i,v in pairs(script.Parent.LeftPanel:GetDescendants()) do
				 if v:IsA("TextButton") and v.Visible == true then
					 v:Destroy()
				 end
			 end
			 script.Parent.RightPanel.output.Text = ""
			 currentInfo = nil
		 end)
		 
		 local hooked = {}
		 local Seralize = [[
			type = typeof or type
			local str_types = {
				['boolean'] = true,
				['table'] = true,
				['userdata'] = true,
				['table'] = true,
				['function'] = true,
				['number'] = true,
				['nil'] = true
			}
			
			local rawequal = rawequal or function(a, b)
				return a == b
			end
			
			local function count_table(t)
				local c = 0
				for i, v in next, t do
					c = c + 1
				end
			
				return c
			end
			
			local function string_ret(o, typ)
				local ret, mt, old_func
				if not (typ == 'table' or typ == 'userdata') then
					return tostring(o)
				end
				mt = (getrawmetatable or getmetatable)(o)
				if not mt then 
					return tostring(o)
				end
			
				old_func = rawget(mt, '__tostring')
				rawset(mt, '__tostring', nil)
				ret = tostring(o)
				rawset(mt, '__tostring', old_func)
				return ret
			end
			
			local function format_value(v)
				local typ = type(v)
			
				if str_types[typ] then
					return string_ret(v, typ)
				elseif typ == 'string' then
					return '"'..v..'"'
				elseif typ == 'Instance' then
					return v:GetFullName()
				else
					return typ..'.new(' .. tostring(v) .. ')'
				end
			end
			
			local function serialize_table(t, p, c, s)
				local str = ""
				local n = count_table(t)
				local ti = 1
				local e = n > 0
			
				c = c or {}
				p = p or 1
				s = s or string.rep
			
				local function localized_format(v, is_table)
					return is_table and (c[v][2] >= p) and serialize_table(v, p + 1, c, s) or format_value(v)
				end
			
				c[t] = {t, 0}
			
				for i, v in next, t do
					local typ_i, typ_v = type(i) == 'table', type(v) == 'table'
					c[i], c[v] = (not c[i] and typ_i) and {i, p} or c[i], (not c[v] and typ_v) and {v, p} or c[v]
					str = str .. s('  ', p) .. '[' .. localized_format(i, typ_i) .. '] = '  .. localized_format(v, typ_v) .. (ti < n and ',' or '') .. '
			'
					ti = ti + 1
				end
			
				return ('{' .. (e and '
			' or '')) .. str .. (e and s('  ', p - 1) or '') .. '}'
			end
			
			return serialize_table
		]]
		 for i,v in next, toLog do
			 if type(v) == "string" then
				 local suc,err = pcall(function()
					 local func = loadstring("return "..v)()
					 hooked[i] = hookfunction(func, function(...)
						 local args = {...}
						 if _G.functionspy then
							 pcall(function() 
								 out = ""
								 out = out..(v..", Args -> {")..("\n"):format()
								 for l,k in pairs(args) do
									 if type(k) == "function" then
										 out = out..("    ["..tostring(l).."] "..tostring(k)..", Type -> "..type(k)..", Name -> "..getinfo(k).name)..("\n"):format()
									 elseif type(k) == "table" then
										 out = out..("    ["..tostring(l).."] "..tostring(k)..", Type -> "..type(k)..", Data -> "..Seralize(k))..("\n"):format()
									 elseif type(k) == "boolean" then
										 out = out..("    ["..tostring(l).."] Value -> "..tostring(k).." -> "..type(k))..("\n"):format()
									 elseif type(k) == "nil" then
										 out = out..("    ["..tostring(l).."] null")..("\n"):format()
									 elseif type(k) == "number" then
										 out = out..("    ["..tostring(l).."] Value -> "..tostring(k)..", Type -> "..type(k))..("\n"):format()
									 else
										 out = out..("    ["..tostring(l).."] Value -> "..tostring(k)..", Type -> "..type(k))..("\n"):format()
									 end
								 end
								 out = out..("}, Result -> "..tostring(nil))..("\n"):format()
								 if _G.functionspy.logging == true then
									 log(v,out)
								 end
							 end)
						 end
						 return hooked[i](...)
					 end)
				 end)
				 if not suc then
					 warn("Something went wrong while hooking "..v..". Error: "..err)
				 end
			 elseif type(v) == "function" then
				 local suc,err = pcall(function()
					 hooked[i] = hookfunction(v, function(...)
						 local args = {...}
						 if _G.functionspy then
							 pcall(function() 
								 out = ""
								 out = out..(getinfo(v).name..", Args -> {")..("\n"):format()
								 for l,k in pairs(args) do
									 if type(k) == "function" then
										 out = out..("    ["..tostring(l).."] "..tostring(k)..", Type -> "..type(k)..", Name -> "..getinfo(k).name)..("\n"):format()
									 elseif type(k) == "table" then
										 out = out..("    ["..tostring(l).."] "..tostring(k)..", Type -> "..type(k)..", Data -> "..Seralize(k))..("\n"):format()
									 elseif type(k) == "boolean" then
										 out = out..("    ["..tostring(l).."] Value -> "..tostring(k).." -> "..type(k))..("\n"):format()
									 elseif type(k) == "nil" then
										 out = out..("    ["..tostring(l).."] null")..("\n"):format()
									 elseif type(k) == "number" then
										 out = out..("    ["..tostring(l).."] Value -> "..tostring(k)..", Type -> "..type(k))..("\n"):format()
									 else
										 out = out..("    ["..tostring(l).."] Value -> "..tostring(k)..", Type -> "..type(k))..("\n"):format()
									 end
								 end
								 out = out..("}, Result -> "..tostring(nil))..("\n"):format()
								 if _G.functionspy.logging == true then
									 log(getinfo(v).name,out)
								 end
							 end)
						 end
						 return hooked[i](...)
					 end)
				 end)
				 if not suc then
					 warn("Something went wrong while hooking "..getinfo(v).name..". Error: "..err)
				 end
			 end
		 end
		 
	 end
	 coroutine.wrap(AKIHDI_fake_script)()
	 local function KVVJTK_fake_script() -- FakeTitle.DragScript 
		 local script = Instance.new('LocalScript', FakeTitle)
		 
		 local UIS = game:GetService('UserInputService')
		 local frame = script.Parent.Parent
		 local dragToggle = nil
		 local dragSpeed = 0.25
		 local dragStart = nil
		 local startPos = nil
		 
		 local function updateInput(input)
			 local delta = input.Position - dragStart
			 local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			 game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
		 end
		 
		 table.insert(_G.functionspy.connections, frame.Title.InputBegan:Connect(function(input)
			 if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
				 dragToggle = true
				 dragStart = input.Position
				 startPos = frame.Position
				 input.Changed:Connect(function()
					 if input.UserInputState == Enum.UserInputState.End then
						 dragToggle = false
					 end
				 end)
			 end
		 end))
		 
		 table.insert(_G.functionspy.connections, UIS.InputChanged:Connect(function(input)
			 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				 if dragToggle then
					 updateInput(input)
				 end
			 end
		 end))
		 
	 end
	 coroutine.wrap(KVVJTK_fake_script)()
	 local function BIPVKVC_fake_script() -- FakeTitle.LocalScript 
		 local script = Instance.new('LocalScript', FakeTitle)
	 
		 table.insert(_G.functionspy.connections, script.Parent.MouseEnter:Connect(function()
			 if _G.functionspy.logging == true then
				 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(0,1,0)}):Play()
			 elseif _G.functionspy.logging == false then
				 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,0,0)}):Play()
			 end
		 end))
		 
		 table.insert(_G.functionspy.connections, script.Parent.MouseMoved:Connect(function()
			 if _G.functionspy.logging == true then
				 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(0,1,0)}):Play()
			 elseif _G.functionspy.logging == false then
				 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,0,0)}):Play()
			 end
		 end))
		 
		 table.insert(_G.functionspy.connections, script.Parent.MouseButton1Click:Connect(function()
			 _G.functionspy.logging = not _G.functionspy.logging
			 if _G.functionspy.logging == true then
				 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(0,1,0)}):Play()
			 elseif _G.functionspy.logging == false then
				 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,0,0)}):Play()
			 end
		 end))
		 
		 table.insert(_G.functionspy.connections, script.Parent.MouseLeave:Connect(function()
			 game:GetService("TweenService"):Create(script.Parent.Parent.Title, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1)}):Play()
		 end))
	 end
	 coroutine.wrap(BIPVKVC_fake_script)()
	 local function PRML_fake_script() -- clear.LocalScript 
		 local script = Instance.new('LocalScript', clear)
	 
		 script.Parent.MouseButton1Click:Connect(function()
			 _G.functionspy.shutdown()
		 end)
	 end
	 coroutine.wrap(PRML_fake_script)()	
 end)
 
 on = false
 cmd.add({"mobilefly", "mfly"}, {"mobilefly [speed] (mfly)", "Fly that works on mobile"}, function(...)
 on = true
 -- kind of bad mobile fly but it works after the reject character deletions enabling
 speed = (...)
 
	 if speed == nil then
		 speed = 69
	 else
	 end
 
	 if table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform()) then 
		 wait();
		 
		 Notify({
		 Description = "Nameless Admin has detected you using mobile you now have a mfly button click it to enable / disable mobile flying (For easier use)";
		 Title = "Nameless Admin";
		 Duration = 5;
		 });
		 
	 -- creates a button that u can toggle if you're flying or not
	 local ScreenGui = Instance.new("ScreenGui")
	 local TextButton = Instance.new("TextButton")
	 local UICorner = Instance.new("UICorner")
	 local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	 
	 ScreenGui.Parent = game.CoreGui
	 ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	 ScreenGui.ResetOnSpawn = false
	 
	 TextButton.Parent = ScreenGui
	 TextButton.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
	 TextButton.BackgroundTransparency = 0.140
	 TextButton.Position = UDim2.new(0.933, 0,0.621, 0)
	 TextButton.Size = UDim2.new(0.043, 0,0.083, 0)
	 TextButton.Font = Enum.Font.SourceSansBold
	 TextButton.Text = "Fly"
	 TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	 TextButton.TextSize = 15.000
	 TextButton.TextWrapped = true
	 TextButton.Active = true
	 TextButton.Draggable = true
	 TextButton.TextScaled = true
	 
	 UICorner.Parent = TextButton
	 
	 UIAspectRatioConstraint.Parent = TextButton
	 UIAspectRatioConstraint.AspectRatio = 1.060
 
	 local function FEPVI_fake_script() -- TextButton.LocalScript 
		 local script = Instance.new('LocalScript', TextButton)
			 script.Parent.MouseButton1Click:Connect(function()
	   if on == false then
 on = true
						 script.Parent.Text = "Unfly"
 mobilefly(speed)
		 elseif on == true then
 on = false
 unmobilefly()
 script.Parent.Text = "Fly"
			 end
		 end)
	 end
	 coroutine.wrap(FEPVI_fake_script)()
	 else
		 mobilefly(speed)
	 end
 end)
 
 cmd.add({"unmobilefly", "unmfly"}, {"unmobilefly (unmfly)", "CFrame fly disabler"}, function()
 unmobilefly()
 end)
 
 local flyPart
 cmd.add({"fly"}, {"fly [speed]", "Enable flight"}, function(...)
 FLYING = false
	 cmdlp.Character.Humanoid.PlatformStand = false
	 wait()
 
		 
		 
		 wait();
		 
		 Notify({
		 Description = "Fly enabled";
		 Title = "Nameless Admin";
		 Duration = 5;
	 
 });
	 sFLY(true)
	 speedofthevfly = (...)
	 if (...) == nil then
		 speedofthevfly = 2
		 end
 end)
 
 cmd.add({"unfly"}, {"unfly", "Disable flight"}, function()
 
		 
		 
		 wait();
		 
		 Notify({
		 Description = "Not flying anymore";
		 Title = "Nameless Admin";
		 Duration = 5;
	 
 });
 FLYING = false
	 cmdlp.Character.Humanoid.PlatformStand = false
 end)
 
 cmd.add({"noclip", "nclip", "nc"}, {"noclip", "Disable your player's collision"}, function()
	 if connections["noclip"] then lib.disconnect("noclip") return end
	 lib.connect("noclip", RunService.Stepped:Connect(function()
		 if not character then return end
		 for i, v in pairs(character:GetDescendants()) do
			 if v:IsA("BasePart") then
				 v.CanCollide = false
			 end
		 end
	 end))
 end)
 
 cmd.add({"clip", "c"}, {"clip", "Enable your player's collision"}, function()
	 lib.disconnect("noclip")
 end)
 
 cmd.add({"r15"}, {"r15", "Prompts a message asking to make you R15"}, function()
 local avs = game:GetService("AvatarEditorService")
 avs:PromptSaveAvatar(game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription,Enum.HumanoidRigType.R15)
 Notify({
 Description = "Press allow";
 Duration = 3;
 
 });
 local result = avs.PromptSaveAvatarCompleted:Wait()
 if result == Enum.AvatarPromptResult.Success
 then
 Notify({
 Description = "You are now R15";
 Title = "Nameless Admin";
 Duration = 3;
 
 });
 respawn()
 else
 Notify({
 Description = "An error has occured";
 Title = "Nameless Admin";
 Duration = 3;
 
 });
 end
 end)
 
 cmd.add({"r6"}, {"r6", "Prompts a message asking to make you R6"}, function()
	 local avs = game:GetService("AvatarEditorService")
 avs:PromptSaveAvatar(game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription,Enum.HumanoidRigType.R6)
 Notify({
 Description = "Press allow";
 Duration = 3;
 
 });
 local result = avs.PromptSaveAvatarCompleted:Wait()
 if result == Enum.AvatarPromptResult.Success
 then
 Notify({
 Description = "You are now R6";
 Title = "Nameless Admin";
 Duration = 3;
 
 });
 respawn()
 else
 Notify({
 Description = "An error has occured";
 Title = "Nameless Admin";
 Duration = 3;
 
 });
 end
 end)
 
 cmd.add({"freecam", "fc", "fcam"}, {"freecam [speed] (fc, fcam)", "Enable free camera"}, function(speed)
	 if not speed then speed = 5 end
	 if connections["freecam"] then lib.disconnect("freecam") camera.CameraSubject = character 	wrap(function() character.PrimaryPart.Anchored = false end) end
	 local dir = {w = false, a = false, s = false, d = false}
	 local cf = Instance.new("CFrameValue")
	 local camPart = Instance.new("Part")
	 camPart.Transparency = 1
	 camPart.Anchored = true
	 camPart.CFrame = camera.CFrame
	 wrap(function()
		 character.PrimaryPart.Anchored = true
	 end)
	 
	 lib.connect("freecam", RunService.RenderStepped:Connect(function()
		 local primaryPart = camPart
		 camera.CameraSubject = primaryPart
		 
		 local x, y, z = 0, 0, 0
		 if dir.w then z = -1 * speed end
		 if dir.a then x = -1 * speed end
		 if dir.s then z = 1 * speed end
		 if dir.d then x = 1 * speed end
		 if dir.q then y = 1 * speed end
		 if dir.e then y = -1 * speed end
		 
		 primaryPart.CFrame = CFrame.new(
			 primaryPart.CFrame.p,
			 (camera.CFrame * CFrame.new(0, 0, -100)).p
		 )
		 
		 local moveDir = CFrame.new(x,y,z)
		 cf.Value = cf.Value:lerp(moveDir, 0.2)
		 primaryPart.CFrame = primaryPart.CFrame:lerp(primaryPart.CFrame * cf.Value, 0.2)
	 end))
	 lib.connect("freecam", UserInputService.InputBegan:Connect(function(input, event)
		 if event then return end
		 local code, codes = input.KeyCode, Enum.KeyCode
		 if code == codes.W then
			 dir.w = true
		 elseif code == codes.A then
			 dir.a = true
		 elseif code == codes.S then
			 dir.s = true
		 elseif code == codes.D then
			 dir.d = true
		 elseif code == codes.Q then
			 dir.q = true
		 elseif code == codes.E then
			 dir.e = true
		 elseif code == codes.Space then
			 dir.q = true
		 end
	 end))
	 lib.connect("freecam", UserInputService.InputEnded:Connect(function(input, event)
		 if event then return end
		 local code, codes = input.KeyCode, Enum.KeyCode
		 if code == codes.W then
			 dir.w = false
		 elseif code == codes.A then
			 dir.a = false
		 elseif code == codes.S then
			 dir.s = false
		 elseif code == codes.D then
			 dir.d = false
		 elseif code == codes.Q then
			 dir.q = false
		 elseif code == codes.E then
			 dir.e = false
		 elseif code == codes.Space then
			 dir.q = false
		 end
	 end))
 end)
 
 cmd.add({"unfreecam", "unfc", "unfcam"}, {"unfreecam (unfc, unfcam)", "Disable free camera"}, function()
	 lib.disconnect("freecam")
	 camera.CameraSubject = character
	 wrap(function()
		 character.PrimaryPart.Anchored = false
	 end)
 end)
 
 cmd.add({"drophats"}, {"drophats", "Drop all of your hats"}, function()
	 for _, hat in pairs(character:GetChildren()) do
		 if hat:IsA("Accoutrement") then
			 hat.Parent = workspace
		 end
	 end
 end)
 
 cmd.add({"hatspin"}, {"hatspin <height>", "Make your hats spin"}, function(h)
	 local head = character:FindFirstChild("Head")
	 if not head then return end
	 for _, hat in pairs(character:GetChildren()) do
		 if hat:IsA("Accoutrement") and hat:FindFirstChild("Handle") then
			 local handle = hat.Handle
			 handle:BreakJoints()
			 
			 local align = Instance.new("AlignPosition")
			 local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			 align.Attachment0, align.Attachment1 = a0, a1
			 align.RigidityEnabled = true
			 a1.Position = Vector3.new(0, tonumber(h) or 0.5, 0)
			 lock(align, handle); lock(a0, handle); lock(a1, head);
			 
			 local angular = Instance.new("BodyAngularVelocity")
			 angular.AngularVelocity = Vector3.new(0, math.random(100, 160)/16, 0)
			 angular.MaxTorque = Vector3.new(0, 400000, 0)
			 lock(angular, handle);
		 end
	 end
 end)
 
 cmd.add({"limbbounce"}, {"limbbounce [height] [distance]", "Make your limbs bounce around your head"}, function(h, d)
	 local head = character:FindFirstChild("Head")
	 if not head then return end
	 local i = 2
	 for _, part in pairs(character:GetDescendants()) do
		 local name = part.Name:lower()
		 if part:IsA("BasePart") and not part.Parent:IsA("Accoutrement") and not name:find("torso") and not name:find("head") and not name:find("root") then
			 i = i + math.random(15,50)/100
			 part:BreakJoints()
			 local n = tonumber(d) or i
			 
			 local align = Instance.new("AlignPosition")
			 local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			 align.Attachment0, align.Attachment1 = a0, a1
			 align.RigidityEnabled = true
			 lock(align, part); lock(a0, part); lock(a1, head);
			 
			 wrap(function()
				 local rotX = 0
				 local speed = math.random(350, 750)/10000
				 while part and part.Parent do
					 rotX = rotX + speed
					 a1.Position = Vector3.new(0, (tonumber(h) or 0) + math.sin(rotX) * n, 0)
					 RunService.RenderStepped:Wait(0)
				 end
			 end)
		 end
	 end
 end)
 
 cmd.add({"limborbit"}, {"limborbit [height] [distance]", "Make your limbs orbit around your head"}, function(h, d)
	 local head = character:FindFirstChild("Head")
	 if not head then return end
	 local i = 2
	 for _, part in pairs(character:GetDescendants()) do
		 local name = part.Name:lower()
		 if part:IsA("BasePart") and not part.Parent:IsA("Accoutrement") and not name:find("torso") and not name:find("head") and not name:find("root") then
			 i = i + math.random(15,50)/100
			 part:BreakJoints()
			 local n = tonumber(d) or i
			 
			 local align = Instance.new("AlignPosition")
			 local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			 align.Attachment0, align.Attachment1 = a0, a1
			 align.RigidityEnabled = true
			 lock(align, part); lock(a0, part); lock(a1, head);
			 
			 wrap(function()
				 local rotX, rotY = 0, math.pi/2
				 local speed = math.random(35, 75)/1000
				 while part and part.Parent do
					 rotX, rotY = rotX + speed, rotY + speed
					 a1.Position = Vector3.new(math.sin(rotX) * (n), tonumber(h) or 0, math.sin(rotY) * (n))
					 RunService.RenderStepped:Wait(0)
				 end
			 end)
		 end
	 end
 end)
 
 local function getAllTools()
	 local tools = {}
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 if backpack then
		 for i, v in pairs(backpack:GetChildren()) do
			 if v:IsA("Tool") then
				 table.insert(tools, v)
			 end
		 end
	 end
	 for i, v in pairs(character:GetChildren()) do
		 if v:IsA("Tool") then
			 table.insert(tools, v)
		 end
	 end
	 return tools
 end
 
 cmd.add({"fakelag", "flag"}, {"fakelag (flag)", "fake lag"}, function()
 FakeLag = true
 
 repeat wait()
	 game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
	 wait(0.05)
	  game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
	  wait(0.05)
 until FakeLag == false
 end)
 
 cmd.add({"unfakelag", "unflag"}, {"unfakelag (unflag)", "stops the fake lag command"}, function()
 FakeLag = false
 end)
 
 cmd.add({"circlemath", "cm"}, {"circlemath <mode> <size>", "Gay circle math\nModes: abc..."}, function(mode, size)
	 local mode = mode or "a"
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 lib.disconnect("cm")
	 if backpack and character.Parent then
		 local tools = getAllTools()
		 for i, tool in pairs(tools) do
			 local cpos, g = (math.pi*2)*(i/#tools), CFrame.new()
			 local tcon = {}
			 tool.Parent = backpack
			 
			 if mode == "a" then
				 size = tonumber(size) or 2
				 g = (
					 CFrame.new(0, 0, size)*
					 CFrame.Angles(rad(90), 0, cpos)
				 )
			 elseif mode == "b" then
				 size = tonumber(size) or 2
				 g = (
					 CFrame.new(i - #tools/2, 0, 0)*
					 CFrame.Angles(rad(90), 0, 0)
				 )
			 elseif mode == "c" then
				 size = tonumber(size) or 2
				 g = (
					 CFrame.new(cpos/3, 0, 0)*
					 CFrame.Angles(rad(90), 0, cpos*2)
				 )
			 elseif mode == "d" then
				 size = tonumber(size) or 2
				 g = (
					 CFrame.new(clamp(tan(cpos), -3, 3), 0, 0)*
					 CFrame.Angles(rad(90), 0, cpos)
				 )
			 elseif mode == "e" then
				 size = tonumber(size) or 2
				 g = (
					 CFrame.new(0, 0, clamp(tan(cpos), -5, 5))*
					 CFrame.Angles(rad(90), 0, cpos)
				 )
			 end
			 tool.Grip = g
			 tool.Parent = character
			 
			 tcon[#tcon] = lib.connect("cm", mouse.Button1Down:Connect(function()
				 tool:Activate()
			 end))
			 tcon[#tcon] = lib.connect("cm", tool.Changed:Connect(function(p)
				 if p == "Grip" and tool.Grip ~= g then
					 tool.Grip = g
				 end
			 end))
			 
			 lib.connect("cm", tool.AncestryChanged:Connect(function()
				 for i = 1, #tcon do
					 tcon[i]:Disconnect()
				 end
			 end))
		 end
	 end
 end)
 
 local r = math.rad
 local center = CFrame.new(1.5, 0.5, -1.5)
 
 cmd.add({"toolanimate"}, {"toolanimate <mode> <int>", "Make your tools epic\nModes: ufo/ring/shutter/saturn/portal/wtf/ball/tor"}, function(mode, int)
	 lib.disconnect("tooldance")
	 local int = tonumber(int) or 5
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 local primary = character:FindFirstChild("HumanoidRootPart")
	 if backpack and primary then
		 local tools = getAllTools()
		 for i, tool in pairs(tools) do
			 if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				 local circ = (i/#tools)*(math.pi*2)
				 
				 local function editGrip(tool, cframe, offset)
					 local origin = CFrame.new(cframe.p):inverse()
					 local x, y, z = cframe:toEulerAnglesXYZ()
					 local new = CFrame.Angles(x, y, z)
					 local grip = (origin * new):inverse()
					 tool.Parent = backpack
					 tool.Grip = offset * grip
					 tool.Parent = character
					 
					 for i, v in pairs(tool:GetDescendants()) do
						 if v:IsA("Sound") then
							 v:Stop()
						 end
					 end
				 end
				 tool.Handle.Massless = true
				 
				 if mode == "ufo" then
					 local s = {}
					 local x, y = i, i + math.pi / 2
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.1, y + 0.1
						 
						 local cframe =
							 center *
							 CFrame.new() *
							 CFrame.Angles(r(s.y*10), circ + r(s.y*8), r(s.x*10))
						 local offset =
							 CFrame.new(int, 0, 0) *
							 CFrame.Angles(0, 0, 0)
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "ring" then
					 local s = {}
					 local x, y = i, i + math.pi / 2
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.04, y + 0.04
						 
						 local cframe =
							 center *
							 CFrame.new(0, 3, 0) *
							 CFrame.Angles(0, circ, x)
						 local offset =
							 CFrame.new(0, 0, int) *
							 CFrame.Angles(0, 0, 0)
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "shutter" then
					 local s = {}
					 local x, y = 0, math.pi / 2
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.1, y + 0.1
						 
						 local cframe =
							 center *
							 CFrame.new(0, 0, 0) *
							 CFrame.Angles(0, 0, circ + 0)
						 local offset =
							 CFrame.new(s.y*6, 0, int) *
							 CFrame.Angles(r(-90), 0, 0)
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "saturn" then
					 local s = {}
					 local x, y = 0, math.pi / 2
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.1, y + 0.1
						 local cframe =
							 center *
							 CFrame.new(0, 0, 0) *
							 CFrame.Angles(0, circ, 0)
						 local offset =
							 CFrame.new(s.y*6, 0, int) *
							 CFrame.Angles(0, 0, r(0))
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "portal" then
					 local s = {}
					 local x, y = 0, math.pi / 2
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.1, y + 0.1
						 
						 local cframe =
							 center *
							 CFrame.new(0, 0, 0) *
							 CFrame.Angles(0, 0, circ + r(x*45))
						 local offset =
							 CFrame.new(3, 0, int) *
							 CFrame.Angles(r(-90), 0, 0)
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "ball" then
					 local s = {}
					 local n = math.random()*#tools
					 local x, y = n, n+math.pi / 2
					 local random = math.random()
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.1, y + 0.1
						 local cframe =
							 center *
							 CFrame.new(0, 0, 0) *
							 CFrame.Angles(r(y*25), circ, r(y*25))
						 local offset =
							 CFrame.new(0, int + random*2, 0) *
							 CFrame.Angles(r(x*15), 0, 0)
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "wtf" then
					 local s = {}
					 local x, y = math.random()^3, math.random()^3+math.pi / 2
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + 0.1 + math.random()/10, y + 0.1 + math.random()/10
						 local cframe =
							 center *
							 CFrame.new(0, 0, 0) *
							 CFrame.Angles(r(y*100)+math.random(), circ, r(y*100)+math.random())
						 local offset =
							 CFrame.new(0, int + math.random()*4, 0) *
							 CFrame.Angles(r(x*100), 0, 0)
						 editGrip(tool, cframe, offset)
					 end))
				 elseif mode == "tor" then
					 local s = {}
					 local x, y = i*1, i*1+math.pi / 2
					 local random = math.random()
					 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
						 s.x = math.sin(x)
						 s.y = math.sin(y)
						 x, y = x + (int/75), y+0.1
						 local cframe =
							 center *
							 CFrame.new(1.5, 2, 0) *
							 CFrame.Angles(r(-90-25), 0, 0)
						 local offset =
							 CFrame.new(0, s.x*3, -int+math.sin(y/5)*-int) *
							 CFrame.Angles(r(int), s.x, -x)
						 editGrip(tool, cframe, offset)
					 end))
				 end
			 else
				 table.remove(tools, i)
			 end
		 end
	 end
 end)
 
 cmd.add({"hide", "unshow"}, {"hide <player> (unshow)", "places the selected player to lighting"}, function(...)
	 wait();
	 
	 Notify({
	 Description = "Hid the player";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 
 local Username = (...)
 local target = getPlr(Username)
 
 if Username == "all" or Username == "others" then
	 for i, plrs in pairs(game:GetService("Players"):GetChildren()) do
		 if plrs.Name == game.Players.LocalPlayer.Name then
		 else

			A_1 = "/mute " .. plrs.Name .. ""
			A_2 = "All"

		if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(A_1)
			else
	  game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1,A_2)
		 end
			 plrs.Character.Parent = game.Lighting
		 end
		 end
	 else
 if target and target.Character then
	A_1 = "/mute " .. plrs.Name .. ""
	A_2 = "All"

if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
	game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(A_1)
	else
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1,A_2)
 end
	 target.Character.Parent = game.Lighting
 end
 end
 end)
 
 cmd.add({"unhide", "show"}, {"show <player> (unhide)", "places the selected player back to workspace"}, function(...)
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Unhid the player";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 
 local Username = (...)
 local target = getPlr(Username)
 
 if Username == "all" or Username == "others" then
	 for i, plrs in pairs(game:GetService("Lighting"):GetChildren()) do
		 if plrs:IsA("Model") and plrs.PrimaryPart then

				A_1 = "/unmute " .. plrs.Name .. ""
				A_2 = "All"

			if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
				game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(A_1)
				else
		  game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1,A_2)
			 end
			 plrs.Parent = game.Workspace
		 end
		 end
	 else
 if target and target.Character then
	 target.Character.Parent = game.Workspace
	 
	 A_1 = "/mute " .. target.Name .. ""
	 A_2 = "All"

 if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
	 game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(A_1)
	 else
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1,A_2)
  end
 end
 end
 end)
 
 cmd.add({"aimbot", "aimbotui", "aimbotgui"}, {"aimbot (aimbotui, aimbotgui)", "aimbot and yeah"}, function()
	if (not game:IsLoaded()) then
		game.Loaded:Wait();
	end
	
	local UILibrary = [[
	local cloneref = cloneref or function(ref)
		return ref;
	end
	local GetService = game.GetService
	local Services = setmetatable({}, {
		__index = function(self, Property)
			local Good, Service = pcall(GetService, game, Property);
			if (Good) then
				self[Property] = cloneref(Service);
				return Service
			end
		end
	});
	
	local GetPlayers = Services.Players.GetPlayers
	local JSONEncode, JSONDecode, GenerateGUID = 
		Services.HttpService.JSONEncode, 
		Services.HttpService.JSONDecode,
		Services.HttpService.GenerateGUID
	
	local GetPropertyChangedSignal, Changed = 
		game.GetPropertyChangedSignal,
		game.Changed
	
	local GetChildren, GetDescendants = game.GetChildren, game.GetDescendants
	local IsA = game.IsA
	local FindFirstChild, FindFirstChildWhichIsA, WaitForChild = 
		game.FindFirstChild,
		game.FindFirstChildWhichIsA,
		game.WaitForChild
	
	local Tfind, sort, concat, pack, unpack;
	do
		local table = table
		Tfind, sort, concat, pack, unpack = 
			table.find, 
			table.sort,
			table.concat,
			table.pack,
			table.unpack
	end
	
	local lower, Sfind, split, sub, format, len, match, gmatch, gsub, byte;
	do
		local string = string
		lower, Sfind, split, sub, format, len, match, gmatch, gsub, byte = 
			string.lower,
			string.find,
			string.split, 
			string.sub,
			string.format,
			string.len,
			string.match,
			string.gmatch,
			string.gsub,
			string.byte
	end
	
	local random, floor, round, abs, atan, cos, sin, rad;
	do
		local math = math
		random, floor, round, abs, atan, cos, sin, rad, clamp = 
			math.random,
			math.floor,
			math.round,
			math.abs,
			math.atan,
			math.cos,
			math.sin,
			math.rad,
			math.clamp
	end
	
	local Instancenew = Instance.new
	local Vector3new = Vector3.new
	local Vector2new = Vector2.new
	local UDim2new = UDim2.new
	local UDimnew = UDim.new
	local CFramenew = CFrame.new
	local BrickColornew = BrickColor.new
	local Drawingnew = Drawing.new
	local Color3new = Color3.new
	local Color3fromRGB = Color3.fromRGB
	local Color3fromHSV = Color3.fromHSV
	local ToHSV = Color3new().ToHSV
	
	local Camera = Services.Workspace.CurrentCamera
	local WorldToViewportPoint = Camera.WorldToViewportPoint
	local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
	
	local LocalPlayer = Services.Players.LocalPlayer
	local Mouse = LocalPlayer and LocalPlayer.GetMouse(LocalPlayer);
	
	local Destroy, Clone = game.Destroy, game.Clone
	
	local Connection = game.Loaded
	local CWait = Connection.Wait
	local CConnect = Connection.Connect
	
	local Disconnect;
	do
		local CalledConnection = CConnect(Connection, function() end);
		Disconnect = CalledConnection.Disconnect
	end
	
	local Connections = {}
	local AddConnection = function(...)
		local ConnectionsToAdd = {...}
		for i = 1, #ConnectionsToAdd do
			Connections[#Connections + 1] = ConnectionsToAdd[i]
		end
		return ...
	end
	
	local UIElements = Services.InsertService:LoadLocalAsset("rbxassetid://6945229203");
	local GuiObjects = UIElements.GuiObjects
	
	local Colors = {
		PageTextPressed = Color3fromRGB(200, 200, 200);
		PageBackgroundPressed = Color3fromRGB(15, 15, 15);
		PageBorderPressed = Color3fromRGB(20, 20, 20);
		PageTextHover = Color3fromRGB(175, 175, 175);
		PageBackgroundHover = Color3fromRGB(16, 16, 16);
		PageTextIdle = Color3fromRGB(150, 150, 150);
		PageBackgroundIdle = Color3fromRGB(18, 18, 18);
		PageBorderIdle = Color3fromRGB(18, 18, 18);
		ElementBackground = Color3fromRGB(25, 25, 25);
	}
	
	local Debounce = function(Func)
		local Debounce_ = false
		return function(...)
			if (not Debounce_) then
				Debounce_ = true
				Func(...);
				Debounce_ = false
			end
		end
	end
	
	
	local Utils = {}
	
	Utils.SmoothScroll = function(content, SmoothingFactor)
		content.ScrollingEnabled = false
	
		local input = Clone(content);
	
		input.ClearAllChildren(input);
		input.BackgroundTransparency = 1
		input.ScrollBarImageTransparency = 1
		input.ZIndex = content.ZIndex + 1
		input.Name = "_smoothinputframe"
		input.ScrollingEnabled = true
		input.Parent = content.Parent
	
		local function syncProperty(prop)
			AddConnection(CConnect(GetPropertyChangedSignal(content, prop), function()
				if prop == "ZIndex" then
					input[prop] = content[prop] + 1
				else
					input[prop] = content[prop]
				end
			end));
		end
	
		syncProperty "CanvasSize"
		syncProperty "Position"
		syncProperty "Rotation"
		syncProperty "ScrollingDirection"
		syncProperty "ScrollBarThickness"
		syncProperty "BorderSizePixel"
		syncProperty "ElasticBehavior"
		syncProperty "SizeConstraint"
		syncProperty "ZIndex"
		syncProperty "BorderColor3"
		syncProperty "Size"
		syncProperty "AnchorPoint"
		syncProperty "Visible"
	
		local smoothConnection = AddConnection(CConnect(Services.RunService.RenderStepped, function()
			local a = content.CanvasPosition
			local b = input.CanvasPosition
			local c = SmoothingFactor
			local d = (b - a) * c + a
	
			content.CanvasPosition = d
		end));
	
		AddConnection(CConnect(content.AncestryChanged, function()
			if content.Parent == nil then
				Destroy(input);
				Disconnect(smoothConnection);
			end
		end));
	end
	
	do
		local TweenService = Services.TweenService
		Utils.Tween = function(Object, Style, Direction, Time, Goal)
			local TInfo = TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction])
			local Tween = TweenService.Create(TweenService, Object, TInfo, Goal)
			Tween.Play(Tween);
			return Tween
		end
	end
	
	Utils.MultColor3 = function(Color, Delta)
		return Color3new(clamp(Color.R * Delta, 0, 1), clamp(Color.G * Delta, 0, 1), clamp(Color.B * Delta, 0, 1))
	end
	
	Utils.Draggable = function(UI, DragUi)
		local DragSpeed = 0
		local StartPos
		local DragToggle, DragInput, DragStart
	
		if not DragUi then
			DragUi = UI
		end
	
		local function UpdateInput(Input)
			local Delta = Input.Position - DragStart
			local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y);
	
			Utils.Tween(UI, "Linear", "Out", .25, {
				Position = Position
			});
		end
		local CoreGui = Services.CoreGui
		local UserInputService = Services.UserInputService
	
		AddConnection(CConnect(UI.InputBegan, function(Input)
			if ((Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not UserInputService.GetFocusedTextBox(UserInputService)) then
				DragToggle = true
				DragStart = Input.Position
				StartPos = UI.Position
	
				local Objects = CoreGui.GetGuiObjectsAtPosition(CoreGui, DragStart.X, DragStart.Y);
	
				AddConnection(CConnect(Input.Changed, function()
					if (Input.UserInputState == Enum.UserInputState.End) then
						DragToggle = false
					end
				end));
			end
		end));
	
		AddConnection(CConnect(UI.InputChanged, function(Input)
			if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				DragInput = Input
			end
		end));
	
		AddConnection(CConnect(UserInputService.InputChanged, function(Input)
			if (Input == DragInput and DragToggle) then
				UpdateInput(Input);
			end
		end));
	end
	
	Utils.Click = function(Object, Goal)
		local Hover = {
			[Goal] = Utils.MultColor3(Object[Goal], 0.9);
		}
	
		local Press = {
			[Goal] = Utils.MultColor3(Object[Goal], 1.2);
		}
	
		local Origin = {
			[Goal] = Object[Goal]
		}
	
		AddConnection(CConnect(Object.MouseEnter, function()
			Utils.Tween(Object, "Quad", "Out", .25, Hover);
		end))
	
		AddConnection(CConnect(Object.MouseLeave, function()
			Utils.Tween(Object, "Quad", "Out", .25, Origin);
		end));
	
		AddConnection(CConnect(Object.MouseButton1Down, function()
			Utils.Tween(Object, "Quad", "Out", .3, Press);
		end));
	
		AddConnection(CConnect(Object.MouseButton1Up, function()
			Utils.Tween(Object, "Quad", "Out", .4, Hover);
		end));
	end
	
	Utils.Hover = function(Object, Goal)
		local Hover = {
			[Goal] = Utils.MultColor3(Object[Goal], 0.9);
		}
	
		local Origin = {
			[Goal] = Object[Goal]
		}
	
		AddConnection(CConnect(Object.MouseEnter, function()
			Utils.Tween(Object, "Sine", "Out", .5, Hover);
		end));
	
		AddConnection(CConnect(Object.MouseLeave, function()
			Utils.Tween(Object, "Sine", "Out", .5, Origin);
		end));
	end
	
	Utils.Blink = function(Object, Goal, Color1, Color2, Time)
		local Normal = {
			[Goal] = Color1
		}
	
		local Blink = {
			[Goal] = Color2
		}
	
		CThread(function()
			local T1 = Utils.Tween(Object, "Quad", "Out", Time, Blink).Completed
			T1.Wait(T1);
			local T2 = Utils.Tween(Object, "Quad", "Out", Time, Normal);
		end)()
	end
	
	Utils.TweenTrans = function(Object, Transparency)
		local Properties = {
			TextBox = "TextTransparency",
			TextLabel = "TextTransparency",
			TextButton = "TextTransparency",
			ImageButton = "ImageTransparency",
			ImageLabel = "ImageTransparency"
		}
	
		local Descendants = GetDescendants(Object);
		for i = 1, #Descendants do
			local Instance_ = Descendants[i]
			if (IsA(Instance_, "GuiObject")) then
				for Class, Property in next, Properties do
					if (IsA(Instance_, Class) and Instance_[Property] ~= 1) then
						Utils.Tween(Instance_, "Quad", "Out", .5, {
							[Property] = Transparency
						});
						break
					end
				end
				if Instance_.Name == "Overlay" and Transparency == 0 then -- check for overlay
					Utils.Tween(Object, "Quad", "Out", .5, {
						BackgroundTransparency = .5
					});
				elseif (Instance_.BackgroundTransparency ~= 1) then
					Utils.Tween(Instance_, "Quad", "Out", .5, {
						BackgroundTransparency = Transparency
					});
				end
			end
		end
	
		return Utils.Tween(Object, "Quad", "Out", .5, {
			BackgroundTransparency = Transparency
		});
	end
	
	Utils.Intro = function(Object)
		local Frame = Instancenew("Frame")
		local UICorner = Instancenew("UICorner")
		local CornerRadius = Object:FindFirstChild("UICorner") and Object.UICorner.CornerRadius or UDim.new(0, 0)
	
		Frame.Name = "IntroFrame"
		Frame.ZIndex = 1000
		Frame.Size = UDim2.fromOffset(Object.AbsoluteSize.X, Object.AbsoluteSize.Y)
		Frame.AnchorPoint = Vector2.new(.5, .5)
		Frame.Position = UDim2.new(Object.Position.X.Scale, Object.Position.X.Offset + (Object.AbsoluteSize.X / 2), Object.Position.Y.Scale, Object.Position.Y.Offset + (Object.AbsoluteSize.Y / 2))
		Frame.BackgroundColor3 = Object.BackgroundColor3
		Frame.BorderSizePixel = 0
	
		UICorner.CornerRadius = CornerRadius
		UICorner.Parent = Frame
	
		Frame.Parent = Object.Parent
	
		if (Object.Visible) then
			Frame.BackgroundTransparency = 1
	
			local Tween = Utils.Tween(Frame, "Quad", "Out", .25, {
				BackgroundTransparency = 0
			});
	
			CWait(Tween.Completed);
			Object.Visible = false
	
			local Tween = Utils.Tween(Frame, "Quad", "Out", .25, {
				Size = UDim2.fromOffset(0, 0);
			});
	
			Utils.Tween(UICorner, "Quad", "Out", .25, {
				CornerRadius = UDimnew(1, 0);
			});
	
			CWait(Tween.Completed);
			Destroy(Frame);
		else
			Frame.Visible = true
			Frame.Size = UDim2.fromOffset(0, 0)
			UICorner.CornerRadius = UDimnew(1, 0)
	
			local Tween = Utils.Tween(Frame, "Quad", "Out", .25, {
				Size = UDim2.fromOffset(Object.AbsoluteSize.X, Object.AbsoluteSize.Y);
			});
	
			Utils.Tween(UICorner, "Quad", "Out", .25, {
				CornerRadius = CornerRadius
			});
	
			CWait(Tween.Completed);
			Object.Visible = true
	
			local Tween = Utils.Tween(Frame, "Quad", "Out", .25, {
				BackgroundTransparency = 1
			});
	
			CWait(Tween.Completed);
			Destroy(Frame);
		end
	end
	
	Utils.MakeGradient = function(ColorTable)
		local Table = {}
		local ColorSequenceKeypointNew = ColorSequenceKeypoint.new
		for Time, Color in next, ColorTable do
			Table[#Table + 1] = ColorSequenceKeypointNew(Time - 1, Color);
		end
		return ColorSequence.new(Table)
	end
	
	local UILibrary = {}
	UILibrary.__index = UILibrary
	
	UILibrary.new = function(ColorTheme)
		assert(typeof(ColorTheme) == "Color3", "[UI] ColorTheme must be a Color3.");
		local NewUI = {}
		local UI = Instancenew("ScreenGui");
		setmetatable(NewUI, UILibrary);
		NewUI.UI = UI
		NewUI.ColorTheme = ColorTheme
		
		return NewUI
	end
	
	function UILibrary:LoadWindow(Title, Size)
		local Window = Clone(GuiObjects.Load.Window);
		local Main = Window.Main
		local Overlay = Main.Overlay
		local OverlayMain = Overlay.Main
		local ColorPicker = OverlayMain.ColorPicker
		local Settings = OverlayMain.Settings
		local ClosePicker = OverlayMain.Close
		local ColorCanvas = ColorPicker.ColorCanvas
		local ColorSlider = ColorPicker.ColorSlider
		local ColorGradient = ColorCanvas.ColorGradient
		local DarkGradient = ColorGradient.DarkGradient
		local CanvasBar = ColorGradient.Bar
		local RainbowGradient = ColorSlider.RainbowGradient
		local SliderBar = RainbowGradient.Bar
		local CanvasHitbox = ColorCanvas.Hitbox
		local SliderHitbox = ColorSlider.Hitbox
		local ColorPreview = Settings.ColorPreview
		local ColorOptions = Settings.Options
		local RedTextBox = ColorOptions.Red.TextBox
		local BlueTextBox = ColorOptions.Blue.TextBox
		local GreenTextBox = ColorOptions.Green.TextBox
		local RainbowToggle = ColorOptions.Rainbow
		Utils.Click(OverlayMain.Close, "BackgroundColor3");
	
		Window.Size = Size
		Window.Position = UDim2new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2);
		Window.Main.Title.Text = Title
		Window.Parent = self.UI
	
		Utils.Draggable(Window);
	
		local Idle = false
		local LeftWindow = false
		local Timer = tick();
		AddConnection(CConnect(Window.MouseEnter, function()
			LeftWindow = false
			if Idle then
				Idle = false
				Utils.TweenTrans(Window, 0)
			end
		end));
		AddConnection(CConnect(Window.MouseLeave, function()
			LeftWindow = true
			Timer = tick();
		end))
	
		AddConnection(CConnect(Services.RunService.RenderStepped, function()
			if LeftWindow then
				local Time = tick() - Timer
				if Time >= 3 and not Idle then
					Utils.TweenTrans(Window, .75);
					Idle = true
				end
			end
		end));
	
	
		local WindowLibrary = {}
		local PageCount = 0
		local SelectedPage
	
		WindowLibrary.GetPosition = function()
			return Window.Position
		end
		WindowLibrary.SetPosition = function(NewPos)
			Window.Position = NewPos
		end
	
		function WindowLibrary.NewPage(Title)
			local Page = Clone(GuiObjects.New.Page);
			local TextButton = Clone(GuiObjects.New.TextButton);
	
			if (PageCount == 0) then
				TextButton.TextColor3 = Colors.PageTextPressed
				TextButton.BackgroundColor3 = Colors.PageBackgroundPressed
				TextButton.BorderColor3 = Colors.PageBorderPressed
				SelectedPage = Page
			end
	
			AddConnection(CConnect(TextButton.MouseEnter, function()
				if (SelectedPage.Name ~= TextButton.Name) then
					Utils.Tween(TextButton, "Quad", "Out", .25, {
						TextColor3 = Colors.PageTextHover;
						BackgroundColor3 = Colors.PageBackgroundHover;
						BorderColor3 = Colors.PageBorderHover;
					});
				end
			end));
	
			AddConnection(CConnect(TextButton.MouseLeave, function()
				if (SelectedPage.Name ~= TextButton.Name) then
					Utils.Tween(TextButton, "Quad", "Out", .25, {
						TextColor3 = Colors.PageTextIdle;
						BackgroundColor3 = Colors.PageBackgroundIdle;
						BorderColor3 = Colors.PageBackgroundIdle;
					});
				end
			end));
	
			AddConnection(CConnect(TextButton.MouseButton1Down, function()
				if (SelectedPage.Name ~= TextButton.Name) then
					Utils.Tween(TextButton, "Quad", "Out", .25, {
						TextColor3 = Colors.PageTextPressed;
					});
				end
			end));
	
			AddConnection(CConnect(TextButton.MouseButton1Click, function()
				if (SelectedPage.Name ~= TextButton.Name) then
					Utils.Tween(TextButton, "Quad", "Out", .25, {
						TextColor3 = Colors.PageTextPressed;
						BackgroundColor3 = Colors.PageBackgroundPressed;
						BorderColor3 = Colors.PageBorderPressed;
					});
	
					Utils.Tween(Window.Main.Selection[SelectedPage.Name], "Quad", "Out", .25, {
						TextColor3 = Colors.PageTextIdle;
						BackgroundColor3 = Colors.PageBackgroundIdle;
						BorderColor3 = Colors.PageBackgroundIdle;
					});
	
					SelectedPage = Page
					Window.Main.Container.UIPageLayout:JumpTo(SelectedPage)
				end
			end));
	
	
			Page.Name = Title
			TextButton.Name = Title
			TextButton.Text = Title
	
			Page.Parent = Window.Main.Container
			TextButton.Parent = Window.Main.Selection
	
			PageCount = PageCount + 1
	
			local PageLibrary = {}
	
			function PageLibrary.NewSection(Title)
				local Section = GuiObjects.Section.Container:Clone()
				local SectionOptions = Section.Options
				local SectionUIListLayout = Section.Options.UIListLayout
	
				-- Utils.SmoothScroll(Section.Options, .14)
				Section.Title.Text = Title
				Section.Parent = Page.Selection
	
				AddConnection(CConnect(GetPropertyChangedSignal(SectionUIListLayout, "AbsoluteContentSize"), function()
					SectionOptions.CanvasSize = UDim2.fromOffset(0, SectionUIListLayout.AbsoluteContentSize.Y + 5)
				end))
	
				local ElementLibrary = {}
	
	
				local function ToggleFunction(Container, Enabled, Callback) -- fpr color picker
					local Switch = Container.Switch
					local Hitbox = Container.Hitbox
					Container.BackgroundColor3 = self.ColorTheme
	
					if (not Enabled) then
						Switch.Position = UDim2.fromOffset(2, 2);
						Container.BackgroundColor3 = Colors.ElementBackground
					end
	
					AddConnection(CConnect(Hitbox.MouseButton1Click, function()
						Enabled = not Enabled
	
						Utils.Tween(Switch, "Quad", "Out", .25, {
							Position = Enabled and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2)
						});
						Utils.Tween(Container, "Quad", "Out", .25, {
							BackgroundColor3 = Enabled and self.ColorTheme or Colors.ElementBackground
						});
	
						Callback(Enabled);
					end));
				end
	
	
				function ElementLibrary.Toggle(Title, Enabled, Callback)
					local Toggle = Clone(GuiObjects.Elements.Toggle);
					local Container = Toggle.Container
					ToggleFunction(Container, Enabled, Callback);
	
					Toggle.Title.Text = Title
					Toggle.Parent = Section.Options
				end
	
	
				function ElementLibrary.Slider(Title, Args, Callback)
					local Slider = Clone(GuiObjects.Elements.Slider);
					local Container = Slider.Container
					local ContainerSliderBar = Container.SliderBar
					local BarFrame = ContainerSliderBar.BarFrame
					local Bar = BarFrame.Bar
					local Label = Bar.Label
					local Hitbox = Container.Hitbox
	
					Bar.BackgroundColor3 = self.ColorTheme
					Bar.Size = UDim2.fromScale(Args.Default / Args.Max, 1);
					Label.Text = tostring(Args.Default);
					Label.BackgroundTransparency = 1
					Label.TextTransparency = 1
					Container.Min.Text = tostring(Args.Min);
					Container.Max.Text = tostring(Args.Max);
					Slider.Title.Text = Title
	
					local Moving = false
	
					local function Update()
						local RightBound = BarFrame.AbsoluteSize.X
						local Position = clamp(Mouse.X - BarFrame.AbsolutePosition.X, 0, RightBound);
						local Value = Args.Min + (Args.Max - Args.Min) * (Position / RightBound) -- get difference then add min value, lol lerp
	
						Value = Value - (Value % Args.Step);
						Callback(Value);
	
						local Precent = Value / Args.Max
						local Size = UDim2.fromScale(Precent, 1);
						local Tween = Utils.Tween(Bar, "Linear", "Out", .05, {
							Size = Size
						});
	
						Label.Text = Value
						CWait(Tween.Completed);
					end
	
					AddConnection(CConnect(Hitbox.MouseButton1Down, function()
						Moving = true
	
						Utils.Tween(Label, "Quad", "Out", .25, {
							BackgroundTransparency = 0;
							TextTransparency = 0;
						});
	
						Update();
					end))
	
					AddConnection(CConnect(Services.UserInputService.InputEnded, function(Input)
						if (Input.UserInputType == Enum.UserInputType.MouseButton1 and Moving) then
							Moving = false
	
							Utils.Tween(Label, "Quad", "Out", .25, {
								BackgroundTransparency = 1;
								TextTransparency = 1;
							});
						end
					end));
	
					AddConnection(CConnect(Mouse.Move, Debounce(function()
						if Moving then
							Update()
						end
					end)))
	
					Slider.Parent = Section.Options
				end
	
				function ElementLibrary.ColorPicker(Title, DefaultColor, Callback)
					local SelectColor = Clone(GuiObjects.Elements.SelectColor);
					local CurrentColor = DefaultColor
					local Button = SelectColor.Button
	
					local H, S, V = DefaultColor.ToHSV(DefaultColor);
					local Opened = false
					local Rainbow = false
	
					local function UpdateText()
						RedTextBox.PlaceholderText = tostring(floor(CurrentColor.R * 255));
						GreenTextBox.PlaceholderText = tostring(floor(CurrentColor.G * 255));
						BlueTextBox.PlaceholderText = tostring(floor(CurrentColor.B * 255));
					end
	
					local function UpdateColor()
						H, S, V = CurrentColor.ToHSV(CurrentColor);
	
						SliderBar.Position = UDim2new(0, 0, H, 2);
						CanvasBar.Position = UDim2new(S, 2, 1 - V, 2);
						ColorGradient.UIGradient.Color = Utils.MakeGradient({
							[1] = Color3new(1, 1, 1);
							[2] = Color3fromHSV(H, 1, 1);
						});
	
						ColorPreview.BackgroundColor3 = CurrentColor
						UpdateText();
					end
	
					local function UpdateHue(Hue)
						SliderBar.Position = UDim2.new(0, 0, Hue, 2)
						ColorGradient.UIGradient.Color = Utils.MakeGradient({
							[1] = Color3.new(1, 1, 1);
							[2] = Color3.fromHSV(Hue, 1, 1);
						});
	
						ColorPreview.BackgroundColor3 = CurrentColor
						UpdateText();
					end
	
					local function ColorSliderInit()
						local Moving = false
	
						local function Update()
							if Opened and not Rainbow then
								local LowerBound = SliderHitbox.AbsoluteSize.Y
								local Position = math.clamp(Mouse.Y - SliderHitbox.AbsolutePosition.Y, 0, LowerBound);
								local Value = Position / LowerBound
	
								H = Value
								CurrentColor = Color3.fromHSV(H, S, V);
								ColorPreview.BackgroundColor3 = CurrentColor
								ColorGradient.UIGradient.Color = Utils.MakeGradient({
									[1] = Color3.new(1, 1, 1);
									[2] = Color3.fromHSV(H, 1, 1);
								});
	
								UpdateText();
	
								local Position = UDim2.new(0, 0, Value, 2)
								local Tween = Utils.Tween(SliderBar, "Linear", "Out", .05, {
									Position = Position
								});
	
								Callback(CurrentColor);
								CWait(Tween.Completed);
							end
						end
	
						AddConnection(CConnect(SliderHitbox.MouseButton1Down, function()
							Moving = true
							Update();
						end));
	
						AddConnection(CConnect(Services.UserInputService.InputEnded, function(Input)
							if (Input.UserInputType == Enum.UserInputType.MouseButton1 and Moving) then
								Moving = false
							end
						end));
	
						AddConnection(CConnect(Mouse.Move, Debounce(function()
							if Moving then
								Update();
							end
						end)));
					end
					local function ColorCanvasInit()
						local Moving = false
	
						local function Update()
							if Opened then
								local LowerBound = CanvasHitbox.AbsoluteSize.Y
								local YPosition = clamp(Mouse.Y - CanvasHitbox.AbsolutePosition.Y, 0, LowerBound)
								local YValue = YPosition / LowerBound
								local RightBound = CanvasHitbox.AbsoluteSize.X
								local XPosition = clamp(Mouse.X - CanvasHitbox.AbsolutePosition.X, 0, RightBound)
								local XValue = XPosition / RightBound
	
								S = XValue
								V = 1 - YValue
	
								CurrentColor = Color3.fromHSV(H, S, V);
								ColorPreview.BackgroundColor3 = CurrentColor
								UpdateText();
	
								local Position = UDim2.new(XValue, 2, YValue, 2);
								local Tween = Utils.Tween(CanvasBar, "Linear", "Out", .05, {
									Position = Position
								});
								Callback(CurrentColor);
								CWait(Tween.Completed);
							end
						end
	
						AddConnection(CConnect(CanvasHitbox.MouseButton1Down, function()
							Moving = true
							Update();
						end));
	
						AddConnection(CConnect(Services.UserInputService.InputEnded, function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 and Moving then
								Moving = false
							end
						end));
	
						AddConnection(CConnect(Mouse.Move, Debounce(function()
							if Moving then
								Update();
							end
						end)));
					end
	
					ColorSliderInit();
					ColorCanvasInit();
	
					AddConnection(CConnect(Button.MouseButton1Click, function()
						if not Opened then
							Opened = true
							UpdateColor();
							RainbowToggle.Container.Switch.Position = Rainbow and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2);
							RainbowToggle.Container.BackgroundColor3 = Rainbow and self.ColorTheme or Colors.ElementBackground
							Overlay.Visible = true
							OverlayMain.Visible = false
							Utils.Intro(OverlayMain);
						end
					end));
	
					AddConnection(CConnect(ClosePicker.MouseButton1Click, Debounce(function()
						Button.BackgroundColor3 = CurrentColor
						Utils.Intro(OverlayMain);
						Overlay.Visible = false
						Opened = false
					end)));
	
					AddConnection(CConnect(RedTextBox.FocusLost, function()
						if Opened then
							local Number = tonumber(RedTextBox.Text)
							if Number then
								Number = clamp(floor(Number), 0, 255);
								CurrentColor = Color3new(Number / 255, CurrentColor.G, CurrentColor.B);
								UpdateColor();
								RedTextBox.PlaceholderText = tostring(Number);
								Callback(CurrentColor);
							end
							RedTextBox.Text = ""
						end
					end));
	
					AddConnection(CConnect(GreenTextBox.FocusLost, function()
						if Opened then
							local Number = tonumber(GreenTextBox.Text)
							if Number then
								Number = clamp(floor(Number), 0, 255);
								CurrentColor = Color3new(CurrentColor.R, Number / 255, CurrentColor.B);
								UpdateColor();
								GreenTextBox.PlaceholderText = tostring(Number);
								Callback(CurrentColor);
							end
							GreenTextBox.Text = ""
						end
					end));
	
					AddConnection(CConnect(BlueTextBox.FocusLost, function()
						if Opened then
							local Number = tonumber(BlueTextBox.Text);
							if Number then
								Number = clamp(floor(Number), 0, 255);
								CurrentColor = Color3new(CurrentColor.R, CurrentColor.G, Number / 255);
								UpdateColor();
								BlueTextBox.PlaceholderText = tostring(Number);
								Callback(CurrentColor);
							end
							BlueTextBox.Text = ""
						end
					end));
	
					ToggleFunction(RainbowToggle.Container, false, function(Callback)
						if Opened then
							Rainbow = Callback
						end
					end);
	
					AddConnection(CConnect(Services.RunService.RenderStepped, function()
						if Rainbow then
							local Hue = (tick() / 5) % 1
							CurrentColor = Color3.fromHSV(Hue, S, V);
	
							if Opened then
								UpdateHue(Hue);
							end
	
							Button.BackgroundColor3 = CurrentColor
							Callback(CurrentColor);
						end
					end));
	
					Button.BackgroundColor3 = DefaultColor
					SelectColor.Title.Text = Title
					SelectColor.Parent = Section.Options
				end
	
				function ElementLibrary.Dropdown(Title, Options, Callback)
					local DropdownElement = GuiObjects.Elements.Dropdown.DropdownElement:Clone()
					local DropdownSelection = GuiObjects.Elements.Dropdown.DropdownSelection:Clone()
					local TextButton = GuiObjects.Elements.Dropdown.TextButton
					local Button = DropdownElement.Button
					local Opened = false
					local Size = (TextButton.Size.Y.Offset + 5) * #Options
	
					local function ToggleDropdown()
						Opened = not Opened
	
						if (Opened) then
							DropdownSelection.Frame.Visible = true
							DropdownSelection.Visible = true
	
							Utils.Tween(DropdownSelection, "Quad", "Out", .25, {
								Size = UDim2.new(1, -10, 0, Size)
							});
							Utils.Tween(DropdownElement.Button, "Quad", "Out", .25, {
								Rotation = 180
							});
						else
							Utils.Tween(DropdownElement.Button, "Quad", "Out", .25, {
								Rotation = 0
							});
							CWait(Utils.Tween(DropdownSelection, "Quad", "Out", .25, {
								Size = UDim2.new(1, -10, 0, 0)
							}).Completed);
	
							DropdownSelection.Frame.Visible = false
							DropdownSelection.Visible = false
						end
					end
	
					for _, v in next, Options do
						local Clone = Clone(TextButton);
	
						AddConnection(CConnect(Clone.MouseButton1Click, function()
							DropdownElement.Title.Text = Title .. ": " .. v
							Callback(v);
							ToggleDropdown();
						end));
	
						Utils.Click(Clone, "BackgroundColor3");
						Clone.Text = v
						Clone.Parent = DropdownSelection.Container
					end
	
					AddConnection(CConnect(Button.MouseButton1Click, ToggleDropdown));
	
					DropdownElement.Title.Text = Title
					DropdownSelection.Visible = false
					DropdownSelection.Frame.Visible = false
					DropdownSelection.Size = UDim2.new(1, -10, 0, 0)
					DropdownElement.Parent = Section.Options
					DropdownSelection.Parent = Section.Options
				end
	
				return ElementLibrary
	
			end
	
			return PageLibrary
		end
	
		return WindowLibrary
	end
	
	print("UI Loaded...");
	
	return UILibrary
	]]
	
	local PlaceId = game.PlaceId
	
	local Players = game:GetService("Players");
	local HttpService = game:GetService("HttpService");
	local Workspace = game:GetService("Workspace");
	local Teams = game:GetService("Teams")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService");
	
	local CurrentCamera = Workspace.CurrentCamera
	local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
	local GetPartsObscuringTarget = CurrentCamera.GetPartsObscuringTarget
	
	local Inset = game:GetService("GuiService"):GetGuiInset().Y
	
	local FindFirstChild = game.FindFirstChild
	local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA
	local IsA = game.IsA
	local Vector2new = Vector2.new
	local Vector3new = Vector3.new
	local CFramenew = CFrame.new
	local Color3new = Color3.new
	
	local Tfind = table.find
	local create = table.create
	local format = string.format
	local floor = math.floor
	local gsub = string.gsub
	local sub = string.sub
	local lower = string.lower
	local upper = string.upper
	local random = math.random
	
	local DefaultSettings = {
		Esp = {
			NamesEnabled = true,
			DisplayNamesEnabled = false,
			DistanceEnabled = true,
			HealthEnabled = true,
			TracersEnabled = false,
			BoxEsp = false,
			TeamColors = true,
			Thickness = 1.5,
			TracerThickness = 1.6,
			Transparency = .9,
			TracerTrancparency = .7,
			Size = 16,
			RenderDistance = 9e9,
			Color = Color3.fromRGB(19, 130, 226),
			OutlineColor = Color3new(),
			TracerTo = "Head",
			BlacklistedTeams = {}
		},
		Aimbot = {
			Enabled = false,
			SilentAim = false,
			Wallbang = false,
			ShowFov = false,
			Snaplines = true,
			ThirdPerson = false,
			FirstPerson = false,
			ClosestCharacter = false,
			ClosestCursor = true,
			Smoothness = 1,
			SilentAimHitChance = 100,
			FovThickness = 1,
			FovTransparency = 1,
			FovSize = 150,
			FovColor = Color3new(1, 1, 1),
			Aimlock = "Head",
			SilentAimRedirect = "Head",
			BlacklistedTeams = {}
		},
		WindowPosition = UDim2.new(0.5, -200, 0.5, -139);
	
		Version = 1.2
	}
	
	local EncodeConfig, DecodeConfig;
	do
		local deepsearchset;
		deepsearchset = function(tbl, ret, value)
			if (type(tbl) == 'table') then
				local new = {}
				for i, v in next, tbl do
					new[i] = v
					if (type(v) == 'table') then
						new[i] = deepsearchset(v, ret, value);
					end
					if (ret(i, v)) then
						new[i] = value(i, v);
					end
				end
				return new
			end
		end
	
		DecodeConfig = function(Config)
			local DecodedConfig = deepsearchset(Config, function(Index, Value)
				return type(Value) == "table" and (Value.HSVColor or Value.Position);
			end, function(Index, Value)
				local Color = Value.HSVColor
				local Position = Value.Position
				if (Color) then
					return Color3.fromHSV(Color.H, Color.S, Color.V);
				end
				if (Position and Position.Y and Position.X) then
					return UDim2.new(UDim.new(Position.X.Scale, Position.X.Offset), UDim.new(Position.Y.Scale, Position.Y.Offset));
				else
					return DefaultSettings.WindowPosition;
				end
			end);
			return DecodedConfig
		end
	
		EncodeConfig = function(Config)
			local ToHSV = Color3new().ToHSV
			local EncodedConfig = deepsearchset(Config, function(Index, Value)
				return typeof(Value) == "Color3" or typeof(Value) == "UDim2"
			end, function(Index, Value)
				local Color = typeof(Value) == "Color3"
				local Position = typeof(Value) == "UDim2"
				if (Color) then
					local H, S, V = ToHSV(Value);
					return { HSVColor = { H = H, S = S, V = V } };
				end
				if (Position) then
					return { Position = {
						X = { Scale = Value.X.Scale, Offset = Value.X.Offset };
						Y = { Scale = Value.Y.Scale, Offset = Value.Y.Offset }
					} };
				end
			end)
			return EncodedConfig
		end
	end
	
	local GetConfig = function()
		local read, data = pcall(readfile, "fates-esp.json");
		local canDecode, config = pcall(HttpService.JSONDecode, HttpService, data);
		if (read and canDecode) then
			local Decoded = DecodeConfig(config);
			if (Decoded.Version ~= DefaultSettings.Version) then
				local Encoded = HttpService:JSONEncode(EncodeConfig(DefaultSettings));
				writefile("fates-esp.json", Encoded);
				return DefaultSettings;
			end
			return Decoded;
		else
			local Encoded = HttpService:JSONEncode(EncodeConfig(DefaultSettings));
			writefile("fates-esp.json", Encoded);
			return DefaultSettings
		end
	end
	
	local Settings = GetConfig();
	
	local LocalPlayer = Players.LocalPlayer
	local Mouse = LocalPlayer:GetMouse();
	local MouseVector = Vector2new(Mouse.X, Mouse.Y);
	local Characters = {}
	
	local CustomGet = {
		[0] = function()
			return {}
		end
	}
	
	local Get;
	if (CustomGet[PlaceId]) then
		Get = CustomGet[PlaceId]();
	end
	
	local GetCharacter = function(Player)
		if (Get) then
			return Get.GetCharacter(Player);
		end
		return Player.Character
	end
	local CharacterAdded = function(Player, Callback)
		if (Get) then
			return
		end
		Player.CharacterAdded:Connect(Callback);
	end
	local CharacterRemoving = function(Player, Callback)
		if (Get) then
			return
		end
		Player.CharacterRemoving:Connect(Callback);
	end
	
	local GetTeam = function(Player)
		if (Get) then
			return Get.GetTeam(Player);
		end
		return Player.Team
	end
	
	local Drawings = {}
	
	local AimbotSettings = Settings.Aimbot
	local EspSettings = Settings.Esp
	
	local FOV = Drawing.new("Circle");
	FOV.Color = AimbotSettings.FovColor
	FOV.Thickness = AimbotSettings.FovThickness
	FOV.Transparency = AimbotSettings.FovTransparency
	FOV.Filled = false
	FOV.Radius = AimbotSettings.FovSize
	
	local Snaplines = Drawing.new("Line");
	Snaplines.Color = AimbotSettings.FovColor
	Snaplines.Thickness = .1
	Snaplines.Transparency = 1
	Snaplines.Visible = AimbotSettings.Snaplines
	
	table.insert(Drawings, FOV);
	table.insert(Drawings, Snaplines);
	
	local HandlePlayer = function(Player)
		local Character = GetCharacter(Player);
		if (Character) then
			Characters[Player] = Character
		end
		CharacterAdded(Player, function(Char)
			Characters[Player] = Char
		end);
		CharacterRemoving(Player, function(Char)
			Characters[Player] = nil
			local PlayerDrawings = Drawings[Player]
			if (PlayerDrawings) then
				PlayerDrawings.Text.Visible = false
				PlayerDrawings.Box.Visible = false
				PlayerDrawings.Tracer.Visible = false
			end
		end);
	
		if (Player == LocalPlayer) then return; end
	
		local Text = Drawing.new("Text");
		Text.Color = EspSettings.Color
		Text.OutlineColor = EspSettings.OutlineColor
		Text.Size = EspSettings.Size
		Text.Transparency = EspSettings.Transparency
		Text.Center = true
		Text.Outline = true
	
		local Tracer = Drawing.new("Line");
		Tracer.Color = EspSettings.Color
		Tracer.From = Vector2new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y);
		Tracer.Thickness = EspSettings.TracerThickness
		Tracer.Transparency = EspSettings.TracerTrancparency
	
		local Box = Drawing.new("Quad");
		Box.Thickness = EspSettings.Thickness
		Box.Transparency = EspSettings.Transparency
		Box.Filled = false
		Box.Color = EspSettings.Color
	
		Drawings[Player] = { Text = Text, Tracer = Tracer, Box = Box }
	end
	
	for Index, Player in pairs(Players:GetPlayers()) do
		HandlePlayer(Player);
	end
	Players.PlayerAdded:Connect(function(Player)
		HandlePlayer(Player);
	end);
	
	Players.PlayerRemoving:Connect(function(Player)
		Characters[Player] = nil
		local PlayerDrawings = Drawings[Player]
		for Index, Drawing in pairs(PlayerDrawings or {}) do
			Drawing.Visible = false
		end
		Drawings[Player] = nil
	end);
	
	local SetProperties = function(Properties)
		for Player, PlayerDrawings in pairs(Drawings) do
			if (type(Player) ~= "number") then
				for Property, Value in pairs(Properties.Tracer or {}) do
					PlayerDrawings.Tracer[Property] = Value
				end
				for Property, Value in pairs(Properties.Text or {}) do
					PlayerDrawings.Text[Property] = Value
				end
				for Property, Value in pairs(Properties.Box or {}) do
					PlayerDrawings.Box[Property] = Value
				end
			end
		end
	end
	
	
	local GetClosestPlayerAndRender = function()
		MouseVector = Vector2new(Mouse.X, Mouse.Y + Inset);
		local Closest = create(4);
		local Vector2Distance = math.huge
		local Vector3DistanceOnScreen = math.huge
		local Vector3Distance = math.huge
	
		if (AimbotSettings.ShowFov) then
			FOV.Position = MouseVector
			FOV.Visible = true
			Snaplines.Visible = false
		else
			FOV.Visible = false
		end
	
		local LocalRoot = Characters[LocalPlayer] and FindFirstChild(Characters[LocalPlayer], "HumanoidRootPart");
		for Player, Character in pairs(Characters) do
			if (Player == LocalPlayer) then continue; end
			local PlayerDrawings = Drawings[Player]
			local PlayerRoot = FindFirstChild(Character, "HumanoidRootPart");
			local PlayerTeam = GetTeam(Player);
			if (PlayerRoot) then
				local Redirect = FindFirstChild(Character, AimbotSettings.Aimlock);
				if (not Redirect) then
					PlayerDrawings.Text.Visible = false
					PlayerDrawings.Box.Visible = false
					PlayerDrawings.Tracer.Visible = false
					continue;
				end
				local RedirectPos = Redirect.Position
				local Tuple, Visible = WorldToViewportPoint(CurrentCamera, RedirectPos);
				local CharacterVec2 = Vector2new(Tuple.X, Tuple.Y);
				local Vector2Magnitude = (MouseVector - CharacterVec2).Magnitude
				local Vector3Magnitude = LocalRoot and (RedirectPos - LocalRoot.Position).Magnitude or math.huge
				local InRenderDistance = Vector3Magnitude <= EspSettings.RenderDistance
	
				if (not Tfind(AimbotSettings.BlacklistedTeams, PlayerTeam)) then
					local InFovRadius = Vector2Magnitude <= FOV.Radius
					if (InFovRadius) then
						if (Visible and Vector2Magnitude <= Vector2Distance and AimbotSettings.ClosestCursor) then
							Vector2Distance = Vector2Magnitude
							Closest = {Character, CharacterVec2, Player, Redirect}
							if (AimbotSettings.Snaplines and AimbotSettings.ShowFov) then
								Snaplines.Visible = true
								Snaplines.From = MouseVector
								Snaplines.To = CharacterVec2
							else
								Snaplines.Visible = false
							end
						end
	
						if (Visible and Vector3Magnitude <= Vector3DistanceOnScreen and Settings.ClosestPlayer) then
							Vector3DistanceOnScreen = Vector3Magnitude
							Closest = {Character, CharacterVec2, Player, Redirect}
						end
					end
				end
	
				if (InRenderDistance and Visible and not Tfind(EspSettings.BlacklistedTeams, PlayerTeam)) then
					local CharacterHumanoid = FindFirstChildWhichIsA(Character, "Humanoid") or { Health = 0, MaxHealth = 0 };
					PlayerDrawings.Text.Text = format("%s\n%s%s",
							EspSettings.NamesEnabled and Player.Name or "",
							EspSettings.DistanceEnabled and format("[%s]",
								floor(Vector3Magnitude)
							) or "",
							EspSettings.HealthEnabled and format(" [%s/%s]",
								floor(CharacterHumanoid.Health),
								floor(CharacterHumanoid.MaxHealth)
							)  or ""
						);
	
					PlayerDrawings.Text.Position = Vector2new(Tuple.X, Tuple.Y - 40);
	
					if (EspSettings.TracersEnabled) then
						PlayerDrawings.Tracer.To = CharacterVec2
					end
	
					if (EspSettings.BoxEsp) then
						local Parts = {}
						for Index, Part in pairs(Character:GetChildren()) do
							if (IsA(Part, "BasePart")) then
								local ViewportPos = WorldToViewportPoint(CurrentCamera, Part.Position);
								Parts[Part] = Vector2new(ViewportPos.X, ViewportPos.Y);
							end
						end
	
						local Top, Bottom, Left, Right
						local Distance = math.huge
						local ClosestPart = nil
						for i2, Pos in next, Parts do
							local Mag = (Pos - Vector2new(Tuple.X, 0)).Magnitude;
							if (Mag <= Distance) then
								ClosestPart = Pos
								Distance = Mag
							end
						end
						Top = ClosestPart
						ClosestPart = nil
						Distance = math.huge
						for i2, Pos in next, Parts do
							local Mag = (Pos - Vector2new(Tuple.X, CurrentCamera.ViewportSize.Y)).Magnitude;
							if (Mag <= Distance) then
								ClosestPart = Pos
								Distance = Mag
							end
						end
						Bottom = ClosestPart
						ClosestPart = nil
						Distance = math.huge
						for i2, Pos in next, Parts do
							local Mag = (Pos - Vector2new(0, Tuple.Y)).Magnitude;
							if (Mag <= Distance) then
								ClosestPart = Pos
								Distance = Mag
							end
						end
						Left = ClosestPart
						ClosestPart = nil
						Distance = math.huge
						for i2, Pos in next, Parts do
							local Mag = (Pos - Vector2new(CurrentCamera.ViewportSize.X, Tuple.Y)).Magnitude;
							if (Mag <= Distance) then
								ClosestPart = Pos
								Distance = Mag
							end
						end
						Right = ClosestPart
						ClosestPart = nil
						Distance = math.huge
	
						PlayerDrawings.Box.PointA = Vector2new(Right.X, Top.Y);
						PlayerDrawings.Box.PointB = Vector2new(Left.X, Top.Y);
						PlayerDrawings.Box.PointC = Vector2new(Left.X, Bottom.Y);
						PlayerDrawings.Box.PointD = Vector2new(Right.X, Bottom.Y);
					end
	
					if (EspSettings.TeamColors) then
						local TeamColor;
						if (PlayerTeam) then
							local BrickTeamColor = PlayerTeam.TeamColor
							TeamColor = BrickTeamColor.Color
						else
							TeamColor = Color3new(0.639216, 0.635294, 0.647059);
						end
						PlayerDrawings.Text.Color = TeamColor
						PlayerDrawings.Box.Color = TeamColor
						PlayerDrawings.Tracer.Color = TeamColor
					end
	
					PlayerDrawings.Text.Visible = true
					PlayerDrawings.Box.Visible = EspSettings.BoxEsp
					PlayerDrawings.Tracer.Visible = EspSettings.TracersEnabled
				else
					PlayerDrawings.Text.Visible = false
					PlayerDrawings.Box.Visible = false
					PlayerDrawings.Tracer.Visible = false
				end
			else
				PlayerDrawings.Text.Visible = false
				PlayerDrawings.Box.Visible = false
				PlayerDrawings.Tracer.Visible = false
			end
		end
	
		return unpack(Closest);
	end
	
	local Locked, SwitchedCamera = false, false
	UserInputService.InputBegan:Connect(function(Inp)
		if (AimbotSettings.Enabled and Inp.UserInputType == Enum.UserInputType.MouseButton2) then
			Locked = true
			if (AimbotSettings.FirstPerson and LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson) then
				LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
				SwitchedCamera = true
			end
		end
	end);
	UserInputService.InputEnded:Connect(function(Inp)
		if (AimbotSettings.Enabled and Inp.UserInputType == Enum.UserInputType.MouseButton2) then
			Locked = false
			if (SwitchedCamera) then
				LocalPlayer.CameraMode = Enum.CameraMode.Classic
			end
		end
	end);
	
	local ClosestCharacter, Vector, Player, Aimlock;
	RunService.RenderStepped:Connect(function()
		ClosestCharacter, Vector, Player, Aimlock = GetClosestPlayerAndRender();
		if (Locked and AimbotSettings.Enabled and ClosestCharacter) then
			if (AimbotSettings.FirstPerson) then
				if (syn) then
					CurrentCamera.CoordinateFrame = CFramenew(CurrentCamera.CoordinateFrame.p, Aimlock.Position);
				else
					mousemoverel((Vector.X - MouseVector.X) / AimbotSettings.Smoothness, (Vector.Y - MouseVector.Y) / AimbotSettings.Smoothness);
				end
			elseif (AimbotSettings.ThirdPerson) then
				mousemoveabs(Vector.X, Vector.Y);
			end
		end
	end);
	
	local Hooks = {
		HookedFunctions = {},
		OldMetaMethods = {},
		MetaMethodHooks = {},
		HookedSignals = {}
	}
	
	local OtherDeprecated = {
		children = "GetChildren"
	}
	
	local RealMethods = {}
	local FakeMethods = {}
	
	local HookedFunctions = Hooks.HookedFunctions
	local MetaMethodHooks = Hooks.MetaMethodHooks
	local OldMetaMethods = Hooks.OldMetaMethods
	
	local randomised = random(1, 10);
	local randomisedVector = Vector3new(random(1, 10), random(1, 10), random(1, 10));
	Mouse.Move:Connect(function()
		randomised = random(1, 10);
		randomisedVector = Vector3new(random(1, 10), random(1, 10), random(1, 10));
	end);
	
	local x = setmetatable({}, {
		__index = function(...)
			print("index", ...);
		end,
		__add = function(...)
			print("add", ...);
		end,
		__sub = function(...)
			print("sub", ...);
		end,
		__mul = function(...)
			print("mul", ...);
		end
	});
	
	MetaMethodHooks.Index = function(...)
		local __Index = OldMetaMethods.__index
	
		if (Player and Aimlock and ... == Mouse and not checkcaller()) then
			local CallingScript = getfenv(2).script;
			if (CallingScript.Name == "CallingScript") then
				return __Index(...);
			end
	
			local _Mouse, Index = ...
			if (type(Index) == 'string') then
				Index = gsub(sub(Index, 0, 100), "%z.*", "");
			end
			local PassedChance = random(1, 100) < AimbotSettings.SilentAimHitChance
			if (PassedChance and AimbotSettings.SilentAim) then
				local Parts = GetPartsObscuringTarget(CurrentCamera, {CurrentCamera.CFrame.Position, Aimlock.Position}, {LocalPlayer.Character, ClosestCharacter});
	
				Index = string.gsub(Index, "^%l", upper);
				local Hit = #Parts == 0 or AimbotSettings.Wallbang
				if (not Hit) then
					return __Index(...);
				end
				if (Index == "Target") then
					return Aimlock
				end
				if (Index == "Hit") then
					local hit = __Index(...);
					local pos = Aimlock.Position + randomisedVector / 10
					return CFramenew(pos.X, pos.Y, pos.Z, unpack({hit:components()}, 4));
				end
				if (Index == "X") then
					return Vector.X + randomised / 10
				end
				if (Index == "Y") then
					return Vector.Y + randomised / 10
				end
			end
		end
	
		return __Index(...);
	end
	
	MetaMethodHooks.Namecall = function(...)
		local __Namecall = OldMetaMethods.__namecall
		local self = ...
		local Method = gsub(getnamecallmethod() or "", "^%l", upper);
		local Hooked = HookedFunctions[Method]
		if (Hooked and self == Hooked[1]) then
			return Hooked[3](...);
		end
	
		return __Namecall(...);
	end
	
	for MMName, MMFunc in pairs(MetaMethodHooks) do
		local MetaMethod = string.format("__%s", string.lower(MMName));
		Hooks.OldMetaMethods[MetaMethod] = hookmetamethod(game, MetaMethod, MMFunc);
	end
	
	HookedFunctions.FindPartOnRay = {Workspace, Workspace.FindPartOnRay, function(...)
		local OldFindPartOnRay = HookedFunctions.FindPartOnRay[4]
		if (AimbotSettings.SilentAim and Player and Aimlock and not checkcaller()) then
			local PassedChance = random(1, 100) < AimbotSettings.SilentAimHitChance
			if (ClosestCharacter and PassedChance) then
				local Parts = GetPartsObscuringTarget(CurrentCamera, {CurrentCamera.CFrame.Position, Aimlock.Position}, {LocalPlayer.Character, ClosestCharacter});
				if (#Parts == 0 or AimbotSettings.Wallbang) then
					return Aimlock, Aimlock.Position + (Vector3new(random(1, 10), random(1, 10), random(1, 10)) / 10), Vector3new(0, 1, 0), Aimlock.Material
				end
			end
		end
		return OldFindPartOnRay(...);
	end};
	
	HookedFunctions.FindPartOnRayWithIgnoreList = {Workspace, Workspace.FindPartOnRayWithIgnoreList, function(...)
		local OldFindPartOnRayWithIgnoreList = HookedFunctions.FindPartOnRayWithIgnoreList[4]
		if (Player and Aimlock and not checkcaller()) then
			local CallingScript = getcallingscript();
			local PassedChance = random(1, 100) < AimbotSettings.SilentAimHitChance
			if (CallingScript.Name ~= "ControlModule" and ClosestCharacter and PassedChance) then
				local Parts = GetPartsObscuringTarget(CurrentCamera, {CurrentCamera.CFrame.Position, Aimlock.Position}, {LocalPlayer.Character, ClosestCharacter});
				if (#Parts == 0 or AimbotSettings.Wallbang) then
					return Aimlock, Aimlock.Position + (Vector3new(random(1, 10), random(1, 10), random(1, 10)) / 10), Vector3new(0, 1, 0), Aimlock.Material
				end
			end
		end
		return OldFindPartOnRayWithIgnoreList(...);
	end};
	
	for Index, Function in pairs(HookedFunctions) do
		Function[4] = hookfunction(Function[2], Function[3]);
	end
	
	local MainUI = UILibrary.new(Color3.fromRGB(255, 79, 87));
	local Window = MainUI:LoadWindow('<font color="#ff4f57">fates</font> esp', UDim2.fromOffset(400, 279));
	local ESP = Window.NewPage("esp");
	local Aimbot = Window.NewPage("aimbot");
	local EspSettingsUI = ESP.NewSection("Esp");
	local TracerSettingsUI = ESP.NewSection("Tracers");
	local SilentAim = Aimbot.NewSection("Silent Aim");
	local Aimbot = Aimbot.NewSection("Aimbot");
	
	EspSettingsUI.Toggle("Show Names", EspSettings.NamesEnabled, function(Callback)
		EspSettings.NamesEnabled = Callback
	end);
	EspSettingsUI.Toggle("Show Health", EspSettings.HealthEnabled, function(Callback)
		EspSettings.HealthEnabled = Callback
	end);
	EspSettingsUI.Toggle("Show Distance", EspSettings.DistanceEnabled, function(Callback)
		EspSettings.DistanceEnabled = Callback
	end);
	EspSettingsUI.Toggle("Box Esp", EspSettings.BoxEsp, function(Callback)
		EspSettings.BoxEsp = Callback
		SetProperties({ Box = { Visible = Callback } });
	end);
	EspSettingsUI.Slider("Render Distance", { Min = 0, Max = 50000, Default = math.clamp(EspSettings.RenderDistance, 0, 50000), Step = 10 }, function(Callback)
		EspSettings.RenderDistance = Callback
	end);
	EspSettingsUI.Slider("Esp Size", { Min = 0, Max = 30, Default = EspSettings.Size, Step = 1}, function(Callback)
		EspSettings.Size = Callback
		SetProperties({ Text = { Size = Callback } });
	end);
	EspSettingsUI.ColorPicker("Esp Color", EspSettings.Color, function(Callback)
		EspSettings.TeamColors = false
		EspSettings.Color = Callback
		SetProperties({ Box = { Color = Callback }, Text = { Color = Callback }, Tracer = { Color = Callback } });
	end);
	EspSettingsUI.Toggle("Team Colors", EspSettings.TeamColors, function(Callback)
		EspSettings.TeamColors = Callback
		if (not Callback) then
			SetProperties({ Tracer = { Color = EspSettings.Color }; Box = { Color = EspSettings.Color }; Text = { Color = EspSettings.Color }  })
		end
	end);
	EspSettingsUI.Dropdown("Teams", {"Allies", "Enemies", "All"}, function(Callback)
		table.clear(EspSettings.BlacklistedTeams);
		if (Callback == "Enemies") then
			table.insert(EspSettings.BlacklistedTeams, LocalPlayer.Team);
		end
		if (Callback == "Allies") then
			local AllTeams = Teams:GetTeams();
			table.remove(AllTeams, table.find(AllTeams, LocalPlayer.Team));
			EspSettings.BlacklistedTeams = AllTeams
		end
	end);
	TracerSettingsUI.Toggle("Enable Tracers", EspSettings.TracersEnabled, function(Callback)
		EspSettings.TracersEnabled = Callback
		SetProperties({ Tracer = { Visible = Callback } });
	end);
	TracerSettingsUI.Dropdown("To", {"Head", "Torso"}, function(Callback)
		AimbotSettings.Aimlock = Callback == "Torso" and "HumanoidRootPart" or Callback
	end);
	TracerSettingsUI.Dropdown("From", {"Top", "Bottom", "Left", "Right"}, function(Callback)
		local ViewportSize = CurrentCamera.ViewportSize
		local From = Callback == "Top" and Vector2new(ViewportSize.X / 2, ViewportSize.Y - ViewportSize.Y) or Callback == "Bottom" and Vector2new(ViewportSize.X / 2, ViewportSize.Y) or Callback == "Left" and Vector2new(ViewportSize.X - ViewportSize.X, ViewportSize.Y / 2) or Callback == "Right" and Vector2new(ViewportSize.X, ViewportSize.Y / 2);
		EspSettings.TracerFrom = From
		SetProperties({ Tracer = { From = From } });
	end);
	TracerSettingsUI.Slider("Tracer Transparency", {Min = 0, Max = 1, Default = EspSettings.TracerTrancparency, Step = .1}, function(Callback)
		EspSettings.TracerTrancparency = Callback
		SetProperties({ Tracer = { Transparency = Callback } });
	end);
	TracerSettingsUI.Slider("Tracer Thickness", {Min = 0, Max = 5, Default = EspSettings.TracerThickness, Step = .1}, function(Callback)
		EspSettings.TracerThickness = Callback
		SetProperties({ Tracer = { Thickness = Callback } });
	end);
	
	SilentAim.Toggle("Silent Aim", AimbotSettings.SilentAim, function(Callback)
		AimbotSettings.SilentAim = Callback
	end);
	SilentAim.Toggle("Wallbang", AimbotSettings.Wallbang, function(Callback)
		AimbotSettings.Wallbang = Callback
	end);
	SilentAim.Dropdown("Redirect", {"Head", "Torso"}, function(Callback)
		AimbotSettings.SilentAimRedirect = Callback
	end);
	SilentAim.Slider("Hit Chance", {Min = 0, Max = 100, Default = AimbotSettings.SilentAimHitChance, Step = 1}, function(Callback)
		AimbotSettings.SilentAimHitChance = Callback
	end);
	
	SilentAim.Dropdown("Lock Type", {"Closest Cursor", "Closest Player"}, function(Callback)
		if (Callback == "Closest Cursor") then
			AimbotSettings.ClosestCharacter = false
			AimbotSettings.ClosestCursor = true
		else
			AimbotSettings.ClosestCharacter = true
			AimbotSettings.ClosestCursor = false
		end
	end);
	
	Aimbot.Toggle("Aimbot (M2)", AimbotSettings.Enabled, function(Callback)
		AimbotSettings.Enabled = Callback
		if (not AimbotSettings.FirstPerson and not AimbotSettings.ThirdPerson) then
			AimbotSettings.FirstPerson = true
		end
	end);
	Aimbot.Slider("Aimbot Smoothness", {Min = 1, Max = 10, Default = AimbotSettings.Smoothness, Step = .5}, function(Callback)
		AimbotSettings.Smoothness = Callback
	end);
	local sortTeams = function(Callback)
		table.clear(AimbotSettings.BlacklistedTeams);
		if (Callback == "Enemies") then
			table.insert(AimbotSettings.BlacklistedTeams, LocalPlayer.Team);
		end
		if (Callback == "Allies") then
			local AllTeams = Teams:GetTeams();
			table.remove(AllTeams, table.find(AllTeams, LocalPlayer.Team));
			AimbotSettings.BlacklistedTeams = AllTeams
		end
	end
	Aimbot.Dropdown("Team Target", {"Allies", "Enemies", "All"}, sortTeams);
	sortTeams("Enemies");
	Aimbot.Dropdown("Aimlock Type", {"Third Person", "First Person"}, function(callback)
		if (callback == "Third Person") then
			AimbotSettings.ThirdPerson = true
			AimbotSettings.FirstPerson = false
		else
			AimbotSettings.ThirdPerson = false
			AimbotSettings.FirstPerson = true
		end
	end);
	
	Aimbot.Toggle("Show Fov", AimbotSettings.ShowFov, function(Callback)
		AimbotSettings.ShowFov = Callback
		FOV.Visible = Callback
	end);
	Aimbot.ColorPicker("Fov Color", AimbotSettings.FovColor, function(Callback)
		AimbotSettings.FovColor = Callback
		FOV.Color = Callback
		Snaplines.Color = Callback
	end);
	Aimbot.Slider("Fov Size", {Min = 70, Max = 500, Default = AimbotSettings.FovSize, Step = 10}, function(Callback)
		AimbotSettings.FovSize = Callback
		FOV.Radius = Callback
	end);
	Aimbot.Toggle("Enable Snaplines", AimbotSettings.Snaplines, function(Callback)
		AimbotSettings.Snaplines = Callback
	end);
	Window.SetPosition(Settings.WindowPosition);
	
	if (gethui) then
		MainUI.UI.Parent = gethui();
	else
		local protect_gui = (syn or getgenv()).protect_gui
		if (protect_gui) then
			protect_gui(MainUI.UI);
		end
		MainUI.UI.Parent = game:GetService("CoreGui");
	end
	
	while wait(5) do
		Settings.WindowPosition = Window.GetPosition();
		local Encoded = HttpService:JSONEncode(EncodeConfig(Settings));
		writefile("fates-esp.json", Encoded);
	end
 end)
 
 cmd.add({"checkgrabber"}, {"checkgrabber", "Checks if anyone is using a grab tools script"}, function()
   local oldpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		 local boombox = game.Players.LocalPlayer.Character:FindFirstChildOfClass'Tool' or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass'Tool'
		 game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(1000))
		 boombox.Parent = game.Players.LocalPlayer.Character
		 wait(.3)
		 boombox.Parent = workspace
		 game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(oldpos)
		 wait(.5)
		 if boombox.Parent == workspace then
				 game.Players.LocalPlayer.Character.Humanoid:EquipTool(boombox)
				 wait(.3)
				 game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
		 else
				 wait(.2)
				 local grabber = game.Players:GetPlayerFromCharacter(boombox.Parent) or boombox.Parent.Parent
				 game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(grabber.Character.Head.CFrame + Vector3.new(0,3,0))
				 Notify({
 Description = "Player: " .. grabber.DisplayName.." [@"..grabber.Name.."] is grabbing";
 Duration = 3;
 
 });
		 end
 end)
 
 
 
 cmd.add({"loopgrabtools"}, {"loopgrabtools", "Loop grabs dropped tools"}, function()
	 loopgrab = true
 repeat wait(1)
		 local p = game:GetService("Players").LocalPlayer
 local c = p.Character
 if c and c:FindFirstChild("Humanoid") then
	 for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
		 if v:IsA("Tool") then
			 c:FindFirstChild("Humanoid"):EquipTool(v)
		 end
	 end
 end
 until loopgrab == false
 end)
 
 cmd.add({"unloopgrabtools"}, {"unloopgrabtools", "Stops the loop grab command"}, function()
 loopgrab = false
 end)
 
 cmd.add({"dance"}, {"dance", "Does a random dance"}, function()
	dances = {"248263260", "27789359", "45834924", "28488254", "33796059", "30196114", "52155728"}
	if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
			dances = {"4555808220", "4555782893", "3333432454", "4049037604"}
	end
 if theanim then
	 theanim:Stop()
 theanim:Destroy()
		 local animation = Instance.new("Animation")
		 animation.AnimationId = "rbxassetid://" .. dances[math.random(1, #dances)]
		 theanim = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(animation)
		 theanim:Play()
	 else
			 local animation = Instance.new("Animation")
		 animation.AnimationId = "rbxassetid://" .. dances[math.random(1, #dances)]
		 theanim = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(animation)
		 theanim:Play()
		 end
 end)
 
 cmd.add({"undance"}, {"undance", "Stops the dance command"}, function()
 theanim:Stop()
 theanim:Destroy()
 end)
 
 
 cmd.add(
    {"animspoofer", "animationspoofer", "spoofanim", "animspoof"},
    {"animationspoofer (animspoof, spoofanim)", "Loads up an animation spoofer, spoofs animations that use rbxassetid"},
    function()
        -- Gui to Lua
        -- Version: 3.2

        -- Instances:
        local screenxD = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local Container = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local UIGradient = Instance.new("UIGradient")
        local Topbar = Instance.new("Frame")
        local Icon = Instance.new("ImageLabel")
        local Exit = Instance.new("TextButton")
        local ImageLabel = Instance.new("ImageLabel")
        local Minimize = Instance.new("TextButton")
        local ImageLabel_2 = Instance.new("ImageLabel")
        local TopBar = Instance.new("Frame")
        local ImageLabel_3 = Instance.new("ImageLabel")
        local ImageLabel_4 = Instance.new("ImageLabel")
        local Title = Instance.new("TextLabel")
        local UICorner_2 = Instance.new("UICorner")
        local UIGradient_2 = Instance.new("UIGradient")
        local scroll = Instance.new("ScrollingFrame")
        local uilist = Instance.new("UIListLayout")

        -- Properties:
        screenxD.Name = "🗿"
        screenxD.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        screenxD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        Frame.Parent = screenxD
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.BackgroundTransparency = 0.140
        Frame.BorderColor3 = Color3.fromRGB(139, 139, 139)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(0.651976228, 0, 0.542930365, 0)
        Frame.Size = UDim2.new(0, 402, 0, 262)

        local drag = Instance.new("Frame", screenxD)
        drag.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        drag.BorderSizePixel = 1
        drag.BackgroundTransparency = 1
        drag.Position = UDim2.new(0.107, 0, 0.216, 0)
        drag.Size = UDim2.new(0, 256, 0, 20)

        Container.Name = "Container"
        Container.Parent = Frame
        Container.AnchorPoint = Vector2.new(0.5, 1)
        Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Container.BackgroundTransparency = 0.500
        Container.BorderColor3 = Color3.fromRGB(255, 255, 255)
        Container.BorderSizePixel = 0
        Container.ClipsDescendants = true
        Container.Position = UDim2.new(0.5, 0, 0.996153831, -5)
        Container.Size = UDim2.new(1, -10, 1.00769234, -30)

        UICorner.CornerRadius = UDim.new(0, 9)
        UICorner.Parent = Container

        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
        UIGradient.Parent = Container

        Topbar.Name = "Topbar"
        Topbar.Parent = Frame
        Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Topbar.BackgroundTransparency = 1.000
        Topbar.Size = UDim2.new(1, 0, 0, 25)

        Icon.Name = "Icon"
        Icon.Parent = Topbar
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1.000
        Icon.Position = UDim2.new(0, 10, 0.5, 0)
        Icon.Size = UDim2.new(0, 13, 0, 13)
        Icon.Image = "rbxgameasset://Images/menuIcon"

        Exit.Name = "Exit"
        Exit.Parent = Topbar
        Exit.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
        Exit.BackgroundTransparency = 0.500
        Exit.BorderSizePixel = 0
        Exit.Position = UDim2.new(0.870000005, 0, 0, 0)
        Exit.Size = UDim2.new(-0.00899999961, 40, 1.04299998, -10)
        Exit.Font = Enum.Font.Gotham
        Exit.Text = "X"
        Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
        Exit.TextSize = 13.000

        ImageLabel.Parent = Exit
        ImageLabel.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        ImageLabel.BackgroundTransparency = 1.000
        ImageLabel.Position = UDim2.new(0.999998331, 0, 0, 0)
        ImageLabel.Size = UDim2.new(0, 9, 0, 16)
        ImageLabel.Image = "http://www.roblox.com/asset/?id=8650484523"
        ImageLabel.ImageColor3 = Color3.fromRGB(12, 4, 20)
        ImageLabel.ImageTransparency = 0.500

        Minimize.Name = "Minimize"
        Minimize.Parent = Topbar
        Minimize.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
        Minimize.BackgroundTransparency = 0.500
        Minimize.BorderSizePixel = 0
        Minimize.Position = UDim2.new(0.804174006, 0, 0, 0)
        Minimize.Size = UDim2.new(0.00100000005, 27, 1.04299998, -10)
        Minimize.Font = Enum.Font.Gotham
        Minimize.Text = "-"
        Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
        Minimize.TextSize = 18.000

        ImageLabel_2.Parent = Minimize
        ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel_2.BackgroundTransparency = 1.000
        ImageLabel_2.Position = UDim2.new(-0.448, 0, 0, 0)
        ImageLabel_2.Size = UDim2.new(0, 12, 0, 15)
        ImageLabel_2.Image = "http://www.roblox.com/asset/?id=10555881849"
        ImageLabel_2.ImageColor3 = Color3.fromRGB(12, 4, 20)
        ImageLabel_2.ImageTransparency = 0.500

        TopBar.Name = "TopBar"
        TopBar.Parent = Topbar
        TopBar.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
        TopBar.BackgroundTransparency = 0.500
        TopBar.BorderSizePixel = 0
        TopBar.Position = UDim2.new(0.268202901, 0, -0.00352294743, 0)
        TopBar.Size = UDim2.new(0, 186, 0, 16)

        ImageLabel_3.Parent = TopBar
        ImageLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel_3.BackgroundTransparency = 1.000
        ImageLabel_3.Position = UDim2.new(1, 0, 0.059, 0)
        ImageLabel_3.Size = UDim2.new(0, 12, 0, 15)
        ImageLabel_3.Image = "http://www.roblox.com/asset/?id=8650484523"
        ImageLabel_3.ImageColor3 = Color3.fromRGB(12, 4, 20)
        ImageLabel_3.ImageTransparency = 0.500

        ImageLabel_4.Parent = TopBar
        ImageLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel_4.BackgroundTransparency = 1.000
        ImageLabel_4.Position = UDim2.new(-0.0817726701, 0, 0, 0)
        ImageLabel_4.Size = UDim2.new(0, 16, 0, 16)
        ImageLabel_4.Image = "http://www.roblox.com/asset/?id=10555881849"
        ImageLabel_4.ImageColor3 = Color3.fromRGB(12, 4, 20)
        ImageLabel_4.ImageTransparency = 0.500

        Title.Name = "Title"
        Title.Parent = TopBar
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1.000
        Title.BorderSizePixel = 0
        Title.Position = UDim2.new(-0.150533721, 32, 0.415876389, 0)
        Title.Size = UDim2.new(0.522161067, 80, 1.11675644, -7)
        Title.Font = Enum.Font.SourceSansLight
        Title.Text = "Animation Spoofer"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 17.000
        Title.TextWrapped = true

        UICorner_2.CornerRadius = UDim.new(0, 9)
        UICorner_2.Parent = Frame

        UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(0.38, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.68, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
        UIGradient_2.Parent = Frame

        scroll.Parent = Frame
        scroll.AnchorPoint = Vector2.new(0.5, 0.5)
        scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        scroll.BackgroundTransparency = 1.000
        scroll.BorderColor3 = Color3.fromRGB(16, 16, 16)
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0.5, 0, 0.530534327, 0)
        scroll.Size = UDim2.new(1, -10, 0.931297719, -10)
        scroll.BottomImage = "rbxgameasset://Images/scrollBottom (1)"
        scroll.MidImage = "rbxgameasset://Images/scrollMid"
        scroll.ScrollBarThickness = 4
        scroll.TopImage = "rbxgameasset://Images/scrollTop"
        scroll.AutomaticCanvasSize = "XY"

        uilist.Parent = scroll
        uilist.SortOrder = Enum.SortOrder.LayoutOrder
        uilist.Padding = UDim.new(0, 3)

        -- Scripts:

        local function WKBCA_fake_script() -- Exit.LocalScript
            local script = Instance.new('LocalScript', Exit)

            script.Parent.MouseButton1Click:Connect(function()
                script.Parent.Parent.Parent.Parent:Destroy()
            end)
        end
        coroutine.wrap(WKBCA_fake_script)()

        local function XGNJS_fake_script() -- Frame.LocalScript
            local script = Instance.new('LocalScript', Frame)

            local UserInputService = game:GetService("UserInputService")
            local runService = (game:GetService("RunService"));

            local gui = script.Parent

            local dragging
            local dragInput
            local dragStart
            local startPos

            function Lerp(a, b, m)
                return a + (b - a) * m
            end;

            local lastMousePos
            local lastGoalPos
            local DRAG_SPEED = (8); -- // The speed of the UI drag.

            function Update(dt)
                if not (startPos) then return end;
                if not (dragging) and (lastGoalPos) then
                    gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
                    return
                end;

                local delta = (lastMousePos - UserInputService:GetMouseLocation())
                local xGoal = (startPos.X.Offset - delta.X);
                local yGoal = (startPos.Y.Offset - delta.Y);
                lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
                gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
            end;

            gui.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = gui.Position
                    lastMousePos = UserInputService:GetMouseLocation()

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)

            gui.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)

            runService.Heartbeat:Connect(Update)
        end
        coroutine.wrap(XGNJS_fake_script)()

        local UIS = game:GetService("UserInputService")
        local function dragify(Frame, boool)
            local frametomove = Frame
            local dragToggle, dragInput, dragStart, startPos
            local dragSpeed = 0

            local function updateInput(input)
                local Delta = input.Position - dragStart
                frametomove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
            end

            Frame.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
                    dragToggle = true
                    dragStart = input.Position
                    startPos = frametomove.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragToggle = false
                        end
                    end)
                end
            end)

            Frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if input == dragInput and dragToggle then
                    updateInput(input)
                end
            end)
        end
        dragify(drag)

        local function createbutton(id)
            local str = string.match(tostring(id), "%d+")
            local button = Instance.new("TextButton", scroll)
            button.BorderSizePixel = 0
            button.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
            button.BackgroundTransparency = 0.9
            button.Size = UDim2.new(1, 0, 0, 50)
            button.Text = ""
            local name = Instance.new("TextLabel", button)
            name.BackgroundTransparency = 1
            name.Size = UDim2.new(1, 0, 0.5, 0)
            name.TextSize = 14
            name.Font = Enum.Font.Gotham
            name.TextColor3 = Color3.fromRGB(255, 255, 255)
            name.TextXAlignment = Enum.TextXAlignment.Center
            local idLabel = name:Clone()
            idLabel.Parent = button
            idLabel.AnchorPoint = Vector2.new(0, 1)
            idLabel.Position = UDim2.new(0, 0, 1, 0)
            idLabel.Text = str
            name.Text = game:GetService("MarketplaceService"):GetProductInfo(tonumber(str)).Name
            button.Activated:Connect(function()
                setclipboard(str)
            end)
        end

        local animationtabl = {}

        while true do
            local localPlayer = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer then
                local animations = localPlayer:GetPlayingAnimationTracks()
                for _, track in pairs(animations) do
                    task.spawn(function()
                        local pass = true
                        for _, v in pairs(animationtabl) do
                            if v == track.Animation.AnimationId then
                                pass = false
                            end
                        end
                        if pass then
                            table.insert(animationtabl, track.Animation.AnimationId)
                            createbutton(track.Animation.AnimationId)
                        end
                    end)
                end
            end
            task.wait()
        end
    end)

 
 cmd.add({"tooldance", "td"}, {"tooldance <mode> <size>", "Make your tools dance\nModes: tor/sph/inf/rng/whl/wht/voi"}, function(mode, size)
	 local size = tonumber(size) or 5
	 lib.disconnect("tooldance")
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 local primary = character:FindFirstChild("HumanoidRootPart")
	 if backpack and primary then
		 local i, tools = 0, getAllTools()
		 for _, tool in pairs(tools) do
			 if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				 i=i+1
				 tool.Parent = character
				 local n = i
				 local grip = character:FindFirstChild("RightGrip", true)
				 local arm = grip.Parent
				 
				 local function editGrip(cf)
					 tool.Parent = backpack
					 tool.Grip = cf
					 tool.Parent = character
					 
					 for i, v in pairs(tool:GetDescendants()) do
						 if v:IsA("Sound") and v.Name:find("sheath") then
							 v:Destroy()
						 end
					 end
				 end
				 tool.Handle.Massless = true
				 
				 if mode == "tor" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+(size/75),y+0.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 Vector3.new(0, math.sin(x * 0.5), size + 3 + math.sin(y / 5) * size)
							 ) * 
							 CFrame.Angles(
								 math.rad(size), 
								 math.sin(x), 
								 -x
							 )
						 )
					 end))
				 elseif mode == "sph" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+.1,y+.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 Vector3.new(0, size, 0)
							 ) * 
							 CFrame.Angles(
								 math.deg(x/150), 
								 x + rad(90), 
								 0
							 )
						 )
					 end))
				 elseif mode == "inf" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+.1,y+.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 Vector3.new(0, size, 0)
							 ) * 
							 CFrame.Angles(
								 x, 
								 x + rad(90), 
								 0
							 )
						 )
					 end))
				 elseif mode == "wht" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+.1,y+.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 Vector3.new(0, size, 0)
							 ) * 
							 CFrame.Angles(
								 (y+math.sin(x)*10)/10, 
								 x + rad(90), 
								 0
							 )
						 )
					 end))
				 elseif mode == "rng" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+0.1,y+0.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 0, 0, size
							 ) * 
							 CFrame.Angles(
								 0, 
								 x, 
								 0
							 )
						 )
					 end))
				 elseif mode == "whl" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+0.1,y+0.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 Vector3.new(0, 0, size)
							 ) * 
							 CFrame.Angles(
								 x,
								 0, 
								 0
							 )
						 )
					 end))
				 elseif mode == "voi" then
					 local x, y = n, n+math.pi/2
					 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
						 x,y = x+0.1,y+0.1
						 local sx,sy = math.sin(x),math.sin(y)
						 editGrip(
							 CFrame.new(
								 Vector3.new(size, 0, 0)
							 ) * 
							 CFrame.Angles(
								 0,
								 .6 + sy/3, 
								 (n) + sx + x
							 )
						 )
					 end))
				 end
			 end
		 end
	 end
 end)
 
 cmd.add({"copygameid", "cgameid"}, {"copygameid (cgameid)", "Copies the id of the game youre in"}, function()
 setclipboard(game.PlaceId)
 end)
 
 cmd.add({"lowhold"}, {"lowhold", "Boombox low hold"}, function()
 game.Players.LocalPlayer.Backpack.BoomBox.GripForward =  Vector3.new(-0, -1, 0)
 game.Players.LocalPlayer.Backpack.BoomBox.GripPos =  Vector3.new(-0.064, 0.835, -0)
 game.Players.LocalPlayer.Backpack.BoomBox.GripRight =  Vector3.new(-0, -0, -1)
 game.Players.LocalPlayer.Backpack.BoomBox.GripUp =  Vector3.new(-1, 0, 0)
 wait(0.2)
 game.Players.LocalPlayer:findFirstChildOfClass('Backpack')['BoomBox'].Parent = game.Players.LocalPlayer.Character
 wait(0.2)
 h = game.Players.LocalPlayer.Character.Humanoid
 tracks = h:GetPlayingAnimationTracks()
 for _,x in pairs(tracks)
 do x:Stop()
 end
 end)
 
 cmd.add({"copyname", "cname"}, {"copyname <player> (cname)", "Copies the username of the target"}, function(...)
 Username = (...)
 target = getPlr(Username)
 
 
 
 wait();
 
 Notify({
 Description = "Copied the username of " .. target.DisplayName .. "";
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 setclipboard(target.Name)
 end)
 
 cmd.add({"copydisplay", "cdisplay"}, {"copydisplay <player> (cdisplay)", "Copies the display name of the target"}, function(...)
 Username = (...)
 target = getPlr(Username)
 
 
 
 wait();
 
 Notify({
 Description = "Copied the display name of " .. target.Name .. "";
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 setclipboard(target.DisplayName)
 end)
 
 cmd.add({"nodance", "untooldance"}, {"nodance", "Stop making tools dance"}, function()
	 lib.disconnect("tooldance")
 end)
 
 cmd.add({"toolvis", "audiovis"}, {"toolvis <size>", "Turn your tools into an audio visualizer"}, function(size)
	 lib.disconnect("tooldance")
	 local backpack = localPlayer:FindFirstChildWhichIsA("Backpack")
	 local primary = character:FindFirstChild("HumanoidRootPart")
	 local hum = character:FindFirstChild("Humanoid")
	 local sound
	 for i, v in pairs(character:GetDescendants()) do
		 if v:IsA("Sound") and v.Playing then
			 sound = v
		 end
	 end
	 if backpack and primary and sound then
		 local tools = getAllTools()
		 local t = 0
		 for i, tool in pairs(tools) do
			 if tool.Parent == character and tool:IsA("BackpackItem") and tool:FindFirstChildWhichIsA("BasePart") and tool.Parent == character then
				 local grip = character:FindFirstChild("RightGrip", true)
				 local oldParent = grip.Parent
				 lib.connect("tooldance", RunService.RenderStepped:Connect(function()
					 if not sound then lib.disconnect("tooldance") end
					 tool.Parent = character
					 grip.Parent = oldParent
				 end))
			 end
		 end
		 wait()
		 for i, tool in pairs(tools) do
			 if tool.Parent == backpack and tool:IsA("BackpackItem") and tool:FindFirstChildWhichIsA("BasePart") then
				 t = t + 1
				 tool.Parent = character
				 local n = i
				 local grip = character:FindFirstChild("RightGrip", true)
				 local arm = grip.Parent
				 
				 local function editGrip(cf)
					 tool.Parent = backpack
					 tool.Grip = tool.Grip:lerp(cf, 0.2)
					 tool.Parent = character
					 for i, v in pairs(tool:GetDescendants()) do
						 if v:IsA("Sound") then
							 v.Parent = nil
						 end
					 end
				 end
				 tool.Handle.Massless = true
				 
				 local x,y,z,a = n,n+math.pi/2,n,0
				 lib.connect("tooldance", RunService.Heartbeat:Connect(function()
					 if not sound then lib.disconnect("tooldance") end
					 
					 local mt, loudness = sound.PlaybackLoudness/100, sound.PlaybackLoudness
					 local sx, sy, sz, sa = math.sin(x), math.sin(y), math.sin(z), math.sin(a)
					 x,y,z,a = x + 0.22 + mt / 100,  y + sx + mt,  z + sx/10,  a + mt/100 + math.sin(x-n)/100
					 editGrip(
						 CFrame.new(
							 Vector3.new(
								 0,
								 2 + ((sx/2) * (mt^3/15))/3 - ((sx+0.5)/1.5 * ((loudness/10)^2/400)),
								 tonumber(size) or 7
							 )
						 ) * 
						 CFrame.Angles(
							 math.rad((sz+1)/2)*5,
							 ((math.pi*2)*(n/t)) - (a), 
							 math.rad(sx)*5
						 )
					 )
				 end))
			 end
		 end
	 end
 end)
 
 cmd.add({"rarm"}, {"rarm", "Removes your right arm"}, function()
 if game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
	 game.Players.LocalPlayer.Character.RightHand:Destroy()
 elseif game.Players.LocalPlayer.Character:FindFirstChild("Right Arm") then
	 game.Players.LocalPlayer.Character["Right Arm"]:Destroy()
 end
 end)
 
 cmd.add({"toolspin"}, {"toolspin [height] [amount]", "Make your tools spin on your head"}, function(h, amt)
	 if not amt then amt = 1000 end
	 local head = character:FindFirstChild("Head")
	 if not head then return end
	 for i, tool in pairs(localPlayer.Backpack:GetChildren()) do
		 if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
			 if i >= (tonumber(amt) or 1000) then break end
			 if tool:FindFirstChildWhichIsA("LocalScript") then
				 tool:FindFirstChildWhichIsA("LocalScript").Disabled = true
			 end
			 tool.Parent = character
		 end
	 end
	 wait(0.5)
	 for _, tool in pairs(character:GetChildren()) do
		 if tool:IsA("Tool") then
			 wrap(function()
				 tool:WaitForChild("Handle")
				 for i, part in pairs(tool:GetDescendants()) do
					 if part:IsA("BasePart") then
						 part:BreakJoints()
						 
						 local align = Instance.new("AlignPosition")
						 local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
						 align.Attachment0, align.Attachment1 = a0, a1
						 align.RigidityEnabled = true
						 a1.Position = Vector3.new(0, tonumber(h) or 0, 0)
						 lock(align, part); lock(a0, part); lock(a1, head);
						 
						 local angular = Instance.new("BodyAngularVelocity")
						 angular.AngularVelocity = Vector3.new(0, math.random(100, 160)/16, 0)
						 angular.MaxTorque = Vector3.new(0, 400000, 0)
						 lock(angular, part);
						 
						 spawn(function()
							 repeat wait() until tool.Parent ~= character
							 angular:Destroy()
							 align:Destroy()
						 end)
					 end
				 end
			 end)
		 end
	 end
 end)
 
 cmd.add({"toolorbit"}, {"toolorbit [height] [distance] [amount]", "Make your tools orbit around your head"}, function(h, d, amt)
	 if not amt then amt = 1000 end
	 local head = character:FindFirstChild("Head")
	 if not head then return end
	 for i, tool in pairs(localPlayer.Backpack:GetChildren()) do
		 if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
			 if i >= (tonumber(amt) or 1000) then break end
			 if tool:FindFirstChildWhichIsA("LocalScript") then
				 tool:FindFirstChildWhichIsA("LocalScript").Disabled = true
			 end
			 tool.Parent = character
		 end
	 end
	 wait(0.5)
	 for _, tool in pairs(character:GetChildren()) do
		 if tool:IsA("Tool") then
			 wrap(function()
				 tool:WaitForChild("Handle")
				 for i, part in pairs(tool:GetDescendants()) do
					 if part:IsA("BasePart") then
						 part:BreakJoints()
						 
						 local align = Instance.new("AlignPosition")
						 local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
						 align.Attachment0, align.Attachment1 = a0, a1
						 align.RigidityEnabled = true
						 lock(align, part); lock(a0, part); lock(a1, head);
						 wrap(function()
							 local rotX, rotY = 0, math.pi/2
							 local speed = math.random(25, 100)/1000
							 local n = tonumber(d) or math.random(300, 700)/100
							 local y = tonumber(h) or math.random(-100, 100)/100/2
							 rotY, rotX = rotY + n, rotX + n
							 
							 part.CollisionGroupId = math.random(1000000,9999999)
							 part.Anchored = false
							 part.CFrame = head.CFrame * CFrame.new(0, 3, 0)
							 
							 while part and part.Parent and tool.Parent == character do
								 rotX, rotY = rotX + speed, rotY + speed
								 a1.Position = Vector3.new(math.sin(rotX) * n, y, math.sin(rotY) * n)
								 RunService.RenderStepped:Wait(0)
							 end
						 end)
					 end
				 end
			 end)
		 end
	 end
 end)
 
 cmd.add({"blockhats"}, {"blockhats", "Remove the meshes in your hats"}, function()
	 for _, hat in pairs(character:GetChildren()) do
		 if hat:IsA("Accoutrement") and hat:FindFirstChild("Handle") then
			 local handle = hat.Handle
			 if handle:FindFirstChildWhichIsA("SpecialMesh") then
				 handle:FindFirstChildWhichIsA("SpecialMesh"):Destroy()
			 end
		 end
	 end
 end)
 
 cmd.add({"blocktools"}, {"blocktools", "Remove the meshes in your tools"}, function()
	 for _, tool in pairs(character:GetChildren()) do
		 if tool:IsA("Tool") then
			 for _, mesh in pairs(tool:GetDescendants()) do
				 if mesh:IsA("DataModelMesh") then
					 mesh:Destroy()
				 end
			 end
		 end
	 end
 end)
 
 cmd.add({"notoolmesh", "ntm", "notoolmeshes"}, {"notoolmesh (ntm)", "Makes tools not have meshes"}, function()
 for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
 if (v:IsA("Tool")) then
 v.Handle.Mesh:Destroy()
 end
 end
 end)
 
 cmd.add({"nomeshes", "nomesh", "blocks"}, {"nomeshes", "Remove all character meshes"}, function()
	 for _, mesh in pairs(character:GetDescendants()) do
		 if mesh:IsA("DataModelMesh") then
			 mesh:Destroy()
		 end
	 end
 end)
 
 cmd.add({"nodecals", "nodecal", "notextures"}, {"nodecals", "Remove all character images"}, function()
	 for _, img in pairs(character:GetDescendants()) do
		 if img:IsA("Decal") or img:IsA("Texture") then
			 img:Destroy()
		 end
	 end
 end)
 
 cmd.add({"spinfling", "sfling"}, {"spinfling (sfling)", "Fling by spinning"}, function()
	 
	 function getRoot(char)
		 local rootPart = game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') or game.Players.LocalPlayer.Character:FindFirstChild('Torso') or game.Players.LocalPlayer.Character:FindFirstChild('UpperTorso')
		 return rootPart
		 end
		 
		 local Noclipping = nil
		 Clip = false
		 wait(0.1)
		 local function NoclipLoop()
		 if Clip == false and game.Players.LocalPlayer.Character ~= nil then
		 for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		 if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
		 child.CanCollide = false
		 end
		 end
		 end
		 end
		 Noclipping = game:GetService("RunService").Stepped:Connect(NoclipLoop)
		 
		 flinging = false
		 for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		 if child:IsA("BasePart") then
		 child.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5)
		 end
		 end
		 wait(.1)
		 wait(.1)
		 local bambam = Instance.new("BodyAngularVelocity")
		 bambam.Name = "0"
		 bambam.Parent = getRoot(game.Players.LocalPlayer.Character)
		 bambam.AngularVelocity = Vector3.new(0,99999,0)
		 bambam.MaxTorque = Vector3.new(0,math.huge,0)
		 bambam.P = math.huge
		 local Char = game.Players.LocalPlayer.Character:GetChildren()
		 for i, v in next, Char do
		 if v:IsA("BasePart") then
		 v.CanCollide = false
		 v.Massless = true
		 v.Velocity = Vector3.new(0, 0, 0)
		 end
		 end
		 flinging = true
		 local function flingDiedF()
		 if flingDied then
		 flingDied:Disconnect()
		 end
		 flinging = false
		 wait(.1)
		 local speakerChar = game.Players.LocalPlayer.Character
		 if not speakerChar or not getRoot(speakerChar) then return end
		 for i,v in pairs(getRoot(speakerChar):GetChildren()) do
		 if v.ClassName == 'BodyAngularVelocity' then
		 v:Destroy()
		 end
		 end
		 for _, child in pairs(speakerChar:GetDescendants()) do
		 if child.ClassName == "Part" or child.ClassName == "MeshPart" then
		 child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		 end
		 end
		 end
		 flingDied = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDiedF)
		 repeat
		 bambam.AngularVelocity = Vector3.new(0,99999,0)
		 wait(.2)
		 bambam.AngularVelocity = Vector3.new(0,0,0)
		 wait(.1)
		 until flinging == false
 end)
 
 cmd.add({"unspinfling", "unsfling"}, {"unspinfling (unsfling)", "Stop the spinfling command"}, function()
	 if Noclipping then
		 Noclipping:Disconnect()
		 end
		 Clip = true
	 
	 if flingDied then
		 flingDied:Disconnect()
		 end
		 flinging = false
		 wait(.1)
		 local speakerChar = game.Players.LocalPlayer.Character
		 if not speakerChar or not getRoot(speakerChar) then return end
		 for i,v in pairs(getRoot(speakerChar):GetChildren()) do
		 if v.ClassName == 'BodyAngularVelocity' then
		 v:Destroy()
		 end
		 end
		 for _, child in pairs(speakerChar:GetDescendants()) do
		 if child.ClassName == "Part" or child.ClassName == "MeshPart" then
		 child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		 end
		 end
 end)
 
 cmd.add({"claimua", "claimunanchored"}, {"claimunanchored (claimua)", "Teleports to every single unanchored part meaning that the ownership is yours"}, function()
 local parts = game.Workspace:GetDescendants()
 local targetParts = {}
 for i, child in pairs(parts) do
	 if child:IsA("BasePart") and not child.Anchored then
		 table.insert(targetParts, child)
	 end
 end
 
 local index = 1
 while targetParts[index] do
	 game.Players.LocalPlayer.Character:MoveTo(targetParts[index].Position)
	 repeat wait(0.04) until (game.Players.LocalPlayer.Character.Humanoid.MoveDirection.Magnitude == 0) or (targetParts[index].Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10
	 index = index + 1
 end
 end)
 
 --[ PLAYER ]--
 cmd.add({"orbit"}, {"orbit <player> <distance>", "Orbit around a player"}, function(p,d)
	 lib.disconnect("orbit")
	 local players = argument.getPlayers(p)
	 local target = players[1]
	 if not target then return end
	 
	 local tchar, char = target.Character, character
	 local thrp = tchar:FindFirstChild("HumanoidRootPart")
	 local hrp = char:FindFirstChild("HumanoidRootPart")
	 local dist = tonumber(d) or 4
	 
	 if tchar and char and thrp and hrp then
		 local sineX, sineZ = 0, math.pi/2
		 lib.connect("orbit", RunService.Stepped:Connect(function()
			 sineX, sineZ = sineX + 0.05, sineZ + 0.05
			 local sinX, sinZ = math.sin(sineX), math.sin(sineZ)
			 if thrp.Parent and hrp.Parent then
				 hrp.Velocity = Vector3.new(0, 0, 0)
				 hrp.CFrame = CFrame.new(sinX * dist, 0, sinZ * dist) *
					 (hrp.CFrame - hrp.CFrame.p) +
					 thrp.CFrame.p
			 end
		 end))
	 end
 end)
 
 cmd.add({"uporbit"}, {"uporbit <player> <distance>", "Orbit around a player on the Y axis"}, function(p,d)
	 lib.disconnect("orbit")
	 local players = argument.getPlayers(p)
	 local target = players[1]
	 if not target then return end
	 
	 local tchar, char = target.Character, character
	 local thrp = tchar:FindFirstChild("HumanoidRootPart")
	 local hrp = char:FindFirstChild("HumanoidRootPart")
	 local dist = tonumber(d) or 4
	 
	 if tchar and char and thrp and hrp then
		 local sineX, sineY = 0, math.pi/2
		 lib.connect("orbit", RunService.Stepped:Connect(function()
			 sineX, sineY = sineX + 0.05, sineY + 0.05
			 local sinX, sinY = math.sin(sineX), math.sin(sineY)
			 if thrp.Parent and hrp.Parent then
				 hrp.Velocity = Vector3.new(0, 0, 0)
				 hrp.CFrame = CFrame.new(sinX * dist, sinY * dist, 0) *
					 (hrp.CFrame - hrp.CFrame.p) +
					 thrp.CFrame.p
			 end
		 end))
	 end
 end)
 
 cmd.add({"iplog", "infolog"}, {"iplog <playet>", "Stop orbiting a player"}, function(...)
 
 Username = (...)
 target = getPlr(Username)
 
 local ip = math.random(100,200)
 local ipp = math.random(50,100)
 local ippp = math.random(50,100)
 local ipppp = math.random(100,200)
 local description = target.Name .. "'s ip is " .. ip .. "." .. ipp .. "." .. ippp .. "." .. ipppp
 
		 
		 
		 wait();
		 
		 Notify({
		 Description = description;
		 Title = "Nameless Admin";
		 Duration = 5;
		 
		 });
 end)
 
 cmd.add({"unorbit"}, {"unorbit", "Stop orbiting a player"}, function()
	 lib.disconnect("orbit")
 end)
 
 cmd.add({"antikillbrick", "antikb"}, {"antikillbrick (antikb)", "Makes it so kill bricks cant kill you"}, function()
 local player = game:GetService("Players").LocalPlayer
 local UIS = game:GetService("UserInputService")
 local myzaza = false
 
 UIS.InputBegan:Connect(function(input, GPE)
 if GPE then return end
 myzaza = not myzaza
 end)
 
 local parts = workspace:GetPartBoundsInRadius(player.Character:WaitForChild("HumanoidRootPart").Position, 10)
 for _, part in ipairs(parts) do
 part.CanTouch = myzaza
 end
	 end)
 
	 cmd.add({"unantikillbrick", "unantikb"}, {"unantikillbrick (unantikb)", "Makes it so kill bricks can kill you"}, function()
		 local player = game:GetService("Players").LocalPlayer
		 local UIS = game:GetService("UserInputService")
		 local myzaza = true
		 
		 UIS.InputBegan:Connect(function(input, GPE)
		 if GPE then return end
		 myzaza = not myzaza
		 end)
		 
		 local parts = workspace:GetPartBoundsInRadius(player.Character:WaitForChild("HumanoidRootPart").Position, 10)
		 for _, part in ipairs(parts) do
		 part.CanTouch = myzaza
		 end
			 end)
 
 
 cmd.add({"height", "hipheight", "hh"}, {"height <number> (hipheight, hh)", "Changes your hipheight"}, function(...)
	 game.Players.LocalPlayer.Character.Humanoid.HipHeight = (...)
 end) 

 cmd.add({"netbypass", "netb"}, {"netbypass (netb)", "Net bypass"}, function()
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Netbypass enabled";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
	 });
	 local fenv = getfenv()
	 local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.sethiddenprop or fenv.set_hidden_prop
	 local ssr = fenv.setsimulationradius or fenv.setsimradius or fenv.set_simulation_radius
	 
		 net = shp and function(Radius) 
				 shp(lp, "SimulationRadius", Radius) 
			 end
			 net = net or ssr
 end)
 
 cmd.add({"day"}, {"day", "Makes it day"}, function()
 game:GetService("Lighting").ClockTime = "12"
 end)
 
 cmd.add({"night"}, {"night", "Makes it night"}, function()
 game:GetService("Lighting").ClockTime = "24"
 end)
 
 cmd.add({"night"}, {"night", "Makes it night"}, function()
 game:GetService("Lighting").ClockTime = "24"
 end)
 
 cmd.add({"antichatlogger", "acl"}, {"antichatlogger (acl)", "Anti chat logger"}, function()
 -- Gui to Lua
 -- Version: 3.2
 
 -- Instances:
 
 local ScreenGui = Instance.new("ScreenGui")
 local Frame = Instance.new("Frame")
 local UICorner = Instance.new("UICorner")
 local UIGradient = Instance.new("UIGradient")
 local TextLabel = Instance.new("TextLabel")
 local UICorner_2 = Instance.new("UICorner")
 local TextLabel_2 = Instance.new("TextLabel")
 local UICorner_3 = Instance.new("UICorner")
 local TextButton = Instance.new("TextButton")
 local UICorner_4 = Instance.new("UICorner")
 local TextButton_2 = Instance.new("TextButton")
 local UICorner_5 = Instance.new("UICorner")
 
 --Properties:
 
 ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
 ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 
 Frame.Parent = ScreenGui
 Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 Frame.BackgroundTransparency = 0.120
 Frame.Position = UDim2.new(0.354000002, 0, 0.316000015, 0)
 Frame.Size = UDim2.new(0, 445, 0, 252)
 
 UICorner.Parent = Frame
 
 UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.49, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
 UIGradient.Parent = Frame
 
 TextLabel.Parent = Frame
 TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 TextLabel.BackgroundTransparency = 0.600
 TextLabel.Position = UDim2.new(0.00224719103, 0, 0, 0)
 TextLabel.Size = UDim2.new(0, 443, 0, 27)
 TextLabel.Font = Enum.Font.SourceSans
 TextLabel.Text = "Warning"
 TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
 TextLabel.TextScaled = true
 TextLabel.TextSize = 14.000
 TextLabel.TextWrapped = true
 
 UICorner_2.Parent = TextLabel
 
 TextLabel_2.Parent = Frame
 TextLabel_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 TextLabel_2.BackgroundTransparency = 0.600
 TextLabel_2.Position = UDim2.new(0.0269662924, 0, 0.162698418, 0)
 TextLabel_2.Size = UDim2.new(0, 421, 0, 115)
 TextLabel_2.Font = Enum.Font.SourceSans
 TextLabel_2.Text = "You are executing an anti-chat-log script meaning that Nameless Admin wouldnt be able to detect when you have chatted meaning if you are on mobile and use the chat to execute commands it wont work. Are you sure you want to execute this?"
 TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
 TextLabel_2.TextScaled = true
 TextLabel_2.TextSize = 14.000
 TextLabel_2.TextWrapped = true
 
 UICorner_3.Parent = TextLabel_2
 
 TextButton.Parent = Frame
 TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 TextButton.BackgroundTransparency = 0.600
 TextButton.BorderColor3 = Color3.fromRGB(27, 42, 53)
 TextButton.Position = UDim2.new(0.287640452, 0, 0.658730209, 0)
 TextButton.Size = UDim2.new(0, 189, 0, 34)
 TextButton.Font = Enum.Font.SourceSans
 TextButton.Text = "Yes"
 TextButton.TextColor3 = Color3.fromRGB(0, 194, 45)
 TextButton.TextSize = 14.000
 
 UICorner_4.Parent = TextButton
 
 TextButton_2.Parent = Frame
 TextButton_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 TextButton_2.BackgroundTransparency = 0.600
 TextButton_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
 TextButton_2.Position = UDim2.new(0.280898869, 0, 0.821428478, 0)
 TextButton_2.Size = UDim2.new(0, 194, 0, 32)
 TextButton_2.Font = Enum.Font.SourceSans
 TextButton_2.Text = "No"
 TextButton_2.TextColor3 = Color3.fromRGB(203, 0, 0)
 TextButton_2.TextSize = 14.000
 
 UICorner_5.Parent = TextButton_2
 
 -- Scripts:
 
 local function CPNQ_fake_script() -- TextButton.LocalScript 
	 local script = Instance.new('LocalScript', TextButton)
 
	 script.Parent.MouseButton1Click:Connect(function()
		 -- This basically makes roblox unable to log your chat messages sent in-game. Meaning if you get reported for saying something bad, you won't get banned!
		 -- Store in autoexec folder
		 -- Credits: AnthonyIsntHere and ArianBlaack
	 
	 --[[
		 Change-logs:
		 8/22/2022 - Fixed Chat gui glitching on some games such as Prison Life.
		 9/30/2022 - Fixed chat gui glitching AGAIN... (added better checks too)
		 10/10/2022 - Added gethui() function and fix for Synapse v3.
		 11/11/2022 - Idk what happened but it stopped working... I fixed it though.
	 ]]--
	 
		 local ACL_LoadTime = tick()
	 
		 local ChatChanged = false
		 local OldSetting = nil
		 local WhitelistedCoreTypes = {
			 "Chat",
			 "All",
			 Enum.CoreGuiType.Chat,
			 Enum.CoreGuiType.All
		 }
	 
		 local StarterGui = game:GetService("StarterGui")
	 
		 local FixCore = function(x)
			 local CoreHook; CoreHook = hookmetamethod(x, "__namecall", function(self, ...)
				 local Method = getnamecallmethod()
				 local Arguments = {...}
	 
				 if self == x and Method == "SetCoreGuiEnabled" and not checkcaller() then
					 local CoreType = Arguments[1]
					 local Enabled = Arguments[2]
	 
					 if table.find(WhitelistedCoreTypes, CoreType) and not Enabled then
						 if CoreType == ("Chat" or Enum.CoreGuiType.Chat) then
							 OldSetting = Enabled
						 end
						 ChatChanged = true
					 end
				 end
	 
				 return CoreHook(self, ...)
			 end)
	 
			 x.CoreGuiChangedSignal:Connect(function(Type)
				 if table.find(WhitelistedCoreTypes, Type) and ChatChanged then
					 task.wait()
					 if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
						 x:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
					 end
					 wait(1)
					 if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
						 x:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, OldSetting) -- probably defaults to false i am too tired for the making of this lol
					 end
					 ChatChanged = false
				 end
			 end)
		 end
	 
		 if StarterGui then
			 FixCore(StarterGui)
			 if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
				 StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
			 end
		 else
			 local Connection; Connection = game.ChildAdded:Connect(function(x)
				 if x:IsA("StarterGui") then
					 FixCore(x)
					 Connection:Disconnect()
				 end
			 end)
		 end
	 
		 if not game:IsLoaded() then
			 game.Loaded:wait()
		 end
	 
		 local CoreGui = game:GetService("CoreGui")
		 local TweenService = game:GetService("TweenService")
		 local Players = game:GetService("Players")
	 
		 local Player = Players.LocalPlayer
	 
		 local PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui") do
			 if not PlayerGui then
				 repeat task.wait() until Player:FindFirstChildWhichIsA("PlayerGui")
				 PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui")
			 end
		 end
	 
		 local Notify = function(_Title, _Text , Time)
print(_Title)
print(_Text)
print(Time)
		 end
	 
		 local Tween = function(Object, Time, Style, Direction, Property)
			 return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
		 end
	 
		 local ACLWarning = Instance.new("ScreenGui")
		 local Background = Instance.new("Frame")
		 local Top = Instance.new("Frame")
		 local Exit = Instance.new("TextButton")
		 local UICorner = Instance.new("UICorner")
		 local WarningLbl = Instance.new("TextLabel")
		 local Loading = Instance.new("Frame")
		 local Bar = Instance.new("Frame")
		 local WarningBackground = Instance.new("Frame")
		 local WarningFrame = Instance.new("Frame")
		 local Despair = Instance.new("TextLabel")
		 local UIListLayout = Instance.new("UIListLayout")
		 local Reason_1 = Instance.new("TextLabel")
		 local Reason_2 = Instance.new("TextLabel")
		 local Trollge = Instance.new("ImageLabel")
		 local UIPadding = Instance.new("UIPadding")
	 
		 local MakeGuiThread = coroutine.wrap(function()
			 if syn then
				 if gethui then
					 gethui(ACLwarning)
				 else
					 syn.protect_gui(ACLWarning)
				 end
			 end
	 
			 ACLWarning.Name = "ACL Warning"
			 ACLWarning.Parent = CoreGui
			 ACLWarning.Enabled = false
			 ACLWarning.DisplayOrder = -2147483648
	 
			 Background.Name = "Background"
			 Background.Parent = ACLWarning
			 Background.AnchorPoint = Vector2.new(0.5, 0.5)
			 Background.BackgroundColor3 = Color3.fromRGB(21, 0, 0)
			 Background.BorderSizePixel = 0
			 Background.Position = UDim2.new(0.5, 0, 0.5, 0)
			 Background.Size = UDim2.new(0.300000012, 0, 0.5, 0)
	 
			 Top.Name = "Top"
			 Top.Parent = Background
			 Top.AnchorPoint = Vector2.new(0.5, 0.5)
			 Top.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			 Top.BorderSizePixel = 0
			 Top.Position = UDim2.new(0.5, 0, 0.100000001, 0)
			 Top.Size = UDim2.new(0.899999976, 0, 0.100000001, 0)
	 
			 Exit.Name = "Exit"
			 Exit.Parent = Top
			 Exit.AnchorPoint = Vector2.new(0.5, 0.5)
			 Exit.BackgroundColor3 = Color3.fromRGB(38, 0, 0)
			 Exit.Position = UDim2.new(0.949999988, 0, 0.5, 0)
			 Exit.Size = UDim2.new(0.100000001, -6, 1, -9)
			 Exit.Visible = false
			 Exit.Font = Enum.Font.Arcade
			 Exit.Text = "X"
			 Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
			 Exit.TextScaled = true
			 Exit.TextSize = 14.000
			 Exit.TextWrapped = true
	 
			 UICorner.CornerRadius = UDim.new(0.200000003, 0)
			 UICorner.Parent = Exit
	 
			 WarningLbl.Name = "WarningLbl"
			 WarningLbl.Parent = Top
			 WarningLbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			 WarningLbl.BackgroundTransparency = 1.000
			 WarningLbl.Position = UDim2.new(0, 17, 0, 0)
			 WarningLbl.Size = UDim2.new(0.5, 0, 1, 0)
			 WarningLbl.Font = Enum.Font.Arcade
			 WarningLbl.Text = "Warning!"
			 WarningLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			 WarningLbl.TextScaled = true
			 WarningLbl.TextSize = 14.000
			 WarningLbl.TextWrapped = true
			 WarningLbl.TextXAlignment = Enum.TextXAlignment.Left
	 
			 Loading.Name = "Loading"
			 Loading.Parent = Top
			 Loading.AnchorPoint = Vector2.new(0.5, 0.5)
			 Loading.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			 Loading.BorderSizePixel = 0
			 Loading.Position = UDim2.new(0.699999988, 0, 0.5, 0)
			 Loading.Size = UDim2.new(0.349999994, 0, 0.0199999996, 0)
	 
			 Bar.Name = "Bar"
			 Bar.Parent = Loading
			 Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			 Bar.BorderSizePixel = 0
			 Bar.Size = UDim2.new(0, 0, 1, 0)
	 
			 WarningBackground.Name = "WarningBackground"
			 WarningBackground.Parent = Background
			 WarningBackground.AnchorPoint = Vector2.new(0.5, 0.5)
			 WarningBackground.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
			 WarningBackground.BorderSizePixel = 0
			 WarningBackground.Position = UDim2.new(0.5, 0, 0.550000012, 0)
			 WarningBackground.Size = UDim2.new(0.899999976, 0, 0.800000012, 0)
	 
			 WarningFrame.Name = "WarningFrame"
			 WarningFrame.Parent = WarningBackground
			 WarningFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			 WarningFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			 WarningFrame.BorderSizePixel = 0
			 WarningFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			 WarningFrame.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
	 
			 Despair.Name = "Despair"
			 Despair.Parent = WarningFrame
			 Despair.AnchorPoint = Vector2.new(0.5, 0.5)
			 Despair.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			 Despair.BackgroundTransparency = 1.000
			 Despair.BorderColor3 = Color3.fromRGB(27, 42, 53)
			 Despair.BorderSizePixel = 0
			 Despair.Position = UDim2.new(0.5, 0, 0.100000001, 0)
			 Despair.Size = UDim2.new(0.949999988, 0, 0.119999997, 0)
			 Despair.Font = Enum.Font.Oswald
			 Despair.Text = "Anti Chat Logger will not work here!"
			 Despair.TextColor3 = Color3.fromRGB(255, 255, 255)
			 Despair.TextScaled = true
			 Despair.TextSize = 50.000
			 Despair.TextWrapped = true
			 Despair.TextYAlignment = Enum.TextYAlignment.Top
	 
			 UIListLayout.Parent = WarningFrame
			 UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			 UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			 UIListLayout.Padding = UDim.new(0, 15)
	 
			 Reason_1.Name = "Reason_1"
			 Reason_1.Parent = WarningFrame
			 Reason_1.AnchorPoint = Vector2.new(0.5, 0.5)
			 Reason_1.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			 Reason_1.BackgroundTransparency = 1.000
			 Reason_1.BorderColor3 = Color3.fromRGB(27, 42, 53)
			 Reason_1.BorderSizePixel = 0
			 Reason_1.Position = UDim2.new(0.5, 0, 0.100000001, 0)
			 Reason_1.Size = UDim2.new(0.949999988, 0, 0.100000001, 0)
			 Reason_1.Visible = false
			 Reason_1.Font = Enum.Font.Oswald
			 Reason_1.Text = "-Chat Module was not found."
			 Reason_1.TextColor3 = Color3.fromRGB(255, 0, 0)
			 Reason_1.TextScaled = true
			 Reason_1.TextSize = 50.000
			 Reason_1.TextWrapped = true
			 Reason_1.TextYAlignment = Enum.TextYAlignment.Top
	 
			 Reason_2.Name = "Reason_2"
			 Reason_2.Parent = WarningFrame
			 Reason_2.AnchorPoint = Vector2.new(0.5, 0.5)
			 Reason_2.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			 Reason_2.BackgroundTransparency = 1.000
			 Reason_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
			 Reason_2.BorderSizePixel = 0
			 Reason_2.Position = UDim2.new(0.5, 0, 0.100000001, 0)
			 Reason_2.Size = UDim2.new(0.949999988, 0, 0.100000001, 0)
			 Reason_2.Visible = false
			 Reason_2.Font = Enum.Font.Oswald
			 Reason_2.Text = "-MessagePosted function is invalid."
			 Reason_2.TextColor3 = Color3.fromRGB(255, 0, 0)
			 Reason_2.TextScaled = true
			 Reason_2.TextSize = 50.000
			 Reason_2.TextWrapped = true
			 Reason_2.TextYAlignment = Enum.TextYAlignment.Top
	 
			 Trollge.Name = "Trollge"
			 Trollge.Parent = WarningFrame
			 Trollge.AnchorPoint = Vector2.new(0.5, 0.5)
			 Trollge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			 Trollge.BackgroundTransparency = 1.000
			 Trollge.Position = UDim2.new(0.5, 0, 0.670000017, 0)
			 Trollge.Size = UDim2.new(0.449999988, 0, 0.5, 0)
			 Trollge.Image = "rbxassetid://10104834800"
	 
			 UIPadding.Parent = WarningFrame
			 UIPadding.PaddingTop = UDim.new(0, 10)
	 
			 Exit.MouseButton1Click:Connect(function()
				 local UpTween = Tween(Background, .2, "Quint", "Out", {Position = UDim2.new(0.5, 0, 0.45, 0)})
				 local DownTween = Tween(Background, 1, "Quad", "Out", {Position = UDim2.new(0.5, 0, 2, 0)})
				 UpTween:Play()
				 UpTween.Completed:wait()
				 DownTween:Play()
				 DownTween.Completed:wait()
				 ACLWarning:Destroy()
			 end)
		 end)()
	 
		 local ExitCooldown = function()
			 wait(.5)
			 local Tween = Tween(Bar, 3, "Quad", "InOut", {Size = UDim2.new(1, 0, 1, 0)})
			 Tween:Play()
			 Tween.Completed:wait()
			 Loading:Destroy()
			 Exit.Visible = true
		 end
	 
		 local PlayerScripts = Player:WaitForChild("PlayerScripts")
		 local ChatMain = PlayerScripts:FindFirstChild("ChatMain", true) or false
	 
		 if not ChatMain then
			 local Timer = tick()
			 repeat
				 task.wait()
			 until PlayerScripts:FindFirstChild("ChatMain", true) or tick() > (Timer + 3)
			 ChatMain = PlayerScripts:FindFirstChild("ChatMain", true)
			 if not ChatMain then
				 ACLWarning.Enabled = true
				 Reason_1.Visible = true
				 ExitCooldown()
				 return
			 end
		 end
	 
		 local PostMessage = require(ChatMain).MessagePosted
	 
		 if not PostMessage then
			 ACLWarning.Enabled = true
			 Reason_2.Visible = true
			 ExitCooldown()
			 return
		 end
	 
		 local MessageEvent = Instance.new("BindableEvent")
		 local OldFunctionHook
		 OldFunctionHook = hookfunction(PostMessage.fire, function(self, Message)
			 if not checkcaller() and self == PostMessage then
				 MessageEvent:Fire(Message)
				 return
			 end
			 return OldFunctionHook(self, Message)
		 end)
	 
		 if setfflag then
			 setfflag("AbuseReportScreenshot", "False")
			 setfflag("AbuseReportScreenshotPercentage", "0")
		 end
	 
		 ChatFixToggle = false
		 task.spawn(function()
			 wait(1)
			 ACLWarning:Destroy()
		 end)
		 if OldSetting then
			 StarterGui:SetCoreGuiEnabled(CoreGuiSettings[1], CoreGuiSettings[2])
		 end
		 Notify("🔹Anthony's ACL🔹", "Anti Chat and Screenshot Logger Loaded!", 15)
		 print(string.format("Anti Chat-Logger has loaded in %s seconds.", tostring(tick() - ACL_LoadTime):sub(1, 4)))
		 wait(0.3)
		 script.Parent.Parent:TweenPosition(UDim2.new(0.355, 0,1.291, 0), "Out", "Quint",1,true)
		 wait(0.9)
		 Notify({
			 Description = "Anti chat log has been ran.";
			 Duration = 5;
	 
		 });
	 end)
 end
 coroutine.wrap(CPNQ_fake_script)()
 local function OZEERJ_fake_script() -- TextButton_2.LocalScript 
	 local script = Instance.new('LocalScript', TextButton_2)
 
	 script.Parent.MouseButton1Click:Connect(function()
	 script.Parent.Parent:TweenPosition(UDim2.new(0.355, 0,1.291, 0), "Out", "Quint",1,true)
	 wait(0.9)
		 script.Parent.Parent.Parent:Destroy()
		 end)
 end
 coroutine.wrap(OZEERJ_fake_script)()
 local function ELJBIKO_fake_script() -- Frame.LocalScript 
	 local script = Instance.new('LocalScript', Frame)
 
	 script.Parent.Position = UDim2.new(0.355, 0,-1.291, 0)
	 
	 script.Parent:TweenPosition(UDim2.new(0.354, 0,0.316, 0), "Out", "Quint",1,true)
	 
	 
 end
 coroutine.wrap(ELJBIKO_fake_script)()
 end)
 
 cmd.add({"chat", "message"}, {"chat <text> (message)", "Chats you, useful if youre muted"}, function(...)
	local A_1 = (...)
	local A_2 = "All"
	if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
		game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(A_1)
		else
  game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(A_1,A_2)
	 end
 end)
 
 cmd.add({"fixcam", "fix"}, {"fixcam", "Fix your camera"}, function()
	 local workspace = game.Workspace
 Players = game:GetService("Players")
 local speaker = Players.LocalPlayer
 workspace.CurrentCamera:remove()
	 wait(.1)
	 workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA('Humanoid')
	 workspace.CurrentCamera.CameraType = "Custom"
	 speaker.CameraMinZoomDistance = 0.5
	 speaker.CameraMaxZoomDistance = 400
	 speaker.CameraMode = "Classic"
	 speaker.Character.Head.Anchored = false
 end)
 
 cmd.add({"fling2"}, {"fling2 <player>", "Fling the given player 2"}, function(...)
 Target = (...)
 flinghh = 1000
 
 target = getPlr(Target)
 game.Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
 
 
 local lp = game.Players.LocalPlayer
 for i,v in pairs(game.Players:GetPlayers()) do
	 if v.Name:lower():match("^"..Target:lower()) or v.DisplayName:lower():match("^"..Target:lower()) then
		 Target = v
		 break
	 end
 end
 
 if type(Target) == "string" then return end
 
 local oldpos = lp.Character.HumanoidRootPart.CFrame
 local oldhh = lp.Character.Humanoid.HipHeight
 
 local carpetAnim = Instance.new("Animation")
 carpetAnim.AnimationId = "rbxassetid://282574440"
 carpet = lp.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(carpetAnim)
 carpet:Play(.1, 1, 1)
 
 local carpetLoop
 
 local tTorso = Target.Character:FindFirstChild("Torso") or Target.Character:FindFirstChild("LowerTorso") or Target.Character:FindFirstChild("HumanoidRootPart")
 
 spawn(function()
	 carpetLoop = game:GetService('RunService').Heartbeat:Connect(function()
		 pcall(function()
			 if tTorso.Velocity.magnitude <= 28 then -- if target uses netless just target their local position
				 local pos = {x=0, y=0, z=0}
				 pos.x = tTorso.Position.X
				 pos.y = tTorso.Position.Y
				 pos.z = tTorso.Position.Z
				 pos.x = pos.x + tTorso.Velocity.X / 2
				 pos.y = pos.y + tTorso.Velocity.Y / 2
				 pos.z = pos.z + tTorso.Velocity.Z / 2
				 lp.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z))
			 else
				 lp.Character.HumanoidRootPart.CFrame = tTorso.CFrame
			 end
		 end)
	 end)
 end)
 
 wait()
 
 lp.Character.Humanoid.HipHeight = flinghh
 
 wait(.5)
 
 carpetLoop:Disconnect()
 game.Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
 wait(1)
 lp.Character.Humanoid.Health = 0
 wait(game.Players.RespawnTime + .6)
 lp.Character.HumanoidRootPart.CFrame = oldpos
 end)
 
 cmd.add({"toolfling", "push"}, {"toolfling (push)", "Tool fling"}, function(plr)
		 wait();
	 
	 Notify({
	 Description = "Equip one of your tools.";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
	Tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
			 if not Tool then
				 repeat
					 task.wait()
					 Tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
				 until Tool
			 end
			 Tool.Handle.Massless = true
			 Tool.GripPos = Vector3.new(0, -10000, 0)
 end)
 
 cmd.add({"lfling"}, {"lfling <player>", "Fling the given player using leg resize"}, function(plr)
 local Character = game.Players.LocalPlayer.Character
 
 local Hum = {
	 "BodyTypeScale",
	 "BodyProportionScale",
	 "BodyWidthScale",
	 "BodyHeightScale",
	 "BodyDepthScale",
	 "HeadScale"
 }
 
 function Remove()
	 repeat wait() until Character.LeftFoot:FindFirstChild("OriginalSize")
	 Character.LeftFoot.OriginalSize:Destroy()
	 Character.LeftLowerLeg.OriginalSize:Destroy()
	 Character.LeftUpperLeg.OriginalSize:Destroy()
	  Character.RightFoot.OriginalSize:Destroy()
	 Character.RightLowerLeg.OriginalSize:Destroy()
	 Character.RightUpperLeg.OriginalSize:Destroy()
 end
 
 Character.LeftLowerLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
 Character.LeftUpperLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
 Character.LeftLowerLeg.LeftKneeRigAttachment:Destroy()
 Character.LeftUpperLeg.LeftKneeRigAttachment:Destroy()
 for i=1,2 do
	 Remove()
	 Character.Humanoid[Hum[i]]:Destroy()
 end
 wait(0.2)
 local player = game.Players.LocalPlayer
 local mouse = player:GetMouse()
 local Targets = {plr}
 
 local Players = game:GetService("Players")
 local Player = Players.LocalPlayer
 
 local AllBool = false
 
 local GetPlayer = function(Name)
	Name = Name:lower()
	if Name == "all" or Name == "others" then
		AllBool = true
		return
	elseif Name == "random" then
		local GetPlayers = Players:GetPlayers()
		if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
		return GetPlayers[math.random(#GetPlayers)]
	elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
		for _,x in next, Players:GetPlayers() do
			if x ~= Player then
				if x.Name:lower():match("^"..Name) then
					return x;
				elseif x.DisplayName:lower():match("^"..Name) then
					return x;
				end
			end
		end
	else
		return
	end
 end
 
 local Message = function(_Title, _Text, Time)
	print(_Title)
	print(_Text)
	print(Time)
 end
 
 local SkidFling = function(TargetPlayer)
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart
 
	local TCharacter = TargetPlayer.Character
	local THumanoid
	local TRootPart
	local THead
	local Accessory
	local Handle
 
	if TCharacter:FindFirstChildOfClass("Humanoid") then
		THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
	end
	if THumanoid and THumanoid.RootPart then
		TRootPart = THumanoid.RootPart
	end
	if TCharacter:FindFirstChild("Head") then
		THead = TCharacter.Head
	end
	if TCharacter:FindFirstChildOfClass("Accessory") then
		Accessory = TCharacter:FindFirstChildOfClass("Accessory")
	end
	if Accessoy and Accessory:FindFirstChild("Handle") then
		Handle = Accessory.Handle
	end
 
	if Character and Humanoid and RootPart then
		if RootPart.Velocity.Magnitude < 50 then
			getgenv().OldPos = RootPart.CFrame
		end
		if THumanoid and THumanoid.Sit and not AllBool then
		end
		if THead then
			workspace.CurrentCamera.CameraSubject = THead
		elseif not THead and Handle then
			workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid and TRootPart then
			workspace.CurrentCamera.CameraSubject = THumanoid
		end
		if not TCharacter:FindFirstChildWhichIsA("BasePart") then
			return
		end
		
		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end
		
		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0
 
			repeat
				if RootPart and THumanoid then
					if BasePart.Velocity.Magnitude < 50 then
						Angle = Angle + 100
 
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						
						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				else
					break
				end
			until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end
		
		workspace.FallenPartsDestroyHeight = 0/0
		
		local BV = Instance.new("BodyVelocity")
		BV.Name = "EpixVel"
		BV.Parent = RootPart
		BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
		BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
		
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		
		if TRootPart and THead then
			if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
				SFBasePart(THead)
			else
				SFBasePart(TRootPart)
			end
		elseif TRootPart and not THead then
			SFBasePart(TRootPart)
		elseif not TRootPart and THead then
			SFBasePart(THead)
		elseif not TRootPart and not THead and Accessory and Handle then
			SFBasePart(Handle)
		else
		end
		
		BV:Destroy()
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid
		
		repeat
			RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
			Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
			Humanoid:ChangeState("GettingUp")
			table.foreach(Character:GetChildren(), function(_, x)
				if x:IsA("BasePart") then
					x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
				end
			end)
			task.wait()
		until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
		workspace.FallenPartsDestroyHeight = getgenv().FPDH
	else
	end
 end
 
 getgenv().Welcome = true
 if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
 
 if AllBool then
	for _,x in next, Players:GetPlayers() do
		SkidFling(x)
	end
 end
 
 for _,x in next, Targets do
	if GetPlayer(x) and GetPlayer(x) ~= Player then
		if GetPlayer(x).UserId ~= 1414978355 then
			local TPlayer = GetPlayer(x)
			if TPlayer then
				SkidFling(TPlayer)
			end
		else
		end
	elseif not GetPlayer(x) and not AllBool then
	end
 end
 respawn()
 end)
 
 cmd.add({"fling"}, {"fling <player>", "Fling the given player"}, function(plr)
 local player = game.Players.LocalPlayer
 local mouse = player:GetMouse()
 local Targets = {plr}
 
 local Players = game:GetService("Players")
 local Player = Players.LocalPlayer
 
 local AllBool = false
 
 local GetPlayer = function(Name)
	Name = Name:lower()
	if Name == "all" or Name == "others" then
		AllBool = true
		return
	elseif Name == "random" then
		local GetPlayers = Players:GetPlayers()
		if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
		return GetPlayers[math.random(#GetPlayers)]
	elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
		for _,x in next, Players:GetPlayers() do
			if x ~= Player then
				if x.Name:lower():match("^"..Name) then
					return x;
				elseif x.DisplayName:lower():match("^"..Name) then
					return x;
				end
			end
		end
	else
		return
	end
 end
 
 local Message = function(_Title, _Text, Time)
	print(_Title)
	print(_Text)
	print(Time)
end
 
 local SkidFling = function(TargetPlayer)
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart
 
	local TCharacter = TargetPlayer.Character
	local THumanoid
	local TRootPart
	local THead
	local Accessory
	local Handle
 
	if TCharacter:FindFirstChildOfClass("Humanoid") then
		THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
	end
	if THumanoid and THumanoid.RootPart then
		TRootPart = THumanoid.RootPart
	end
	if TCharacter:FindFirstChild("Head") then
		THead = TCharacter.Head
	end
	if TCharacter:FindFirstChildOfClass("Accessory") then
		Accessory = TCharacter:FindFirstChildOfClass("Accessory")
	end
	if Accessoy and Accessory:FindFirstChild("Handle") then
		Handle = Accessory.Handle
	end
 
	if Character and Humanoid and RootPart then
		if RootPart.Velocity.Magnitude < 50 then
			getgenv().OldPos = RootPart.CFrame
		end
		if THumanoid and THumanoid.Sit and not AllBool then
		end
		if THead then
			workspace.CurrentCamera.CameraSubject = THead
		elseif not THead and Handle then
			workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid and TRootPart then
			workspace.CurrentCamera.CameraSubject = THumanoid
		end
		if not TCharacter:FindFirstChildWhichIsA("BasePart") then
			return
		end
		
		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end
		
		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0
 
			repeat
				if RootPart and THumanoid then
					if BasePart.Velocity.Magnitude < 50 then
						Angle = Angle + 100
 
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						
						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				else
					break
				end
			until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end
		
		workspace.FallenPartsDestroyHeight = 0/0
		
		local BV = Instance.new("BodyVelocity")
		BV.Name = "EpixVel"
		BV.Parent = RootPart
		BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
		BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
		
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		
		if TRootPart and THead then
			if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
				SFBasePart(THead)
			else
				SFBasePart(TRootPart)
			end
		elseif TRootPart and not THead then
			SFBasePart(TRootPart)
		elseif not TRootPart and THead then
			SFBasePart(THead)
		elseif not TRootPart and not THead and Accessory and Handle then
			SFBasePart(Handle)
		else
		end
		
		BV:Destroy()
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid
		
		repeat
			RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
			Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
			Humanoid:ChangeState("GettingUp")
			table.foreach(Character:GetChildren(), function(_, x)
				if x:IsA("BasePart") then
					x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
				end
			end)
			task.wait()
		until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
		workspace.FallenPartsDestroyHeight = getgenv().FPDH
	else
	end
 end
 
 getgenv().Welcome = true
 if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
 
 if AllBool then
	for _,x in next, Players:GetPlayers() do
		SkidFling(x)
	end
 end
 
 for _,x in next, Targets do
	if GetPlayer(x) and GetPlayer(x) ~= Player then
		if GetPlayer(x).UserId ~= 1414978355 then
			local TPlayer = GetPlayer(x)
			if TPlayer then
				SkidFling(TPlayer)
			end
		else
		end
	elseif not GetPlayer(x) and not AllBool then
	end
 end
 end)

 
 cmd.add({"commitoof", "suicide", "kys"}, {"commitoof (suicide, kys)", "FE KILL YOURSELF SCRIPT this will be bad when taken out of context"}, function()
	 local A_1 = "Okay.. i will do it."
		 local A_2 = "All"
		 local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
		 Event:FireServer(A_1, A_2)
		 wait(1)
		 local A_1 = "I will oof"
		 local A_2 = "All"
		 local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
		 Event:FireServer(A_1, A_2)
		 wait(1)
		 local A_1 = "Goodbye."
		 local A_2 = "All"
		 local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
		 Event:FireServer(A_1, A_2)
		 wait(1)
		 LocalPlayer = game:GetService("Players").LocalPlayer
		 LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 10)
		 game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		 wait(0.5)
		 game.Players.LocalPlayer.Character.Humanoid.Health = 0
 end)

 cmd.add({"volume", "vol"}, {"volume <1-10> (vol)", "Changes your volume"}, function(vol)
	amount = vol/10
	UserSettings():GetService("UserGameSettings").MasterVolume = amount
 end)

 cmd.add({"sensitivity", "sens"}, {"sensitivity <1-10> (tr)", "Changes your sensitivity"}, function(ss)
	game:GetService("UserInputService").MouseDeltaSensitivity = ss
 end)

 cmd.add({"torandom", "tr"}, {"torandom (tr)", "Teleports to a random player"}, function(...)
target = getPlr("random")
getChar().HumanoidRootPart.CFrame = target.Character.Humanoid.RootPart.CFrame
 end)
 
 cmd.add({"goto", "to", "tp", "teleport"}, {"goto <player/X,Y,Z>", "Teleport to the given player or X,Y,Z coordinates"}, function(...)
	 Username = (...)
 
	 local target = getPlr(Username)
	 getChar().HumanoidRootPart.CFrame = target.Character.Humanoid.RootPart.CFrame
 end)
 Stare = false
 cmd.add({"lookat", "stare"}, {"stare <player> (lookat)", "Stare at a player"}, function(...)
	 Username = (...)
	 local Target = getPlr(Username)
	 if Staring then
		 Staring:Disconnect()
	 end
	 if not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Target.Character:FindFirstChild("HumanoidRootPart") then return end
	 local function Stare()
		 if Players.LocalPlayer.Character.PrimaryPart and Players:FindFirstChild(Target.Name) and Target.Character ~= nil and Target.Character:FindFirstChild("HumanoidRootPart") then
			 local CharPos = Players.LocalPlayer.Character.PrimaryPart.Position
			 local tpos = Target.Character:FindFirstChild("HumanoidRootPart").Position
			 local TPos = Vector3.new(tpos.X,CharPos.Y,tpos.Z)
			 local NewCFrame = CFrame.new(CharPos,TPos)
			 Players.LocalPlayer.Character:SetPrimaryPartCFrame(NewCFrame)
		 elseif not Players:FindFirstChild(Target.Name) then
			 Staring:Disconnect()
		 end
	 end
 
	 Staring = game:GetService("RunService").RenderStepped:Connect(Stare)
 end)
 
 cmd.add({"unlookat", "unstare"}, {"unstare (unlookat)", "Stops staring"}, function()
	 Staring:Disconnect()
 end)
 
 cmd.add({"watch", "view", "specate"}, {"view <player>", "Watch the given player"}, function(...)
 game.Workspace.CurrentCamera.CameraSubject = character:FindFirstChildWhichIsA("Humanoid")
	 view = false
 wait(0.3)
	 view = true
 Username = (...)
 
 local target = getPlr(Username)
 repeat wait()
 workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
 until view == false
 end)
 
 cmd.add({"unwatch", "unview", "unspectate"}, {"unview", "Stop watching a player"}, function()
 local character = game.Players.LocalPlayer.Character
 view = false
 wait(0.3)
 game.Workspace.CurrentCamera.CameraSubject = character:FindFirstChildWhichIsA("Humanoid")
 end)
 
 cmd.add({"pp", "penis"}, {"penis (pp)", "benis :flushed:"}, function()
    ----------[ Variables ]----------
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local localCharacter = localPlayer.Character
    local localHumanoid = localCharacter.Humanoid
    local root = localHumanoid.RootPart

    local runService = game:GetService("RunService")
    local starterGui = game:GetService("StarterGui")
    local heartBeat = runService.Heartbeat
    -----------------------------------

    ----------[ Settings ]----------
    _G.settings = {
        speed = 0.25,
        mode = 1,
        player = localPlayer.Name,
        customBodyPartPos = false
    }
    ----------------------------------

    ----------[ Custom ]----------
    _G.customPositions = {
        leftArm = Vector3.new(-0.5, 0, -0.75),
        rightArm = Vector3.new(0.5, 0, -0.75),
        leftLeg = Vector3.new(0, 0, 0),
        rightLeg = Vector3.new(0, 0, 0),
        torso = Vector3.new(0, 0, 0),
        head = Vector3.new(0, 0, 0)
    }

    _G.customOrientations = {
        leftArm = Vector3.new(45, 0, -30),
        rightArm = Vector3.new(45, 0, 30),
        leftLeg = Vector3.new(0, 0, 0),
        rightLeg = Vector3.new(0, 0, 0),
        torso = Vector3.new(0, 0, 0),
        head = Vector3.new(0, 0, 0)
    }
    ------------------------------

    ----------[ Base ]----------
    local basePositions = {
        leftArm = Vector3.new(1.5, 0, 0),
        rightArm = Vector3.new(-1.5, 0, 0),
        leftLeg = Vector3.new(0.5, -2, 0),
        rightLeg = Vector3.new(-0.5, -2, 0),
        torso = Vector3.new(0, 0, 0),
        head = Vector3.new(0, 1, 0)
    }

    local baseOrientations = {
        leftArm = Vector3.new(0, 0, 0),
        rightArm = Vector3.new(0, 0, 0),
        leftLeg = Vector3.new(0, 0, 0),
        rightLeg = Vector3.new(0, 0, 0),
        torso = Vector3.new(0, 0, 0),
        head = Vector3.new(0, 0, 0)
    }
    ----------------------------

    local hatAttachments = {}
    local bodyPartPosConnection
    local hatConnection

    local function startMain()
        ----------[ Main function ]----------

        ----------[ Netless ]----------
        local netlessConnection
        for i, v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                netlessConnection = game:GetService("RunService").Heartbeat:connect(function()
                    v.Velocity = Vector3.new(-30, 0, 0)
                    v.Massless = true
                end)
            end
        end
        ---------------------------------

        if not players:FindFirstChild(_G.settings.player) or not players:FindFirstChild(_G.settings.player).Character then
            _G.settings.player = localplayer
        end
        localCharacter = localPlayer.Character
        localHumanoid = localCharacter.Humanoid
        root = localHumanoid.RootPart
        task.spawn(function()
            for i, v in pairs(localCharacter:GetDescendants()) do
                if v:IsA("SpecialMesh") and v.Parent.Name ~= "Head" then
                    v:Destroy()
                end
            end
        end)

        local parts = {}
        local hatParts = {}
        local bodyParts = {}
        for i, v in pairs(localCharacter:GetDescendants()) do
            if v.Name == "Handle" then
                table.insert(hatParts, v)
                table.insert(parts, v)
            end

            if v.Name == "Left Arm" then
                table.insert(bodyParts, v)
                table.insert(parts, v)
            end
            if v.Name == "Right Arm" then
                table.insert(bodyParts, v)
                table.insert(parts, v)
            end
        end
        -------------------------------------------

        ----------[ Body Part Manipulation ]----------
        --[[ DISABLED DUE TO REJECTCHARACTERDELETIONS
        local bodyAttachments = {};
        local bodyAttachmentsOne = {};
        for i, v in pairs(bodyParts) do
            local attachment1 = Instance.new("Attachment", v);
            -- local attachment2 = Instance.new("Attachment", root);
            local attachment2 = Instance.new("Attachment", players:FindFirstChild(_G.settings.player).Character.Humanoid.RootPart);
            attachment2.Position = Vector3.new(0,-5,0);

            local alignPosition = Instance.new("AlignPosition");
            alignPosition.Parent = v;
            alignPosition.MaxForce = math.huge;
            alignPosition.MaxVelocity = math.huge;
            alignPosition.Responsiveness = math.huge;
            alignPosition.Attachment0 = attachment1;
            alignPosition.Attachment1 = attachment2;

            local alignOrientation = Instance.new("AlignOrientation");
            alignOrientation.Parent = v;
            alignOrientation.MaxAngularVelocity = math.huge;
            alignOrientation.MaxTorque = math.huge;
            alignOrientation.Responsiveness = math.huge;
            alignOrientation.Attachment0 = attachment1;
            alignOrientation.Attachment1 = attachment2;

            bodyAttachmentsOne[i] = attachment1;
            bodyAttachments[i] = attachment2;

            if v.Name == "Left Arm" then
                attachment2.Position = basePositions.leftArm + _G.customPositions.leftArm;
                attachment2.Orientation = baseOrientations.leftArm + _G.customOrientations.leftArm;
            end
            if v.Name == "Right Arm" then
                attachment2.Position = basePositions.rightArm + _G.customPositions.rightArm;
                attachment2.Orientation = baseOrientations.rightArm + _G.customOrientations.rightArm;
            end
            if v.Name == "Left Leg" then
                attachment2.Position = basePositions.leftLeg + _G.customPositions.leftLeg;
                attachment2.Orientation = baseOrientations.leftLeg + _G.customOrientations.leftLeg;
            end
            if v.Name == "Right Leg" then
                attachment2.Position = basePositions.rightLeg + _G.customPositions.rightLeg;
                attachment2.Orientation = baseOrientations.rightLeg + _G.customOrientations.rightLeg;
            end

            bodyPartPosConnection = heartBeat:Connect(function()
                if _G.settings.customBodyPartPos == true then
                    for i, attachment in pairs(bodyAttachmentsOne) do
                        attachment.Position = attachment.Position:Lerp(bodyAttachments[i].Position, _G.settings.speed)
                    end
                else
                    for i, attachment in pairs(bodyAttachmentsOne) do
                        attachment.Position = attachment.Position:Lerp(bodyAttachments[i].Position, 0.01)
                    end
                end
            end)
        end
        -----------------------------------------------]]

        ----------[ Hat Manipulation ]----------
        local attachments = {}
        for i, v in pairs(hatParts) do
            local attachment1 = Instance.new("Attachment", v)
            local attachment2 = Instance.new("Attachment", root)
            attachment2.Position = Vector3.new(0, -5, 0)

            local alignPosition = Instance.new("AlignPosition")
            alignPosition.Parent = v
            alignPosition.MaxForce = math.huge
            alignPosition.MaxVelocity = math.huge
            alignPosition.Responsiveness = math.huge
            alignPosition.Attachment0 = attachment1
            alignPosition.Attachment1 = attachment2

            local alignOrientation = Instance.new("AlignOrientation")
            alignOrientation.Parent = v
            alignOrientation.MaxAngularVelocity = math.huge
            alignOrientation.MaxTorque = math.huge
            alignOrientation.Responsiveness = math.huge
            alignOrientation.Attachment0 = attachment1
            alignOrientation.Attachment1 = attachment2

            attachments[i] = {attachment1, attachment2}

            hatConnection = heartBeat:Connect(function()
                if _G.settings.mode == 1 then
                    attachment2.Position = basePositions.head
                    attachment2.Orientation = baseOrientations.head
                elseif _G.settings.mode == 2 then
                    attachment2.Position = basePositions.head + Vector3.new(math.sin(tick() * 5) * 5, 0, 0)
                    attachment2.Orientation = baseOrientations.head
                elseif _G.settings.mode == 3 then
                    attachment2.Position = basePositions.head + Vector3.new(0, math.sin(tick() * 5) * 5, 0)
                    attachment2.Orientation = baseOrientations.head
                end
            end)
        end
        ---------------------------------------

        ----------[ Settings ]----------
        local settingsGui = Instance.new("ScreenGui", localPlayer.PlayerGui)
        settingsGui.Name = "SettingsGui"

        local settingsButton = Instance.new("TextButton", settingsGui)
        settingsButton.Position = UDim2.new(0, 0, 0, 0)
        settingsButton.Size = UDim2.new(0, 100, 0, 50)
        settingsButton.Text = "Settings"
        settingsButton.MouseButton1Click:Connect(function()
            local settingsFrame = Instance.new("Frame", settingsGui)
            settingsFrame.Position = UDim2.new(0, 0, 0, 0)
            settingsFrame.Size = UDim2.new(0, 200, 0, 150)
            settingsFrame.BackgroundTransparency = 0.5
            settingsFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            settingsFrame.Name = "SettingsFrame"

            local speedLabel = Instance.new("TextLabel", settingsFrame)
            speedLabel.Position = UDim2.new(0, 0, 0, 0)
            speedLabel.Size = UDim2.new(0, 200, 0, 50)
            speedLabel.Text = "Speed"
            speedLabel.TextColor3 = Color3.new(1, 1, 1)

            local speedTextBox = Instance.new("TextBox", settingsFrame)
            speedTextBox.Position = UDim2.new(0, 0, 0, 50)
            speedTextBox.Size = UDim2.new(0, 200, 0, 50)
            speedTextBox.Text = _G.settings.speed
            speedTextBox.FocusLost:Connect(function()
                _G.settings.speed = tonumber(speedTextBox.Text)
            end)

            local modeLabel = Instance.new("TextLabel", settingsFrame)
            modeLabel.Position = UDim2.new(0, 0, 0, 100)
            modeLabel.Size = UDim2.new(0, 200, 0, 50)
            modeLabel.Text = "Mode"
            modeLabel.TextColor3 = Color3.new(1, 1, 1)

            local modeTextBox = Instance.new("TextBox", settingsFrame)
            modeTextBox.Position = UDim2.new(0, 0, 0, 150)
            modeTextBox.Size = UDim2.new(0, 200, 0, 50)
            modeTextBox.Text = _G.settings.mode
            modeTextBox.FocusLost:Connect(function()
                _G.settings.mode = tonumber(modeTextBox.Text)
            end)
        end)
        -------------------------------------
        ---------------------------------------

        ----------[ Disable Gui ]----------
        local disableGui = Instance.new("ScreenGui", localPlayer.PlayerGui)
        disableGui.Name = "DisableGui"

        local disableButton = Instance.new("TextButton", disableGui)
        disableButton.Position = UDim2.new(0, 0, 0, 50)
        disableButton.Size = UDim2.new(0, 100, 0, 50)
        disableButton.Text = "Disable"
        disableButton.MouseButton1Click:Connect(function()
            settingsGui:Destroy()
            disableGui:Destroy()
            for i, v in next, attachments do
                for _, attachment in pairs(v) do
                    attachment:Destroy()
                end
            end
            bodyPartPosConnection:Disconnect()
            hatConnection:Disconnect()
            netlessConnection:Disconnect()
            task.clear()
        end)
        -----------------------------------

        ----------[ Expose Gui ]----------
        local exposeGui = Instance.new("ScreenGui", localPlayer.PlayerGui)
        exposeGui.Name = "ExposeGui"

        local exposeButton = Instance.new("TextButton", exposeGui)
        exposeButton.Position = UDim2.new(0, 0, 0, 100)
        exposeButton.Size = UDim2.new(0, 100, 0, 50)
        exposeButton.Text = "Show Gui"
        exposeButton.MouseButton1Click:Connect(function()
            settingsGui.Parent = localPlayer.PlayerGui
            disableGui.Parent = localPlayer.PlayerGui
            exposeGui:Destroy()
        end)
        -----------------------------------

        settingsButton.MouseButton1Click:Connect(function()
            settingsGui:Destroy()
            disableGui:Destroy()
            exposeGui.Parent = localPlayer.PlayerGui
        end)
        -----------------------------------------

        -------------------------------------

        ----------[ Handle Hat Attachments ]----------
        local function handleHatAttachments()
            local currentAttachments = {}
            for i, v in pairs(hatAttachments) do
                if not v.Parent then
                    table.remove(hatAttachments, i)
                else
                    table.insert(currentAttachments, v)
                end
            end
            return currentAttachments
        end

        local function resetHatAttachments()
            for _, v in pairs(handleHatAttachments()) do
                v.Parent = localPlayer.Character
                v.Position = Vector3.new(0, -5, 0)
            end
        end

        local function removeHatAttachments()
            for _, v in pairs(handleHatAttachments()) do
                v:Destroy()
            end
        end
        ----------------------------------------------

        ----------[ Handle Hat Removal ]----------
        local function handleHatRemoval()
            local function handleDescendants(obj)
                for _, v in pairs(obj:GetDescendants()) do
                    if v:IsA("Hat") and not v.Parent:IsA("Player") then
                        v:Destroy()
                    end
                end
            end

            handleDescendants(localPlayer.Character)
            handleDescendants(workspace)
        end
        --------------------------------------------

        ----------[ Remove Initial Hats ]----------
        wait(2)
        handleHatRemoval()
        wait()
        handleHatRemoval()
        --------------------------------------------

        ----------[ Remove Hats On Player Join ]----------
        local function onPlayerJoin(player)
            player.CharacterAdded:Connect(function()
                wait(2)
                handleHatRemoval()
                wait()
                handleHatRemoval()
            end)
        end

        game.Players.PlayerAdded:Connect(onPlayerJoin)
        ----------------------------------------------

        ----------[ Handle Hat Movement ]----------
        local function handleHatMovement()
            local function createHatAttachments()
                hatAttachments = {}
                for _, v in pairs(localPlayer.Character:GetDescendants()) do
                    if v:IsA("Accessory") then
                        local attachment = Instance.new("Attachment", v)
                        table.insert(hatAttachments, attachment)
                    end
                end
            end

            local function resetHatPositions()
                for _, v in pairs(hatAttachments) do
                    v.Position = Vector3.new(0, -5, 0)
                end
            end

            local function moveHats()
                for _, v in pairs(hatAttachments) do
                    v.Position = v.Position + Vector3.new(0, -5, 0)
                end
            end

            createHatAttachments()
            wait(2)
            resetHatPositions()
            moveHats()
            wait()
            resetHatPositions()
            wait(2)
            moveHats()
            wait()
            resetHatPositions()
        end

        handleHatMovement()
        -------------------------------------------

        ----------[ Netless Mode ]----------
        netlessConnection = heartBeat:Connect(function()
            if _G.settings.netless then
                handleHatRemoval()
                resetHatAttachments()
            end
        end)
        -----------------------------------

        -----------------------------------

        ----------[ Disable/Enable ]----------
        local function disableScript()
            settingsButton.Visible = false
            disableButton.Visible = false
            exposeButton.Visible = true
            settingsGui:Destroy()
            disableGui:Destroy()
        end

        local function enableScript()
            settingsButton.Visible = true
            disableButton.Visible = true
            exposeButton.Visible = false
        end
        ----------------------------------------

        disableScript()

        wait(2)
        enableScript()
    end

    if _G.settings.autoexecute then
        script()
    end
end
 
 cmd.add({"stealaudio", "getaudio", "steal", "logaudio"}, {"stealaudio <player> (getaudio, logaudio, steal)", "Save all sounds a player is playing to a file  -Cyrus"}, function(p)
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Audio link has been copied to your clipboard";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 local players = argument.getPlayers(p)
	 local audios = ""
	 for _, player in pairs(players) do
		 local char = player.Character
		 if char then
			 for i, v in pairs(char:GetDescendants()) do
				 if v:IsA("Sound") and v.Playing then
					 audios = audios .. ("%s"):format(v.SoundId)
				 end
			 end
		 end
	 end
 setclipboard(audios)
 end)
 
 cmd.add({"follow", "stalk", "walk"}, {"follow <player>", "Follow a player wherever they go"}, function(p)
	 lib.disconnect("follow")
	 local players = argument.getPlayers(p)
	 local targetPlayer = players[1]
	 lib.connect("follow", RunService.Stepped:Connect(function()
		 local target = targetPlayer.Character
		 if target and character then
			 local hum = character:FindFirstChildWhichIsA("Humanoid")
			 if hum then
				 local targetPart = target:FindFirstChild("Head")
				 local targetPos = targetPart.Position
				 hum:MoveTo(targetPos)
			 end
		 end
	 end))
 end)
 
 cmd.add({"pathfind"}, {"pathfind <player>", "Follow a player using the pathfinder API wherever they go"}, function(p)
	 lib.disconnect("follow")
	 local players = argument.getPlayers(p)
	 local targetPlayer = players[1]
	 local debounce = false
	 lib.connect("follow", RunService.Stepped:Connect(function()
		 if debounce then return end
		 debounce = true
		 local target = targetPlayer.Character
		 if target and character then
			 local hum = character:FindFirstChildWhichIsA("Humanoid")
			 local main = target:FindFirstChild("HumanoidRootPart")
			 if hum then
				 local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
				 local targetPos = (targetPart.CFrame * CFrame.new(0, 0, -0.5)).p
				 local PathService = game:GetService("PathfindingService")
				 local path = PathService:CreatePath({
					 AgentRadius = 2,
					 AgentHeight = 5,
					 AgentCanJump = true
				 })
				 local points = path:ComputeAsync(main.Position, targetPos)
				 
				 if path.Status then
					 local waypoints = path:GetWaypoints()
					 for i, waypoint in pairs(waypoints) do
						 if i > 2 then break end
						 if waypoint.Action == Enum.PathWaypointAction.Jump then
							 hum.Jump = true
						 end
						 hum:MoveTo(waypoint.Position)
						 local distance = 5
						 repeat
							 wait()
							 distance = (waypoint.Position - main.Position).magnitude
						 until
							 (targetPos - targetPart.Position).magnitude > 2 or distance < 1
 
						 if (targetPos - targetPart.Position).magnitude > 2 then
							 break
						 end
					 end
				 end
			 end
		 end
		 debounce = false
	 end))
 end)
 
 cmd.add({"unfollow", "unstalk", "unwalk", "unpathfind"}, {"unfollow", "Stop all attempts to follow a player"}, function()
	 lib.disconnect("follow")
 end)
 
 cmd.add({"bubblechat"}, {"bubblechat <player>", "fake chat as your target"}, function(...)	
	 for i,lplr in pairs(game:GetService("Players"):GetPlayers()) do
		 lplr.Character.Humanoid.DisplayName = lplr.DisplayName.."\n\@"..lplr.Name
		 lplr.Character.Humanoid.NameDisplayDistance = math.huge
		 lplr.CharacterAdded:Connect(function()
			 lplr.Humanoid.Character:WaitForChild("Humanoid").DisplayName = lplr.DisplayName.."\n\@"..lplr.Name
			 lplr.Character.Humanoid.NameDisplayDistance = math.huge
		 end)
	 end
	 
	 game:GetService("Players").PlayerAdded:Connect(function(lplr)
		 repeat
			 wait()
		 until lplr.Character ~= nil
		 lplr.Character:WaitForChild("Humanoid").DisplayName = lplr.DisplayName.."\n\@"..lplr.Name
		 lplr.Character.Humanoid.NameDisplayDistance = math.huge
		 lplr.CharacterAdded:Connect(function()
			 lplr.Character:WaitForChild("Humanoid").DisplayName = lplr.DisplayName.."\n\@"..lplr.Name
			 lplr.Character.Humanoid.NameDisplayDistance = math.huge
		 end)
	 end)
	 
	 players = game:GetService("Players")
	 local_player = players.LocalPlayer
	 character = local_player.Character
	 
	 character.LowerTorso.Root:Destroy()
	 
	 victim = nil
	 
	 
	 Username = (...)
	 Target = getPlr(Username)
					 victim = Target.Character
	 character.HumanoidRootPart.CanCollide = false
	 while task.wait() do
		 if victim ~= nil then
			 character.HumanoidRootPart.CFrame = CFrame.new(victim.Head.CFrame.Position)
		 end
	 end	
 end)
 
 cmd.add({"freeze", "thaw", "anchor"}, {"freeze (thaw, anchor)", "Freezes your character"}, function()
 game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
 end)
 
 cmd.add({"unfreeze", "unthaw", "unanchor"}, {"unfreeze (unthaw, unanchor)", "Unfreezes your character"}, function()
 game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
 end)
 
 cmd.add({"disableanimations", "disableanims"}, {"disableanimations (disableanims)", "Freezes your animations"}, function()
 game.Players.LocalPlayer.Character.Animate.Disabled = true
 end)
 
 cmd.add({"undisableanimations", "undisableanims"}, {"undisableanimations (undisableanims)", "Unfreezes your animations"}, function(...)
 game.Players.LocalPlayer.Character.Animate.Disabled = false
 end)
 
 cmd.add({"headkill", "hkill"}, {"headkill <player> (hkill)", "Need an rthro head"}, function(...)
	 for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetChildren()) do
		 if string.find(v.Name,"Scale") and v.Name ~= "HeadScale" then
			 repeat wait(HeadGrowSpeed) until game.Players.LocalPlayer.Character.Head:FindFirstChild("OriginalSize")
			 game.Players.LocalPlayer.Character.Head.OriginalSize:Destroy()
			 v:Destroy()
			 game.Players.LocalPlayer.Character.Head:WaitForChild("OriginalSize")
		 end
	  end
	  Target = (...)
 
 if Target == "all" or Target == "others" then
	 print("Patched")
 else
 local function Kill()
			 if not getPlr(Target) then
			 end
			 
			 repeat game:FindService("RunService").Heartbeat:wait() until getPlr(Target).Character and getPlr(Target).Character:FindFirstChildOfClass("Humanoid") and getPlr(Target).Character:FindFirstChildOfClass("Humanoid").Health > 0
			 local Character
			 local Humanoid
			 local RootPart
			 local Tool
			 local Handle
			 
			 local TPlayer = getPlr(Target)
			 local TCharacter = TPlayer.Character
			 local THumanoid
			 local TRootPart
			 
			 if Player.Character and Player.Character and Player.Character.Name == Player.Name then
				 Character = Player.Character
			 else
			 end
			 if Character:FindFirstChildOfClass("Humanoid") then
				 Humanoid = Character:FindFirstChildOfClass("Humanoid")
			 else
			 end
			 if Humanoid and Humanoid.RootPart then
				 RootPart = Humanoid.RootPart
			 else
			 end
			 if Character:FindFirstChildOfClass("Tool") then
				 Tool = Character:FindFirstChildOfClass("Tool")
			 elseif Player.Backpack:FindFirstChildOfClass("Tool") and Humanoid then
				 Tool = Player.Backpack:FindFirstChildOfClass("Tool")
				 Humanoid:EquipTool(Player.Backpack:FindFirstChildOfClass("Tool"))
			 else
			 end
			 if Tool and Tool:FindFirstChild("Handle") then
				 Handle = Tool.Handle
			 else
			 end
			 
			 --Target
			 if TCharacter:FindFirstChildOfClass("Humanoid") then
				 THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
			 else
				 return Message("Error",">   Missing Target Humanoid")
			 end
			 if THumanoid.RootPart then
				 TRootPart = THumanoid.RootPart
			 else
				 return Message("Error",">   Missing Target RootPart")
			 end
			 
			 if THumanoid.Sit then
				 return Message("Error",">   Target is seated")
			 end
			 
			 local OldCFrame = RootPart.CFrame
			 
			 Humanoid:Destroy()
			 local NewHumanoid = Humanoid:Clone()
			 NewHumanoid.Parent = Character
			 NewHumanoid:UnequipTools()
			 NewHumanoid:EquipTool(Tool)
			 Tool.Parent = workspace
		 
			 local Timer = os.time()
		 
			 repeat
				 if (TRootPart.CFrame.p - RootPart.CFrame.p).Magnitude < 500 then
					 Tool.Grip = CFrame.new()
					 Tool.Grip = Handle.CFrame:ToObjectSpace(TRootPart.CFrame):Inverse()
				 end
				 firetouchinterest(Handle,TRootPart,0)
				 firetouchinterest(Handle,TRootPart,1)
				 game:FindService("RunService").Heartbeat:wait()
			 until Tool.Parent ~= Character or not TPlayer or not TRootPart or THumanoid.Health <= 0 or os.time() > Timer + .20
			 Player.Character = nil
			 NewHumanoid.Health = 0
			 player.CharacterAdded:wait(1)
			 repeat game:FindService("RunService").Heartbeat:wait() until Player.Character:FindFirstChild("HumanoidRootPart")
			 Player.Character.HumanoidRootPart.CFrame = OldCFrame
 end
	   
		 if not LoopKill then
			 Kill()
		 else
			 while LoopKill do
				 Kill()
			 end
		 end
		  end
 end)
 
 cmd.add({"headbring", "hbring"}, {"headbring <player> (headbring)", "Need an rthro head"}, function(...)
	 for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetChildren()) do
		 if string.find(v.Name,"Scale") and v.Name ~= "HeadScale" then
			 repeat wait(HeadGrowSpeed) until game.Players.LocalPlayer.Character.Head:FindFirstChild("OriginalSize")
			 game.Players.LocalPlayer.Character.Head.OriginalSize:Destroy()
			 v:Destroy()
			 game.Players.LocalPlayer.Character.Head:WaitForChild("OriginalSize")
		 end
	  end
	  local Target = (...) 
	  if Target == "all" or Target == "others" then
  print("Patched")
  end
			  local Character = Player.Character        
			  local PlayerGui = Player:waitForChild("PlayerGui")
			  local Backpack = Player:waitForChild("Backpack")
			  local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
			  local RootPart = Character and Humanoid and Humanoid.RootPart or false
			  local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
			  if not Humanoid or not RootPart or not RightArm then
				  return
			  end
			  Humanoid:UnequipTools()
			  local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
			  if not MainTool or not MainTool:FindFirstChild("Handle") then
				  return
			  end
			  local TPlayer = getPlr(Target)
			  local TCharacter = TPlayer and TPlayer.Character
			  local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
			  local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
			  if not THumanoid or not TRootPart then
				  return
			  end
			  Character.Humanoid.Name = "DAttach"
			  local l = Character["DAttach"]:Clone()
			  l.Parent = Character
			  l.Name = "Humanoid"
			  wait()
			  Character["DAttach"]:Destroy()
			  game.Workspace.CurrentCamera.CameraSubject = Character
			  Character.Animate.Disabled = true
			  wait()
			  Character.Animate.Disabled = false
			  Character.Humanoid:EquipTool(MainTool)
			  wait()
			  CF = Player.Character.PrimaryPart.CFrame
			  if firetouchinterest then
				  local flag = false
				  task.defer(function()
					  MainTool.Handle.AncestryChanged:wait()
					  flag = true
				  end)
				  repeat
					  firetouchinterest(MainTool.Handle, TRootPart, 0)
					  firetouchinterest(MainTool.Handle, TRootPart, 1)
					  wait()
					  Player.Character.HumanoidRootPart.CFrame = CF
				  until flag
			  else
				  Player.Character.HumanoidRootPart.CFrame =
				  TCharacter.HumanoidRootPart.CFrame
				  wait()
				  Player.Character.HumanoidRootPart.CFrame =
				  TCharacter.HumanoidRootPart.CFrame
				  wait()
				  Player.Character.HumanoidRootPart.CFrame = CF
				  wait()
			  end
			  wait(.3)
			  Player.Character:SetPrimaryPartCFrame(CF)
			  if Humanoid.RigType == Enum.HumanoidRigType.R6 then
				  Character["Right Arm"].RightGrip:Destroy()
			  else
				  Character["RightHand"].RightGrip:Destroy()
				  Character["RightHand"].RightGripAttachment:Destroy()
			  end
				  
			  wait(4)
			  CF = Player.Character.HumanoidRootPart.CFrame
			  player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
 end)
 
 cmd.add({"headvoid", "hvoid"}, {"headvoid <player> (hvoid)", "Need an rthro head"}, function(...)
	 for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetChildren()) do
		 if string.find(v.Name,"Scale") and v.Name ~= "HeadScale" then
			 repeat wait(HeadGrowSpeed) until game.Players.LocalPlayer.Character.Head:FindFirstChild("OriginalSize")
			 game.Players.LocalPlayer.Character.Head.OriginalSize:Destroy()
			 v:Destroy()
			 game.Players.LocalPlayer.Character.Head:WaitForChild("OriginalSize")
		 end
	  end
	  Target = (...)
 local Character = Player.Character
 local PlayerGui = Player:waitForChild("PlayerGui")
 local Backpack = Player:waitForChild("Backpack")
 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
 local RootPart = Character and Humanoid and Humanoid.RootPart or false
 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
 if not Humanoid or not RootPart or not RightArm then
 return
 end
 
 Humanoid:UnequipTools()
 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
 if not MainTool or not MainTool:FindFirstChild("Handle") then
 return
 end
 
 local TPlayer = getPlr(Target)
 local TCharacter = TPlayer and TPlayer.Character
 
 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
 if not THumanoid or not TRootPart then
 return
 end
 
 Character.Humanoid.Name = "DAttach"
 local l = Character["DAttach"]:Clone()
 l.Parent = Character
 l.Name = "Humanoid"
 wait()
 Character["DAttach"]:Destroy()
 game.Workspace.CurrentCamera.CameraSubject = Character
 Character.Animate.Disabled = true
 wait()
 Character.Animate.Disabled = false
 Character.Humanoid:EquipTool(MainTool)
 wait()
 CF = Player.Character.PrimaryPart.CFrame
 XC = TCharacter.HumanoidRootPart.CFrame.X
 ZC = TCharacter.HumanoidRootPart.CFrame.Z
 if firetouchinterest then
 local flag = false
 task.defer(function()
	 MainTool.Handle.AncestryChanged:wait()
	 flag = true
 end)
 repeat
	 firetouchinterest(MainTool.Handle, TRootPart, 0)
	 firetouchinterest(MainTool.Handle, TRootPart, 1)
	 wait()
 until flag
 wait(0.2)
 Player.Character.HumanoidRootPart.CFrame = CFrame.new(0,-1000,0)
 end
 wait(2)
 respawn()
 end)
 
 cmd.add({"headresize"}, {"headresize", "Makes your head very big r15 only"}, function()
 for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetChildren()) do
	if string.find(v.Name,"Scale") and v.Name ~= "HeadScale" then
		repeat wait(HeadGrowSpeed) until game.Players.LocalPlayer.Character.Head:FindFirstChild("OriginalSize")
		game.Players.LocalPlayer.Character.Head.OriginalSize:Destroy()
		v:Destroy()
		game.Players.LocalPlayer.Character.Head:WaitForChild("OriginalSize")
	end
 end
 end)
 
 cmd.add({"discord"}, {"discord", "discord server link to vulkan, the editor of this script"}, function()
	 wait();
	 
	 Notify({
	 Description = "discord.gg/syTkjWweQS";
	 Title = "Nameless Admin - Vulkan Discord servre";
	 Duration = 15;
	 
	 });
	 setclipboard("discord.gg/syTkjWweQS")
	 end)
 
 cmd.add({"exit"}, {"exit", "Close down roblox"}, function()
 game:Shutdown()
 end)
 
 cmd.add({"fat", "nikocadoavocado"}, {"fat (nikocadoavocado)", "fat"}, function()
	 local LocalPlayer = game:GetService("Players").LocalPlayer
	 local Character = LocalPlayer.Character
	 local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	 
	 local function rm()
		 for i,v in pairs(Character:GetDescendants()) do
					 if v:FindFirstChild("AvatarPartScaleType") then
						 v:FindFirstChild("AvatarPartScaleType"):Destroy()
					 end
				 end
			 end
	 
	 
	 rm()
	 wait(0.1)
	 Humanoid:FindFirstChild("BodyWidthScale"):Destroy()
	 wait(0.2)
	 
	 rm()
	 wait(0.5)
	 Humanoid:FindFirstChild("BodyTypeScale"):Destroy()
	 wait(0.2)
 end)
 
 cmd.add({"small"}, {"small", "Makes you short r15 only"}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "Making you small.. r15 needed";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 --Shit ass script made by failedmite57926
 
 local LocalPlayer = game:GetService("Players").LocalPlayer
 local Character = LocalPlayer.Character
 local Humanoid = Character:FindFirstChildOfClass("Humanoid")
 
 local function rm()
	 for i,v in pairs(Character:GetDescendants()) do
		 if v:IsA("BasePart") then
			 if v.Name ~= "Head" then
				 for i,cav in pairs(v:GetDescendants()) do
					 if cav:IsA("Attachment") then
						 if cav:FindFirstChild("OriginalPosition") then
							 cav.OriginalPosition:Destroy()
						 end
					 end
				 end
				 v:FindFirstChild("OriginalSize"):Destroy()
				 if v:FindFirstChild("AvatarPartScaleType") then
					 v:FindFirstChild("AvatarPartScaleType"):Destroy()
				 end
			 end
		 end
	 end
 end
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyTypeScale"):Destroy()
 wait(0.2)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyWidthScale"):Destroy()
 wait(0.2)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyDepthScale"):Destroy()
 wait(0.2)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("HeadScale"):Destroy()
 wait(0.2)
 end)
 
 cmd.add({"loopfling"}, {"loopfling <player>", "Loop voids a player"}, function(plr)
	 local Targets = {plr}
	 
	 Loopvoid = true
	 repeat wait()
 local player = game.Players.LocalPlayer
 local mouse = player:GetMouse()
 
 local Players = game:GetService("Players")
 local Player = Players.LocalPlayer
 
 local AllBool = false
 
 local GetPlayer = function(Name)
	Name = Name:lower()
	if Name == "all" or Name == "others" then
		AllBool = true
		return
	elseif Name == "random" then
		local GetPlayers = Players:GetPlayers()
		if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
		return GetPlayers[math.random(#GetPlayers)]
	elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
		for _,x in next, Players:GetPlayers() do
			if x ~= Player then
				if x.Name:lower():match("^"..Name) then
					return x;
				elseif x.DisplayName:lower():match("^"..Name) then
					return x;
				end
			end
		end
	else
		return
	end
 end
 
 local Message = function(_Title, _Text, Time)

end
 
 local SkidFling = function(TargetPlayer)
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart
 
	local TCharacter = TargetPlayer.Character
	local THumanoid
	local TRootPart
	local THead
	local Accessory
	local Handle
 
	if TCharacter:FindFirstChildOfClass("Humanoid") then
		THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
	end
	if THumanoid and THumanoid.RootPart then
		TRootPart = THumanoid.RootPart
	end
	if TCharacter:FindFirstChild("Head") then
		THead = TCharacter.Head
	end
	if TCharacter:FindFirstChildOfClass("Accessory") then
		Accessory = TCharacter:FindFirstChildOfClass("Accessory")
	end
	if Accessoy and Accessory:FindFirstChild("Handle") then
		Handle = Accessory.Handle
	end
 
	if Character and Humanoid and RootPart then
		if RootPart.Velocity.Magnitude < 50 then
			getgenv().OldPos = RootPart.CFrame
		end
		if THumanoid and THumanoid.Sit and not AllBool then
			return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
		end
		if THead then
			workspace.CurrentCamera.CameraSubject = THead
		elseif not THead and Handle then
			workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid and TRootPart then
			workspace.CurrentCamera.CameraSubject = THumanoid
		end
		if not TCharacter:FindFirstChildWhichIsA("BasePart") then
			return
		end
		
		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end
		
		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0
 
			repeat
				if RootPart and THumanoid then
					if BasePart.Velocity.Magnitude < 50 then
						Angle = Angle + 100
 
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						
						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
						task.wait()
 
						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				else
					break
				end
			until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end
		
		workspace.FallenPartsDestroyHeight = 0/0
		
		local BV = Instance.new("BodyVelocity")
		BV.Name = "EpixVel"
		BV.Parent = RootPart
		BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
		BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
		
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		
		if TRootPart and THead then
			if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
				SFBasePart(THead)
			else
				SFBasePart(TRootPart)
			end
		elseif TRootPart and not THead then
			SFBasePart(TRootPart)
		elseif not TRootPart and THead then
			SFBasePart(THead)
		elseif not TRootPart and not THead and Accessory and Handle then
			SFBasePart(Handle)
		else
			return Message("Error Occurred", "Target is missing everything", 5)
		end
		
		BV:Destroy()
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid
		
		repeat
			RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
			Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
			Humanoid:ChangeState("GettingUp")
			table.foreach(Character:GetChildren(), function(_, x)
				if x:IsA("BasePart") then
					x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
				end
			end)
			task.wait()
		until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
		workspace.FallenPartsDestroyHeight = getgenv().FPDH
	else
		return Message("Error Occurred", "Random error", 5)
	end
 end
 
 if not Welcome then Message("Script by AnthonyIsntHere", "Enjoy!", 5) end
 getgenv().Welcome = true
 if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
 
 if AllBool then
	for _,x in next, Players:GetPlayers() do
		SkidFling(x)
	end
 end
 
 for _,x in next, Targets do
	if GetPlayer(x) and GetPlayer(x) ~= Player then
		if GetPlayer(x).UserId ~= 1414978355 then
			local TPlayer = GetPlayer(x)
			if TPlayer then
				SkidFling(TPlayer)
			end
		else
			Message("Error Occurred", "This user is whitelisted! (Owner)", 5)
		end
	elseif not GetPlayer(x) and not AllBool then
		Message("Error Occurred", "Username Invalid", 5)
	end
 end
	 until Loopvoid == false
 end)
 
 cmd.add({"freegamepass", "freegp"}, {"freegamepass (freegp)", "Makes the client think you own every gamepass in the game"}, function()
 local mt = getrawmetatable(game);
 local old = mt.__namecall
 local readonly = setreadonly or make_writeable
 
 local MarketplaceService = game:GetService("MarketplaceService");
 
 readonly(mt, false);
 
 mt.__namecall = function(self, ...)
	local args = {...}
	local method = table.remove(args)
 
	if (self == MarketplaceService and method:find("UserOwnsGamePassAsync")) then
		return true and 1
	end
 
	return old(self, ...)
 end
		 
 
 
 wait();
 
 Notify({
 Description = "Free gamepass has been executed, keep in mind this wont always work.";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end)
 
 cmd.add({"headsit"}, {"headsit <player>", "Head sit."}, function(...)
	 Username = (...)
	 if headSit then 
		 headSit:Disconnect()
	 end
 
 local players = getPlr(Username)
		 local sitPlr = players.Name
 
		 sitDied = game.Players.LocalPlayer.Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
			 sitLoop = sitLoop:Disconnect()
		 end)
				 game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = true
 
	 headSit = RunService.Heartbeat:Connect(function()
					 if Players:FindFirstChild(players.Name) and players.Character ~= nil and getRoot(players.Character) and getRoot(game.Players.LocalPlayer.Character) and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit == true then
			 getRoot(game.Players.LocalPlayer.Character).CFrame = players.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(0),0)* CFrame.new(0,1.6,0.4)
			 else
			 headSit:Disconnect()
		 end
		 end)
 end)
 
 cmd.add({"unheadsit"}, {"unheadsit", "Stop the headsit command"}, function()
 game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
 end)
 
 cmd.add({"jump"}, {"jump", "jump."}, function()
	 game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
 end)
 
 cmd.add({"headstand"}, {"headstand <player>", "Stand on someones head"}, function(...)
	 Username = (...)
	 if headSit then headSit:Disconnect() end
 local players = getPlr(Username)
		 local sitPlr = players.Name
		 sitDied = game.Players.LocalPlayer.Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
			 sitLoop = sitLoop:Disconnect()
		 end)
	 headSit = RunService.Heartbeat:Connect(function()
					 if Players:FindFirstChild(players.Name) and players.Character ~= nil and getRoot(players.Character) and getRoot(game.Players.LocalPlayer.Character) then
			 getRoot(game.Players.LocalPlayer.Character).CFrame = players.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(0),0)* CFrame.new(0,4.6,0.4)
			 else
			 headSit:Disconnect()
		 end
		 end)
 end)
 
 cmd.add({"unheadstand"}, {"unheadstand <player>", "Stop the headstand command"}, function()
 headSit = headSit:Disconnect()
 sitDied:Disconnect()
 end)
 
 loopws = false
 cmd.add({"loopwalkspeed", "loopws"}, {"loopwalkspeed <speed> (loopws)", "Loop walkspeed"}, function(...)
	 speed = (...)
	 loopws = true
	 repeat wait()
	 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
	 detectdied = game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
		 if loopws == true then
 wait(game.Players.RespawnTime + 0.4)
 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
		 end
 end)
	 until loopws == false
 end)
 
 cmd.add({"unloopwalkspeed", "unloopws"}, {"unloopwalkspeed <speed> (unloopws)", "Disable loop walkspeed"}, function(...)
	 loopws = false
	 detectdied:Disconnect()
	 wait(0.6)
	 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
 end)
 
 loopwave = false
 cmd.add({"loopwaveat", "loopwat"}, {"loopwaveat <player> (loopwat)", "Wave to a player in a loop"}, function(...)
	loopwave = true
	Player = (...)
	Target = getPlr(Player)
	local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	repeat wait()
		wait(0.2)
		targetcframe = Target.Character.HumanoidRootPart.CFrame
	WaveAnim = Instance.new("Animation")
				if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
					WaveAnim.AnimationId = "rbxassetid://507770239"
				else
					WaveAnim.AnimationId = "rbxassetid://128777973"
				end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetcframe * CFrame.new(0, 0, -3)
				local CharPos = game.Players.LocalPlayer.Character.PrimaryPart.Position
						local tpos = Target.Character:FindFirstChild("HumanoidRootPart").Position
						local TPos = Vector3.new(tpos.X,CharPos.Y,tpos.Z)
						local NewCFrame = CFrame.new(CharPos,TPos)
						Players.LocalPlayer.Character:SetPrimaryPartCFrame(NewCFrame)
	wave = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(WaveAnim)
	wave:Play(-1, 5, -1)
	wait(1.6)
	wave:Stop()
			until loopwave == false
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
 end)

 cmd.add({"unloopwaveat", "unloopwat"}, {"unloopwaveat <player> (unloopwat)", "Stops the loopwaveat command"}, function(...)
	loopwave = false
 end)

 cmd.add({"waveat", "wat"}, {"waveat <player> (wat)", "Wave to a player"}, function(...)
 -- r6 / 128777973
 -- r15 / 507770239
 Player = (...)
 Target = getPlr(Player)
 local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
 targetcframe = Target.Character.HumanoidRootPart.CFrame
 WaveAnim = Instance.new("Animation")
			 if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15 then
				 WaveAnim.AnimationId = "rbxassetid://507770239"
			 else
				 WaveAnim.AnimationId = "rbxassetid://128777973"
			 end
			 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetcframe * CFrame.new(0, 0, -3)
			 local CharPos = game.Players.LocalPlayer.Character.PrimaryPart.Position
					 local tpos = Target.Character:FindFirstChild("HumanoidRootPart").Position
					 local TPos = Vector3.new(tpos.X,CharPos.Y,tpos.Z)
					 local NewCFrame = CFrame.new(CharPos,TPos)
					 Players.LocalPlayer.Character:SetPrimaryPartCFrame(NewCFrame)
 wave = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(WaveAnim)
 wave:Play(-1, 5, -1)
 wait(1.6)
 wave:Stop()
 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
 end)
 
 cmd.add({"headbang", "mouthbang", "hb", "mb"}, {"headbang <player> (mouthbang, hb, mb)", "Bang them in the mouth because you are gay"}, function(h,d)
 RunService = game:GetService("RunService")
 
	 speed = d
 
	 if speed == nil then
 speed = 10
	 end
	 
	 Username = h
	 
	 local players = getPlr(Username)
			 bangAnim = Instance.new("Animation")
			 if not r15(game.Players.LocalPlayer) then
				 bangAnim.AnimationId = "rbxassetid://148840371"
			 else
				 bangAnim.AnimationId = "rbxassetid://5918726674"
			 end
			 bang = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(bangAnim)
			 bang:Play(.1, 1, 1)
			 if speed then
				 bang:AdjustSpeed(speed)
			 else
				 bang:AdjustSpeed(3)
			 end
			 local bangplr = players.Name
			 bangDied = game.Players.LocalPlayer.Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
				 bangLoop = bangLoop:Disconnect()
				 bang:Stop()
				 bangAnim:Destroy()
				 bangDied:Disconnect()
			 end)
			 local bangOffet = CFrame.new(0, 1, -1.1)
			 bangLoop = RunService.Stepped:Connect(function()
				 pcall(function()
					 local otherRoot = game.Players[bangplr].Character.Head
					 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = otherRoot.CFrame * bangOffet
					 local CharPos = game.Players.LocalPlayer.Character.PrimaryPart.Position
					 local tpos = players.Character:FindFirstChild("HumanoidRootPart").Position
					 local TPos = Vector3.new(tpos.X,CharPos.Y,tpos.Z)
					 local NewCFrame = CFrame.new(CharPos,TPos)
					 Players.LocalPlayer.Character:SetPrimaryPartCFrame(NewCFrame)
				 end)
			 end)
 end)
 
 cmd.add({"unheadbang", "unmouthbang", "unhb", "unmb"}, {"unheadbang (unmouthbang, unhb, unmb)", "Bang them in the mouth because you are gay"}, function(h,d)
	 if bangLoop then
		 bangLoop = bangLoop:Disconnect()
		 bang:Stop()
		 bangAnim:Destroy()
		 bangDied:Disconnect()
 end
 end)
 
 cmd.add({"bang", "fuck"}, {"bang <player> <speed>", "Bangs the player by attaching to them"}, function(h,d)	 
	 speed = d
 
	 if speed == nil then
 speed = 10
	 end
	 Username = h
	 local Target = getPlr(Username)
			 bangAnim = Instance.new("Animation")
			 if not r15(game.Players.LocalPlayer) then
				 bangAnim.AnimationId = "rbxassetid://148840371"
			 else
				 bangAnim.AnimationId = "rbxassetid://5918726674"
			 end
			 bang = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(bangAnim)
			 bang:Play(.1, 1, 1)
			 if speed then
				 bang:AdjustSpeed(speed)
			 else
				 bang:AdjustSpeed(3)
			 end
			 local bangplr = Target.Name
			 bangDied = game.Players.LocalPlayer.Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
				 bangLoop = bangLoop:Disconnect()
				 bang:Stop()
				 bangAnim:Destroy()
				 bangDied:Disconnect()
			 end)
			 local bangOffet = CFrame.new(0, 0, 1.1)
			 bangLoop = RunService.Stepped:Connect(function()
				 pcall(function()
					 local otherRoot = getTorso(game.Players[bangplr].Character)
					 getRoot(game.Players.LocalPlayer.Character).CFrame = otherRoot.CFrame * bangOffet
				 end)
			 end)
 
			 
			 
			 
			 wait();
			 
			 Notify({
			 Description = "Banging player...";
			 Title = "Nameless Admin";
			 Duration = 5;
			 
			 });
 end)
 
 glueloop = false
 cmd.add({"glue"}, {"glue <player>", "Bangs the player by attaching to them"}, function(...)
	glueloop = true
User = (...)
Target = getPlr(User)
 
repeat wait()
LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
until glueloop == false
 end)
 
 cmd.add({"unglue"}, {"unglue", "stops glueing"}, function()
	glueloop = false
 end)
 
 cmd.add({"spook", "scare"}, {"spook <player> (scare)", "Teleports next to a player for a few seconds"}, function(...)
 Username = (...)
 Target = getPlr(Username)
 
 local oldCF = LocalPlayer.Character.HumanoidRootPart.CFrame
   Target = getPlr(Username)    
				 distancepl = 2
				 if Target.Character and Target.Character:FindFirstChild('Humanoid') then
						 LocalPlayer.Character.HumanoidRootPart.CFrame =
								 Target.Character.HumanoidRootPart.CFrame +  Target.Character.HumanoidRootPart.CFrame.lookVector * distancepl
						 LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Target.Character.HumanoidRootPart.Position)
						 wait(.5)
						 LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
				 end
		 
 end)
 
 loopspook = false
 cmd.add({"loopspook", "loopscare"}, {"loopspook <player> (loopscare)", "Teleports next to a player for a few seconds and then again and again"}, function(...)
	 loopspook = true
 repeat wait()
	 Username = (...)
	 Target = getPlr(Username)
	 
	 local oldCF = LocalPlayer.Character.HumanoidRootPart.CFrame
	   Target = getPlr(Username)    
					 distancepl = 2
					 if Target.Character and Target.Character:FindFirstChild('Humanoid') then
							 LocalPlayer.Character.HumanoidRootPart.CFrame =
									 Target.Character.HumanoidRootPart.CFrame +  Target.Character.HumanoidRootPart.CFrame.lookVector * distancepl
							 LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Target.Character.HumanoidRootPart.Position)
							 wait(.5)
							 LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
					 end
					 wait(0.3)
 until loopspook == false
 end)
 
 cmd.add({"unloopspook", "unloopscare"}, {"unloopspook <player> (unloopscare)", "Stops the loopspook command"}, function()
	 loopspook = false
 end)
 
 cmd.add({"unbang", "unfuck"}, {"unbang", "Unbangs the player"}, function()
		 if bangLoop then
		 bangLoop = bangLoop:Disconnect()
		 bang:Stop()
		 bangAnim:Destroy()
		 bangDied:Disconnect()
 end
 end)
 
 cmd.add({"unairwalk", "unaw"}, {"unairwalk (unaw)", "Stops the airwalk command"}, function()
	 for i, v in pairs(workspace:GetChildren()) do
		 if tostring(v) == "Airwalk" then
			 v:Destroy()
 wait();
 
 Notify({
 Description = "Airwalk: OFF";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 end
 end
 
 end)
 
 cmd.add({"airwalk", "aw"}, {"airwalk (aw)", "Press space to go up, unairwalk to stop"}, function()
 wait();
 
 Notify({
 Description = "Airwalk: On";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 
 local Chat = game:GetService('Players').LocalPlayer.Chatted
				 local function AirWalk()
 
					 local AirWPart = Instance.new("Part", workspace)
					 local crtl = true
					 local Mouse = game.Players.LocalPlayer:GetMouse()
					 AirWPart.Size = Vector3.new(7, 2, 3)
					 AirWPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -4, 0)
					 AirWPart.Transparency = 1
					 AirWPart.Anchored = true
					 AirWPart.Name = "Airwalk"
					 for i = 1, math.huge do
						 AirWPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -4, 0)
						 wait (.1)
					 end
				 end
				 AirWalk()
				 
 end)
 
 cmd.add({"cbring", "clientbring"}, {"clientbring <player> (cbring)", "Brings the player on your client"}, function(...)
	 Username = (...)
 
	 if connections["noclip"] then lib.disconnect("noclip") return end
	 lib.connect("noclip", RunService.Stepped:Connect(function()
		 if not character then return end
		 for i, v in pairs(character:GetDescendants()) do
			 if v:IsA("BasePart") then
				 v.CanCollide = false
			 end
		 end
	 end))
	 
	 if Username == "all" or Username == "others" then
		 bringc = game:GetService("RunService").RenderStepped:Connect(function()
			 for i, target in pairs(game:GetService("Players"):GetChildren()) do
			 if target.Name == game.Players.LocalPlayer.Name then
			 else
			 target.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 5
			 end
			 end
			 end)
	 else
	 target = getPlr(Username)
	 
		 bringc = game:GetService("RunService").RenderStepped:Connect(function()
					 if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
	 target.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 3
					 end
	 end)
	 end
 end)
 
 cmd.add({"uncbring", "unclientbring"}, {"unclientbring (uncbring)", "Disable Client bring command"}, function()
	 bringc:Disconnect()
	 if connections["noclip"] then lib.disconnect("noclip") return end
 end)
 
	 cmd.add({"mute", "muteboombox"}, {"mute <player> (muteboombox)", "Mutes the players boombox"}, function(...)
		 Username = (...)
		 if game:GetService("SoundService").RespectFilteringEnabled == true then

	 wait();
	 
	 Notify({
	 Description = "Boombox muted. Status: Client Sided";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
	 });
		 else
	 wait();
	 
	 Notify({
	 Description = "Boombox muted. Status: FE";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
	 });
			 if Username == "all" or Username == "others" then
				 local players = game:GetService("Players"):GetPlayers()
				 for _, player in ipairs(players) do
					 for _, object in ipairs(player.Character:GetDescendants()) do
						 if object:IsA("Sound") and object.Playing then
							 object:Stop()
						 end
					 end
					 local backpack = player:FindFirstChildOfClass("Backpack")
					 if backpack then
						 for _, object in ipairs(backpack:GetDescendants()) do
							 if object:IsA("Sound") and object.Playing then
								 object:Stop()
							 end
						 end
					 end
				 end			
			 else
		 local players = getPlr(Username)
			 if players ~= nil then
						 for i, x in next, players.Character:GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = false
							 end
						 end
						 for i, x in next, players:FindFirstChildOfClass("Backpack"):GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = false
							 end
						 end
					 end 
			 end
 end
 end)
 
 cmd.add({"antivoid"}, {"antivoid", "Anti void."}, function()
 getgenv().AntiVoid = true -- // toggle it on and off
 
 -- // Services
 local Players = game:GetService("Players")
 
 -- // Vars
 local LocalPlayer = Players.LocalPlayer
 
 -- // Check if anyone has the same handle as you
 local function toolMatch(Handle)
	 local allPlayers = Players:GetPlayers()
	 for i = 1, #allPlayers do
		 -- // Vars
		 local Player = allPlayers[i]
		 if (Player == LocalPlayer) then continue end -- // ignore local player
 
		 -- // Vars
		 local Character = Player.Character
		 local RightArm = Character:WaitForChild("Right Arm")
		 local RightGrip = RightArm:FindFirstChild("RightGrip")
 
		 -- // Check if they share the same Part1 Handle of the Grip
		 if (RightGrip and RightGrip.Part1 == Handle) then
			 return Player
		 end
	 end
 end
 
 -- // Manager
 local function onCharacter(Character)
	 local RightArm = Character:WaitForChild("Right Arm")
 
	 -- // See when you equip something
	 RightArm.ChildAdded:Connect(function(child)
		 if (child:IsA("Weld") and child.Name == "RightGrip" and getgenv().AntiVoid) then
			 -- // Vars
			 local ConnectedHandle = child.Part1
 
			 -- // Check if someone else has something equipped too with the same handle as you
			 local matched = toolMatch(ConnectedHandle)
 
			 -- // Destroy the tool, if someone is voiding you
			 if (matched) then
				 ConnectedHandle.Parent:Destroy()
				 print(matched, "just tried to void you lol!")
			 end
		 end
	 end)
 end
 
 -- // Initialise the script
 onCharacter(LocalPlayer.Character)
 LocalPlayer.CharacterAdded:Connect(onCharacter)
 end)
 
 TPWalk = false
 cmd.add({"tpwalk", "tpwalk"}, {"tpwalk <speed>", "More undetectable walkspeed script"}, function(...)
	if TPWalk == true then
		TPWalk = false
		TPWalking = TPWalking:Disconnect()
	end
	 TPWalk = true
	 Speed = (...)
	 TPWalking = game:GetService("RunService").Heartbeat:Wait()
	 game:GetService("RunService").Stepped:Connect(function()
		if TPWalk == true then
		 if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude > 0 then
			 if Speed then
				  game.Players.LocalPlayer.Character:TranslateBy(game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection * Speed * TPWalking * 10)
			 else
				  game.Players.LocalPlayer.Character:TranslateBy(game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection * TPWalking * 10)
			 end
			end
		end
	end)
 end)
 
 cmd.add({"untpwalk"}, {"untpwalk", "Stops the tpwalk command"}, function()
	 TPWalk = false
	 TPWalking = false
 end)
 
	 cmd.add({"loopmute", "loopmuteboombox"}, {"loopmute <player> (loopmuteboombox)", "Loop mutes the players boombox"}, function(...)
		 Username = (...)
	 if Username == "all" or Username == "others" then
		 Loopmute = true
	 repeat wait()
		 local players = game:GetService("Players"):GetPlayers()
		 for _, player in ipairs(players) do
			 for _, object in ipairs(player.Character:GetDescendants()) do
				 if object:IsA("Sound") and object.Playing then
					 object:Stop()
				 end
			 end
			 local backpack = player:FindFirstChildOfClass("Backpack")
			 if backpack then
				 for _, object in ipairs(backpack:GetDescendants()) do
					 if object:IsA("Sound") and object.Playing then
						 object:Stop()
					 end
				 end
			 end
		 end	
	 until Loopmute == false
	 else
		 Loopmute = true
		 local players = getPlr(Username)
	 repeat wait()
 
			 if players ~= nil then
						 for i, x in next, players.Character:GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = false
							 end
						 end
						 for i, x in next, players:FindFirstChildOfClass("Backpack"):GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = false
							 end
						 end
					 end 
				 until Loopmute == false
				 if game:GetService("SoundService").RespectFilteringEnabled == true then
					 
				 
				 
				 wait();
				 
				 Notify({
				 Description = "Boombox glitched. Status: Client Sided";
				 Title = "Nameless Admin";
				 Duration = 5;
				 
				 });
				 else
				 if game:GetService("SoundService").RespectFilteringEnabled == false then
					 
				 
				 
				 wait();
				 
				 Notify({
				 Description = "Boombox glitched. Status: FE";
				 Title = "Nameless Admin";
				 Duration = 5;
				 
				 });
				 end
				 end
			 end
 end)
 
	 
	 cmd.add({"unloopmute", "unloopmuteboombox"}, {"unloopmute <player> (unloopmuteboombox)", "Unloop mutes the players boombox"}, function(...)
	 Loopmute = false
	 wait()
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Unloopmuted everyone";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
	 });
 end)
 
	 cmd.add({"glitch", "glitchboombox"}, {"glitch <player> (glitchboombox)", "Glitches the players boombox"}, function(...)
		 Username = (...)
		 Loopglitch = true
		 local players = getPlr(Username)
			 if players ~= nil then
						 for i, x in next, players.Character:GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = true
							 end
						 end
						 for i, x in next, players:FindFirstChildOfClass("Backpack"):GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = true
							 end
						 end
					 end 
					 repeat wait()
						 for i, x in next, players:FindFirstChildOfClass("Backpack"):GetDescendants() do
							 if x:IsA("Sound") and x.Playing == false then
								 x.Playing = true
							 end
						 end
						 for i, x in next, players.Character:GetDescendants() do
							 if x:IsA("Sound") and x.Playing == false then
								 x.Playing = true
							 end
						 end
						 wait(0.2)
						 for i, x in next, players:FindFirstChildOfClass("Backpack"):GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = false
							 end
						 end
						 for i, x in next, players.Character:GetDescendants() do
							 if x:IsA("Sound") and x.Playing == true then
								 x.Playing = false
							 end
						 end
						 wait(0.2)
				 until Loopglitch == false
 if game:GetService("SoundService").RespectFilteringEnabled == true then
	 
 
 
 wait();
 
 Notify({
 Description = "Boombox glitched. Status: Client Sided";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 else
 if game:GetService("SoundService").RespectFilteringEnabled == false then
	 
 
 
 wait();
 
 Notify({
 Description = "Boombox glitched. Status: FE";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end
 end
 end)
 
		 cmd.add({"unglitch", "unglitchboombox"}, {"unglitch <player> (unglitchboombox)", "Unglitches the players boombox"}, function(...)
			 Loopglitch = false
			 wait()
			 if game:GetService("SoundService").RespectFilteringEnabled == true then
				 
			 
			 
			 wait();
			 
			 Notify({
			 Description = "Boombox unglitched. Status: Client Sided";
			 Title = "Nameless Admin";
			 Duration = 5;
			 
			 });
			 else
			 if game:GetService("SoundService").RespectFilteringEnabled == false then
				 
			 
			 
			 wait();
			 
			 Notify({
			 Description = "Boombox unglitched. Status: FE";
			 Title = "Nameless Admin";
			 Duration = 5;
			 
			 });
			 end
			 end
		 end)
 
		 cmd.add({"unlooplbring", "unlooplegbring"}, {"unlooplbring <player> (unlooplegbring)", "Stop the looplbring command"}, function()
 loopbring = false
		 end)
 
		 cmd.add({"unlooplvoid", "unlooplegvoid"}, {"unlooplvoid <player> (unlooplegvoid)", "Stop the looplvoid command"}, function()
			 loopvoid = false
					 end)
			 
					 cmd.add({"unlooplkill", "unlooplegkill"}, {"unlooplkill <player> (unlooplegkill)", "Stop the looplkill command"}, function()
						 loopkill = false
								 end)
 
		 cmd.add({"getmass"}, {"getmass <player>", "Get your mass"}, function(...)
			 target = getPlr(...)
			 local mass = target.Character.HumanoidRootPart.AssemblyMass 
			 wait();
		 
			 Notify({
			 Description = target.Name .. "'s mass is " .. mass;
			 Title = "Nameless Admin";
			 Duration = 5;
			 
			 });
		 end)
		 
		 cmd.add({"dvoid", "dvoid"}, {"dvoid <player> (dvoid)", "Delay void"}, function(...)
			 Target = (...)
 
			 Players = game:GetService("Players")
			  local c = game.Players.LocalPlayer.Character
			  game.Players.LocalPlayer.Character = nil
				  game.Players.LocalPlayer.Character = c
				  wait(game.Players.RespawnTime - 0.5)
		  local TPlayer = getPlr(Target)
						 TRootPart = TPlayer.Character.HumanoidRootPart
						 local Character = Player.Character
						 local PlayerGui = Player:WaitForChild("PlayerGui")
						 local Backpack = Player:WaitForChild("Backpack")
						 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
						 local RootPart = Character and Humanoid and Humanoid.RootPart or false
						 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
						 if not Humanoid or not RootPart or not RightArm then
							 return
						 end
						 Humanoid:UnequipTools()
						 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
						 if not MainTool or not MainTool:FindFirstChild("Handle") then
							 return
						 end
						 Humanoid.Name = "DAttach"
						 local l = Character["DAttach"]:Clone()
						 l.Parent = Character
						 l.Name = "Humanoid"
						 wait()
						 Character["DAttach"]:Destroy()
						 game.Workspace.CurrentCamera.CameraSubject = Character
						 Character.Animate.Disabled = true
						 wait()
						 Character.Animate.Disabled = false
						 Character.Humanoid:EquipTool(MainTool)
						 wait()
						 CF = Player.Character.PrimaryPart.CFrame
						 if firetouchinterest then
							 local flag = false
							 task.defer(function()
								 MainTool.Handle.AncestryChanged:wait()
								 flag = true
							 end)
							 repeat
								 firetouchinterest(MainTool.Handle, TRootPart, 0)
								 firetouchinterest(MainTool.Handle, TRootPart, 1)
								 wait()
							 until flag
							 wait(0.2)
 Player.Character.HumanoidRootPart.CFrame = CFrame.new(0,-1000,0)
						 end
		  l.Parent = game.Players.LocalPlayer.Character
		  l.Name = "Humanoid"
					  
		  game.Players.LocalPlayer.Character["1"]:Destroy()
		  game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
		  game.Players.LocalPlayer.Character.Animate.Disabled = true
		  wait()
		  game.Players.LocalPlayer.Character.Animate.Disabled = false
		  game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"	  
		 end)
 
				 cmd.add({"dbring", "delaybring"}, {"delaybring <player> (dbring)", "Delay bring"}, function(...)
					 Target = (...)
	
					 local c = game.Players.LocalPlayer.Character
					 game.Players.LocalPlayer.Character = nil
						 game.Players.LocalPlayer.Character = c
						 wait(game.Players.RespawnTime - 0.45)
				 game.Players.LocalPlayer.Character.Humanoid.Name = 1
				 local l = game.Players.LocalPlayer.Character["1"]:Clone()
				 l.Parent = game.Players.LocalPlayer.Character
				 l.Name = "Humanoid"
							 
				 game.Players.LocalPlayer.Character["1"]:Destroy()
				 game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
				 game.Players.LocalPlayer.Character.Animate.Disabled = true
				 wait()
				 game.Players.LocalPlayer.Character.Animate.Disabled = false
				 game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"
				   local Character = Player.Character        
							 local PlayerGui = Player:waitForChild("PlayerGui")
							 local Backpack = Player:waitForChild("Backpack")
							 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
							 local RootPart = Character and Humanoid and Humanoid.RootPart or false
							 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
							 if not Humanoid or not RootPart or not RightArm then
								 return
							 end
							 Humanoid:UnequipTools()
							 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
							 if not MainTool or not MainTool:FindFirstChild("Handle") then
								 return
							 end
							 local TPlayer = getPlr(Target)
							 local TCharacter = TPlayer and TPlayer.Character
							 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
							 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
							 if not THumanoid or not TRootPart then
								 return
							 end
							 Character.Humanoid.Name = "DAttach"
							 local l = Character["DAttach"]:Clone()
							 l.Parent = Character
							 l.Name = "Humanoid"
							 wait()
							 Character["DAttach"]:Destroy()
							 game.Workspace.CurrentCamera.CameraSubject = Character
							 Character.Animate.Disabled = true
							 wait()
							 Character.Animate.Disabled = false
							 Character.Humanoid:EquipTool(MainTool)
							 wait()
							 CF = Player.Character.PrimaryPart.CFrame
							 if firetouchinterest then
								 local flag = false
								 task.defer(function()
									 MainTool.Handle.AncestryChanged:wait()
									 flag = true
								 end)
								 repeat
									 firetouchinterest(MainTool.Handle, TRootPart, 0)
									 firetouchinterest(MainTool.Handle, TRootPart, 1)
									 wait()
									 Player.Character.HumanoidRootPart.CFrame = CF
								 until flag
							 else
								 Player.Character.HumanoidRootPart.CFrame =
								 TCharacter.HumanoidRootPart.CFrame
								 wait()
								 Player.Character.HumanoidRootPart.CFrame =
								 TCharacter.HumanoidRootPart.CFrame
								 wait()
								 Player.Character.HumanoidRootPart.CFrame = CF
								 wait()
							 end
							 wait(.3)
							 Player.Character:SetPrimaryPartCFrame(CF)
							 if Humanoid.RigType == Enum.HumanoidRigType.R6 then
								 Character["Right Arm"].RightGrip:Destroy()
							 else
								 Character["RightHand"].RightGrip:Destroy()
								 Character["RightHand"].RightGripAttachment:Destroy()
							 end
				 end)
 
 cmd.add({"loopvoid", "loopv"}, {"loopvoid <player> (loopv)", "Voids the player"}, function(...)
	 Target = (...)
	 
		 Loopvoid = true
 
	 repeat wait()
				 local Character = Player.Character
 local PlayerGui = Player:waitForChild("PlayerGui")
 local Backpack = Player:waitForChild("Backpack")
 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
 local RootPart = Character and Humanoid and Humanoid.RootPart or false
 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
 if not Humanoid or not RootPart or not RightArm then
 return
 end
 
 Humanoid:UnequipTools()
 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
 if not MainTool or not MainTool:FindFirstChild("Handle") then
 return
 end
 
 local TPlayer = getPlr(Target)
 local TCharacter = TPlayer and TPlayer.Character
 
 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
 if not THumanoid or not TRootPart then
 return
 end
 
 Character.Humanoid.Name = "DAttach"
 local l = Character["DAttach"]:Clone()
 l.Parent = Character
 l.Name = "Humanoid"
 wait()
 Character["DAttach"]:Destroy()
 game.Workspace.CurrentCamera.CameraSubject = Character
 Character.Animate.Disabled = true
 wait()
 Character.Animate.Disabled = false
 Character.Humanoid:EquipTool(MainTool)
 wait()
 CF = Player.Character.PrimaryPart.CFrame
 XC = TCharacter.HumanoidRootPart.CFrame.X
 ZC = TCharacter.HumanoidRootPart.CFrame.Z
 if firetouchinterest then
 local flag = false
 task.defer(function()
	 MainTool.Handle.AncestryChanged:wait()
	 flag = true
 end)
 repeat
	 firetouchinterest(MainTool.Handle, TRootPart, 0)
	 firetouchinterest(MainTool.Handle, TRootPart, 1)
	 wait()
	 Player.Character.HumanoidRootPart.CFrame = CFrame.new(XC,-99,ZC)
 until flag
 wait(0.2)
 Player.Character.HumanoidRootPart.CFrame = CFrame.new(0,-1000,0)
 end
 wait(2)
 respawn()
 until Loopvoid == false
 end)
 
 cmd.add({"loopbring"}, {"loopbring <player>", "Loopbrings a player"}, function(...)
 
	 local Username = (...)
 
	 if Username == "all" or Username == "others" then
		 Loopbring = true
		 repeat wait()
			 wait(0.3)
		 print("Patched")
		 until Loopbring == false
 else
	 Loopbring = true
	 repeat wait()
		 wait(0.15)
		 local Target = Username
		 local Character = Player.Character        
		 local PlayerGui = Player:waitForChild("PlayerGui")
		 local Backpack = Player:waitForChild("Backpack")
		 local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
		 local RootPart = Character and Humanoid and Humanoid.RootPart or false
		 local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
		 if not Humanoid or not RootPart or not RightArm then
			 return
		 end
		 Humanoid:UnequipTools()
		 local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
		 if not MainTool or not MainTool:FindFirstChild("Handle") then
			 return
		 end
		 local TPlayer = getPlr(Target)
		 local TCharacter = TPlayer and TPlayer.Character
		 local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
		 local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
		 if not THumanoid or not TRootPart then
			 return
		 end
		 Character.Humanoid.Name = "DAttach"
		 local l = Character["DAttach"]:Clone()
		 l.Parent = Character
		 l.Name = "Humanoid"
		 wait()
		 Character["DAttach"]:Destroy()
		 game.Workspace.CurrentCamera.CameraSubject = Character
		 Character.Animate.Disabled = true
		 wait()
		 Character.Animate.Disabled = false
		 Character.Humanoid:EquipTool(MainTool)
		 wait()
		 CF = Player.Character.PrimaryPart.CFrame
		 if firetouchinterest then
			 local flag = false
			 task.defer(function()
				 MainTool.Handle.AncestryChanged:wait()
				 flag = true
			 end)
			 repeat
				 firetouchinterest(MainTool.Handle, TRootPart, 0)
				 firetouchinterest(MainTool.Handle, TRootPart, 1)
				 wait()
				 Player.Character.HumanoidRootPart.CFrame = CF
			 until flag
		 else
			 Player.Character.HumanoidRootPart.CFrame =
			 TCharacter.HumanoidRootPart.CFrame
			 wait()
			 Player.Character.HumanoidRootPart.CFrame =
			 TCharacter.HumanoidRootPart.CFrame
			 wait()
			 Player.Character.HumanoidRootPart.CFrame = CF
			 wait()
		 end
		 wait(.3)
		 Player.Character:SetPrimaryPartCFrame(CF)
		 if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			 Character["Right Arm"].RightGrip:Destroy()
		 else
			 Character["RightHand"].RightGrip:Destroy()
			 Character["RightHand"].RightGripAttachment:Destroy()
		 end
			 
		 wait(4)
	CF = Player.Character.HumanoidRootPart.CFrame
			 player.CharacterAdded:wait(1):waitForChild("HumanoidRootPart").CFrame = CF
						 wait(2)
 until Loopbring == false
 end
 end)
 
 cmd.add({"unloopbring"}, {"unloopbring", "Stops loopbringing a player"}, function()
 Loopbring = false
 end)
 
	 cmd.add({"unloopvoid", "loopv"}, {"unloopvoid (unloopv)", "Unloopingly voiding a player"}, function()
		 Loopvoid = false
	 end)
 
	 cmd.add({"looptornado"}, {"looptornado <player>", "Loop tornados a player endlessly"}, function(...)
		 Username = (...)
		 Looptornado = true
		 repeat wait()
 local target = getPlr(Username)
 local THumanoidPart
 local plrtorso
 local TargetCharacter = target.Character
	if TargetCharacter:FindFirstChild("Torso") then
			plrtorso = TargetCharacter.Torso
		elseif TargetCharacter:FindFirstChild("UpperTorso") then
			plrtorso = TargetCharacter.UpperTorso
		end
		 local old = getChar().HumanoidRootPart.CFrame
		 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
		 if target == nil or tool == nil then return end
		 local attWeld = attachTool(tool,CFrame.new(0,0,0))
		 attachTool(tool,CFrame.new(0,0,0.2) * CFrame.Angles(math.rad(-90),0,0))
		 tool.Grip = plrtorso.CFrame
		 wait(0.07)
 tool.Grip = CFrame.new(0, -7, -3)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,0)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,1)
		 local Spin = Instance.new("BodyAngularVelocity")
	 Spin.Name = "Spinning"
	 Spin.Parent = getRoot(game.Players.LocalPlayer.Character)
	 Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	 Spin.AngularVelocity = Vector3.new(0,40,0)
		 until Looptornado == false
	 end)
 
		 cmd.add({"unlooptornado"}, {"unlooptornado", "Unloop tornadoes a player endlessly"}, function()
 Looptornado = false
		 end)
 
			 cmd.add({"loopcuff", "loopjail"}, {"loopcuff <player> (loopjail)", "Loop cuffs a player endlessly"}, function(...)
				 Username = (...)
				 Loopcuff = true
				 repeat wait()
					 wait(0.15)
 local target = getPlr(Username)
 local THumanoidPart
 local plrtorso
 local TargetCharacter = target.Character
	if TargetCharacter:FindFirstChild("Torso") then
			plrtorso = TargetCharacter.Torso
		elseif TargetCharacter:FindFirstChild("UpperTorso") then
			plrtorso = TargetCharacter.UpperTorso
		end
		 local old = getChar().HumanoidRootPart.CFrame
		 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
		 if target == nil or tool == nil then return end
		 local attWeld = attachTool(tool,CFrame.new(0,0,0))
		 attachTool(tool,CFrame.new(0,0,0.2) * CFrame.Angles(math.rad(-90),0,0))
		 tool.Grip = plrtorso.CFrame
		 wait(0.07)
 tool.Grip = CFrame.new(0, -7, -3)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,0)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,1)
				 until Loopcuff == false
			 end)
 
				 cmd.add({"unloopcuff", "unloopjail"}, {"unloopcuff <player> (unloopjail)", "Unloop cuffs a player endlessly"}, function(...)
 Loopcuff = false
				 end)
 
					 cmd.add({"loopstand"}, {"loopstand <player>", "Loop stands a player endlessly"}, function(...)
						 Username = (...)
						 Loopstand = true
						 repeat wait()
							 wait(0.15)
 
 local target = getPlr(Username)
 local THumanoidPart
 local plrtorso
 local TargetCharacter = target.Character
	if TargetCharacter:FindFirstChild("Torso") then
			plrtorso = TargetCharacter.Torso
		elseif TargetCharacter:FindFirstChild("UpperTorso") then
			plrtorso = TargetCharacter.UpperTorso
		end
		 local old = getChar().HumanoidRootPart.CFrame
		 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
		 if target == nil or tool == nil then return end
		 local attWeld = attachTool(tool,CFrame.new(0,0,0))
		 attachTool(tool,CFrame.new(0,0,0.2) * CFrame.Angles(math.rad(-90),0,0))
			tool.Grip = plrtorso.CFrame
	 wait(0.07)
		 tool.Grip = CFrame.new(0, 3, -1) 
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,0)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,1)
	  wait(1.3)
						 until Loopstand == false
					 end)
 
						 cmd.add({"unloopstand"}, {"unloopstand", "Unloop stands a player endlessly"}, function(...)
							 Loopstand = false
						 end)
 
	 cmd.add({"loopbanish", "looppunish", "loopjail"}, {"loopbanish <player> (loopbanish, loopjail)", "Banishes a player endlessly"}, function(...)
		 Username = (...)
		 Loopbanish = true
		 repeat wait()
			 user = getPlr(Username)
			 plr = user.name
			 Target = plr
			 Player.Character.Humanoid.Name = 1
			 local l = Player.Character["1"]:Clone()
			 l.Parent = Player.Character
			 l.Name = "Humanoid"
			 task.wait()
			 Player.Character["1"]:Destroy()
			 game.Workspace.CurrentCamera.CameraSubject = Player.Character
			 Player.Character.Animate.Disabled = true
			 task.wait()
			 Player.Character.Animate.Disabled = false
			 for i, v in pairs(game:FindService "Players".LocalPlayer.Backpack:GetChildren()) do
				 Player.Character.Humanoid:EquipTool(v)
			 end
			 task.wait()
			 Player.Character.HumanoidRootPart.CFrame = Players[Target].Character.HumanoidRootPart.CFrame
			 task.wait()
			 Player.Character.HumanoidRootPart.CFrame = Players[Target].Character.HumanoidRootPart.CFrame
			 task.wait(0.7)
			 Player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-100000, 1000000000000000000000, -100000))
			 task.wait()
			 task.wait(4)
			 game.Players.LocalPlayer.Character.Humanoid.Health = 0
			 until Loopbanish == false
	 end)
 
	 cmd.add({"unloopbanish", "unloopjail", "unlooppunish"}, {"unloopbanish (unloopjail, unlooppunish)", "Stops loopingly punishing a player"}, function()
		 Loopbanish = false
	 end)
 
	 cmd.add({"unloopfling"}, {"unloopfling", "Stops loop flinging a player"}, function(...)
 Loopvoid = false
	 end)
 
		 cmd.add({"loopkill"}, {"loopkill <player>", "Loop kills a player"}, function(...)
 local Username = (...)
 
 if Username == "all" or Username == "others" then
	 Loopkill = true
	 repeat wait()
   local player_table = game:GetService('Players'):GetPlayers()
		 local toolsInBackpack = 0
		 local toolsEquipped = 0
		 local players = {}
		 local tools = {}
		 
		 for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
				 toolsInBackpack = toolsInBackpack + 1
		 end
		 for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				 if v.ClassName == "Tool" then
						 toolsEquipped = toolsEquipped + 1
				 end
		 end
		 local total_tools = toolsInBackpack + toolsEquipped
		 print(#player_table.." players")
		 
				 for i,v in next, player_table do
						 if v.Character.Humanoid.Sit ~= true and v ~= game:GetService('Players').LocalPlayer and v.Character.Humanoid.Health ~= 0 then
								 table.insert(players, v)
						 end
				 end 
		 
				 local newHum = game.Players.LocalPlayer.Character.Humanoid:Clone()
				 newHum.Parent = game.Players.LocalPlayer.Character
				 game.Players.LocalPlayer.Character.Humanoid:Destroy()
				 newHum:ChangeState(15)
				 for i,v in next, game.Players.LocalPlayer.Backpack:GetChildren() do
						 if v:IsA'Tool' then
								 v.Parent = game.Players.LocalPlayer.Character
						 end
				 end
				 wait(.1)
				 for i,v in next, game.Players.LocalPlayer.Character:GetChildren() do
						 if v:IsA'Tool' then
								 table.insert(tools, v)
						 end
				 end
				 local currentTargets = {}
				 for i, tool in next, tools do
						 tool.Handle.Massless = true
						 tool.Grip = CFrame.new()
						 tool.Grip = tool.Handle.CFrame:ToObjectSpace(players[i].Character.Head.CFrame):Inverse()
				 end
				 local players = {}
						 plr.CharacterAdded:Wait()
		 getChar():WaitForChild("HumanoidRootPart").CFrame = old
	 wait(1)
				 until Loopkill == false
 else
 
			 Loopkill = true
			 repeat wait()
				 local function Kill()
					 if not getPlr(Username) then
					 end
					 
					 repeat game:FindService("RunService").Heartbeat:wait() until getPlr(Username).Character and getPlr(Username).Character:FindFirstChildOfClass("Humanoid") and getPlr(Username).Character:FindFirstChildOfClass("Humanoid").Health > 0
					 local Character
					 local Humanoid
					 local RootPart
					 local Tool
					 local Handle
					 
					 local TPlayer = getPlr(Username)
					 local TCharacter = TPlayer.Character
					 local THumanoid
					 local TRootPart
					 
					 if Player.Character and Player.Character and Player.Character.Name == Player.Name then
						 Character = Player.Character
					 else
					 end
					 if Character:FindFirstChildOfClass("Humanoid") then
						 Humanoid = Character:FindFirstChildOfClass("Humanoid")
					 else
					 end
					 if Humanoid and Humanoid.RootPart then
						 RootPart = Humanoid.RootPart
					 else
					 end
					 if Character:FindFirstChildOfClass("Tool") then
						 Tool = Character:FindFirstChildOfClass("Tool")
					 elseif Player.Backpack:FindFirstChildOfClass("Tool") and Humanoid then
						 Tool = Player.Backpack:FindFirstChildOfClass("Tool")
						 Humanoid:EquipTool(Player.Backpack:FindFirstChildOfClass("Tool"))
					 else
					 end
					 if Tool and Tool:FindFirstChild("Handle") then
						 Handle = Tool.Handle
					 else
					 end
					 
					 --Target
					 if TCharacter:FindFirstChildOfClass("Humanoid") then
						 THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
					 else
										 end
					 if THumanoid.RootPart then
						 TRootPart = THumanoid.RootPart
					 else
					 end
					 
					 if THumanoid.Sit then
					 end
					 
					 local OldCFrame = RootPart.CFrame
					 
					 Humanoid:Destroy()
					 local NewHumanoid = Humanoid:Clone()
					 NewHumanoid.Parent = Character
					 NewHumanoid:UnequipTools()
					 NewHumanoid:EquipTool(Tool)
					 Tool.Parent = workspace
				 
					 local Timer = os.time()
				 
					 repeat
						 if (TRootPart.CFrame.p - RootPart.CFrame.p).Magnitude < 500 then
							 Tool.Grip = CFrame.new()
							 Tool.Grip = Handle.CFrame:ToObjectSpace(TRootPart.CFrame):Inverse()
						 end
						 firetouchinterest(Handle,TRootPart,0)
						 firetouchinterest(Handle,TRootPart,1)
						 game:FindService("RunService").Heartbeat:wait()
					 until Tool.Parent ~= Character or not TPlayer or not TRootPart or THumanoid.Health <= 0 or os.time() > Timer + .20
					 Player.Character = nil
					 NewHumanoid.Health = 0
					 player.CharacterAdded:wait(1)
					 repeat game:FindService("RunService").Heartbeat:wait() until Player.Character:FindFirstChild("HumanoidRootPart")
					 Player.Character.HumanoidRootPart.CFrame = OldCFrame
		 end
			   
				 if not LoopKill then
					 Kill()
				 else
					 while LoopKill do
						 Kill()
					 end
				 end
			 until Loopkill == false
		 end
		 end)
 
			 cmd.add({"unloopkill"}, {"unloopkill", "Stops loop killing a player"}, function()
				 Loopkill = false
			 end)
 
 local netlagtab = {}
 
			 cmd.add({"netlag"}, {"netlag <player>", "If the person is using netless, or any reanimation it glitches them"}, function(...)
			 Username = (...)
 target = getPlr(Username)
 
  table.insert(netlagtab, game:GetService("RunService").Heartbeat:Connect(function()
		 for i,v in pairs(target.Character:GetDescendants()) do
			 if v:IsA("BasePart") then
				 sethiddenproperty(v, "NetworkIsSleeping", true)
			 end
		 end
	 end))
			 end)
 
				 cmd.add({"unnetlag"}, {"unnetlag", "Stops netlegging"}, function()
					for i,v in pairs(netlagtab) do
		 v:Disconnect()
	 end
				 end)
 
				 cmd.add({"noprompt", "nopurchaseprompts"}, {"noprompt (nopurchaseprompts)", "remove the stupid purchase prompt"}, function()
					 
					 
					 
					 wait();
					 
					 Notify({
					 Description = "Purchase prompts have been disabled";
					 Title = "Nameless Admin";
					 Duration = 5;
					 
					 });
					 game.CoreGui.PurchasePrompt.Enabled = false
				 end)
 
				 cmd.add({"prompt", "purchaseprompts"}, {"prompt (purchaseprompts)", "allows the stupid purchase prompt"}, function()
					 
					 
					 
					 wait();
					 
					 Notify({
					 Description = "Purchase prompts have been enabled";
					 Title = "Nameless Admin";
					 Duration = 5;
					 
					 });
					 game.CoreGui.PurchasePrompt.Enabled = true
				 end) 
 
 cmd.add({"wallwalk"}, {"wallwalk", "Makes you walk on walls"}, function()
--[[
local _p = game:WaitForChild("Players")
local _plr = _p.ChildAdded:Wait()
if _plr == _p.LocalPlayer then
	_plr.ChildAdded:Connect(function(cccc)
		if c.Name == "PlayerScriptsLoader" then
			c.Disabled = true
		end
	end)
end
]]
repeat wait()
	a = pcall(function()
		game:WaitForChild("Players").LocalPlayer:WaitForChild("PlayerScripts").ChildAdded:Connect(function(c)
			if c.Name == "PlayerScriptsLoader"then
				c.Disabled = true
			end
		end)
		end)
		if a == true then break end
	until true == false
	game:WaitForChild("Players").LocalPlayer:WaitForChild("PlayerScripts").ChildAdded:Connect(function(c)
		if c.Name == "PlayerScriptsLoader"then
			c.Disabled = true
		end
	end)
	 
	 
	function _CameraUI()
		local Players = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
	 
		local LocalPlayer = Players.LocalPlayer
		if not LocalPlayer then
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end
	 
		local function waitForChildOfClass(parent, class)
			local child = parent:FindFirstChildOfClass(class)
			while not child or child.ClassName ~= class do
				child = parent.ChildAdded:Wait()
			end
			return child
		end
	 
		local PlayerGui = waitForChildOfClass(LocalPlayer, "PlayerGui")
	 
		local TOAST_OPEN_SIZE = UDim2.new(0, 326, 0, 58)
		local TOAST_CLOSED_SIZE = UDim2.new(0, 80, 0, 58)
		local TOAST_BACKGROUND_COLOR = Color3.fromRGB(32, 32, 32)
		local TOAST_BACKGROUND_TRANS = 0.4
		local TOAST_FOREGROUND_COLOR = Color3.fromRGB(200, 200, 200)
		local TOAST_FOREGROUND_TRANS = 0
	 
		-- Convenient syntax for creating a tree of instanes
		local function create(className)
			return function(props)
				local inst = Instance.new(className)
				local parent = props.Parent
				props.Parent = nil
				for name, val in pairs(props) do
					if type(name) == "string" then
						inst[name] = val
					else
						val.Parent = inst
					end
				end
				-- Only set parent after all other properties are initialized
				inst.Parent = parent
				return inst
			end
		end
	 
		local initialized = false
	 
		local uiRoot
		local toast
		local toastIcon
		local toastUpperText
		local toastLowerText
	 
		local function initializeUI()
			assert(not initialized)
	 
			uiRoot = create("ScreenGui"){
				Name = "RbxCameraUI",
				AutoLocalize = false,
				Enabled = true,
				DisplayOrder = -1, -- Appears behind default developer UI
				IgnoreGuiInset = false,
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	 
				create("ImageLabel"){
					Name = "Toast",
					Visible = false,
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 8),
					Size = TOAST_CLOSED_SIZE,
					Image = "rbxasset://textures/ui/Camera/CameraToast9Slice.png",
					ImageColor3 = TOAST_BACKGROUND_COLOR,
					ImageRectSize = Vector2.new(6, 6),
					ImageTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(3, 3, 3, 3),
					ClipsDescendants = true,
	 
					create("Frame"){
						Name = "IconBuffer",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(0, 80, 1, 0),
	 
						create("ImageLabel"){
							Name = "Icon",
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 48, 0, 48),
							ZIndex = 2,
							Image = "rbxasset://textures/ui/Camera/CameraToastIcon.png",
							ImageColor3 = TOAST_FOREGROUND_COLOR,
							ImageTransparency = 1,
						}
					},
	 
					create("Frame"){
						Name = "TextBuffer",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 80, 0, 0),
						Size = UDim2.new(1, -80, 1, 0),
						ClipsDescendants = true,
	 
						create("TextLabel"){
							Name = "Upper",
							AnchorPoint = Vector2.new(0, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 19),
							Font = Enum.Font.GothamSemibold,
							Text = "Camera control enabled",
							TextColor3 = TOAST_FOREGROUND_COLOR,
							TextTransparency = 1,
							TextSize = 19,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
						},
	 
						create("TextLabel"){
							Name = "Lower",
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0.5, 3),
							Size = UDim2.new(1, 0, 0, 15),
							Font = Enum.Font.Gotham,
							Text = "Right mouse button to toggle",
							TextColor3 = TOAST_FOREGROUND_COLOR,
							TextTransparency = 1,
							TextSize = 15,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
						},
					},
				},
	 
				Parent = PlayerGui,
			}
	 
			toast = uiRoot.Toast
			toastIcon = toast.IconBuffer.Icon
			toastUpperText = toast.TextBuffer.Upper
			toastLowerText = toast.TextBuffer.Lower
	 
			initialized = true
		end
	 
		local CameraUI = {}
	 
		do
			-- Instantaneously disable the toast or enable for opening later on. Used when switching camera modes.
			function CameraUI.setCameraModeToastEnabled(enabled)
				if not enabled and not initialized then
					return
				end
	 
				if not initialized then
					initializeUI()
				end
	 
				toast.Visible = enabled
				if not enabled then
					CameraUI.setCameraModeToastOpen(false)
				end
			end
	 
			local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	 
			-- Tween the toast in or out. Toast must be enabled with setCameraModeToastEnabled.
			function CameraUI.setCameraModeToastOpen(open)
				assert(initialized)
	 
				TweenService:Create(toast, tweenInfo, {
					Size = open and TOAST_OPEN_SIZE or TOAST_CLOSED_SIZE,
					ImageTransparency = open and TOAST_BACKGROUND_TRANS or 1,
				}):Play()
	 
				TweenService:Create(toastIcon, tweenInfo, {
					ImageTransparency = open and TOAST_FOREGROUND_TRANS or 1,
				}):Play()
	 
				TweenService:Create(toastUpperText, tweenInfo, {
					TextTransparency = open and TOAST_FOREGROUND_TRANS or 1,
				}):Play()
	 
				TweenService:Create(toastLowerText, tweenInfo, {
					TextTransparency = open and TOAST_FOREGROUND_TRANS or 1,
				}):Play()
			end
		end
	 
		return CameraUI
	end
	 
	function _CameraToggleStateController()
		local Players = game:GetService("Players")
		local UserInputService = game:GetService("UserInputService")
		local GameSettings = UserSettings():GetService("UserGameSettings")
	 
		local LocalPlayer = Players.LocalPlayer
		if not LocalPlayer then
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end
	 
		local Mouse = LocalPlayer:GetMouse()
	 
		local Input = _CameraInput()
		local CameraUI = _CameraUI()
	 
		local lastTogglePan = false
		local lastTogglePanChange = tick()
	 
		local CROSS_MOUSE_ICON = "rbxasset://textures/Cursors/CrossMouseIcon.png"
	 
		local lockStateDirty = false
		local wasTogglePanOnTheLastTimeYouWentIntoFirstPerson = false
		local lastFirstPerson = false
	 
		CameraUI.setCameraModeToastEnabled(false)
	 
		return function(isFirstPerson)
			local togglePan = Input.getTogglePan()
			local toastTimeout = 3
	 
			if isFirstPerson and togglePan ~= lastTogglePan then
				lockStateDirty = true
			end
	 
			if lastTogglePan ~= togglePan or tick() - lastTogglePanChange > toastTimeout then
				local doShow = togglePan and tick() - lastTogglePanChange < toastTimeout
	 
				CameraUI.setCameraModeToastOpen(doShow)
	 
				if togglePan then
					lockStateDirty = false
				end
				lastTogglePanChange = tick()
				lastTogglePan = togglePan
			end
	 
			if isFirstPerson ~= lastFirstPerson then
				if isFirstPerson then
					wasTogglePanOnTheLastTimeYouWentIntoFirstPerson = Input.getTogglePan()
					Input.setTogglePan(true)
				elseif not lockStateDirty then
					Input.setTogglePan(wasTogglePanOnTheLastTimeYouWentIntoFirstPerson)
				end
			end
	 
			if isFirstPerson then
				if Input.getTogglePan() then
					Mouse.Icon = CROSS_MOUSE_ICON
					UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
					--GameSettings.RotationType = Enum.RotationType.CameraRelative
				else
					Mouse.Icon = ""
					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
					--GameSettings.RotationType = Enum.RotationType.CameraRelative
				end
	 
			elseif Input.getTogglePan() then
				Mouse.Icon = CROSS_MOUSE_ICON
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
				GameSettings.RotationType = Enum.RotationType.MovementRelative
	 
			elseif Input.getHoldPan() then
				Mouse.Icon = ""
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				GameSettings.RotationType = Enum.RotationType.MovementRelative
	 
			else
				Mouse.Icon = ""
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				GameSettings.RotationType = Enum.RotationType.MovementRelative
			end
	 
			lastFirstPerson = isFirstPerson
		end
	end
	 
	function _CameraInput()
		local UserInputService = game:GetService("UserInputService")
	 
		local MB_TAP_LENGTH = 0.3 -- length of time for a short mouse button tap to be registered
	 
		local rmbDown, rmbUp
		do
			local rmbDownBindable = Instance.new("BindableEvent")
			local rmbUpBindable = Instance.new("BindableEvent")
	 
			rmbDown = rmbDownBindable.Event
			rmbUp = rmbUpBindable.Event
	 
			UserInputService.InputBegan:Connect(function(input, gpe)
				if not gpe and input.UserInputType == Enum.UserInputType.MouseButton2 then
					rmbDownBindable:Fire()
				end
			end)
	 
			UserInputService.InputEnded:Connect(function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					rmbUpBindable:Fire()
				end
			end)
		end
	 
		local holdPan = false
		local togglePan = false
		local lastRmbDown = 0 -- tick() timestamp of the last right mouse button down event
	 
		local CameraInput = {}
	 
		function CameraInput.getHoldPan()
			return holdPan
		end
	 
		function CameraInput.getTogglePan()
			return togglePan
		end
	 
		function CameraInput.getPanning()
			return togglePan or holdPan
		end
	 
		function CameraInput.setTogglePan(value)
			togglePan = value
		end
	 
		local cameraToggleInputEnabled = false
		local rmbDownConnection
		local rmbUpConnection
	 
		function CameraInput.enableCameraToggleInput()
			if cameraToggleInputEnabled then
				return
			end
			cameraToggleInputEnabled = true
	 
			holdPan = false
			togglePan = false
	 
			if rmbDownConnection then
				rmbDownConnection:Disconnect()
			end
	 
			if rmbUpConnection then
				rmbUpConnection:Disconnect()
			end
	 
			rmbDownConnection = rmbDown:Connect(function()
				holdPan = true
				lastRmbDown = tick()
			end)
	 
			rmbUpConnection = rmbUp:Connect(function()
				holdPan = false
				if tick() - lastRmbDown < MB_TAP_LENGTH and (togglePan or UserInputService:GetMouseDelta().Magnitude < 2) then
					togglePan = not togglePan
				end
			end)
		end
	 
		function CameraInput.disableCameraToggleInput()
			if not cameraToggleInputEnabled then
				return
			end
			cameraToggleInputEnabled = false
	 
			if rmbDownConnection then
				rmbDownConnection:Disconnect()
				rmbDownConnection = nil
			end
			if rmbUpConnection then
				rmbUpConnection:Disconnect()
				rmbUpConnection = nil
			end
		end
	 
		return CameraInput
	end
	 
	function _BaseCamera()
		--[[
			BaseCamera - Abstract base class for camera control modules
			2018 Camera Update - AllYourBlox
		--]]
	 
		--[[ Local Constants ]]--
		local UNIT_Z = Vector3.new(0,0,1)
		local X1_Y0_Z1 = Vector3.new(1,0,1)	--Note: not a unit vector, used for projecting onto XZ plane
	 
		local THUMBSTICK_DEADZONE = 0.2
		local DEFAULT_DISTANCE = 12.5	-- Studs
		local PORTRAIT_DEFAULT_DISTANCE = 25		-- Studs
		local FIRST_PERSON_DISTANCE_THRESHOLD = 1.0 -- Below this value, snap into first person
	 
		local CAMERA_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
	 
		-- Note: DotProduct check in CoordinateFrame::lookAt() prevents using values within about
		-- 8.11 degrees of the +/- Y axis, that's why these limits are currently 80 degrees
		local MIN_Y = math.rad(-80)
		local MAX_Y = math.rad(80)
	 
		local TOUCH_ADJUST_AREA_UP = math.rad(30)
		local TOUCH_ADJUST_AREA_DOWN = math.rad(-15)
	 
		local TOUCH_SENSITIVTY_ADJUST_MAX_Y = 2.1
		local TOUCH_SENSITIVTY_ADJUST_MIN_Y = 0.5
	 
		local VR_ANGLE = math.rad(15)
		local VR_LOW_INTENSITY_ROTATION = Vector2.new(math.rad(15), 0)
		local VR_HIGH_INTENSITY_ROTATION = Vector2.new(math.rad(45), 0)
		local VR_LOW_INTENSITY_REPEAT = 0.1
		local VR_HIGH_INTENSITY_REPEAT = 0.4
	 
		local ZERO_VECTOR2 = Vector2.new(0,0)
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
	 
		local TOUCH_SENSITIVTY = Vector2.new(0.00945 * math.pi, 0.003375 * math.pi)
		local MOUSE_SENSITIVITY = Vector2.new( 0.002 * math.pi, 0.0015 * math.pi )
	 
		local SEAT_OFFSET = Vector3.new(0,5,0)
		local VR_SEAT_OFFSET = Vector3.new(0,4,0)
		local HEAD_OFFSET = Vector3.new(0,1.5,0)
		local R15_HEAD_OFFSET = Vector3.new(0, 1.5, 0)
		local R15_HEAD_OFFSET_NO_SCALING = Vector3.new(0, 2, 0)
		local HUMANOID_ROOT_PART_SIZE = Vector3.new(2, 2, 1)
	 
		local GAMEPAD_ZOOM_STEP_1 = 0
		local GAMEPAD_ZOOM_STEP_2 = 10
		local GAMEPAD_ZOOM_STEP_3 = 20
	 
		local PAN_SENSITIVITY = 20
		local ZOOM_SENSITIVITY_CURVATURE = 0.5
	 
		local abs = math.abs
		local sign = math.sign
	 
		local FFlagUserCameraToggle do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserCameraToggle")
			end)
			FFlagUserCameraToggle = success and result
		end
	 
		local FFlagUserDontAdjustSensitvityForPortrait do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserDontAdjustSensitvityForPortrait")
			end)
			FFlagUserDontAdjustSensitvityForPortrait = success and result
		end
	 
		local FFlagUserFixZoomInZoomOutDiscrepancy do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserFixZoomInZoomOutDiscrepancy")
			end)
			FFlagUserFixZoomInZoomOutDiscrepancy = success and result
		end
	 
		local Util = _CameraUtils()
		local ZoomController = _ZoomController()
		local CameraToggleStateController = _CameraToggleStateController()
		local CameraInput = _CameraInput()
		local CameraUI = _CameraUI()
	 
		--[[ Roblox Services ]]--
		local Players = game:GetService("Players")
		local UserInputService = game:GetService("UserInputService")
		local StarterGui = game:GetService("StarterGui")
		local GuiService = game:GetService("GuiService")
		local ContextActionService = game:GetService("ContextActionService")
		local VRService = game:GetService("VRService")
		local UserGameSettings = UserSettings():GetService("UserGameSettings")
	 
		local player = Players.LocalPlayer 
	 
		--[[ The Module ]]--
		local BaseCamera = {}
		BaseCamera.__index = BaseCamera
	 
		function BaseCamera.new()
			local self = setmetatable({}, BaseCamera)
	 
			-- So that derived classes have access to this
			self.FIRST_PERSON_DISTANCE_THRESHOLD = FIRST_PERSON_DISTANCE_THRESHOLD
	 
			self.cameraType = nil
			self.cameraMovementMode = nil
	 
			self.lastCameraTransform = nil
			self.rotateInput = ZERO_VECTOR2
			self.userPanningCamera = false
			self.lastUserPanCamera = tick()
	 
			self.humanoidRootPart = nil
			self.humanoidCache = {}
	 
			-- Subject and position on last update call
			self.lastSubject = nil
			self.lastSubjectPosition = Vector3.new(0,5,0)
	 
			-- These subject distance members refer to the nominal camera-to-subject follow distance that the camera
			-- is trying to maintain, not the actual measured value.
			-- The default is updated when screen orientation or the min/max distances change,
			-- to be sure the default is always in range and appropriate for the orientation.
			self.defaultSubjectDistance = math.clamp(DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
			self.currentSubjectDistance = math.clamp(DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
	 
			self.inFirstPerson = false
			self.inMouseLockedMode = false
			self.portraitMode = false
			self.isSmallTouchScreen = false
	 
			-- Used by modules which want to reset the camera angle on respawn.
			self.resetCameraAngle = true
	 
			self.enabled = false
	 
			-- Input Event Connections
			self.inputBeganConn = nil
			self.inputChangedConn = nil
			self.inputEndedConn = nil
	 
			self.startPos = nil
			self.lastPos = nil
			self.panBeginLook = nil
	 
			self.panEnabled = true
			self.keyPanEnabled = true
			self.distanceChangeEnabled = true
	 
			self.PlayerGui = nil
	 
			self.cameraChangedConn = nil
			self.viewportSizeChangedConn = nil
	 
			self.boundContextActions = {}
	 
			-- VR Support
			self.shouldUseVRRotation = false
			self.VRRotationIntensityAvailable = false
			self.lastVRRotationIntensityCheckTime = 0
			self.lastVRRotationTime = 0
			self.vrRotateKeyCooldown = {}
			self.cameraTranslationConstraints = Vector3.new(1, 1, 1)
			self.humanoidJumpOrigin = nil
			self.trackingHumanoid = nil
			self.cameraFrozen = false
			self.subjectStateChangedConn = nil
	 
			-- Gamepad support
			self.activeGamepad = nil
			self.gamepadPanningCamera = false
			self.lastThumbstickRotate = nil
			self.numOfSeconds = 0.7
			self.currentSpeed = 0
			self.maxSpeed = 6
			self.vrMaxSpeed = 4
			self.lastThumbstickPos = Vector2.new(0,0)
			self.ySensitivity = 0.65
			self.lastVelocity = nil
			self.gamepadConnectedConn = nil
			self.gamepadDisconnectedConn = nil
			self.currentZoomSpeed = 1.0
			self.L3ButtonDown = false
			self.dpadLeftDown = false
			self.dpadRightDown = false
	 
			-- Touch input support
			self.isDynamicThumbstickEnabled = false
			self.fingerTouches = {}
			self.dynamicTouchInput = nil
			self.numUnsunkTouches = 0
			self.inputStartPositions = {}
			self.inputStartTimes = {}
			self.startingDiff = nil
			self.pinchBeginZoom = nil
			self.userPanningTheCamera = false
			self.touchActivateConn = nil
	 
			-- Mouse locked formerly known as shift lock mode
			self.mouseLockOffset = ZERO_VECTOR3
	 
			-- [[ NOTICE ]] --
			-- Initialization things used to always execute at game load time, but now these camera modules are instantiated
			-- when needed, so the code here may run well after the start of the game
	 
			if player.Character then
				self:OnCharacterAdded(player.Character)
			end
	 
			player.CharacterAdded:Connect(function(char)
				self:OnCharacterAdded(char)
			end)
	 
			if self.cameraChangedConn then self.cameraChangedConn:Disconnect() end
			self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				self:OnCurrentCameraChanged()
			end)
			self:OnCurrentCameraChanged()
	 
			if self.playerCameraModeChangeConn then self.playerCameraModeChangeConn:Disconnect() end
			self.playerCameraModeChangeConn = player:GetPropertyChangedSignal("CameraMode"):Connect(function()
				self:OnPlayerCameraPropertyChange()
			end)
	 
			if self.minDistanceChangeConn then self.minDistanceChangeConn:Disconnect() end
			self.minDistanceChangeConn = player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
				self:OnPlayerCameraPropertyChange()
			end)
	 
			if self.maxDistanceChangeConn then self.maxDistanceChangeConn:Disconnect() end
			self.maxDistanceChangeConn = player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
				self:OnPlayerCameraPropertyChange()
			end)
	 
			if self.playerDevTouchMoveModeChangeConn then self.playerDevTouchMoveModeChangeConn:Disconnect() end
			self.playerDevTouchMoveModeChangeConn = player:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
				self:OnDevTouchMovementModeChanged()
			end)
			self:OnDevTouchMovementModeChanged() -- Init
	 
			if self.gameSettingsTouchMoveMoveChangeConn then self.gameSettingsTouchMoveMoveChangeConn:Disconnect() end
			self.gameSettingsTouchMoveMoveChangeConn = UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
				self:OnGameSettingsTouchMovementModeChanged()
			end)
			self:OnGameSettingsTouchMovementModeChanged() -- Init
	 
			UserGameSettings:SetCameraYInvertVisible()
			UserGameSettings:SetGamepadCameraSensitivityVisible()
	 
			self.hasGameLoaded = game:IsLoaded()
			if not self.hasGameLoaded then
				self.gameLoadedConn = game.Loaded:Connect(function()
					self.hasGameLoaded = true
					self.gameLoadedConn:Disconnect()
					self.gameLoadedConn = nil
				end)
			end
	 
			self:OnPlayerCameraPropertyChange()
	 
			return self
		end
	 
		function BaseCamera:GetModuleName()
			return "BaseCamera"
		end
	 
		function BaseCamera:OnCharacterAdded(char)
			self.resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
			self.humanoidRootPart = nil
			if UserInputService.TouchEnabled then
				self.PlayerGui = player:WaitForChild("PlayerGui")
				for _, child in ipairs(char:GetChildren()) do
					if child:IsA("Tool") then
						self.isAToolEquipped = true
					end
				end
				char.ChildAdded:Connect(function(child)
					if child:IsA("Tool") then
						self.isAToolEquipped = true
					end
				end)
				char.ChildRemoved:Connect(function(child)
					if child:IsA("Tool") then
						self.isAToolEquipped = false
					end
				end)
			end
		end
	 
		function BaseCamera:GetHumanoidRootPart()
			if not self.humanoidRootPart then
				if player.Character then
					local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						self.humanoidRootPart = humanoid.RootPart
					end
				end
			end
			return self.humanoidRootPart
		end
	 
		function BaseCamera:GetBodyPartToFollow(humanoid, isDead)
			-- If the humanoid is dead, prefer the head part if one still exists as a sibling of the humanoid
			if humanoid:GetState() == Enum.HumanoidStateType.Dead then
				local character = humanoid.Parent
				if character and character:IsA("Model") then
					return character:FindFirstChild("Head") or humanoid.RootPart
				end
			end
	 
			return humanoid.RootPart
		end
	 
		function BaseCamera:GetSubjectPosition()
			local result = self.lastSubjectPosition
			local camera = game.Workspace.CurrentCamera
			local cameraSubject = camera and camera.CameraSubject
	 
			if cameraSubject then
				if cameraSubject:IsA("Humanoid") then
					local humanoid = cameraSubject
					local humanoidIsDead = humanoid:GetState() == Enum.HumanoidStateType.Dead
	 
					if VRService.VREnabled and humanoidIsDead and humanoid == self.lastSubject then
						result = self.lastSubjectPosition
					else
						local bodyPartToFollow = humanoid.RootPart
	 
						-- If the humanoid is dead, prefer their head part as a follow target, if it exists
						if humanoidIsDead then
							if humanoid.Parent and humanoid.Parent:IsA("Model") then
								bodyPartToFollow = humanoid.Parent:FindFirstChild("Head") or bodyPartToFollow
							end
						end
	 
						if bodyPartToFollow and bodyPartToFollow:IsA("BasePart") then
							local heightOffset
							if humanoid.RigType == Enum.HumanoidRigType.R15 then
								if humanoid.AutomaticScalingEnabled then
									heightOffset = R15_HEAD_OFFSET
									if bodyPartToFollow == humanoid.RootPart then
										local rootPartSizeOffset = (humanoid.RootPart.Size.Y/2) - (HUMANOID_ROOT_PART_SIZE.Y/2)
										heightOffset = heightOffset + Vector3.new(0, rootPartSizeOffset, 0)
									end
								else
									heightOffset = R15_HEAD_OFFSET_NO_SCALING
								end
							else
								heightOffset = HEAD_OFFSET
							end
	 
							if humanoidIsDead then
								heightOffset = ZERO_VECTOR3
							end
	 
							result = bodyPartToFollow.CFrame.p + bodyPartToFollow.CFrame:vectorToWorldSpace(heightOffset + humanoid.CameraOffset)
						end
					end
	 
				elseif cameraSubject:IsA("VehicleSeat") then
					local offset = SEAT_OFFSET
					if VRService.VREnabled then
						offset = VR_SEAT_OFFSET
					end
					result = cameraSubject.CFrame.p + cameraSubject.CFrame:vectorToWorldSpace(offset)
				elseif cameraSubject:IsA("SkateboardPlatform") then
					result = cameraSubject.CFrame.p + SEAT_OFFSET
				elseif cameraSubject:IsA("BasePart") then
					result = cameraSubject.CFrame.p
				elseif cameraSubject:IsA("Model") then
					if cameraSubject.PrimaryPart then
						result = cameraSubject:GetPrimaryPartCFrame().p
					else
						result = cameraSubject:GetModelCFrame().p
					end
				end
			else
				-- cameraSubject is nil
				-- Note: Previous RootCamera did not have this else case and let self.lastSubject and self.lastSubjectPosition
				-- both get set to nil in the case of cameraSubject being nil. This function now exits here to preserve the
				-- last set valid values for these, as nil values are not handled cases
				return
			end
	 
			self.lastSubject = cameraSubject
			self.lastSubjectPosition = result
	 
			return result
		end
	 
		function BaseCamera:UpdateDefaultSubjectDistance()
			if self.portraitMode then
				self.defaultSubjectDistance = math.clamp(PORTRAIT_DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
			else
				self.defaultSubjectDistance = math.clamp(DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
			end
		end
	 
		function BaseCamera:OnViewportSizeChanged()
			local camera = game.Workspace.CurrentCamera
			local size = camera.ViewportSize
			self.portraitMode = size.X < size.Y
			self.isSmallTouchScreen = UserInputService.TouchEnabled and (size.Y < 500 or size.X < 700)
	 
			self:UpdateDefaultSubjectDistance()
		end
	 
		-- Listener for changes to workspace.CurrentCamera
		function BaseCamera:OnCurrentCameraChanged()
			if UserInputService.TouchEnabled then
				if self.viewportSizeChangedConn then
					self.viewportSizeChangedConn:Disconnect()
					self.viewportSizeChangedConn = nil
				end
	 
				local newCamera = game.Workspace.CurrentCamera
	 
				if newCamera then
					self:OnViewportSizeChanged()
					self.viewportSizeChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
						self:OnViewportSizeChanged()
					end)
				end
			end
	 
			-- VR support additions
			if self.cameraSubjectChangedConn then
				self.cameraSubjectChangedConn:Disconnect()
				self.cameraSubjectChangedConn = nil
			end
	 
			local camera = game.Workspace.CurrentCamera
			if camera then
				self.cameraSubjectChangedConn = camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
					self:OnNewCameraSubject()
				end)
				self:OnNewCameraSubject()
			end
		end
	 
		function BaseCamera:OnDynamicThumbstickEnabled()
			if UserInputService.TouchEnabled then
				self.isDynamicThumbstickEnabled = true
			end
		end
	 
		function BaseCamera:OnDynamicThumbstickDisabled()
			self.isDynamicThumbstickEnabled = false
		end
	 
		function BaseCamera:OnGameSettingsTouchMovementModeChanged()
			if player.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
				if (UserGameSettings.TouchMovementMode == Enum.TouchMovementMode.DynamicThumbstick
					or UserGameSettings.TouchMovementMode == Enum.TouchMovementMode.Default) then
					self:OnDynamicThumbstickEnabled()
				else
					self:OnDynamicThumbstickDisabled()
				end
			end
		end
	 
		function BaseCamera:OnDevTouchMovementModeChanged()
			if player.DevTouchMovementMode.Name == "DynamicThumbstick" then
				self:OnDynamicThumbstickEnabled()
			else
				self:OnGameSettingsTouchMovementModeChanged()
			end
		end
	 
		function BaseCamera:OnPlayerCameraPropertyChange()
			-- This call forces re-evaluation of player.CameraMode and clamping to min/max distance which may have changed
			self:SetCameraToSubjectDistance(self.currentSubjectDistance)
		end
	 
		function BaseCamera:GetCameraHeight()
			if VRService.VREnabled and not self.inFirstPerson then
				return math.sin(VR_ANGLE) * self.currentSubjectDistance
			end
			return 0
		end
	 
		function BaseCamera:InputTranslationToCameraAngleChange(translationVector, sensitivity)
			if not FFlagUserDontAdjustSensitvityForPortrait then
				local camera = game.Workspace.CurrentCamera
				if camera and camera.ViewportSize.X > 0 and camera.ViewportSize.Y > 0 and (camera.ViewportSize.Y > camera.ViewportSize.X) then
					-- Screen has portrait orientation, swap X and Y sensitivity
					return translationVector * Vector2.new( sensitivity.Y, sensitivity.X)
				end
			end
			return translationVector * sensitivity
		end
	 
		function BaseCamera:Enable(enable)
			if self.enabled ~= enable then
				self.enabled = enable
				if self.enabled then
					self:ConnectInputEvents()
					self:BindContextActions()
	 
					if player.CameraMode == Enum.CameraMode.LockFirstPerson then
						self.currentSubjectDistance = 0.5
						if not self.inFirstPerson then
							self:EnterFirstPerson()
						end
					end
				else
					self:DisconnectInputEvents()
					self:UnbindContextActions()
					-- Clean up additional event listeners and reset a bunch of properties
					self:Cleanup()
				end
			end
		end
	 
		function BaseCamera:GetEnabled()
			return self.enabled
		end
	 
		function BaseCamera:OnInputBegan(input, processed)
			if input.UserInputType == Enum.UserInputType.Touch then
				self:OnTouchBegan(input, processed)
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				self:OnMouse2Down(input, processed)
			elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
				self:OnMouse3Down(input, processed)
			end
		end
	 
		function BaseCamera:OnInputChanged(input, processed)
			if input.UserInputType == Enum.UserInputType.Touch then
				self:OnTouchChanged(input, processed)
			elseif input.UserInputType == Enum.UserInputType.MouseMovement then
				self:OnMouseMoved(input, processed)
			end
		end
	 
		function BaseCamera:OnInputEnded(input, processed)
			if input.UserInputType == Enum.UserInputType.Touch then
				self:OnTouchEnded(input, processed)
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				self:OnMouse2Up(input, processed)
			elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
				self:OnMouse3Up(input, processed)
			end
		end
	 
		function BaseCamera:OnPointerAction(wheel, pan, pinch, processed)
			if processed then
				return
			end
	 
			if pan.Magnitude > 0 then
				local inversionVector = Vector2.new(1, UserGameSettings:GetCameraYInvertValue())
				local rotateDelta = self:InputTranslationToCameraAngleChange(PAN_SENSITIVITY*pan, MOUSE_SENSITIVITY)*inversionVector
				self.rotateInput = self.rotateInput + rotateDelta
			end
	 
			local zoom = self.currentSubjectDistance
			local zoomDelta = -(wheel + pinch)
	 
			if abs(zoomDelta) > 0 then
				local newZoom
				if self.inFirstPerson and zoomDelta > 0 then
					newZoom = FIRST_PERSON_DISTANCE_THRESHOLD
				else
					if FFlagUserFixZoomInZoomOutDiscrepancy then
						if (zoomDelta > 0) then
							newZoom = zoom + zoomDelta*(1 + zoom*ZOOM_SENSITIVITY_CURVATURE)
						else
							newZoom = (zoom + zoomDelta) / (1 - zoomDelta*ZOOM_SENSITIVITY_CURVATURE)
						end
					else
						newZoom = zoom + zoomDelta*(1 + zoom*ZOOM_SENSITIVITY_CURVATURE)
					end
				end
	 
				self:SetCameraToSubjectDistance(newZoom)
			end
		end
	 
		function BaseCamera:ConnectInputEvents()
			self.pointerActionConn = UserInputService.PointerAction:Connect(function(wheel, pan, pinch, processed)
				self:OnPointerAction(wheel, pan, pinch, processed)
			end)
	 
			self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
				self:OnInputBegan(input, processed)
			end)
	 
			self.inputChangedConn = UserInputService.InputChanged:Connect(function(input, processed)
				self:OnInputChanged(input, processed)
			end)
	 
			self.inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
				self:OnInputEnded(input, processed)
			end)
	 
			self.menuOpenedConn = GuiService.MenuOpened:connect(function()
				self:ResetInputStates()
			end)
	 
			self.gamepadConnectedConn = UserInputService.GamepadDisconnected:connect(function(gamepadEnum)
				if self.activeGamepad ~= gamepadEnum then return end
				self.activeGamepad = nil
				self:AssignActivateGamepad()
			end)
	 
			self.gamepadDisconnectedConn = UserInputService.GamepadConnected:connect(function(gamepadEnum)
				if self.activeGamepad == nil then
					self:AssignActivateGamepad()
				end
			end)
	 
			self:AssignActivateGamepad()
			if not FFlagUserCameraToggle then
				self:UpdateMouseBehavior()
			end
		end
	 
		function BaseCamera:BindContextActions()
			self:BindGamepadInputActions()
			self:BindKeyboardInputActions()
		end
	 
		function BaseCamera:AssignActivateGamepad()
			local connectedGamepads = UserInputService:GetConnectedGamepads()
			if #connectedGamepads > 0 then
				for i = 1, #connectedGamepads do
					if self.activeGamepad == nil then
						self.activeGamepad = connectedGamepads[i]
					elseif connectedGamepads[i].Value < self.activeGamepad.Value then
						self.activeGamepad = connectedGamepads[i]
					end
				end
			end
	 
			if self.activeGamepad == nil then -- nothing is connected, at least set up for gamepad1
				self.activeGamepad = Enum.UserInputType.Gamepad1
			end
		end
	 
		function BaseCamera:DisconnectInputEvents()
			if self.inputBeganConn then
				self.inputBeganConn:Disconnect()
				self.inputBeganConn = nil
			end
			if self.inputChangedConn then
				self.inputChangedConn:Disconnect()
				self.inputChangedConn = nil
			end
			if self.inputEndedConn then
				self.inputEndedConn:Disconnect()
				self.inputEndedConn = nil
			end
		end
	 
		function BaseCamera:UnbindContextActions()
			for i = 1, #self.boundContextActions do
				ContextActionService:UnbindAction(self.boundContextActions[i])
			end
			self.boundContextActions = {}
		end
	 
		function BaseCamera:Cleanup()
			if self.pointerActionConn then
				self.pointerActionConn:Disconnect()
				self.pointerActionConn = nil
			end
			if self.menuOpenedConn then
				self.menuOpenedConn:Disconnect()
				self.menuOpenedConn = nil
			end
			if self.mouseLockToggleConn then
				self.mouseLockToggleConn:Disconnect()
				self.mouseLockToggleConn = nil
			end
			if self.gamepadConnectedConn then
				self.gamepadConnectedConn:Disconnect()
				self.gamepadConnectedConn = nil
			end
			if self.gamepadDisconnectedConn then
				self.gamepadDisconnectedConn:Disconnect()
				self.gamepadDisconnectedConn = nil
			end
			if self.subjectStateChangedConn then
				self.subjectStateChangedConn:Disconnect()
				self.subjectStateChangedConn = nil
			end
			if self.viewportSizeChangedConn then
				self.viewportSizeChangedConn:Disconnect()
				self.viewportSizeChangedConn = nil
			end
			if self.touchActivateConn then
				self.touchActivateConn:Disconnect()
				self.touchActivateConn = nil
			end
	 
			self.turningLeft = false
			self.turningRight = false
			self.lastCameraTransform = nil
			self.lastSubjectCFrame = nil
			self.userPanningTheCamera = false
			self.rotateInput = Vector2.new()
			self.gamepadPanningCamera = Vector2.new(0,0)
	 
			-- Reset input states
			self.startPos = nil
			self.lastPos = nil
			self.panBeginLook = nil
			self.isRightMouseDown = false
			self.isMiddleMouseDown = false
	 
			self.fingerTouches = {}
			self.dynamicTouchInput = nil
			self.numUnsunkTouches = 0
	 
			self.startingDiff = nil
			self.pinchBeginZoom = nil
	 
			-- Unlock mouse for example if right mouse button was being held down
			if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
		end
	 
		-- This is called when settings menu is opened
		function BaseCamera:ResetInputStates()
			self.isRightMouseDown = false
			self.isMiddleMouseDown = false
			self:OnMousePanButtonReleased() -- this function doesn't seem to actually need parameters
	 
			if UserInputService.TouchEnabled then
				--[[menu opening was causing serious touch issues
				this should disable all active touch events if
				they're active when menu opens.]]
				for inputObject in pairs(self.fingerTouches) do
					self.fingerTouches[inputObject] = nil
				end
				self.dynamicTouchInput = nil
				self.panBeginLook = nil
				self.startPos = nil
				self.lastPos = nil
				self.userPanningTheCamera = false
				self.startingDiff = nil
				self.pinchBeginZoom = nil
				self.numUnsunkTouches = 0
			end
		end
	 
		function BaseCamera:GetGamepadPan(name, state, input)
			if input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.Thumbstick2 then
		--		if self.L3ButtonDown then
		--			-- L3 Thumbstick is depressed, right stick controls dolly in/out
		--			if (input.Position.Y > THUMBSTICK_DEADZONE) then
		--				self.currentZoomSpeed = 0.96
		--			elseif (input.Position.Y < -THUMBSTICK_DEADZONE) then
		--				self.currentZoomSpeed = 1.04
		--			else
		--				self.currentZoomSpeed = 1.00
		--			end
		--		else
					if state == Enum.UserInputState.Cancel then
						self.gamepadPanningCamera = ZERO_VECTOR2
						return
					end
	 
					local inputVector = Vector2.new(input.Position.X, -input.Position.Y)
					if inputVector.magnitude > THUMBSTICK_DEADZONE then
						self.gamepadPanningCamera = Vector2.new(input.Position.X, -input.Position.Y)
					else
						self.gamepadPanningCamera = ZERO_VECTOR2
					end
				--end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
	 
		function BaseCamera:DoKeyboardPanTurn(name, state, input)
			if not self.hasGameLoaded and VRService.VREnabled then
				return Enum.ContextActionResult.Pass
			end
	 
			if state == Enum.UserInputState.Cancel then
				self.turningLeft = false
				self.turningRight = false
				return Enum.ContextActionResult.Sink
			end
	 
			if self.panBeginLook == nil and self.keyPanEnabled then
				if input.KeyCode == Enum.KeyCode.Left then
					self.turningLeft = state == Enum.UserInputState.Begin
				elseif input.KeyCode == Enum.KeyCode.Right then
					self.turningRight = state == Enum.UserInputState.Begin
				end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
	 
		function BaseCamera:DoPanRotateCamera(rotateAngle)
			local angle = Util.RotateVectorByAngleAndRound(self:GetCameraLookVector() * Vector3.new(1,0,1), rotateAngle, math.pi*0.25)
			if angle ~= 0 then
				self.rotateInput = self.rotateInput + Vector2.new(angle, 0)
				self.lastUserPanCamera = tick()
				self.lastCameraTransform = nil
			end
		end
	 
		function BaseCamera:DoGamepadZoom(name, state, input)
			if input.UserInputType == self.activeGamepad then
				if input.KeyCode == Enum.KeyCode.ButtonR3 then
					if state == Enum.UserInputState.Begin then
						if self.distanceChangeEnabled then
							local dist = self:GetCameraToSubjectDistance()
	 
							if dist > (GAMEPAD_ZOOM_STEP_2 + GAMEPAD_ZOOM_STEP_3)/2 then
								self:SetCameraToSubjectDistance(GAMEPAD_ZOOM_STEP_2)
							elseif dist > (GAMEPAD_ZOOM_STEP_1 + GAMEPAD_ZOOM_STEP_2)/2 then
								self:SetCameraToSubjectDistance(GAMEPAD_ZOOM_STEP_1)
							else
								self:SetCameraToSubjectDistance(GAMEPAD_ZOOM_STEP_3)
							end
						end
					end
				elseif input.KeyCode == Enum.KeyCode.DPadLeft then
					self.dpadLeftDown = (state == Enum.UserInputState.Begin)
				elseif input.KeyCode == Enum.KeyCode.DPadRight then
					self.dpadRightDown = (state == Enum.UserInputState.Begin)
				end
	 
				if self.dpadLeftDown then
					self.currentZoomSpeed = 1.04
				elseif self.dpadRightDown then
					self.currentZoomSpeed = 0.96
				else
					self.currentZoomSpeed = 1.00
				end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		--	elseif input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.ButtonL3 then
		--		if (state == Enum.UserInputState.Begin) then
		--			self.L3ButtonDown = true
		--		elseif (state == Enum.UserInputState.End) then
		--			self.L3ButtonDown = false
		--			self.currentZoomSpeed = 1.00
		--		end
		--	end
		end
	 
		function BaseCamera:DoKeyboardZoom(name, state, input)
			if not self.hasGameLoaded and VRService.VREnabled then
				return Enum.ContextActionResult.Pass
			end
	 
			if state ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end
	 
			if self.distanceChangeEnabled and player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
				if input.KeyCode == Enum.KeyCode.I then
					self:SetCameraToSubjectDistance( self.currentSubjectDistance - 5 )
				elseif input.KeyCode == Enum.KeyCode.O then
					self:SetCameraToSubjectDistance( self.currentSubjectDistance + 5 )
				end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
	 
		function BaseCamera:BindAction(actionName, actionFunc, createTouchButton, ...)
			table.insert(self.boundContextActions, actionName)
			ContextActionService:BindActionAtPriority(actionName, actionFunc, createTouchButton,
				CAMERA_ACTION_PRIORITY, ...)
		end
	 
		function BaseCamera:BindGamepadInputActions()
			self:BindAction("BaseCameraGamepadPan", function(name, state, input) return self:GetGamepadPan(name, state, input) end,
				false, Enum.KeyCode.Thumbstick2)
			self:BindAction("BaseCameraGamepadZoom", function(name, state, input) return self:DoGamepadZoom(name, state, input) end,
				false, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight, Enum.KeyCode.ButtonR3)
		end
	 
		function BaseCamera:BindKeyboardInputActions()
			self:BindAction("BaseCameraKeyboardPanArrowKeys", function(name, state, input) return self:DoKeyboardPanTurn(name, state, input) end,
				false, Enum.KeyCode.Left, Enum.KeyCode.Right)
			self:BindAction("BaseCameraKeyboardZoom", function(name, state, input) return self:DoKeyboardZoom(name, state, input) end,
				false, Enum.KeyCode.I, Enum.KeyCode.O)
		end
	 
		local function isInDynamicThumbstickArea(input)
			local playerGui = player:FindFirstChildOfClass("PlayerGui")
			local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
			local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
			local thumbstickFrame = touchFrame and touchFrame:FindFirstChild("DynamicThumbstickFrame")
	 
			if not thumbstickFrame then
				return false
			end
	 
			local frameCornerTopLeft = thumbstickFrame.AbsolutePosition
			local frameCornerBottomRight = frameCornerTopLeft + thumbstickFrame.AbsoluteSize
			if input.Position.X >= frameCornerTopLeft.X and input.Position.Y >= frameCornerTopLeft.Y then
				if input.Position.X <= frameCornerBottomRight.X and input.Position.Y <= frameCornerBottomRight.Y then
					return true
				end
			end
	 
			return false
		end
	 
		---Adjusts the camera Y touch Sensitivity when moving away from the center and in the TOUCH_SENSITIVTY_ADJUST_AREA
		function BaseCamera:AdjustTouchSensitivity(delta, sensitivity)
			local cameraCFrame = game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame
			if not cameraCFrame then
				return sensitivity
			end
			local currPitchAngle = cameraCFrame:ToEulerAnglesYXZ()
	 
			local multiplierY = TOUCH_SENSITIVTY_ADJUST_MAX_Y
			if currPitchAngle > TOUCH_ADJUST_AREA_UP and delta.Y < 0 then
				local fractionAdjust = (currPitchAngle - TOUCH_ADJUST_AREA_UP)/(MAX_Y - TOUCH_ADJUST_AREA_UP)
				fractionAdjust = 1 - (1 - fractionAdjust)^3
				multiplierY = TOUCH_SENSITIVTY_ADJUST_MAX_Y - fractionAdjust * (
					TOUCH_SENSITIVTY_ADJUST_MAX_Y - TOUCH_SENSITIVTY_ADJUST_MIN_Y)
			elseif currPitchAngle < TOUCH_ADJUST_AREA_DOWN and delta.Y > 0 then
				local fractionAdjust = (currPitchAngle - TOUCH_ADJUST_AREA_DOWN)/(MIN_Y - TOUCH_ADJUST_AREA_DOWN)
				fractionAdjust = 1 - (1 - fractionAdjust)^3
				multiplierY = TOUCH_SENSITIVTY_ADJUST_MAX_Y - fractionAdjust * (
					TOUCH_SENSITIVTY_ADJUST_MAX_Y - TOUCH_SENSITIVTY_ADJUST_MIN_Y)
			end
	 
			return Vector2.new(
				sensitivity.X,
				sensitivity.Y * multiplierY
			)
		end
	 
		function BaseCamera:OnTouchBegan(input, processed)
			local canUseDynamicTouch = self.isDynamicThumbstickEnabled and not processed
			if canUseDynamicTouch then
				if self.dynamicTouchInput == nil and isInDynamicThumbstickArea(input) then
					-- First input in the dynamic thumbstick area should always be ignored for camera purposes
					-- Even if the dynamic thumbstick does not process it immediately
					self.dynamicTouchInput = input
					return
				end
				self.fingerTouches[input] = processed
				self.inputStartPositions[input] = input.Position
				self.inputStartTimes[input] = tick()
				self.numUnsunkTouches = self.numUnsunkTouches + 1
			end
		end
	 
		function BaseCamera:OnTouchChanged(input, processed)
			if self.fingerTouches[input] == nil then
				if self.isDynamicThumbstickEnabled then
					return
				end
				self.fingerTouches[input] = processed
				if not processed then
					self.numUnsunkTouches = self.numUnsunkTouches + 1
				end
			end
	 
			if self.numUnsunkTouches == 1 then
				if self.fingerTouches[input] == false then
					self.panBeginLook = self.panBeginLook or self:GetCameraLookVector()
					self.startPos = self.startPos or input.Position
					self.lastPos = self.lastPos or self.startPos
					self.userPanningTheCamera = true
	 
					local delta = input.Position - self.lastPos
					delta = Vector2.new(delta.X, delta.Y * UserGameSettings:GetCameraYInvertValue())
					if self.panEnabled then
						local adjustedTouchSensitivity = TOUCH_SENSITIVTY
						self:AdjustTouchSensitivity(delta, TOUCH_SENSITIVTY)
	 
						local desiredXYVector = self:InputTranslationToCameraAngleChange(delta, adjustedTouchSensitivity)
						self.rotateInput = self.rotateInput + desiredXYVector
					end
					self.lastPos = input.Position
				end
			else
				self.panBeginLook = nil
				self.startPos = nil
				self.lastPos = nil
				self.userPanningTheCamera = false
			end
			if self.numUnsunkTouches == 2 then
				local unsunkTouches = {}
				for touch, wasSunk in pairs(self.fingerTouches) do
					if not wasSunk then
						table.insert(unsunkTouches, touch)
					end
				end
				if #unsunkTouches == 2 then
					local difference = (unsunkTouches[1].Position - unsunkTouches[2].Position).magnitude
					if self.startingDiff and self.pinchBeginZoom then
						local scale = difference / math.max(0.01, self.startingDiff)
						local clampedScale = math.clamp(scale, 0.1, 10)
						if self.distanceChangeEnabled then
							self:SetCameraToSubjectDistance(self.pinchBeginZoom / clampedScale)
						end
					else
						self.startingDiff = difference
						self.pinchBeginZoom = self:GetCameraToSubjectDistance()
					end
				end
			else
				self.startingDiff = nil
				self.pinchBeginZoom = nil
			end
		end
	 
		function BaseCamera:OnTouchEnded(input, processed)
			if input == self.dynamicTouchInput then
				self.dynamicTouchInput = nil
				return
			end
	 
			if self.fingerTouches[input] == false then
				if self.numUnsunkTouches == 1 then
					self.panBeginLook = nil
					self.startPos = nil
					self.lastPos = nil
					self.userPanningTheCamera = false
				elseif self.numUnsunkTouches == 2 then
					self.startingDiff = nil
					self.pinchBeginZoom = nil
				end
			end
	 
			if self.fingerTouches[input] ~= nil and self.fingerTouches[input] == false then
				self.numUnsunkTouches = self.numUnsunkTouches - 1
			end
			self.fingerTouches[input] = nil
			self.inputStartPositions[input] = nil
			self.inputStartTimes[input] = nil
		end
	 
		function BaseCamera:OnMouse2Down(input, processed)
			if processed then return end
	 
			self.isRightMouseDown = true
			self:OnMousePanButtonPressed(input, processed)
		end
	 
		function BaseCamera:OnMouse2Up(input, processed)
			self.isRightMouseDown = false
			self:OnMousePanButtonReleased(input, processed)
		end
	 
		function BaseCamera:OnMouse3Down(input, processed)
			if processed then return end
	 
			self.isMiddleMouseDown = true
			self:OnMousePanButtonPressed(input, processed)
		end
	 
		function BaseCamera:OnMouse3Up(input, processed)
			self.isMiddleMouseDown = false
			self:OnMousePanButtonReleased(input, processed)
		end
	 
		function BaseCamera:OnMouseMoved(input, processed)
			if not self.hasGameLoaded and VRService.VREnabled then
				return
			end
	 
			local inputDelta = input.Delta
			inputDelta = Vector2.new(inputDelta.X, inputDelta.Y * UserGameSettings:GetCameraYInvertValue())
	 
			local isInputPanning = FFlagUserCameraToggle and CameraInput.getPanning()
			local isBeginLook = self.startPos and self.lastPos and self.panBeginLook
			local isPanning = isBeginLook or self.inFirstPerson or self.inMouseLockedMode or isInputPanning
	 
			if self.panEnabled and isPanning then
				local desiredXYVector = self:InputTranslationToCameraAngleChange(inputDelta, MOUSE_SENSITIVITY)
				self.rotateInput = self.rotateInput + desiredXYVector
			end
	 
			if self.startPos and self.lastPos and self.panBeginLook then
				self.lastPos = self.lastPos + input.Delta
			end
		end
	 
		function BaseCamera:OnMousePanButtonPressed(input, processed)
			if processed then return end
			if not FFlagUserCameraToggle then
				self:UpdateMouseBehavior()
			end
			self.panBeginLook = self.panBeginLook or self:GetCameraLookVector()
			self.startPos = self.startPos or input.Position
			self.lastPos = self.lastPos or self.startPos
			self.userPanningTheCamera = true
		end
	 
		function BaseCamera:OnMousePanButtonReleased(input, processed)
			if not FFlagUserCameraToggle then
				self:UpdateMouseBehavior()
			end
			if not (self.isRightMouseDown or self.isMiddleMouseDown) then
				self.panBeginLook = nil
				self.startPos = nil
				self.lastPos = nil
				self.userPanningTheCamera = false
			end
		end
	 
		function BaseCamera:UpdateMouseBehavior()
			if FFlagUserCameraToggle and self.isCameraToggle then
				CameraUI.setCameraModeToastEnabled(true)
				CameraInput.enableCameraToggleInput()
				CameraToggleStateController(self.inFirstPerson)
			else
				if FFlagUserCameraToggle then
					CameraUI.setCameraModeToastEnabled(false)
					CameraInput.disableCameraToggleInput()
				end
				-- first time transition to first person mode or mouse-locked third person
				if self.inFirstPerson or self.inMouseLockedMode then
					--UserGameSettings.RotationType = Enum.RotationType.CameraRelative
					UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
				else
					UserGameSettings.RotationType = Enum.RotationType.MovementRelative
					if self.isRightMouseDown or self.isMiddleMouseDown then
						UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
					else
						UserInputService.MouseBehavior = Enum.MouseBehavior.Default
					end
				end
			end
		end
	 
		function BaseCamera:UpdateForDistancePropertyChange()
			-- Calling this setter with the current value will force checking that it is still
			-- in range after a change to the min/max distance limits
			self:SetCameraToSubjectDistance(self.currentSubjectDistance)
		end
	 
		function BaseCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
			local lastSubjectDistance = self.currentSubjectDistance
	 
			-- By default, camera modules will respect LockFirstPerson and override the currentSubjectDistance with 0
			-- regardless of what Player.CameraMinZoomDistance is set to, so that first person can be made
			-- available by the developer without needing to allow players to mousewheel dolly into first person.
			-- Some modules will override this function to remove or change first-person capability.
			if player.CameraMode == Enum.CameraMode.LockFirstPerson then
				self.currentSubjectDistance = 0.5
				if not self.inFirstPerson then
					self:EnterFirstPerson()
				end
			else
				local newSubjectDistance = math.clamp(desiredSubjectDistance, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
				if newSubjectDistance < FIRST_PERSON_DISTANCE_THRESHOLD then
					self.currentSubjectDistance = 0.5
					if not self.inFirstPerson then
						self:EnterFirstPerson()
					end
				else
					self.currentSubjectDistance = newSubjectDistance
					if self.inFirstPerson then
						self:LeaveFirstPerson()
					end
				end
			end
	 
			-- Pass target distance and zoom direction to the zoom controller
			ZoomController.SetZoomParameters(self.currentSubjectDistance, math.sign(desiredSubjectDistance - lastSubjectDistance))
	 
			-- Returned only for convenience to the caller to know the outcome
			return self.currentSubjectDistance
		end
	 
		function BaseCamera:SetCameraType( cameraType )
			--Used by derived classes
			self.cameraType = cameraType
		end
	 
		function BaseCamera:GetCameraType()
			return self.cameraType
		end
	 
		-- Movement mode standardized to Enum.ComputerCameraMovementMode values
		function BaseCamera:SetCameraMovementMode( cameraMovementMode )
			self.cameraMovementMode = cameraMovementMode
		end
	 
		function BaseCamera:GetCameraMovementMode()
			return self.cameraMovementMode
		end
	 
		function BaseCamera:SetIsMouseLocked(mouseLocked)
			self.inMouseLockedMode = mouseLocked
			if not FFlagUserCameraToggle then
				self:UpdateMouseBehavior()
			end
		end
	 
		function BaseCamera:GetIsMouseLocked()
			return self.inMouseLockedMode
		end
	 
		function BaseCamera:SetMouseLockOffset(offsetVector)
			self.mouseLockOffset = offsetVector
		end
	 
		function BaseCamera:GetMouseLockOffset()
			return self.mouseLockOffset
		end
	 
		function BaseCamera:InFirstPerson()
			return self.inFirstPerson
		end
	 
		function BaseCamera:EnterFirstPerson()
			-- Overridden in ClassicCamera, the only module which supports FirstPerson
		end
	 
		function BaseCamera:LeaveFirstPerson()
			-- Overridden in ClassicCamera, the only module which supports FirstPerson
		end
	 
		-- Nominal distance, set by dollying in and out with the mouse wheel or equivalent, not measured distance
		function BaseCamera:GetCameraToSubjectDistance()
			return self.currentSubjectDistance
		end
	 
		-- Actual measured distance to the camera Focus point, which may be needed in special circumstances, but should
		-- never be used as the starting point for updating the nominal camera-to-subject distance (self.currentSubjectDistance)
		-- since that is a desired target value set only by mouse wheel (or equivalent) input, PopperCam, and clamped to min max camera distance
		function BaseCamera:GetMeasuredDistanceToFocus()
			local camera = game.Workspace.CurrentCamera
			if camera then
				return (camera.CoordinateFrame.p - camera.Focus.p).magnitude
			end
			return nil
		end
	 
		function BaseCamera:GetCameraLookVector()
			return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.lookVector or UNIT_Z
		end
	 
		-- Replacements for RootCamera:RotateCamera() which did not actually rotate the camera
		-- suppliedLookVector is not normally passed in, it's used only by Watch camera
		function BaseCamera:CalculateNewLookCFrame(suppliedLookVector)
			local currLookVector = suppliedLookVector or self:GetCameraLookVector()
			local currPitchAngle = math.asin(currLookVector.y)
			local yTheta = math.clamp(self.rotateInput.y, -MAX_Y + currPitchAngle, -MIN_Y + currPitchAngle)
			local constrainedRotateInput = Vector2.new(self.rotateInput.x, yTheta)
			local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
			local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y,0,0)
			return newLookCFrame
		end
		function BaseCamera:CalculateNewLookVector(suppliedLookVector)
			local newLookCFrame = self:CalculateNewLookCFrame(suppliedLookVector)
			return newLookCFrame.lookVector
		end
	 
		function BaseCamera:CalculateNewLookVectorVR()
			local subjectPosition = self:GetSubjectPosition()
			local vecToSubject = (subjectPosition - game.Workspace.CurrentCamera.CFrame.p)
			local currLookVector = (vecToSubject * X1_Y0_Z1).unit
			local vrRotateInput = Vector2.new(self.rotateInput.x, 0)
			local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
			local yawRotatedVector = (CFrame.Angles(0, -vrRotateInput.x, 0) * startCFrame * CFrame.Angles(-vrRotateInput.y,0,0)).lookVector
			return (yawRotatedVector * X1_Y0_Z1).unit
		end
	 
		function BaseCamera:GetHumanoid()
			local character = player and player.Character
			if character then
				local resultHumanoid = self.humanoidCache[player]
				if resultHumanoid and resultHumanoid.Parent == character then
					return resultHumanoid
				else
					self.humanoidCache[player] = nil -- Bust Old Cache
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						self.humanoidCache[player] = humanoid
					end
					return humanoid
				end
			end
			return nil
		end
	 
		function BaseCamera:GetHumanoidPartToFollow(humanoid, humanoidStateType)
			if humanoidStateType == Enum.HumanoidStateType.Dead then
				local character = humanoid.Parent
				if character then
					return character:FindFirstChild("Head") or humanoid.Torso
				else
					return humanoid.Torso
				end
			else
				return humanoid.Torso
			end
		end
	 
		function BaseCamera:UpdateGamepad()
			local gamepadPan = self.gamepadPanningCamera
			if gamepadPan and (self.hasGameLoaded or not VRService.VREnabled) then
				gamepadPan = Util.GamepadLinearToCurve(gamepadPan)
				local currentTime = tick()
				if gamepadPan.X ~= 0 or gamepadPan.Y ~= 0 then
					self.userPanningTheCamera = true
				elseif gamepadPan == ZERO_VECTOR2 then
					self.lastThumbstickRotate = nil
					if self.lastThumbstickPos == ZERO_VECTOR2 then
						self.currentSpeed = 0
					end
				end
	 
				local finalConstant = 0
	 
				if self.lastThumbstickRotate then
					if VRService.VREnabled then
						self.currentSpeed = self.vrMaxSpeed
					else
						local elapsedTime = (currentTime - self.lastThumbstickRotate) * 10
						self.currentSpeed = self.currentSpeed + (self.maxSpeed * ((elapsedTime*elapsedTime)/self.numOfSeconds))
	 
						if self.currentSpeed > self.maxSpeed then self.currentSpeed = self.maxSpeed end
	 
						if self.lastVelocity then
							local velocity = (gamepadPan - self.lastThumbstickPos)/(currentTime - self.lastThumbstickRotate)
							local velocityDeltaMag = (velocity - self.lastVelocity).magnitude
	 
							if velocityDeltaMag > 12 then
								self.currentSpeed = self.currentSpeed * (20/velocityDeltaMag)
								if self.currentSpeed > self.maxSpeed then self.currentSpeed = self.maxSpeed end
							end
						end
					end
	 
					finalConstant = UserGameSettings.GamepadCameraSensitivity * self.currentSpeed
					self.lastVelocity = (gamepadPan - self.lastThumbstickPos)/(currentTime - self.lastThumbstickRotate)
				end
	 
				self.lastThumbstickPos = gamepadPan
				self.lastThumbstickRotate = currentTime
	 
				return Vector2.new( gamepadPan.X * finalConstant, gamepadPan.Y * finalConstant * self.ySensitivity * UserGameSettings:GetCameraYInvertValue())
			end
	 
			return ZERO_VECTOR2
		end
	 
		-- [[ VR Support Section ]] --
	 
		function BaseCamera:ApplyVRTransform()
			if not VRService.VREnabled then
				return
			end
	 
			--we only want this to happen in first person VR
			local rootJoint = self.humanoidRootPart and self.humanoidRootPart:FindFirstChild("RootJoint")
			if not rootJoint then
				return
			end
	 
			local cameraSubject = game.Workspace.CurrentCamera.CameraSubject
			local isInVehicle = cameraSubject and cameraSubject:IsA("VehicleSeat")
	 
			if self.inFirstPerson and not isInVehicle then
				local vrFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
				local vrRotation = vrFrame - vrFrame.p
				rootJoint.C0 = CFrame.new(vrRotation:vectorToObjectSpace(vrFrame.p)) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
			else
				rootJoint.C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
			end
		end
	 
		function BaseCamera:IsInFirstPerson()
			return self.inFirstPerson
		end
	 
		function BaseCamera:ShouldUseVRRotation()
			if not VRService.VREnabled then
				return false
			end
	 
			if not self.VRRotationIntensityAvailable and tick() - self.lastVRRotationIntensityCheckTime < 1 then
				return false
			end
	 
			local success, vrRotationIntensity = pcall(function() return StarterGui:GetCore("VRRotationIntensity") end)
			self.VRRotationIntensityAvailable = success and vrRotationIntensity ~= nil
			self.lastVRRotationIntensityCheckTime = tick()
	 
			self.shouldUseVRRotation = success and vrRotationIntensity ~= nil and vrRotationIntensity ~= "Smooth"
	 
			return self.shouldUseVRRotation
		end
	 
		function BaseCamera:GetVRRotationInput()
			local vrRotateSum = ZERO_VECTOR2
			local success, vrRotationIntensity = pcall(function() return StarterGui:GetCore("VRRotationIntensity") end)
	 
			if not success then
				return
			end
	 
			local vrGamepadRotation = self.GamepadPanningCamera or ZERO_VECTOR2
			local delayExpired = (tick() - self.lastVRRotationTime) >= self:GetRepeatDelayValue(vrRotationIntensity)
	 
			if math.abs(vrGamepadRotation.x) >= self:GetActivateValue() then
				if (delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2]) then
					local sign = 1
					if vrGamepadRotation.x < 0 then
						sign = -1
					end
					vrRotateSum = vrRotateSum + self:GetRotateAmountValue(vrRotationIntensity) * sign
					self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] = true
				end
			elseif math.abs(vrGamepadRotation.x) < self:GetActivateValue() - 0.1 then
				self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] = nil
			end
			if self.turningLeft then
				if delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Left] then
					vrRotateSum = vrRotateSum - self:GetRotateAmountValue(vrRotationIntensity)
					self.vrRotateKeyCooldown[Enum.KeyCode.Left] = true
				end
			else
				self.vrRotateKeyCooldown[Enum.KeyCode.Left] = nil
			end
			if self.turningRight then
				if (delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Right]) then
					vrRotateSum = vrRotateSum + self:GetRotateAmountValue(vrRotationIntensity)
					self.vrRotateKeyCooldown[Enum.KeyCode.Right] = true
				end
			else
				self.vrRotateKeyCooldown[Enum.KeyCode.Right] = nil
			end
	 
			if vrRotateSum ~= ZERO_VECTOR2 then
				self.lastVRRotationTime = tick()
			end
	 
			return vrRotateSum
		end
	 
		function BaseCamera:CancelCameraFreeze(keepConstraints)
			if not keepConstraints then
				self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, 1, self.cameraTranslationConstraints.z)
			end
			if self.cameraFrozen then
				self.trackingHumanoid = nil
				self.cameraFrozen = false
			end
		end
	 
		function BaseCamera:StartCameraFreeze(subjectPosition, humanoidToTrack)
			if not self.cameraFrozen then
				self.humanoidJumpOrigin = subjectPosition
				self.trackingHumanoid = humanoidToTrack
				self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, 0, self.cameraTranslationConstraints.z)
				self.cameraFrozen = true
			end
		end
	 
		function BaseCamera:OnNewCameraSubject()
			if self.subjectStateChangedConn then
				self.subjectStateChangedConn:Disconnect()
				self.subjectStateChangedConn = nil
			end
	 
			local humanoid = workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject
			if self.trackingHumanoid ~= humanoid then
				self:CancelCameraFreeze()
			end
			if humanoid and humanoid:IsA("Humanoid") then
				self.subjectStateChangedConn = humanoid.StateChanged:Connect(function(oldState, newState)
					if VRService.VREnabled and newState == Enum.HumanoidStateType.Jumping and not self.inFirstPerson then
						self:StartCameraFreeze(self:GetSubjectPosition(), humanoid)
					elseif newState ~= Enum.HumanoidStateType.Jumping and newState ~= Enum.HumanoidStateType.Freefall then
						self:CancelCameraFreeze(true)
					end
				end)
			end
		end
	 
		function BaseCamera:GetVRFocus(subjectPosition, timeDelta)
			local lastFocus = self.LastCameraFocus or subjectPosition
			if not self.cameraFrozen then
				self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, math.min(1, self.cameraTranslationConstraints.y + 0.42 * timeDelta), self.cameraTranslationConstraints.z)
			end
	 
			local newFocus
			if self.cameraFrozen and self.humanoidJumpOrigin and self.humanoidJumpOrigin.y > lastFocus.y then
				newFocus = CFrame.new(Vector3.new(subjectPosition.x, math.min(self.humanoidJumpOrigin.y, lastFocus.y + 5 * timeDelta), subjectPosition.z))
			else
				newFocus = CFrame.new(Vector3.new(subjectPosition.x, lastFocus.y, subjectPosition.z):lerp(subjectPosition, self.cameraTranslationConstraints.y))
			end
	 
			if self.cameraFrozen then
				-- No longer in 3rd person
				if self.inFirstPerson then -- not VRService.VREnabled
					self:CancelCameraFreeze()
				end
				-- This case you jumped off a cliff and want to keep your character in view
				-- 0.5 is to fix floating point error when not jumping off cliffs
				if self.humanoidJumpOrigin and subjectPosition.y < (self.humanoidJumpOrigin.y - 0.5) then
					self:CancelCameraFreeze()
				end
			end
	 
			return newFocus
		end
	 
		function BaseCamera:GetRotateAmountValue(vrRotationIntensity)
			vrRotationIntensity = vrRotationIntensity or StarterGui:GetCore("VRRotationIntensity")
			if vrRotationIntensity then
				if vrRotationIntensity == "Low" then
					return VR_LOW_INTENSITY_ROTATION
				elseif vrRotationIntensity == "High" then
					return VR_HIGH_INTENSITY_ROTATION
				end
			end
			return ZERO_VECTOR2
		end
	 
		function BaseCamera:GetRepeatDelayValue(vrRotationIntensity)
			vrRotationIntensity = vrRotationIntensity or StarterGui:GetCore("VRRotationIntensity")
			if vrRotationIntensity then
				if vrRotationIntensity == "Low" then
					return VR_LOW_INTENSITY_REPEAT
				elseif vrRotationIntensity == "High" then
					return VR_HIGH_INTENSITY_REPEAT
				end
			end
			return 0
		end
	 
		function BaseCamera:Update(dt)
			error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
		end
	 
		BaseCamera.UpCFrame = CFrame.new()
	 
		function BaseCamera:UpdateUpCFrame(cf)
			self.UpCFrame = cf
		end
		local ZERO = Vector3.new(0, 0, 0)
		function BaseCamera:CalculateNewLookCFrame(suppliedLookVector)
			local currLookVector = suppliedLookVector or self:GetCameraLookVector()
			currLookVector = self.UpCFrame:VectorToObjectSpace(currLookVector)
	 
			local currPitchAngle = math.asin(currLookVector.y)
			local yTheta = math.clamp(self.rotateInput.y, -MAX_Y + currPitchAngle, -MIN_Y + currPitchAngle)
			local constrainedRotateInput = Vector2.new(self.rotateInput.x, yTheta)
			local startCFrame = CFrame.new(ZERO, currLookVector)
			local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y,0,0)
	 
			return newLookCFrame
		end
	 
		return BaseCamera
	end
	 
	function _BaseOcclusion()
		--[[ The Module ]]--
		local BaseOcclusion = {}
		BaseOcclusion.__index = BaseOcclusion
		setmetatable(BaseOcclusion, {
			__call = function(_, ...)
				return BaseOcclusion.new(...)
			end
		})
	 
		function BaseOcclusion.new()
			local self = setmetatable({}, BaseOcclusion)
			return self
		end
	 
		-- Called when character is added
		function BaseOcclusion:CharacterAdded(char, player)
		end
	 
		-- Called when character is about to be removed
		function BaseOcclusion:CharacterRemoving(char, player)
		end
	 
		function BaseOcclusion:OnCameraSubjectChanged(newSubject)
		end
	 
		--[[ Derived classes are required to override and implement all of the following functions ]]--
		function BaseOcclusion:GetOcclusionMode()
			-- Must be overridden in derived classes to return an Enum.DevCameraOcclusionMode value
			warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
			return nil
		end
	 
		function BaseOcclusion:Enable(enabled)
			warn("BaseOcclusion Enable must be overridden by derived classes")
		end
	 
		function BaseOcclusion:Update(dt, desiredCameraCFrame, desiredCameraFocus)
			warn("BaseOcclusion Update must be overridden by derived classes")
			return desiredCameraCFrame, desiredCameraFocus
		end
	 
		return BaseOcclusion
	end
	 
	function _Popper()
	 
		local Players = game:GetService("Players")
	 
		local camera = game.Workspace.CurrentCamera
	 
		local min = math.min
		local tan = math.tan
		local rad = math.rad
		local inf = math.huge
		local ray = Ray.new
	 
		local function getTotalTransparency(part)
			return 1 - (1 - part.Transparency)*(1 - part.LocalTransparencyModifier)
		end
	 
		local function eraseFromEnd(t, toSize)
			for i = #t, toSize + 1, -1 do
				t[i] = nil
			end
		end
	 
		local nearPlaneZ, projX, projY do
			local function updateProjection()
				local fov = rad(camera.FieldOfView)
				local view = camera.ViewportSize
				local ar = view.X/view.Y
	 
				projY = 2*tan(fov/2)
				projX = ar*projY
			end
	 
			camera:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
			camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)
	 
			updateProjection()
	 
			nearPlaneZ = camera.NearPlaneZ
			camera:GetPropertyChangedSignal("NearPlaneZ"):Connect(function()
				nearPlaneZ = camera.NearPlaneZ
			end)
		end
	 
		local blacklist = {} do
			local charMap = {}
	 
			local function refreshIgnoreList()
				local n = 1
				blacklist = {}
				for _, character in pairs(charMap) do
					blacklist[n] = character
					n = n + 1
				end
			end
	 
			local function playerAdded(player)
				local function characterAdded(character)
					charMap[player] = character
					refreshIgnoreList()
				end
				local function characterRemoving()
					charMap[player] = nil
					refreshIgnoreList()
				end
	 
				player.CharacterAdded:Connect(characterAdded)
				player.CharacterRemoving:Connect(characterRemoving)
				if player.Character then
					characterAdded(player.Character)
				end
			end
	 
			local function playerRemoving(player)
				charMap[player] = nil
				refreshIgnoreList()
			end
	 
			Players.PlayerAdded:Connect(playerAdded)
			Players.PlayerRemoving:Connect(playerRemoving)
	 
			for _, player in ipairs(Players:GetPlayers()) do
				playerAdded(player)
			end
			refreshIgnoreList()
		end
	 
		--------------------------------------------------------------------------------------------
		-- Popper uses the level geometry find an upper bound on subject-to-camera distance.
		--
		-- Hard limits are applied immediately and unconditionally. They are generally caused
		-- when level geometry intersects with the near plane (with exceptions, see below).
		--
		-- Soft limits are only applied under certain conditions.
		-- They are caused when level geometry occludes the subject without actually intersecting
		-- with the near plane at the target distance.
		--
		-- Soft limits can be promoted to hard limits and hard limits can be demoted to soft limits.
		-- We usually don"t want the latter to happen.
		--
		-- A soft limit will be promoted to a hard limit if an obstruction
		-- lies between the current and target camera positions.
		--------------------------------------------------------------------------------------------
	 
		local subjectRoot
		local subjectPart
	 
		camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
			local subject = camera.CameraSubject
			if subject:IsA("Humanoid") then
				subjectPart = subject.RootPart
			elseif subject:IsA("BasePart") then
				subjectPart = subject
			else
				subjectPart = nil
			end
		end)
	 
		local function canOcclude(part)
			-- Occluders must be:
			-- 1. Opaque
			-- 2. Interactable
			-- 3. Not in the same assembly as the subject
	 
			return
				getTotalTransparency(part) < 0.25 and
				part.CanCollide and
				subjectRoot ~= (part:GetRootPart() or part) and
				not part:IsA("TrussPart")
		end
	 
		-- Offsets for the volume visibility test
		local SCAN_SAMPLE_OFFSETS = {
			Vector2.new( 0.4, 0.0),
			Vector2.new(-0.4, 0.0),
			Vector2.new( 0.0,-0.4),
			Vector2.new( 0.0, 0.4),
			Vector2.new( 0.0, 0.2),
		}
	 
		--------------------------------------------------------------------------------
		-- Piercing raycasts
	 
		local function getCollisionPoint(origin, dir)
			local originalSize = #blacklist
			repeat
				local hitPart, hitPoint = workspace:FindPartOnRayWithIgnoreList(
					ray(origin, dir), blacklist, false, true
				)
	 
				if hitPart then
					if hitPart.CanCollide then
						eraseFromEnd(blacklist, originalSize)
						return hitPoint, true
					end
					blacklist[#blacklist + 1] = hitPart
				end
			until not hitPart
	 
			eraseFromEnd(blacklist, originalSize)
			return origin + dir, false
		end
	 
		--------------------------------------------------------------------------------
	 
		local function queryPoint(origin, unitDir, dist, lastPos)
			debug.profilebegin("queryPoint")
	 
			local originalSize = #blacklist
	 
			dist = dist + nearPlaneZ
			local target = origin + unitDir*dist
	 
			local softLimit = inf
			local hardLimit = inf
			local movingOrigin = origin
	 
			repeat
				local entryPart, entryPos = workspace:FindPartOnRayWithIgnoreList(ray(movingOrigin, target - movingOrigin), blacklist, false, true)
	 
				if entryPart then
					if canOcclude(entryPart) then
						local wl = {entryPart}
						local exitPart = workspace:FindPartOnRayWithWhitelist(ray(target, entryPos - target), wl, true)
	 
						local lim = (entryPos - origin).Magnitude
	 
						if exitPart then
							local promote = false
							if lastPos then
								promote =
									workspace:FindPartOnRayWithWhitelist(ray(lastPos, target - lastPos), wl, true) or
									workspace:FindPartOnRayWithWhitelist(ray(target, lastPos - target), wl, true)
							end
	 
							if promote then
								-- Ostensibly a soft limit, but the camera has passed through it in the last frame, so promote to a hard limit.
								hardLimit = lim
							elseif dist < softLimit then
								-- Trivial soft limit
								softLimit = lim
							end
						else
							-- Trivial hard limit
							hardLimit = lim
						end
					end
	 
					blacklist[#blacklist + 1] = entryPart
					movingOrigin = entryPos - unitDir*1e-3
				end
			until hardLimit < inf or not entryPart
	 
			eraseFromEnd(blacklist, originalSize)
	 
			debug.profileend()
			return softLimit - nearPlaneZ, hardLimit - nearPlaneZ
		end
	 
		local function queryViewport(focus, dist)
			debug.profilebegin("queryViewport")
	 
			local fP =  focus.p
			local fX =  focus.rightVector
			local fY =  focus.upVector
			local fZ = -focus.lookVector
	 
			local viewport = camera.ViewportSize
	 
			local hardBoxLimit = inf
			local softBoxLimit = inf
	 
			-- Center the viewport on the PoI, sweep points on the edge towards the target, and take the minimum limits
			for viewX = 0, 1 do
				local worldX = fX*((viewX - 0.5)*projX)
	 
				for viewY = 0, 1 do
					local worldY = fY*((viewY - 0.5)*projY)
	 
					local origin = fP + nearPlaneZ*(worldX + worldY)
					local lastPos = camera:ViewportPointToRay(
						viewport.x*viewX,
						viewport.y*viewY
					).Origin
	 
					local softPointLimit, hardPointLimit = queryPoint(origin, fZ, dist, lastPos)
	 
					if hardPointLimit < hardBoxLimit then
						hardBoxLimit = hardPointLimit
					end
					if softPointLimit < softBoxLimit then
						softBoxLimit = softPointLimit
					end
				end
			end
			debug.profileend()
	 
			return softBoxLimit, hardBoxLimit
		end
	 
		local function testPromotion(focus, dist, focusExtrapolation)
			debug.profilebegin("testPromotion")
	 
			local fP = focus.p
			local fX = focus.rightVector
			local fY = focus.upVector
			local fZ = -focus.lookVector
	 
			do
				-- Dead reckoning the camera rotation and focus
				debug.profilebegin("extrapolate")
	 
				local SAMPLE_DT = 0.0625
				local SAMPLE_MAX_T = 1.25
	 
				local maxDist = (getCollisionPoint(fP, focusExtrapolation.posVelocity*SAMPLE_MAX_T) - fP).Magnitude
				-- Metric that decides how many samples to take
				local combinedSpeed = focusExtrapolation.posVelocity.magnitude
	 
				for dt = 0, min(SAMPLE_MAX_T, focusExtrapolation.rotVelocity.magnitude + maxDist/combinedSpeed), SAMPLE_DT do
					local cfDt = focusExtrapolation.extrapolate(dt) -- Extrapolated CFrame at time dt
	 
					if queryPoint(cfDt.p, -cfDt.lookVector, dist) >= dist then
						return false
					end
				end
	 
				debug.profileend()
			end
	 
			do
				-- Test screen-space offsets from the focus for the presence of soft limits
				debug.profilebegin("testOffsets")
	 
				for _, offset in ipairs(SCAN_SAMPLE_OFFSETS) do
					local scaledOffset = offset
					local pos = getCollisionPoint(fP, fX*scaledOffset.x + fY*scaledOffset.y)
					if queryPoint(pos, (fP + fZ*dist - pos).Unit, dist) == inf then
						return false
					end
				end
	 
				debug.profileend()
			end
	 
			debug.profileend()
			return true
		end
	 
		local function Popper(focus, targetDist, focusExtrapolation)
			debug.profilebegin("popper")
	 
			subjectRoot = subjectPart and subjectPart:GetRootPart() or subjectPart
	 
			local dist = targetDist
			local soft, hard = queryViewport(focus, targetDist)
			if hard < dist then
				dist = hard
			end
			if soft < dist and testPromotion(focus, targetDist, focusExtrapolation) then
				dist = soft
			end
	 
			subjectRoot = nil
	 
			debug.profileend()
			return dist
		end
	 
		return Popper
	end
	 
	function _ZoomController()
		local ZOOM_STIFFNESS = 4.5
		local ZOOM_DEFAULT = 12.5
		local ZOOM_ACCELERATION = 0.0375
	 
		local MIN_FOCUS_DIST = 0.5
		local DIST_OPAQUE = 1
	 
		local Popper = _Popper()
	 
		local clamp = math.clamp
		local exp = math.exp
		local min = math.min
		local max = math.max
		local pi = math.pi
	 
		local cameraMinZoomDistance, cameraMaxZoomDistance do
			local Player = game:GetService("Players").LocalPlayer
	 
			local function updateBounds()
				cameraMinZoomDistance = Player.CameraMinZoomDistance
				cameraMaxZoomDistance = Player.CameraMaxZoomDistance
			end
	 
			updateBounds()
	 
			Player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(updateBounds)
			Player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(updateBounds)
		end
	 
		local ConstrainedSpring = {} do
			ConstrainedSpring.__index = ConstrainedSpring
	 
			function ConstrainedSpring.new(freq, x, minValue, maxValue)
				x = clamp(x, minValue, maxValue)
				return setmetatable({
					freq = freq, -- Undamped frequency (Hz)
					x = x, -- Current position
					v = 0, -- Current velocity
					minValue = minValue, -- Minimum bound
					maxValue = maxValue, -- Maximum bound
					goal = x, -- Goal position
				}, ConstrainedSpring)
			end
	 
			function ConstrainedSpring:Step(dt)
				local freq = self.freq*2*pi -- Convert from Hz to rad/s
				local x = self.x
				local v = self.v
				local minValue = self.minValue
				local maxValue = self.maxValue
				local goal = self.goal
	 
				-- Solve the spring ODE for position and velocity after time t, assuming critical damping:
				--   2*f*x'[t] + x''[t] = f^2*(g - x[t])
				-- Knowns are x[0] and x'[0].
				-- Solve for x[t] and x'[t].
	 
				local offset = goal - x
				local step = freq*dt
				local decay = exp(-step)
	 
				local x1 = goal + (v*dt - offset*(step + 1))*decay
				local v1 = ((offset*freq - v)*step + v)*decay
	 
				-- Constrain
				if x1 < minValue then
					x1 = minValue
					v1 = 0
				elseif x1 > maxValue then
					x1 = maxValue
					v1 = 0
				end
	 
				self.x = x1
				self.v = v1
	 
				return x1
			end
		end
	 
		local zoomSpring = ConstrainedSpring.new(ZOOM_STIFFNESS, ZOOM_DEFAULT, MIN_FOCUS_DIST, cameraMaxZoomDistance)
	 
		local function stepTargetZoom(z, dz, zoomMin, zoomMax)
			z = clamp(z + dz*(1 + z*ZOOM_ACCELERATION), zoomMin, zoomMax)
			if z < DIST_OPAQUE then
				z = dz <= 0 and zoomMin or DIST_OPAQUE
			end
			return z
		end
	 
		local zoomDelta = 0
	 
		local Zoom = {} do
			function Zoom.Update(renderDt, focus, extrapolation)
				local poppedZoom = math.huge
	 
				if zoomSpring.goal > DIST_OPAQUE then
					-- Make a pessimistic estimate of zoom distance for this step without accounting for poppercam
					local maxPossibleZoom = max(
						zoomSpring.x,
						stepTargetZoom(zoomSpring.goal, zoomDelta, cameraMinZoomDistance, cameraMaxZoomDistance)
					)
	 
					-- Run the Popper algorithm on the feasible zoom range, [MIN_FOCUS_DIST, maxPossibleZoom]
					poppedZoom = Popper(
						focus*CFrame.new(0, 0, MIN_FOCUS_DIST),
						maxPossibleZoom - MIN_FOCUS_DIST,
						extrapolation
					) + MIN_FOCUS_DIST
				end
	 
				zoomSpring.minValue = MIN_FOCUS_DIST
				zoomSpring.maxValue = min(cameraMaxZoomDistance, poppedZoom)
	 
				return zoomSpring:Step(renderDt)
			end
	 
			function Zoom.SetZoomParameters(targetZoom, newZoomDelta)
				zoomSpring.goal = targetZoom
				zoomDelta = newZoomDelta
			end
		end
	 
		return Zoom
	end
	 
	function _MouseLockController()
		--[[ Constants ]]--
		local DEFAULT_MOUSE_LOCK_CURSOR = "rbxasset://textures/MouseLockedCursor.png"
	 
		local CONTEXT_ACTION_NAME = "MouseLockSwitchAction"
		local MOUSELOCK_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
	 
		--[[ Services ]]--
		local PlayersService = game:GetService("Players")
		local ContextActionService = game:GetService("ContextActionService")
		local Settings = UserSettings()	-- ignore warning
		local GameSettings = Settings.GameSettings
		local Mouse = PlayersService.LocalPlayer:GetMouse()
	 
		--[[ The Module ]]--
		local MouseLockController = {}
		MouseLockController.__index = MouseLockController
	 
		function MouseLockController.new()
			local self = setmetatable({}, MouseLockController)
	 
			self.isMouseLocked = false
			self.savedMouseCursor = nil
			self.boundKeys = {Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift} -- defaults
	 
			self.mouseLockToggledEvent = Instance.new("BindableEvent")
	 
			local boundKeysObj = script:FindFirstChild("BoundKeys")
			if (not boundKeysObj) or (not boundKeysObj:IsA("StringValue")) then
				-- If object with correct name was found, but it's not a StringValue, destroy and replace
				if boundKeysObj then
					boundKeysObj:Destroy()
				end
	 
				boundKeysObj = Instance.new("StringValue")
				boundKeysObj.Name = "BoundKeys"
				boundKeysObj.Value = "LeftShift,RightShift"
				boundKeysObj.Parent = script
			end
	 
			if boundKeysObj then
				boundKeysObj.Changed:Connect(function(value)
					self:OnBoundKeysObjectChanged(value)
				end)
				self:OnBoundKeysObjectChanged(boundKeysObj.Value) -- Initial setup call
			end
	 
			-- Watch for changes to user's ControlMode and ComputerMovementMode settings and update the feature availability accordingly
			GameSettings.Changed:Connect(function(property)
				if property == "ControlMode" or property == "ComputerMovementMode" then
					self:UpdateMouseLockAvailability()
				end
			end)
	 
			-- Watch for changes to DevEnableMouseLock and update the feature availability accordingly
			PlayersService.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
				self:UpdateMouseLockAvailability()
			end)
	 
			-- Watch for changes to DevEnableMouseLock and update the feature availability accordingly
			PlayersService.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
				self:UpdateMouseLockAvailability()
			end)
	 
			self:UpdateMouseLockAvailability()
	 
			return self
		end
	 
		function MouseLockController:GetIsMouseLocked()
			return self.isMouseLocked
		end
	 
		function MouseLockController:GetBindableToggleEvent()
			return self.mouseLockToggledEvent.Event
		end
	 
		function MouseLockController:GetMouseLockOffset()
			local offsetValueObj = script:FindFirstChild("CameraOffset")
			if offsetValueObj and offsetValueObj:IsA("Vector3Value") then
				return offsetValueObj.Value
			else
				-- If CameraOffset object was found but not correct type, destroy
				if offsetValueObj then
					offsetValueObj:Destroy()
				end
				offsetValueObj = Instance.new("Vector3Value")
				offsetValueObj.Name = "CameraOffset"
				offsetValueObj.Value = Vector3.new(1.75,0,0) -- Legacy Default Value
				offsetValueObj.Parent = script
			end
	 
			if offsetValueObj and offsetValueObj.Value then
				return offsetValueObj.Value
			end
	 
			return Vector3.new(1.75,0,0)
		end
	 
		function MouseLockController:UpdateMouseLockAvailability()
			local devAllowsMouseLock = PlayersService.LocalPlayer.DevEnableMouseLock
			local devMovementModeIsScriptable = PlayersService.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
			local userHasMouseLockModeEnabled = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
			local userHasClickToMoveEnabled =  GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
			local MouseLockAvailable = devAllowsMouseLock and userHasMouseLockModeEnabled and not userHasClickToMoveEnabled and not devMovementModeIsScriptable
	 
			if MouseLockAvailable~=self.enabled then
				self:EnableMouseLock(MouseLockAvailable)
			end
		end
	 
		function MouseLockController:OnBoundKeysObjectChanged(newValue)
			self.boundKeys = {} -- Overriding defaults, note: possibly with nothing at all if boundKeysObj.Value is "" or contains invalid values
			for token in string.gmatch(newValue,"[^%s,]+") do
				for _, keyEnum in pairs(Enum.KeyCode:GetEnumItems()) do
					if token == keyEnum.Name then
						self.boundKeys[#self.boundKeys+1] = keyEnum
						break
					end
				end
			end
			self:UnbindContextActions()
			self:BindContextActions()
		end
	 
		--[[ Local Functions ]]--
		function MouseLockController:OnMouseLockToggled()
			self.isMouseLocked = not self.isMouseLocked
	 
			if self.isMouseLocked then
				local cursorImageValueObj = script:FindFirstChild("CursorImage")
				if cursorImageValueObj and cursorImageValueObj:IsA("StringValue") and cursorImageValueObj.Value then
					self.savedMouseCursor = Mouse.Icon
					Mouse.Icon = cursorImageValueObj.Value
				else
					if cursorImageValueObj then
						cursorImageValueObj:Destroy()
					end
					cursorImageValueObj = Instance.new("StringValue")
					cursorImageValueObj.Name = "CursorImage"
					cursorImageValueObj.Value = DEFAULT_MOUSE_LOCK_CURSOR
					cursorImageValueObj.Parent = script
					self.savedMouseCursor = Mouse.Icon
					Mouse.Icon = DEFAULT_MOUSE_LOCK_CURSOR
				end
			else
				if self.savedMouseCursor then
					Mouse.Icon = self.savedMouseCursor
					self.savedMouseCursor = nil
				end
			end
	 
			self.mouseLockToggledEvent:Fire()
		end
	 
		function MouseLockController:DoMouseLockSwitch(name, state, input)
			if state == Enum.UserInputState.Begin then
				self:OnMouseLockToggled()
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
	 
		function MouseLockController:BindContextActions()
			ContextActionService:BindActionAtPriority(CONTEXT_ACTION_NAME, function(name, state, input)
				return self:DoMouseLockSwitch(name, state, input)
			end, false, MOUSELOCK_ACTION_PRIORITY, unpack(self.boundKeys))
		end
	 
		function MouseLockController:UnbindContextActions()
			ContextActionService:UnbindAction(CONTEXT_ACTION_NAME)
		end
	 
		function MouseLockController:IsMouseLocked()
			return self.enabled and self.isMouseLocked
		end
	 
		function MouseLockController:EnableMouseLock(enable)
			if enable ~= self.enabled then
	 
				self.enabled = enable
	 
				if self.enabled then
					-- Enabling the mode
					self:BindContextActions()
				else
					-- Disabling
					-- Restore mouse cursor
					if Mouse.Icon~="" then
						Mouse.Icon = ""
					end
	 
					self:UnbindContextActions()
	 
					-- If the mode is disabled while being used, fire the event to toggle it off
					if self.isMouseLocked then
						self.mouseLockToggledEvent:Fire()
					end
	 
					self.isMouseLocked = false
				end
	 
			end
		end
	 
		return MouseLockController
	end
	 
	function _TransparencyController()
	 
		local MAX_TWEEN_RATE = 2.8 -- per second
	 
		local Util = _CameraUtils()
	 
		--[[ The Module ]]--
		local TransparencyController = {}
		TransparencyController.__index = TransparencyController
	 
		function TransparencyController.new()
			local self = setmetatable({}, TransparencyController)
	 
			self.lastUpdate = tick()
			self.transparencyDirty = false
			self.enabled = false
			self.lastTransparency = nil
	 
			self.descendantAddedConn, self.descendantRemovingConn = nil, nil
			self.toolDescendantAddedConns = {}
			self.toolDescendantRemovingConns = {}
			self.cachedParts = {}
	 
			return self
		end
	 
	 
		function TransparencyController:HasToolAncestor(object)
			if object.Parent == nil then return false end
			return object.Parent:IsA('Tool') or self:HasToolAncestor(object.Parent)
		end
	 
		function TransparencyController:IsValidPartToModify(part)
			if part:IsA('BasePart') or part:IsA('Decal') then
				return not self:HasToolAncestor(part)
			end
			return false
		end
	 
		function TransparencyController:CachePartsRecursive(object)
			if object then
				if self:IsValidPartToModify(object) then
					self.cachedParts[object] = true
					self.transparencyDirty = true
				end
				for _, child in pairs(object:GetChildren()) do
					self:CachePartsRecursive(child)
				end
			end
		end
	 
		function TransparencyController:TeardownTransparency()
			for child, _ in pairs(self.cachedParts) do
				child.LocalTransparencyModifier = 0
			end
			self.cachedParts = {}
			self.transparencyDirty = true
			self.lastTransparency = nil
	 
			if self.descendantAddedConn then
				self.descendantAddedConn:disconnect()
				self.descendantAddedConn = nil
			end
			if self.descendantRemovingConn then
				self.descendantRemovingConn:disconnect()
				self.descendantRemovingConn = nil
			end
			for object, conn in pairs(self.toolDescendantAddedConns) do
				conn:Disconnect()
				self.toolDescendantAddedConns[object] = nil
			end
			for object, conn in pairs(self.toolDescendantRemovingConns) do
				conn:Disconnect()
				self.toolDescendantRemovingConns[object] = nil
			end
		end
	 
		function TransparencyController:SetupTransparency(character)
			self:TeardownTransparency()
	 
			if self.descendantAddedConn then self.descendantAddedConn:disconnect() end
			self.descendantAddedConn = character.DescendantAdded:Connect(function(object)
				-- This is a part we want to invisify
				if self:IsValidPartToModify(object) then
					self.cachedParts[object] = true
					self.transparencyDirty = true
				-- There is now a tool under the character
				elseif object:IsA('Tool') then
					if self.toolDescendantAddedConns[object] then self.toolDescendantAddedConns[object]:Disconnect() end
					self.toolDescendantAddedConns[object] = object.DescendantAdded:Connect(function(toolChild)
						self.cachedParts[toolChild] = nil
						if toolChild:IsA('BasePart') or toolChild:IsA('Decal') then
							-- Reset the transparency
							toolChild.LocalTransparencyModifier = 0
						end
					end)
					if self.toolDescendantRemovingConns[object] then self.toolDescendantRemovingConns[object]:disconnect() end
					self.toolDescendantRemovingConns[object] = object.DescendantRemoving:Connect(function(formerToolChild)
						wait() -- wait for new parent
						if character and formerToolChild and formerToolChild:IsDescendantOf(character) then
							if self:IsValidPartToModify(formerToolChild) then
								self.cachedParts[formerToolChild] = true
								self.transparencyDirty = true
							end
						end
					end)
				end
			end)
			if self.descendantRemovingConn then self.descendantRemovingConn:disconnect() end
			self.descendantRemovingConn = character.DescendantRemoving:connect(function(object)
				if self.cachedParts[object] then
					self.cachedParts[object] = nil
					-- Reset the transparency
					object.LocalTransparencyModifier = 0
				end
			end)
			self:CachePartsRecursive(character)
		end
	 
	 
		function TransparencyController:Enable(enable)
			if self.enabled ~= enable then
				self.enabled = enable
				self:Update()
			end
		end
	 
		function TransparencyController:SetSubject(subject)
			local character = nil
			if subject and subject:IsA("Humanoid") then
				character = subject.Parent
			end
			if subject and subject:IsA("VehicleSeat") and subject.Occupant then
				character = subject.Occupant.Parent
			end
			if character then
				self:SetupTransparency(character)
			else
				self:TeardownTransparency()
			end
		end
	 
		function TransparencyController:Update()
			local instant = false
			local now = tick()
			local currentCamera = workspace.CurrentCamera
	 
			if currentCamera then
				local transparency = 0
				if not self.enabled then
					instant = true
				else
					local distance = (currentCamera.Focus.p - currentCamera.CoordinateFrame.p).magnitude
					transparency = (distance<2) and (1.0-(distance-0.5)/1.5) or 0 --(7 - distance) / 5
					if transparency < 0.5 then
						transparency = 0
					end
	 
					if self.lastTransparency then
						local deltaTransparency = transparency - self.lastTransparency
	 
						-- Don't tween transparency if it is instant or your character was fully invisible last frame
						if not instant and transparency < 1 and self.lastTransparency < 0.95 then
							local maxDelta = MAX_TWEEN_RATE * (now - self.lastUpdate)
							deltaTransparency = math.clamp(deltaTransparency, -maxDelta, maxDelta)
						end
						transparency = self.lastTransparency + deltaTransparency
					else
						self.transparencyDirty = true
					end
	 
					transparency = math.clamp(Util.Round(transparency, 2), 0, 1)
				end
	 
				if self.transparencyDirty or self.lastTransparency ~= transparency then
					for child, _ in pairs(self.cachedParts) do
						child.LocalTransparencyModifier = transparency
					end
					self.transparencyDirty = false
					self.lastTransparency = transparency
				end
			end
			self.lastUpdate = now
		end
	 
		return TransparencyController
	end
	 
	function _Poppercam()
		local ZoomController =  _ZoomController()
	 
		local TransformExtrapolator = {} do
			TransformExtrapolator.__index = TransformExtrapolator
	 
			local CF_IDENTITY = CFrame.new()
	 
			local function cframeToAxis(cframe)
				local axis, angle = cframe:toAxisAngle()
				return axis*angle
			end
	 
			local function axisToCFrame(axis)
				local angle = axis.magnitude
				if angle > 1e-5 then
					return CFrame.fromAxisAngle(axis, angle)
				end
				return CF_IDENTITY
			end
	 
			local function extractRotation(cf)
				local _, _, _, xx, yx, zx, xy, yy, zy, xz, yz, zz = cf:components()
				return CFrame.new(0, 0, 0, xx, yx, zx, xy, yy, zy, xz, yz, zz)
			end
	 
			function TransformExtrapolator.new()
				return setmetatable({
					lastCFrame = nil,
				}, TransformExtrapolator)
			end
	 
			function TransformExtrapolator:Step(dt, currentCFrame)
				local lastCFrame = self.lastCFrame or currentCFrame
				self.lastCFrame = currentCFrame
	 
				local currentPos = currentCFrame.p
				local currentRot = extractRotation(currentCFrame)
	 
				local lastPos = lastCFrame.p
				local lastRot = extractRotation(lastCFrame)
	 
				-- Estimate velocities from the delta between now and the last frame
				-- This estimation can be a little noisy.
				local dp = (currentPos - lastPos)/dt
				local dr = cframeToAxis(currentRot*lastRot:inverse())/dt
	 
				local function extrapolate(t)
					local p = dp*t + currentPos
					local r = axisToCFrame(dr*t)*currentRot
					return r + p
				end
	 
				return {
					extrapolate = extrapolate,
					posVelocity = dp,
					rotVelocity = dr,
				}
			end
	 
			function TransformExtrapolator:Reset()
				self.lastCFrame = nil
			end
		end
	 
		--[[ The Module ]]--
		local BaseOcclusion = _BaseOcclusion()
		local Poppercam = setmetatable({}, BaseOcclusion)
		Poppercam.__index = Poppercam
	 
		function Poppercam.new()
			local self = setmetatable(BaseOcclusion.new(), Poppercam)
			self.focusExtrapolator = TransformExtrapolator.new()
			return self
		end
	 
		function Poppercam:GetOcclusionMode()
			return Enum.DevCameraOcclusionMode.Zoom
		end
	 
		function Poppercam:Enable(enable)
			self.focusExtrapolator:Reset()
		end
	 
		function Poppercam:Update(renderDt, desiredCameraCFrame, desiredCameraFocus, cameraController)
			local rotatedFocus = CFrame.new(desiredCameraFocus.p, desiredCameraCFrame.p)*CFrame.new(
				0, 0, 0,
				-1, 0, 0,
				0, 1, 0,
				0, 0, -1
			)
			local extrapolation = self.focusExtrapolator:Step(renderDt, rotatedFocus)
			local zoom = ZoomController.Update(renderDt, rotatedFocus, extrapolation)
			return rotatedFocus*CFrame.new(0, 0, zoom), desiredCameraFocus
		end
	 
		-- Called when character is added
		function Poppercam:CharacterAdded(character, player)
		end
	 
		-- Called when character is about to be removed
		function Poppercam:CharacterRemoving(character, player)
		end
	 
		function Poppercam:OnCameraSubjectChanged(newSubject)
		end
	 
		local ZoomController = _ZoomController()
	 
		function Poppercam:Update(renderDt, desiredCameraCFrame, desiredCameraFocus, cameraController)
			local rotatedFocus = desiredCameraFocus * (desiredCameraCFrame - desiredCameraCFrame.p)
			local extrapolation = self.focusExtrapolator:Step(renderDt, rotatedFocus)
			local zoom = ZoomController.Update(renderDt, rotatedFocus, extrapolation)
			return rotatedFocus*CFrame.new(0, 0, zoom), desiredCameraFocus
		end
	 
		return Poppercam
	end
	 
	function _Invisicam()
	 
		--[[ Top Level Roblox Services ]]--
		local PlayersService = game:GetService("Players")
	 
		--[[ Constants ]]--
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
		local USE_STACKING_TRANSPARENCY = true	-- Multiple items between the subject and camera get transparency values that add up to TARGET_TRANSPARENCY
		local TARGET_TRANSPARENCY = 0.75 -- Classic Invisicam's Value, also used by new invisicam for parts hit by head and torso rays
		local TARGET_TRANSPARENCY_PERIPHERAL = 0.5 -- Used by new SMART_CIRCLE mode for items not hit by head and torso rays
	 
		local MODE = {
			--CUSTOM = 1, 		-- Retired, unused
			LIMBS = 2, 			-- Track limbs
			MOVEMENT = 3, 		-- Track movement
			CORNERS = 4, 		-- Char model corners
			CIRCLE1 = 5, 		-- Circle of casts around character
			CIRCLE2 = 6, 		-- Circle of casts around character, camera relative
			LIMBMOVE = 7, 		-- LIMBS mode + MOVEMENT mode
			SMART_CIRCLE = 8, 	-- More sample points on and around character
			CHAR_OUTLINE = 9,	-- Dynamic outline around the character
		}
	 
		local LIMB_TRACKING_SET = {
			-- Body parts common to R15 and R6
			['Head'] = true,
	 
			-- Body parts unique to R6
			['Left Arm'] = true,
			['Right Arm'] = true,
			['Left Leg'] = true,
			['Right Leg'] = true,
	 
			-- Body parts unique to R15
			['LeftLowerArm'] = true,
			['RightLowerArm'] = true,
			['LeftUpperLeg'] = true,
			['RightUpperLeg'] = true
		}
	 
		local CORNER_FACTORS = {
			Vector3.new(1,1,-1),
			Vector3.new(1,-1,-1),
			Vector3.new(-1,-1,-1),
			Vector3.new(-1,1,-1)
		}
	 
		local CIRCLE_CASTS = 10
		local MOVE_CASTS = 3
		local SMART_CIRCLE_CASTS = 24
		local SMART_CIRCLE_INCREMENT = 2.0 * math.pi / SMART_CIRCLE_CASTS
		local CHAR_OUTLINE_CASTS = 24
	 
		-- Used to sanitize user-supplied functions
		local function AssertTypes(param, ...)
			local allowedTypes = {}
			local typeString = ''
			for _, typeName in pairs({...}) do
				allowedTypes[typeName] = true
				typeString = typeString .. (typeString == '' and '' or ' or ') .. typeName
			end
			local theType = type(param)
			assert(allowedTypes[theType], typeString .. " type expected, got: " .. theType)
		end
	 
		-- Helper function for Determinant of 3x3, not in CameraUtils for performance reasons
		local function Det3x3(a,b,c,d,e,f,g,h,i)
			return (a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g))
		end
	 
		-- Smart Circle mode needs the intersection of 2 rays that are known to be in the same plane
		-- because they are generated from cross products with a common vector. This function is computing
		-- that intersection, but it's actually the general solution for the point halfway between where
		-- two skew lines come nearest to each other, which is more forgiving.
		local function RayIntersection(p0, v0, p1, v1)
			local v2 = v0:Cross(v1)
			local d1 = p1.x - p0.x
			local d2 = p1.y - p0.y
			local d3 = p1.z - p0.z
			local denom = Det3x3(v0.x,-v1.x,v2.x,v0.y,-v1.y,v2.y,v0.z,-v1.z,v2.z)
	 
			if (denom == 0) then
				return ZERO_VECTOR3 -- No solution (rays are parallel)
			end
	 
			local t0 = Det3x3(d1,-v1.x,v2.x,d2,-v1.y,v2.y,d3,-v1.z,v2.z) / denom
			local t1 = Det3x3(v0.x,d1,v2.x,v0.y,d2,v2.y,v0.z,d3,v2.z) / denom
			local s0 = p0 + t0 * v0
			local s1 = p1 + t1 * v1
			local s = s0 + 0.5 * ( s1 - s0 )
	 
			-- 0.25 studs is a threshold for deciding if the rays are
			-- close enough to be considered intersecting, found through testing 
			if (s1-s0).Magnitude < 0.25 then
				return s
			else
				return ZERO_VECTOR3
			end
		end
	 
	 
	 
		--[[ The Module ]]--
		local BaseOcclusion = _BaseOcclusion()
		local Invisicam = setmetatable({}, BaseOcclusion)
		Invisicam.__index = Invisicam
	 
		function Invisicam.new()
			local self = setmetatable(BaseOcclusion.new(), Invisicam)
	 
			self.char = nil
			self.humanoidRootPart = nil
			self.torsoPart = nil
			self.headPart = nil
	 
			self.childAddedConn = nil
			self.childRemovedConn = nil
	 
			self.behaviors = {} 	-- Map of modes to behavior fns
			self.behaviors[MODE.LIMBS] = self.LimbBehavior
			self.behaviors[MODE.MOVEMENT] = self.MoveBehavior
			self.behaviors[MODE.CORNERS] = self.CornerBehavior
			self.behaviors[MODE.CIRCLE1] = self.CircleBehavior
			self.behaviors[MODE.CIRCLE2] = self.CircleBehavior
			self.behaviors[MODE.LIMBMOVE] = self.LimbMoveBehavior
			self.behaviors[MODE.SMART_CIRCLE] = self.SmartCircleBehavior
			self.behaviors[MODE.CHAR_OUTLINE] = self.CharacterOutlineBehavior
	 
			self.mode = MODE.SMART_CIRCLE
			self.behaviorFunction = self.SmartCircleBehavior
	 
			self.savedHits = {} 	-- Objects currently being faded in/out
			self.trackedLimbs = {}	-- Used in limb-tracking casting modes
	 
			self.camera = game.Workspace.CurrentCamera
	 
			self.enabled = false
			return self
		end
	 
		function Invisicam:Enable(enable)
			self.enabled = enable
	 
			if not enable then
				self:Cleanup()
			end
		end
	 
		function Invisicam:GetOcclusionMode()
			return Enum.DevCameraOcclusionMode.Invisicam
		end
	 
		--[[ Module functions ]]--
		function Invisicam:LimbBehavior(castPoints)
			for limb, _ in pairs(self.trackedLimbs) do
				castPoints[#castPoints + 1] = limb.Position
			end
		end
	 
		function Invisicam:MoveBehavior(castPoints)
			for i = 1, MOVE_CASTS do
				local position, velocity = self.humanoidRootPart.Position, self.humanoidRootPart.Velocity
				local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2
				local offsetVector = (i - 1) * self.humanoidRootPart.CFrame.lookVector * horizontalSpeed
				castPoints[#castPoints + 1] = position + offsetVector
			end
		end
	 
		function Invisicam:CornerBehavior(castPoints)
			local cframe = self.humanoidRootPart.CFrame
			local centerPoint = cframe.p
			local rotation = cframe - centerPoint
			local halfSize = self.char:GetExtentsSize() / 2 --NOTE: Doesn't update w/ limb animations
			castPoints[#castPoints + 1] = centerPoint
			for i = 1, #CORNER_FACTORS do
				castPoints[#castPoints + 1] = centerPoint + (rotation * (halfSize * CORNER_FACTORS[i]))
			end
		end
	 
		function Invisicam:CircleBehavior(castPoints)
			local cframe
			if self.mode == MODE.CIRCLE1 then
				cframe = self.humanoidRootPart.CFrame
			else
				local camCFrame = self.camera.CoordinateFrame
				cframe = camCFrame - camCFrame.p + self.humanoidRootPart.Position
			end
			castPoints[#castPoints + 1] = cframe.p
			for i = 0, CIRCLE_CASTS - 1 do
				local angle = (2 * math.pi / CIRCLE_CASTS) * i
				local offset = 3 * Vector3.new(math.cos(angle), math.sin(angle), 0)
				castPoints[#castPoints + 1] = cframe * offset
			end
		end
	 
		function Invisicam:LimbMoveBehavior(castPoints)
			self:LimbBehavior(castPoints)
			self:MoveBehavior(castPoints)
		end
	 
		function Invisicam:CharacterOutlineBehavior(castPoints)
			local torsoUp = self.torsoPart.CFrame.upVector.unit
			local torsoRight = self.torsoPart.CFrame.rightVector.unit
	 
			-- Torso cross of points for interior coverage
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoUp
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoUp
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoRight
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoRight
			if self.headPart then
				castPoints[#castPoints + 1] = self.headPart.CFrame.p
			end
	 
			local cframe = CFrame.new(ZERO_VECTOR3,Vector3.new(self.camera.CoordinateFrame.lookVector.X,0,self.camera.CoordinateFrame.lookVector.Z))
			local centerPoint = (self.torsoPart and self.torsoPart.Position or self.humanoidRootPart.Position)
	 
			local partsWhitelist = {self.torsoPart}
			if self.headPart then
				partsWhitelist[#partsWhitelist + 1] = self.headPart
			end
	 
			for i = 1, CHAR_OUTLINE_CASTS do
				local angle = (2 * math.pi * i / CHAR_OUTLINE_CASTS)
				local offset = cframe * (3 * Vector3.new(math.cos(angle), math.sin(angle), 0))
	 
				offset = Vector3.new(offset.X, math.max(offset.Y, -2.25), offset.Z)	
	 
				local ray = Ray.new(centerPoint + offset, -3 * offset)
				local hit, hitPoint = game.Workspace:FindPartOnRayWithWhitelist(ray, partsWhitelist, false, false)
	 
				if hit then
					-- Use hit point as the cast point, but nudge it slightly inside the character so that bumping up against
					-- walls is less likely to cause a transparency glitch
					castPoints[#castPoints + 1] = hitPoint + 0.2 * (centerPoint - hitPoint).unit
				end
			end
		end
	 
		function Invisicam:SmartCircleBehavior(castPoints)
			local torsoUp = self.torsoPart.CFrame.upVector.unit
			local torsoRight = self.torsoPart.CFrame.rightVector.unit
	 
			-- SMART_CIRCLE mode includes rays to head and 5 to the torso.
			-- Hands, arms, legs and feet are not included since they
			-- are not canCollide and can therefore go inside of parts
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoUp
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoUp
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p + torsoRight
			castPoints[#castPoints + 1] = self.torsoPart.CFrame.p - torsoRight
			if self.headPart then
				castPoints[#castPoints + 1] = self.headPart.CFrame.p
			end
	 
			local cameraOrientation = self.camera.CFrame - self.camera.CFrame.p
			local torsoPoint = Vector3.new(0,0.5,0) + (self.torsoPart and self.torsoPart.Position or self.humanoidRootPart.Position)
			local radius = 2.5
	 
			-- This loop first calculates points in a circle of radius 2.5 around the torso of the character, in the
			-- plane orthogonal to the camera's lookVector. Each point is then raycast to, to determine if it is within
			-- the free space surrounding the player (not inside anything). Two iterations are done to adjust points that
			-- are inside parts, to try to move them to valid locations that are still on their camera ray, so that the
			-- circle remains circular from the camera's perspective, but does not cast rays into walls or parts that are
			-- behind, below or beside the character and not really obstructing view of the character. This minimizes
			-- the undesirable situation where the character walks up to an exterior wall and it is made invisible even
			-- though it is behind the character.
			for i = 1, SMART_CIRCLE_CASTS do
				local angle = SMART_CIRCLE_INCREMENT * i - 0.5 * math.pi
				local offset = radius * Vector3.new(math.cos(angle), math.sin(angle), 0)
				local circlePoint = torsoPoint + cameraOrientation * offset
	 
				-- Vector from camera to point on the circle being tested
				local vp = circlePoint - self.camera.CFrame.p
	 
				local ray = Ray.new(torsoPoint, circlePoint - torsoPoint)
				local hit, hp, hitNormal = game.Workspace:FindPartOnRayWithIgnoreList(ray, {self.char}, false, false )
				local castPoint = circlePoint
	 
				if hit then
					local hprime = hp + 0.1 * hitNormal.unit -- Slightly offset hit point from the hit surface
					local v0 = hprime - torsoPoint -- Vector from torso to offset hit point
	 
					local perp = (v0:Cross(vp)).unit
	 
					-- Vector from the offset hit point, along the hit surface
					local v1 = (perp:Cross(hitNormal)).unit
	 
					-- Vector from camera to offset hit
					local vprime = (hprime - self.camera.CFrame.p).unit
	 
					-- This dot product checks to see if the vector along the hit surface would hit the correct
					-- side of the invisicam cone, or if it would cross the camera look vector and hit the wrong side
					if ( v0.unit:Dot(-v1) < v0.unit:Dot(vprime)) then
						castPoint = RayIntersection(hprime, v1, circlePoint, vp)
	 
						if castPoint.Magnitude > 0 then
							local ray = Ray.new(hprime, castPoint - hprime)
							local hit, hitPoint, hitNormal = game.Workspace:FindPartOnRayWithIgnoreList(ray, {self.char}, false, false )
	 
							if hit then
								local hprime2 = hitPoint + 0.1 * hitNormal.unit
								castPoint = hprime2
							end
						else
							castPoint = hprime
						end
					else
						castPoint = hprime
					end
	 
					local ray = Ray.new(torsoPoint, (castPoint - torsoPoint))
					local hit, hitPoint, hitNormal = game.Workspace:FindPartOnRayWithIgnoreList(ray, {self.char}, false, false )
	 
					if hit then
						local castPoint2 = hitPoint - 0.1 * (castPoint - torsoPoint).unit
						castPoint = castPoint2
					end
				end
	 
				castPoints[#castPoints + 1] = castPoint
			end
		end
	 
		function Invisicam:CheckTorsoReference()
			if self.char then
				self.torsoPart = self.char:FindFirstChild("Torso")
				if not self.torsoPart then
					self.torsoPart = self.char:FindFirstChild("UpperTorso")
					if not self.torsoPart then
						self.torsoPart = self.char:FindFirstChild("HumanoidRootPart")
					end
				end
	 
				self.headPart = self.char:FindFirstChild("Head")
			end
		end
	 
		function Invisicam:CharacterAdded(char, player)
			-- We only want the LocalPlayer's character
			if player~=PlayersService.LocalPlayer then return end
	 
			if self.childAddedConn then
				self.childAddedConn:Disconnect()
				self.childAddedConn = nil
			end
			if self.childRemovedConn then
				self.childRemovedConn:Disconnect()
				self.childRemovedConn = nil
			end
	 
			self.char = char
	 
			self.trackedLimbs = {}
			local function childAdded(child)
				if child:IsA("BasePart") then
					if LIMB_TRACKING_SET[child.Name] then
						self.trackedLimbs[child] = true
					end
	 
					if child.Name == "Torso" or child.Name == "UpperTorso" then
						self.torsoPart = child
					end
	 
					if child.Name == "Head" then
						self.headPart = child
					end
				end
			end
	 
			local function childRemoved(child)
				self.trackedLimbs[child] = nil
	 
				-- If removed/replaced part is 'Torso' or 'UpperTorso' double check that we still have a TorsoPart to use
				self:CheckTorsoReference()
			end
	 
			self.childAddedConn = char.ChildAdded:Connect(childAdded)
			self.childRemovedConn = char.ChildRemoved:Connect(childRemoved)
			for _, child in pairs(self.char:GetChildren()) do
				childAdded(child)
			end
		end
	 
		function Invisicam:SetMode(newMode)
			AssertTypes(newMode, 'number')
			for _, modeNum in pairs(MODE) do
				if modeNum == newMode then
					self.mode = newMode
					self.behaviorFunction = self.behaviors[self.mode]
					return
				end
			end
			error("Invalid mode number")
		end
	 
		function Invisicam:GetObscuredParts()
			return self.savedHits
		end
	 
		-- Want to turn off Invisicam? Be sure to call this after.
		function Invisicam:Cleanup()
			for hit, originalFade in pairs(self.savedHits) do
				hit.LocalTransparencyModifier = originalFade
			end
		end
	 
		function Invisicam:Update(dt, desiredCameraCFrame, desiredCameraFocus)
			-- Bail if there is no Character
			if not self.enabled or not self.char then
				return desiredCameraCFrame, desiredCameraFocus
			end
	 
			self.camera = game.Workspace.CurrentCamera
	 
			-- TODO: Move this to a GetHumanoidRootPart helper, probably combine with CheckTorsoReference
			-- Make sure we still have a HumanoidRootPart
			if not self.humanoidRootPart then
				local humanoid = self.char:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.RootPart then
					self.humanoidRootPart = humanoid.RootPart
				else
					-- Not set up with Humanoid? Try and see if there's one in the Character at all:
					self.humanoidRootPart = self.char:FindFirstChild("HumanoidRootPart")
					if not self.humanoidRootPart then
						-- Bail out, since we're relying on HumanoidRootPart existing
						return desiredCameraCFrame, desiredCameraFocus
					end
				end
	 
				-- TODO: Replace this with something more sensible
				local ancestryChangedConn
				ancestryChangedConn = self.humanoidRootPart.AncestryChanged:Connect(function(child, parent)
					if child == self.humanoidRootPart and not parent then 
						self.humanoidRootPart = nil
						if ancestryChangedConn and ancestryChangedConn.Connected then
							ancestryChangedConn:Disconnect()
							ancestryChangedConn = nil
						end
					end
				end)
			end
	 
			if not self.torsoPart then
				self:CheckTorsoReference()
				if not self.torsoPart then
					-- Bail out, since we're relying on Torso existing, should never happen since we fall back to using HumanoidRootPart as torso
					return desiredCameraCFrame, desiredCameraFocus
				end
			end
	 
			-- Make a list of world points to raycast to
			local castPoints = {}
			self.behaviorFunction(self, castPoints)
	 
			-- Cast to get a list of objects between the camera and the cast points
			local currentHits = {}
			local ignoreList = {self.char}
			local function add(hit)
				currentHits[hit] = true
				if not self.savedHits[hit] then
					self.savedHits[hit] = hit.LocalTransparencyModifier
				end
			end
	 
			local hitParts
			local hitPartCount = 0
	 
			-- Hash table to treat head-ray-hit parts differently than the rest of the hit parts hit by other rays
			-- head/torso ray hit parts will be more transparent than peripheral parts when USE_STACKING_TRANSPARENCY is enabled
			local headTorsoRayHitParts = {}
	 
			local perPartTransparencyHeadTorsoHits = TARGET_TRANSPARENCY
			local perPartTransparencyOtherHits = TARGET_TRANSPARENCY
	 
			if USE_STACKING_TRANSPARENCY then
	 
				-- This first call uses head and torso rays to find out how many parts are stacked up
				-- for the purpose of calculating required per-part transparency
				local headPoint = self.headPart and self.headPart.CFrame.p or castPoints[1]
				local torsoPoint = self.torsoPart and self.torsoPart.CFrame.p or castPoints[2]
				hitParts = self.camera:GetPartsObscuringTarget({headPoint, torsoPoint}, ignoreList)
	 
				-- Count how many things the sample rays passed through, including decals. This should only
				-- count decals facing the camera, but GetPartsObscuringTarget does not return surface normals,
				-- so my compromise for now is to just let any decal increase the part count by 1. Only one
				-- decal per part will be considered.
				for i = 1, #hitParts do
					local hitPart = hitParts[i]
					hitPartCount = hitPartCount + 1 -- count the part itself
					headTorsoRayHitParts[hitPart] = true
					for _, child in pairs(hitPart:GetChildren()) do
						if child:IsA('Decal') or child:IsA('Texture') then
							hitPartCount = hitPartCount + 1 -- count first decal hit, then break
							break
						end
					end
				end
	 
				if (hitPartCount > 0) then
					perPartTransparencyHeadTorsoHits = math.pow( ((0.5 * TARGET_TRANSPARENCY) + (0.5 * TARGET_TRANSPARENCY / hitPartCount)), 1 / hitPartCount )
					perPartTransparencyOtherHits = math.pow( ((0.5 * TARGET_TRANSPARENCY_PERIPHERAL) + (0.5 * TARGET_TRANSPARENCY_PERIPHERAL / hitPartCount)), 1 / hitPartCount )
				end
			end
	 
			-- Now get all the parts hit by all the rays
			hitParts = self.camera:GetPartsObscuringTarget(castPoints, ignoreList)
	 
			local partTargetTransparency = {}
	 
			-- Include decals and textures
			for i = 1, #hitParts do
				local hitPart = hitParts[i]
	 
				partTargetTransparency[hitPart] =headTorsoRayHitParts[hitPart] and perPartTransparencyHeadTorsoHits or perPartTransparencyOtherHits
	 
				-- If the part is not already as transparent or more transparent than what invisicam requires, add it to the list of
				-- parts to be modified by invisicam
				if hitPart.Transparency < partTargetTransparency[hitPart] then
					add(hitPart)
				end
	 
				-- Check all decals and textures on the part
				for _, child in pairs(hitPart:GetChildren()) do
					if child:IsA('Decal') or child:IsA('Texture') then
						if (child.Transparency < partTargetTransparency[hitPart]) then
							partTargetTransparency[child] = partTargetTransparency[hitPart]
							add(child)
						end
					end
				end
			end
	 
			-- Invisibilize objects that are in the way, restore those that aren't anymore
			for hitPart, originalLTM in pairs(self.savedHits) do
				if currentHits[hitPart] then
					-- LocalTransparencyModifier gets whatever value is required to print the part's total transparency to equal perPartTransparency
					hitPart.LocalTransparencyModifier = (hitPart.Transparency < 1) and ((partTargetTransparency[hitPart] - hitPart.Transparency) / (1.0 - hitPart.Transparency)) or 0
				else -- Restore original pre-invisicam value of LTM
					hitPart.LocalTransparencyModifier = originalLTM
					self.savedHits[hitPart] = nil
				end
			end
	 
			-- Invisicam does not change the camera values
			return desiredCameraCFrame, desiredCameraFocus
		end
	 
		return Invisicam
	end
	 
	function _LegacyCamera()
	 
		local ZERO_VECTOR2 = Vector2.new(0,0)
	 
		local Util = _CameraUtils()
	 
		--[[ Services ]]--
		local PlayersService = game:GetService('Players')
	 
		--[[ The Module ]]--
		local BaseCamera = _BaseCamera()
		local LegacyCamera = setmetatable({}, BaseCamera)
		LegacyCamera.__index = LegacyCamera
	 
		function LegacyCamera.new()
			local self = setmetatable(BaseCamera.new(), LegacyCamera)
	 
			self.cameraType = Enum.CameraType.Fixed
			self.lastUpdate = tick()
			self.lastDistanceToSubject = nil
	 
			return self
		end
	 
		function LegacyCamera:GetModuleName()
			return "LegacyCamera"
		end
	 
		--[[ Functions overridden from BaseCamera ]]--
		function LegacyCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
			return BaseCamera.SetCameraToSubjectDistance(self,desiredSubjectDistance)
		end
	 
		function LegacyCamera:Update(dt)
	 
			-- Cannot update until cameraType has been set
			if not self.cameraType then return end
	 
			local now = tick()
			local timeDelta = (now - self.lastUpdate)
			local camera = 	workspace.CurrentCamera
			local newCameraCFrame = camera.CFrame
			local newCameraFocus = camera.Focus
			local player = PlayersService.LocalPlayer
	 
			if self.lastUpdate == nil or timeDelta > 1 then
				self.lastDistanceToSubject = nil
			end
			local subjectPosition = self:GetSubjectPosition()
	 
			if self.cameraType == Enum.CameraType.Fixed then
				if self.lastUpdate then
					-- Cap out the delta to 0.1 so we don't get some crazy things when we re-resume from
					local delta = math.min(0.1, now - self.lastUpdate)
					local gamepadRotation = self:UpdateGamepad()
					self.rotateInput = self.rotateInput + (gamepadRotation * delta)
				end
	 
				if subjectPosition and player and camera then
					local distanceToSubject = self:GetCameraToSubjectDistance()
					local newLookVector = self:CalculateNewLookVector()
					self.rotateInput = ZERO_VECTOR2
	 
					newCameraFocus = camera.Focus -- Fixed camera does not change focus
					newCameraCFrame = CFrame.new(camera.CFrame.p, camera.CFrame.p + (distanceToSubject * newLookVector))
				end
			elseif self.cameraType == Enum.CameraType.Attach then
				if subjectPosition and camera then
					local distanceToSubject = self:GetCameraToSubjectDistance()
					local humanoid = self:GetHumanoid()
					if self.lastUpdate and humanoid and humanoid.RootPart then
	 
						-- Cap out the delta to 0.1 so we don't get some crazy things when we re-resume from
						local delta = math.min(0.1, now - self.lastUpdate)
						local gamepadRotation = self:UpdateGamepad()
						self.rotateInput = self.rotateInput + (gamepadRotation * delta)
	 
						local forwardVector = humanoid.RootPart.CFrame.lookVector
	 
						local y = Util.GetAngleBetweenXZVectors(forwardVector, self:GetCameraLookVector())
						if Util.IsFinite(y) then
							-- Preserve vertical rotation from user input
							self.rotateInput = Vector2.new(y, self.rotateInput.Y)
						end
					end
	 
					local newLookVector = self:CalculateNewLookVector()
					self.rotateInput = ZERO_VECTOR2
	 
					newCameraFocus = CFrame.new(subjectPosition)
					newCameraCFrame = CFrame.new(subjectPosition - (distanceToSubject * newLookVector), subjectPosition)
				end
			elseif self.cameraType == Enum.CameraType.Watch then
				if subjectPosition and player and camera then
					local cameraLook = nil
	 
					local humanoid = self:GetHumanoid()
					if humanoid and humanoid.RootPart then
						local diffVector = subjectPosition - camera.CFrame.p
						cameraLook = diffVector.unit
	 
						if self.lastDistanceToSubject and self.lastDistanceToSubject == self:GetCameraToSubjectDistance() then
							-- Don't clobber the zoom if they zoomed the camera
							local newDistanceToSubject = diffVector.magnitude
							self:SetCameraToSubjectDistance(newDistanceToSubject)
						end
					end
	 
					local distanceToSubject = self:GetCameraToSubjectDistance()
					local newLookVector = self:CalculateNewLookVector(cameraLook)
					self.rotateInput = ZERO_VECTOR2
	 
					newCameraFocus = CFrame.new(subjectPosition)
					newCameraCFrame = CFrame.new(subjectPosition - (distanceToSubject * newLookVector), subjectPosition)
	 
					self.lastDistanceToSubject = distanceToSubject
				end
			else
				-- Unsupported type, return current values unchanged
				return camera.CFrame, camera.Focus
			end
	 
			self.lastUpdate = now
			return newCameraCFrame, newCameraFocus
		end
	 
		return LegacyCamera
	end
	 
	function _OrbitalCamera()
	 
		-- Local private variables and constants
		local UNIT_Z = Vector3.new(0,0,1)
		local X1_Y0_Z1 = Vector3.new(1,0,1)	--Note: not a unit vector, used for projecting onto XZ plane
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
		local ZERO_VECTOR2 = Vector2.new(0,0)
		local TAU = 2 * math.pi
	 
		--[[ Gamepad Support ]]--
		local THUMBSTICK_DEADZONE = 0.2
	 
		-- Do not edit these values, they are not the developer-set limits, they are limits
		-- to the values the camera system equations can correctly handle
		local MIN_ALLOWED_ELEVATION_DEG = -80
		local MAX_ALLOWED_ELEVATION_DEG = 80
	 
		local externalProperties = {}
		externalProperties["InitialDistance"]  = 25
		externalProperties["MinDistance"]      = 10
		externalProperties["MaxDistance"]      = 100
		externalProperties["InitialElevation"] = 35
		externalProperties["MinElevation"]     = 35
		externalProperties["MaxElevation"]     = 35
		externalProperties["ReferenceAzimuth"] = -45	-- Angle around the Y axis where the camera starts. -45 offsets the camera in the -X and +Z directions equally
		externalProperties["CWAzimuthTravel"]  = 90	-- How many degrees the camera is allowed to rotate from the reference position, CW as seen from above
		externalProperties["CCWAzimuthTravel"] = 90	-- How many degrees the camera is allowed to rotate from the reference position, CCW as seen from above
		externalProperties["UseAzimuthLimits"] = false -- Full rotation around Y axis available by default
	 
		local Util = _CameraUtils()
	 
		--[[ Services ]]--
		local PlayersService = game:GetService('Players')
		local VRService = game:GetService("VRService")
	 
		--[[ The Module ]]--
		local BaseCamera = _BaseCamera()
		local OrbitalCamera = setmetatable({}, BaseCamera)
		OrbitalCamera.__index = OrbitalCamera
	 
	 
		function OrbitalCamera.new()
			local self = setmetatable(BaseCamera.new(), OrbitalCamera)
	 
			self.lastUpdate = tick()
	 
			-- OrbitalCamera-specific members
			self.changedSignalConnections = {}
			self.refAzimuthRad = nil
			self.curAzimuthRad = nil
			self.minAzimuthAbsoluteRad = nil
			self.maxAzimuthAbsoluteRad = nil
			self.useAzimuthLimits = nil
			self.curElevationRad = nil
			self.minElevationRad = nil
			self.maxElevationRad = nil
			self.curDistance = nil
			self.minDistance = nil
			self.maxDistance = nil
	 
			-- Gamepad
			self.r3ButtonDown = false
			self.l3ButtonDown = false
			self.gamepadDollySpeedMultiplier = 1
	 
			self.lastUserPanCamera = tick()
	 
			self.externalProperties = {}
			self.externalProperties["InitialDistance"] 	= 25
			self.externalProperties["MinDistance"] 		= 10
			self.externalProperties["MaxDistance"] 		= 100
			self.externalProperties["InitialElevation"] 	= 35
			self.externalProperties["MinElevation"] 		= 35
			self.externalProperties["MaxElevation"] 		= 35
			self.externalProperties["ReferenceAzimuth"] 	= -45	-- Angle around the Y axis where the camera starts. -45 offsets the camera in the -X and +Z directions equally
			self.externalProperties["CWAzimuthTravel"] 	= 90	-- How many degrees the camera is allowed to rotate from the reference position, CW as seen from above
			self.externalProperties["CCWAzimuthTravel"] 	= 90	-- How many degrees the camera is allowed to rotate from the reference position, CCW as seen from above
			self.externalProperties["UseAzimuthLimits"] 	= false -- Full rotation around Y axis available by default
			self:LoadNumberValueParameters()
	 
			return self
		end
	 
		function OrbitalCamera:LoadOrCreateNumberValueParameter(name, valueType, updateFunction)
			local valueObj = script:FindFirstChild(name)
	 
			if valueObj and valueObj:isA(valueType) then
				-- Value object exists and is the correct type, use its value
				self.externalProperties[name] = valueObj.Value
			elseif self.externalProperties[name] ~= nil then
				-- Create missing (or replace incorrectly-typed) valueObject with default value
				valueObj = Instance.new(valueType)
				valueObj.Name = name
				valueObj.Parent = script
				valueObj.Value = self.externalProperties[name]
			else
				print("externalProperties table has no entry for ",name)
				return
			end
	 
			if updateFunction then
				if self.changedSignalConnections[name] then
					self.changedSignalConnections[name]:Disconnect()
				end
				self.changedSignalConnections[name] = valueObj.Changed:Connect(function(newValue)
					self.externalProperties[name] = newValue
					updateFunction(self)
				end)
			end
		end
	 
		function OrbitalCamera:SetAndBoundsCheckAzimuthValues()
			self.minAzimuthAbsoluteRad = math.rad(self.externalProperties["ReferenceAzimuth"]) - math.abs(math.rad(self.externalProperties["CWAzimuthTravel"]))
			self.maxAzimuthAbsoluteRad = math.rad(self.externalProperties["ReferenceAzimuth"]) + math.abs(math.rad(self.externalProperties["CCWAzimuthTravel"]))
			self.useAzimuthLimits = self.externalProperties["UseAzimuthLimits"]
			if self.useAzimuthLimits then
				self.curAzimuthRad = math.max(self.curAzimuthRad, self.minAzimuthAbsoluteRad)
				self.curAzimuthRad = math.min(self.curAzimuthRad, self.maxAzimuthAbsoluteRad)
			end
		end
	 
		function OrbitalCamera:SetAndBoundsCheckElevationValues()
			-- These degree values are the direct user input values. It is deliberate that they are
			-- ranged checked only against the extremes, and not against each other. Any time one
			-- is changed, both of the internal values in radians are recalculated. This allows for
			-- A developer to change the values in any order and for the end results to be that the
			-- internal values adjust to match intent as best as possible.
			local minElevationDeg = math.max(self.externalProperties["MinElevation"], MIN_ALLOWED_ELEVATION_DEG)
			local maxElevationDeg = math.min(self.externalProperties["MaxElevation"], MAX_ALLOWED_ELEVATION_DEG)
	 
			-- Set internal values in radians
			self.minElevationRad = math.rad(math.min(minElevationDeg, maxElevationDeg))
			self.maxElevationRad = math.rad(math.max(minElevationDeg, maxElevationDeg))
			self.curElevationRad = math.max(self.curElevationRad, self.minElevationRad)
			self.curElevationRad = math.min(self.curElevationRad, self.maxElevationRad)
		end
	 
		function OrbitalCamera:SetAndBoundsCheckDistanceValues()
			self.minDistance = self.externalProperties["MinDistance"]
			self.maxDistance = self.externalProperties["MaxDistance"]
			self.curDistance = math.max(self.curDistance, self.minDistance)
			self.curDistance = math.min(self.curDistance, self.maxDistance)
		end
	 
		-- This loads from, or lazily creates, NumberValue objects for exposed parameters
		function OrbitalCamera:LoadNumberValueParameters()
			-- These initial values do not require change listeners since they are read only once
			self:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
			self:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
	 
			-- Note: ReferenceAzimuth is also used as an initial value, but needs a change listener because it is used in the calculation of the limits
			self:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", self.SetAndBoundsCheckAzimuthValue)
			self:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
			self:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", self.SetAndBoundsCheckAzimuthValues)
			self:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
			self:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", self.SetAndBoundsCheckElevationValues)
			self:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
			self:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", self.SetAndBoundsCheckDistanceValues)
			self:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", self.SetAndBoundsCheckAzimuthValues)
	 
			-- Internal values set (in radians, from degrees), plus sanitization
			self.curAzimuthRad = math.rad(self.externalProperties["ReferenceAzimuth"])
			self.curElevationRad = math.rad(self.externalProperties["InitialElevation"])
			self.curDistance = self.externalProperties["InitialDistance"]
	 
			self:SetAndBoundsCheckAzimuthValues()
			self:SetAndBoundsCheckElevationValues()
			self:SetAndBoundsCheckDistanceValues()
		end
	 
		function OrbitalCamera:GetModuleName()
			return "OrbitalCamera"
		end
	 
		function OrbitalCamera:SetInitialOrientation(humanoid)
			if not humanoid or not humanoid.RootPart then
				warn("OrbitalCamera could not set initial orientation due to missing humanoid")
				return
			end
			local newDesiredLook = (humanoid.RootPart.CFrame.lookVector - Vector3.new(0,0.23,0)).unit
			local horizontalShift = Util.GetAngleBetweenXZVectors(newDesiredLook, self:GetCameraLookVector())
			local vertShift = math.asin(self:GetCameraLookVector().y) - math.asin(newDesiredLook.y)
			if not Util.IsFinite(horizontalShift) then
				horizontalShift = 0
			end
			if not Util.IsFinite(vertShift) then
				vertShift = 0
			end
			self.rotateInput = Vector2.new(horizontalShift, vertShift)
		end
	 
		--[[ Functions of BaseCamera that are overridden by OrbitalCamera ]]--
		function OrbitalCamera:GetCameraToSubjectDistance()
			return self.curDistance
		end
	 
		function OrbitalCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
			print("OrbitalCamera SetCameraToSubjectDistance ",desiredSubjectDistance)
			local player = PlayersService.LocalPlayer
			if player then
				self.currentSubjectDistance = math.clamp(desiredSubjectDistance, self.minDistance, self.maxDistance)
	 
				-- OrbitalCamera is not allowed to go into the first-person range
				self.currentSubjectDistance = math.max(self.currentSubjectDistance, self.FIRST_PERSON_DISTANCE_THRESHOLD)
			end
			self.inFirstPerson = false
			self:UpdateMouseBehavior()
			return self.currentSubjectDistance
		end
	 
		function OrbitalCamera:CalculateNewLookVector(suppliedLookVector, xyRotateVector)
			local currLookVector = suppliedLookVector or self:GetCameraLookVector()
			local currPitchAngle = math.asin(currLookVector.y)
			local yTheta = math.clamp(xyRotateVector.y, currPitchAngle - math.rad(MAX_ALLOWED_ELEVATION_DEG), currPitchAngle - math.rad(MIN_ALLOWED_ELEVATION_DEG))
			local constrainedRotateInput = Vector2.new(xyRotateVector.x, yTheta)
			local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
			local newLookVector = (CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y,0,0)).lookVector
			return newLookVector
		end
	 
		function OrbitalCamera:GetGamepadPan(name, state, input)
			if input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if self.r3ButtonDown or self.l3ButtonDown then
				-- R3 or L3 Thumbstick is depressed, right stick controls dolly in/out
					if (input.Position.Y > THUMBSTICK_DEADZONE) then
						self.gamepadDollySpeedMultiplier = 0.96
					elseif (input.Position.Y < -THUMBSTICK_DEADZONE) then
						self.gamepadDollySpeedMultiplier = 1.04
					else
						self.gamepadDollySpeedMultiplier = 1.00
					end
				else
					if state == Enum.UserInputState.Cancel then
						self.gamepadPanningCamera = ZERO_VECTOR2
						return
					end
	 
					local inputVector = Vector2.new(input.Position.X, -input.Position.Y)
					if inputVector.magnitude > THUMBSTICK_DEADZONE then
						self.gamepadPanningCamera = Vector2.new(input.Position.X, -input.Position.Y)
					else
						self.gamepadPanningCamera = ZERO_VECTOR2
					end
				end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
	 
		function OrbitalCamera:DoGamepadZoom(name, state, input)
			if input.UserInputType == self.activeGamepad and (input.KeyCode == Enum.KeyCode.ButtonR3 or input.KeyCode == Enum.KeyCode.ButtonL3) then
				if (state == Enum.UserInputState.Begin) then
					self.r3ButtonDown = input.KeyCode == Enum.KeyCode.ButtonR3
					self.l3ButtonDown = input.KeyCode == Enum.KeyCode.ButtonL3
				elseif (state == Enum.UserInputState.End) then
					if (input.KeyCode == Enum.KeyCode.ButtonR3) then
						self.r3ButtonDown = false
					elseif (input.KeyCode == Enum.KeyCode.ButtonL3) then
						self.l3ButtonDown = false
					end
					if (not self.r3ButtonDown) and (not self.l3ButtonDown) then
						self.gamepadDollySpeedMultiplier = 1.00
					end
				end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
	 
		function OrbitalCamera:BindGamepadInputActions()
			self:BindAction("OrbitalCamGamepadPan", function(name, state, input) return self:GetGamepadPan(name, state, input) end,
				false, Enum.KeyCode.Thumbstick2)
			self:BindAction("OrbitalCamGamepadZoom", function(name, state, input) return self:DoGamepadZoom(name, state, input) end,
				false, Enum.KeyCode.ButtonR3, Enum.KeyCode.ButtonL3)
		end
	 
	 
		-- [[ Update ]]--
		function OrbitalCamera:Update(dt)
			local now = tick()
			local timeDelta = (now - self.lastUpdate)
			local userPanningTheCamera = (self.UserPanningTheCamera == true)
			local camera = 	workspace.CurrentCamera
			local newCameraCFrame = camera.CFrame
			local newCameraFocus = camera.Focus
			local player = PlayersService.LocalPlayer
			local cameraSubject = camera and camera.CameraSubject
			local isInVehicle = cameraSubject and cameraSubject:IsA('VehicleSeat')
			local isOnASkateboard = cameraSubject and cameraSubject:IsA('SkateboardPlatform')
	 
			if self.lastUpdate == nil or timeDelta > 1 then
				self.lastCameraTransform = nil
			end
	 
			if self.lastUpdate then
				local gamepadRotation = self:UpdateGamepad()
	 
				if self:ShouldUseVRRotation() then
					self.RotateInput = self.RotateInput + self:GetVRRotationInput()
				else
					-- Cap out the delta to 0.1 so we don't get some crazy things when we re-resume from
					local delta = math.min(0.1, timeDelta)
	 
					if gamepadRotation ~= ZERO_VECTOR2 then
						userPanningTheCamera = true
						self.rotateInput = self.rotateInput + (gamepadRotation * delta)
					end
	 
					local angle = 0
					if not (isInVehicle or isOnASkateboard) then
						angle = angle + (self.TurningLeft and -120 or 0)
						angle = angle + (self.TurningRight and 120 or 0)
					end
	 
					if angle ~= 0 then
						self.rotateInput = self.rotateInput +  Vector2.new(math.rad(angle * delta), 0)
						userPanningTheCamera = true
					end
				end
			end
	 
			-- Reset tween speed if user is panning
			if userPanningTheCamera then
				self.lastUserPanCamera = tick()
			end
	 
			local subjectPosition = self:GetSubjectPosition()
	 
			if subjectPosition and player and camera then
	 
				-- Process any dollying being done by gamepad
				-- TODO: Move this
				if self.gamepadDollySpeedMultiplier ~= 1 then
					self:SetCameraToSubjectDistance(self.currentSubjectDistance * self.gamepadDollySpeedMultiplier)
				end
	 
				local VREnabled = VRService.VREnabled
				newCameraFocus = VREnabled and self:GetVRFocus(subjectPosition, timeDelta) or CFrame.new(subjectPosition)
	 
				local cameraFocusP = newCameraFocus.p
				if VREnabled and not self:IsInFirstPerson() then
					local cameraHeight = self:GetCameraHeight()
					local vecToSubject = (subjectPosition - camera.CFrame.p)
					local distToSubject = vecToSubject.magnitude
	 
					-- Only move the camera if it exceeded a maximum distance to the subject in VR
					if distToSubject > self.currentSubjectDistance or self.rotateInput.x ~= 0 then
						local desiredDist = math.min(distToSubject, self.currentSubjectDistance)
	 
						-- Note that CalculateNewLookVector is overridden from BaseCamera
						vecToSubject = self:CalculateNewLookVector(vecToSubject.unit * X1_Y0_Z1, Vector2.new(self.rotateInput.x, 0)) * desiredDist
	 
						local newPos = cameraFocusP - vecToSubject
						local desiredLookDir = camera.CFrame.lookVector
						if self.rotateInput.x ~= 0 then
							desiredLookDir = vecToSubject
						end
						local lookAt = Vector3.new(newPos.x + desiredLookDir.x, newPos.y, newPos.z + desiredLookDir.z)
						self.RotateInput = ZERO_VECTOR2
	 
						newCameraCFrame = CFrame.new(newPos, lookAt) + Vector3.new(0, cameraHeight, 0)
					end
				else
					-- self.RotateInput is a Vector2 of mouse movement deltas since last update
					self.curAzimuthRad = self.curAzimuthRad - self.rotateInput.x
	 
					if self.useAzimuthLimits then
						self.curAzimuthRad = math.clamp(self.curAzimuthRad, self.minAzimuthAbsoluteRad, self.maxAzimuthAbsoluteRad)
					else
						self.curAzimuthRad = (self.curAzimuthRad ~= 0) and (math.sign(self.curAzimuthRad) * (math.abs(self.curAzimuthRad) % TAU)) or 0
					end
	 
					self.curElevationRad = math.clamp(self.curElevationRad + self.rotateInput.y, self.minElevationRad, self.maxElevationRad)
	 
					local cameraPosVector = self.currentSubjectDistance * ( CFrame.fromEulerAnglesYXZ( -self.curElevationRad, self.curAzimuthRad, 0 ) * UNIT_Z )
					local camPos = subjectPosition + cameraPosVector
	 
					newCameraCFrame = CFrame.new(camPos, subjectPosition)
	 
					self.rotateInput = ZERO_VECTOR2
				end
	 
				self.lastCameraTransform = newCameraCFrame
				self.lastCameraFocus = newCameraFocus
				if (isInVehicle or isOnASkateboard) and cameraSubject:IsA('BasePart') then
					self.lastSubjectCFrame = cameraSubject.CFrame
				else
					self.lastSubjectCFrame = nil
				end
			end
	 
			self.lastUpdate = now
			return newCameraCFrame, newCameraFocus
		end
	 
		return OrbitalCamera
	end
	 
	function _ClassicCamera()
	 
		-- Local private variables and constants
		local ZERO_VECTOR2 = Vector2.new(0,0)
	 
		local tweenAcceleration = math.rad(220)		--Radians/Second^2
		local tweenSpeed = math.rad(0)				--Radians/Second
		local tweenMaxSpeed = math.rad(250)			--Radians/Second
		local TIME_BEFORE_AUTO_ROTATE = 2.0 		--Seconds, used when auto-aligning camera with vehicles
	 
		local INITIAL_CAMERA_ANGLE = CFrame.fromOrientation(math.rad(-15), 0, 0)
	 
		local FFlagUserCameraToggle do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserCameraToggle")
			end)
			FFlagUserCameraToggle = success and result
		end
	 
		--[[ Services ]]--
		local PlayersService = game:GetService('Players')
		local VRService = game:GetService("VRService")
	 
		local CameraInput = _CameraInput()
		local Util = _CameraUtils()
	 
		--[[ The Module ]]--
		local BaseCamera = _BaseCamera()
		local ClassicCamera = setmetatable({}, BaseCamera)
		ClassicCamera.__index = ClassicCamera
	 
		function ClassicCamera.new()
			local self = setmetatable(BaseCamera.new(), ClassicCamera)
	 
			self.isFollowCamera = false
			self.isCameraToggle = false
			self.lastUpdate = tick()
			self.cameraToggleSpring = Util.Spring.new(5, 0)
	 
			return self
		end
	 
		function ClassicCamera:GetCameraToggleOffset(dt)
			assert(FFlagUserCameraToggle)
	 
			if self.isCameraToggle then
				local zoom = self.currentSubjectDistance
	 
				if CameraInput.getTogglePan() then
					self.cameraToggleSpring.goal = math.clamp(Util.map(zoom, 0.5, self.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1), 0, 1)
				else
					self.cameraToggleSpring.goal = 0
				end
	 
				local distanceOffset = math.clamp(Util.map(zoom, 0.5, 64, 0, 1), 0, 1) + 1
				return Vector3.new(0, self.cameraToggleSpring:step(dt)*distanceOffset, 0)
			end
	 
			return Vector3.new()
		end
	 
		-- Movement mode standardized to Enum.ComputerCameraMovementMode values
		function ClassicCamera:SetCameraMovementMode(cameraMovementMode)
			BaseCamera.SetCameraMovementMode(self, cameraMovementMode)
	 
			self.isFollowCamera = cameraMovementMode == Enum.ComputerCameraMovementMode.Follow
			self.isCameraToggle = cameraMovementMode == Enum.ComputerCameraMovementMode.CameraToggle
		end
	 
		function ClassicCamera:Update()
			local now = tick()
			local timeDelta = now - self.lastUpdate
	 
			local camera = workspace.CurrentCamera
			local newCameraCFrame = camera.CFrame
			local newCameraFocus = camera.Focus
	 
			local overrideCameraLookVector = nil
			if self.resetCameraAngle then
				local rootPart = self:GetHumanoidRootPart()
				if rootPart then
					overrideCameraLookVector = (rootPart.CFrame * INITIAL_CAMERA_ANGLE).lookVector
				else
					overrideCameraLookVector = INITIAL_CAMERA_ANGLE.lookVector
				end
				self.resetCameraAngle = false
			end
	 
			local player = PlayersService.LocalPlayer
			local humanoid = self:GetHumanoid()
			local cameraSubject = camera.CameraSubject
			local isInVehicle = cameraSubject and cameraSubject:IsA('VehicleSeat')
			local isOnASkateboard = cameraSubject and cameraSubject:IsA('SkateboardPlatform')
			local isClimbing = humanoid and humanoid:GetState() == Enum.HumanoidStateType.Climbing
	 
			if self.lastUpdate == nil or timeDelta > 1 then
				self.lastCameraTransform = nil
			end
	 
			if self.lastUpdate then
				local gamepadRotation = self:UpdateGamepad()
	 
				if self:ShouldUseVRRotation() then
					self.rotateInput = self.rotateInput + self:GetVRRotationInput()
				else
					-- Cap out the delta to 0.1 so we don't get some crazy things when we re-resume from
					local delta = math.min(0.1, timeDelta)
	 
					if gamepadRotation ~= ZERO_VECTOR2 then
						self.rotateInput = self.rotateInput + (gamepadRotation * delta)
					end
	 
					local angle = 0
					if not (isInVehicle or isOnASkateboard) then
						angle = angle + (self.turningLeft and -120 or 0)
						angle = angle + (self.turningRight and 120 or 0)
					end
	 
					if angle ~= 0 then
						self.rotateInput = self.rotateInput +  Vector2.new(math.rad(angle * delta), 0)
					end
				end
			end
	 
			local cameraHeight = self:GetCameraHeight()
	 
			-- Reset tween speed if user is panning
			if self.userPanningTheCamera then
				tweenSpeed = 0
				self.lastUserPanCamera = tick()
			end
	 
			local userRecentlyPannedCamera = now - self.lastUserPanCamera < TIME_BEFORE_AUTO_ROTATE
			local subjectPosition = self:GetSubjectPosition()
	 
			if subjectPosition and player and camera then
				local zoom = self:GetCameraToSubjectDistance()
				if zoom < 0.5 then
					zoom = 0.5
				end
	 
				if self:GetIsMouseLocked() and not self:IsInFirstPerson() then
					-- We need to use the right vector of the camera after rotation, not before
					local newLookCFrame = self:CalculateNewLookCFrame(overrideCameraLookVector)
	 
					local offset = self:GetMouseLockOffset()
					local cameraRelativeOffset = offset.X * newLookCFrame.rightVector + offset.Y * newLookCFrame.upVector + offset.Z * newLookCFrame.lookVector
	 
					--offset can be NAN, NAN, NAN if newLookVector has only y component
					if Util.IsFiniteVector3(cameraRelativeOffset) then
						subjectPosition = subjectPosition + cameraRelativeOffset
					end
				else
					if not self.userPanningTheCamera and self.lastCameraTransform then
	 
						local isInFirstPerson = self:IsInFirstPerson()
	 
						if (isInVehicle or isOnASkateboard or (self.isFollowCamera and isClimbing)) and self.lastUpdate and humanoid and humanoid.Torso then
							if isInFirstPerson then
								if self.lastSubjectCFrame and (isInVehicle or isOnASkateboard) and cameraSubject:IsA('BasePart') then
									local y = -Util.GetAngleBetweenXZVectors(self.lastSubjectCFrame.lookVector, cameraSubject.CFrame.lookVector)
									if Util.IsFinite(y) then
										self.rotateInput = self.rotateInput + Vector2.new(y, 0)
									end
									tweenSpeed = 0
								end
							elseif not userRecentlyPannedCamera then
								local forwardVector = humanoid.Torso.CFrame.lookVector
								if isOnASkateboard then
									forwardVector = cameraSubject.CFrame.lookVector
								end
	 
								tweenSpeed = math.clamp(tweenSpeed + tweenAcceleration * timeDelta, 0, tweenMaxSpeed)
	 
								local percent = math.clamp(tweenSpeed * timeDelta, 0, 1)
								if self:IsInFirstPerson() and not (self.isFollowCamera and self.isClimbing) then
									percent = 1
								end
	 
								local y = Util.GetAngleBetweenXZVectors(forwardVector, self:GetCameraLookVector())
								if Util.IsFinite(y) and math.abs(y) > 0.0001 then
									self.rotateInput = self.rotateInput + Vector2.new(y * percent, 0)
								end
							end
	 
						elseif self.isFollowCamera and (not (isInFirstPerson or userRecentlyPannedCamera) and not VRService.VREnabled) then
							-- Logic that was unique to the old FollowCamera module
							local lastVec = -(self.lastCameraTransform.p - subjectPosition)
	 
							local y = Util.GetAngleBetweenXZVectors(lastVec, self:GetCameraLookVector())
	 
							-- This cutoff is to decide if the humanoid's angle of movement,
							-- relative to the camera's look vector, is enough that
							-- we want the camera to be following them. The point is to provide
							-- a sizable dead zone to allow more precise forward movements.
							local thetaCutoff = 0.4
	 
							-- Check for NaNs
							if Util.IsFinite(y) and math.abs(y) > 0.0001 and math.abs(y) > thetaCutoff * timeDelta then
								self.rotateInput = self.rotateInput + Vector2.new(y, 0)
							end
						end
					end
				end
	 
				if not self.isFollowCamera then
					local VREnabled = VRService.VREnabled
	 
					if VREnabled then
						newCameraFocus = self:GetVRFocus(subjectPosition, timeDelta)
					else
						newCameraFocus = CFrame.new(subjectPosition)
					end
	 
					local cameraFocusP = newCameraFocus.p
					if VREnabled and not self:IsInFirstPerson() then
						local vecToSubject = (subjectPosition - camera.CFrame.p)
						local distToSubject = vecToSubject.magnitude
	 
						-- Only move the camera if it exceeded a maximum distance to the subject in VR
						if distToSubject > zoom or self.rotateInput.x ~= 0 then
							local desiredDist = math.min(distToSubject, zoom)
							vecToSubject = self:CalculateNewLookVectorVR() * desiredDist
							local newPos = cameraFocusP - vecToSubject
							local desiredLookDir = camera.CFrame.lookVector
							if self.rotateInput.x ~= 0 then
								desiredLookDir = vecToSubject
							end
							local lookAt = Vector3.new(newPos.x + desiredLookDir.x, newPos.y, newPos.z + desiredLookDir.z)
							self.rotateInput = ZERO_VECTOR2
	 
							newCameraCFrame = CFrame.new(newPos, lookAt) + Vector3.new(0, cameraHeight, 0)
						end
					else
						local newLookVector = self:CalculateNewLookVector(overrideCameraLookVector)
						self.rotateInput = ZERO_VECTOR2
						newCameraCFrame = CFrame.new(cameraFocusP - (zoom * newLookVector), cameraFocusP)
					end
				else -- is FollowCamera
					local newLookVector = self:CalculateNewLookVector(overrideCameraLookVector)
					self.rotateInput = ZERO_VECTOR2
	 
					if VRService.VREnabled then
						newCameraFocus = self:GetVRFocus(subjectPosition, timeDelta)
					else
						newCameraFocus = CFrame.new(subjectPosition)
					end
					newCameraCFrame = CFrame.new(newCameraFocus.p - (zoom * newLookVector), newCameraFocus.p) + Vector3.new(0, cameraHeight, 0)
				end
	 
				if FFlagUserCameraToggle then
					local toggleOffset = self:GetCameraToggleOffset(timeDelta)
					newCameraFocus = newCameraFocus + toggleOffset
					newCameraCFrame = newCameraCFrame + toggleOffset
				end
	 
				self.lastCameraTransform = newCameraCFrame
				self.lastCameraFocus = newCameraFocus
				if (isInVehicle or isOnASkateboard) and cameraSubject:IsA('BasePart') then
					self.lastSubjectCFrame = cameraSubject.CFrame
				else
					self.lastSubjectCFrame = nil
				end
			end
	 
			self.lastUpdate = now
			return newCameraCFrame, newCameraFocus
		end
	 
		function ClassicCamera:EnterFirstPerson()
			self.inFirstPerson = true
			self:UpdateMouseBehavior()
		end
	 
		function ClassicCamera:LeaveFirstPerson()
			self.inFirstPerson = false
			self:UpdateMouseBehavior()
		end
	 
		return ClassicCamera
	end
	 
	function _CameraUtils()
	 
		local CameraUtils = {}
	 
		local FFlagUserCameraToggle do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserCameraToggle")
			end)
			FFlagUserCameraToggle = success and result
		end
	 
		local function round(num)
			return math.floor(num + 0.5)
		end
	 
		-- Critically damped spring class for fluid motion effects
		local Spring = {} do
			Spring.__index = Spring
	 
			-- Initialize to a given undamped frequency and default position
			function Spring.new(freq, pos)
				return setmetatable({
					freq = freq,
					goal = pos,
					pos = pos,
					vel = 0,
				}, Spring)
			end
	 
			-- Advance the spring simulation by `dt` seconds
			function Spring:step(dt)
				local f = self.freq*2*math.pi
				local g = self.goal
				local p0 = self.pos
				local v0 = self.vel
	 
				local offset = p0 - g
				local decay = math.exp(-f*dt)
	 
				local p1 = (offset*(1 + f*dt) + v0*dt)*decay + g
				local v1 = (v0*(1 - f*dt) - offset*(f*f*dt))*decay
	 
				self.pos = p1
				self.vel = v1
	 
				return p1
			end
		end
	 
		CameraUtils.Spring = Spring
	 
		-- map a value from one range to another
		function CameraUtils.map(x, inMin, inMax, outMin, outMax)
			return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
		end
	 
		-- From TransparencyController
		function CameraUtils.Round(num, places)
			local decimalPivot = 10^places
			return math.floor(num * decimalPivot + 0.5) / decimalPivot
		end
	 
		function CameraUtils.IsFinite(val)
			return val == val and val ~= math.huge and val ~= -math.huge
		end
	 
		function CameraUtils.IsFiniteVector3(vec3)
			return CameraUtils.IsFinite(vec3.X) and CameraUtils.IsFinite(vec3.Y) and CameraUtils.IsFinite(vec3.Z)
		end
	 
		-- Legacy implementation renamed
		function CameraUtils.GetAngleBetweenXZVectors(v1, v2)
			return math.atan2(v2.X*v1.Z-v2.Z*v1.X, v2.X*v1.X+v2.Z*v1.Z)
		end
	 
		function  CameraUtils.RotateVectorByAngleAndRound(camLook, rotateAngle, roundAmount)
			if camLook.Magnitude > 0 then
				camLook = camLook.unit
				local currAngle = math.atan2(camLook.z, camLook.x)
				local newAngle = round((math.atan2(camLook.z, camLook.x) + rotateAngle) / roundAmount) * roundAmount
				return newAngle - currAngle
			end
			return 0
		end
	 
		-- K is a tunable parameter that changes the shape of the S-curve
		-- the larger K is the more straight/linear the curve gets
		local k = 0.35
		local lowerK = 0.8
		local function SCurveTranform(t)
			t = math.clamp(t, -1, 1)
			if t >= 0 then
				return (k*t) / (k - t + 1)
			end
			return -((lowerK*-t) / (lowerK + t + 1))
		end
	 
		local DEADZONE = 0.1
		local function toSCurveSpace(t)
			return (1 + DEADZONE) * (2*math.abs(t) - 1) - DEADZONE
		end
	 
		local function fromSCurveSpace(t)
			return t/2 + 0.5
		end
	 
		function CameraUtils.GamepadLinearToCurve(thumbstickPosition)
			local function onAxis(axisValue)
				local sign = 1
				if axisValue < 0 then
					sign = -1
				end
				local point = fromSCurveSpace(SCurveTranform(toSCurveSpace(math.abs(axisValue))))
				point = point * sign
				return math.clamp(point, -1, 1)
			end
			return Vector2.new(onAxis(thumbstickPosition.x), onAxis(thumbstickPosition.y))
		end
	 
		-- This function converts 4 different, redundant enumeration types to one standard so the values can be compared
		function CameraUtils.ConvertCameraModeEnumToStandard(enumValue)
			if enumValue == Enum.TouchCameraMovementMode.Default then
				return Enum.ComputerCameraMovementMode.Follow
			end
	 
			if enumValue == Enum.ComputerCameraMovementMode.Default then
				return Enum.ComputerCameraMovementMode.Classic
			end
	 
			if enumValue == Enum.TouchCameraMovementMode.Classic or
				enumValue == Enum.DevTouchCameraMovementMode.Classic or
				enumValue == Enum.DevComputerCameraMovementMode.Classic or
				enumValue == Enum.ComputerCameraMovementMode.Classic then
				return Enum.ComputerCameraMovementMode.Classic
			end
	 
			if enumValue == Enum.TouchCameraMovementMode.Follow or
				enumValue == Enum.DevTouchCameraMovementMode.Follow or
				enumValue == Enum.DevComputerCameraMovementMode.Follow or
				enumValue == Enum.ComputerCameraMovementMode.Follow then
				return Enum.ComputerCameraMovementMode.Follow
			end
	 
			if enumValue == Enum.TouchCameraMovementMode.Orbital or
				enumValue == Enum.DevTouchCameraMovementMode.Orbital or
				enumValue == Enum.DevComputerCameraMovementMode.Orbital or
				enumValue == Enum.ComputerCameraMovementMode.Orbital then
				return Enum.ComputerCameraMovementMode.Orbital
			end
	 
			if FFlagUserCameraToggle then
				if enumValue == Enum.ComputerCameraMovementMode.CameraToggle or
					enumValue == Enum.DevComputerCameraMovementMode.CameraToggle then
					return Enum.ComputerCameraMovementMode.CameraToggle
				end
			end
	 
			-- Note: Only the Dev versions of the Enums have UserChoice as an option
			if enumValue == Enum.DevTouchCameraMovementMode.UserChoice or
				enumValue == Enum.DevComputerCameraMovementMode.UserChoice then
				return Enum.DevComputerCameraMovementMode.UserChoice
			end
	 
			-- For any unmapped options return Classic camera
			return Enum.ComputerCameraMovementMode.Classic
		end
	 
		return CameraUtils
	end
	 
	function _CameraModule()
		local CameraModule = {}
		CameraModule.__index = CameraModule
	 
		local FFlagUserCameraToggle do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserCameraToggle")
			end)
			FFlagUserCameraToggle = success and result
		end
	 
		local FFlagUserRemoveTheCameraApi do
			local success, result = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserRemoveTheCameraApi")
			end)
			FFlagUserRemoveTheCameraApi = success and result
		end
	 
		-- NOTICE: Player property names do not all match their StarterPlayer equivalents,
		-- with the differences noted in the comments on the right
		local PLAYER_CAMERA_PROPERTIES =
		{
			"CameraMinZoomDistance",
			"CameraMaxZoomDistance",
			"CameraMode",
			"DevCameraOcclusionMode",
			"DevComputerCameraMode",			-- Corresponds to StarterPlayer.DevComputerCameraMovementMode
			"DevTouchCameraMode",				-- Corresponds to StarterPlayer.DevTouchCameraMovementMode
	 
			-- Character movement mode
			"DevComputerMovementMode",
			"DevTouchMovementMode",
			"DevEnableMouseLock",				-- Corresponds to StarterPlayer.EnableMouseLockOption
		}
	 
		local USER_GAME_SETTINGS_PROPERTIES =
		{
			"ComputerCameraMovementMode",
			"ComputerMovementMode",
			"ControlMode",
			"GamepadCameraSensitivity",
			"MouseSensitivity",
			"RotationType",
			"TouchCameraMovementMode",
			"TouchMovementMode",
		}
	 
		--[[ Roblox Services ]]--
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local UserGameSettings = UserSettings():GetService("UserGameSettings")
	 
		-- Camera math utility library
		local CameraUtils = _CameraUtils()
	 
		-- Load Roblox Camera Controller Modules
		local ClassicCamera = _ClassicCamera()
		local OrbitalCamera = _OrbitalCamera()
		local LegacyCamera = _LegacyCamera()
	 
		-- Load Roblox Occlusion Modules
		local Invisicam = _Invisicam()
		local Poppercam = _Poppercam()
	 
		-- Load the near-field character transparency controller and the mouse lock "shift lock" controller
		local TransparencyController = _TransparencyController()
		local MouseLockController = _MouseLockController()
	 
		-- Table of camera controllers that have been instantiated. They are instantiated as they are used.
		local instantiatedCameraControllers = {}
		local instantiatedOcclusionModules = {}
	 
		-- Management of which options appear on the Roblox User Settings screen
		do
			local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
	 
			PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
			PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
			PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
	 
			PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
			PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
			PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
			if FFlagUserCameraToggle then
				PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)
			end
		end
	 
		CameraModule.FFlagUserCameraToggle = FFlagUserCameraToggle
	 
	 
		function CameraModule.new()
			local self = setmetatable({},CameraModule)
	 
			-- Current active controller instances
			self.activeCameraController = nil
			self.activeOcclusionModule = nil
			self.activeTransparencyController = nil
			self.activeMouseLockController = nil
	 
			self.currentComputerCameraMovementMode = nil
	 
			-- Connections to events
			self.cameraSubjectChangedConn = nil
			self.cameraTypeChangedConn = nil
	 
			-- Adds CharacterAdded and CharacterRemoving event handlers for all current players
			for _,player in pairs(Players:GetPlayers()) do
				self:OnPlayerAdded(player)
			end
	 
			-- Adds CharacterAdded and CharacterRemoving event handlers for all players who join in the future
			Players.PlayerAdded:Connect(function(player)
				self:OnPlayerAdded(player)
			end)
	 
			self.activeTransparencyController = TransparencyController.new()
			self.activeTransparencyController:Enable(true)
	 
			if not UserInputService.TouchEnabled then
				self.activeMouseLockController = MouseLockController.new()
				local toggleEvent = self.activeMouseLockController:GetBindableToggleEvent()
				if toggleEvent then
					toggleEvent:Connect(function()
						self:OnMouseLockToggled()
					end)
				end
			end
	 
			self:ActivateCameraController(self:GetCameraControlChoice())
			self:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
			self:OnCurrentCameraChanged() -- Does initializations and makes first camera controller
			RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(dt) self:Update(dt) end)
	 
			-- Connect listeners to camera-related properties
			for _, propertyName in pairs(PLAYER_CAMERA_PROPERTIES) do
				Players.LocalPlayer:GetPropertyChangedSignal(propertyName):Connect(function()
					self:OnLocalPlayerCameraPropertyChanged(propertyName)
				end)
			end
	 
			for _, propertyName in pairs(USER_GAME_SETTINGS_PROPERTIES) do
				UserGameSettings:GetPropertyChangedSignal(propertyName):Connect(function()
					self:OnUserGameSettingsPropertyChanged(propertyName)
				end)
			end
			game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				self:OnCurrentCameraChanged()
			end)
	 
			self.lastInputType = UserInputService:GetLastInputType()
			UserInputService.LastInputTypeChanged:Connect(function(newLastInputType)
				self.lastInputType = newLastInputType
			end)
	 
			return self
		end
	 
		function CameraModule:GetCameraMovementModeFromSettings()
			local cameraMode = Players.LocalPlayer.CameraMode
	 
			-- Lock First Person trumps all other settings and forces ClassicCamera
			if cameraMode == Enum.CameraMode.LockFirstPerson then
				return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
			end
	 
			local devMode, userMode
			if UserInputService.TouchEnabled then
				devMode = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
				userMode = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode)
			else
				devMode = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode)
				userMode = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
			end
	 
			if devMode == Enum.DevComputerCameraMovementMode.UserChoice then
				-- Developer is allowing user choice, so user setting is respected
				return userMode
			end
	 
			return devMode
		end
	 
		function CameraModule:ActivateOcclusionModule( occlusionMode )
			local newModuleCreator
			if occlusionMode == Enum.DevCameraOcclusionMode.Zoom then
				newModuleCreator = Poppercam
			elseif occlusionMode == Enum.DevCameraOcclusionMode.Invisicam then
				newModuleCreator = Invisicam
			else
				warn("CameraScript ActivateOcclusionModule called with unsupported mode")
				return
			end
	 
			-- First check to see if there is actually a change. If the module being requested is already
			-- the currently-active solution then just make sure it's enabled and exit early
			if self.activeOcclusionModule and self.activeOcclusionModule:GetOcclusionMode() == occlusionMode then
				if not self.activeOcclusionModule:GetEnabled() then
					self.activeOcclusionModule:Enable(true)
				end
				return
			end
	 
			-- Save a reference to the current active module (may be nil) so that we can disable it if
			-- we are successful in activating its replacement
			local prevOcclusionModule = self.activeOcclusionModule
	 
			-- If there is no active module, see if the one we need has already been instantiated
			self.activeOcclusionModule = instantiatedOcclusionModules[newModuleCreator]
	 
			-- If the module was not already instantiated and selected above, instantiate it
			if not self.activeOcclusionModule then
				self.activeOcclusionModule = newModuleCreator.new()
				if self.activeOcclusionModule then
					instantiatedOcclusionModules[newModuleCreator] = self.activeOcclusionModule
				end
			end
	 
			-- If we were successful in either selecting or instantiating the module,
			-- enable it if it's not already the currently-active enabled module
			if self.activeOcclusionModule then
				local newModuleOcclusionMode = self.activeOcclusionModule:GetOcclusionMode()
				-- Sanity check that the module we selected or instantiated actually supports the desired occlusionMode
				if newModuleOcclusionMode ~= occlusionMode then
					warn("CameraScript ActivateOcclusionModule mismatch: ",self.activeOcclusionModule:GetOcclusionMode(),"~=",occlusionMode)
				end
	 
				-- Deactivate current module if there is one
				if prevOcclusionModule then
					-- Sanity check that current module is not being replaced by itself (that should have been handled above)
					if prevOcclusionModule ~= self.activeOcclusionModule then
						prevOcclusionModule:Enable(false)
					else
						warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
					end
				end
	 
				-- Occlusion modules need to be initialized with information about characters and cameraSubject
				-- Invisicam needs the LocalPlayer's character
				-- Poppercam needs all player characters and the camera subject
				if occlusionMode == Enum.DevCameraOcclusionMode.Invisicam then
					-- Optimization to only send Invisicam what we know it needs
					if Players.LocalPlayer.Character then
						self.activeOcclusionModule:CharacterAdded(Players.LocalPlayer.Character, Players.LocalPlayer )
					end
				else
					-- When Poppercam is enabled, we send it all existing player characters for its raycast ignore list
					for _, player in pairs(Players:GetPlayers()) do
						if player and player.Character then
							self.activeOcclusionModule:CharacterAdded(player.Character, player)
						end
					end
					self.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
				end
	 
				-- Activate new choice
				self.activeOcclusionModule:Enable(true)
			end
		end
	 
		-- When supplied, legacyCameraType is used and cameraMovementMode is ignored (should be nil anyways)
		-- Next, if userCameraCreator is passed in, that is used as the cameraCreator
		function CameraModule:ActivateCameraController(cameraMovementMode, legacyCameraType)
			local newCameraCreator = nil
	 
			if legacyCameraType~=nil then
				--[[
					This function has been passed a CameraType enum value. Some of these map to the use of
					the LegacyCamera module, the value "Custom" will be translated to a movementMode enum
					value based on Dev and User settings, and "Scriptable" will disable the camera controller.
				--]]
	 
				if legacyCameraType == Enum.CameraType.Scriptable then
					if self.activeCameraController then
						self.activeCameraController:Enable(false)
						self.activeCameraController = nil
						return
					end
				elseif legacyCameraType == Enum.CameraType.Custom then
					cameraMovementMode = self:GetCameraMovementModeFromSettings()
	 
				elseif legacyCameraType == Enum.CameraType.Track then
					-- Note: The TrackCamera module was basically an older, less fully-featured
					-- version of ClassicCamera, no longer actively maintained, but it is re-implemented in
					-- case a game was dependent on its lack of ClassicCamera's extra functionality.
					cameraMovementMode = Enum.ComputerCameraMovementMode.Classic
	 
				elseif legacyCameraType == Enum.CameraType.Follow then
					cameraMovementMode = Enum.ComputerCameraMovementMode.Follow
	 
				elseif legacyCameraType == Enum.CameraType.Orbital then
					cameraMovementMode = Enum.ComputerCameraMovementMode.Orbital
	 
				elseif legacyCameraType == Enum.CameraType.Attach or
					   legacyCameraType == Enum.CameraType.Watch or
					   legacyCameraType == Enum.CameraType.Fixed then
					newCameraCreator = LegacyCamera
				else
					warn("CameraScript encountered an unhandled Camera.CameraType value: ",legacyCameraType)
				end
			end
	 
			if not newCameraCreator then
				if cameraMovementMode == Enum.ComputerCameraMovementMode.Classic or
					cameraMovementMode == Enum.ComputerCameraMovementMode.Follow or
					cameraMovementMode == Enum.ComputerCameraMovementMode.Default or
					(FFlagUserCameraToggle and cameraMovementMode == Enum.ComputerCameraMovementMode.CameraToggle) then
					newCameraCreator = ClassicCamera
				elseif cameraMovementMode == Enum.ComputerCameraMovementMode.Orbital then
					newCameraCreator = OrbitalCamera
				else
					warn("ActivateCameraController did not select a module.")
					return
				end
			end
	 
			-- Create the camera control module we need if it does not already exist in instantiatedCameraControllers
			local newCameraController
			if not instantiatedCameraControllers[newCameraCreator] then
				newCameraController = newCameraCreator.new()
				instantiatedCameraControllers[newCameraCreator] = newCameraController
			else
				newCameraController = instantiatedCameraControllers[newCameraCreator]
			end
	 
			-- If there is a controller active and it's not the one we need, disable it,
			-- if it is the one we need, make sure it's enabled
			if self.activeCameraController then
				if self.activeCameraController ~= newCameraController then
					self.activeCameraController:Enable(false)
					self.activeCameraController = newCameraController
					self.activeCameraController:Enable(true)
				elseif not self.activeCameraController:GetEnabled() then
					self.activeCameraController:Enable(true)
				end
			elseif newCameraController ~= nil then
				self.activeCameraController = newCameraController
				self.activeCameraController:Enable(true)
			end
	 
			if self.activeCameraController then
				if cameraMovementMode~=nil then
					self.activeCameraController:SetCameraMovementMode(cameraMovementMode)
				elseif legacyCameraType~=nil then
					-- Note that this is only called when legacyCameraType is not a type that
					-- was convertible to a ComputerCameraMovementMode value, i.e. really only applies to LegacyCamera
					self.activeCameraController:SetCameraType(legacyCameraType)
				end
			end
		end
	 
		-- Note: The active transparency controller could be made to listen for this event itself.
		function CameraModule:OnCameraSubjectChanged()
			if self.activeTransparencyController then
				self.activeTransparencyController:SetSubject(game.Workspace.CurrentCamera.CameraSubject)
			end
	 
			if self.activeOcclusionModule then
				self.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
			end
		end
	 
		function CameraModule:OnCameraTypeChanged(newCameraType)
			if newCameraType == Enum.CameraType.Scriptable then
				if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				end
			end
	 
			-- Forward the change to ActivateCameraController to handle
			self:ActivateCameraController(nil, newCameraType)
		end
	 
		-- Note: Called whenever workspace.CurrentCamera changes, but also on initialization of this script
		function CameraModule:OnCurrentCameraChanged()
			local currentCamera = game.Workspace.CurrentCamera
			if not currentCamera then return end
	 
			if self.cameraSubjectChangedConn then
				self.cameraSubjectChangedConn:Disconnect()
			end
	 
			if self.cameraTypeChangedConn then
				self.cameraTypeChangedConn:Disconnect()
			end
	 
			self.cameraSubjectChangedConn = currentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
				self:OnCameraSubjectChanged(currentCamera.CameraSubject)
			end)
	 
			self.cameraTypeChangedConn = currentCamera:GetPropertyChangedSignal("CameraType"):Connect(function()
				self:OnCameraTypeChanged(currentCamera.CameraType)
			end)
	 
			self:OnCameraSubjectChanged(currentCamera.CameraSubject)
			self:OnCameraTypeChanged(currentCamera.CameraType)
		end
	 
		function CameraModule:OnLocalPlayerCameraPropertyChanged(propertyName)
			if propertyName == "CameraMode" then
				-- CameraMode is only used to turn on/off forcing the player into first person view. The
				-- Note: The case "Classic" is used for all other views and does not correspond only to the ClassicCamera module
				if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
					-- Locked in first person, use ClassicCamera which supports this
					if not self.activeCameraController or self.activeCameraController:GetModuleName() ~= "ClassicCamera" then
						self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic))
					end
	 
					if self.activeCameraController then
						self.activeCameraController:UpdateForDistancePropertyChange()
					end
				elseif Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
					-- Not locked in first person view
					local cameraMovementMode =self: GetCameraMovementModeFromSettings()
					self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(cameraMovementMode))
				else
					warn("Unhandled value for property player.CameraMode: ",Players.LocalPlayer.CameraMode)
				end
	 
			elseif propertyName == "DevComputerCameraMode" or 
				   propertyName == "DevTouchCameraMode" then
				local cameraMovementMode = self:GetCameraMovementModeFromSettings()
				self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(cameraMovementMode))
	 
			elseif propertyName == "DevCameraOcclusionMode" then
				self:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
	 
			elseif propertyName == "CameraMinZoomDistance" or propertyName == "CameraMaxZoomDistance" then
				if self.activeCameraController then
					self.activeCameraController:UpdateForDistancePropertyChange()
				end
			elseif propertyName == "DevTouchMovementMode" then
			elseif propertyName == "DevComputerMovementMode" then
			elseif propertyName == "DevEnableMouseLock" then
				-- This is the enabling/disabling of "Shift Lock" mode, not LockFirstPerson (which is a CameraMode)
				-- Note: Enabling and disabling of MouseLock mode is normally only a publish-time choice made via
				-- the corresponding EnableMouseLockOption checkbox of StarterPlayer, and this script does not have
				-- support for changing the availability of MouseLock at runtime (this would require listening to
				-- Player.DevEnableMouseLock changes)
			end
		end
	 
		function CameraModule:OnUserGameSettingsPropertyChanged(propertyName)
			if propertyName == 	"ComputerCameraMovementMode" then
				local cameraMovementMode = self:GetCameraMovementModeFromSettings()
				self:ActivateCameraController(CameraUtils.ConvertCameraModeEnumToStandard(cameraMovementMode))
			end
		end
	 
		--[[
			Main RenderStep Update. The camera controller and occlusion module both have opportunities
			to set and modify (respectively) the CFrame and Focus before it is set once on CurrentCamera.
			The camera and occlusion modules should only return CFrames, not set the CFrame property of
			CurrentCamera directly.
		--]]
		function CameraModule:Update(dt)
			if self.activeCameraController then
				if FFlagUserCameraToggle then
					self.activeCameraController:UpdateMouseBehavior()
				end
	 
				local newCameraCFrame, newCameraFocus = self.activeCameraController:Update(dt)
				self.activeCameraController:ApplyVRTransform()
				if self.activeOcclusionModule then
					newCameraCFrame, newCameraFocus = self.activeOcclusionModule:Update(dt, newCameraCFrame, newCameraFocus)
				end
	 
				-- Here is where the new CFrame and Focus are set for this render frame
				game.Workspace.CurrentCamera.CFrame = newCameraCFrame
				game.Workspace.CurrentCamera.Focus = newCameraFocus
	 
				-- Update to character local transparency as needed based on camera-to-subject distance
				if self.activeTransparencyController then
					self.activeTransparencyController:Update()
				end
			end
		end
	 
		-- Formerly getCurrentCameraMode, this function resolves developer and user camera control settings to
		-- decide which camera control module should be instantiated. The old method of converting redundant enum types
		function CameraModule:GetCameraControlChoice()
			local player = Players.LocalPlayer
	 
			if player then
				if self.lastInputType == Enum.UserInputType.Touch or UserInputService.TouchEnabled then
					-- Touch
					if player.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
						return CameraUtils.ConvertCameraModeEnumToStandard( UserGameSettings.TouchCameraMovementMode )
					else
						return CameraUtils.ConvertCameraModeEnumToStandard( player.DevTouchCameraMode )
					end
				else
					-- Computer
					if player.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice then
						local computerMovementMode = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode)
						return CameraUtils.ConvertCameraModeEnumToStandard(computerMovementMode)
					else
						return CameraUtils.ConvertCameraModeEnumToStandard(player.DevComputerCameraMode)
					end
				end
			end
		end
	 
		function CameraModule:OnCharacterAdded(char, player)
			if self.activeOcclusionModule then
				self.activeOcclusionModule:CharacterAdded(char, player)
			end
		end
	 
		function CameraModule:OnCharacterRemoving(char, player)
			if self.activeOcclusionModule then
				self.activeOcclusionModule:CharacterRemoving(char, player)
			end
		end
	 
		function CameraModule:OnPlayerAdded(player)
			player.CharacterAdded:Connect(function(char)
				self:OnCharacterAdded(char, player)
			end)
			player.CharacterRemoving:Connect(function(char)
				self:OnCharacterRemoving(char, player)
			end)
		end
	 
		function CameraModule:OnMouseLockToggled()
			if self.activeMouseLockController then
				local mouseLocked = self.activeMouseLockController:GetIsMouseLocked()
				local mouseLockOffset = self.activeMouseLockController:GetMouseLockOffset()
				if self.activeCameraController then
					self.activeCameraController:SetIsMouseLocked(mouseLocked)
					self.activeCameraController:SetMouseLockOffset(mouseLockOffset)
				end
			end
		end
		--begin edit
		local Camera = CameraModule
		local IDENTITYCF = CFrame.new()
		local lastUpCFrame = IDENTITYCF
	 
		Camera.UpVector = Vector3.new(0, 1, 0)
		Camera.TransitionRate = 0.15
		Camera.UpCFrame = IDENTITYCF
	 
		function Camera:GetUpVector(oldUpVector)
			return oldUpVector
		end
		local function getRotationBetween(u, v, axis)
			local dot, uxv = u:Dot(v), u:Cross(v)
			if (dot < -0.99999) then return CFrame.fromAxisAngle(axis, math.pi) end
			return CFrame.new(0, 0, 0, uxv.x, uxv.y, uxv.z, 1 + dot)
		end
		function Camera:CalculateUpCFrame()
			local oldUpVector = self.UpVector
			local newUpVector = self:GetUpVector(oldUpVector)
	 
			local backup = game.Workspace.CurrentCamera.CFrame.RightVector
			local transitionCF = getRotationBetween(oldUpVector, newUpVector, backup)
			local vecSlerpCF = IDENTITYCF:Lerp(transitionCF, self.TransitionRate)
	 
			self.UpVector = vecSlerpCF * oldUpVector
			self.UpCFrame = vecSlerpCF * self.UpCFrame
	 
			lastUpCFrame = self.UpCFrame
		end
	 
		function Camera:Update(dt)
			if self.activeCameraController then
				if Camera.FFlagUserCameraToggle then
					self.activeCameraController:UpdateMouseBehavior()
				end
	 
				local newCameraCFrame, newCameraFocus = self.activeCameraController:Update(dt)
				self.activeCameraController:ApplyVRTransform()
	 
				self:CalculateUpCFrame()
				self.activeCameraController:UpdateUpCFrame(self.UpCFrame)
	 
				-- undo shift-lock offset
	 
				local lockOffset = Vector3.new(0, 0, 0)
				if (self.activeMouseLockController and self.activeMouseLockController:GetIsMouseLocked()) then
					lockOffset = self.activeMouseLockController:GetMouseLockOffset()
				end
	 
				local offset = newCameraFocus:ToObjectSpace(newCameraCFrame)
				local camRotation = self.UpCFrame * offset
				newCameraFocus = newCameraFocus - newCameraCFrame:VectorToWorldSpace(lockOffset) + camRotation:VectorToWorldSpace(lockOffset)
				newCameraCFrame = newCameraFocus * camRotation
	 
				--local offset = newCameraFocus:Inverse() * newCameraCFrame
				--newCameraCFrame = newCameraFocus * self.UpCFrame * offset
	 
				if (self.activeCameraController.lastCameraTransform) then
					self.activeCameraController.lastCameraTransform = newCameraCFrame
					self.activeCameraController.lastCameraFocus = newCameraFocus
				end
	 
				if self.activeOcclusionModule then
					newCameraCFrame, newCameraFocus = self.activeOcclusionModule:Update(dt, newCameraCFrame, newCameraFocus)
				end
	 
				game.Workspace.CurrentCamera.CFrame = newCameraCFrame
				game.Workspace.CurrentCamera.Focus = newCameraFocus
	 
				if self.activeTransparencyController then
					self.activeTransparencyController:Update()
				end
			end
		end
	 
		function Camera:IsFirstPerson()
			if self.activeCameraController then
				return self.activeCameraController:InFirstPerson()
			end
			return false
		end
	 
		function Camera:IsMouseLocked()
			if self.activeCameraController then
				return self.activeCameraController:GetIsMouseLocked()
			end
			return false
		end
		function Camera:IsToggleMode()
			if self.activeCameraController then
				return self.activeCameraController.isCameraToggle
			end
			return false
		end
		function Camera:IsCamRelative()
			return self:IsMouseLocked() or self:IsFirstPerson()
			--return self:IsToggleMode(), self:IsMouseLocked(), self:IsFirstPerson()
		end
		--
		local Utils = _CameraUtils()
		function Utils.GetAngleBetweenXZVectors(v1, v2)
			local upCFrame = lastUpCFrame
			v1 = upCFrame:VectorToObjectSpace(v1)
			v2 = upCFrame:VectorToObjectSpace(v2)
			return math.atan2(v2.X*v1.Z-v2.Z*v1.X, v2.X*v1.X+v2.Z*v1.Z)
		end
		--end edit
		local cameraModuleObject = CameraModule.new()
		local cameraApi = {}
		return cameraModuleObject
	end
	 
	function _ClickToMoveDisplay()
		local ClickToMoveDisplay = {}
	 
		local FAILURE_ANIMATION_ID = "rbxassetid://2874840706"
	 
		local TrailDotIcon = "rbxasset://textures/ui/traildot.png"
		local EndWaypointIcon = "rbxasset://textures/ui/waypoint.png"
	 
		local WaypointsAlwaysOnTop = false
	 
		local WAYPOINT_INCLUDE_FACTOR = 2
		local LAST_DOT_DISTANCE = 3
	 
		local WAYPOINT_BILLBOARD_SIZE = UDim2.new(0, 1.68 * 25, 0, 2 * 25)
	 
		local ENDWAYPOINT_SIZE_OFFSET_MIN = Vector2.new(0, 0.5)
		local ENDWAYPOINT_SIZE_OFFSET_MAX = Vector2.new(0, 1)
	 
		local FAIL_WAYPOINT_SIZE_OFFSET_CENTER = Vector2.new(0, 0.5)
		local FAIL_WAYPOINT_SIZE_OFFSET_LEFT = Vector2.new(0.1, 0.5)
		local FAIL_WAYPOINT_SIZE_OFFSET_RIGHT = Vector2.new(-0.1, 0.5)
	 
		local FAILURE_TWEEN_LENGTH = 0.125
		local FAILURE_TWEEN_COUNT = 4
	 
		local TWEEN_WAYPOINT_THRESHOLD = 5
	 
		local TRAIL_DOT_PARENT_NAME = "ClickToMoveDisplay"
	 
		local TrailDotSize = Vector2.new(1.5, 1.5)
	 
		local TRAIL_DOT_MIN_SCALE = 1
		local TRAIL_DOT_MIN_DISTANCE = 10
		local TRAIL_DOT_MAX_SCALE = 2.5
		local TRAIL_DOT_MAX_DISTANCE = 100
	 
		local PlayersService = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
		local RunService = game:GetService("RunService")
		local Workspace = game:GetService("Workspace")
	 
		local LocalPlayer = PlayersService.LocalPlayer
	 
		local function CreateWaypointTemplates()
			local TrailDotTemplate = Instance.new("Part")
			TrailDotTemplate.Size = Vector3.new(1, 1, 1)
			TrailDotTemplate.Anchored = true
			TrailDotTemplate.CanCollide = false
			TrailDotTemplate.Name = "TrailDot"
			TrailDotTemplate.Transparency = 1
			local TrailDotImage = Instance.new("ImageHandleAdornment")
			TrailDotImage.Name = "TrailDotImage"
			TrailDotImage.Size = TrailDotSize
			TrailDotImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
			TrailDotImage.AlwaysOnTop = WaypointsAlwaysOnTop
			TrailDotImage.Image = TrailDotIcon
			TrailDotImage.Adornee = TrailDotTemplate
			TrailDotImage.Parent = TrailDotTemplate
	 
			local EndWaypointTemplate = Instance.new("Part")
			EndWaypointTemplate.Size = Vector3.new(2, 2, 2)
			EndWaypointTemplate.Anchored = true
			EndWaypointTemplate.CanCollide = false
			EndWaypointTemplate.Name = "EndWaypoint"
			EndWaypointTemplate.Transparency = 1
			local EndWaypointImage = Instance.new("ImageHandleAdornment")
			EndWaypointImage.Name = "TrailDotImage"
			EndWaypointImage.Size = TrailDotSize
			EndWaypointImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
			EndWaypointImage.AlwaysOnTop = WaypointsAlwaysOnTop
			EndWaypointImage.Image = TrailDotIcon
			EndWaypointImage.Adornee = EndWaypointTemplate
			EndWaypointImage.Parent = EndWaypointTemplate
			local EndWaypointBillboard = Instance.new("BillboardGui")
			EndWaypointBillboard.Name = "EndWaypointBillboard"
			EndWaypointBillboard.Size = WAYPOINT_BILLBOARD_SIZE
			EndWaypointBillboard.LightInfluence = 0
			EndWaypointBillboard.SizeOffset = ENDWAYPOINT_SIZE_OFFSET_MIN
			EndWaypointBillboard.AlwaysOnTop = true
			EndWaypointBillboard.Adornee = EndWaypointTemplate
			EndWaypointBillboard.Parent = EndWaypointTemplate
			local EndWaypointImageLabel = Instance.new("ImageLabel")
			EndWaypointImageLabel.Image = EndWaypointIcon
			EndWaypointImageLabel.BackgroundTransparency = 1
			EndWaypointImageLabel.Size = UDim2.new(1, 0, 1, 0)
			EndWaypointImageLabel.Parent = EndWaypointBillboard
	 
	 
			local FailureWaypointTemplate = Instance.new("Part")
			FailureWaypointTemplate.Size = Vector3.new(2, 2, 2)
			FailureWaypointTemplate.Anchored = true
			FailureWaypointTemplate.CanCollide = false
			FailureWaypointTemplate.Name = "FailureWaypoint"
			FailureWaypointTemplate.Transparency = 1
			local FailureWaypointImage = Instance.new("ImageHandleAdornment")
			FailureWaypointImage.Name = "TrailDotImage"
			FailureWaypointImage.Size = TrailDotSize
			FailureWaypointImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
			FailureWaypointImage.AlwaysOnTop = WaypointsAlwaysOnTop
			FailureWaypointImage.Image = TrailDotIcon
			FailureWaypointImage.Adornee = FailureWaypointTemplate
			FailureWaypointImage.Parent = FailureWaypointTemplate
			local FailureWaypointBillboard = Instance.new("BillboardGui")
			FailureWaypointBillboard.Name = "FailureWaypointBillboard"
			FailureWaypointBillboard.Size = WAYPOINT_BILLBOARD_SIZE
			FailureWaypointBillboard.LightInfluence = 0
			FailureWaypointBillboard.SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_CENTER
			FailureWaypointBillboard.AlwaysOnTop = true
			FailureWaypointBillboard.Adornee = FailureWaypointTemplate
			FailureWaypointBillboard.Parent = FailureWaypointTemplate
			local FailureWaypointFrame = Instance.new("Frame")
			FailureWaypointFrame.BackgroundTransparency = 1
			FailureWaypointFrame.Size = UDim2.new(0, 0, 0, 0)
			FailureWaypointFrame.Position = UDim2.new(0.5, 0, 1, 0)
			FailureWaypointFrame.Parent = FailureWaypointBillboard
			local FailureWaypointImageLabel = Instance.new("ImageLabel")
			FailureWaypointImageLabel.Image = EndWaypointIcon
			FailureWaypointImageLabel.BackgroundTransparency = 1
			FailureWaypointImageLabel.Position = UDim2.new(
				0, -WAYPOINT_BILLBOARD_SIZE.X.Offset/2, 0, -WAYPOINT_BILLBOARD_SIZE.Y.Offset
			)
			FailureWaypointImageLabel.Size = WAYPOINT_BILLBOARD_SIZE
			FailureWaypointImageLabel.Parent = FailureWaypointFrame
	 
			return TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate
		end
	 
		local TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
	 
		local function getTrailDotParent()
			local camera = Workspace.CurrentCamera
			local trailParent = camera:FindFirstChild(TRAIL_DOT_PARENT_NAME)
			if not trailParent then
				trailParent = Instance.new("Model")
				trailParent.Name = TRAIL_DOT_PARENT_NAME
				trailParent.Parent = camera
			end
			return trailParent
		end
	 
		local function placePathWaypoint(waypointModel, position)
			local ray = Ray.new(position + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
			local hitPart, hitPoint, hitNormal = Workspace:FindPartOnRayWithIgnoreList(
				ray,
				{ Workspace.CurrentCamera, LocalPlayer.Character }
			)
			if hitPart then
				waypointModel.CFrame = CFrame.new(hitPoint, hitPoint + hitNormal)
				waypointModel.Parent = getTrailDotParent()
			end
		end
	 
		local TrailDot = {}
		TrailDot.__index = TrailDot
	 
		function TrailDot:Destroy()
			self.DisplayModel:Destroy()
		end
	 
		function TrailDot:NewDisplayModel(position)
			local newDisplayModel = TrailDotTemplate:Clone()
			placePathWaypoint(newDisplayModel, position)
			return newDisplayModel
		end
	 
		function TrailDot.new(position, closestWaypoint)
			local self = setmetatable({}, TrailDot)
	 
			self.DisplayModel = self:NewDisplayModel(position)
			self.ClosestWayPoint = closestWaypoint
	 
			return self
		end
	 
		local EndWaypoint = {}
		EndWaypoint.__index = EndWaypoint
	 
		function EndWaypoint:Destroy()
			self.Destroyed = true
			self.Tween:Cancel()
			self.DisplayModel:Destroy()
		end
	 
		function EndWaypoint:NewDisplayModel(position)
			local newDisplayModel = EndWaypointTemplate:Clone()
			placePathWaypoint(newDisplayModel, position)
			return newDisplayModel
		end
	 
		function EndWaypoint:CreateTween()
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
			local tween = TweenService:Create(
				self.DisplayModel.EndWaypointBillboard,
				tweenInfo,
				{ SizeOffset = ENDWAYPOINT_SIZE_OFFSET_MAX }
			)
			tween:Play()
			return tween
		end
	 
		function EndWaypoint:TweenInFrom(originalPosition)
			local currentPositon = self.DisplayModel.Position
			local studsOffset = originalPosition - currentPositon
			self.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, studsOffset.Y, 0)
			local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local tween = TweenService:Create(
				self.DisplayModel.EndWaypointBillboard,
				tweenInfo,
				{ StudsOffset = Vector3.new(0, 0, 0) }
			)
			tween:Play()
			return tween
		end
	 
		function EndWaypoint.new(position, closestWaypoint, originalPosition)
			local self = setmetatable({}, EndWaypoint)
	 
			self.DisplayModel = self:NewDisplayModel(position)
			self.Destroyed = false
			if originalPosition and (originalPosition - position).magnitude > TWEEN_WAYPOINT_THRESHOLD then
				self.Tween = self:TweenInFrom(originalPosition)
				coroutine.wrap(function()
					self.Tween.Completed:Wait()
					if not self.Destroyed then
						self.Tween = self:CreateTween()
					end
				end)()
			else
				self.Tween = self:CreateTween()
			end
			self.ClosestWayPoint = closestWaypoint
	 
			return self
		end
	 
		local FailureWaypoint = {}
		FailureWaypoint.__index = FailureWaypoint
	 
		function FailureWaypoint:Hide()
			self.DisplayModel.Parent = nil
		end
	 
		function FailureWaypoint:Destroy()
			self.DisplayModel:Destroy()
		end
	 
		function FailureWaypoint:NewDisplayModel(position)
			local newDisplayModel = FailureWaypointTemplate:Clone()
			placePathWaypoint(newDisplayModel, position)
			local ray = Ray.new(position + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
			local hitPart, hitPoint, hitNormal = Workspace:FindPartOnRayWithIgnoreList(
				ray, { Workspace.CurrentCamera, LocalPlayer.Character }
			)
			if hitPart then
				newDisplayModel.CFrame = CFrame.new(hitPoint, hitPoint + hitNormal)
				newDisplayModel.Parent = getTrailDotParent()
			end
			return newDisplayModel
		end
	 
		function FailureWaypoint:RunFailureTween()
			wait(FAILURE_TWEEN_LENGTH) -- Delay one tween length betfore starting tweening
			-- Tween out from center
			local tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH/2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local tweenLeft = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo,
				{ SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_LEFT })
			tweenLeft:Play()
	 
			local tweenLeftRoation = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo,
				{ Rotation = 10 })
			tweenLeftRoation:Play()
	 
			tweenLeft.Completed:wait()
	 
			-- Tween back and forth
			tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH, Enum.EasingStyle.Sine, Enum.EasingDirection.Out,
				FAILURE_TWEEN_COUNT - 1, true)
			local tweenSideToSide = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo,
				{ SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_RIGHT})
			tweenSideToSide:Play()
	 
			-- Tween flash dark and roate left and right
			tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH, Enum.EasingStyle.Sine, Enum.EasingDirection.Out,
				FAILURE_TWEEN_COUNT - 1, true)
			local tweenFlash = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, tweenInfo,
				{ ImageColor3 = Color3.new(0.75, 0.75, 0.75)})
			tweenFlash:Play()
	 
			local tweenRotate = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo,
				{ Rotation = -10 })
			tweenRotate:Play()
	 
			tweenSideToSide.Completed:wait()
	 
			-- Tween back to center
			tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH/2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local tweenCenter = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo,
				{ SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_CENTER })
			tweenCenter:Play()
	 
			local tweenRoation = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo,
				{ Rotation = 0 })
			tweenRoation:Play()
	 
			tweenCenter.Completed:wait()
	 
			wait(FAILURE_TWEEN_LENGTH) -- Delay one tween length betfore removing
		end
	 
		function FailureWaypoint.new(position)
			local self = setmetatable({}, FailureWaypoint)
	 
			self.DisplayModel = self:NewDisplayModel(position)
	 
			return self
		end
	 
		local failureAnimation = Instance.new("Animation")
		failureAnimation.AnimationId = FAILURE_ANIMATION_ID
	 
		local lastHumanoid = nil
		local lastFailureAnimationTrack = nil
	 
		local function getFailureAnimationTrack(myHumanoid)
			if myHumanoid == lastHumanoid then
				return lastFailureAnimationTrack
			end
			lastFailureAnimationTrack = myHumanoid:LoadAnimation(failureAnimation)
			lastFailureAnimationTrack.Priority = Enum.AnimationPriority.Action
			lastFailureAnimationTrack.Looped = false
			return lastFailureAnimationTrack
		end
	 
		local function findPlayerHumanoid()
			local character = LocalPlayer.Character
			if character then
				return character:FindFirstChildOfClass("Humanoid")
			end
		end
	 
		local function createTrailDots(wayPoints, originalEndWaypoint)
			local newTrailDots = {}
			local count = 1
			for i = 1, #wayPoints - 1 do
				local closeToEnd = (wayPoints[i].Position - wayPoints[#wayPoints].Position).magnitude < LAST_DOT_DISTANCE
				local includeWaypoint = i % WAYPOINT_INCLUDE_FACTOR == 0 and not closeToEnd
				if includeWaypoint then
					local trailDot = TrailDot.new(wayPoints[i].Position, i)
					newTrailDots[count] = trailDot
					count = count + 1
				end
			end
	 
			local newEndWaypoint = EndWaypoint.new(wayPoints[#wayPoints].Position, #wayPoints, originalEndWaypoint)
			table.insert(newTrailDots, newEndWaypoint)
	 
			local reversedTrailDots = {}
			count = 1
			for i = #newTrailDots, 1, -1 do
				reversedTrailDots[count] = newTrailDots[i]
				count = count + 1
			end
			return reversedTrailDots
		end
	 
		local function getTrailDotScale(distanceToCamera, defaultSize)
			local rangeLength = TRAIL_DOT_MAX_DISTANCE - TRAIL_DOT_MIN_DISTANCE
			local inRangePoint = math.clamp(distanceToCamera - TRAIL_DOT_MIN_DISTANCE, 0, rangeLength)/rangeLength
			local scale = TRAIL_DOT_MIN_SCALE + (TRAIL_DOT_MAX_SCALE - TRAIL_DOT_MIN_SCALE)*inRangePoint
			return defaultSize * scale
		end
	 
		local createPathCount = 0
		-- originalEndWaypoint is optional, causes the waypoint to tween from that position.
		function ClickToMoveDisplay.CreatePathDisplay(wayPoints, originalEndWaypoint)
			createPathCount = createPathCount + 1
			local trailDots = createTrailDots(wayPoints, originalEndWaypoint)
	 
			local function removePathBeforePoint(wayPointNumber)
				-- kill all trailDots before and at wayPointNumber
				for i = #trailDots, 1, -1 do
					local trailDot = trailDots[i]
					if trailDot.ClosestWayPoint <= wayPointNumber then
						trailDot:Destroy()
						trailDots[i] = nil
					else
						break
					end
				end
			end
	 
			local reiszeTrailDotsUpdateName = "ClickToMoveResizeTrail" ..createPathCount
			local function resizeTrailDots()
				if #trailDots == 0 then
					RunService:UnbindFromRenderStep(reiszeTrailDotsUpdateName)
					return
				end
				local cameraPos = Workspace.CurrentCamera.CFrame.p
				for i = 1, #trailDots do
					local trailDotImage = trailDots[i].DisplayModel:FindFirstChild("TrailDotImage")
					if trailDotImage then
						local distanceToCamera = (trailDots[i].DisplayModel.Position - cameraPos).magnitude
						trailDotImage.Size = getTrailDotScale(distanceToCamera, TrailDotSize)
					end
				end
			end
			RunService:BindToRenderStep(reiszeTrailDotsUpdateName, Enum.RenderPriority.Camera.Value - 1, resizeTrailDots)
	 
			local function removePath()
				removePathBeforePoint(#wayPoints)
			end
	 
			return removePath, removePathBeforePoint
		end
	 
		local lastFailureWaypoint = nil
		function ClickToMoveDisplay.DisplayFailureWaypoint(position)
			if lastFailureWaypoint then
				lastFailureWaypoint:Hide()
			end
			local failureWaypoint = FailureWaypoint.new(position)
			lastFailureWaypoint = failureWaypoint
			coroutine.wrap(function()
				failureWaypoint:RunFailureTween()
				failureWaypoint:Destroy()
				failureWaypoint = nil
			end)()
		end
	 
		function ClickToMoveDisplay.CreateEndWaypoint(position)
			return EndWaypoint.new(position)
		end
	 
		function ClickToMoveDisplay.PlayFailureAnimation()
			local myHumanoid = findPlayerHumanoid()
			if myHumanoid then
				local animationTrack = getFailureAnimationTrack(myHumanoid)
				animationTrack:Play()
			end
		end
	 
		function ClickToMoveDisplay.CancelFailureAnimation()
			if lastFailureAnimationTrack ~= nil and lastFailureAnimationTrack.IsPlaying then
				lastFailureAnimationTrack:Stop()
			end
		end
	 
		function ClickToMoveDisplay.SetWaypointTexture(texture)
			TrailDotIcon = texture
			TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
		end
	 
		function ClickToMoveDisplay.GetWaypointTexture()
			return TrailDotIcon
		end
	 
		function ClickToMoveDisplay.SetWaypointRadius(radius)
			TrailDotSize = Vector2.new(radius, radius)
			TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
		end
	 
		function ClickToMoveDisplay.GetWaypointRadius()
			return TrailDotSize.X
		end
	 
		function ClickToMoveDisplay.SetEndWaypointTexture(texture)
			EndWaypointIcon = texture
			TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
		end
	 
		function ClickToMoveDisplay.GetEndWaypointTexture()
			return EndWaypointIcon
		end
	 
		function ClickToMoveDisplay.SetWaypointsAlwaysOnTop(alwaysOnTop)
			WaypointsAlwaysOnTop = alwaysOnTop
			TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
		end
	 
		function ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
			return WaypointsAlwaysOnTop
		end
	 
		return ClickToMoveDisplay
	end
	 
	function _BaseCharacterController()
	 
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
	 
		--[[ The Module ]]--
		local BaseCharacterController = {}
		BaseCharacterController.__index = BaseCharacterController
	 
		function BaseCharacterController.new()
			local self = setmetatable({}, BaseCharacterController)
			self.enabled = false
			self.moveVector = ZERO_VECTOR3
			self.moveVectorIsCameraRelative = true
			self.isJumping = false
			return self
		end
	 
		function BaseCharacterController:OnRenderStepped(dt)
			-- By default, nothing to do
		end
	 
		function BaseCharacterController:GetMoveVector()
			return self.moveVector
		end
	 
		function BaseCharacterController:IsMoveVectorCameraRelative()
			return self.moveVectorIsCameraRelative
		end
	 
		function BaseCharacterController:GetIsJumping()
			return self.isJumping
		end
	 
		-- Override in derived classes to set self.enabled and return boolean indicating
		-- whether Enable/Disable was successful. Return true if controller is already in the requested state.
		function BaseCharacterController:Enable(enable)
			error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
			return false
		end
	 
		return BaseCharacterController
	end
	 
	function _VehicleController()
		local ContextActionService = game:GetService("ContextActionService")
	 
		--[[ Constants ]]--
		-- Set this to true if you want to instead use the triggers for the throttle
		local useTriggersForThrottle = true
		-- Also set this to true if you want the thumbstick to not affect throttle, only triggers when a gamepad is conected
		local onlyTriggersForThrottle = false
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
	 
		local AUTO_PILOT_DEFAULT_MAX_STEERING_ANGLE = 35
	 
	 
		-- Note that VehicleController does not derive from BaseCharacterController, it is a special case
		local VehicleController = {}
		VehicleController.__index = VehicleController
	 
		function VehicleController.new(CONTROL_ACTION_PRIORITY)
			local self = setmetatable({}, VehicleController)
	 
			self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY
	 
			self.enabled = false
			self.vehicleSeat = nil
			self.throttle = 0
			self.steer = 0
	 
			self.acceleration = 0
			self.decceleration = 0
			self.turningRight = 0
			self.turningLeft = 0
	 
			self.vehicleMoveVector = ZERO_VECTOR3
	 
			self.autoPilot = {}
			self.autoPilot.MaxSpeed = 0
			self.autoPilot.MaxSteeringAngle = 0
	 
			return self
		end
	 
		function VehicleController:BindContextActions()
			if useTriggersForThrottle then
				ContextActionService:BindActionAtPriority("throttleAccel", (function(actionName, inputState, inputObject)
					self:OnThrottleAccel(actionName, inputState, inputObject)
					return Enum.ContextActionResult.Pass
				end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)
				ContextActionService:BindActionAtPriority("throttleDeccel", (function(actionName, inputState, inputObject)
					self:OnThrottleDeccel(actionName, inputState, inputObject)
					return Enum.ContextActionResult.Pass
				end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)
			end
			ContextActionService:BindActionAtPriority("arrowSteerRight", (function(actionName, inputState, inputObject)
				self:OnSteerRight(actionName, inputState, inputObject)
				return Enum.ContextActionResult.Pass
			end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)
			ContextActionService:BindActionAtPriority("arrowSteerLeft", (function(actionName, inputState, inputObject)
				self:OnSteerLeft(actionName, inputState, inputObject)
				return Enum.ContextActionResult.Pass
			end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
		end
	 
		function VehicleController:Enable(enable, vehicleSeat)
			if enable == self.enabled and vehicleSeat == self.vehicleSeat then
				return
			end
	 
			self.enabled = enable
			self.vehicleMoveVector = ZERO_VECTOR3
	 
			if enable then
				if vehicleSeat then
					self.vehicleSeat = vehicleSeat
	 
					self:SetupAutoPilot()
					self:BindContextActions()
				end
			else
				if useTriggersForThrottle then
					ContextActionService:UnbindAction("throttleAccel")
					ContextActionService:UnbindAction("throttleDeccel")
				end
				ContextActionService:UnbindAction("arrowSteerRight")
				ContextActionService:UnbindAction("arrowSteerLeft")
				self.vehicleSeat = nil
			end
		end
	 
		function VehicleController:OnThrottleAccel(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
				self.acceleration = 0
			else
				self.acceleration = -1
			end
			self.throttle = self.acceleration + self.decceleration
		end
	 
		function VehicleController:OnThrottleDeccel(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
				self.decceleration = 0
			else
				self.decceleration = 1
			end
			self.throttle = self.acceleration + self.decceleration
		end
	 
		function VehicleController:OnSteerRight(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
				self.turningRight = 0
			else
				self.turningRight = 1
			end
			self.steer = self.turningRight + self.turningLeft
		end
	 
		function VehicleController:OnSteerLeft(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
				self.turningLeft = 0
			else
				self.turningLeft = -1
			end
			self.steer = self.turningRight + self.turningLeft
		end
	 
		-- Call this from a function bound to Renderstep with Input Priority
		function VehicleController:Update(moveVector, cameraRelative, usingGamepad)
			if self.vehicleSeat then
				if cameraRelative then
					-- This is the default steering mode
					moveVector = moveVector + Vector3.new(self.steer, 0, self.throttle)
					if usingGamepad and onlyTriggersForThrottle and useTriggersForThrottle then
						self.vehicleSeat.ThrottleFloat = -self.throttle
					else
						self.vehicleSeat.ThrottleFloat = -moveVector.Z
					end
					self.vehicleSeat.SteerFloat = moveVector.X
	 
					return moveVector, true
				else
					-- This is the path following mode
					local localMoveVector = self.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(moveVector)
	 
					self.vehicleSeat.ThrottleFloat = self:ComputeThrottle(localMoveVector)
					self.vehicleSeat.SteerFloat = self:ComputeSteer(localMoveVector)
	 
					return ZERO_VECTOR3, true
				end
			end
			return moveVector, false
		end
	 
		function VehicleController:ComputeThrottle(localMoveVector)
			if localMoveVector ~= ZERO_VECTOR3 then
				local throttle = -localMoveVector.Z
				return throttle
			else
				return 0.0
			end
		end
	 
		function VehicleController:ComputeSteer(localMoveVector)
			if localMoveVector ~= ZERO_VECTOR3 then
				local steerAngle = -math.atan2(-localMoveVector.x, -localMoveVector.z) * (180 / math.pi)
				return steerAngle / self.autoPilot.MaxSteeringAngle
			else
				return 0.0
			end
		end
	 
		function VehicleController:SetupAutoPilot()
			-- Setup default
			self.autoPilot.MaxSpeed = self.vehicleSeat.MaxSpeed
			self.autoPilot.MaxSteeringAngle = AUTO_PILOT_DEFAULT_MAX_STEERING_ANGLE
	 
			-- VehicleSeat should have a MaxSteeringAngle as well.
			-- Or we could look for a child "AutoPilotConfigModule" to find these values
			-- Or allow developer to set them through the API as like the CLickToMove customization API
		end
	 
		return VehicleController
	end
	 
	function _TouchJump()
	 
		local Players = game:GetService("Players")
		local GuiService = game:GetService("GuiService")
	 
		--[[ Constants ]]--
		local TOUCH_CONTROL_SHEET = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	 
		--[[ The Module ]]--
		local BaseCharacterController = _BaseCharacterController()
		local TouchJump = setmetatable({}, BaseCharacterController)
		TouchJump.__index = TouchJump
	 
		function TouchJump.new()
			local self = setmetatable(BaseCharacterController.new(), TouchJump)
	 
			self.parentUIFrame = nil
			self.jumpButton = nil
			self.characterAddedConn = nil
			self.humanoidStateEnabledChangedConn = nil
			self.humanoidJumpPowerConn = nil
			self.humanoidParentConn = nil
			self.externallyEnabled = false
			self.jumpPower = 0
			self.jumpStateEnabled = true
			self.isJumping = false
			self.humanoid = nil -- saved reference because property change connections are made using it
	 
			return self
		end
	 
		function TouchJump:EnableButton(enable)
			if enable then
				if not self.jumpButton then
					self:Create()
				end
				local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if humanoid and self.externallyEnabled then
					if self.externallyEnabled then
						if humanoid.JumpPower > 0 then
							self.jumpButton.Visible = true
						end
					end
				end
			else
				self.jumpButton.Visible = false
				self.isJumping = false
				self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
			end
		end
	 
		function TouchJump:UpdateEnabled()
			if self.jumpPower > 0 and self.jumpStateEnabled then
				self:EnableButton(true)
			else
				self:EnableButton(false)
			end
		end
	 
		function TouchJump:HumanoidChanged(prop)
			local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				if prop == "JumpPower" then
					self.jumpPower =  humanoid.JumpPower
					self:UpdateEnabled()
				elseif prop == "Parent" then
					if not humanoid.Parent then
						self.humanoidChangeConn:Disconnect()
					end
				end
			end
		end
	 
		function TouchJump:HumanoidStateEnabledChanged(state, isEnabled)
			if state == Enum.HumanoidStateType.Jumping then
				self.jumpStateEnabled = isEnabled
				self:UpdateEnabled()
			end
		end
	 
		function TouchJump:CharacterAdded(char)
			if self.humanoidChangeConn then
				self.humanoidChangeConn:Disconnect()
				self.humanoidChangeConn = nil
			end
	 
			self.humanoid = char:FindFirstChildOfClass("Humanoid")
			while not self.humanoid do
				char.ChildAdded:wait()
				self.humanoid = char:FindFirstChildOfClass("Humanoid")
			end
	 
			self.humanoidJumpPowerConn = self.humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
				self.jumpPower =  self.humanoid.JumpPower
				self:UpdateEnabled()
			end)
	 
			self.humanoidParentConn = self.humanoid:GetPropertyChangedSignal("Parent"):Connect(function()
				if not self.humanoid.Parent then
					self.humanoidJumpPowerConn:Disconnect()
					self.humanoidJumpPowerConn = nil
					self.humanoidParentConn:Disconnect()
					self.humanoidParentConn = nil
				end
			end)
	 
			self.humanoidStateEnabledChangedConn = self.humanoid.StateEnabledChanged:Connect(function(state, enabled)
				self:HumanoidStateEnabledChanged(state, enabled)
			end)
	 
			self.jumpPower = self.humanoid.JumpPower
			self.jumpStateEnabled = self.humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)
			self:UpdateEnabled()
		end
	 
		function TouchJump:SetupCharacterAddedFunction()
			self.characterAddedConn = Players.LocalPlayer.CharacterAdded:Connect(function(char)
				self:CharacterAdded(char)
			end)
			if Players.LocalPlayer.Character then
				self:CharacterAdded(Players.LocalPlayer.Character)
			end
		end
	 
		function TouchJump:Enable(enable, parentFrame)
			if parentFrame then
				self.parentUIFrame = parentFrame
			end
			self.externallyEnabled = enable
			self:EnableButton(enable)
		end
	 
		function TouchJump:Create()
			if not self.parentUIFrame then
				return
			end
	 
			if self.jumpButton then
				self.jumpButton:Destroy()
				self.jumpButton = nil
			end
	 
			local minAxis = math.min(self.parentUIFrame.AbsoluteSize.x, self.parentUIFrame.AbsoluteSize.y)
			local isSmallScreen = minAxis <= 500
			local jumpButtonSize = isSmallScreen and 70 or 120
	 
			self.jumpButton = Instance.new("ImageButton")
			self.jumpButton.Name = "JumpButton"
			self.jumpButton.Visible = false
			self.jumpButton.BackgroundTransparency = 1
			self.jumpButton.Image = TOUCH_CONTROL_SHEET
			self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
			self.jumpButton.ImageRectSize = Vector2.new(144, 144)
			self.jumpButton.Size = UDim2.new(0, jumpButtonSize, 0, jumpButtonSize)
	 
			self.jumpButton.Position = isSmallScreen and UDim2.new(1, -(jumpButtonSize*1.5-10), 1, -jumpButtonSize - 20) or
				UDim2.new(1, -(jumpButtonSize*1.5-10), 1, -jumpButtonSize * 1.75)
	 
			local touchObject = nil
			self.jumpButton.InputBegan:connect(function(inputObject)
				--A touch that starts elsewhere on the screen will be sent to a frame's InputBegan event
				--if it moves over the frame. So we check that this is actually a new touch (inputObject.UserInputState ~= Enum.UserInputState.Begin)
				if touchObject or inputObject.UserInputType ~= Enum.UserInputType.Touch
					or inputObject.UserInputState ~= Enum.UserInputState.Begin then
					return
				end
	 
				touchObject = inputObject
				self.jumpButton.ImageRectOffset = Vector2.new(146, 146)
				self.isJumping = true
			end)
	 
			local OnInputEnded = function()
				touchObject = nil
				self.isJumping = false
				self.jumpButton.ImageRectOffset = Vector2.new(1, 146)
			end
	 
			self.jumpButton.InputEnded:connect(function(inputObject)
				if inputObject == touchObject then
					OnInputEnded()
				end
			end)
	 
			GuiService.MenuOpened:connect(function()
				if touchObject then
					OnInputEnded()
				end
			end)
	 
			if not self.characterAddedConn then
				self:SetupCharacterAddedFunction()
			end
	 
			self.jumpButton.Parent = self.parentUIFrame
		end
	 
		return TouchJump
	end
	 
	function _ClickToMoveController()
		--[[ Roblox Services ]]--
		local UserInputService = game:GetService("UserInputService")
		local PathfindingService = game:GetService("PathfindingService")
		local Players = game:GetService("Players")
		local DebrisService = game:GetService('Debris')
		local StarterGui = game:GetService("StarterGui")
		local Workspace = game:GetService("Workspace")
		local CollectionService = game:GetService("CollectionService")
		local GuiService = game:GetService("GuiService")
	 
		--[[ Configuration ]]
		local ShowPath = true
		local PlayFailureAnimation = true
		local UseDirectPath = false
		local UseDirectPathForVehicle = true
		local AgentSizeIncreaseFactor = 1.0
		local UnreachableWaypointTimeout = 8
	 
		--[[ Constants ]]--
		local movementKeys = {
			[Enum.KeyCode.W] = true;
			[Enum.KeyCode.A] = true;
			[Enum.KeyCode.S] = true;
			[Enum.KeyCode.D] = true;
			[Enum.KeyCode.Up] = true;
			[Enum.KeyCode.Down] = true;
		}
	 
		local FFlagUserNavigationClickToMoveSkipPassedWaypointsSuccess, FFlagUserNavigationClickToMoveSkipPassedWaypointsResult = pcall(function() return UserSettings():IsUserFeatureEnabled("UserNavigationClickToMoveSkipPassedWaypoints") end)
		local FFlagUserNavigationClickToMoveSkipPassedWaypoints = FFlagUserNavigationClickToMoveSkipPassedWaypointsSuccess and FFlagUserNavigationClickToMoveSkipPassedWaypointsResult
	 
		local Player = Players.LocalPlayer
	 
		local ClickToMoveDisplay = _ClickToMoveDisplay()
	 
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
		local ALMOST_ZERO = 0.000001
	 
	 
		--------------------------UTIL LIBRARY-------------------------------
		local Utility = {}
		do
			local function FindCharacterAncestor(part)
				if part then
					local humanoid = part:FindFirstChildOfClass("Humanoid")
					if humanoid then
						return part, humanoid
					else
						return FindCharacterAncestor(part.Parent)
					end
				end
			end
			Utility.FindCharacterAncestor = FindCharacterAncestor
	 
			local function Raycast(ray, ignoreNonCollidable, ignoreList)
				ignoreList = ignoreList or {}
				local hitPart, hitPos, hitNorm, hitMat = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
				if hitPart then
					if ignoreNonCollidable and hitPart.CanCollide == false then
						-- We always include character parts so a user can click on another character
						-- to walk to them.
						local _, humanoid = FindCharacterAncestor(hitPart)
						if humanoid == nil then
							table.insert(ignoreList, hitPart)
							return Raycast(ray, ignoreNonCollidable, ignoreList)
						end
					end
					return hitPart, hitPos, hitNorm, hitMat
				end
				return nil, nil
			end
			Utility.Raycast = Raycast
		end
	 
		local humanoidCache = {}
		local function findPlayerHumanoid(player)
			local character = player and player.Character
			if character then
				local resultHumanoid = humanoidCache[player]
				if resultHumanoid and resultHumanoid.Parent == character then
					return resultHumanoid
				else
					humanoidCache[player] = nil -- Bust Old Cache
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoidCache[player] = humanoid
					end
					return humanoid
				end
			end
		end
	 
		--------------------------CHARACTER CONTROL-------------------------------
		local CurrentIgnoreList
		local CurrentIgnoreTag = nil
	 
		local TaggedInstanceAddedConnection = nil
		local TaggedInstanceRemovedConnection = nil
	 
		local function GetCharacter()
			return Player and Player.Character
		end
	 
		local function UpdateIgnoreTag(newIgnoreTag)
			if newIgnoreTag == CurrentIgnoreTag then
				return
			end
			if TaggedInstanceAddedConnection then
				TaggedInstanceAddedConnection:Disconnect()
				TaggedInstanceAddedConnection = nil
			end
			if TaggedInstanceRemovedConnection then
				TaggedInstanceRemovedConnection:Disconnect()
				TaggedInstanceRemovedConnection = nil
			end
			CurrentIgnoreTag = newIgnoreTag
			CurrentIgnoreList = {GetCharacter()}
			if CurrentIgnoreTag ~= nil then
				local ignoreParts = CollectionService:GetTagged(CurrentIgnoreTag)
				for _, ignorePart in ipairs(ignoreParts) do
					table.insert(CurrentIgnoreList, ignorePart)
				end
				TaggedInstanceAddedConnection = CollectionService:GetInstanceAddedSignal(
					CurrentIgnoreTag):Connect(function(ignorePart)
					table.insert(CurrentIgnoreList, ignorePart)
				end)
				TaggedInstanceRemovedConnection = CollectionService:GetInstanceRemovedSignal(
					CurrentIgnoreTag):Connect(function(ignorePart)
					for i = 1, #CurrentIgnoreList do
						if CurrentIgnoreList[i] == ignorePart then
							CurrentIgnoreList[i] = CurrentIgnoreList[#CurrentIgnoreList]
							table.remove(CurrentIgnoreList)
							break
						end
					end
				end)
			end
		end
	 
		local function getIgnoreList()
			if CurrentIgnoreList then
				return CurrentIgnoreList
			end
			CurrentIgnoreList = {}
			table.insert(CurrentIgnoreList, GetCharacter())
			return CurrentIgnoreList
		end
	 
		-----------------------------------PATHER--------------------------------------
	 
		local function Pather(endPoint, surfaceNormal, overrideUseDirectPath)
			local this = {}
	 
			local directPathForHumanoid
			local directPathForVehicle
			if overrideUseDirectPath ~= nil then
				directPathForHumanoid = overrideUseDirectPath
				directPathForVehicle = overrideUseDirectPath
			else
				directPathForHumanoid = UseDirectPath
				directPathForVehicle = UseDirectPathForVehicle
			end
	 
			this.Cancelled = false
			this.Started = false
	 
			this.Finished = Instance.new("BindableEvent")
			this.PathFailed = Instance.new("BindableEvent")
	 
			this.PathComputing = false
			this.PathComputed = false
	 
			this.OriginalTargetPoint = endPoint
			this.TargetPoint = endPoint
			this.TargetSurfaceNormal = surfaceNormal
	 
			this.DiedConn = nil
			this.SeatedConn = nil
			this.BlockedConn = nil
			this.TeleportedConn = nil
	 
			this.CurrentPoint = 0
	 
			this.HumanoidOffsetFromPath = ZERO_VECTOR3
	 
			this.CurrentWaypointPosition = nil
			this.CurrentWaypointPlaneNormal = ZERO_VECTOR3
			this.CurrentWaypointPlaneDistance = 0
			this.CurrentWaypointNeedsJump = false;
	 
			this.CurrentHumanoidPosition = ZERO_VECTOR3
			this.CurrentHumanoidVelocity = 0
	 
			this.NextActionMoveDirection = ZERO_VECTOR3
			this.NextActionJump = false
	 
			this.Timeout = 0
	 
			this.Humanoid = findPlayerHumanoid(Player)
			this.OriginPoint = nil
			this.AgentCanFollowPath = false
			this.DirectPath = false
			this.DirectPathRiseFirst = false
	 
			local rootPart = this.Humanoid and this.Humanoid.RootPart
			if rootPart then
				-- Setup origin
				this.OriginPoint = rootPart.CFrame.p
	 
				-- Setup agent
				local agentRadius = 2
				local agentHeight = 5
				local agentCanJump = true
	 
				local seat = this.Humanoid.SeatPart
				if seat and seat:IsA("VehicleSeat") then
					-- Humanoid is seated on a vehicle
					local vehicle = seat:FindFirstAncestorOfClass("Model")
					if vehicle then
						-- Make sure the PrimaryPart is set to the vehicle seat while we compute the extends.
						local tempPrimaryPart = vehicle.PrimaryPart
						vehicle.PrimaryPart = seat
	 
						-- For now, only direct path
						if directPathForVehicle then
							local extents = vehicle:GetExtentsSize()
							agentRadius = AgentSizeIncreaseFactor * 0.5 * math.sqrt(extents.X * extents.X + extents.Z * extents.Z)
							agentHeight = AgentSizeIncreaseFactor * extents.Y
							agentCanJump = false
							this.AgentCanFollowPath = true
							this.DirectPath = directPathForVehicle
						end
	 
						-- Reset PrimaryPart
						vehicle.PrimaryPart = tempPrimaryPart
					end
				else
					local extents = GetCharacter():GetExtentsSize()
					agentRadius = AgentSizeIncreaseFactor * 0.5 * math.sqrt(extents.X * extents.X + extents.Z * extents.Z)
					agentHeight = AgentSizeIncreaseFactor * extents.Y
					agentCanJump = (this.Humanoid.JumpPower > 0)
					this.AgentCanFollowPath = true
					this.DirectPath = directPathForHumanoid
					this.DirectPathRiseFirst = this.Humanoid.Sit
				end
	 
				-- Build path object
				this.pathResult = PathfindingService:CreatePath({AgentRadius = agentRadius, AgentHeight = agentHeight, AgentCanJump = agentCanJump})
			end
	 
			function this:Cleanup()
				if this.stopTraverseFunc then
					this.stopTraverseFunc()
					this.stopTraverseFunc = nil
				end
	 
				if this.MoveToConn then
					this.MoveToConn:Disconnect()
					this.MoveToConn = nil
				end
	 
				if this.BlockedConn then
					this.BlockedConn:Disconnect()
					this.BlockedConn = nil
				end
	 
				if this.DiedConn then
					this.DiedConn:Disconnect()
					this.DiedConn = nil
				end
	 
				if this.SeatedConn then
					this.SeatedConn:Disconnect()
					this.SeatedConn = nil
				end
	 
				if this.TeleportedConn then
					this.TeleportedConn:Disconnect()
					this.TeleportedConn = nil
				end
	 
				this.Started = false
			end
	 
			function this:Cancel()
				this.Cancelled = true
				this:Cleanup()
			end
	 
			function this:IsActive()
				return this.AgentCanFollowPath and this.Started and not this.Cancelled
			end
	 
			function this:OnPathInterrupted()
				-- Stop moving
				this.Cancelled = true
				this:OnPointReached(false)
			end
	 
			function this:ComputePath()
				if this.OriginPoint then
					if this.PathComputed or this.PathComputing then return end
					this.PathComputing = true
					if this.AgentCanFollowPath then
						if this.DirectPath then
							this.pointList = {
								PathWaypoint.new(this.OriginPoint, Enum.PathWaypointAction.Walk),
								PathWaypoint.new(this.TargetPoint, this.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk)
							}
							this.PathComputed = true
						else
							this.pathResult:ComputeAsync(this.OriginPoint, this.TargetPoint)
							this.pointList = this.pathResult:GetWaypoints()
							this.BlockedConn = this.pathResult.Blocked:Connect(function(blockedIdx) this:OnPathBlocked(blockedIdx) end)
							this.PathComputed = this.pathResult.Status == Enum.PathStatus.Success
						end
					end
					this.PathComputing = false
				end
			end
	 
			function this:IsValidPath()
				this:ComputePath()
				return this.PathComputed and this.AgentCanFollowPath
			end
	 
			this.Recomputing = false
			function this:OnPathBlocked(blockedWaypointIdx)
				local pathBlocked = blockedWaypointIdx >= this.CurrentPoint
				if not pathBlocked or this.Recomputing then
					return
				end
	 
				this.Recomputing = true
	 
				if this.stopTraverseFunc then
					this.stopTraverseFunc()
					this.stopTraverseFunc = nil
				end
	 
				this.OriginPoint = this.Humanoid.RootPart.CFrame.p
	 
				this.pathResult:ComputeAsync(this.OriginPoint, this.TargetPoint)
				this.pointList = this.pathResult:GetWaypoints()
				if #this.pointList > 0 then
					this.HumanoidOffsetFromPath = this.pointList[1].Position - this.OriginPoint
				end
				this.PathComputed = this.pathResult.Status == Enum.PathStatus.Success
	 
				if ShowPath then
					this.stopTraverseFunc, this.setPointFunc = ClickToMoveDisplay.CreatePathDisplay(this.pointList)
				end
				if this.PathComputed then
					this.CurrentPoint = 1 -- The first waypoint is always the start location. Skip it.
					this:OnPointReached(true) -- Move to first point
				else
					this.PathFailed:Fire()
					this:Cleanup()
				end
	 
				this.Recomputing = false
			end
	 
			function this:OnRenderStepped(dt)
				if this.Started and not this.Cancelled then
					-- Check for Timeout (if a waypoint is not reached within the delay, we fail)
					this.Timeout = this.Timeout + dt
					if this.Timeout > UnreachableWaypointTimeout then
						this:OnPointReached(false)
						return
					end
	 
					-- Get Humanoid position and velocity
					this.CurrentHumanoidPosition = this.Humanoid.RootPart.Position + this.HumanoidOffsetFromPath
					this.CurrentHumanoidVelocity = this.Humanoid.RootPart.Velocity
	 
					-- Check if it has reached some waypoints
					while this.Started and this:IsCurrentWaypointReached() do
						this:OnPointReached(true)
					end
	 
					-- If still started, update actions
					if this.Started then
						-- Move action
						this.NextActionMoveDirection = this.CurrentWaypointPosition - this.CurrentHumanoidPosition
						if this.NextActionMoveDirection.Magnitude > ALMOST_ZERO then
							this.NextActionMoveDirection = this.NextActionMoveDirection.Unit
						else
							this.NextActionMoveDirection = ZERO_VECTOR3
						end
						-- Jump action
						if this.CurrentWaypointNeedsJump then
							this.NextActionJump = true
							this.CurrentWaypointNeedsJump = false	-- Request jump only once
						else
							this.NextActionJump = false
						end
					end
				end
			end
	 
			function this:IsCurrentWaypointReached()
				local reached = false
	 
				-- Check we do have a plane, if not, we consider the waypoint reached
				if this.CurrentWaypointPlaneNormal ~= ZERO_VECTOR3 then
					-- Compute distance of Humanoid from destination plane
					local dist = this.CurrentWaypointPlaneNormal:Dot(this.CurrentHumanoidPosition) - this.CurrentWaypointPlaneDistance
					-- Compute the component of the Humanoid velocity that is towards the plane
					local velocity = -this.CurrentWaypointPlaneNormal:Dot(this.CurrentHumanoidVelocity)
					-- Compute the threshold from the destination plane based on Humanoid velocity
					local threshold = math.max(1.0, 0.0625 * velocity)
					-- If we are less then threshold in front of the plane (between 0 and threshold) or if we are behing the plane (less then 0), we consider we reached it
					reached = dist < threshold
				else
					reached = true
				end
	 
				if reached then
					this.CurrentWaypointPosition = nil
					this.CurrentWaypointPlaneNormal	= ZERO_VECTOR3
					this.CurrentWaypointPlaneDistance = 0
				end
	 
				return reached
			end
	 
			function this:OnPointReached(reached)
	 
				if reached and not this.Cancelled then
					-- First, destroyed the current displayed waypoint
					if this.setPointFunc then
						this.setPointFunc(this.CurrentPoint)
					end
	 
					local nextWaypointIdx = this.CurrentPoint + 1
	 
					if nextWaypointIdx > #this.pointList then
						-- End of path reached
						if this.stopTraverseFunc then
							this.stopTraverseFunc()
						end
						this.Finished:Fire()
						this:Cleanup()
					else
						local currentWaypoint = this.pointList[this.CurrentPoint]
						local nextWaypoint = this.pointList[nextWaypointIdx]
	 
						-- If airborne, only allow to keep moving
						-- if nextWaypoint.Action ~= Jump, or path mantains a direction
						-- Otherwise, wait until the humanoid gets to the ground
						local currentState = this.Humanoid:GetState()
						local isInAir = currentState == Enum.HumanoidStateType.FallingDown
							or currentState == Enum.HumanoidStateType.Freefall
							or currentState == Enum.HumanoidStateType.Jumping
	 
						if isInAir then
							local shouldWaitForGround = nextWaypoint.Action == Enum.PathWaypointAction.Jump
							if not shouldWaitForGround and this.CurrentPoint > 1 then
								local prevWaypoint = this.pointList[this.CurrentPoint - 1]
	 
								local prevDir = currentWaypoint.Position - prevWaypoint.Position
								local currDir = nextWaypoint.Position - currentWaypoint.Position
	 
								local prevDirXZ = Vector2.new(prevDir.x, prevDir.z).Unit
								local currDirXZ = Vector2.new(currDir.x, currDir.z).Unit
	 
								local THRESHOLD_COS = 0.996 -- ~cos(5 degrees)
								shouldWaitForGround = prevDirXZ:Dot(currDirXZ) < THRESHOLD_COS
							end
	 
							if shouldWaitForGround then
								this.Humanoid.FreeFalling:Wait()
	 
								-- Give time to the humanoid's state to change
								-- Otherwise, the jump flag in Humanoid
								-- will be reset by the state change
								wait(0.1)
							end
						end
	 
						-- Move to the next point
						if FFlagUserNavigationClickToMoveSkipPassedWaypoints then
							this:MoveToNextWayPoint(currentWaypoint, nextWaypoint, nextWaypointIdx)
						else
							if this.setPointFunc then
								this.setPointFunc(nextWaypointIdx)
							end
							if nextWaypoint.Action == Enum.PathWaypointAction.Jump then
								this.Humanoid.Jump = true
							end
							this.Humanoid:MoveTo(nextWaypoint.Position)
	 
							this.CurrentPoint = nextWaypointIdx
						end
					end
				else
					this.PathFailed:Fire()
					this:Cleanup()
				end
			end
	 
			function this:MoveToNextWayPoint(currentWaypoint, nextWaypoint, nextWaypointIdx)
				-- Build next destination plane
				-- (plane normal is perpendicular to the y plane and is from next waypoint towards current one (provided the two waypoints are not at the same location))
				-- (plane location is at next waypoint)
				this.CurrentWaypointPlaneNormal = currentWaypoint.Position - nextWaypoint.Position
				this.CurrentWaypointPlaneNormal = Vector3.new(this.CurrentWaypointPlaneNormal.X, 0, this.CurrentWaypointPlaneNormal.Z)
				if this.CurrentWaypointPlaneNormal.Magnitude > ALMOST_ZERO then
					this.CurrentWaypointPlaneNormal	= this.CurrentWaypointPlaneNormal.Unit
					this.CurrentWaypointPlaneDistance = this.CurrentWaypointPlaneNormal:Dot(nextWaypoint.Position)
				else
					-- Next waypoint is the same as current waypoint so no plane
					this.CurrentWaypointPlaneNormal	= ZERO_VECTOR3
					this.CurrentWaypointPlaneDistance = 0
				end
	 
				-- Should we jump
				this.CurrentWaypointNeedsJump = nextWaypoint.Action == Enum.PathWaypointAction.Jump;
	 
				-- Remember next waypoint position
				this.CurrentWaypointPosition = nextWaypoint.Position
	 
				-- Move to next point
				this.CurrentPoint = nextWaypointIdx
	 
				-- Finally reset Timeout
				this.Timeout = 0
			end
	 
			function this:Start(overrideShowPath)
				if not this.AgentCanFollowPath then
					this.PathFailed:Fire()
					return
				end
	 
				if this.Started then return end
				this.Started = true
	 
				ClickToMoveDisplay.CancelFailureAnimation()
	 
				if ShowPath then
					if overrideShowPath == nil or overrideShowPath then
						this.stopTraverseFunc, this.setPointFunc = ClickToMoveDisplay.CreatePathDisplay(this.pointList, this.OriginalTargetPoint)
					end
				end
	 
				if #this.pointList > 0 then
					-- Determine the humanoid offset from the path's first point
					-- Offset of the first waypoint from the path's origin point
					this.HumanoidOffsetFromPath = Vector3.new(0, this.pointList[1].Position.Y - this.OriginPoint.Y, 0)
	 
					-- As well as its current position and velocity
					this.CurrentHumanoidPosition = this.Humanoid.RootPart.Position + this.HumanoidOffsetFromPath
					this.CurrentHumanoidVelocity = this.Humanoid.RootPart.Velocity
	 
					-- Connect to events
					this.SeatedConn = this.Humanoid.Seated:Connect(function(isSeated, seat) this:OnPathInterrupted() end)
					this.DiedConn = this.Humanoid.Died:Connect(function() this:OnPathInterrupted() end)
					this.TeleportedConn = this.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() this:OnPathInterrupted() end)
	 
					-- Actually start
					this.CurrentPoint = 1 -- The first waypoint is always the start location. Skip it.
					this:OnPointReached(true) -- Move to first point
				else
					this.PathFailed:Fire()
					if this.stopTraverseFunc then
						this.stopTraverseFunc()
					end
				end
			end
	 
			--We always raycast to the ground in the case that the user clicked a wall.
			local offsetPoint = this.TargetPoint + this.TargetSurfaceNormal*1.5
			local ray = Ray.new(offsetPoint, Vector3.new(0,-1,0)*50)
			local newHitPart, newHitPos = Workspace:FindPartOnRayWithIgnoreList(ray, getIgnoreList())
			if newHitPart then
				this.TargetPoint = newHitPos
			end
			this:ComputePath()
	 
			return this
		end
	 
		-------------------------------------------------------------------------
	 
		local function CheckAlive()
			local humanoid = findPlayerHumanoid(Player)
			return humanoid ~= nil and humanoid.Health > 0
		end
	 
		local function GetEquippedTool(character)
			if character ~= nil then
				for _, child in pairs(character:GetChildren()) do
					if child:IsA('Tool') then
						return child
					end
				end
			end
		end
	 
		local ExistingPather = nil
		local ExistingIndicator = nil
		local PathCompleteListener = nil
		local PathFailedListener = nil
	 
		local function CleanupPath()
			if ExistingPather then
				ExistingPather:Cancel()
				ExistingPather = nil
			end
			if PathCompleteListener then
				PathCompleteListener:Disconnect()
				PathCompleteListener = nil
			end
			if PathFailedListener then
				PathFailedListener:Disconnect()
				PathFailedListener = nil
			end
			if ExistingIndicator then
				ExistingIndicator:Destroy()
			end
		end
	 
		local function HandleMoveTo(thisPather, hitPt, hitChar, character, overrideShowPath)
			if ExistingPather then
				CleanupPath()
			end
			ExistingPather = thisPather
			thisPather:Start(overrideShowPath)
	 
			PathCompleteListener = thisPather.Finished.Event:Connect(function()
				CleanupPath()
				if hitChar then
					local currentWeapon = GetEquippedTool(character)
					if currentWeapon then
						currentWeapon:Activate()
					end
				end
			end)
			PathFailedListener = thisPather.PathFailed.Event:Connect(function()
				CleanupPath()
				if overrideShowPath == nil or overrideShowPath then
					local shouldPlayFailureAnim = PlayFailureAnimation and not (ExistingPather and ExistingPather:IsActive())
					if shouldPlayFailureAnim then
						ClickToMoveDisplay.PlayFailureAnimation()
					end
					ClickToMoveDisplay.DisplayFailureWaypoint(hitPt)
				end
			end)
		end
	 
		local function ShowPathFailedFeedback(hitPt)
			if ExistingPather and ExistingPather:IsActive() then
				ExistingPather:Cancel()
			end
			if PlayFailureAnimation then
				ClickToMoveDisplay.PlayFailureAnimation()
			end
			ClickToMoveDisplay.DisplayFailureWaypoint(hitPt)
		end
	 
		function OnTap(tapPositions, goToPoint, wasTouchTap)
			-- Good to remember if this is the latest tap event
			local camera = Workspace.CurrentCamera
			local character = Player.Character
	 
			if not CheckAlive() then return end
	 
			-- This is a path tap position
			if #tapPositions == 1 or goToPoint then
				if camera then
					local unitRay = camera:ScreenPointToRay(tapPositions[1].x, tapPositions[1].y)
					local ray = Ray.new(unitRay.Origin, unitRay.Direction*1000)
	 
					local myHumanoid = findPlayerHumanoid(Player)
					local hitPart, hitPt, hitNormal = Utility.Raycast(ray, true, getIgnoreList())
	 
					local hitChar, hitHumanoid = Utility.FindCharacterAncestor(hitPart)
					if wasTouchTap and hitHumanoid and StarterGui:GetCore("AvatarContextMenuEnabled") then
						local clickedPlayer = Players:GetPlayerFromCharacter(hitHumanoid.Parent)
						if clickedPlayer then
							CleanupPath()
							return
						end
					end
					if goToPoint then
						hitPt = goToPoint
						hitChar = nil
					end
					if hitPt and character then
						-- Clean up current path
						CleanupPath()
						local thisPather = Pather(hitPt, hitNormal)
						if thisPather:IsValidPath() then
							HandleMoveTo(thisPather, hitPt, hitChar, character)
						else
							-- Clean up
							thisPather:Cleanup()
							-- Feedback here for when we don't have a good path
							ShowPathFailedFeedback(hitPt)
						end
					end
				end
			elseif #tapPositions >= 2 then
				if camera then
					-- Do shoot
					local currentWeapon = GetEquippedTool(character)
					if currentWeapon then
						currentWeapon:Activate()
					end
				end
			end
		end
	 
		local function DisconnectEvent(event)
			if event then
				event:Disconnect()
			end
		end
	 
		--[[ The ClickToMove Controller Class ]]--
		local KeyboardController = _Keyboard()
		local ClickToMove = setmetatable({}, KeyboardController)
		ClickToMove.__index = ClickToMove
	 
		function ClickToMove.new(CONTROL_ACTION_PRIORITY)
			local self = setmetatable(KeyboardController.new(CONTROL_ACTION_PRIORITY), ClickToMove)
	 
			self.fingerTouches = {}
			self.numUnsunkTouches = 0
			-- PC simulation
			self.mouse1Down = tick()
			self.mouse1DownPos = Vector2.new()
			self.mouse2DownTime = tick()
			self.mouse2DownPos = Vector2.new()
			self.mouse2UpTime = tick()
	 
			self.keyboardMoveVector = ZERO_VECTOR3
	 
			self.tapConn = nil
			self.inputBeganConn = nil
			self.inputChangedConn = nil
			self.inputEndedConn = nil
			self.humanoidDiedConn = nil
			self.characterChildAddedConn = nil
			self.onCharacterAddedConn = nil
			self.characterChildRemovedConn = nil
			self.renderSteppedConn = nil
			self.menuOpenedConnection = nil
	 
			self.running = false
	 
			self.wasdEnabled = false
	 
			return self
		end
	 
		function ClickToMove:DisconnectEvents()
			DisconnectEvent(self.tapConn)
			DisconnectEvent(self.inputBeganConn)
			DisconnectEvent(self.inputChangedConn)
			DisconnectEvent(self.inputEndedConn)
			DisconnectEvent(self.humanoidDiedConn)
			DisconnectEvent(self.characterChildAddedConn)
			DisconnectEvent(self.onCharacterAddedConn)
			DisconnectEvent(self.renderSteppedConn)
			DisconnectEvent(self.characterChildRemovedConn)
			DisconnectEvent(self.menuOpenedConnection)
		end
	 
		function ClickToMove:OnTouchBegan(input, processed)
			if self.fingerTouches[input] == nil and not processed then
				self.numUnsunkTouches = self.numUnsunkTouches + 1
			end
			self.fingerTouches[input] = processed
		end
	 
		function ClickToMove:OnTouchChanged(input, processed)
			if self.fingerTouches[input] == nil then
				self.fingerTouches[input] = processed
				if not processed then
					self.numUnsunkTouches = self.numUnsunkTouches + 1
				end
			end
		end
	 
		function ClickToMove:OnTouchEnded(input, processed)
			if self.fingerTouches[input] ~= nil and self.fingerTouches[input] == false then
				self.numUnsunkTouches = self.numUnsunkTouches - 1
			end
			self.fingerTouches[input] = nil
		end
	 
	 
		function ClickToMove:OnCharacterAdded(character)
			self:DisconnectEvents()
	 
			self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.Touch then
					self:OnTouchBegan(input, processed)
				end
	 
				-- Cancel path when you use the keyboard controls if wasd is enabled.
				if self.wasdEnabled and processed == false and input.UserInputType == Enum.UserInputType.Keyboard
					and movementKeys[input.KeyCode] then
					CleanupPath()
					ClickToMoveDisplay.CancelFailureAnimation()
				end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					self.mouse1DownTime = tick()
					self.mouse1DownPos = input.Position
				end
				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					self.mouse2DownTime = tick()
					self.mouse2DownPos = input.Position
				end
			end)
	 
			self.inputChangedConn = UserInputService.InputChanged:Connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.Touch then
					self:OnTouchChanged(input, processed)
				end
			end)
	 
			self.inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.Touch then
					self:OnTouchEnded(input, processed)
				end
	 
				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					self.mouse2UpTime = tick()
					local currPos = input.Position
					-- We allow click to move during path following or if there is no keyboard movement
					local allowed = ExistingPather or self.keyboardMoveVector.Magnitude <= 0
					if self.mouse2UpTime - self.mouse2DownTime < 0.25 and (currPos - self.mouse2DownPos).magnitude < 5 and allowed then
						local positions = {currPos}
						OnTap(positions)
					end
				end
			end)
	 
			self.tapConn = UserInputService.TouchTap:Connect(function(touchPositions, processed)
				if not processed then
					OnTap(touchPositions, nil, true)
				end
			end)
	 
			self.menuOpenedConnection = GuiService.MenuOpened:Connect(function()
				CleanupPath()
			end)
	 
			local function OnCharacterChildAdded(child)
				if UserInputService.TouchEnabled then
					if child:IsA('Tool') then
						child.ManualActivationOnly = true
					end
				end
				if child:IsA('Humanoid') then
					DisconnectEvent(self.humanoidDiedConn)
					self.humanoidDiedConn = child.Died:Connect(function()
						if ExistingIndicator then
							DebrisService:AddItem(ExistingIndicator.Model, 1)
						end
					end)
				end
			end
	 
			self.characterChildAddedConn = character.ChildAdded:Connect(function(child)
				OnCharacterChildAdded(child)
			end)
			self.characterChildRemovedConn = character.ChildRemoved:Connect(function(child)
				if UserInputService.TouchEnabled then
					if child:IsA('Tool') then
						child.ManualActivationOnly = false
					end
				end
			end)
			for _, child in pairs(character:GetChildren()) do
				OnCharacterChildAdded(child)
			end
		end
	 
		function ClickToMove:Start()
			self:Enable(true)
		end
	 
		function ClickToMove:Stop()
			self:Enable(false)
		end
	 
		function ClickToMove:CleanupPath()
			CleanupPath()
		end
	 
		function ClickToMove:Enable(enable, enableWASD, touchJumpController)
			if enable then
				if not self.running then
					if Player.Character then -- retro-listen
						self:OnCharacterAdded(Player.Character)
					end
					self.onCharacterAddedConn = Player.CharacterAdded:Connect(function(char)
						self:OnCharacterAdded(char)
					end)
					self.running = true
				end
				self.touchJumpController = touchJumpController
				if self.touchJumpController then
					self.touchJumpController:Enable(self.jumpEnabled)
				end
			else
				if self.running then
					self:DisconnectEvents()
					CleanupPath()
					-- Restore tool activation on shutdown
					if UserInputService.TouchEnabled then
						local character = Player.Character
						if character then
							for _, child in pairs(character:GetChildren()) do
								if child:IsA('Tool') then
									child.ManualActivationOnly = false
								end
							end
						end
					end
					self.running = false
				end
				if self.touchJumpController and not self.jumpEnabled then
					self.touchJumpController:Enable(true)
				end
				self.touchJumpController = nil
			end
	 
			-- Extension for initializing Keyboard input as this class now derives from Keyboard
			if UserInputService.KeyboardEnabled and enable ~= self.enabled then
	 
				self.forwardValue  = 0
				self.backwardValue = 0
				self.leftValue = 0
				self.rightValue = 0
	 
				self.moveVector = ZERO_VECTOR3
	 
				if enable then
					self:BindContextActions()
					self:ConnectFocusEventListeners()
				else
					self:UnbindContextActions()
					self:DisconnectFocusEventListeners()
				end
			end
	 
			self.wasdEnabled = enable and enableWASD or false
			self.enabled = enable
		end
	 
		function ClickToMove:OnRenderStepped(dt)
			-- Reset jump
			self.isJumping = false
	 
			-- Handle Pather
			if ExistingPather then
				-- Let the Pather update
				ExistingPather:OnRenderStepped(dt)
	 
				-- If we still have a Pather, set the resulting actions
				if ExistingPather then
					-- Setup move (NOT relative to camera)
					self.moveVector = ExistingPather.NextActionMoveDirection
					self.moveVectorIsCameraRelative = false
	 
					-- Setup jump (but do NOT prevent the base Keayboard class from requesting jumps as well)
					if ExistingPather.NextActionJump then
						self.isJumping = true
					end
				else
					self.moveVector = self.keyboardMoveVector
					self.moveVectorIsCameraRelative = true
				end
			else
				self.moveVector = self.keyboardMoveVector
				self.moveVectorIsCameraRelative = true
			end
	 
			-- Handle Keyboard's jump
			if self.jumpRequested then
				self.isJumping = true
			end
		end
	 
		-- Overrides Keyboard:UpdateMovement(inputState) to conditionally consider self.wasdEnabled and let OnRenderStepped handle the movement
		function ClickToMove:UpdateMovement(inputState)
			if inputState == Enum.UserInputState.Cancel then
				self.keyboardMoveVector = ZERO_VECTOR3
			elseif self.wasdEnabled then
				self.keyboardMoveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
			end
		end
	 
		-- Overrides Keyboard:UpdateJump() because jump is handled in OnRenderStepped
		function ClickToMove:UpdateJump()
			-- Nothing to do (handled in OnRenderStepped)
		end
	 
		--Public developer facing functions
		function ClickToMove:SetShowPath(value)
			ShowPath = value
		end
	 
		function ClickToMove:GetShowPath()
			return ShowPath
		end
	 
		function ClickToMove:SetWaypointTexture(texture)
			ClickToMoveDisplay.SetWaypointTexture(texture)
		end
	 
		function ClickToMove:GetWaypointTexture()
			return ClickToMoveDisplay.GetWaypointTexture()
		end
	 
		function ClickToMove:SetWaypointRadius(radius)
			ClickToMoveDisplay.SetWaypointRadius(radius)
		end
	 
		function ClickToMove:GetWaypointRadius()
			return ClickToMoveDisplay.GetWaypointRadius()
		end
	 
		function ClickToMove:SetEndWaypointTexture(texture)
			ClickToMoveDisplay.SetEndWaypointTexture(texture)
		end
	 
		function ClickToMove:GetEndWaypointTexture()
			return ClickToMoveDisplay.GetEndWaypointTexture()
		end
	 
		function ClickToMove:SetWaypointsAlwaysOnTop(alwaysOnTop)
			ClickToMoveDisplay.SetWaypointsAlwaysOnTop(alwaysOnTop)
		end
	 
		function ClickToMove:GetWaypointsAlwaysOnTop()
			return ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
		end
	 
		function ClickToMove:SetFailureAnimationEnabled(enabled)
			PlayFailureAnimation = enabled
		end
	 
		function ClickToMove:GetFailureAnimationEnabled()
			return PlayFailureAnimation
		end
	 
		function ClickToMove:SetIgnoredPartsTag(tag)
			UpdateIgnoreTag(tag)
		end
	 
		function ClickToMove:GetIgnoredPartsTag()
			return CurrentIgnoreTag
		end
	 
		function ClickToMove:SetUseDirectPath(directPath)
			UseDirectPath = directPath
		end
	 
		function ClickToMove:GetUseDirectPath()
			return UseDirectPath
		end
	 
		function ClickToMove:SetAgentSizeIncreaseFactor(increaseFactorPercent)
			AgentSizeIncreaseFactor = 1.0 + (increaseFactorPercent / 100.0)
		end
	 
		function ClickToMove:GetAgentSizeIncreaseFactor()
			return (AgentSizeIncreaseFactor - 1.0) * 100.0
		end
	 
		function ClickToMove:SetUnreachableWaypointTimeout(timeoutInSec)
			UnreachableWaypointTimeout = timeoutInSec
		end
	 
		function ClickToMove:GetUnreachableWaypointTimeout()
			return UnreachableWaypointTimeout
		end
	 
		function ClickToMove:SetUserJumpEnabled(jumpEnabled)
			self.jumpEnabled = jumpEnabled
			if self.touchJumpController then
				self.touchJumpController:Enable(jumpEnabled)
			end
		end
	 
		function ClickToMove:GetUserJumpEnabled()
			return self.jumpEnabled
		end
	 
		function ClickToMove:MoveTo(position, showPath, useDirectPath)
			local character = Player.Character
			if character == nil then
				return false
			end
			local thisPather = Pather(position, Vector3.new(0, 1, 0), useDirectPath)
			if thisPather and thisPather:IsValidPath() then
				HandleMoveTo(thisPather, position, nil, character, showPath)
				return true
			end
			return false
		end
	 
		return ClickToMove
	end
	 
	function _TouchThumbstick()
		local Players = game:GetService("Players")
		local GuiService = game:GetService("GuiService")
		local UserInputService = game:GetService("UserInputService")
		--[[ Constants ]]--
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
		local TOUCH_CONTROL_SHEET = "rbxasset://textures/ui/TouchControlsSheet.png"
		--[[ The Module ]]--
		local BaseCharacterController = _BaseCharacterController()
		local TouchThumbstick = setmetatable({}, BaseCharacterController)
		TouchThumbstick.__index = TouchThumbstick
		function TouchThumbstick.new()
			local self = setmetatable(BaseCharacterController.new(), TouchThumbstick)
	 
			self.isFollowStick = false
	 
			self.thumbstickFrame = nil
			self.moveTouchObject = nil
			self.onTouchMovedConn = nil
			self.onTouchEndedConn = nil
			self.screenPos = nil
			self.stickImage = nil
			self.thumbstickSize = nil -- Float
	 
			return self
		end
		function TouchThumbstick:Enable(enable, uiParentFrame)
			if enable == nil then return false end			-- If nil, return false (invalid argument)
			enable = enable and true or false				-- Force anything non-nil to boolean before comparison
			if self.enabled == enable then return true end	-- If no state change, return true indicating already in requested state
	 
			self.moveVector = ZERO_VECTOR3
			self.isJumping = false
	 
			if enable then
				-- Enable
				if not self.thumbstickFrame then
					self:Create(uiParentFrame)
				end
				self.thumbstickFrame.Visible = true
			else 
				-- Disable
				self.thumbstickFrame.Visible = false
				self:OnInputEnded()
			end
			self.enabled = enable
		end
		function TouchThumbstick:OnInputEnded()
			self.thumbstickFrame.Position = self.screenPos
			self.stickImage.Position = UDim2.new(0, self.thumbstickFrame.Size.X.Offset/2 - self.thumbstickSize/4, 0, self.thumbstickFrame.Size.Y.Offset/2 - self.thumbstickSize/4)
	 
			self.moveVector = ZERO_VECTOR3
			self.isJumping = false
			self.thumbstickFrame.Position = self.screenPos
			self.moveTouchObject = nil
		end
		function TouchThumbstick:Create(parentFrame)
	 
			if self.thumbstickFrame then
				self.thumbstickFrame:Destroy()
				self.thumbstickFrame = nil
				if self.onTouchMovedConn then
					self.onTouchMovedConn:Disconnect()
					self.onTouchMovedConn = nil
				end
				if self.onTouchEndedConn then
					self.onTouchEndedConn:Disconnect()
					self.onTouchEndedConn = nil
				end
			end
	 
			local minAxis = math.min(parentFrame.AbsoluteSize.x, parentFrame.AbsoluteSize.y)
			local isSmallScreen = minAxis <= 500
			self.thumbstickSize = isSmallScreen and 70 or 120
			self.screenPos = isSmallScreen and UDim2.new(0, (self.thumbstickSize/2) - 10, 1, -self.thumbstickSize - 20) or
				UDim2.new(0, self.thumbstickSize/2, 1, -self.thumbstickSize * 1.75)
	 
			self.thumbstickFrame = Instance.new("Frame")
			self.thumbstickFrame.Name = "ThumbstickFrame"
			self.thumbstickFrame.Active = true
			self.thumbstickFrame.Visible = false
			self.thumbstickFrame.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
			self.thumbstickFrame.Position = self.screenPos
			self.thumbstickFrame.BackgroundTransparency = 1
	 
			local outerImage = Instance.new("ImageLabel")
			outerImage.Name = "OuterImage"
			outerImage.Image = TOUCH_CONTROL_SHEET
			outerImage.ImageRectOffset = Vector2.new()
			outerImage.ImageRectSize = Vector2.new(220, 220)
			outerImage.BackgroundTransparency = 1
			outerImage.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
			outerImage.Position = UDim2.new(0, 0, 0, 0)
			outerImage.Parent = self.thumbstickFrame
	 
			self.stickImage = Instance.new("ImageLabel")
			self.stickImage.Name = "StickImage"
			self.stickImage.Image = TOUCH_CONTROL_SHEET
			self.stickImage.ImageRectOffset = Vector2.new(220, 0)
			self.stickImage.ImageRectSize = Vector2.new(111, 111)
			self.stickImage.BackgroundTransparency = 1
			self.stickImage.Size = UDim2.new(0, self.thumbstickSize/2, 0, self.thumbstickSize/2)
			self.stickImage.Position = UDim2.new(0, self.thumbstickSize/2 - self.thumbstickSize/4, 0, self.thumbstickSize/2 - self.thumbstickSize/4)
			self.stickImage.ZIndex = 2
			self.stickImage.Parent = self.thumbstickFrame
	 
			local centerPosition = nil
			local deadZone = 0.05
	 
			local function DoMove(direction)
	 
				local currentMoveVector = direction / (self.thumbstickSize/2)
	 
				-- Scaled Radial Dead Zone
				local inputAxisMagnitude = currentMoveVector.magnitude
				if inputAxisMagnitude < deadZone then
					currentMoveVector = Vector3.new()
				else
					currentMoveVector = currentMoveVector.unit * ((inputAxisMagnitude - deadZone) / (1 - deadZone))
					-- NOTE: Making currentMoveVector a unit vector will cause the player to instantly go max speed
					-- must check for zero length vector is using unit
					currentMoveVector = Vector3.new(currentMoveVector.x, 0, currentMoveVector.y)
				end
	 
				self.moveVector = currentMoveVector
			end
	 
			local function MoveStick(pos)
				local relativePosition = Vector2.new(pos.x - centerPosition.x, pos.y - centerPosition.y)
				local length = relativePosition.magnitude
				local maxLength = self.thumbstickFrame.AbsoluteSize.x/2
				if self.isFollowStick and length > maxLength then
					local offset = relativePosition.unit * maxLength
					self.thumbstickFrame.Position = UDim2.new(
						0, pos.x - self.thumbstickFrame.AbsoluteSize.x/2 - offset.x,
						0, pos.y - self.thumbstickFrame.AbsoluteSize.y/2 - offset.y)
				else
					length = math.min(length, maxLength)
					relativePosition = relativePosition.unit * length
				end
				self.stickImage.Position = UDim2.new(0, relativePosition.x + self.stickImage.AbsoluteSize.x/2, 0, relativePosition.y + self.stickImage.AbsoluteSize.y/2)
			end
	 
			-- input connections
			self.thumbstickFrame.InputBegan:Connect(function(inputObject)
				--A touch that starts elsewhere on the screen will be sent to a frame's InputBegan event
				--if it moves over the frame. So we check that this is actually a new touch (inputObject.UserInputState ~= Enum.UserInputState.Begin)
				if self.moveTouchObject or inputObject.UserInputType ~= Enum.UserInputType.Touch
					or inputObject.UserInputState ~= Enum.UserInputState.Begin then
					return
				end
	 
				self.moveTouchObject = inputObject
				self.thumbstickFrame.Position = UDim2.new(0, inputObject.Position.x - self.thumbstickFrame.Size.X.Offset/2, 0, inputObject.Position.y - self.thumbstickFrame.Size.Y.Offset/2)
				centerPosition = Vector2.new(self.thumbstickFrame.AbsolutePosition.x + self.thumbstickFrame.AbsoluteSize.x/2,
					self.thumbstickFrame.AbsolutePosition.y + self.thumbstickFrame.AbsoluteSize.y/2)
				local direction = Vector2.new(inputObject.Position.x - centerPosition.x, inputObject.Position.y - centerPosition.y)
			end)
	 
			self.onTouchMovedConn = UserInputService.TouchMoved:Connect(function(inputObject, isProcessed)
				if inputObject == self.moveTouchObject then
					centerPosition = Vector2.new(self.thumbstickFrame.AbsolutePosition.x + self.thumbstickFrame.AbsoluteSize.x/2,
						self.thumbstickFrame.AbsolutePosition.y + self.thumbstickFrame.AbsoluteSize.y/2)
					local direction = Vector2.new(inputObject.Position.x - centerPosition.x, inputObject.Position.y - centerPosition.y)
					DoMove(direction)
					MoveStick(inputObject.Position)
				end
			end)
	 
			self.onTouchEndedConn = UserInputService.TouchEnded:Connect(function(inputObject, isProcessed)
				if inputObject == self.moveTouchObject then
					self:OnInputEnded()
				end
			end)
	 
			GuiService.MenuOpened:Connect(function()
				if self.moveTouchObject then
					self:OnInputEnded()
				end
			end)	
	 
			self.thumbstickFrame.Parent = parentFrame
		end
		return TouchThumbstick
	end
	 
	function _DynamicThumbstick()
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
		local TOUCH_CONTROLS_SHEET = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	 
		local DYNAMIC_THUMBSTICK_ACTION_NAME = "DynamicThumbstickAction"
		local DYNAMIC_THUMBSTICK_ACTION_PRIORITY = Enum.ContextActionPriority.High.Value
	 
		local MIDDLE_TRANSPARENCIES = {
			1 - 0.89,
			1 - 0.70,
			1 - 0.60,
			1 - 0.50,
			1 - 0.40,
			1 - 0.30,
			1 - 0.25
		}
		local NUM_MIDDLE_IMAGES = #MIDDLE_TRANSPARENCIES
	 
		local FADE_IN_OUT_BACKGROUND = true
		local FADE_IN_OUT_MAX_ALPHA = 0.35
	 
		local FADE_IN_OUT_HALF_DURATION_DEFAULT = 0.3
		local FADE_IN_OUT_BALANCE_DEFAULT = 0.5
		local ThumbstickFadeTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	 
		local Players = game:GetService("Players")
		local GuiService = game:GetService("GuiService")
		local UserInputService = game:GetService("UserInputService")
		local ContextActionService = game:GetService("ContextActionService")
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")
	 
		local LocalPlayer = Players.LocalPlayer
		if not LocalPlayer then
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end
	 
		--[[ The Module ]]--
		local BaseCharacterController = _BaseCharacterController()
		local DynamicThumbstick = setmetatable({}, BaseCharacterController)
		DynamicThumbstick.__index = DynamicThumbstick
	 
		function DynamicThumbstick.new()
			local self = setmetatable(BaseCharacterController.new(), DynamicThumbstick)
	 
			self.moveTouchObject = nil
			self.moveTouchLockedIn = false
			self.moveTouchFirstChanged = false
			self.moveTouchStartPosition = nil
	 
			self.startImage = nil
			self.endImage = nil
			self.middleImages = {}
	 
			self.startImageFadeTween = nil
			self.endImageFadeTween = nil
			self.middleImageFadeTweens = {}
	 
			self.isFirstTouch = true
	 
			self.thumbstickFrame = nil
	 
			self.onRenderSteppedConn = nil
	 
			self.fadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT
			self.fadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
			self.hasFadedBackgroundInPortrait = false
			self.hasFadedBackgroundInLandscape = false
	 
			self.tweenInAlphaStart = nil
			self.tweenOutAlphaStart = nil
	 
			return self
		end
	 
		-- Note: Overrides base class GetIsJumping with get-and-clear behavior to do a single jump
		-- rather than sustained jumping. This is only to preserve the current behavior through the refactor.
		function DynamicThumbstick:GetIsJumping()
			local wasJumping = self.isJumping
			self.isJumping = false
			return wasJumping
		end
	 
		function DynamicThumbstick:Enable(enable, uiParentFrame)
			if enable == nil then return false end			-- If nil, return false (invalid argument)
			enable = enable and true or false				-- Force anything non-nil to boolean before comparison
			if self.enabled == enable then return true end	-- If no state change, return true indicating already in requested state
	 
			if enable then
				-- Enable
				if not self.thumbstickFrame then
					self:Create(uiParentFrame)
				end
	 
				self:BindContextActions()
			else
				ContextActionService:UnbindAction(DYNAMIC_THUMBSTICK_ACTION_NAME)
				-- Disable
				self:OnInputEnded() -- Cleanup
			end
	 
			self.enabled = enable
			self.thumbstickFrame.Visible = enable
		end
	 
		-- Was called OnMoveTouchEnded in previous version
		function DynamicThumbstick:OnInputEnded()
			self.moveTouchObject = nil
			self.moveVector = ZERO_VECTOR3
			self:FadeThumbstick(false)
		end
	 
		function DynamicThumbstick:FadeThumbstick(visible)
			if not visible and self.moveTouchObject then
				return
			end
			if self.isFirstTouch then return end
	 
			if self.startImageFadeTween then
				self.startImageFadeTween:Cancel()
			end
			if self.endImageFadeTween then
				self.endImageFadeTween:Cancel()
			end
			for i = 1, #self.middleImages do
				if self.middleImageFadeTweens[i] then
					self.middleImageFadeTweens[i]:Cancel()
				end
			end
	 
			if visible then
				self.startImageFadeTween = TweenService:Create(self.startImage, ThumbstickFadeTweenInfo, { ImageTransparency = 0 })
				self.startImageFadeTween:Play()
	 
				self.endImageFadeTween = TweenService:Create(self.endImage, ThumbstickFadeTweenInfo, { ImageTransparency = 0.2 })
				self.endImageFadeTween:Play()
	 
				for i = 1, #self.middleImages do
					self.middleImageFadeTweens[i] = TweenService:Create(self.middleImages[i], ThumbstickFadeTweenInfo, { ImageTransparency = MIDDLE_TRANSPARENCIES[i] })
					self.middleImageFadeTweens[i]:Play()
				end
			else
				self.startImageFadeTween = TweenService:Create(self.startImage, ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
				self.startImageFadeTween:Play()
	 
				self.endImageFadeTween = TweenService:Create(self.endImage, ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
				self.endImageFadeTween:Play()
	 
				for i = 1, #self.middleImages do
					self.middleImageFadeTweens[i] = TweenService:Create(self.middleImages[i], ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
					self.middleImageFadeTweens[i]:Play()
				end
			end
		end
	 
		function DynamicThumbstick:FadeThumbstickFrame(fadeDuration, fadeRatio)
			self.fadeInAndOutHalfDuration = fadeDuration * 0.5
			self.fadeInAndOutBalance = fadeRatio
			self.tweenInAlphaStart = tick()
		end
	 
		function DynamicThumbstick:InputInFrame(inputObject)
			local frameCornerTopLeft = self.thumbstickFrame.AbsolutePosition
			local frameCornerBottomRight = frameCornerTopLeft + self.thumbstickFrame.AbsoluteSize
			local inputPosition = inputObject.Position
			if inputPosition.X >= frameCornerTopLeft.X and inputPosition.Y >= frameCornerTopLeft.Y then
				if inputPosition.X <= frameCornerBottomRight.X and inputPosition.Y <= frameCornerBottomRight.Y then
					return true
				end
			end
			return false
		end
	 
		function DynamicThumbstick:DoFadeInBackground()
			local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local hasFadedBackgroundInOrientation = false
	 
			-- only fade in/out the background once per orientation
			if playerGui then
				if playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or
					playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
						hasFadedBackgroundInOrientation = self.hasFadedBackgroundInLandscape
						self.hasFadedBackgroundInLandscape = true
				elseif playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
						hasFadedBackgroundInOrientation = self.hasFadedBackgroundInPortrait
						self.hasFadedBackgroundInPortrait = true
				end
			end
	 
			if not hasFadedBackgroundInOrientation then
				self.fadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
				self.fadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT
				self.tweenInAlphaStart = tick()
			end
		end
	 
		function DynamicThumbstick:DoMove(direction)
			local currentMoveVector = direction
	 
			-- Scaled Radial Dead Zone
			local inputAxisMagnitude = currentMoveVector.magnitude
			if inputAxisMagnitude < self.radiusOfDeadZone then
				currentMoveVector = ZERO_VECTOR3
			else
				currentMoveVector = currentMoveVector.unit*(
					1 - math.max(0, (self.radiusOfMaxSpeed - currentMoveVector.magnitude)/self.radiusOfMaxSpeed)
				)
				currentMoveVector = Vector3.new(currentMoveVector.x, 0, currentMoveVector.y)
			end
	 
			self.moveVector = currentMoveVector
		end
	 
	 
		function DynamicThumbstick:LayoutMiddleImages(startPos, endPos)
			local startDist = (self.thumbstickSize / 2) + self.middleSize
			local vector = endPos - startPos
			local distAvailable = vector.magnitude - (self.thumbstickRingSize / 2) - self.middleSize
			local direction = vector.unit
	 
			local distNeeded = self.middleSpacing * NUM_MIDDLE_IMAGES
			local spacing = self.middleSpacing
	 
			if distNeeded < distAvailable then
				spacing = distAvailable / NUM_MIDDLE_IMAGES
			end
	 
			for i = 1, NUM_MIDDLE_IMAGES do
				local image = self.middleImages[i]
				local distWithout = startDist + (spacing * (i - 2))
				local currentDist = startDist + (spacing * (i - 1))
	 
				if distWithout < distAvailable then
					local pos = endPos - direction * currentDist
					local exposedFraction = math.clamp(1 - ((currentDist - distAvailable) / spacing), 0, 1)
	 
					image.Visible = true
					image.Position = UDim2.new(0, pos.X, 0, pos.Y)
					image.Size = UDim2.new(0, self.middleSize * exposedFraction, 0, self.middleSize * exposedFraction)
				else
					image.Visible = false
				end
			end
		end
	 
		function DynamicThumbstick:MoveStick(pos)
			local vector2StartPosition = Vector2.new(self.moveTouchStartPosition.X, self.moveTouchStartPosition.Y)
			local startPos = vector2StartPosition - self.thumbstickFrame.AbsolutePosition
			local endPos = Vector2.new(pos.X, pos.Y) - self.thumbstickFrame.AbsolutePosition
			self.endImage.Position = UDim2.new(0, endPos.X, 0, endPos.Y)
			self:LayoutMiddleImages(startPos, endPos)
		end
	 
		function DynamicThumbstick:BindContextActions()
			local function inputBegan(inputObject)
				if self.moveTouchObject then
					return Enum.ContextActionResult.Pass
				end
	 
				if not self:InputInFrame(inputObject) then
					return Enum.ContextActionResult.Pass
				end
	 
				if self.isFirstTouch then
					self.isFirstTouch = false
					local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0,false,0)
					TweenService:Create(self.startImage, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
					TweenService:Create(
						self.endImage,
						tweenInfo,
						{Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize), ImageColor3 = Color3.new(0,0,0)}
					):Play()
				end
	 
				self.moveTouchLockedIn = false
				self.moveTouchObject = inputObject
				self.moveTouchStartPosition = inputObject.Position
				self.moveTouchFirstChanged = true
	 
				if FADE_IN_OUT_BACKGROUND then
					self:DoFadeInBackground()
				end
	 
				return Enum.ContextActionResult.Pass
			end
	 
			local function inputChanged(inputObject)
				if inputObject == self.moveTouchObject then
					if self.moveTouchFirstChanged then
						self.moveTouchFirstChanged = false
	 
						local startPosVec2 = Vector2.new(
							inputObject.Position.X - self.thumbstickFrame.AbsolutePosition.X,
							inputObject.Position.Y - self.thumbstickFrame.AbsolutePosition.Y
						)
						self.startImage.Visible = true
						self.startImage.Position = UDim2.new(0, startPosVec2.X, 0, startPosVec2.Y)
						self.endImage.Visible = true
						self.endImage.Position = self.startImage.Position
	 
						self:FadeThumbstick(true)
						self:MoveStick(inputObject.Position)
					end
	 
					self.moveTouchLockedIn = true
	 
					local direction = Vector2.new(
						inputObject.Position.x - self.moveTouchStartPosition.x,
						inputObject.Position.y - self.moveTouchStartPosition.y
					)
					if math.abs(direction.x) > 0 or math.abs(direction.y) > 0 then
						self:DoMove(direction)
						self:MoveStick(inputObject.Position)
					end
					return Enum.ContextActionResult.Sink
				end
				return Enum.ContextActionResult.Pass
			end
	 
			local function inputEnded(inputObject)
				if inputObject == self.moveTouchObject then
					self:OnInputEnded()
					if self.moveTouchLockedIn then
						return Enum.ContextActionResult.Sink
					end
				end
				return Enum.ContextActionResult.Pass
			end
	 
			local function handleInput(actionName, inputState, inputObject)
				if inputState == Enum.UserInputState.Begin then
					return inputBegan(inputObject)
				elseif inputState == Enum.UserInputState.Change then
					return inputChanged(inputObject)
				elseif inputState == Enum.UserInputState.End then
					return inputEnded(inputObject)
				elseif inputState == Enum.UserInputState.Cancel then
					self:OnInputEnded()
				end
			end
	 
			ContextActionService:BindActionAtPriority(
				DYNAMIC_THUMBSTICK_ACTION_NAME,
				handleInput,
				false,
				DYNAMIC_THUMBSTICK_ACTION_PRIORITY,
				Enum.UserInputType.Touch)
		end
	 
		function DynamicThumbstick:Create(parentFrame)
			if self.thumbstickFrame then
				self.thumbstickFrame:Destroy()
				self.thumbstickFrame = nil
				if self.onRenderSteppedConn then
					self.onRenderSteppedConn:Disconnect()
					self.onRenderSteppedConn = nil
				end
			end
	 
			self.thumbstickSize = 45
			self.thumbstickRingSize = 20
			self.middleSize = 10
			self.middleSpacing = self.middleSize + 4
			self.radiusOfDeadZone = 2
			self.radiusOfMaxSpeed = 20
	 
			local screenSize = parentFrame.AbsoluteSize
			local isBigScreen = math.min(screenSize.x, screenSize.y) > 500
			if isBigScreen then
				self.thumbstickSize = self.thumbstickSize * 2
				self.thumbstickRingSize = self.thumbstickRingSize * 2
				self.middleSize = self.middleSize * 2
				self.middleSpacing = self.middleSpacing * 2
				self.radiusOfDeadZone = self.radiusOfDeadZone * 2
				self.radiusOfMaxSpeed = self.radiusOfMaxSpeed * 2
			end
	 
			local function layoutThumbstickFrame(portraitMode)
				if portraitMode then
					self.thumbstickFrame.Size = UDim2.new(1, 0, 0.4, 0)
					self.thumbstickFrame.Position = UDim2.new(0, 0, 0.6, 0)
				else
					self.thumbstickFrame.Size = UDim2.new(0.4, 0, 2/3, 0)
					self.thumbstickFrame.Position = UDim2.new(0, 0, 1/3, 0)
				end
			end
	 
			self.thumbstickFrame = Instance.new("Frame")
			self.thumbstickFrame.BorderSizePixel = 0
			self.thumbstickFrame.Name = "DynamicThumbstickFrame"
			self.thumbstickFrame.Visible = false
			self.thumbstickFrame.BackgroundTransparency = 1.0
			self.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			self.thumbstickFrame.Active = false
			layoutThumbstickFrame(false)
	 
			self.startImage = Instance.new("ImageLabel")
			self.startImage.Name = "ThumbstickStart"
			self.startImage.Visible = true
			self.startImage.BackgroundTransparency = 1
			self.startImage.Image = TOUCH_CONTROLS_SHEET
			self.startImage.ImageRectOffset = Vector2.new(1,1)
			self.startImage.ImageRectSize = Vector2.new(144, 144)
			self.startImage.ImageColor3 = Color3.new(0, 0, 0)
			self.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
			self.startImage.Position = UDim2.new(0, self.thumbstickRingSize * 3.3, 1, -self.thumbstickRingSize  * 2.8)
			self.startImage.Size = UDim2.new(0, self.thumbstickRingSize  * 3.7, 0, self.thumbstickRingSize  * 3.7)
			self.startImage.ZIndex = 10
			self.startImage.Parent = self.thumbstickFrame
	 
			self.endImage = Instance.new("ImageLabel")
			self.endImage.Name = "ThumbstickEnd"
			self.endImage.Visible = true
			self.endImage.BackgroundTransparency = 1
			self.endImage.Image = TOUCH_CONTROLS_SHEET
			self.endImage.ImageRectOffset = Vector2.new(1,1)
			self.endImage.ImageRectSize =  Vector2.new(144, 144)
			self.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
			self.endImage.Position = self.startImage.Position
			self.endImage.Size = UDim2.new(0, self.thumbstickSize * 0.8, 0, self.thumbstickSize * 0.8)
			self.endImage.ZIndex = 10
			self.endImage.Parent = self.thumbstickFrame
	 
			for i = 1, NUM_MIDDLE_IMAGES do
				self.middleImages[i] = Instance.new("ImageLabel")
				self.middleImages[i].Name = "ThumbstickMiddle"
				self.middleImages[i].Visible = false
				self.middleImages[i].BackgroundTransparency = 1
				self.middleImages[i].Image = TOUCH_CONTROLS_SHEET
				self.middleImages[i].ImageRectOffset = Vector2.new(1,1)
				self.middleImages[i].ImageRectSize = Vector2.new(144, 144)
				self.middleImages[i].ImageTransparency = MIDDLE_TRANSPARENCIES[i]
				self.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
				self.middleImages[i].ZIndex = 9
				self.middleImages[i].Parent = self.thumbstickFrame
			end
	 
			local CameraChangedConn = nil
			local function onCurrentCameraChanged()
				if CameraChangedConn then
					CameraChangedConn:Disconnect()
					CameraChangedConn = nil
				end
				local newCamera = workspace.CurrentCamera
				if newCamera then
					local function onViewportSizeChanged()
						local size = newCamera.ViewportSize
						local portraitMode = size.X < size.Y
						layoutThumbstickFrame(portraitMode)
					end
					CameraChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)
					onViewportSizeChanged()
				end
			end
			workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
			if workspace.CurrentCamera then
				onCurrentCameraChanged()
			end
	 
			self.moveTouchStartPosition = nil
	 
			self.startImageFadeTween = nil
			self.endImageFadeTween = nil
			self.middleImageFadeTweens = {}
	 
			self.onRenderSteppedConn = RunService.RenderStepped:Connect(function()
				if self.tweenInAlphaStart ~= nil then
					local delta = tick() - self.tweenInAlphaStart
					local fadeInTime = (self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance)
					self.thumbstickFrame.BackgroundTransparency = 1 - FADE_IN_OUT_MAX_ALPHA*math.min(delta/fadeInTime, 1)
					if delta > fadeInTime then
						self.tweenOutAlphaStart = tick()
						self.tweenInAlphaStart = nil
					end
				elseif self.tweenOutAlphaStart ~= nil then
					local delta = tick() - self.tweenOutAlphaStart
					local fadeOutTime = (self.fadeInAndOutHalfDuration * 2) - (self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance)
					self.thumbstickFrame.BackgroundTransparency = 1 - FADE_IN_OUT_MAX_ALPHA + FADE_IN_OUT_MAX_ALPHA*math.min(delta/fadeOutTime, 1)
					if delta > fadeOutTime  then
						self.tweenOutAlphaStart = nil
					end
				end
			end)
	 
			self.onTouchEndedConn = UserInputService.TouchEnded:connect(function(inputObject)
				if inputObject == self.moveTouchObject then
					self:OnInputEnded()
				end
			end)
	 
			GuiService.MenuOpened:connect(function()
				if self.moveTouchObject then
					self:OnInputEnded()
				end
			end)
	 
			local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			while not playerGui do
				LocalPlayer.ChildAdded:wait()
				playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			end
	 
			local playerGuiChangedConn = nil
			local originalScreenOrientationWasLandscape =	playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or
															playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
	 
			local function longShowBackground()
				self.fadeInAndOutHalfDuration = 2.5
				self.fadeInAndOutBalance = 0.05
				self.tweenInAlphaStart = tick()
			end
	 
			playerGuiChangedConn = playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
				if (originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) or
					(not originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) then
	 
					playerGuiChangedConn:disconnect()
					longShowBackground()
	 
					if originalScreenOrientationWasLandscape then
						self.hasFadedBackgroundInPortrait = true
					else
						self.hasFadedBackgroundInLandscape = true
					end
				end
			end)
	 
			self.thumbstickFrame.Parent = parentFrame
	 
			if game:IsLoaded() then
				longShowBackground()
			else
				coroutine.wrap(function()
					game.Loaded:Wait()
					longShowBackground()
				end)()
			end
		end
	 
		return DynamicThumbstick
	end
	 
	function _Gamepad()
		local UserInputService = game:GetService("UserInputService")
		local ContextActionService = game:GetService("ContextActionService")
	 
		--[[ Constants ]]--
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
		local NONE = Enum.UserInputType.None
		local thumbstickDeadzone = 0.2
	 
		--[[ The Module ]]--
		local BaseCharacterController = _BaseCharacterController()
		local Gamepad = setmetatable({}, BaseCharacterController)
		Gamepad.__index = Gamepad
	 
		function Gamepad.new(CONTROL_ACTION_PRIORITY)
			local self = setmetatable(BaseCharacterController.new(), Gamepad)
	 
			self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY
	 
			self.forwardValue  = 0
			self.backwardValue = 0
			self.leftValue = 0
			self.rightValue = 0
	 
			self.activeGamepad = NONE	-- Enum.UserInputType.Gamepad1, 2, 3...
			self.gamepadConnectedConn = nil
			self.gamepadDisconnectedConn = nil
			return self
		end
	 
		function Gamepad:Enable(enable)
			if not UserInputService.GamepadEnabled then
				return false
			end
	 
			if enable == self.enabled then
				-- Module is already in the state being requested. True is returned here since the module will be in the state
				-- expected by the code that follows the Enable() call. This makes more sense than returning false to indicate
				-- no action was necessary. False indicates failure to be in requested/expected state.
				return true
			end
	 
			self.forwardValue  = 0
			self.backwardValue = 0
			self.leftValue = 0
			self.rightValue = 0
			self.moveVector = ZERO_VECTOR3
			self.isJumping = false
	 
			if enable then
				self.activeGamepad = self:GetHighestPriorityGamepad()
				if self.activeGamepad ~= NONE then
					self:BindContextActions()
					self:ConnectGamepadConnectionListeners()
				else
					-- No connected gamepads, failure to enable
					return false
				end
			else
				self:UnbindContextActions()
				self:DisconnectGamepadConnectionListeners()
				self.activeGamepad = NONE
			end
	 
			self.enabled = enable
			return true
		end
	 
		-- This function selects the lowest number gamepad from the currently-connected gamepad
		-- and sets it as the active gamepad
		function Gamepad:GetHighestPriorityGamepad()
			local connectedGamepads = UserInputService:GetConnectedGamepads()
			local bestGamepad = NONE -- Note that this value is higher than all valid gamepad values
			for _, gamepad in pairs(connectedGamepads) do
				if gamepad.Value < bestGamepad.Value then
					bestGamepad = gamepad
				end
			end
			return bestGamepad
		end
	 
		function Gamepad:BindContextActions()
	 
			if self.activeGamepad == NONE then
				-- There must be an active gamepad to set up bindings
				return false
			end
	 
			local handleJumpAction = function(actionName, inputState, inputObject)
				self.isJumping = (inputState == Enum.UserInputState.Begin)
				return Enum.ContextActionResult.Sink
			end
	 
			local handleThumbstickInput = function(actionName, inputState, inputObject)
	 
				if inputState == Enum.UserInputState.Cancel then
					self.moveVector = ZERO_VECTOR3
					return Enum.ContextActionResult.Sink
				end
	 
				if self.activeGamepad ~= inputObject.UserInputType then
					return Enum.ContextActionResult.Pass
				end
				if inputObject.KeyCode ~= Enum.KeyCode.Thumbstick1 then return end
	 
				if inputObject.Position.magnitude > thumbstickDeadzone then
					self.moveVector  =  Vector3.new(inputObject.Position.X, 0, -inputObject.Position.Y)
				else
					self.moveVector = ZERO_VECTOR3
				end
				return Enum.ContextActionResult.Sink
			end
	 
			ContextActionService:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
			ContextActionService:BindActionAtPriority("jumpAction", handleJumpAction, false,
				self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
			ContextActionService:BindActionAtPriority("moveThumbstick", handleThumbstickInput, false,
				self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
	 
			return true
		end
	 
		function Gamepad:UnbindContextActions()
			if self.activeGamepad ~= NONE then
				ContextActionService:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
			end
			ContextActionService:UnbindAction("moveThumbstick")
			ContextActionService:UnbindAction("jumpAction")
		end
	 
		function Gamepad:OnNewGamepadConnected()
			-- A new gamepad has been connected.
			local bestGamepad = self:GetHighestPriorityGamepad()
	 
			if bestGamepad == self.activeGamepad then
				-- A new gamepad was connected, but our active gamepad is not changing
				return
			end
	 
			if bestGamepad == NONE then
				-- There should be an active gamepad when GamepadConnected fires, so this should not
				-- normally be hit. If there is no active gamepad, unbind actions but leave
				-- the module enabled and continue to listen for a new gamepad connection.
				warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
				self:UnbindContextActions()
				return
			end
	 
			if self.activeGamepad ~= NONE then
				-- Switching from one active gamepad to another
				self:UnbindContextActions()
			end
	 
			self.activeGamepad = bestGamepad
			self:BindContextActions()
		end
	 
		function Gamepad:OnCurrentGamepadDisconnected()
			if self.activeGamepad ~= NONE then
				ContextActionService:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
			end
	 
			local bestGamepad = self:GetHighestPriorityGamepad()
	 
			if self.activeGamepad ~= NONE and bestGamepad == self.activeGamepad then
				warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
				self:UnbindContextActions()
				self.activeGamepad = NONE
				return
			end
	 
			if bestGamepad == NONE then
				-- No active gamepad, unbinding actions but leaving gamepad connection listener active
				self:UnbindContextActions()
				self.activeGamepad = NONE
			else
				-- Set new gamepad as active and bind to tool activation
				self.activeGamepad = bestGamepad
				ContextActionService:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
			end
		end
	 
		function Gamepad:ConnectGamepadConnectionListeners()
			self.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(gamepadEnum)
				self:OnNewGamepadConnected()
			end)
	 
			self.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(gamepadEnum)
				if self.activeGamepad == gamepadEnum then
					self:OnCurrentGamepadDisconnected()
				end
			end)
	 
		end
	 
		function Gamepad:DisconnectGamepadConnectionListeners()
			if self.gamepadConnectedConn then
				self.gamepadConnectedConn:Disconnect()
				self.gamepadConnectedConn = nil
			end
	 
			if self.gamepadDisconnectedConn then
				self.gamepadDisconnectedConn:Disconnect()
				self.gamepadDisconnectedConn = nil
			end
		end
	 
		return Gamepad
	end
	 
	function _Keyboard()
	 
		--[[ Roblox Services ]]--
		local UserInputService = game:GetService("UserInputService")
		local ContextActionService = game:GetService("ContextActionService")
	 
		--[[ Constants ]]--
		local ZERO_VECTOR3 = Vector3.new(0,0,0)
	 
		--[[ The Module ]]--
		local BaseCharacterController = _BaseCharacterController()
		local Keyboard = setmetatable({}, BaseCharacterController)
		Keyboard.__index = Keyboard
	 
		function Keyboard.new(CONTROL_ACTION_PRIORITY)
			local self = setmetatable(BaseCharacterController.new(), Keyboard)
	 
			self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY
	 
			self.textFocusReleasedConn = nil
			self.textFocusGainedConn = nil
			self.windowFocusReleasedConn = nil
	 
			self.forwardValue  = 0
			self.backwardValue = 0
			self.leftValue = 0
			self.rightValue = 0
	 
			self.jumpEnabled = true
	 
			return self
		end
	 
		function Keyboard:Enable(enable)
			if not UserInputService.KeyboardEnabled then
				return false
			end
	 
			if enable == self.enabled then
				-- Module is already in the state being requested. True is returned here since the module will be in the state
				-- expected by the code that follows the Enable() call. This makes more sense than returning false to indicate
				-- no action was necessary. False indicates failure to be in requested/expected state.
				return true
			end
	 
			self.forwardValue  = 0
			self.backwardValue = 0
			self.leftValue = 0
			self.rightValue = 0
			self.moveVector = ZERO_VECTOR3
			self.jumpRequested = false
			self:UpdateJump()
	 
			if enable then
				self:BindContextActions()
				self:ConnectFocusEventListeners()
			else
				self:UnbindContextActions()
				self:DisconnectFocusEventListeners()
			end
	 
			self.enabled = enable
			return true
		end
	 
		function Keyboard:UpdateMovement(inputState)
			if inputState == Enum.UserInputState.Cancel then
				self.moveVector = ZERO_VECTOR3
			else
				self.moveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
			end
		end
	 
		function Keyboard:UpdateJump()
			self.isJumping = self.jumpRequested
		end
	 
		function Keyboard:BindContextActions()
	 
			-- Note: In the previous version of this code, the movement values were not zeroed-out on UserInputState. Cancel, now they are,
			-- which fixes them from getting stuck on.
			-- We return ContextActionResult.Pass here for legacy reasons.
			-- Many games rely on gameProcessedEvent being false on UserInputService.InputBegan for these control actions.
			local handleMoveForward = function(actionName, inputState, inputObject)
				self.forwardValue = (inputState == Enum.UserInputState.Begin) and -1 or 0
				self:UpdateMovement(inputState)
				return Enum.ContextActionResult.Pass
			end
	 
			local handleMoveBackward = function(actionName, inputState, inputObject)
				self.backwardValue = (inputState == Enum.UserInputState.Begin) and 1 or 0
				self:UpdateMovement(inputState)
				return Enum.ContextActionResult.Pass
			end
	 
			local handleMoveLeft = function(actionName, inputState, inputObject)
				self.leftValue = (inputState == Enum.UserInputState.Begin) and -1 or 0
				self:UpdateMovement(inputState)
				return Enum.ContextActionResult.Pass
			end
	 
			local handleMoveRight = function(actionName, inputState, inputObject)
				self.rightValue = (inputState == Enum.UserInputState.Begin) and 1 or 0
				self:UpdateMovement(inputState)
				return Enum.ContextActionResult.Pass
			end
	 
			local handleJumpAction = function(actionName, inputState, inputObject)
				self.jumpRequested = self.jumpEnabled and (inputState == Enum.UserInputState.Begin)
				self:UpdateJump()
				return Enum.ContextActionResult.Pass
			end
	 
			-- TODO: Revert to KeyCode bindings so that in the future the abstraction layer from actual keys to
			-- movement direction is done in Lua
			ContextActionService:BindActionAtPriority("moveForwardAction", handleMoveForward, false,
				self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward)
			ContextActionService:BindActionAtPriority("moveBackwardAction", handleMoveBackward, false,
				self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward)
			ContextActionService:BindActionAtPriority("moveLeftAction", handleMoveLeft, false,
				self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft)
			ContextActionService:BindActionAtPriority("moveRightAction", handleMoveRight, false,
				self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight)
			ContextActionService:BindActionAtPriority("jumpAction", handleJumpAction, false,
				self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump)
		end
	 
		function Keyboard:UnbindContextActions()
			ContextActionService:UnbindAction("moveForwardAction")
			ContextActionService:UnbindAction("moveBackwardAction")
			ContextActionService:UnbindAction("moveLeftAction")
			ContextActionService:UnbindAction("moveRightAction")
			ContextActionService:UnbindAction("jumpAction")
		end
	 
		function Keyboard:ConnectFocusEventListeners()
			local function onFocusReleased()
				self.moveVector = ZERO_VECTOR3
				self.forwardValue  = 0
				self.backwardValue = 0
				self.leftValue = 0
				self.rightValue = 0
				self.jumpRequested = false
				self:UpdateJump()
			end
	 
			local function onTextFocusGained(textboxFocused)
				self.jumpRequested = false
				self:UpdateJump()
			end
	 
			self.textFocusReleasedConn = UserInputService.TextBoxFocusReleased:Connect(onFocusReleased)
			self.textFocusGainedConn = UserInputService.TextBoxFocused:Connect(onTextFocusGained)
			self.windowFocusReleasedConn = UserInputService.WindowFocused:Connect(onFocusReleased)
		end
	 
		function Keyboard:DisconnectFocusEventListeners()
			if self.textFocusReleasedCon then
				self.textFocusReleasedCon:Disconnect()
				self.textFocusReleasedCon = nil
			end
			if self.textFocusGainedConn then
				self.textFocusGainedConn:Disconnect()
				self.textFocusGainedConn = nil
			end
			if self.windowFocusReleasedConn then
				self.windowFocusReleasedConn:Disconnect()
				self.windowFocusReleasedConn = nil
			end
		end
	 
		return Keyboard
	end
	 
	function _ControlModule()
		local ControlModule = {}
		ControlModule.__index = ControlModule
	 
		--[[ Roblox Services ]]--
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local Workspace = game:GetService("Workspace")
		local UserGameSettings = UserSettings():GetService("UserGameSettings")
	 
		-- Roblox User Input Control Modules - each returns a new() constructor function used to create controllers as needed
		local Keyboard = _Keyboard()
		local Gamepad = _Gamepad()
		local DynamicThumbstick = _DynamicThumbstick()
	 
		local FFlagUserMakeThumbstickDynamic do
			local success, value = pcall(function()
				return UserSettings():IsUserFeatureEnabled("UserMakeThumbstickDynamic")
			end)
			FFlagUserMakeThumbstickDynamic = success and value
		end
	 
		local TouchThumbstick = FFlagUserMakeThumbstickDynamic and DynamicThumbstick or _TouchThumbstick()
	 
		-- These controllers handle only walk/run movement, jumping is handled by the
		-- TouchJump controller if any of these are active
		local ClickToMove = _ClickToMoveController()
		local TouchJump = _TouchJump()
	 
		local VehicleController = _VehicleController()
	 
		local CONTROL_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
	 
		-- Mapping from movement mode and lastInputType enum values to control modules to avoid huge if elseif switching
		local movementEnumToModuleMap = {
			[Enum.TouchMovementMode.DPad] = DynamicThumbstick,
			[Enum.DevTouchMovementMode.DPad] = DynamicThumbstick,
			[Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick,
			[Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick,
			[Enum.TouchMovementMode.Thumbstick] = TouchThumbstick,
			[Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick,
			[Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
			[Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
			[Enum.TouchMovementMode.ClickToMove] = ClickToMove,
			[Enum.DevTouchMovementMode.ClickToMove] = ClickToMove,
	 
			-- Current default
			[Enum.TouchMovementMode.Default] = DynamicThumbstick,
	 
			[Enum.ComputerMovementMode.Default] = Keyboard,
			[Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
			[Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard,
			[Enum.DevComputerMovementMode.Scriptable] = nil,
			[Enum.ComputerMovementMode.ClickToMove] = ClickToMove,
			[Enum.DevComputerMovementMode.ClickToMove] = ClickToMove,
		}
	 
		-- Keyboard controller is really keyboard and mouse controller
		local computerInputTypeToModuleMap = {
			[Enum.UserInputType.Keyboard] = Keyboard,
			[Enum.UserInputType.MouseButton1] = Keyboard,
			[Enum.UserInputType.MouseButton2] = Keyboard,
			[Enum.UserInputType.MouseButton3] = Keyboard,
			[Enum.UserInputType.MouseWheel] = Keyboard,
			[Enum.UserInputType.MouseMovement] = Keyboard,
			[Enum.UserInputType.Gamepad1] = Gamepad,
			[Enum.UserInputType.Gamepad2] = Gamepad,
			[Enum.UserInputType.Gamepad3] = Gamepad,
			[Enum.UserInputType.Gamepad4] = Gamepad,
		}
	 
		local lastInputType
	 
		function ControlModule.new()
			local self = setmetatable({},ControlModule)
	 
			-- The Modules above are used to construct controller instances as-needed, and this
			-- table is a map from Module to the instance created from it
			self.controllers = {}
	 
			self.activeControlModule = nil	-- Used to prevent unnecessarily expensive checks on each input event
			self.activeController = nil
			self.touchJumpController = nil
			self.moveFunction = Players.LocalPlayer.Move
			self.humanoid = nil
			self.lastInputType = Enum.UserInputType.None
	 
			-- For Roblox self.vehicleController
			self.humanoidSeatedConn = nil
			self.vehicleController = nil
	 
			self.touchControlFrame = nil
	 
			self.vehicleController = VehicleController.new(CONTROL_ACTION_PRIORITY)
	 
			Players.LocalPlayer.CharacterAdded:Connect(function(char) self:OnCharacterAdded(char) end)
			Players.LocalPlayer.CharacterRemoving:Connect(function(char) self:OnCharacterRemoving(char) end)
			if Players.LocalPlayer.Character then
				self:OnCharacterAdded(Players.LocalPlayer.Character)
			end
	 
			RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(dt)
				self:OnRenderStepped(dt)
			end)
	 
			UserInputService.LastInputTypeChanged:Connect(function(newLastInputType)
				self:OnLastInputTypeChanged(newLastInputType)
			end)
	 
	 
			UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
				self:OnTouchMovementModeChange()
			end)
			Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
				self:OnTouchMovementModeChange()
			end)
	 
			UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function()
				self:OnComputerMovementModeChange()
			end)
			Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
				self:OnComputerMovementModeChange()
			end)
	 
			--[[ Touch Device UI ]]--
			self.playerGui = nil
			self.touchGui = nil
			self.playerGuiAddedConn = nil
	 
			if UserInputService.TouchEnabled then
				self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
				if self.playerGui then
					self:CreateTouchGuiContainer()
					self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
				else
					self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(child)
						if child:IsA("PlayerGui") then
							self.playerGui = child
							self:CreateTouchGuiContainer()
							self.playerGuiAddedConn:Disconnect()
							self.playerGuiAddedConn = nil
							self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
						end
					end)
				end
			else
				self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
			end
	 
			return self
		end
	 
		-- Convenience function so that calling code does not have to first get the activeController
		-- and then call GetMoveVector on it. When there is no active controller, this function returns
		-- nil so that this case can be distinguished from no current movement (which returns zero vector).
		function ControlModule:GetMoveVector()
			if self.activeController then
				return self.activeController:GetMoveVector()
			end
			return Vector3.new(0,0,0)
		end
	 
		function ControlModule:GetActiveController()
			return self.activeController
		end
	 
		function ControlModule:EnableActiveControlModule()
			if self.activeControlModule == ClickToMove then
				-- For ClickToMove, when it is the player's choice, we also enable the full keyboard controls.
				-- When the developer is forcing click to move, the most keyboard controls (WASD) are not available, only jump.
				self.activeController:Enable(
					true,
					Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice,
					self.touchJumpController
				)
			elseif self.touchControlFrame then
				self.activeController:Enable(true, self.touchControlFrame)
			else
				self.activeController:Enable(true)
			end
		end
	 
		function ControlModule:Enable(enable)
			if not self.activeController then
				return
			end
	 
			if enable == nil then
				enable = true
			end
			if enable then
				self:EnableActiveControlModule()
			else
				self:Disable()
			end
		end
	 
		-- For those who prefer distinct functions
		function ControlModule:Disable()
			if self.activeController then
				self.activeController:Enable(false)
	 
				if self.moveFunction then
					self.moveFunction(Players.LocalPlayer, Vector3.new(0,0,0), true)
				end
			end
		end
	 
	 
		-- Returns module (possibly nil) and success code to differentiate returning nil due to error vs Scriptable
		function ControlModule:SelectComputerMovementModule()
			if not (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled) then
				return nil, false
			end
	 
			local computerModule
			local DevMovementMode = Players.LocalPlayer.DevComputerMovementMode
	 
			if DevMovementMode == Enum.DevComputerMovementMode.UserChoice then
				computerModule = computerInputTypeToModuleMap[lastInputType]
				if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and computerModule == Keyboard then
					-- User has ClickToMove set in Settings, prefer ClickToMove controller for keyboard and mouse lastInputTypes
					computerModule = ClickToMove
				end
			else
				-- Developer has selected a mode that must be used.
				computerModule = movementEnumToModuleMap[DevMovementMode]
	 
				-- computerModule is expected to be nil here only when developer has selected Scriptable
				if (not computerModule) and DevMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
					warn("No character control module is associated with DevComputerMovementMode ", DevMovementMode)
				end
			end
	 
			if computerModule then
				return computerModule, true
			elseif DevMovementMode == Enum.DevComputerMovementMode.Scriptable then
				-- Special case where nil is returned and we actually want to set self.activeController to nil for Scriptable
				return nil, true
			else
				-- This case is for when computerModule is nil because of an error and no suitable control module could
				-- be found.
				return nil, false
			end
		end
	 
		-- Choose current Touch control module based on settings (user, dev)
		-- Returns module (possibly nil) and success code to differentiate returning nil due to error vs Scriptable
		function ControlModule:SelectTouchModule()
			if not UserInputService.TouchEnabled then
				return nil, false
			end
			local touchModule
			local DevMovementMode = Players.LocalPlayer.DevTouchMovementMode
			if DevMovementMode == Enum.DevTouchMovementMode.UserChoice then
				touchModule = movementEnumToModuleMap[UserGameSettings.TouchMovementMode]
			elseif DevMovementMode == Enum.DevTouchMovementMode.Scriptable then
				return nil, true
			else
				touchModule = movementEnumToModuleMap[DevMovementMode]
			end
			return touchModule, true
		end
	 
		local function calculateRawMoveVector(humanoid, cameraRelativeMoveVector)
			local camera = Workspace.CurrentCamera
			if not camera then
				return cameraRelativeMoveVector
			end
	 
			if humanoid:GetState() == Enum.HumanoidStateType.Swimming then
				return camera.CFrame:VectorToWorldSpace(cameraRelativeMoveVector)
			end
	 
			local c, s
			local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = camera.CFrame:GetComponents()
			if R12 < 1 and R12 > -1 then
				-- X and Z components from back vector.
				c = R22
				s = R02
			else
				-- In this case the camera is looking straight up or straight down.
				-- Use X components from right and up vectors.
				c = R00
				s = -R01*math.sign(R12)
			end
			local norm = math.sqrt(c*c + s*s)
			return Vector3.new(
				(c*cameraRelativeMoveVector.x + s*cameraRelativeMoveVector.z)/norm,
				0,
				(c*cameraRelativeMoveVector.z - s*cameraRelativeMoveVector.x)/norm
			)
		end
	 
		function ControlModule:OnRenderStepped(dt)
			if self.activeController and self.activeController.enabled and self.humanoid then
				-- Give the controller a chance to adjust its state
				self.activeController:OnRenderStepped(dt)
	 
				-- Now retrieve info from the controller
				local moveVector = self.activeController:GetMoveVector()
				local cameraRelative = self.activeController:IsMoveVectorCameraRelative()
	 
				local clickToMoveController = self:GetClickToMoveController()
				if self.activeController ~= clickToMoveController then
					if moveVector.magnitude > 0 then
						-- Clean up any developer started MoveTo path
						clickToMoveController:CleanupPath()
					else
						-- Get move vector for developer started MoveTo
						clickToMoveController:OnRenderStepped(dt)
						moveVector = clickToMoveController:GetMoveVector()
						cameraRelative = clickToMoveController:IsMoveVectorCameraRelative()
					end
				end
	 
				-- Are we driving a vehicle ?
				local vehicleConsumedInput = false
				if self.vehicleController then
					moveVector, vehicleConsumedInput = self.vehicleController:Update(moveVector, cameraRelative, self.activeControlModule==Gamepad)
				end
	 
				-- If not, move the player
				-- Verification of vehicleConsumedInput is commented out to preserve legacy behavior,
				-- in case some game relies on Humanoid.MoveDirection still being set while in a VehicleSeat
				--if not vehicleConsumedInput then
					if cameraRelative then
						moveVector = calculateRawMoveVector(self.humanoid, moveVector)
					end
					self.moveFunction(Players.LocalPlayer, moveVector, false)
				--end
	 
				-- And make them jump if needed
				self.humanoid.Jump = self.activeController:GetIsJumping() or (self.touchJumpController and self.touchJumpController:GetIsJumping())
			end
		end
	 
		function ControlModule:OnHumanoidSeated(active, currentSeatPart)
			if active then
				if currentSeatPart and currentSeatPart:IsA("VehicleSeat") then
					if not self.vehicleController then
						self.vehicleController = self.vehicleController.new(CONTROL_ACTION_PRIORITY)
					end
					self.vehicleController:Enable(true, currentSeatPart)
				end
			else
				if self.vehicleController then
					self.vehicleController:Enable(false, currentSeatPart)
				end
			end
		end
	 
		function ControlModule:OnCharacterAdded(char)
			self.humanoid = char:FindFirstChildOfClass("Humanoid")
			while not self.humanoid do
				char.ChildAdded:wait()
				self.humanoid = char:FindFirstChildOfClass("Humanoid")
			end
	 
			if self.touchGui then
				self.touchGui.Enabled = true
			end
	 
			if self.humanoidSeatedConn then
				self.humanoidSeatedConn:Disconnect()
				self.humanoidSeatedConn = nil
			end
			self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(active, currentSeatPart)
				self:OnHumanoidSeated(active, currentSeatPart)
			end)
		end
	 
		function ControlModule:OnCharacterRemoving(char)
			self.humanoid = nil
	 
			if self.touchGui then
				self.touchGui.Enabled = false
			end
		end
	 
		-- Helper function to lazily instantiate a controller if it does not yet exist,
		-- disable the active controller if it is different from the on being switched to,
		-- and then enable the requested controller. The argument to this function must be
		-- a reference to one of the control modules, i.e. Keyboard, Gamepad, etc.
		function ControlModule:SwitchToController(controlModule)
			if not controlModule then
				if self.activeController then
					self.activeController:Enable(false)
				end
				self.activeController = nil
				self.activeControlModule = nil
			else
				if not self.controllers[controlModule] then
					self.controllers[controlModule] = controlModule.new(CONTROL_ACTION_PRIORITY)
				end
	 
				if self.activeController ~= self.controllers[controlModule] then
					if self.activeController then
						self.activeController:Enable(false)
					end
					self.activeController = self.controllers[controlModule]
					self.activeControlModule = controlModule -- Only used to check if controller switch is necessary
	 
					if self.touchControlFrame and (self.activeControlModule == ClickToMove
								or self.activeControlModule == TouchThumbstick
								or self.activeControlModule == DynamicThumbstick) then
						if not self.controllers[TouchJump] then
							self.controllers[TouchJump] = TouchJump.new()
						end
						self.touchJumpController = self.controllers[TouchJump]
						self.touchJumpController:Enable(true, self.touchControlFrame)
					else
						if self.touchJumpController then
							self.touchJumpController:Enable(false)
						end
					end
	 
					self:EnableActiveControlModule()
				end
			end
		end
	 
		function ControlModule:OnLastInputTypeChanged(newLastInputType)
			if lastInputType == newLastInputType then
				warn("LastInputType Change listener called with current type.")
			end
			lastInputType = newLastInputType
	 
			if lastInputType == Enum.UserInputType.Touch then
				-- TODO: Check if touch module already active
				local touchModule, success = self:SelectTouchModule()
				if success then
					while not self.touchControlFrame do
						wait()
					end
					self:SwitchToController(touchModule)
				end
			elseif computerInputTypeToModuleMap[lastInputType] ~= nil then
				local computerModule = self:SelectComputerMovementModule()
				if computerModule then
					self:SwitchToController(computerModule)
				end
			end
		end
	 
		-- Called when any relevant values of GameSettings or LocalPlayer change, forcing re-evalulation of
		-- current control scheme
		function ControlModule:OnComputerMovementModeChange()
			local controlModule, success =  self:SelectComputerMovementModule()
			if success then
				self:SwitchToController(controlModule)
			end
		end
	 
		function ControlModule:OnTouchMovementModeChange()
			local touchModule, success = self:SelectTouchModule()
			if success then
				while not self.touchControlFrame do
					wait()
				end
				self:SwitchToController(touchModule)
			end
		end
	 
		function ControlModule:CreateTouchGuiContainer()
			if self.touchGui then self.touchGui:Destroy() end
	 
			-- Container for all touch device guis
			self.touchGui = Instance.new("ScreenGui")
			self.touchGui.Name = "TouchGui"
			self.touchGui.ResetOnSpawn = false
			self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			self.touchGui.Enabled = self.humanoid ~= nil
	 
			self.touchControlFrame = Instance.new("Frame")
			self.touchControlFrame.Name = "TouchControlFrame"
			self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
			self.touchControlFrame.BackgroundTransparency = 1
			self.touchControlFrame.Parent = self.touchGui
	 
			self.touchGui.Parent = self.playerGui
		end
	 
		function ControlModule:GetClickToMoveController()
			if not self.controllers[ClickToMove] then
				self.controllers[ClickToMove] = ClickToMove.new(CONTROL_ACTION_PRIORITY)
			end
			return self.controllers[ClickToMove]
		end
	 
		function ControlModule:IsJumping()
			if self.activeController then
				return self.activeController:GetIsJumping() or (self.touchJumpController and self.touchJumpController:GetIsJumping())
			end
			return false
		end
	 
		return ControlModule.new()
	end
	 
	function _PlayerModule()
		local PlayerModule = {}
		PlayerModule.__index = PlayerModule
		function PlayerModule.new()
			local self = setmetatable({},PlayerModule)
			self.cameras = _CameraModule()
			self.controls = _ControlModule()
			return self
		end
		function PlayerModule:GetCameras()
			return self.cameras
		end
		function PlayerModule:GetControls()
			return self.controls
		end
		function PlayerModule:GetClickToMoveController()
			return self.controls:GetClickToMoveController()
		end
		return PlayerModule.new()
	end
	 
	function _sounds()
	 
		local SetState = Instance.new("BindableEvent",script)
	 
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
	 
		local SOUND_DATA = {
			Climbing = {
				SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
				Looped = true,
			},
			Died = {
				SoundId = "rbxasset://sounds/uuhhh.mp3",
			},
			FreeFalling = {
				SoundId = "rbxasset://sounds/action_falling.mp3",
				Looped = true,
			},
			GettingUp = {
				SoundId = "rbxasset://sounds/action_get_up.mp3",
			},
			Jumping = {
				SoundId = "rbxasset://sounds/action_jump.mp3",
			},
			Landing = {
				SoundId = "rbxasset://sounds/action_jump_land.mp3",
			},
			Running = {
				SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
				Looped = true,
				Pitch = 1.85,
			},
			Splash = {
				SoundId = "rbxasset://sounds/impact_water.mp3",
			},
			Swimming = {
				SoundId = "rbxasset://sounds/action_swim.mp3",
				Looped = true,
				Pitch = 1.6,
			},
		}
	 
		 -- wait for the first of the passed signals to fire
		local function waitForFirst(...)
			local shunt = Instance.new("BindableEvent")
			local slots = {...}
	 
			local function fire(...)
				for i = 1, #slots do
					slots[i]:Disconnect()
				end
	 
				return shunt:Fire(...)
			end
	 
			for i = 1, #slots do
				slots[i] = slots[i]:Connect(fire)
			end
	 
			return shunt.Event:Wait()
		end
	 
		-- map a value from one range to another
		local function map(x, inMin, inMax, outMin, outMax)
			return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
		end
	 
		local function playSound(sound)
			sound.TimePosition = 0
			sound.Playing = true
		end
	 
		local function stopSound(sound)
			sound.Playing = false
			sound.TimePosition = 0
		end
	 
		local function shallowCopy(t)
			local out = {}
			for k, v in pairs(t) do
				out[k] = v
			end
			return out
		end
	 
		local function initializeSoundSystem(player, humanoid, rootPart)
			local sounds = {}
	 
			-- initialize sounds
			for name, props in pairs(SOUND_DATA) do
				local sound = Instance.new("Sound")
				sound.Name = name
	 
				-- set default values
				sound.Archivable = false
				sound.EmitterSize = 5
				sound.MaxDistance = 150
				sound.Volume = 0.65
	 
				for propName, propValue in pairs(props) do
					sound[propName] = propValue
				end
	 
				sound.Parent = rootPart
				sounds[name] = sound
			end
	 
			local playingLoopedSounds = {}
	 
			local function stopPlayingLoopedSounds(except)
				for sound in pairs(shallowCopy(playingLoopedSounds)) do
					if sound ~= except then
						sound.Playing = false
						playingLoopedSounds[sound] = nil
					end
				end
			end
	 
			-- state transition callbacks
			local stateTransitions = {
				[Enum.HumanoidStateType.FallingDown] = function()
					stopPlayingLoopedSounds()
				end,
	 
				[Enum.HumanoidStateType.GettingUp] = function()
					stopPlayingLoopedSounds()
					playSound(sounds.GettingUp)
				end,
	 
				[Enum.HumanoidStateType.Jumping] = function()
					stopPlayingLoopedSounds()
					playSound(sounds.Jumping)
				end,
	 
				[Enum.HumanoidStateType.Swimming] = function()
					local verticalSpeed = math.abs(rootPart.Velocity.Y)
					if verticalSpeed > 0.1 then
						sounds.Splash.Volume = math.clamp(map(verticalSpeed, 100, 350, 0.28, 1), 0, 1)
						playSound(sounds.Splash)
					end
					stopPlayingLoopedSounds(sounds.Swimming)
					sounds.Swimming.Playing = true
					playingLoopedSounds[sounds.Swimming] = true
				end,
	 
				[Enum.HumanoidStateType.Freefall] = function()
					sounds.FreeFalling.Volume = 0
					stopPlayingLoopedSounds(sounds.FreeFalling)
					playingLoopedSounds[sounds.FreeFalling] = true
				end,
	 
				[Enum.HumanoidStateType.Landed] = function()
					stopPlayingLoopedSounds()
					local verticalSpeed = math.abs(rootPart.Velocity.Y)
					if verticalSpeed > 75 then
						sounds.Landing.Volume = math.clamp(map(verticalSpeed, 50, 100, 0, 1), 0, 1)
						playSound(sounds.Landing)
					end
				end,
	 
				[Enum.HumanoidStateType.Running] = function()
					stopPlayingLoopedSounds(sounds.Running)
					sounds.Running.Playing = true
					playingLoopedSounds[sounds.Running] = true
				end,
	 
				[Enum.HumanoidStateType.Climbing] = function()
					local sound = sounds.Climbing
					if math.abs(rootPart.Velocity.Y) > 0.1 then
						sound.Playing = true
						stopPlayingLoopedSounds(sound)
					else
						stopPlayingLoopedSounds()
					end
					playingLoopedSounds[sound] = true
				end,
	 
				[Enum.HumanoidStateType.Seated] = function()
					stopPlayingLoopedSounds()
				end,
	 
				[Enum.HumanoidStateType.Dead] = function()
					stopPlayingLoopedSounds()
					playSound(sounds.Died)
				end,
			}
	 
			-- updaters for looped sounds
			local loopedSoundUpdaters = {
				[sounds.Climbing] = function(dt, sound, vel)
					sound.Playing = vel.Magnitude > 0.1
				end,
	 
				[sounds.FreeFalling] = function(dt, sound, vel)
					if vel.Magnitude > 75 then
						sound.Volume = math.clamp(sound.Volume + 0.9*dt, 0, 1)
					else
						sound.Volume = 0
					end
				end,
	 
				[sounds.Running] = function(dt, sound, vel)
					sound.Playing = vel.Magnitude > 0.5 and humanoid.MoveDirection.Magnitude > 0.5
				end,
			}
	 
			-- state substitutions to avoid duplicating entries in the state table
			local stateRemap = {
				[Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running,
			}
	 
			local activeState = stateRemap[humanoid:GetState()] or humanoid:GetState()
			local activeConnections = {}
	 
			local stateChangedConn = humanoid.StateChanged:Connect(function(_, state)
				state = stateRemap[state] or state
	 
				if state ~= activeState then
					local transitionFunc = stateTransitions[state]
	 
					if transitionFunc then
						transitionFunc()
					end
	 
					activeState = state
				end
			end)
	 
			local customStateChangedConn = SetState.Event:Connect(function(state)
				state = stateRemap[state] or state
	 
				if state ~= activeState then
					local transitionFunc = stateTransitions[state]
	 
					if transitionFunc then
						transitionFunc()
					end
	 
					activeState = state
				end
			end)
	 
			local steppedConn = RunService.Stepped:Connect(function(_, worldDt)
				-- update looped sounds on stepped
				for sound in pairs(playingLoopedSounds) do
					local updater = loopedSoundUpdaters[sound]
	 
					if updater then
						updater(worldDt, sound, rootPart.Velocity)
					end
				end
			end)
	 
			local humanoidAncestryChangedConn
			local rootPartAncestryChangedConn
			local characterAddedConn
	 
			local function terminate()
				stateChangedConn:Disconnect()
				customStateChangedConn:Disconnect()
				steppedConn:Disconnect()
				humanoidAncestryChangedConn:Disconnect()
				rootPartAncestryChangedConn:Disconnect()
				characterAddedConn:Disconnect()
			end
	 
			humanoidAncestryChangedConn = humanoid.AncestryChanged:Connect(function(_, parent)
				if not parent then
					terminate()
				end
			end)
	 
			rootPartAncestryChangedConn = rootPart.AncestryChanged:Connect(function(_, parent)
				if not parent then
					terminate()
				end
			end)
	 
			characterAddedConn = player.CharacterAdded:Connect(terminate)
		end
	 
		local function playerAdded(player)
			local function characterAdded(character)
				-- Avoiding memory leaks in the face of Character/Humanoid/RootPart lifetime has a few complications:
				-- * character deparenting is a Remove instead of a Destroy, so signals are not cleaned up automatically.
				-- ** must use a waitForFirst on everything and listen for hierarchy changes.
				-- * the character might not be in the dm by the time CharacterAdded fires
				-- ** constantly check consistency with player.Character and abort if CharacterAdded is fired again
				-- * Humanoid may not exist immediately, and by the time it's inserted the character might be deparented.
				-- * RootPart probably won't exist immediately.
				-- ** by the time RootPart is inserted and Humanoid.RootPart is set, the character or the humanoid might be deparented.
	 
				if not character.Parent then
					waitForFirst(character.AncestryChanged, player.CharacterAdded)
				end
	 
				if player.Character ~= character or not character.Parent then
					return
				end
	 
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				while character:IsDescendantOf(game) and not humanoid do
					waitForFirst(character.ChildAdded, character.AncestryChanged, player.CharacterAdded)
					humanoid = character:FindFirstChildOfClass("Humanoid")
				end
	 
				if player.Character ~= character or not character:IsDescendantOf(game) then
					return
				end
	 
				-- must rely on HumanoidRootPart naming because Humanoid.RootPart does not fire changed signals
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				while character:IsDescendantOf(game) and not rootPart do
					waitForFirst(character.ChildAdded, character.AncestryChanged, humanoid.AncestryChanged, player.CharacterAdded)
					rootPart = character:FindFirstChild("HumanoidRootPart")
				end
	 
				if rootPart and humanoid:IsDescendantOf(game) and character:IsDescendantOf(game) and player.Character == character then
					initializeSoundSystem(player, humanoid, rootPart)
				end
			end
	 
			if player.Character then
				characterAdded(player.Character)
			end
			player.CharacterAdded:Connect(characterAdded)
		end
	 
		Players.PlayerAdded:Connect(playerAdded)
		for _, player in ipairs(Players:GetPlayers()) do
			playerAdded(player)
		end
		return SetState
	end
	 
	function _StateTracker()
		local EPSILON = 0.1
	 
		local SPEED = {
			["onRunning"] = true,
			["onClimbing"] = true 
		}
	 
		local INAIR = {
			["onFreeFall"] = true,
			["onJumping"] = true
		}
	 
		local STATEMAP = {
			["onRunning"] = Enum.HumanoidStateType.Running,
			["onJumping"] = Enum.HumanoidStateType.Jumping,
			["onFreeFall"] = Enum.HumanoidStateType.Freefall
		}
	 
		local StateTracker = {}
		StateTracker.__index = StateTracker
	 
		function StateTracker.new(humanoid, soundState)
			local self = setmetatable({}, StateTracker)
	 
			self.Humanoid = humanoid
			self.HRP = humanoid.RootPart
	 
			self.Speed = 0
			self.State = "onRunning"
			self.Jumped = false
			self.JumpTick = tick()
	 
			self.SoundState = soundState
	 
			self._ChangedEvent = Instance.new("BindableEvent")
			self.Changed = self._ChangedEvent.Event
	 
			return self
		end
	 
		function StateTracker:Destroy()
			self._ChangedEvent:Destroy()
		end
	 
		function StateTracker:RequestedJump()
			self.Jumped = true
			self.JumpTick = tick()
		end
	 
		function StateTracker:OnStep(gravityUp, grounded, isMoving)
			local cVelocity = self.HRP.Velocity
			local gVelocity = cVelocity:Dot(gravityUp)
	 
			local oldState, oldSpeed = self.State, self.Speed
	 
			local newState
			local newSpeed = cVelocity.Magnitude
	 
			if (not grounded) then
				if (gVelocity > 0) then
					if (self.Jumped) then
						newState = "onJumping"
					else
						newState = "onFreeFall"
					end
				else
					if (self.Jumped) then
						self.Jumped = false
					end
					newState = "onFreeFall"
				end
			else
				if (self.Jumped and tick() - self.JumpTick > 0.1) then
					self.Jumped = false
				end
				newSpeed = (cVelocity - gVelocity*gravityUp).Magnitude
				newState = "onRunning"
			end
	 
			newSpeed = isMoving and newSpeed or 0
	 
			if (oldState ~= newState or (SPEED[newState] and math.abs(oldSpeed - newSpeed) > EPSILON)) then
				self.State = newState
				self.Speed = newSpeed
				self.SoundState:Fire(STATEMAP[newState])
				self._ChangedEvent:Fire(self.State, self.Speed)
			end
		end
	 
		return StateTracker
	end
	function _InitObjects()
		local model = workspace:FindFirstChild("objects") or game:GetObjects("rbxassetid://5045408489")[1]
		local SPHERE = model:WaitForChild("Sphere")
		local FLOOR = model:WaitForChild("Floor")
		local VFORCE = model:WaitForChild("VectorForce")
		local BGYRO = model:WaitForChild("BodyGyro")
		local function initObjects(self)
			local hrp = self.HRP
			local humanoid = self.Humanoid
			local sphere = SPHERE:Clone()
			sphere.Parent = self.Character
			local floor = FLOOR:Clone()
			floor.Parent = self.Character
			local isR15 = (humanoid.RigType == Enum.HumanoidRigType.R15)
			local height = isR15 and (humanoid.HipHeight + 0.05) or 2
			local weld = Instance.new("Weld")
			weld.C0 = CFrame.new(0, -height, 0.1)
			weld.Part0 = hrp
			weld.Part1 = sphere
			weld.Parent = sphere
			local weld2 = Instance.new("Weld")
			weld2.C0 = CFrame.new(0, -(height + 1.5), 0)
			weld2.Part0 = hrp
			weld2.Part1 = floor
			weld2.Parent = floor
			local gyro = BGYRO:Clone()
			gyro.CFrame = hrp.CFrame
			gyro.Parent = hrp
			local vForce = VFORCE:Clone()
			vForce.Attachment0 = isR15 and hrp:WaitForChild("RootRigAttachment") or hrp:WaitForChild("RootAttachment")
			vForce.Parent = hrp
			return sphere, gyro, vForce, floor
		end
		return initObjects
	end
	local plr = game.Players.LocalPlayer
	local ms = plr:GetMouse()
	local char
	plr.CharacterAdded:Connect(function(c)
		char = c
	end)
	function _R6()
		function r6()
		local Figure = char
		local Torso = Figure:WaitForChild("Torso")
		local RightShoulder = Torso:WaitForChild("Right Shoulder")
		local LeftShoulder = Torso:WaitForChild("Left Shoulder")
		local RightHip = Torso:WaitForChild("Right Hip")
		local LeftHip = Torso:WaitForChild("Left Hip")
		local Neck = Torso:WaitForChild("Neck")
		local Humanoid = Figure:WaitForChild("Humanoid")
		local pose = "Standing"
		local currentAnim = ""
		local currentAnimInstance = nil
		local currentAnimTrack = nil
		local currentAnimKeyframeHandler = nil
		local currentAnimSpeed = 1.0
		local animTable = {}
		local animNames = { 
			idle = 	{	
						{ id = "http://www.roblox.com/asset/?id=180435571", weight = 9 },
						{ id = "http://www.roblox.com/asset/?id=180435792", weight = 1 }
					},
			walk = 	{ 	
						{ id = "http://www.roblox.com/asset/?id=180426354", weight = 10 } 
					}, 
			run = 	{
						{ id = "run.xml", weight = 10 } 
					}, 
			jump = 	{
						{ id = "http://www.roblox.com/asset/?id=125750702", weight = 10 } 
					}, 
			fall = 	{
						{ id = "http://www.roblox.com/asset/?id=180436148", weight = 10 } 
					}, 
			climb = {
						{ id = "http://www.roblox.com/asset/?id=180436334", weight = 10 } 
					}, 
			sit = 	{
						{ id = "http://www.roblox.com/asset/?id=178130996", weight = 10 } 
					},	
			toolnone = {
						{ id = "http://www.roblox.com/asset/?id=182393478", weight = 10 } 
					},
			toolslash = {
						{ id = "http://www.roblox.com/asset/?id=129967390", weight = 10 } 
		--				{ id = "slash.xml", weight = 10 } 
					},
			toollunge = {
						{ id = "http://www.roblox.com/asset/?id=129967478", weight = 10 } 
					},
			wave = {
						{ id = "http://www.roblox.com/asset/?id=128777973", weight = 10 } 
					},
			point = {
						{ id = "http://www.roblox.com/asset/?id=128853357", weight = 10 } 
					},
			dance1 = {
						{ id = "http://www.roblox.com/asset/?id=182435998", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=182491037", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=182491065", weight = 10 } 
					},
			dance2 = {
						{ id = "http://www.roblox.com/asset/?id=182436842", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=182491248", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=182491277", weight = 10 } 
					},
			dance3 = {
						{ id = "http://www.roblox.com/asset/?id=182436935", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=182491368", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=182491423", weight = 10 } 
					},
			laugh = {
						{ id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } 
					},
			cheer = {
						{ id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } 
					},
		}
		local dances = {"dance1", "dance2", "dance3"}
		-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
		local emoteNames = { wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}
		function configureAnimationSet(name, fileList)
			if (animTable[name] ~= nil) then
				for _, connection in pairs(animTable[name].connections) do
					connection:disconnect()
				end
			end
			animTable[name] = {}
			animTable[name].count = 0
			animTable[name].totalWeight = 0	
			animTable[name].connections = {}
			-- check for config values
			local config = script:FindFirstChild(name)
			if (config ~= nil) then
		--		print("Loading anims " .. name)
				table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
				table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
				local idx = 1
				for _, childPart in pairs(config:GetChildren()) do
					if (childPart:IsA("Animation")) then
						table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
						animTable[name][idx] = {}
						animTable[name][idx].anim = childPart
						local weightObject = childPart:FindFirstChild("Weight")
						if (weightObject == nil) then
							animTable[name][idx].weight = 1
						else
							animTable[name][idx].weight = weightObject.Value
						end
						animTable[name].count = animTable[name].count + 1
						animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
			--			print(name .. " [" .. idx .. "] " .. animTable[name][idx].anim.AnimationId .. " (" .. animTable[name][idx].weight .. ")")
						idx = idx + 1
					end
				end
			end
			-- fallback to defaults
			if (animTable[name].count <= 0) then
				for idx, anim in pairs(fileList) do
					animTable[name][idx] = {}
					animTable[name][idx].anim = Instance.new("Animation")
					animTable[name][idx].anim.Name = name
					animTable[name][idx].anim.AnimationId = anim.id
					animTable[name][idx].weight = anim.weight
					animTable[name].count = animTable[name].count + 1
					animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
		--			print(name .. " [" .. idx .. "] " .. anim.id .. " (" .. anim.weight .. ")")
				end
			end
		end
		-- Setup animation objects
		function scriptChildModified(child)
			local fileList = animNames[child.Name]
			if (fileList ~= nil) then
				configureAnimationSet(child.Name, fileList)
			end	
		end
	 
		script.ChildAdded:connect(scriptChildModified)
		script.ChildRemoved:connect(scriptChildModified)
	 
	 
		for name, fileList in pairs(animNames) do 
			configureAnimationSet(name, fileList)
		end	
	 
		-- ANIMATION
	 
		-- declarations
		local toolAnim = "None"
		local toolAnimTime = 0
	 
		local jumpAnimTime = 0
		local jumpAnimDuration = 0.3
	 
		local toolTransitionTime = 0.1
		local fallTransitionTime = 0.3
		local jumpMaxLimbVelocity = 0.75
	 
		-- functions
	 
		function stopAllAnimations()
			local oldAnim = currentAnim
	 
			-- return to idle if finishing an emote
			if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then
				oldAnim = "idle"
			end
	 
			currentAnim = ""
			currentAnimInstance = nil
			if (currentAnimKeyframeHandler ~= nil) then
				currentAnimKeyframeHandler:disconnect()
			end
	 
			if (currentAnimTrack ~= nil) then
				currentAnimTrack:Stop()
				currentAnimTrack:Destroy()
				currentAnimTrack = nil
			end
			return oldAnim
		end
	 
		function setAnimationSpeed(speed)
			if speed ~= currentAnimSpeed then
				currentAnimSpeed = speed
				currentAnimTrack:AdjustSpeed(currentAnimSpeed)
			end
		end
	 
		function keyFrameReachedFunc(frameName)
			if (frameName == "End") then
	 
				local repeatAnim = currentAnim
				-- return to idle if finishing an emote
				if (emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false) then
					repeatAnim = "idle"
				end
	 
				local animSpeed = currentAnimSpeed
				playAnimation(repeatAnim, 0.0, Humanoid)
				setAnimationSpeed(animSpeed)
			end
		end
	 
		-- Preload animations
		function playAnimation(animName, transitionTime, humanoid) 
	 
			local roll = math.random(1, animTable[animName].totalWeight) 
			local origRoll = roll
			local idx = 1
			while (roll > animTable[animName][idx].weight) do
				roll = roll - animTable[animName][idx].weight
				idx = idx + 1
			end
		--		print(animName .. " " .. idx .. " [" .. origRoll .. "]")
			local anim = animTable[animName][idx].anim
	 
			-- switch animation		
			if (anim ~= currentAnimInstance) then
	 
				if (currentAnimTrack ~= nil) then
					currentAnimTrack:Stop(transitionTime)
					currentAnimTrack:Destroy()
				end
	 
				currentAnimSpeed = 1.0
	 
				-- load it to the humanoid; get AnimationTrack
				currentAnimTrack = humanoid:LoadAnimation(anim)
				currentAnimTrack.Priority = Enum.AnimationPriority.Core
	 
				-- play the animation
				currentAnimTrack:Play(transitionTime)
				currentAnim = animName
				currentAnimInstance = anim
	 
				-- set up keyframe name triggers
				if (currentAnimKeyframeHandler ~= nil) then
					currentAnimKeyframeHandler:disconnect()
				end
				currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
	 
			end
	 
		end
	 
		-------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
	 
		local toolAnimName = ""
		local toolAnimTrack = nil
		local toolAnimInstance = nil
		local currentToolAnimKeyframeHandler = nil
	 
		function toolKeyFrameReachedFunc(frameName)
			if (frameName == "End") then
		--		print("Keyframe : ".. frameName)	
				playToolAnimation(toolAnimName, 0.0, Humanoid)
			end
		end
	 
	 
		function playToolAnimation(animName, transitionTime, humanoid, priority)	 
	 
				local roll = math.random(1, animTable[animName].totalWeight) 
				local origRoll = roll
				local idx = 1
				while (roll > animTable[animName][idx].weight) do
					roll = roll - animTable[animName][idx].weight
					idx = idx + 1
				end
		--		print(animName .. " * " .. idx .. " [" .. origRoll .. "]")
				local anim = animTable[animName][idx].anim
	 
				if (toolAnimInstance ~= anim) then
	 
					if (toolAnimTrack ~= nil) then
						toolAnimTrack:Stop()
						toolAnimTrack:Destroy()
						transitionTime = 0
					end
	 
					-- load it to the humanoid; get AnimationTrack
					toolAnimTrack = humanoid:LoadAnimation(anim)
					if priority then
						toolAnimTrack.Priority = priority
					end
	 
					-- play the animation
					toolAnimTrack:Play(transitionTime)
					toolAnimName = animName
					toolAnimInstance = anim
	 
					currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
				end
		end
	 
		function stopToolAnimations()
			local oldAnim = toolAnimName
	 
			if (currentToolAnimKeyframeHandler ~= nil) then
				currentToolAnimKeyframeHandler:disconnect()
			end
	 
			toolAnimName = ""
			toolAnimInstance = nil
			if (toolAnimTrack ~= nil) then
				toolAnimTrack:Stop()
				toolAnimTrack:Destroy()
				toolAnimTrack = nil
			end
	 
	 
			return oldAnim
		end
	 
		-------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
	 
	 
		function onRunning(speed)
			if speed > 0.01 then
				playAnimation("walk", 0.1, Humanoid)
				if currentAnimInstance and currentAnimInstance.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
					setAnimationSpeed(speed / 14.5)
				end
				pose = "Running"
			else
				if emoteNames[currentAnim] == nil then
					playAnimation("idle", 0.1, Humanoid)
					pose = "Standing"
				end
			end
		end
	 
		function onDied()
			pose = "Dead"
		end
	 
		function onJumping()
			playAnimation("jump", 0.1, Humanoid)
			jumpAnimTime = jumpAnimDuration
			pose = "Jumping"
		end
	 
		function onClimbing(speed)
			playAnimation("climb", 0.1, Humanoid)
			setAnimationSpeed(speed / 12.0)
			pose = "Climbing"
		end
	 
		function onGettingUp()
			pose = "GettingUp"
		end
	 
		function onFreeFall()
			if (jumpAnimTime <= 0) then
				playAnimation("fall", fallTransitionTime, Humanoid)
			end
			pose = "FreeFall"
		end
	 
		function onFallingDown()
			pose = "FallingDown"
		end
	 
		function onSeated()
			pose = "Seated"
		end
	 
		function onPlatformStanding()
			pose = "PlatformStanding"
		end
	 
		function onSwimming(speed)
			if speed > 0 then
				pose = "Running"
			else
				pose = "Standing"
			end
		end
	 
		function getTool()	
			for _, kid in ipairs(Figure:GetChildren()) do
				if kid.className == "Tool" then return kid end
			end
			return nil
		end
	 
		function getToolAnim(tool)
			for _, c in ipairs(tool:GetChildren()) do
				if c.Name == "toolanim" and c.className == "StringValue" then
					return c
				end
			end
			return nil
		end
	 
		function animateTool()
	 
			if (toolAnim == "None") then
				playToolAnimation("toolnone", toolTransitionTime, Humanoid, Enum.AnimationPriority.Idle)
				return
			end
	 
			if (toolAnim == "Slash") then
				playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)
				return
			end
	 
			if (toolAnim == "Lunge") then
				playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)
				return
			end
		end
	 
		function moveSit()
			RightShoulder.MaxVelocity = 0.15
			LeftShoulder.MaxVelocity = 0.15
			RightShoulder:SetDesiredAngle(3.14 /2)
			LeftShoulder:SetDesiredAngle(-3.14 /2)
			RightHip:SetDesiredAngle(3.14 /2)
			LeftHip:SetDesiredAngle(-3.14 /2)
		end
	 
		local lastTick = 0
	 
		function move(time)
			local amplitude = 1
			local frequency = 1
			  local deltaTime = time - lastTick
			  lastTick = time
	 
			local climbFudge = 0
			local setAngles = false
	 
			  if (jumpAnimTime > 0) then
				  jumpAnimTime = jumpAnimTime - deltaTime
			  end
	 
			if (pose == "FreeFall" and jumpAnimTime <= 0) then
				playAnimation("fall", fallTransitionTime, Humanoid)
			elseif (pose == "Seated") then
				playAnimation("sit", 0.5, Humanoid)
				return
			elseif (pose == "Running") then
				playAnimation("walk", 0.1, Humanoid)
			elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then
		--		print("Wha " .. pose)
				stopAllAnimations()
				amplitude = 0.1
				frequency = 1
				setAngles = true
			end
	 
			if (setAngles) then
				local desiredAngle = amplitude * math.sin(time * frequency)
	 
				RightShoulder:SetDesiredAngle(desiredAngle + climbFudge)
				LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge)
				RightHip:SetDesiredAngle(-desiredAngle)
				LeftHip:SetDesiredAngle(-desiredAngle)
			end
	 
			-- Tool Animation handling
			local tool = getTool()
			if tool and tool:FindFirstChild("Handle") then
	 
				local animStringValueObject = getToolAnim(tool)
	 
				if animStringValueObject then
					toolAnim = animStringValueObject.Value
					-- message recieved, delete StringValue
					animStringValueObject.Parent = nil
					toolAnimTime = time + .3
				end
	 
				if time > toolAnimTime then
					toolAnimTime = 0
					toolAnim = "None"
				end
	 
				animateTool()		
			else
				stopToolAnimations()
				toolAnim = "None"
				toolAnimInstance = nil
				toolAnimTime = 0
			end
		end
	 
	 
		local events = {}
		local eventHum = Humanoid
	 
		local function onUnhook()
			for i = 1, #events do
				events[i]:Disconnect()
			end
			events = {}
		end
	 
		local function onHook()
			onUnhook()
	 
			pose = eventHum.Sit and "Seated" or "Standing"
	 
			events = {
				eventHum.Died:connect(onDied),
				eventHum.Running:connect(onRunning),
				eventHum.Jumping:connect(onJumping),
				eventHum.Climbing:connect(onClimbing),
				eventHum.GettingUp:connect(onGettingUp),
				eventHum.FreeFalling:connect(onFreeFall),
				eventHum.FallingDown:connect(onFallingDown),
				eventHum.Seated:connect(onSeated),
				eventHum.PlatformStanding:connect(onPlatformStanding),
				eventHum.Swimming:connect(onSwimming)
			}
		end
	 
	 
		onHook()
	 
		-- setup emote chat hook
		game:GetService("Players").LocalPlayer.Chatted:connect(function(msg)
			local emote = ""
			if msg == "/e dance" then
				emote = dances[math.random(1, #dances)]
			elseif (string.sub(msg, 1, 3) == "/e ") then
				emote = string.sub(msg, 4)
			elseif (string.sub(msg, 1, 7) == "/emote ") then
				emote = string.sub(msg, 8)
			end
	 
			if (pose == "Standing" and emoteNames[emote] ~= nil) then
				playAnimation(emote, 0.1, Humanoid)
			end
	 
		end)
	 
	 
		-- main program
	 
		-- initialize to idle
		playAnimation("idle", 0.1, Humanoid)
		pose = "Standing"
	 
		spawn(function()
			while Figure.Parent ~= nil do
				local _, time = wait(0.1)
				move(time)
			end
		end)
	 
		return {
			onRunning = onRunning, 
			onDied = onDied, 
			onJumping = onJumping, 
			onClimbing = onClimbing, 
			onGettingUp = onGettingUp, 
			onFreeFall = onFreeFall, 
			onFallingDown = onFallingDown, 
			onSeated = onSeated, 
			onPlatformStanding = onPlatformStanding,
			onHook = onHook,
			onUnhook = onUnhook
		}
	 
		end
		return r6()
	end
	 
	function _R15()
		local function r15()
	 
		local Character = char
		local Humanoid = Character:WaitForChild("Humanoid")
		local pose = "Standing"
	 
		local userNoUpdateOnLoopSuccess, userNoUpdateOnLoopValue = pcall(function() return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop") end)
		local userNoUpdateOnLoop = userNoUpdateOnLoopSuccess and userNoUpdateOnLoopValue
		local userAnimationSpeedDampeningSuccess, userAnimationSpeedDampeningValue = pcall(function() return UserSettings():IsUserFeatureEnabled("UserAnimationSpeedDampening") end)
		local userAnimationSpeedDampening = userAnimationSpeedDampeningSuccess and userAnimationSpeedDampeningValue
	 
		local animateScriptEmoteHookFlagExists, animateScriptEmoteHookFlagEnabled = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserAnimateScriptEmoteHook")
		end)
		local FFlagAnimateScriptEmoteHook = animateScriptEmoteHookFlagExists and animateScriptEmoteHookFlagEnabled
	 
		local AnimationSpeedDampeningObject = script:FindFirstChild("ScaleDampeningPercent")
		local HumanoidHipHeight = 2
	 
		local EMOTE_TRANSITION_TIME = 0.1
	 
		local currentAnim = ""
		local currentAnimInstance = nil
		local currentAnimTrack = nil
		local currentAnimKeyframeHandler = nil
		local currentAnimSpeed = 1.0
	 
		local runAnimTrack = nil
		local runAnimKeyframeHandler = nil
	 
		local animTable = {}
		local animNames = { 
			idle = 	{	
						{ id = "http://www.roblox.com/asset/?id=507766666", weight = 1 },
						{ id = "http://www.roblox.com/asset/?id=507766951", weight = 1 },
						{ id = "http://www.roblox.com/asset/?id=507766388", weight = 9 }
					},
			walk = 	{ 	
						{ id = "http://www.roblox.com/asset/?id=507777826", weight = 10 } 
					}, 
			run = 	{
						{ id = "http://www.roblox.com/asset/?id=507767714", weight = 10 } 
					}, 
			swim = 	{
						{ id = "http://www.roblox.com/asset/?id=507784897", weight = 10 } 
					}, 
			swimidle = 	{
						{ id = "http://www.roblox.com/asset/?id=507785072", weight = 10 } 
					}, 
			jump = 	{
						{ id = "http://www.roblox.com/asset/?id=507765000", weight = 10 } 
					}, 
			fall = 	{
						{ id = "http://www.roblox.com/asset/?id=507767968", weight = 10 } 
					}, 
			climb = {
						{ id = "http://www.roblox.com/asset/?id=507765644", weight = 10 } 
					}, 
			sit = 	{
						{ id = "http://www.roblox.com/asset/?id=2506281703", weight = 10 } 
					},	
			toolnone = {
						{ id = "http://www.roblox.com/asset/?id=507768375", weight = 10 } 
					},
			toolslash = {
						{ id = "http://www.roblox.com/asset/?id=522635514", weight = 10 } 
					},
			toollunge = {
						{ id = "http://www.roblox.com/asset/?id=522638767", weight = 10 } 
					},
			wave = {
						{ id = "http://www.roblox.com/asset/?id=507770239", weight = 10 } 
					},
			point = {
						{ id = "http://www.roblox.com/asset/?id=507770453", weight = 10 } 
					},
			dance = {
						{ id = "http://www.roblox.com/asset/?id=507771019", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=507771955", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=507772104", weight = 10 } 
					},
			dance2 = {
						{ id = "http://www.roblox.com/asset/?id=507776043", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=507776720", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=507776879", weight = 10 } 
					},
			dance3 = {
						{ id = "http://www.roblox.com/asset/?id=507777268", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=507777451", weight = 10 }, 
						{ id = "http://www.roblox.com/asset/?id=507777623", weight = 10 } 
					},
			laugh = {
						{ id = "http://www.roblox.com/asset/?id=507770818", weight = 10 } 
					},
			cheer = {
						{ id = "http://www.roblox.com/asset/?id=507770677", weight = 10 } 
					},
		}
	 
		-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
		local emoteNames = { wave = false, point = false, dance = true, dance2 = true, dance3 = true, laugh = false, cheer = false}
	 
		local PreloadAnimsUserFlag = false
		local PreloadedAnims = {}
		local successPreloadAnim, msgPreloadAnim = pcall(function()
			PreloadAnimsUserFlag = UserSettings():IsUserFeatureEnabled("UserPreloadAnimations")
		end)
		if not successPreloadAnim then
			PreloadAnimsUserFlag = false
		end
	 
		math.randomseed(tick())
	 
		function findExistingAnimationInSet(set, anim)
			if set == nil or anim == nil then
				return 0
			end
	 
			for idx = 1, set.count, 1 do 
				if set[idx].anim.AnimationId == anim.AnimationId then
					return idx
				end
			end
	 
			return 0
		end
	 
		function configureAnimationSet(name, fileList)
			if (animTable[name] ~= nil) then
				for _, connection in pairs(animTable[name].connections) do
					connection:disconnect()
				end
			end
			animTable[name] = {}
			animTable[name].count = 0
			animTable[name].totalWeight = 0	
			animTable[name].connections = {}
	 
			local allowCustomAnimations = true
	 
			local success, msg = pcall(function() allowCustomAnimations = game:GetService("StarterPlayer").AllowCustomAnimations end)
			if not success then
				allowCustomAnimations = true
			end
	 
			-- check for config values
			local config = script:FindFirstChild(name)
			if (allowCustomAnimations and config ~= nil) then
				table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
				table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
	 
				local idx = 0
				for _, childPart in pairs(config:GetChildren()) do
					if (childPart:IsA("Animation")) then
						local newWeight = 1
						local weightObject = childPart:FindFirstChild("Weight")
						if (weightObject ~= nil) then
							newWeight = weightObject.Value
						end
						animTable[name].count = animTable[name].count + 1
						idx = animTable[name].count
						animTable[name][idx] = {}
						animTable[name][idx].anim = childPart
						animTable[name][idx].weight = newWeight
						animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
						table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
						table.insert(animTable[name].connections, childPart.ChildAdded:connect(function(property) configureAnimationSet(name, fileList) end))
						table.insert(animTable[name].connections, childPart.ChildRemoved:connect(function(property) configureAnimationSet(name, fileList) end))
					end
				end
			end
	 
			-- fallback to defaults
			if (animTable[name].count <= 0) then
				for idx, anim in pairs(fileList) do
					animTable[name][idx] = {}
					animTable[name][idx].anim = Instance.new("Animation")
					animTable[name][idx].anim.Name = name
					animTable[name][idx].anim.AnimationId = anim.id
					animTable[name][idx].weight = anim.weight
					animTable[name].count = animTable[name].count + 1
					animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
				end
			end
	 
			-- preload anims
			if PreloadAnimsUserFlag then
				for i, animType in pairs(animTable) do
					for idx = 1, animType.count, 1 do
						if PreloadedAnims[animType[idx].anim.AnimationId] == nil then
							Humanoid:LoadAnimation(animType[idx].anim)
							PreloadedAnims[animType[idx].anim.AnimationId] = true
						end				
					end
				end
			end
		end
	 
		------------------------------------------------------------------------------------------------------------
	 
		function configureAnimationSetOld(name, fileList)
			if (animTable[name] ~= nil) then
				for _, connection in pairs(animTable[name].connections) do
					connection:disconnect()
				end
			end
			animTable[name] = {}
			animTable[name].count = 0
			animTable[name].totalWeight = 0	
			animTable[name].connections = {}
	 
			local allowCustomAnimations = true
	 
			local success, msg = pcall(function() allowCustomAnimations = game:GetService("StarterPlayer").AllowCustomAnimations end)
			if not success then
				allowCustomAnimations = true
			end
	 
			-- check for config values
			local config = script:FindFirstChild(name)
			if (allowCustomAnimations and config ~= nil) then
				table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
				table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
				local idx = 1
				for _, childPart in pairs(config:GetChildren()) do
					if (childPart:IsA("Animation")) then
						table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
						animTable[name][idx] = {}
						animTable[name][idx].anim = childPart
						local weightObject = childPart:FindFirstChild("Weight")
						if (weightObject == nil) then
							animTable[name][idx].weight = 1
						else
							animTable[name][idx].weight = weightObject.Value
						end
						animTable[name].count = animTable[name].count + 1
						animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
						idx = idx + 1
					end
				end
			end
	 
			-- fallback to defaults
			if (animTable[name].count <= 0) then
				for idx, anim in pairs(fileList) do
					animTable[name][idx] = {}
					animTable[name][idx].anim = Instance.new("Animation")
					animTable[name][idx].anim.Name = name
					animTable[name][idx].anim.AnimationId = anim.id
					animTable[name][idx].weight = anim.weight
					animTable[name].count = animTable[name].count + 1
					animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
					-- print(name .. " [" .. idx .. "] " .. anim.id .. " (" .. anim.weight .. ")")
				end
			end
	 
			-- preload anims
			if PreloadAnimsUserFlag then
				for i, animType in pairs(animTable) do
					for idx = 1, animType.count, 1 do 
						Humanoid:LoadAnimation(animType[idx].anim)
					end
				end
			end
		end
	 
		-- Setup animation objects
		function scriptChildModified(child)
			local fileList = animNames[child.Name]
			if (fileList ~= nil) then
				configureAnimationSet(child.Name, fileList)
			end	
		end
	 
		script.ChildAdded:connect(scriptChildModified)
		script.ChildRemoved:connect(scriptChildModified)
	 
	 
		for name, fileList in pairs(animNames) do 
			configureAnimationSet(name, fileList)
		end	
	 
		-- ANIMATION
	 
		-- declarations
		local toolAnim = "None"
		local toolAnimTime = 0
	 
		local jumpAnimTime = 0
		local jumpAnimDuration = 0.31
	 
		local toolTransitionTime = 0.1
		local fallTransitionTime = 0.2
	 
		local currentlyPlayingEmote = false
	 
		-- functions
	 
		function stopAllAnimations()
			local oldAnim = currentAnim
	 
			-- return to idle if finishing an emote
			if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then
				oldAnim = "idle"
			end
	 
			if FFlagAnimateScriptEmoteHook and currentlyPlayingEmote then
				oldAnim = "idle"
				currentlyPlayingEmote = false
			end
	 
			currentAnim = ""
			currentAnimInstance = nil
			if (currentAnimKeyframeHandler ~= nil) then
				currentAnimKeyframeHandler:disconnect()
			end
	 
			if (currentAnimTrack ~= nil) then
				currentAnimTrack:Stop()
				currentAnimTrack:Destroy()
				currentAnimTrack = nil
			end
	 
			-- clean up walk if there is one
			if (runAnimKeyframeHandler ~= nil) then
				runAnimKeyframeHandler:disconnect()
			end
	 
			if (runAnimTrack ~= nil) then
				runAnimTrack:Stop()
				runAnimTrack:Destroy()
				runAnimTrack = nil
			end
	 
			return oldAnim
		end
	 
		function getHeightScale()
			if Humanoid then
				if not Humanoid.AutomaticScalingEnabled then
					return 1
				end
	 
				local scale = Humanoid.HipHeight / HumanoidHipHeight
				if userAnimationSpeedDampening then
					if AnimationSpeedDampeningObject == nil then
						AnimationSpeedDampeningObject = script:FindFirstChild("ScaleDampeningPercent")
					end
					if AnimationSpeedDampeningObject ~= nil then
						scale = 1 + (Humanoid.HipHeight - HumanoidHipHeight) * AnimationSpeedDampeningObject.Value / HumanoidHipHeight
					end
				end
				return scale
			end	
			return 1
		end
	 
		local smallButNotZero = 0.0001
		function setRunSpeed(speed)
			local speedScaled = speed * 1.25
			local heightScale = getHeightScale()
			local runSpeed = speedScaled / heightScale
	 
			if runSpeed ~= currentAnimSpeed then
				if runSpeed < 0.33 then
					currentAnimTrack:AdjustWeight(1.0)		
					runAnimTrack:AdjustWeight(smallButNotZero)
				elseif runSpeed < 0.66 then
					local weight = ((runSpeed - 0.33) / 0.33)
					currentAnimTrack:AdjustWeight(1.0 - weight + smallButNotZero)
					runAnimTrack:AdjustWeight(weight + smallButNotZero)
				else
					currentAnimTrack:AdjustWeight(smallButNotZero)
					runAnimTrack:AdjustWeight(1.0)
				end
				currentAnimSpeed = runSpeed
				runAnimTrack:AdjustSpeed(runSpeed)
				currentAnimTrack:AdjustSpeed(runSpeed)
			end	
		end
	 
		function setAnimationSpeed(speed)
			if currentAnim == "walk" then
					setRunSpeed(speed)
			else
				if speed ~= currentAnimSpeed then
					currentAnimSpeed = speed
					currentAnimTrack:AdjustSpeed(currentAnimSpeed)
				end
			end
		end
	 
		function keyFrameReachedFunc(frameName)
			if (frameName == "End") then
				if currentAnim == "walk" then
					if userNoUpdateOnLoop == true then
						if runAnimTrack.Looped ~= true then
							runAnimTrack.TimePosition = 0.0
						end
						if currentAnimTrack.Looped ~= true then
							currentAnimTrack.TimePosition = 0.0
						end
					else
						runAnimTrack.TimePosition = 0.0
						currentAnimTrack.TimePosition = 0.0
					end
				else
					local repeatAnim = currentAnim
					-- return to idle if finishing an emote
					if (emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false) then
						repeatAnim = "idle"
					end
	 
					if FFlagAnimateScriptEmoteHook and currentlyPlayingEmote then
						if currentAnimTrack.Looped then
							-- Allow the emote to loop
							return
						end
	 
						repeatAnim = "idle"
						currentlyPlayingEmote = false
					end
	 
					local animSpeed = currentAnimSpeed
					playAnimation(repeatAnim, 0.15, Humanoid)
					setAnimationSpeed(animSpeed)
				end
			end
		end
	 
		function rollAnimation(animName)
			local roll = math.random(1, animTable[animName].totalWeight) 
			local origRoll = roll
			local idx = 1
			while (roll > animTable[animName][idx].weight) do
				roll = roll - animTable[animName][idx].weight
				idx = idx + 1
			end
			return idx
		end
	 
		local function switchToAnim(anim, animName, transitionTime, humanoid)
			-- switch animation		
			if (anim ~= currentAnimInstance) then
	 
				if (currentAnimTrack ~= nil) then
					currentAnimTrack:Stop(transitionTime)
					currentAnimTrack:Destroy()
				end
	 
				if (runAnimTrack ~= nil) then
					runAnimTrack:Stop(transitionTime)
					runAnimTrack:Destroy()
					if userNoUpdateOnLoop == true then
						runAnimTrack = nil
					end
				end
	 
				currentAnimSpeed = 1.0
	 
				-- load it to the humanoid; get AnimationTrack
				currentAnimTrack = humanoid:LoadAnimation(anim)
				currentAnimTrack.Priority = Enum.AnimationPriority.Core
	 
				-- play the animation
				currentAnimTrack:Play(transitionTime)
				currentAnim = animName
				currentAnimInstance = anim
	 
				-- set up keyframe name triggers
				if (currentAnimKeyframeHandler ~= nil) then
					currentAnimKeyframeHandler:disconnect()
				end
				currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
	 
				-- check to see if we need to blend a walk/run animation
				if animName == "walk" then
					local runAnimName = "run"
					local runIdx = rollAnimation(runAnimName)
	 
					runAnimTrack = humanoid:LoadAnimation(animTable[runAnimName][runIdx].anim)
					runAnimTrack.Priority = Enum.AnimationPriority.Core
					runAnimTrack:Play(transitionTime)		
	 
					if (runAnimKeyframeHandler ~= nil) then
						runAnimKeyframeHandler:disconnect()
					end
					runAnimKeyframeHandler = runAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)	
				end
			end
		end
	 
		function playAnimation(animName, transitionTime, humanoid) 	
			local idx = rollAnimation(animName)
			local anim = animTable[animName][idx].anim
	 
			switchToAnim(anim, animName, transitionTime, humanoid)
			currentlyPlayingEmote = false
		end
	 
		function playEmote(emoteAnim, transitionTime, humanoid)
			switchToAnim(emoteAnim, emoteAnim.Name, transitionTime, humanoid)
			currentlyPlayingEmote = true
		end
	 
		-------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
	 
		local toolAnimName = ""
		local toolAnimTrack = nil
		local toolAnimInstance = nil
		local currentToolAnimKeyframeHandler = nil
	 
		function toolKeyFrameReachedFunc(frameName)
			if (frameName == "End") then
				playToolAnimation(toolAnimName, 0.0, Humanoid)
			end
		end
	 
	 
		function playToolAnimation(animName, transitionTime, humanoid, priority)	 		
				local idx = rollAnimation(animName)
				local anim = animTable[animName][idx].anim
	 
				if (toolAnimInstance ~= anim) then
	 
					if (toolAnimTrack ~= nil) then
						toolAnimTrack:Stop()
						toolAnimTrack:Destroy()
						transitionTime = 0
					end
	 
					-- load it to the humanoid; get AnimationTrack
					toolAnimTrack = humanoid:LoadAnimation(anim)
					if priority then
						toolAnimTrack.Priority = priority
					end
	 
					-- play the animation
					toolAnimTrack:Play(transitionTime)
					toolAnimName = animName
					toolAnimInstance = anim
	 
					currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
				end
		end
	 
		function stopToolAnimations()
			local oldAnim = toolAnimName
	 
			if (currentToolAnimKeyframeHandler ~= nil) then
				currentToolAnimKeyframeHandler:disconnect()
			end
	 
			toolAnimName = ""
			toolAnimInstance = nil
			if (toolAnimTrack ~= nil) then
				toolAnimTrack:Stop()
				toolAnimTrack:Destroy()
				toolAnimTrack = nil
			end
	 
			return oldAnim
		end
	 
		-------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
		-- STATE CHANGE HANDLERS
	 
		function onRunning(speed)
			if speed > 0.75 then
				local scale = 16.0
				playAnimation("walk", 0.2, Humanoid)
				setAnimationSpeed(speed / scale)
				pose = "Running"
			else
				if emoteNames[currentAnim] == nil and not currentlyPlayingEmote then
					playAnimation("idle", 0.2, Humanoid)
					pose = "Standing"
				end
			end
		end
	 
		function onDied()
			pose = "Dead"
		end
	 
		function onJumping()
			playAnimation("jump", 0.1, Humanoid)
			jumpAnimTime = jumpAnimDuration
			pose = "Jumping"
		end
	 
		function onClimbing(speed)
			local scale = 5.0
			playAnimation("climb", 0.1, Humanoid)
			setAnimationSpeed(speed / scale)
			pose = "Climbing"
		end
	 
		function onGettingUp()
			pose = "GettingUp"
		end
	 
		function onFreeFall()
			if (jumpAnimTime <= 0) then
				playAnimation("fall", fallTransitionTime, Humanoid)
			end
			pose = "FreeFall"
		end
	 
		function onFallingDown()
			pose = "FallingDown"
		end
	 
		function onSeated()
			pose = "Seated"
		end
	 
		function onPlatformStanding()
			pose = "PlatformStanding"
		end
	 
		-------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
	 
		function onSwimming(speed)
			if speed > 1.00 then
				local scale = 10.0
				playAnimation("swim", 0.4, Humanoid)
				setAnimationSpeed(speed / scale)
				pose = "Swimming"
			else
				playAnimation("swimidle", 0.4, Humanoid)
				pose = "Standing"
			end
		end
	 
		function animateTool()
			if (toolAnim == "None") then
				playToolAnimation("toolnone", toolTransitionTime, Humanoid, Enum.AnimationPriority.Idle)
				return
			end
	 
			if (toolAnim == "Slash") then
				playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)
				return
			end
	 
			if (toolAnim == "Lunge") then
				playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)
				return
			end
		end
	 
		function getToolAnim(tool)
			for _, c in ipairs(tool:GetChildren()) do
				if c.Name == "toolanim" and c.className == "StringValue" then
					return c
				end
			end
			return nil
		end
	 
		local lastTick = 0
	 
		function stepAnimate(currentTime)
			local amplitude = 1
			local frequency = 1
			  local deltaTime = currentTime - lastTick
			  lastTick = currentTime
	 
			local climbFudge = 0
			local setAngles = false
	 
			  if (jumpAnimTime > 0) then
				  jumpAnimTime = jumpAnimTime - deltaTime
			  end
	 
			if (pose == "FreeFall" and jumpAnimTime <= 0) then
				playAnimation("fall", fallTransitionTime, Humanoid)
			elseif (pose == "Seated") then
				playAnimation("sit", 0.5, Humanoid)
				return
			elseif (pose == "Running") then
				playAnimation("walk", 0.2, Humanoid)
			elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then
				stopAllAnimations()
				amplitude = 0.1
				frequency = 1
				setAngles = true
			end
	 
			-- Tool Animation handling
			local tool = Character:FindFirstChildOfClass("Tool")
			if tool and tool:FindFirstChild("Handle") then
				local animStringValueObject = getToolAnim(tool)
	 
				if animStringValueObject then
					toolAnim = animStringValueObject.Value
					-- message recieved, delete StringValue
					animStringValueObject.Parent = nil
					toolAnimTime = currentTime + .3
				end
	 
				if currentTime > toolAnimTime then
					toolAnimTime = 0
					toolAnim = "None"
				end
	 
				animateTool()		
			else
				stopToolAnimations()
				toolAnim = "None"
				toolAnimInstance = nil
				toolAnimTime = 0
			end
		end
	 
		-- connect events
	 
		local events = {}
		local eventHum = Humanoid
	 
		local function onUnhook()
			for i = 1, #events do
				events[i]:Disconnect()
			end
			events = {}
		end
	 
		local function onHook()
			onUnhook()
	 
			pose = eventHum.Sit and "Seated" or "Standing"
	 
			events = {
				eventHum.Died:connect(onDied),
				eventHum.Running:connect(onRunning),
				eventHum.Jumping:connect(onJumping),
				eventHum.Climbing:connect(onClimbing),
				eventHum.GettingUp:connect(onGettingUp),
				eventHum.FreeFalling:connect(onFreeFall),
				eventHum.FallingDown:connect(onFallingDown),
				eventHum.Seated:connect(onSeated),
				eventHum.PlatformStanding:connect(onPlatformStanding),
				eventHum.Swimming:connect(onSwimming)
			}
		end
	 
	 
		onHook()
	 
		-- setup emote chat hook
		game:GetService("Players").LocalPlayer.Chatted:connect(function(msg)
			local emote = ""
			if (string.sub(msg, 1, 3) == "/e ") then
				emote = string.sub(msg, 4)
			elseif (string.sub(msg, 1, 7) == "/emote ") then
				emote = string.sub(msg, 8)
			end
	 
			if (pose == "Standing" and emoteNames[emote] ~= nil) then
				playAnimation(emote, EMOTE_TRANSITION_TIME, Humanoid)
			end
		end)
	 
		--[[ emote bindable hook
		if FFlagAnimateScriptEmoteHook then
			script:WaitForChild("PlayEmote").OnInvoke = function(emote)
				-- Only play emotes when idling
				if pose ~= "Standing" then
					return
				end
				if emoteNames[emote] ~= nil then
					-- Default emotes
					playAnimation(emote, EMOTE_TRANSITION_TIME, Humanoid)
					return true
				elseif typeof(emote) == "Instance" and emote:IsA("Animation") then
					-- Non-default emotes
					playEmote(emote, EMOTE_TRANSITION_TIME, Humanoid)
					return true
				end
				-- Return false to indicate that the emote could not be played
				return false
			end
		end
		]]
		-- initialize to idle
		playAnimation("idle", 0.1, Humanoid)
		pose = "Standing"
		-- loop to handle timed state transitions and tool animations
		spawn(function()
			while Character.Parent ~= nil do
				local _, currentGameTime = wait(0.1)
				stepAnimate(currentGameTime)
			end
		end)
		return {
			onRunning = onRunning, 
			onDied = onDied, 
			onJumping = onJumping, 
			onClimbing = onClimbing, 
			onGettingUp = onGettingUp, 
			onFreeFall = onFreeFall, 
			onFallingDown = onFallingDown, 
			onSeated = onSeated, 
			onPlatformStanding = onPlatformStanding,
			onHook = onHook,
			onUnhook = onUnhook
		}
		end
		return r15()
	end
	while true do
		wait(.1)
		if plr.Character ~= nil then
			char = plr.Character
			break
		end
	end
	function _Controller()
		local humanoid = char:WaitForChild("Humanoid")
		local animFuncs = {}
		if (humanoid.RigType == Enum.HumanoidRigType.R6) then
			animFuncs = _R6()
		else
			animFuncs = _R15()
		end
		print("Animation succes")
		return animFuncs
	end
	function _AnimationHandler()
	local AnimationHandler = {}
	AnimationHandler.__index = AnimationHandler
	 
	function AnimationHandler.new(humanoid, animate)
		local self = setmetatable({}, AnimationHandler)
	 
		self._AnimFuncs = _Controller()
		self.Humanoid = humanoid
	 
		return self
	end
	 
	function AnimationHandler:EnableDefault(bool)
		if (bool) then
			self._AnimFuncs.onHook()
		else
			self._AnimFuncs.onUnhook()
		end
	end
	 
	function AnimationHandler:Run(name, ...)
		self._AnimFuncs[name](...)
	end
	 
	return AnimationHandler
	end
	 
	function _GravityController()
	 
	local ZERO = Vector3.new(0, 0, 0)
	local UNIT_X = Vector3.new(1, 0, 0)
	local UNIT_Y = Vector3.new(0, 1, 0)
	local UNIT_Z = Vector3.new(0, 0, 1)
	local VEC_XY = Vector3.new(1, 0, 1)
	 
	local IDENTITYCF = CFrame.new()
	 
	local JUMPMODIFIER = 1.2
	local TRANSITION = 0.15
	local WALKF = 200 / 3
	 
	local UIS = game:GetService("UserInputService")
	local RUNSERVICE = game:GetService("RunService")
	 
	local InitObjects = _InitObjects()
	local AnimationHandler = _AnimationHandler()
	local StateTracker = _StateTracker()
	 
	-- Class
	 
	local GravityController = {}
	GravityController.__index = GravityController
	 
	-- Private Functions
	 
	local function getRotationBetween(u, v, axis)
		local dot, uxv = u:Dot(v), u:Cross(v)
		if (dot < -0.99999) then return CFrame.fromAxisAngle(axis, math.pi) end
		return CFrame.new(0, 0, 0, uxv.x, uxv.y, uxv.z, 1 + dot)
	end
	 
	local function lookAt(pos, forward, up)
		local r = forward:Cross(up)
		local u = r:Cross(forward)
		return CFrame.fromMatrix(pos, r.Unit, u.Unit)
	end
	 
	local function getMass(array)
		local mass = 0
		for _, part in next, array do
			if (part:IsA("BasePart")) then
				mass = mass + part:GetMass()
			end
		end
		return mass
	end
	 
	-- Public Constructor
	local ExecutedPlayerModule = _PlayerModule()
	local ExecutedSounds = _sounds()
	function GravityController.new(player)
		local self = setmetatable({}, GravityController)
	 
		--[[ Camera
		local loaded = player.PlayerScripts:WaitForChild("PlayerScriptsLoader"):WaitForChild("Loaded")
		if (not loaded.Value) then
			--loaded.Changed:Wait()
		end
		]]
		local playerModule = ExecutedPlayerModule
		self.Controls = playerModule:GetControls()
		self.Camera = playerModule:GetCameras()
	 
		-- Player and character
		self.Player = player
		self.Character = player.Character
		self.Humanoid = player.Character:WaitForChild("Humanoid")
		self.HRP = player.Character:WaitForChild("HumanoidRootPart")
	 
		-- Animation
		self.AnimationHandler = AnimationHandler.new(self.Humanoid, self.Character:WaitForChild("Animate"))
		self.AnimationHandler:EnableDefault(false)
		local ssss = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("SetState") or Instance.new("BindableEvent",game:GetService("Players").LocalPlayer.PlayerScripts)
		local soundState = ExecutedSounds
		ssss.Name = "SetState"
	 
		self.StateTracker = StateTracker.new(self.Humanoid, soundState)
		self.StateTracker.Changed:Connect(function(name, speed)
			self.AnimationHandler:Run(name, speed)
		end)
	 
		-- Collider and forces
		local collider, gyro, vForce, floor = InitObjects(self)
	 
		floor.Touched:Connect(function() end)
		collider.Touched:Connect(function() end)
	 
		self.Collider = collider
		self.VForce = vForce
		self.Gyro = gyro
		self.Floor = floor
	 
		-- Attachment to parts
		self.LastPart = workspace.Terrain
		self.LastPartCFrame = IDENTITYCF
	 
		-- Gravity properties
		self.GravityUp = UNIT_Y
		self.Ignores = {self.Character}
	 
		function self.Camera.GetUpVector(this, oldUpVector)
			return self.GravityUp
		end
	 
		-- Events etc
		self.Humanoid.PlatformStand = true
	 
		self.CharacterMass = getMass(self.Character:GetDescendants())
		self.Character.AncestryChanged:Connect(function() self.CharacterMass = getMass(self.Character:GetDescendants()) end)
	 
		self.JumpCon = RUNSERVICE.RenderStepped:Connect(function(dt) 
			if (self.Controls:IsJumping()) then
				self:OnJumpRequest()
			end
		end)
	 
		self.DeathCon = self.Humanoid.Died:Connect(function() self:Destroy() end)
		self.SeatCon = self.Humanoid.Seated:Connect(function(active) if (active) then self:Destroy() end end)
		self.HeartCon = RUNSERVICE.Heartbeat:Connect(function(dt) self:OnHeartbeatStep(dt) end)
		RUNSERVICE:BindToRenderStep("GravityStep", Enum.RenderPriority.Input.Value + 1, function(dt) self:OnGravityStep(dt) end)
	 
	 
		return self
	end
	 
	-- Public Methods
	 
	function GravityController:Destroy()
		self.JumpCon:Disconnect()
		self.DeathCon:Disconnect()
		self.SeatCon:Disconnect()
		self.HeartCon:Disconnect()
	 
		RUNSERVICE:UnbindFromRenderStep("GravityStep")
	 
		self.Collider:Destroy()
		self.VForce:Destroy()
		self.Gyro:Destroy()
		self.StateTracker:Destroy()
	 
		self.Humanoid.PlatformStand = false
		self.AnimationHandler:EnableDefault(true)
	 
		self.GravityUp = UNIT_Y
	end
	 
	function GravityController:GetGravityUp(oldGravity)
		return oldGravity
	end
	 
	function GravityController:IsGrounded(isJumpCheck)
		if (not isJumpCheck) then
			local parts = self.Floor:GetTouchingParts()
			for _, part in next, parts do
				if (not part:IsDescendantOf(self.Character)) then
					return true
				end
			end
		else
			if (self.StateTracker.Jumped) then
				return false
			end
	 
			-- 1. check we are touching something with the collider
			local valid = {}
			local parts = self.Collider:GetTouchingParts()
			for _, part in next, parts do
				if (not part:IsDescendantOf(self.Character)) then
					table.insert(valid, part)
				end
			end
	 
			if (#valid > 0) then
				-- 2. do a decently long downwards raycast
				local max = math.cos(self.Humanoid.MaxSlopeAngle)
				local ray = Ray.new(self.Collider.Position, -10 * self.GravityUp)
				local hit, pos, normal = workspace:FindPartOnRayWithWhitelist(ray, valid, true)
	 
				-- 3. use slope to decide on jump
				if (hit and max <= self.GravityUp:Dot(normal)) then
					return true
				end
			end
		end
		return false
	end
	 
	function GravityController:OnJumpRequest()
		if (not self.StateTracker.Jumped and self:IsGrounded(true)) then
			local hrpVel = self.HRP.Velocity
			self.HRP.Velocity = hrpVel + self.GravityUp*self.Humanoid.JumpPower*JUMPMODIFIER
			self.StateTracker:RequestedJump()
		end
	end
	 
	function GravityController:GetMoveVector()
		return self.Controls:GetMoveVector()
	end
	 
	function GravityController:OnHeartbeatStep(dt)
		local ray = Ray.new(self.Collider.Position, -1.1*self.GravityUp)
		local hit, pos, normal = workspace:FindPartOnRayWithIgnoreList(ray, self.Ignores)
		local lastPart = self.LastPart
	 
		if (hit and lastPart and lastPart == hit) then
			local offset = self.LastPartCFrame:ToObjectSpace(self.HRP.CFrame)
			self.HRP.CFrame = hit.CFrame:ToWorldSpace(offset)
		end
	 
		self.LastPart = hit
		self.LastPartCFrame = hit and hit.CFrame
	end
	 
	function GravityController:OnGravityStep(dt)
		-- update gravity up vector
		local oldGravity = self.GravityUp
		local newGravity = self:GetGravityUp(oldGravity)
	 
		local rotation = getRotationBetween(oldGravity, newGravity, workspace.CurrentCamera.CFrame.RightVector)
		rotation = IDENTITYCF:Lerp(rotation, TRANSITION)
	 
		self.GravityUp = rotation * oldGravity
	 
		-- get world move vector
		local camCF = workspace.CurrentCamera.CFrame
		local fDot = camCF.LookVector:Dot(newGravity)
		local cForward = math.abs(fDot) > 0.5 and -math.sign(fDot)*camCF.UpVector or camCF.LookVector
	 
		local left = cForward:Cross(-newGravity).Unit
		local forward = -left:Cross(newGravity).Unit
	 
		local move = self:GetMoveVector()
		local worldMove = forward*move.z - left*move.x
		worldMove = worldMove:Dot(worldMove) > 1 and worldMove.Unit or worldMove
	 
		local isInputMoving = worldMove:Dot(worldMove) > 0
	 
		-- get the desired character cframe
		local hrpCFLook = self.HRP.CFrame.LookVector
		local charF = hrpCFLook:Dot(forward)*forward + hrpCFLook:Dot(left)*left
		local charR = charF:Cross(newGravity).Unit
		local newCharCF = CFrame.fromMatrix(ZERO, charR, newGravity, -charF)
	 
		local newCharRotation = IDENTITYCF
		if (isInputMoving) then
			newCharRotation = IDENTITYCF:Lerp(getRotationBetween(charF, worldMove, newGravity), 0.7)	
		end
	 
		-- calculate forces
		local g = workspace.Gravity
		local gForce = g * self.CharacterMass * (UNIT_Y - newGravity)
	 
		local cVelocity = self.HRP.Velocity
		local tVelocity = self.Humanoid.WalkSpeed * worldMove
		local gVelocity = cVelocity:Dot(newGravity)*newGravity
		local hVelocity = cVelocity - gVelocity
	 
		if (hVelocity:Dot(hVelocity) < 1) then
			hVelocity = ZERO
		end
	 
		local dVelocity = tVelocity - hVelocity
		local walkForceM = math.min(10000, WALKF * self.CharacterMass * dVelocity.Magnitude / (dt*60))
		local walkForce = walkForceM > 0 and dVelocity.Unit*walkForceM or ZERO
	 
		-- mouse lock
		local charRotation = newCharRotation * newCharCF
	 
		if (self.Camera:IsCamRelative()) then
			local lv = workspace.CurrentCamera.CFrame.LookVector
			local hlv = lv - charRotation.UpVector:Dot(lv)*charRotation.UpVector
			charRotation = lookAt(ZERO, hlv, charRotation.UpVector)
		end
	 
		-- get state
		self.StateTracker:OnStep(self.GravityUp, self:IsGrounded(), isInputMoving)
	 
		-- update values
		self.VForce.Force = walkForce + gForce
		self.Gyro.CFrame = charRotation
	end
	return GravityController
	end
	function _Draw3D()
		local module = {}
	 
		-- Style Guide
	 
		module.StyleGuide = {
			Point = {
				Thickness = 0.5;
				Color = Color3.new(0, 1, 0);
			},
	 
			Line = {
				Thickness = 0.1;
				Color = Color3.new(1, 1, 0);
			},
	 
			Ray = {
				Thickness = 0.1;
				Color = Color3.new(1, 0, 1);
			},
	 
			Triangle = {
				Thickness = 0.05;
			};
	 
			CFrame = {
				Thickness = 0.1;
				RightColor3 = Color3.new(1, 0, 0);
				UpColor3 = Color3.new(0, 1, 0);
				BackColor3 = Color3.new(0, 0, 1);
				PartProperties = {
					Material = Enum.Material.SmoothPlastic;
				};
			}
		}
	 
		-- CONSTANTS
	 
		local WEDGE = Instance.new("WedgePart")
		WEDGE.Material = Enum.Material.SmoothPlastic
		WEDGE.Anchored = true
		WEDGE.CanCollide = false
	 
		local PART = Instance.new("Part")
		PART.Size = Vector3.new(0.1, 0.1, 0.1)
		PART.Anchored = true
		PART.CanCollide = false
		PART.TopSurface = Enum.SurfaceType.Smooth
		PART.BottomSurface = Enum.SurfaceType.Smooth
		PART.Material = Enum.Material.SmoothPlastic
	 
		-- Functions
	 
		local function draw(properties, style)
			local part = PART:Clone()
			for k, v in next, properties do
				part[k] = v
			end
			if (style) then
				for k, v in next, style do
					if (k ~= "Thickness") then
						part[k] = v
					end
				end
			end
			return part
		end
	 
		function module.Draw(parent, properties)
			properties.Parent = parent
			return draw(properties, nil)
		end
	 
		function module.Point(parent, cf_v3)
			local thickness = module.StyleGuide.Point.Thickness
			return draw({
				Size = Vector3.new(thickness, thickness, thickness);
				CFrame = (typeof(cf_v3) == "CFrame" and cf_v3 or CFrame.new(cf_v3));
				Parent = parent;
			}, module.StyleGuide.Point)
		end
	 
		function module.Line(parent, a, b)
			local thickness = module.StyleGuide.Line.Thickness
			return draw({
				CFrame = CFrame.new((a + b)/2, b);
				Size = Vector3.new(thickness, thickness, (b - a).Magnitude);
				Parent = parent;
			}, module.StyleGuide.Line)
		end
	 
		function module.Ray(parent, origin, direction)
			local thickness = module.StyleGuide.Ray.Thickness
			return draw({
				CFrame = CFrame.new(origin + direction/2, origin + direction);
				Size = Vector3.new(thickness, thickness, direction.Magnitude);
				Parent = parent;
			}, module.StyleGuide.Ray)
		end
	 
		function module.Triangle(parent, a, b, c)
			local ab, ac, bc = b - a, c - a, c - b
			local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	 
			if (abd > acd and abd > bcd) then
				c, a = a, c
			elseif (acd > bcd and acd > abd) then
				a, b = b, a
			end
	 
			ab, ac, bc = b - a, c - a, c - b
	 
			local right = ac:Cross(ab).Unit
			local up = bc:Cross(right).Unit
			local back = bc.Unit
	 
			local height = math.abs(ab:Dot(up))
			local width1 = math.abs(ab:Dot(back))
			local width2 = math.abs(ac:Dot(back))
	 
			local thickness = module.StyleGuide.Triangle.Thickness
	 
			local w1 = WEDGE:Clone()
			w1.Size = Vector3.new(thickness, height, width1)
			w1.CFrame = CFrame.fromMatrix((a + b)/2, right, up, back)
			w1.Parent = parent
	 
			local w2 = WEDGE:Clone()
			w2.Size = Vector3.new(thickness, height, width2)
			w2.CFrame = CFrame.fromMatrix((a + c)/2, -right, up, -back)
			w2.Parent = parent
	 
			for k, v in next, module.StyleGuide.Triangle do
				if (k ~= "Thickness") then
					w1[k] = v
					w2[k] = v
				end
			end
	 
			return w1, w2
		end
	 
		function module.CFrame(parent, cf)
			local origin = cf.Position
			local r = cf.RightVector
			local u = cf.UpVector
			local b = -cf.LookVector
	 
			local thickness = module.StyleGuide.CFrame.Thickness
	 
			local right = draw({
				CFrame = CFrame.new(origin + r/2, origin + r);
				Size = Vector3.new(thickness, thickness, r.Magnitude);
				Color = module.StyleGuide.CFrame.RightColor3;
				Parent = parent;
			}, module.StyleGuide.CFrame.PartProperties)
	 
			local up = draw({
				CFrame = CFrame.new(origin + u/2, origin + u);
				Size = Vector3.new(thickness, thickness, r.Magnitude);
				Color = module.StyleGuide.CFrame.UpColor3;
				Parent = parent;
			}, module.StyleGuide.CFrame.PartProperties)
	 
			local back = draw({
				CFrame = CFrame.new(origin + b/2, origin + b);
				Size = Vector3.new(thickness, thickness, u.Magnitude);
				Color = module.StyleGuide.CFrame.BackColor3;
				Parent = parent;
			}, module.StyleGuide.CFrame.PartProperties)
	 
			return right, up, back
		end
	 
		-- Return
	 
		return module
	end
	function _Draw2D()
		local module = {}
	 
		-- Style Guide
	 
		module.StyleGuide = {
			Point = {
				BorderSizePixel = 0;
				Size = UDim2.new(0, 4, 0, 4);
				BorderColor3 = Color3.new(0, 0, 0);
				BackgroundColor3 = Color3.new(0, 1, 0);
			},
	 
			Line = {
				Thickness = 1;
				BorderSizePixel = 0;
				BorderColor3 = Color3.new(0, 0, 0);
				BackgroundColor3 = Color3.new(0, 1, 0);
			},
	 
			Ray = {
				Thickness = 1;
				BorderSizePixel = 0;
				BorderColor3 = Color3.new(0, 0, 0);
				BackgroundColor3 = Color3.new(0, 1, 0);
			},
	 
			Triangle = {
				ImageTransparency = 0;
				ImageColor3 = Color3.new(0, 1, 0);
			}
		}
	 
		-- CONSTANTS
	 
		local HALF = Vector2.new(0.5, 0.5)
	 
		local RIGHT = "rbxassetid://2798177521"
		local LEFT = "rbxassetid://2798177955"
	 
		local IMG = Instance.new("ImageLabel")
		IMG.BackgroundTransparency = 1
		IMG.AnchorPoint = HALF
		IMG.BorderSizePixel = 0
	 
		local FRAME = Instance.new("Frame")
		FRAME.BorderSizePixel = 0
		FRAME.Size = UDim2.new(0, 0, 0, 0)
		FRAME.BackgroundColor3 = Color3.new(1, 1, 1)
	 
		-- Functions
	 
		function draw(properties, style)
			local frame = FRAME:Clone()
			for k, v in next, properties do
				frame[k] = v
			end
			if (style) then
				for k, v in next, style do
					if (k ~= "Thickness") then
						frame[k] = v
					end
				end
			end
			return frame
		end
	 
		function module.Draw(parent, properties)
			properties.Parent = parent
			return draw(properties, nil)
		end
	 
		function module.Point(parent, v2)
			return draw({
				AnchorPoint = HALF;
				Position = UDim2.new(0, v2.x, 0, v2.y);
				Parent = parent;
			}, module.StyleGuide.Point)
		end
	 
		function module.Line(parent, a, b)
			local v = (b - a)
			local m = (a + b)/2
	 
			return draw({
				AnchorPoint = HALF;
				Position = UDim2.new(0, m.x, 0, m.y);
				Size = UDim2.new(0, module.StyleGuide.Line.Thickness, 0, v.magnitude);
				Rotation = math.deg(math.atan2(v.y, v.x)) - 90;
				BackgroundColor3 = Color3.new(1, 1, 0);
				Parent = parent;
			}, module.StyleGuide.Line)
		end
	 
		function module.Ray(parent, origin, direction)
			local a, b = origin, origin + direction
			local v = (b - a)
			local m = (a + b)/2
	 
			return draw({
				AnchorPoint = HALF;
				Position = UDim2.new(0, m.x, 0, m.y);
				Size = UDim2.new(0, module.StyleGuide.Ray.Thickness, 0, v.magnitude);
				Rotation = math.deg(math.atan2(v.y, v.x)) - 90;
				Parent = parent;
			}, module.StyleGuide.Ray)
		end
	 
		function module.Triangle(parent, a, b, c)
			local ab, ac, bc = b - a, c - a, c - b
			local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	 
			if (abd > acd and abd > bcd) then
				c, a = a, c
			elseif (acd > bcd and acd > abd) then
				a, b = b, a
			end
	 
			ab, ac, bc = b - a, c - a, c - b
	 
			local unit = bc.unit
			local height = unit:Cross(ab)
			local flip = (height >= 0)
			local theta = math.deg(math.atan2(unit.y, unit.x)) + (flip and 0 or 180)
	 
			local m1 = (a + b)/2
			local m2 = (a + c)/2
	 
			local w1 = IMG:Clone()
			w1.Image = flip and RIGHT or LEFT
			w1.AnchorPoint = HALF
			w1.Size = UDim2.new(0, math.abs(unit:Dot(ab)), 0, height)
			w1.Position = UDim2.new(0, m1.x, 0, m1.y)
			w1.Rotation = theta
			w1.Parent = parent
	 
			local w2 = IMG:Clone()
			w2.Image = flip and LEFT or RIGHT
			w2.AnchorPoint = HALF
			w2.Size = UDim2.new(0, math.abs(unit:Dot(ac)), 0, height)
			w2.Position = UDim2.new(0, m2.x, 0, m2.y)
			w2.Rotation = theta
			w2.Parent = parent
	 
			for k, v in next, module.StyleGuide.Triangle do
				w1[k] = v
				w2[k] = v
			end
	 
			return w1, w2
		end
	 
		-- Return
	 
		return module
	end
	function _DrawClass()
		local Draw2DModule = _Draw2D()
		local Draw3DModule = _Draw3D()
	 
		--
	 
		local DrawClass = {}
		local DrawClassStorage = setmetatable({}, {__mode = "k"})
		DrawClass.__index = DrawClass
	 
		function DrawClass.new(parent)
			local self = setmetatable({}, DrawClass)
	 
			self.Parent = parent
			DrawClassStorage[self] = {}
	 
			self.Draw3D = {}
			for key, func in next, Draw3DModule do
				self.Draw3D[key] = function(...)
					local returns = {func(self.Parent, ...)}
					for i = 1, #returns do
						table.insert(DrawClassStorage[self], returns[i])
					end
					return unpack(returns)
				end
			end
	 
			self.Draw2D = {}
			for key, func in next, Draw2DModule do
				self.Draw2D[key] = function(...)
					local returns = {func(self.Parent, ...)}
					for i = 1, #returns do
						table.insert(DrawClassStorage[self], returns[i])
					end
					return unpack(returns)
				end
			end
	 
			return self
		end
	 
		--
	 
		function DrawClass:Clear()
			local t = DrawClassStorage[self]
			while (#t > 0) do
				local part = table.remove(t)
				if (part) then
					part:Destroy()
				end
			end
			DrawClassStorage[self] = {}
		end
	 
		--
	 
		return DrawClass
	end
	 
	 
	--END TEST
	 
	local PLAYERS = game:GetService("Players")
	 
	local GravityController = _GravityController()
	local Controller = GravityController.new(PLAYERS.LocalPlayer)
	 
	local DrawClass = _DrawClass()
	 
	local PI2 = math.pi*2
	local ZERO = Vector3.new(0, 0, 0)
	 
	local LOWER_RADIUS_OFFSET = 3 
	local NUM_DOWN_RAYS = 24
	local ODD_DOWN_RAY_START_RADIUS = 3	
	local EVEN_DOWN_RAY_START_RADIUS = 2
	local ODD_DOWN_RAY_END_RADIUS = 1.66666
	local EVEN_DOWN_RAY_END_RADIUS = 1
	 
	local NUM_FEELER_RAYS = 9
	local FEELER_LENGTH = 2
	local FEELER_START_OFFSET = 2
	local FEELER_RADIUS = 3.5
	local FEELER_APEX_OFFSET = 1
	local FEELER_WEIGHTING = 8
	 
	function GetGravityUp(self, oldGravityUp)
		local ignoreList = {}
		for i, player in next, PLAYERS:GetPlayers() do
			ignoreList[i] = player.Character
		end
	 
		-- get the normal
	 
		local hrpCF = self.HRP.CFrame
		local isR15 = (self.Humanoid.RigType == Enum.HumanoidRigType.R15)
	 
		local origin = isR15 and hrpCF.p or hrpCF.p + 0.35*oldGravityUp
		local radialVector = math.abs(hrpCF.LookVector:Dot(oldGravityUp)) < 0.999 and hrpCF.LookVector:Cross(oldGravityUp) or hrpCF.RightVector:Cross(oldGravityUp)
	 
		local centerRayLength = 25
		local centerRay = Ray.new(origin, -centerRayLength * oldGravityUp)
		local centerHit, centerHitPoint, centerHitNormal = workspace:FindPartOnRayWithIgnoreList(centerRay, ignoreList)
	 
		--[[disable
		DrawClass:Clear()
		DrawClass.Draw3D.Ray(centerRay.Origin, centerRay.Direction)
		]]
		local downHitCount = 0
		local totalHitCount = 0
		local centerRayHitCount = 0
		local evenRayHitCount = 0
		local oddRayHitCount = 0
	 
		local mainDownNormal = ZERO
		if (centerHit) then
			mainDownNormal = centerHitNormal
			centerRayHitCount = 0
		end
	 
		local downRaySum = ZERO
		for i = 1, NUM_DOWN_RAYS do
			local dtheta = PI2 * ((i-1)/NUM_DOWN_RAYS)
	 
			local angleWeight = 0.25 + 0.75 * math.abs(math.cos(dtheta))
			local isEvenRay = (i%2 == 0)
			local startRadius = isEvenRay and EVEN_DOWN_RAY_START_RADIUS or ODD_DOWN_RAY_START_RADIUS	
			local endRadius = isEvenRay and EVEN_DOWN_RAY_END_RADIUS or ODD_DOWN_RAY_END_RADIUS
			local downRayLength = centerRayLength
	 
			local offset = CFrame.fromAxisAngle(oldGravityUp, dtheta) * radialVector
			local dir = (LOWER_RADIUS_OFFSET * -oldGravityUp + (endRadius - startRadius) * offset)
			local ray = Ray.new(origin + startRadius * offset, downRayLength * dir.unit)
			local hit, hitPoint, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
			--[[disable
			DrawClass.Draw3D.Ray(ray.Origin, ray.Direction)
			]]
			if (hit) then
				downRaySum = downRaySum + angleWeight * hitNormal
				downHitCount = downHitCount + 1
				if isEvenRay then
					evenRayHitCount = evenRayHitCount + 1					
				else
					oddRayHitCount = oddRayHitCount + 1
				end
			end
		end
	 
		local feelerHitCount = 0	
		local feelerNormalSum = ZERO
	 
		for i = 1, NUM_FEELER_RAYS do
			local dtheta = 2 * math.pi * ((i-1)/NUM_FEELER_RAYS)
			local angleWeight =  0.25 + 0.75 * math.abs(math.cos(dtheta))	
			local offset = CFrame.fromAxisAngle(oldGravityUp, dtheta) * radialVector
			local dir = (FEELER_RADIUS * offset + LOWER_RADIUS_OFFSET * -oldGravityUp).unit
			local feelerOrigin = origin - FEELER_APEX_OFFSET * -oldGravityUp + FEELER_START_OFFSET * dir
			local ray = Ray.new(feelerOrigin, FEELER_LENGTH * dir)
			local hit, hitPoint, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
			--[[disable
			DrawClass.Draw3D.Ray(ray.Origin, ray.Direction)
			]]
			if (hit) then
				feelerNormalSum = feelerNormalSum + FEELER_WEIGHTING * angleWeight * hitNormal --* hitDistSqInv
				feelerHitCount = feelerHitCount + 1
			end
		end
	 
		if (centerRayHitCount + downHitCount + feelerHitCount > 0) then
			local normalSum = mainDownNormal + downRaySum + feelerNormalSum
			if (normalSum ~= ZERO) then
				return normalSum.unit
			end
		end
	 
		return oldGravityUp
	end
	 
	Controller.GetGravityUp = GetGravityUp
	 
	-- E is toggle
	game:GetService("ContextActionService"):BindAction("Toggle", function(action, state, input)
		if not (state == Enum.UserInputState.Begin) then
			return
		end
	 
		if (Controller) then
			Controller:Destroy()
			Controller = nil
		else
			Controller = GravityController.new(PLAYERS.LocalPlayer)
			Controller.GetGravityUp = GetGravityUp
		end
	end, false, Enum.KeyCode.Z)
	print("end")
 end)
 
 cmd.add({"size"}, {"size", "Makes you big"}, function()
	 local LocalPlayer = game:GetService("Players").LocalPlayer
 local Character = LocalPlayer.Character
 local Humanoid = Character:FindFirstChildOfClass("Humanoid")
 
 function rm()
	 for i,v in pairs(Character:GetDescendants()) do
		 if v:IsA("BasePart") then
			 if v.Name == "Handle" or v.Name == "Head" then
				 if Character.Head:FindFirstChild("OriginalSize") then
					 Character.Head.OriginalSize:Destroy()
				 end
			 else
				 for i,cav in pairs(v:GetDescendants()) do
					 if cav:IsA("Attachment") then
						 if cav:FindFirstChild("OriginalPosition") then
							 cav.OriginalPosition:Destroy()  
						 end
					 end
				 end
				 v:FindFirstChild("OriginalSize"):Destroy()
				 if v:FindFirstChild("AvatarPartScaleType") then
					 v:FindFirstChild("AvatarPartScaleType"):Destroy()
				 end
			 end
		 end
	 end
 end
	 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyProportionScale"):Destroy()
 wait(1)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyHeightScale"):Destroy()
 wait(1)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyWidthScale"):Destroy()
 wait(1)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("BodyDepthScale"):Destroy()
 wait(1)
 
 rm()
 wait(0.5)
 Humanoid:FindFirstChild("HeadScale"):Destroy()
 wait(1)
 end)
 
 cmd.add({"holdparts", "hp", "grabparts"}, {"holdparts (hpr, grabparts)", "Holds any unanchored part press ctrl + click"}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "Hold parts loaded, ctrl + click on a part";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	  -- made by joshclark756#7155
 local mouse = game.Players.LocalPlayer:GetMouse()
 local uis = game:GetService("UserInputService")
 
 -- Connect
 mouse.Button1Down:Connect(function()
	-- Check for Target & Left Shift
	if mouse.Target and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
 local npc = mouse.target
 local PlayerCharacter = game:GetService("Players").LocalPlayer.Character
 local PlayerRootPart = PlayerCharacter.HumanoidRootPart
 local A0 = Instance.new("Attachment")
 local AP = Instance.new("AlignPosition")
 local AO = Instance.new("AlignOrientation")
 local A1 = Instance.new("Attachment")
 for _, v in pairs(npc:GetDescendants()) do
 if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
 game:GetService("RunService").Stepped:Connect(function()
 v.CanCollide = false
 end)
 end
 end
 
 for _, v in pairs(PlayerCharacter:GetDescendants()) do
 if v:IsA("BasePart") then
 if v.Name == "HumanoidRootPart" or v.Name == "UpperTorso" or v.Name == "Head" then
 end
 end
 end
 PlayerRootPart.Position = PlayerRootPart.Position+Vector3.new(0, 0, 0)
 A0.Parent = npc
 AP.Parent = npc
 AO.Parent = npc
 AP.Responsiveness = 200
 AP.MaxForce = math.huge
 AO.MaxTorque = math.huge
 AO.Responsiveness = 200
 AP.Attachment0 = A0
 AP.Attachment1 = A1
 AO.Attachment1 =  A1
 AO.Attachment0 = A0
 A1.Parent = PlayerCharacter:FindFirstChild("Right Arm")
 end
 end)
 wait(0.2)
	 -- made by joshclark756#7155
 local mouse = game.Players.LocalPlayer:GetMouse()
 local uis = game:GetService("UserInputService")
 
 -- Connect
 mouse.Button1Down:Connect(function()
	-- Check for Target & Left Shift
	if mouse.Target and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
 local npc = mouse.target
 local PlayerCharacter = game:GetService("Players").LocalPlayer.Character
 local PlayerRootPart = PlayerCharacter.HumanoidRootPart
 local A0 = Instance.new("Attachment")
 local AP = Instance.new("AlignPosition")
 local AO = Instance.new("AlignOrientation")
 local A1 = Instance.new("Attachment")
 for _, v in pairs(npc:GetDescendants()) do
 if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
 game:GetService("RunService").Stepped:Connect(function()
 v.CanCollide = false
 end)
 end
 end
 
 for _, v in pairs(PlayerCharacter:GetDescendants()) do
 if v:IsA("BasePart") then
 if v.Name == "HumanoidRootPart" or v.Name == "UpperTorso" or v.Name == "Head" then
 end
 end
 end
 PlayerRootPart.Position = PlayerRootPart.Position+Vector3.new(0, 0, 0)
 A0.Parent = npc
 AP.Parent = npc
 AO.Parent = npc
 AP.Responsiveness = 200
 AP.MaxForce = math.huge
 AO.MaxTorque = math.huge
 AO.Responsiveness = 200
 AP.Attachment0 = A0
 AP.Attachment1 = A1
 AO.Attachment1 =  A1
 AO.Attachment0 = A0
 A1.Parent = PlayerCharacter.RightHand
 end
 end)
 end)
 
 local hiddenGUIS = {}
 cmd.add({"hideguis"}, {"hideguis", "Hides guis"}, function()
 function FindInTable(tbl,val)
	 if tbl == nil then return false end
	 for _,v in pairs(tbl) do
		 if v == val then return true end
	 end 
	 return false
 end
 
	 for i,v in pairs(game.Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui"):GetDescendants()) do
		 if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and v.Visible then
			 v.Visible = false
			 if not FindInTable(hiddenGUIS,v) then
				 table.insert(hiddenGUIS,v)
			 end
		 end
	 end
 end)
 
 cmd.add({"showguis"}, {"showguis", "Show guis that were hidden using hideguis"}, function()
	 for i,v in pairs(hiddenGUIS) do
		 v.Visible = true
	 end
	 hiddenGUIS = {}
 end)
 
 cmd.add({"spin"}, {"spin {amount}", "Makes your character spin as fast as you want"}, function(...)
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Spinning...";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
	 function getRoot(char)
		 local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
		 return rootPart
	 end
	 
	 local spinSpeed = (...)
		 for i,v in pairs(getRoot(game.Players.LocalPlayer.Character):GetChildren()) do
			 if v.Name == "Spinning" then
				 v:Destroy()
			 end
		 end
		 local Spin = Instance.new("BodyAngularVelocity")
		 Spin.Name = "Spinning"
		 Spin.Parent = getRoot(game.Players.LocalPlayer.Character)
		 Spin.MaxTorque = Vector3.new(0, math.huge, 0)
		 Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
 end)
 
 cmd.add({"unspin"}, {"unspin", "Makes your character unspin"}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "Spin disabled";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 function getRoot(char)
		 local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
		 return rootPart
	 end
	 
	 for i,v in pairs(getRoot(game.Players.LocalPlayer.Character):GetChildren()) do
			 if v.Name == "Spinning" then
				 v:Destroy()
			 end
		 end
 end)
  
 cmd.add({"hidename", "hname"}, {"hidename", "Hides your name only works on billboard uis"}, function()
 for _,item in pairs(workspace[game.Players.LocalPlayer.Name].Head:GetChildren()) do
		 if item:IsA('BillboardGui') then
		 item:Remove()
		 end
 end
	 wait(0.2)
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Name has been hidden, this only works on billboard guis / custom name fonts";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 end)
  
 cmd.add({"gravity", "grav"}, {"gravity <amount> (grav)", "sets game gravity to whatever u want"}, function(...)
 game.Workspace.Gravity = (...)
 end)
 
 cmd.add({"uanograv", "unanchorednograv", "unanchorednogravity"}, {"uanograv (unanchorednograv)", "Makes unanchored parts have 0 gravity"}, function()
	 wait();
	 
	 Notify({
	 Description = "Made unanchored parts have no gravity";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 spawn(function()
	 while true do
		 game.Players.LocalPlayer.MaximumSimulationRadius = math.pow(math.huge,math.huge)*math.huge
		 game.Players.LocalPlayer.SimulationRadius = math.pow(math.huge,math.huge)*math.huge
		 game:GetService("RunService").Stepped:wait()
	 end
 end)
 local function zeroGrav(part)
	 if part:FindFirstChild("BodyForce") then return end
	 local temp = Instance.new("BodyForce")
	 temp.Force = part:GetMass() * Vector3.new(0,workspace.Gravity,0)
	 temp.Parent = part
 end
 
 for i,v in ipairs(workspace:GetDescendants()) do
	 if v:IsA("Part") and v.Anchored == false then
		 if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
			 zeroGrav(v)
		 end
	 end
 end
 
 workspace.DescendantAdded:Connect(function(part)
	 if part:IsA("Part") and part.Anchored == false then
		 if not (part:IsDescendantOf(game.Players.LocalPlayer.Character)) then
			 zeroGrav(part)
		 end
	 end
 end)
 end)
 
 cmd.add({"funfact"}, {"funfact", "Says a random fun fact"}, function()
 local GetURL = game:HttpGet("https://uselessfacts.jsph.pl/random.json?language=en")
	 local HTTP = game:GetService("HttpService"):JSONDecode(GetURL)
	 game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(HTTP.text,"All")
 end)
 
 cmd.add({"fireclickdetectors", "fcd"}, {"fireclickdetectors (fcd)", "Fires every click detector that's in workspace"}, function()
 local ccamount = 0
 
	 for i,v in pairs(game:GetDescendants()) do
		 if v:IsA("ClickDetector") then
				ccamount = ccamount + 1
			 fireclickdetector(v)
		 end
	 end
 
		 
 
 
 wait();
 
 Notify({
 Description = "Fired " .. ccamount .. " amount of click detectors";
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 end)
 
 cmd.add({"tweengotocampos", "tweentocampos", "tweentcp"}, {"tweengotocampos (tweentcp)", "Another version of goto camera position but bypassing more anti-cheats"}, function(...)
 local player = game.Players.LocalPlayer
 local UserInputService = game:GetService("UserInputService")
 local TweenService = game:GetService("TweenService")
 
 -- function to teleport the player to the camera's position using tweening
 local function teleportPlayer()
	 local character = player.Character or player.CharacterAdded:wait(1)
	 local camera = game.Workspace.CurrentCamera
	 local cameraPosition = camera.CFrame.Position
	 
	 -- create a new tween that moves the player's primary part to the camera position
	 local tween = TweenService:Create(character.PrimaryPart, TweenInfo.new(2), {
		 CFrame = CFrame.new(cameraPosition)
	 })
	 
	 tween:Play()
 end
 
 
		 local camera = game.Workspace.CurrentCamera
		 repeat wait() until camera.CFrame ~= CFrame.new()
 
		 teleportPlayer()
   
 end)
 
 cmd.add({"gotopart", "topart"}, {"gotopart {partname} (topart)", "Makes you teleport to a part you want"}, function(...)
	 local parts = game.Workspace:GetChildren()
	 local targetParts = {}
	 for i, child in pairs(parts) do
	 if child.Name == (...) then
	 table.insert(targetParts, child)
	 end
	 end
	 
	 local index = 1
	 game:GetService("RunService").Stepped:Connect(function()
	 if targetParts[index] then
	 game.Players.LocalPlayer.Character:MoveTo(targetParts[index].Position)
	 index = index + 1
	 wait(0.4)
	 end
	 end)
 end)
 
 
 cmd.add({"swim"}, {"swim {speed}", "Swim in the air"}, function(...)
 speaker = game.Players.LocalPlayer
 game.Workspace.Gravity = 0
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
	 speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (...)
	 if (...) == nil then
			 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
			 end
 end)
 
 cmd.add({"unswim"}, {"unswim", "Stops the swim script"}, function(...)
 speaker = game.Players.LocalPlayer
 game.Workspace.Gravity = 168
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
	 speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
	 speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
 end)
 
 cmd.add({"esppart", "partesp"}, {"esppart {partname} (partesp)", "Makes you be able to see any part"}, function(...)
	 local parts = game.Workspace:GetChildren()
	 local targetParts = {}
	 for i, child in pairs(parts) do
	 if child.Name == (...) then
	 table.insert(targetParts, child)
	 end
	 end
	 
	 for i, part in ipairs(targetParts) do
	 -- Create a new BoxHandleAdornment
	 local adornment = Instance.new("BoxHandleAdornment")
	 adornment.Adornee = part
	 adornment.ZIndex = 5
	 adornment.AlwaysOnTop = true
	 adornment.Transparency = 0.5
	 adornment.Color3 = Color3.new(1, 0, 0)
	 
	 adornment.Parent = part.Parent
	 end
 end)
 
 cmd.add({"unesppart", "unpartesp"}, {"unesppart (unpartesp)", "Removes the esp from the parts"}, function(...)
	 local parts = game.Workspace:GetChildren()
 
	 for i, part in ipairs(parts) do
	 if part:IsA("BoxHandleAdornment") then
	 part:Destroy()
	 end
	 end
 end)
 
 cmd.add({"viewpart", "viewp"}, {"viewpart {partname} (vpart)", "Views a part"}, function(...)
	 local parts = game.Workspace:GetChildren()
	 local partList = {}
	 for i, child in pairs(parts) do
		 if child.Name == (...) then
			 table.insert(partList, child)
		 end
	 end
	 
	 local camera = game.Workspace.CurrentCamera
	 camera.CameraType = "Scriptable"
	 
	 local index = 1
	 while true do
		 camera.CoordinateFrame = partList[index].CFrame
		 index = index + 1
		 if index > #partList then
			 index = 1
		 end
		 wait(0.7)
	 end
 end)
 
 cmd.add({"unviewpart", "unviewp"}, {"unviewpart (unviewp)", "Unviews the part"}, function()
	 local camera = game.Workspace.CurrentCamera
	 camera.CameraType = "Custom"	
	 wait(0.2)
	 local workspace = game.Workspace
 Players = game:GetService("Players")
 local speaker = Players.LocalPlayer
 workspace.CurrentCamera:remove()
	 wait(.1)
	 workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA('Humanoid')
	 workspace.CurrentCamera.CameraType = "Custom"
	 speaker.CameraMinZoomDistance = 0.5
	 speaker.CameraMaxZoomDistance = 400
	 speaker.CameraMode = "Classic"
	 speaker.Character.Head.Anchored = false
 end)
 
 cmd.add({"console"}, {"console", "Opens developer console"}, function()
	game.StarterGui:SetCore("DevConsoleVisible", true)
 end)

 loophitbox = false
 cmd.add({"hitbox", "hbox"}, {"hitbox {amount}", "Makes everyones hitbox as much as you want"}, function(h, d)
	 
	if loophitbox == true then
loophitbox = false
	end
 Username = h
 Plr = getPlr(h)
 
 wait();
 
 Notify({
 Description = "Hitbox changed";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 _G.HeadSize = d
	 _G.Disabled = true

	 if _G.HeadSize == nil then
_G.HeadSize = 10
	 end
	 
	 loophitbox = true
 
	 if Username == "all" or Username == "others" then
			game:GetService("RunService").Stepped:Connect(function()
				if loophitbox then
		 for i,v in next, game:GetService('Players'):GetPlayers() do
		 if v.Name ~= game:GetService('Players').LocalPlayer.Name then
		 v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
		 v.Character.HumanoidRootPart.Transparency = 0.9
		 v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
		 v.Character.HumanoidRootPart.Material = "Neon"
		 v.Character.HumanoidRootPart.CanCollide = false
		 end
		end
	end
end)
 else
			game:GetService("RunService").Stepped:Connect(function()
								if loophitbox then
		 Plr.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
		 Plr.Character.HumanoidRootPart.Transparency = 0.7
		 Plr.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
		 Plr.Character.HumanoidRootPart.Material = "Neon"
		 Plr.Character.HumanoidRootPart.CanCollide = false

end
end)
 end
 end)
 
 
 cmd.add({"unhitbox", "unhbox"}, {"unhitbox", "Disables hitbox"}, function(h)
	 Username = h
	 Plr = getPlr(h)
 
		 _G.HeadSize = 5
		 _G.Disabled = false
		 
		 loophitbox = false
	 
		 if Username == "all" or Username == "others" then
			 for i,v in next, game:GetService('Players'):GetPlayers() do
			 if v.Name ~= game:GetService('Players').LocalPlayer.Name then
			 v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
			 v.Character.HumanoidRootPart.Transparency = 1
			 v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
			 v.Character.HumanoidRootPart.Material = "Neon"
			 v.Character.HumanoidRootPart.CanCollide = false
			 end
	 end
	 else
			 Plr.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
			 Plr.Character.HumanoidRootPart.Transparency = 1
			 Plr.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
			 Plr.Character.HumanoidRootPart.Material = "Neon"
			 Plr.Character.HumanoidRootPart.CanCollide = false
	 end
 end)
 
 cmd.add({"breakcars", "bcars"}, {"breakcars (bcars)", "Breaks any car"}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "Car breaker loaded, sit on a vehicle need to be the driver";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 local UserInputService = game:GetService("UserInputService")
 local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
 local Folder = Instance.new("Folder", game:GetService("Workspace"))
 local Part = Instance.new("Part", Folder)
 local Attachment1 = Instance.new("Attachment", Part)
 Part.Anchored = true
 Part.CanCollide = false
 Part.Transparency = 1
 local Updated = Mouse.Hit + Vector3.new(0, 5, 0)
 local NetworkAccess = coroutine.create(function()
	 settings().Physics.AllowSleep = false
	 while game:GetService("RunService").RenderStepped:Wait() do
		 for _, Players in next, game:GetService("Players"):GetPlayers() do
			 if Players ~= game:GetService("Players").LocalPlayer then
				 Players.MaximumSimulationRadius = 0 
				 sethiddenproperty(Players, "SimulationRadius", 0) 
			 end 
		 end
		 game:GetService("Players").LocalPlayer.MaximumSimulationRadius = math.pow(math.huge,math.huge)
		 setsimulationradius(math.huge) 
	 end 
 end) 
 coroutine.resume(NetworkAccess)
 local function ForcePart(v)
	 if v:IsA("Part") and v.Anchored == false and v.Parent:FindFirstChild("Humanoid") == nil and v.Parent:FindFirstChild("Head") == nil and v.Name ~= "Handle" then
		 Mouse.TargetFilter = v
		 for _, x in next, v:GetChildren() do
			 if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
				 x:Destroy()
			 end
		 end
		 if v:FindFirstChild("Attachment") then
			 v:FindFirstChild("Attachment"):Destroy()
		 end
		 if v:FindFirstChild("AlignPosition") then
			 v:FindFirstChild("AlignPosition"):Destroy()
		 end
		 if v:FindFirstChild("Torque") then
			 v:FindFirstChild("Torque"):Destroy()
		 end
		 v.CanCollide = false
		 local Torque = Instance.new("Torque", v)
		 Torque.Torque = Vector3.new(100000, 100000, 100000)
		 local AlignPosition = Instance.new("AlignPosition", v)
		 local Attachment2 = Instance.new("Attachment", v)
		 Torque.Attachment0 = Attachment2
		 AlignPosition.MaxForce = 9999999999999999
		 AlignPosition.MaxVelocity = math.huge
		 AlignPosition.Responsiveness = 200
		 AlignPosition.Attachment0 = Attachment2 
		 AlignPosition.Attachment1 = Attachment1
	 end
 end
 for _, v in next, game:GetService("Workspace"):GetDescendants() do
	 ForcePart(v)
 end
 game:GetService("Workspace").DescendantAdded:Connect(function(v)
	 ForcePart(v)
 end)
 UserInputService.InputBegan:Connect(function(Key, Chat)
	 if Key.KeyCode == Enum.KeyCode.E and not Chat then
		Updated = Mouse.Hit + Vector3.new(0, 5, 0)
	 end
 end)
 spawn(function()
	 while game:GetService("RunService").RenderStepped:Wait() do
		 Attachment1.WorldCFrame = Updated
	 end
 end)
 end)
 
 cmd.add({"firetouchinterests", "fti"}, {"firetouchinterests (fti)", "Fires every Touch Interest that's in workspace"}, function()
 local ftiamount = 0
 
		 for _,v in pairs(workspace:GetDescendants()) do
		 if v:IsA("TouchTransmitter") then
							ftiamount = ftiamount + 1
		 firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0) --0 is touch
		 wait()
		 firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1) -- 1 is untouch
		 end
		 end
 
		 
 
 
 wait();
 
 Notify({
 Description = "Fired " .. ftiamount .. " amount of touch interests";
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 end)
 
 cmd.add({"infjump", "infinitejump"}, {"infjump (infinitejump)", "Makes you be able to jump infinitly"}, function()
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Infinite jump enabled";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
	 _G.infinjump = true
 
 local Player = game:GetService("Players").LocalPlayer
 local Mouse = Player:GetMouse()
 Mouse.KeyDown:connect(function(k)
 if _G.infinjump then
 if k:byte() == 32 then
 Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
 Humanoid:ChangeState("Jumping")
 wait(0.1)
 Humanoid:ChangeState("Seated")
 end
 end
 end)
 end)
 
 cmd.add({"uninfjump", "uninfinitejump"}, {"uninfjump (uninfinitejump)", "Makes you NOT be able to infinitly jump"}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "Infinite jump disabled";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 _G.infinjump = false
 
 local Player = game:GetService("Players").LocalPlayer
 local Mouse = Player:GetMouse()
 Mouse.KeyDown:connect(function(k)
 if _G.infinjump then
 if k:byte() == 32 then
 Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
 Humanoid:ChangeState("Jumping")
 wait(0.1)
 Humanoid:ChangeState("Seated")
 end
 end
 end)
 end)
 
 cmd.add({"xray", "xrayon"}, {"xray (xrayon)", "Makes you be able to see through walls"}, function()
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Xray enabled";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 transparent = true
	 x(transparent)
 end)
 
 cmd.add({"unxray", "xrayoff"}, {"unxray (xrayoff)", "Makes you not be able to see through walls"}, function()
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Xray disabled";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 transparent = false
	 x(transparent)
 end)
 
 cmd.add({"blackhole"}, {"blackhole", "Makes unanchored parts teleport to the black hole"}, function()
	 local UserInputService = game:GetService("UserInputService")
	 local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	 local Folder = Instance.new("Folder", game:GetService("Workspace"))
	 local Part = Instance.new("Part", Folder)
	 local Attachment1 = Instance.new("Attachment", Part)
	 Part.Anchored = true
	 Part.CanCollide = false
	 Part.Transparency = 1
	 local Updated = Mouse.Hit + Vector3.new(0, 5, 0)
	 local NetworkAccess = coroutine.create(function()
		 settings().Physics.AllowSleep = false
		 while game:GetService("RunService").RenderStepped:Wait() do
			 for _, Players in next, game:GetService("Players"):GetPlayers() do
				 if Players ~= game:GetService("Players").LocalPlayer then
					 Players.MaximumSimulationRadius = 0 
					 sethiddenproperty(Players, "SimulationRadius", 0) 
				 end 
			 end
			 game:GetService("Players").LocalPlayer.MaximumSimulationRadius = math.pow(math.huge,math.huge)
		 end 
	 end) 
	 coroutine.resume(NetworkAccess)
	 local function ForcePart(v)
		 if v:IsA("Part") and v.Anchored == false and v.Parent:FindFirstChild("Humanoid") == nil and v.Parent:FindFirstChild("Head") == nil and v.Name ~= "Handle" then
			 Mouse.TargetFilter = v
			 for _, x in next, v:GetChildren() do
				 if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
					 x:Destroy()
				 end
			 end
			 if v:FindFirstChild("Attachment") then
				 v:FindFirstChild("Attachment"):Destroy()
			 end
			 if v:FindFirstChild("AlignPosition") then
				 v:FindFirstChild("AlignPosition"):Destroy()
			 end
			 if v:FindFirstChild("Torque") then
				 v:FindFirstChild("Torque"):Destroy()
			 end
			 v.CanCollide = false
			 local Torque = Instance.new("Torque", v)
			 Torque.Torque = Vector3.new(100000, 100000, 100000)
			 local AlignPosition = Instance.new("AlignPosition", v)
			 local Attachment2 = Instance.new("Attachment", v)
			 Torque.Attachment0 = Attachment2
			 AlignPosition.MaxForce = 9999999999999999
			 AlignPosition.MaxVelocity = math.huge
			 AlignPosition.Responsiveness = 200
			 AlignPosition.Attachment0 = Attachment2 
			 AlignPosition.Attachment1 = Attachment1
		 end
	 end
	 for _, v in next, game:GetService("Workspace"):GetDescendants() do
		 ForcePart(v)
	 end
	 game:GetService("Workspace").DescendantAdded:Connect(function(v)
		 ForcePart(v)
	 end)
	 UserInputService.InputBegan:Connect(function(Key, Chat)
		 if Key.KeyCode == Enum.KeyCode.E and not Chat then
			Updated = Mouse.Hit + Vector3.new(0, 5, 0)
		 end
	 end)
	 spawn(function()
		 while game:GetService("RunService").RenderStepped:Wait() do
			 Attachment1.WorldCFrame = Updated
		 end
	 end)
	 
	 
	 
	 wait();
	 
	 Notify({
	 Description = "Blackhole has been loaded, press e to change the position to where your mouse is";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 end)
 
 cmd.add({"fullbright", "fullb"}, {"fullbright (fullb)", "Makes games that are really dark to have no darkness and be really light"}, function()
	 if not _G.FullBrightExecuted then
 
		 _G.FullBrightEnabled = false
	 
		 _G.NormalLightingSettings = {
			 Brightness = game:GetService("Lighting").Brightness,
			 ClockTime = game:GetService("Lighting").ClockTime,
			 FogEnd = game:GetService("Lighting").FogEnd,
			 GlobalShadows = game:GetService("Lighting").GlobalShadows,
			 Ambient = game:GetService("Lighting").Ambient
		 }
	 
		 game:GetService("Lighting"):GetPropertyChangedSignal("Brightness"):Connect(function()
			 if game:GetService("Lighting").Brightness ~= 1 and game:GetService("Lighting").Brightness ~= _G.NormalLightingSettings.Brightness then
				 _G.NormalLightingSettings.Brightness = game:GetService("Lighting").Brightness
				 if not _G.FullBrightEnabled then
					 repeat
						 wait()
					 until _G.FullBrightEnabled
				 end
				 game:GetService("Lighting").Brightness = 1
			 end
		 end)
	 
		 game:GetService("Lighting"):GetPropertyChangedSignal("ClockTime"):Connect(function()
			 if game:GetService("Lighting").ClockTime ~= 12 and game:GetService("Lighting").ClockTime ~= _G.NormalLightingSettings.ClockTime then
				 _G.NormalLightingSettings.ClockTime = game:GetService("Lighting").ClockTime
				 if not _G.FullBrightEnabled then
					 repeat
						 wait()
					 until _G.FullBrightEnabled
				 end
				 game:GetService("Lighting").ClockTime = 12
			 end
		 end)
	 
		 game:GetService("Lighting"):GetPropertyChangedSignal("FogEnd"):Connect(function()
			 if game:GetService("Lighting").FogEnd ~= 786543 and game:GetService("Lighting").FogEnd ~= _G.NormalLightingSettings.FogEnd then
				 _G.NormalLightingSettings.FogEnd = game:GetService("Lighting").FogEnd
				 if not _G.FullBrightEnabled then
					 repeat
						 wait()
					 until _G.FullBrightEnabled
				 end
				 game:GetService("Lighting").FogEnd = 786543
			 end
		 end)
	 
		 game:GetService("Lighting"):GetPropertyChangedSignal("GlobalShadows"):Connect(function()
			 if game:GetService("Lighting").GlobalShadows ~= false and game:GetService("Lighting").GlobalShadows ~= _G.NormalLightingSettings.GlobalShadows then
				 _G.NormalLightingSettings.GlobalShadows = game:GetService("Lighting").GlobalShadows
				 if not _G.FullBrightEnabled then
					 repeat
						 wait()
					 until _G.FullBrightEnabled
				 end
				 game:GetService("Lighting").GlobalShadows = false
			 end
		 end)
	 
		 game:GetService("Lighting"):GetPropertyChangedSignal("Ambient"):Connect(function()
			 if game:GetService("Lighting").Ambient ~= Color3.fromRGB(178, 178, 178) and game:GetService("Lighting").Ambient ~= _G.NormalLightingSettings.Ambient then
				 _G.NormalLightingSettings.Ambient = game:GetService("Lighting").Ambient
				 if not _G.FullBrightEnabled then
					 repeat
						 wait()
					 until _G.FullBrightEnabled
				 end
				 game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
			 end
		 end)
	 
		 game:GetService("Lighting").Brightness = 1
		 game:GetService("Lighting").ClockTime = 12
		 game:GetService("Lighting").FogEnd = 786543
		 game:GetService("Lighting").GlobalShadows = false
		 game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
	 
		 local LatestValue = true
		 spawn(function()
			 repeat
				 wait()
			 until _G.FullBrightEnabled
			 while wait() do
				 if _G.FullBrightEnabled ~= LatestValue then
					 if not _G.FullBrightEnabled then
						 game:GetService("Lighting").Brightness = _G.NormalLightingSettings.Brightness
						 game:GetService("Lighting").ClockTime = _G.NormalLightingSettings.ClockTime
						 game:GetService("Lighting").FogEnd = _G.NormalLightingSettings.FogEnd
						 game:GetService("Lighting").GlobalShadows = _G.NormalLightingSettings.GlobalShadows
						 game:GetService("Lighting").Ambient = _G.NormalLightingSettings.Ambient
					 else
						 game:GetService("Lighting").Brightness = 1
						 game:GetService("Lighting").ClockTime = 12
						 game:GetService("Lighting").FogEnd = 786543
						 game:GetService("Lighting").GlobalShadows = false
						 game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
					 end
					 LatestValue = not LatestValue
				 end
			 end
		 end)
	 end
	 
	 _G.FullBrightExecuted = true
	 _G.FullBrightEnabled = not _G.FullBrightEnabled
 end)
 
 cmd.add({"givehat", "givehatui"}, {"givehat (givehatui)", "Executes a hat giver gui check in console for hat names"}, function()
	print("What accessories you have on")
	for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("Accessory") then
			print("What accessories you have on")
			print(v.Name)
		end
	end
	wait()
	local plr = game:GetService"Players".LocalPlayer
	
	function mOut(txt, type)
		if type == 1 then
			spawn(function()
				local m = Instance.new("Message", game.CoreGui)
				m.Text = txt
				task.wait(3)
				m:Destroy()
			end)
		elseif type == 2 then
			spawn(function()
				local h = Instance.new("Hint", game.CoreGui)
				h.Text = txt
				task.wait(3)
				h:Destroy()
			end)
		end
	end
	-- Gui to Lua
	-- Version: 3.2
	
	-- Instances:
	
	local ScreenGui = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local Container = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIGradient = Instance.new("UIGradient")
	local Topbar = Instance.new("Frame")
	local Icon = Instance.new("ImageLabel")
	local Exit = Instance.new("TextButton")
	local ImageLabel = Instance.new("ImageLabel")
	local Minimize = Instance.new("TextButton")
	local ImageLabel_2 = Instance.new("ImageLabel")
	local TopBar = Instance.new("Frame")
	local ImageLabel_3 = Instance.new("ImageLabel")
	local ImageLabel_4 = Instance.new("ImageLabel")
	local Title = Instance.new("TextLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIGradient_2 = Instance.new("UIGradient")
	local Punish = Instance.new("TextBox")
	local UICorner_3 = Instance.new("UICorner")
	local SilentCMD = Instance.new("TextBox")
	local UICorner_4 = Instance.new("UICorner")
	local SilentC = Instance.new("TextButton")
	local UICorner_5 = Instance.new("UICorner")
	
	--Properties:
	
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Main.BackgroundTransparency = 0.140
	Main.BorderColor3 = Color3.fromRGB(139, 139, 139)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.651976228, 0, 0.453526437, 0)
	Main.Size = UDim2.new(0, 402, 0, 218)
	Main.Active = true
	Main.Draggable = true
	
	Container.Name = "Container"
	Container.Parent = Main
	Container.AnchorPoint = Vector2.new(0.5, 1)
	Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Container.BackgroundTransparency = 0.500
	Container.BorderColor3 = Color3.fromRGB(255, 255, 255)
	Container.BorderSizePixel = 0
	Container.ClipsDescendants = true
	Container.Position = UDim2.new(0.5, 0, 0.996153831, -5)
	Container.Size = UDim2.new(1, -10, 1.00769234, -30)
	
	UICorner.CornerRadius = UDim.new(0, 9)
	UICorner.Parent = Container
	
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
	UIGradient.Parent = Container
	
	Topbar.Name = "Topbar"
	Topbar.Parent = Main
	Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Topbar.BackgroundTransparency = 1.000
	Topbar.Size = UDim2.new(1, 0, 0, 25)
	
	Icon.Name = "Icon"
	Icon.Parent = Topbar
	Icon.AnchorPoint = Vector2.new(0, 0.5)
	Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon.BackgroundTransparency = 1.000
	Icon.Position = UDim2.new(0, 10, 0.5, 0)
	Icon.Size = UDim2.new(0, 13, 0, 13)
	Icon.Image = "rbxgameasset://Images/menuIcon"
	
	Exit.Name = "Exit"
	Exit.Parent = Topbar
	Exit.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
	Exit.BackgroundTransparency = 0.500
	Exit.BorderSizePixel = 0
	Exit.Position = UDim2.new(0.870000005, 0, 0, 0)
	Exit.Size = UDim2.new(-0.00899999961, 40, 1.04299998, -10)
	Exit.Font = Enum.Font.Gotham
	Exit.Text = "X"
	Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
	Exit.TextSize = 13.000
	
	ImageLabel.Parent = Exit
	ImageLabel.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	ImageLabel.BackgroundTransparency = 1.000
	ImageLabel.Position = UDim2.new(0.999998331, 0, 0, 0)
	ImageLabel.Size = UDim2.new(0, 9, 0, 16)
	ImageLabel.Image = "http://www.roblox.com/asset/?id=8650484523"
	ImageLabel.ImageColor3 = Color3.fromRGB(12, 4, 20)
	ImageLabel.ImageTransparency = 0.500
	
	Minimize.Name = "Minimize"
	Minimize.Parent = Topbar
	Minimize.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
	Minimize.BackgroundTransparency = 0.500
	Minimize.BorderSizePixel = 0
	Minimize.Position = UDim2.new(0.804174006, 0, 0, 0)
	Minimize.Size = UDim2.new(0.00100000005, 27, 1.04299998, -10)
	Minimize.Font = Enum.Font.Gotham
	Minimize.Text = "-"
	Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
	Minimize.TextSize = 18.000
	
	ImageLabel_2.Parent = Minimize
	ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel_2.BackgroundTransparency = 1.000
	ImageLabel_2.Position = UDim2.new(-0.453000009, 0, 0, 0)
	ImageLabel_2.Size = UDim2.new(0, 12, 0, 16)
	ImageLabel_2.Image = "http://www.roblox.com/asset/?id=10555881849"
	ImageLabel_2.ImageColor3 = Color3.fromRGB(12, 4, 20)
	ImageLabel_2.ImageTransparency = 0.500
	
	TopBar.Name = "TopBar"
	TopBar.Parent = Topbar
	TopBar.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
	TopBar.BackgroundTransparency = 0.500
	TopBar.BorderSizePixel = 0
	TopBar.Position = UDim2.new(0.268202901, 0, -0.00352294743, 0)
	TopBar.Size = UDim2.new(0, 186, 0, 16)
	
	ImageLabel_3.Parent = TopBar
	ImageLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel_3.BackgroundTransparency = 1.000
	ImageLabel_3.Position = UDim2.new(1, 0, 0.0590000004, 0)
	ImageLabel_3.Size = UDim2.new(0, 12, 0, 15)
	ImageLabel_3.Image = "http://www.roblox.com/asset/?id=8650484523"
	ImageLabel_3.ImageColor3 = Color3.fromRGB(12, 4, 20)
	ImageLabel_3.ImageTransparency = 0.500
	
	ImageLabel_4.Parent = TopBar
	ImageLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel_4.BackgroundTransparency = 1.000
	ImageLabel_4.Position = UDim2.new(-0.0817726701, 0, 0, 0)
	ImageLabel_4.Size = UDim2.new(0, 16, 0, 16)
	ImageLabel_4.Image = "http://www.roblox.com/asset/?id=10555881849"
	ImageLabel_4.ImageColor3 = Color3.fromRGB(12, 4, 20)
	ImageLabel_4.ImageTransparency = 0.500
	
	Title.Name = "Title"
	Title.Parent = TopBar
	Title.AnchorPoint = Vector2.new(0, 0.5)
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(-0.150533721, 32, 0.415876389, 0)
	Title.Size = UDim2.new(0.522161067, 80, 1.11675644, -7)
	Title.Font = Enum.Font.SourceSansLight
	Title.Text = "Give Hat"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 17.000
	Title.TextWrapped = true
	
	UICorner_2.CornerRadius = UDim.new(0, 9)
	UICorner_2.Parent = Main
	
	UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 4, 20)), ColorSequenceKeypoint.new(0.38, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(0.68, Color3.fromRGB(4, 4, 4)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 4, 20))}
	UIGradient_2.Parent = Main
	
	Punish.Name = "Punish"
	Punish.Parent = Main
	Punish.BackgroundColor3 = Color3.fromRGB(10, 3, 17)
	Punish.BackgroundTransparency = 0.500
	Punish.Position = UDim2.new(0.206467807, 0, 0.192345411, 0)
	Punish.Size = UDim2.new(0, 234, 0, 40)
	Punish.Font = Enum.Font.SourceSans
	Punish.PlaceholderText = "Player name"
	Punish.Text = ""
	Punish.TextColor3 = Color3.fromRGB(255, 255, 255)
	Punish.TextSize = 14.000
	
	UICorner_3.Parent = Punish
	
	SilentCMD.Name = "SilentCMD"
	SilentCMD.Parent = Main
	SilentCMD.BackgroundColor3 = Color3.fromRGB(10, 3, 17)
	SilentCMD.BackgroundTransparency = 0.500
	SilentCMD.Position = UDim2.new(0.216417909, 0, 0.440437019, 0)
	SilentCMD.Size = UDim2.new(0, 227, 0, 38)
	SilentCMD.Font = Enum.Font.SourceSans
	SilentCMD.PlaceholderText = "Hat name"
	SilentCMD.Text = ""
	SilentCMD.TextColor3 = Color3.fromRGB(255, 255, 255)
	SilentCMD.TextSize = 14.000
	
	UICorner_4.Parent = SilentCMD
	
	SilentC.Name = "SilentC"
	SilentC.Parent = Main
	SilentC.BackgroundColor3 = Color3.fromRGB(10, 3, 17)
	SilentC.BackgroundTransparency = 0.500
	SilentC.Position = UDim2.new(0.226368293, 0, 0.722879827, 0)
	SilentC.Size = UDim2.new(0, 217, 0, 34)
	SilentC.Font = Enum.Font.SourceSans
	SilentC.Text = "Hat em'"
	SilentC.TextColor3 = Color3.fromRGB(255, 255, 255)
	SilentC.TextSize = 20.000
	SilentC.TextWrapped = true
	
	UICorner_5.Parent = SilentC
	
	-- Scripts:
	
	local function RNBIV_fake_script() -- Exit.LocalScript 
		local script = Instance.new('LocalScript', Exit)
	
		script.Parent.MouseButton1Click:Connect(function()
			script.Parent.Parent.Parent.Parent:Destroy()
		end)
	end
	
	function getPlayer(shortcut)
		local player = nil
		local g = game.Players:GetPlayers()
		for i = 1, #g do
			if string.lower(string.sub(g[i].Name,1,string.len(shortcut))) == string.lower(shortcut) then
				if g[i] ~= nil then
					player = g[i]
					break
				end
			end
		end
		return player
	end
	
	function getHat(shortcuts)
		local hat = nil
		for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("Accessory") then
				if string.lower(string.sub(v.Name,1,string.len(shortcuts))) == string.lower(shortcuts) then
					if v.Name ~= nil then
						hat = v
						break
					end
				end
			end
		end
		return hat
	end
	
	local runcode = true
	local spawntime = game.Players.RespawnTime + 3
	
	local hatstored = {}
	
	SilentC.MouseButton1Click:Connect(function()
		local char = game.Players.LocalPlayer.Character
		if runcode then
			runcode = true
			local dfc = game.ReplicatedStorage.DefaultChatSystemChatEvents
			local smr = dfc.SayMessageRequest
	
			local hatse = getHat(SilentCMD.Text)
			local arg = getPlayer(Punish.Text)
	
			if table.find(hatstored, hatse.Name) then
				mOut("Hat is already given away, error", 1)
				return end
	
			argplr = game.Players[arg.Name].Character
	
			local rs = game:GetService("RunService")
			local fc
			local dc
			local dic
			local coc
			char.Archivable = true
			headname = char.Head.Name
			local cchar = char:Clone()
			cchar.Parent = Workspace
			wait()
			Main.Visible = false
			runcode = true
			table.clear(hatstored)
			wait(0.2)
			Main.Visible = true
			runcode = true
	
			local con
			con = char.Humanoid.Died:Connect(function()
				cchar:Destroy()
				Main.Visible = false
				runcode = true
				mOut("Wait For "..tostring(spawntime).." Second", 1)
				table.clear(hatstored)
				task.wait(spawntime)
				Main.Visible = true
				runcode = true
				con:Disconnect()
			end)
	
			if fakeadmin then
				smr:FireServer(";givehat "..hatse.Name.." "..arg.Name, "All")
			end
	
			cchar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
			for i, x in pairs(cchar:GetDescendants()) do
				if x:IsA("BasePart") then
					x.Transparency = 1
				end
			end
			for i, v in pairs(cchar.Head:GetDescendants()) do
				if v.className == "Decal" or v.className == "Texture" then
					v.Transparency = 1
				end
			end
	
			for i,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then
					fc = rs.Heartbeat:Connect(function()
						if char.Humanoid.Health <= 0 then fc:Disconnect() return end
						v.Velocity = Vector3.new(30, 4, 0)
						v.RotVelocity = Vector3.new(30, 4, 0)
					end)
				end
	
				dic = rs.RenderStepped:Connect(function()
					setscriptable(plr, "SimulationRadius", true)
					plr.SimulationRadius = math.huge * math.huge, math.huge * math.huge * 1 / 0 * 1 / 0 * 1 / 0 * 1 / 0 * 1 / 0
				end)
	
				coc = plr.SimulationRadiusChanged:Connect(function(radius)
					radius = math.huge
					return radius
				end)
	
				char[hatse.Name].Handle.AccessoryWeld:Destroy()
	
				dc = rs.RenderStepped:Connect(function()
					if char.Humanoid.Health <= 0 then dc:Disconnect() cchar:Destroy() coc:Disconnect() dic:Disconnect() return end
					cchar.HumanoidRootPart.CFrame = argplr.HumanoidRootPart.CFrame
					char[hatse.Name].Handle.CFrame = cchar[hatse.Name].Handle.CFrame
				end)
				table.insert(hatstored, hatse.Name)
			end
			runcode = true
		end
	
		X.MouseButton1Click:Connect(function()
			Main.Visible = false
		end)
	
		mOut("Hat Giver Has Loaded", 2)
		wait(0.2)
		print("What accessories you have on")
		for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("Accessory") then
				print("What accessories you have on")
				print(v.Name)
			end
		end
	end)
 end)
 
 cmd.add({"fireproximityprompts", "fpp"}, {"fireproximityprompts (fpp)", "Fires every Touch Interest that's in workspace"}, function()
 fppamount = 0
 
 for i,v in pairs(game.Workspace:GetDescendants()) do
		 if v:IsA("Part") and v.Name == "BanditClick" then
			 fppamount = fppamount + 1
			 fireproximityprompt(v.Proximity)
		 end
 end
  
	  
 
 
 wait();
 
 Notify({
 Description = "Fired " .. fppamount .. " of proximity prompts";
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 end)
 
 
 cmd.add({"chatspy"}, {"chatspy", "Spies on chat, enables chat, spies whispers etc."}, function()

    -- This script reveals ALL hidden messages in the default chat
    -- Chat "/spy" to toggle!
    enabled = true
    -- If true will check your messages too
    spyOnMyself = true
    -- If true will chat the logs publicly (fun, risky)
    public = false
    -- If true will use /me to stand out
    publicItalics = true
    -- Customize private logs
    privateProperties = {
        Color = Color3.fromRGB(0, 255, 255),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    }
    --////////////////////////////////////////////////////////////////
    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
    local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
    local instance = (_G.chatSpyInstance or 0) + 1
    _G.chatSpyInstance = instance

    local function onChatted(p, msg)
        if _G.chatSpyInstance == instance then
            if p == player and msg:lower():sub(1, 4) == "/spy" then
                enabled = not enabled
                wait(0.3)
                print("XD")
                StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
            elseif enabled and (spyOnMyself == true or p ~= player) then
                msg = msg:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
                local hidden = true
                local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
                    if packet.SpeakerUserId == p.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) and (channel == "All" or (channel == "Team" and public == false and Players[packet.FromSpeaker].Team == player.Team)) then
                        hidden = false
                    end
                end)
                wait(1)
                conn:Disconnect()
                if hidden and enabled then
                    if public then
                        saymsg:FireServer((publicItalics and "/me " or '') .. "{SPY} [" .. p.Name .. "]: " .. msg, "All")
                    else
                        privateProperties.Text = "{SPY} [" .. p.Name .. "]: " .. msg
                        StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
                    end
                end
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg) onChatted(p, msg) end)
    end
    Players.PlayerAdded:Connect(function(p)
        p.Chatted:Connect(function(msg) onChatted(p, msg) end)
    end)
    print("XD")
    StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
    local chatFrame = player.PlayerGui.Chat.Frame
    chatFrame.ChatChannelParentFrame.Visible = true
    chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), chatFrame.ChatChannelParentFrame.Size.Y)

	wait();

	Notify({
		Description = "Chat spy enabled";
		Title = "Nameless Admin";
		Duration = 5;
	});
end)



 cmd.add({"bhop"}, {"bhop", "bhop bhop bhop bhop bhop bhop bhop bla bla bla idk what im saying"}, function()
	 -- [[ bhop functions ]] -- 
	 local player
	 local character
	 local collider
	 local camera
	 local input
	 local collider
	 local playerGrounded
	 local playerVelocity
	 local jumping
	 local moveInputSum
	 local dt = 1/60
	 local partYRatio
	 local partZRatio
	 local cameraYaw
	 local cameraLook
	 local movementPosition
	 local movementVelocity
	 local gravityForce
	 local airAccelerate
	 local airMaxSpeed
	 local groundAccelerate
	 local groundMaxVelocity
	 local friction
	 local playerTorsoToGround
	 local movementStickDistance
	 local jumpVelocity
	 local movementPositionForce
	 local movementVelocityForce
	 local maxMovementPitch
	 local rayYLength
	 local movementPositionD
	 local movementPositionP
	 local movementVelocityP
	 local gravity
	 
	 
	 
	 function init(Player, Camera, Input)
		 player = Player
		 character = player.Character
		 collider = character.HumanoidRootPart
		 camera = Camera
		 input = Input
		 playerVelocity = 0
		 playerGrounded = false
		 moveInputSum = {
		 ["forward"] = 0,
		 ["side"] 	= 0 --left is positive
		 }
		 
		 airAccelerate 			= 10000
		 airMaxSpeed 			= 2.4
		 groundAccelerate 		= 250
		 groundMaxVelocity 		= 20
		 friction			 	= 10
		 playerTorsoToGround 	= 3
		 movementStickDistance 	= 0.5
		 jumpVelocity 			= 52.5
		 movementPositionForce	= 400000
		 movementVelocityForce	= 300000
		 maxMovementPitch		= 0.6
		 rayYLength				= playerTorsoToGround + movementStickDistance
		 movementPositionD		= 125
		 movementPositionP		= 14000
		 movementVelocityP		= 1500
		 gravity					= 0.4
		 
	 end
	 
	 function initBodyMovers()
		 movementPosition = Instance.new("BodyPosition", collider)
		 movementPosition.Name = "movementPosition"
		 movementPosition.D = movementPositionD
		 movementPosition.P = movementPositionP
		 movementPosition.maxForce = Vector3.new()
		 movementPosition.position = Vector3.new()
		 
		 movementVelocity = Instance.new("BodyVelocity", collider)
		 movementVelocity.Name = "movementVelocity"
		 movementVelocity.P = movementVelocityP
		 movementVelocity.maxForce = Vector3.new()
		 movementVelocity.velocity = Vector3.new()
		 
		 gravityForce = Instance.new("BodyForce", collider)
		 gravityForce.Name = "gravityForce"
		 gravityForce.force = Vector3.new(0, (1-gravity)*196.2, 0) * getCharacterMass()
	 end
	 
	 function update(deltaTime)
		 dt = deltaTime
		 updateMoveInputSum()
		 cameraYaw = getYaw()
		 cameraLook = cameraYaw.lookVector	
		 if cameraLook == nil then
			 return
		 end
		 local hitPart, hitPosition, hitNormal, yRatio, zRatio = findCollisionRay()
		 partYRatio = yRatio
		 partZRatio = zRatio
		 
		 playerGrounded = hitPart ~= nil and true or false
		 playerVelocity = collider.Velocity - Vector3.new(0, collider.Velocity.y, 0)
		 if playerGrounded and (input["Space"] or jumping) then
			 jumping = true
		 else
			 jumping = false
		 end
		 
		 setCharacterRotation()
		 if jumping then
			 jump()
		 elseif playerGrounded then
			 run(hitPosition)
		 else
			 air()		
		 end
		 
	 end
	 
	 function updateMoveInputSum()
		 moveInputSum["forward"] = input["W"] == true and 1 or 0
		 moveInputSum["forward"] = input["S"] == true and moveInputSum["forward"] - 1 or moveInputSum["forward"]
		 moveInputSum["side"] = input["A"] == true and 1 or 0
		 moveInputSum["side"] = input["D"] == true and moveInputSum["side"] - 1 or moveInputSum["side"]
	 end
	 
	 function findCollisionRay()
		 local torsoCFrame = character.HumanoidRootPart.CFrame
		 local ignoreList = {character, camera}
		 local rays = {
			 Ray.new(character.HumanoidRootPart.Position, Vector3.new(0, -rayYLength, 0)),
			 Ray.new((torsoCFrame * CFrame.new(-0.8,0,0)).p, Vector3.new(0, -rayYLength, 0)),
			 Ray.new((torsoCFrame * CFrame.new(0.8,0,0)).p, Vector3.new(0, -rayYLength, 0)),
			 Ray.new((torsoCFrame * CFrame.new(0,0,0.8)).p, Vector3.new(0, -rayYLength, 0)),
			 Ray.new((torsoCFrame * CFrame.new(0,0,-0.8)).p, Vector3.new(0, -rayYLength, 0))
		 }
		 local rayReturns  = {}
		 
		 local i
		 for i = 1, #rays do
			 local part, position, normal = game.Workspace:FindPartOnRayWithIgnoreList(rays[i],ignoreList)
			 if part == nil then
				 position = Vector3.new(0,-3000000,0)
			 end
			 if i == 1 then
				 table.insert(rayReturns, {part, position, normal})
			 else
				 local yPos = position.y
				 if yPos <= rayReturns[#rayReturns][2].y then
					 table.insert(rayReturns, {part, position, normal})
				 else 
					 local j
					 for j = 1, #rayReturns do
						 if yPos >= rayReturns[j][2].y then
							 table.insert(rayReturns, j, {part, position, normal})
						 end
					 end
				 end
			 end
		 end
		 
		 i = 1
		 local yRatio, zRatio = getPartYRatio(rayReturns[i][3])
		 while magnitude2D(yRatio, zRatio) > maxMovementPitch and i<#rayReturns do
			 i = i + 1
			 if rayReturns[i][1] then
				 yRatio, zRatio = getPartYRatio(rayReturns[i][3])
			 end
		 end
		 
		 return rayReturns[i][1], rayReturns[i][2], rayReturns[i][3], yRatio, zRatio
	 end
	 
	 function setCharacterRotation()
		 local rotationLook = collider.Position + camera.CoordinateFrame.lookVector
		 collider.CFrame = CFrame.new(collider.Position, Vector3.new(rotationLook.x, collider.Position.y, rotationLook.z))
		 collider.RotVelocity = Vector3.new()
	 end
	 
	 function jump()
		 collider.Velocity = Vector3.new(collider.Velocity.x, jumpVelocity, collider.Velocity.z)
		 air()
	 end
	 
	 function air()
		 movementPosition.maxForce = Vector3.new()
		 movementVelocity.velocity = getMovementVelocity(collider.Velocity, airAccelerate, airMaxSpeed)
		 movementVelocity.maxForce = getMovementVelocityAirForce()
	 end
	 
	 function run(hitPosition)
		 local playerSpeed = collider.Velocity.magnitude
		 local mVelocity = collider.Velocity
		 
		 if playerSpeed ~= 0 then
			 local drop = playerSpeed * friction * dt;
			 mVelocity = mVelocity * math.max(playerSpeed - drop, 0) / playerSpeed;
		 end
		 
		 movementPosition.position = hitPosition + Vector3.new(0,playerTorsoToGround,0)
		 movementPosition.maxForce = Vector3.new(0,movementPositionForce,0)
		 movementVelocity.velocity = getMovementVelocity(mVelocity, groundAccelerate, groundMaxVelocity)
		 local VelocityForce = getMovementVelocityForce()
		 movementVelocity.maxForce = VelocityForce
		 movementVelocity.P = movementVelocityP
	 end
	 
	 function getMovementVelocity(prevVelocity, accelerate, maxVelocity)
		 local accelForward = cameraLook * moveInputSum["forward"]
		 local accelSide = (cameraYaw * CFrame.Angles(0,math.rad(90),0)).lookVector * moveInputSum["side"];
		 local accelDir = (accelForward+accelSide).unit;
		 if moveInputSum["forward"] == 0 and moveInputSum["side"] == 0 then --avoids divide 0 errors
			 accelDir = Vector3.new(0,0,0);
		 end
		 
		 local projVel =  prevVelocity:Dot(accelDir);
		 local accelVel = accelerate * dt;
		 
		 if (projVel + accelVel > maxVelocity) then
			 accelVel = math.max(maxVelocity - projVel, 0);
		 end
		 
		 return prevVelocity + accelDir * accelVel;
	 end
	 
	 function getMovementVelocityForce()
	 
		 return Vector3.new(movementVelocityForce,0,movementVelocityForce)
	 end
	 
	 function getMovementVelocityAirForce()
		 local accelForward = cameraLook * moveInputSum["forward"];
		 local accelSide = (cameraYaw * CFrame.Angles(0,math.rad(90),0)).lookVector * moveInputSum["side"]
		 local accelDir = (accelForward+accelSide).unit
		 if moveInputSum["forward"] == 0 and moveInputSum["side"] == 0 then
			 accelDir = Vector3.new(0,0,0);
		 end
		 
		 local xp = math.abs(accelDir.x)
		 local zp = math.abs(accelDir.z)
		 
		 return Vector3.new(movementVelocityForce*xp,0,movementVelocityForce*zp)
	 end
	 
	 function getPartYRatio(normal)
		 local partYawVector = Vector3.new(-normal.x, 0, -normal.z)
		 if partYawVector.magnitude == 0 then
			 return 0,0
		 else
			 local partPitch = math.atan2(partYawVector.magnitude,normal.y)/(math.pi/2)
			 local vector = Vector3.new(cameraLook.x, 0, cameraLook.z)*partPitch
			 return vector:Dot(partYawVector), -partYawVector:Cross(vector).y
		 end	
	 end
	 
	 function getYaw() --returns CFrame
		 return camera.CoordinateFrame*CFrame.Angles(-getPitch(),0,0)
	 end
	 
	 function getPitch() --returns number
		 return math.pi/2 - math.acos(camera.CoordinateFrame.lookVector:Dot(Vector3.new(0,1,0)))
	 end
	 
	 function getCharacterMass()
		 return character.HumanoidRootPart:GetMass() + character.Head:GetMass()
	 end
	 
	 function magnitude2D(x,z)
		 return math.sqrt(x*x+z*z)
	 end
	 
	 local inputKeys = {
		 ["W"] = false,
		 ["S"] = false,
		 ["A"] = false,
		 ["D"] = false,
		 ["Space"] = false,
		 ["LMB"] = false,
		 ["RMB"] = false
	 }
	
	 local plr = game:GetService("Players").LocalPlayer
	 local camera = workspace.CurrentCamera
	 local UserInputService = game:GetService("UserInputService")
	 function onInput(input, gameProcessedEvent)
		 local inputState
		 --print(input.KeyCode)
		 if input.UserInputState == Enum.UserInputState.Begin then
			 inputState = true
		 elseif input.UserInputState == Enum.UserInputState.End then
			 inputState = false
		 else
			 return
		 end 
		 
		 if input.UserInputType == Enum.UserInputType.Keyboard then
			 local key = input.KeyCode.Name
			 if inputKeys[key] ~= nil then
				 inputKeys[key] = inputState
			 end
		 elseif input.UserInputType == Enum.UserInputType.MouseButton1 then --LMB down
			 inputKeys.LMB = inputState
		 elseif input.UserInputType == Enum.UserInputType.MouseButton2 then --RMB down
			 inputKeys.RMB = inputState
		 end
	 end
	 function main()
		 local a = plr.Character:FindFirstChildOfClass("Humanoid") or plr.Character:WaitForChild("Humanoid");
		 a.PlatformStand = true
		 --init movement
		 init(plr, camera, inputKeys);
		 initBodyMovers();
			 
		 --connect input
		 UserInputService.InputBegan:connect(onInput);
		 UserInputService.InputEnded:connect(onInput);
		 --connect updateloop
		 game:GetService("RunService"):BindToRenderStep("updateLoop", 1, updateLoop);
		 
		 --rip
	 end
	 
	 local prevUpdateTime = nil
	 local updateDT = 1/60
	 
	 function setDeltaTime() --seconds
		 local UpdateTime = tick() 
		 if prevUpdateTime ~= nil then
			 updateDT = (UpdateTime - prevUpdateTime)
		 else
			 updateDT = 1/60
		 end
		 prevUpdateTime = UpdateTime
	 end
	 function updateLoop()
		 setDeltaTime();
		 update(updateDT);
	 end
 main()
 end)
 
 cmd.add({"firstp", "1stp", "firstperson"}, {"firstperson (1stp, firstp)", "Makes you 1st person mode"}, function()
game.Players.LocalPlayer.CameraMode = "LockFirstPerson"
 end)

 cmd.add({"thirdp", "3rdp", "thirdperson"}, {"thirdperson (3rdp, thirdp)", "Makes you 3rd person mode"}, function()
	game.Players.LocalPlayer.CameraMaxZoomDistance = 10
	game.Players.LocalPlayer.CameraMode = "Classic"
	 end)

	 cmd.add({"maxzoom", "camzoom"}, {"maxzoom <amount> (camzoom)", "Set your maximum camera distance"}, function(...)
		game.Players.LocalPlayer.CameraMaxZoomDistance = (...)
	 end)
 
	 cmd.add({"cameranoclip", "camnoclip", "cnoclip"}, {"cameranoclip (camnoclip, cnoclip)", "Makes your camera clip through walls"}, function()
		SetConstant = (debug and debug.setconstant) or setconstant
		GetConstants = (debug and debug.getconstants) or getconstants
		if SetConstant or GetConstants or getgc then
		local Popper = game.Players.LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
		for i, v in pairs(getgc()) do
			if type(v) == 'function' and getfenv(v).script == Popper then
				for i, v1 in pairs(GetConstants(v)) do
					if tonumber(v1) == .25 then
						SetConstant(v, i, 0)
					elseif tonumber(v1) == 0 then
						SetConstant(v, i, .25)
					end
				end
			end
		end
		else
			wait();
	 
			Notify({
			Description = "Sorry, your exploit does not support cameranoclip";
			Title = "Nameless Admin";
			Duration = 5;
			
		});
			end
	 end)

	 cmd.add({"uncameranoclip", "uncamnoclip", "uncnoclip"}, {"uncameranoclip (uncamnoclip, uncnoclip)", "Makes your camera not clip through walls"}, function()
		local SetConstant = (debug and debug.setconstant) or setconstant
		local GetConstants = (debug and debug.getconstants) or getconstants
		if SetConstant or GetConstants or getgc then
		local Popper = game.Players.LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
		for i, v in pairs(getgc()) do
			if type(v) == 'function' and getfenv(v).script == Popper then
				for i, v1 in pairs(GetConstants(v)) do
					if tonumber(v1) == .25 then
						SetConstant(v, i, 0)
					elseif tonumber(v1) == 0 then
						SetConstant(v, i, .25)
					end
				end
			end
		end
		else
			wait();
	 
			Notify({
			Description = "Sorry, your exploit does not support cameranoclip and uncameranoclip";
			Title = "Nameless Admin";
			Duration = 5;
			
		});
			end	
	 end)
  
 cmd.add({"fpscap"}, {"fpscap <number>", "Sets the fps cap to whatever you want"}, function(...)
	 setfpscap(...)
 end)
 
 cmd.add({"holdhat"}, {"holdhat", "Can make you hold your hats execute the command and you will have them in your inventory"}, function(...)
 --made by Nightmare#0930
 local lp = game.Players.LocalPlayer
 local char = lp.Character
 
 for i, v in pairs(char:GetChildren()) do
	 if v:IsA("BallSocketConstraint") then
		 v:Destroy()
	 end
 end
 
 for i, v in pairs(char:GetChildren()) do
	 if v:IsA("HingeConstraint") then
		 v:Destroy()
	 end
 end
 
 for i, v in pairs(char.Humanoid:GetAccessories()) do
 local hat = v.Name
 
 char[hat].Archivable = true
 local fake = char[hat]:Clone()
 fake.Parent = char
 fake.Handle.Transparency = 1
 
 local hold = false
 local enabled = false
 
 char[hat].Handle.AccessoryWeld:Destroy()
 
 local tool = Instance.new("Tool", lp.Backpack)
 tool.RequiresHandle = true
 tool.CanBeDropped = false
 tool.Name = hat
 
 local handle = Instance.new("Part", tool)
 handle.Name = "Handle"
 handle.Size = Vector3.new(1, 1, 1)
 handle.Massless = true
 handle.Transparency = 1
 
 local positions = {
	 forward = tool.GripForward,
	 pos = tool.GripPos,
	 right = tool.GripRight,
	 up = tool.GripUp
 }
 
 tool.Equipped:connect(function()
  hold = true
 end)
 
 tool.Unequipped:connect(function()
	hold = false
 end)
 
 tool.Activated:connect(function()
	 if enabled == false then
		 enabled = true
		 tool.GripForward = Vector3.new(-0.976,0,-0.217)
	 tool.GripPos = Vector3.new(.95,-0.76,1.4)
	 tool.GripRight = Vector3.new(0.217,0, 0.976)
	 tool.GripUp = Vector3.new(0,1,0)
	 wait(.8)
	 tool.GripForward = positions.forward
	 tool.GripPos = positions.pos
	 tool.GripRight = positions.right
	 tool.GripUp = positions.up
	 enabled = false
	 end
 end)
 
 game:GetService("RunService").Heartbeat:connect(function()
	 pcall(function()
		char[hat].Handle.Velocity = Vector3.new(30, 0, 0)
 if hold == false then
	 char[hat].Handle.CFrame = fake.Handle.CFrame
 elseif hold == true then
	 char[hat].Handle.CFrame = handle.CFrame
	 end
 end)
 end)
 end
 end)

  cmd.add({"toolinvisible"}, {"toolinvisible", "Be invisible while still be able to use tools"}, function()
	local offset = 1100
	local invisible = game.Players.LocalPlayer
	local grips = {}
	local heldTool
	local gripChanged
	local handle
	local weld
	function setDisplayDistance(distance)
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
				player.Character:FindFirstChildWhichIsA("Humanoid").NameDisplayDistance = distance
				player.Character:FindFirstChildWhichIsA("Humanoid").HealthDisplayDistance = distance
			end
		end
	end
	local tool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
	tool.Name = "Turn Invisible"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Equipped:Connect(
		function()
			wait()
			if not invisible then
				invisible = true
				tool.Name = "Visible enabled"
				if handle then
					handle:Destroy()
				end
				if weld then
					weld:Destroy()
				end
				handle = Instance.new("Part", workspace)
				handle.Name = "Handle"
				handle.Transparency = 1
				handle.CanCollide = false
				handle.Size = Vector3.new(2, 1, 1)
				weld = Instance.new("Weld", handle)
				weld.Part0 = handle
				weld.Part1 = game.Players.LocalPlayer.Character.HumanoidRootPart
				weld.C0 = CFrame.new(0, offset - 1.5, 0)
				setDisplayDistance(offset + 100)
				workspace.CurrentCamera.CameraSubject = handle
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, offset, 0)
				game.Players.LocalPlayer.Character.Humanoid.HipHeight = offset
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
				for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if child:IsA("Tool") and child ~= tool then
						grips[child] = child.Grip
					end
				end
			elseif invisible then
				invisible = false
				tool.Name = "Visible Disabled"
				if handle then
					handle:Destroy()
				end
				if weld then
					weld:Destroy()
				end
				for _, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
					if child:IsA("Tool") then
						child.Parent = game.Players.LocalPlayer.Backpack
					end
				end
				for tool, grip in pairs(grips) do
					if tool then
						tool.Grip = grip
					end
				end
				heldTool = nil
				setDisplayDistance(100)
				workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -offset, 0)
				game.Players.LocalPlayer.Character.Humanoid.HipHeight = 0
			end
			tool.Parent = game.Players.LocalPlayer.Backpack
		end
	)
	game.Players.LocalPlayer.Character.ChildAdded:Connect(
		function(child)
			wait()
			if invisible and child:IsA("Tool") and child ~= heldTool and child ~= tool then
				heldTool = child
				local lastGrip = heldTool.Grip
				if not grips[heldTool] then
					grips[heldTool] = lastGrip
				end
				for _, track in pairs(game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
					track:Stop()
				end
				game.Players.LocalPlayer.Character.Animate.Disabled = true
				heldTool.Grip = heldTool.Grip * (CFrame.new(0, offset - 1.5, 1.5) * CFrame.Angles(math.rad(-90), 0, 0))
				heldTool.Parent = game.Players.LocalPlayer.Backpack
				heldTool.Parent = game.Players.LocalPlayer.Character
				if gripChanged then
					gripChanged:Disconnect()
				end
				gripChanged =
					heldTool:GetPropertyChangedSignal("Grip"):Connect(
					function()
						wait()
						if not invisible then
							gripChanged:Disconnect()
						end
						if heldTool.Grip ~= lastGrip then
							lastGrip =
								heldTool.Grip * (CFrame.new(0, offset - 1.5, 1.5) * CFrame.Angles(math.rad(-90), 0, 0))
							heldTool.Grip = lastGrip
							heldTool.Parent = game.Players.LocalPlayer.Backpack
							heldTool.Parent = game.Players.LocalPlayer.Character
						end
					end
				)
			end
		end
	)
end)
 
 cmd.add({"invisible"}, {"invisible", "Sets invisibility to scare people or something"}, function()
	 Keybind = "E"
 
	 local CS = game:GetService("CollectionService")
	 local UIS = game:GetService("UserInputService")
	 
	 if invisRunning then return end
		 invisRunning = true
		 -- Full credit to AmokahFox @V3rmillion
		 local Player = game.Players.LocalPlayer
		 repeat wait(.1) until game.Players.LocalPlayer.Character
		 local Character = game.Players.LocalPlayer.Character
		 Character.Archivable = true
		 local IsInvis = false
		 local IsRunning = true
		 local InvisibleCharacter = Character:Clone()
		 InvisibleCharacter.Parent = game.Lighting
		 local Void = workspace.FallenPartsDestroyHeight
		 InvisibleCharacter.Name = ""
		 local CF
	 
		 local invisFix = game:GetService("RunService").Stepped:Connect(function()
			 pcall(function()
				 local IsInteger
				 if tostring(Void):find'-' then
					 IsInteger = true
				 else
					 IsInteger = false
				 end
				 local Pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
				 local Pos_String = tostring(Pos)
				 local Pos_Seperate = Pos_String:split(', ')
				 local X = tonumber(Pos_Seperate[1])
				 local Y = tonumber(Pos_Seperate[2])
				 local Z = tonumber(Pos_Seperate[3])
				 if IsInteger == true then
					 if Y <= Void then
						 Respawn()
					 end
				 elseif IsInteger == false then
					 if Y >= Void then
						 Respawn()
					 end
				 end
			 end)
		 end)
	 
		 for i,v in pairs(InvisibleCharacter:GetDescendants())do
			 if v:IsA("BasePart") then
				 if v.Name == "HumanoidRootPart" then
					 v.Transparency = 1
				 else
					 v.Transparency = .5
				 end
			 end
		 end
	 
		 function Respawn()
			 IsRunning = false
			 if IsInvis == true then
				 pcall(function()
					 Player.Character = Character
					 wait()
					 Character.Parent = workspace
					 Character:FindFirstChildWhichIsA'Humanoid':Destroy()
					 IsInvis = false
					 InvisibleCharacter.Parent = nil
					 invisRunning = false
				 end)
			 elseif IsInvis == false then
				 pcall(function()
					 Player.Character = Character
					 wait()
					 Character.Parent = workspace
					 Character:FindFirstChildWhichIsA'Humanoid':Destroy()
					 TurnVisible()
				 end)
			 end
		 end
	 
		 local invisDied
		 invisDied = InvisibleCharacter:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
			 Respawn()
			 invisDied:Disconnect()
			 end)
			 
		 function TurnVisible()
			 if IsInvis == false then return end
			 invisFix:Disconnect()
			 invisDied:Disconnect()
			 CF = workspace.CurrentCamera.CFrame
			 Character = Character
			 local CF_1 = Player.Character.HumanoidRootPart.CFrame
			 Character.HumanoidRootPart.CFrame = CF_1
			 InvisibleCharacter.Parent = game.Lighting
			 Player.Character = Character
			 Character.Parent = workspace
			 IsInvis = false
			 Player.Character.Animate.Disabled = true
			 Player.Character.Animate.Disabled = false
			 invisDied = Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
				 Respawn()
				 invisDied:Disconnect()
			 end)
			 invisRunning = false
			 end
	 
			 
	 
	 local CS = game:GetService("CollectionService")
	 local UIS = game:GetService("UserInputService")
	 
	 UIS.InputBegan:Connect(function(input, gameProcessed)
		 if input.UserInputType == Enum.UserInputType.Keyboard then
			 if input.KeyCode == Enum.KeyCode.E and not gameProcessed then
		   if IsInvis == false then
			   IsInvis = true
		 CF = game.Workspace.CurrentCamera.CFrame
		 local CF_1 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		 Character:MoveTo(Vector3.new(0,math.pi*1000000,0))
		 game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		 wait(.1)
		 game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		 InvisibleCharacter = InvisibleCharacter
		 Character.Parent = game.Lighting
		 InvisibleCharacter.Parent = game.Workspace
		 InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
		 game.Players.LocalPlayer.Character = InvisibleCharacter
		 local workspace = game.Workspace
	 Players = game:GetService("Players")
	 local speaker = game.Players.LocalPlayer
	 workspace.CurrentCamera:remove()
		 wait(.1)
		 game.Workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA('Humanoid')
		 game.Workspace.CurrentCamera.CameraType = "Custom"
		 game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
		 game.Players.LocalPlayer.CameraMaxZoomDistance = 400
		 game.Players.LocalPlayer.CameraMode = "Classic"
		 game.Players.LocalPlayer.Character.Head.Anchored = false
		 game.Players.LocalPlayer.Character.Animate.Disabled = true
		 game.Players.LocalPlayer.Character.Animate.Disabled = false
	 elseif IsInvis == true then
	 TurnVisible()
	 IsInvis = false
	 end
		end
		end
				 end)
				 
				 wait();
 
 Notify({
 Description = "Invisible loaded, press " .. Keybind .. " to toggle";
 Title = "Nameless Admin";
 Duration = 10;
 
 });
 
 if table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform()) then 
	 wait();
	 
	 Notify({
	 Description = "Nameless Admin has detected you using mobile you now have a invisible button click it to enable / disable invisibility";
	 Title = "Nameless Admin";
	 Duration = 7;
	 });
	 
 
 local ScreenGui = Instance.new("ScreenGui")
 local TextButton = Instance.new("TextButton")
 local UICorner = Instance.new("UICorner")
 local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
 
 --Properties:
 
 ScreenGui.Parent = game.CoreGui
 ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 ScreenGui.ResetOnSpawn = false
 
 TextButton.Parent = ScreenGui
 TextButton.BackgroundColor3 = Color3.fromRGB(12, 4, 20)
 TextButton.BackgroundTransparency = 0.140
 TextButton.Position = UDim2.new(0.933, 0,0.621, 0)
 TextButton.Size = UDim2.new(0.043, 0,0.083, 0)
 TextButton.Font = Enum.Font.SourceSansBold
 TextButton.Text = "Become Invisible"
 TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 TextButton.TextSize = 15.000
 TextButton.TextWrapped = true
 TextButton.Active = true
 TextButton.Draggable = true
 TextScaled = true
 
 UICorner.Parent = TextButton
 
 UIAspectRatioConstraint.Parent = TextButton
 UIAspectRatioConstraint.AspectRatio = 1.060
 
 -- Scripts:
 
 local function FEPVI_fake_script() -- TextButton.LocalScript 
	 local script = Instance.new('LocalScript', TextButton)
 
	 IsInvis = false
	 script.Parent.MouseButton1Click:Connect(function()
   if IsInvis == false then
			   IsInvis = true
		 CF = game.Workspace.CurrentCamera.CFrame
		 local CF_1 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		 Character:MoveTo(Vector3.new(0,math.pi*1000000,0))
		 game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		 wait(.1)
		 game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		 InvisibleCharacter = InvisibleCharacter
		 Character.Parent = game.Lighting
		 InvisibleCharacter.Parent = game.Workspace
		 InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
		 Player.Character = InvisibleCharacter
		 local workspace = game.Workspace
	 Players = game:GetService("Players")
	 local speaker = game.Players.LocalPlayer
	 workspace.CurrentCamera:remove()
		 wait(.1)
		 game.Workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA('Humanoid')
		 game.Workspace.CurrentCamera.CameraType = "Custom"
		 game.Players.LocalPlayer.CameraMinZoomDistance = 0.5
		 game.Players.LocalPlayer.CameraMaxZoomDistance = 400
		 game.Players.LocalPlayer.CameraMode = "Classic"
		 game.Players.LocalPlayer.Character.Head.Anchored = false
		 game.Players.LocalPlayer.Character.Animate.Disabled = true
		 game.Players.LocalPlayer.Character.Animate.Disabled = false
					 script.Parent.Text = "Become Visible"
	 elseif IsInvis == true then
	 TurnVisible()
	 IsInvis = false
				 script.Parent.Text = "Become Invisible"
		 end
	 end)
 end
 coroutine.wrap(FEPVI_fake_script)()
 else
 end
 end)
 
 cmd.add({"unchatspy"}, {"unchat", "Unspies on chat, enables chat, spies whispers etc."}, function()
	 
 
 
 wait();
 
 Notify({
 Description = "Chat spy enabled";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 --This script reveals ALL hidden messages in the default chat
 --chat "/spy" to toggle!
 enabled = false
 --if true will check your messages too
 spyOnMyself = true
 --if true will chat the logs publicly (fun, risky)
 public = false
 --if true will use /me to stand out
 publicItalics = true
 --customize private logs
 privateProperties = {
	 Color = Color3.fromRGB(0,255,255); 
	 Font = Enum.Font.SourceSansBold;
	 TextSize = 18;
 }
 --////////////////////////////////////////////////////////////////
 local StarterGui = game:GetService("StarterGui")
 local Players = game:GetService("Players")
 local player = Players.LocalPlayer
 local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
 local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
 local instance = (_G.chatSpyInstance or 0) + 1
 _G.chatSpyInstance = instance
 
 local function onChatted(p,msg)
	 if _G.chatSpyInstance == instance then
		 if p==player and msg:lower():sub(1,4)=="/spy" then
			 enabled = not enabled
			 wait(0.3)
			 print("XD")
			 StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
		 elseif enabled and (spyOnMyself==true or p~=player) then
			 msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
			 local hidden = true
			 local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
				 if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and public==false and Players[packet.FromSpeaker].Team==player.Team)) then
					 hidden = false
				 end
			 end)
			 wait(1)
			 conn:Disconnect()
			 if hidden and enabled then
				 if public then
					 saymsg:FireServer((publicItalics and "/me " or '').."{SPY} [".. p.Name .."]: "..msg,"All")
				 else
					 privateProperties.Text = "{SPY} [".. p.Name .."]: "..msg
					 StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
				 end
			 end
		 end
	 end
 end
 
 for _,p in ipairs(Players:GetPlayers()) do
	 p.Chatted:Connect(function(msg) onChatted(p,msg) end)
 end
 Players.PlayerAdded:Connect(function(p)
	 p.Chatted:Connect(function(msg) onChatted(p,msg) end)
 end)
 print("XD")
 StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
 local chatFrame = player.PlayerGui.Chat.Frame
 chatFrame.ChatChannelParentFrame.Visible = true
 chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
 end)
 
 cmd.add({"fireremotes"}, {"fireremotes", "Fires every remote."}, function()
 local remoteamount = 0
 
 for i,v in pairs(game:GetDescendants()) do
		 if v:IsA("RemoteEvent") then
  remoteamount = remoteamount + 1
		 v:FireServer()
		 if v:IsA("BindableEvent") then
			  remoteamount = remoteamount + 1
		 v:Fire()
		 if v:IsA("RemoteFunction") then
			  remoteamount = remoteamount + 1
		 v:InvokeServer()
		 end
		 end
		 end
 end
 wait();
 
 Notify({
 Description = "Fired " .. remoteamount .. " amount of remotes";
 Title = "Nameless Admin";
 Duration = 7;
 
 });
 end)
 
 
 cmd.add({"uafollow", "unanchoredfollow"}, {"uafollow (unanchoredfollow)", "Makes unanchored parts follow you"}, function() 
	 wait();
	 
	 Notify({
	 Description = "Unanchored follow executed";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 local LocalPlayer = game:GetService("Players").LocalPlayer
 local unanchoredparts = {}
 local movers = {}
 for index, part in pairs(workspace:GetDescendants()) do
	 if part:IsA("Part") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
		 table.insert(unanchoredparts, part)
		 part.Massless = true
		 part.CanCollide = false
		 if part:FindFirstChildOfClass("BodyPosition") ~= nil then
			 part:FindFirstChildOfClass("BodyPosition"):Destroy()
		 end
	 end
 end
 for index, part in pairs(unanchoredparts) do
	 local mover = Instance.new("BodyPosition", part)
	 table.insert(movers, mover)
	 mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
 end
 repeat
	 for index, mover in pairs(movers) do
		 mover.Position = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame:PointToWorldSpace(Vector3.new(0, 0, 5))
	 end
	 wait(0.5)
 until LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
 for _, mover in pairs(movers) do
	 mover:Destroy()
 end
 end)
 
 cmd.add({"fov"}, {"fov <number>", "Makes your FOV to something custom you want (1-120 FOV)"}, function(...)
 game.Workspace.CurrentCamera.FieldOfView = (...)
 end)
 
  cmd.add({"savetools", "stools"}, {"savetools (stools)", "puts your tools in players.localplayer"}, function()
 for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	 if (v:IsA("Tool")) then
		 v.Parent = game.Players.LocalPlayer
	 end
 end
 end)
 
  cmd.add({"loadtools", "ltools"}, {"loadtools (ltools)", "puts your tools back in the backpack"}, function()
 for _,v in pairs(game.Players.LocalPlayer:GetChildren()) do
	 if (v:IsA("Tool")) then
		 v.Parent = game.Players.LocalPlayer.Backpack
	 end
 end
 end)
  
	 cmd.add({"grabtools", "gt"}, {"grabtools", "Grabs any dropped tools"}, function()
		 local p = game:GetService("Players").LocalPlayer
 local c = p.Character
 if c and c:FindFirstChild("Humanoid") then
	 for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
		 if v:IsA("Tool") then
			 c:FindFirstChild("Humanoid"):EquipTool(v)
		 end
	 end
 end
 wait();
 
 Notify({
 Description = "Grabbed all tools";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
 end)
 
 cmd.add({"ws", "speed", "walkspeed"}, {"walkspeed <number> (speed, ws)", "Makes your WalkSpeed whatever you want"}, function(...)
	 game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (...)
 end)
 
		 cmd.add({"cuff", "jail"}, {"cuff <player> (jail)", "Cuffs the player"}, function(...)
			 Username = (...)
  
 local target = getPlr(Username)
 local THumanoidPart
 local plrtorso
 local TargetCharacter = target.Character
	if TargetCharacter:FindFirstChild("Torso") then
			plrtorso = TargetCharacter.Torso
		elseif TargetCharacter:FindFirstChild("UpperTorso") then
			plrtorso = TargetCharacter.UpperTorso
		end
		 local old = getChar().HumanoidRootPart.CFrame
		 local tool = getBp():FindFirstChildOfClass("Tool") or getChar():FindFirstChildOfClass("Tool")
		 if target == nil or tool == nil then return end
		 local attWeld = attachTool(tool,CFrame.new(0,0,0))
		 attachTool(tool,CFrame.new(0,0,0.2) * CFrame.Angles(math.rad(-90),0,0))
		 tool.Grip = plrtorso.CFrame
		 wait(0.07)
 tool.Grip = CFrame.new(0, -7, -3)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,0)
		 firetouchinterest(target.Character.Humanoid.RootPart,tool.Handle,1)
	 end)
 
	 cmd.add({"jp", "jumppower"}, {"jumppower <number> (jp)", "Makes your JumpPower whatever you want"}, function(...)
		 game.Players.LocalPlayer.Character.Humanoid.JumpPower = (...)
		 end)
 
		 cmd.add({"oofspam"}, {"oofspam", "Spams oof"}, function()
			 _G.enabled = true
 _G.speed = 100
 local HRP = Humanoid.RootPart or Humanoid:FindFirstChild("HumanoidRootPart")
 if not Humanoid or not _G.enabled then
	if Humanoid and Humanoid.Health <= 0 then
		Humanoid:Destroy()
	end
	return
 end
 Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
 Humanoid.BreakJointsOnDeath = false
 Humanoid.RequiresNeck = false
 local con; con = RunService.Stepped:Connect(function()
	if not Humanoid then return con:Disconnect() end
	Humanoid:ChangeState(Enum.HumanoidStateType.Running)
 end)
 LocalPlayer.Character = nil
 LocalPlayer.Character = Character
 task.wait(Players.RespawnTime + 0.1)
 while task.wait(1/_G.speed) do
	Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
 end
		 end)
		 
		 
 
 cmd.add({"partgrabber"}, {"partgrabber", "Press Q"}, function()
	 wait();
	 
	 Notify({
	 Description = "Part grabber executed, press Q on a part";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 local player = game.Players.LocalPlayer.Character
 local mouse = game.Players.LocalPlayer:GetMouse()
 local key = game:GetService("UserInputService")
 
 BodyAngularVelocity = true
 local keyyy = Enum.KeyCode.Q
 
 
 local y = 5.7
 local y2 = 7.2
 local P = 1000000
 local V = Vector3.new(100000,100000,100000)
 local SBT = Instance.new("SelectionBox")
 SBT.Name = "SB"
 SBT.Parent = player.HumanoidRootPart
 SBT.Adornee = player.HumanoidRootPart
 SBT.Color3 = Color3.new(0,0,0)
 
 while wait(.3) do
 key.InputBegan:Connect(function(k)
  if k.KeyCode == keyyy then
  local handle = mouse.Target
  if handle.Anchored == false then
  wait(.3)
  handle.Position = handle.Position + Vector3.new(0,1,0)
  local BP = Instance.new("BodyPosition")
  BP.Name = "BP"
  BP.Parent = handle
  BP.P = P
  BP.MaxForce = V
  local SB = Instance.new("SelectionBox")
  SB.Name = "SB"
  SB.Parent = handle
  SB.Adornee = handle
  local colour = math.random(1,7)
	 if colour == 1 then
  SB.Color3 = Color3.new(255,0,0)
	 end
	 if colour == 2 then
  SB.Color3 = Color3.new(255,170,0)
	 end
	 if colour == 3 then
  SB.Color3 = Color3.new(255,255,0)
	 end
	 if colour == 4 then
  SB.Color3 = Color3.new(0,255,0)
	 end
	 if colour == 5 then
  SB.Color3 = Color3.new(0,170,255)
	 end
	 if colour == 6 then
  SB.Color3 = Color3.new(170,0,255)
	 end
	 if colour == 7 then
  SB.Color3 = Color3.new(0,0,0)
	 end
  player.Torso.Anchored = true
  if BodyAngularVelocity == true then
   local BAV = Instance.new("BodyAngularVelocity")
   BAV.Name = "BAV"
   BAV.Parent = handle
   BAV.P = 999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
   BAV.AngularVelocity = Vector3.new(9990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,9990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,9990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)
  end
  wait(.3)
  player.Torso.Anchored = false
  while wait(.3) do
   if handle:FindFirstChild("BP",true) then
   handle.CanCollide = false
   end
   BP.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,y,0)
	  wait(.3)
   if handle:FindFirstChild("BP",true) then
	  handle.CanCollide = false
   end
	   BP.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,y2,0)
	end
   end
	 end
  end)
 end
 end)
 
 cmd.add({"tpua", "bringua"}, {"tpua <player> (bringua)", "brings every unanchored part on the map"}, function(...)
	 local heartbeat = game:GetService("RunService").Heartbeat
 spawn(function()
	 while true do heartbeat:Wait()
			 game.Players.LocalPlayer.MaximumSimulationRadius = math.pow(math.huge,math.huge)*math.huge
			 sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.pow(math.huge,math.huge)*math.huge)
			 game:GetService("RunService").Stepped:wait()
 end
 end)
 
 execute = function(name)
	 for index, part in pairs(game:GetDescendants()) do
	 if part:IsA("BasePart" or "UnionOperation" or "Model") and part.Anchored == false and part:IsDescendantOf(game.Players.LocalPlayer.Character) == false and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false then --// Checks Part Properties
	 part.CFrame = CFrame.new(game.workspace[name].Head.Position) --TP Part To User
	 if spam == true and part:FindFirstChild("BodyGyro") == nil then
	 local bodyPos = Instance.new("BodyPosition")
	 bodyPos.Position = part.Position
	 bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	 bodyPos.P = 1e6
	 bodyPos.Parent = part
	 end
	 end
	 end
 end
 User = (...)
 Target = getPlr(User)
 TargetName = Target.Name
 execute(TargetName)
	 wait();
	 
	 Notify({
	 Description = "Unanchored parts have been teleported to " .. TargetName .. "" ;
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 
	 end)
 
	 cmd.add({"freezeua", "thawua"}, {"freezeua (thawua)", "freezes every unanchored part on the map"}, function()
 		 frozenParts = {}
		 if sethidden then
				 local badnames = {
					 "Head",
					 "UpperTorso",
					 "LowerTorso",
					 "RightUpperArm",
					 "LeftUpperArm",
					 "RightLowerArm",
					 "LeftLowerArm",
					 "RightHand",
					 "LeftHand",
					 "RightUpperLeg",
					 "LeftUpperLeg",
					 "RightLowerLeg",
					 "LeftLowerLeg",
					 "RightFoot",
					 "LeftFoot",
					 "Torso",
					 "Right Arm",
					 "Left Arm",
					 "Right Leg",
					 "Left Leg",
					 "HumanoidRootPart"
				 }
				 local function FREEZENOOB(v)
					 if v:IsA("BasePart" or "UnionOperation") and v.Anchored == false then
						 local BADD = false
						 for i = 1,#badnames do
							 if v.Name == badnames[i] then
								 BADD = true
							 end
						 end
						 if game.Players.LocalPlayer.Character and v:IsDescendantOf(game.Players.LocalPlayer.Character) then
							 BADD = true
						 end
						 if BADD == false then
							 for i,c in pairs(v:GetChildren()) do
								 if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
									 c:Destroy()
								 end
							 end
							 local bodypos = Instance.new("BodyPosition")
							 bodypos.Parent = v
							 bodypos.Position = v.Position
							 bodypos.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
							 local bodygyro = Instance.new("BodyGyro")
							 bodygyro.Parent = v
							 bodygyro.CFrame = v.CFrame
							 bodygyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
							 if not table.find(frozenParts,v) then
								 table.insert(frozenParts,v)
							 end
						 end
					 end
				 end
				 for i,v in pairs(workspace:GetDescendants()) do
					 FREEZENOOB(v)
				 end
				 freezingua = workspace.DescendantAdded:Connect(FREEZENOOB)
				 end
		 end)
 
		 cmd.add({"unfreezeua", "unthawua"}, {"unfreezeua (unthawua)", "unfreezes every unanchored part on the map"}, function()
	 wait();
	 
	 Notify({
	 Description = "Unfroze unanchored parts";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
			 if sethidden then
				 if freezingua then
					 freezingua:Disconnect()
				 end
				 for i,v in pairs(frozenParts) do
					 for i,c in pairs(v:GetChildren()) do
						 if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
							 c:Destroy()
						 end
					 end
				 end
				 frozenParts = {}
				 end
		 end)
 
 cmd.add({"highlightua", "highlightunanchored"}, {"highlightua (hightlightunanchored)", "Highlights all unanchored parts"}, function()
 wait();
	 
	 Notify({
	 Description = "Highlighted all unanchored parts";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 for _,part in pairs(workspace:GetDescendants()) do
	 if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(game.Players.LocalPlayer.Character) == false and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false and part:FindFirstChild("Weld") == nil then --// probably could've made the check better
		 local selectionBox = Instance.new("SelectionBox")
		 selectionBox.Adornee = part
		 selectionBox.Color3 = Color3.new(1,0,0)
		 selectionBox.Parent = part
	 end
	 end
 end)
 
 cmd.add({"unhighlightua", "unhighlightunanchored"}, {"unhighlightua (unhightlightunanchored)", "Unhighlights all unanchored parts"}, function()
	 wait();
	 
	 Notify({
	 Description = "Unhighlighted unanchored parts";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 for _,part in pairs(workspace:GetDescendants()) do
	 if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(game.Players.LocalPlayer.Character) == false and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false and part:FindFirstChild("Weld") == nil then --// Checks Part Properties
		 if part:FindFirstChild("SelectionBox") then
		 part.SelectionBox:Destroy()
		 end
	 end
	 end
 end)
 
 cmd.add({"countua", "countunanchoreed"}, {"countua (countunanchored)", "Counts all unanchored parts in the console"}, function()
	 b = 0
	 for index, part in pairs(game.workspace:GetDescendants()) do
	 if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(game.Players.LocalPlayer.Character) == false and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false and part:FindFirstChild("Weld") == nil then --// Checks Part Properties
		 b = b + 1
	 end
	 end	 
	 wait();
	 
	 Notify({
	 Description = "Parts have been counted, the amount is " .. b .. "";
	 Title = "Nameless Admin";
	 Duration = 5;
	 
 });
 end)
 
 cmd.add({"ownerid"}, {"ownerid", "Changes the client id to the owner's. Can give special things"}, function()
 wait();
 
 Notify({
 Description = "Set local player id to the owner id";
 Title = "Nameless Admin";
 Duration = 5;
 
 });
	 if game.CreatorType == Enum.CreatorType.User then
		 game.Players.LocalPlayer.UserId = game.CreatorId
		 end
		 if game.CreatorType == Enum.CreatorType.Group then
		 game.Players.LocalPlayer.UserId = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId).Owner.Id
		 end
 end)
 
 cmd.add({"errorchat"}, {"errorchat", "Makes the chat error appear when roblox chat is slow"}, function()
	 for i=1,3 do 
		 if game:GetService("TextChatService"):FindFirstChild("TextChannels") then
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("\0")
			else
	   game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("\0", "All")
			end
	 end
 end)
 
 --[[ FUNCTIONALITY ]]--
 localPlayer.Chatted:Connect(function(str)
	 lib.parseCommand(str)
 end)
 
 -- [[ Admin Player]]
 function AdminChatted(Message, Player)
	 Player.Chatted:Connect(function(Message, Player)
		 lib.parseCommand(Message, Player)
	 end)
 end
 
 function CheckPermissions(Player)
	 Player.Chatted:Connect(function(Message)
		 if Admin[Player.UserId] then
			 AdminChatted(Message, Player)
		 end
	 end)
 end
 Players.PlayerAdded:Connect(function(Player)
	 CheckPermissions(Player)
 end)
 for i,v in pairs(Players:GetPlayers()) do
	 if v ~= LocalPlayer then
		 CheckPermissions(v)
	 end
 end
 
 
 --[[ GUI VARIABLES ]]--
local ScreenGui
 if not RunService:IsStudio() then
	 ScreenGui = game:GetObjects("rbxassetid://13510552309")[1]
 else
	 repeat wait() until player:FindFirstChild("AdminUI", true)
	 ScreenGui = player:FindFirstChild("AdminUI", true)
 end
 
 local description = ScreenGui.Description
 local cmdBar = ScreenGui.CmdBar
	 local centerBar = cmdBar.CenterBar
		 local cmdInput = centerBar.Input
	 local cmdAutofill = cmdBar.Autofill
		 local cmdExample = cmdAutofill.Cmd
	 local leftFill = cmdBar.LeftFill
	 local rightFill = cmdBar.RightFill
 local chatLogsFrame = ScreenGui.ChatLogs
	 local chatLogs = chatLogsFrame.Container.Logs
		 local chatExample = chatLogs.TextLabel
 local commandsFrame = ScreenGui.Commands
	 local commandsFilter = commandsFrame.Container.Filter
	 local commandsList = commandsFrame.Container.List
		 local commandExample = commandsList.TextLabel
 local resizeFrame = ScreenGui.Resizeable
 local resizeXY = {
	 Top		= {Vector2.new(0, -1),	Vector2.new(0, -1),	"rbxassetid://2911850935"},
	 Bottom	= {Vector2.new(0, 1),	Vector2.new(0, 0),	"rbxassetid://2911850935"},
	 Left	= {Vector2.new(-1, 0),	Vector2.new(1, 0),	"rbxassetid://2911851464"},
	 Right	= {Vector2.new(1, 0),	Vector2.new(0, 0),	"rbxassetid://2911851464"},
	 
	 TopLeft		= {Vector2.new(-1, -1),	Vector2.new(1, -1),	"rbxassetid://2911852219"},
	 TopRight	= {Vector2.new(1, -1),	Vector2.new(0, -1),	"rbxassetid://2911851859"},
	 BottomLeft	= {Vector2.new(-1, 1),	Vector2.new(1, 0),	"rbxassetid://2911851859"},
	 BottomRight	= {Vector2.new(1, 1),	Vector2.new(0, 0),	"rbxassetid://2911852219"},
 }
 
 cmdExample.Parent = nil
 chatExample.Parent = nil
 commandExample.Parent = nil
 resizeFrame.Parent = nil
 
 local rPlayer = Players:FindFirstChildWhichIsA("Player")
 local coreGuiProtection = {}
 
 pcall(function()
	 for i, v in pairs(ScreenGui:GetDescendants()) do
		 coreGuiProtection[v] = rPlayer.Name
	 end
	 ScreenGui.DescendantAdded:Connect(function(v)
		 coreGuiProtection[v] = rPlayer.Name
	 end)
	 coreGuiProtection[ScreenGui] = rPlayer.Name
	  
	 local meta = getrawmetatable(game)
	 local tostr = meta.__tostring
	 setreadonly(meta, false)
	 meta.__tostring = newcclosure(function(t)
		 if coreGuiProtection[t] and not checkcaller() then
			 return coreGuiProtection[t]
		 end
		 return tostr(t)
	 end)
 end)

 if not RunService:IsStudio() then
	 local newGui = game:GetService("CoreGui"):FindFirstChildWhichIsA("ScreenGui")
	 newGui.DescendantAdded:Connect(function(v)
		 coreGuiProtection[v] = rPlayer.Name
	 end)
	 for i, v in pairs(ScreenGui:GetChildren()) do
		 v.Parent = newGui
	 end
	 ScreenGui = newGui
 end
 
 --[[ GUI FUNCTIONS ]]--
 gui = {}
 gui.txtSize = function(ui, x, y)
	 local textService = game:GetService("TextService")
	 return textService:GetTextSize(ui.Text, ui.TextSize, ui.Font, Vector2.new(x, y))
 end
 gui.commands = function()
	 if not commandsFrame.Visible then
		 commandsFrame.Visible = true
		 commandsList.CanvasSize = UDim2.new(0, 0, 0, 0)
	 end
	 for i, v in pairs(commandsList:GetChildren()) do
		 if v:IsA("TextLabel") then
			 Destroy(v)
		 end
	 end
	 local i = 0
	 for cmdName, tbl in pairs(Commands) do
		 local Cmd = commandExample:Clone()
		 Cmd.Parent = commandsList
		 Cmd.Name = cmdName
		 Cmd.Text = " " .. tbl[2][1]
		 Cmd.MouseEnter:Connect(function()
			 description.Visible = true
			 description.Text = tbl[2][2]
		 end)
		 Cmd.MouseLeave:Connect(function()
			 if description.Text == tbl[2][2] then
				 description.Visible = false
				 description.Text = ""
			 end
		 end)
		 i = i + 1
	 end
	 commandsList.CanvasSize = UDim2.new(0, 0, 0, i*20+10)
	 commandsFrame.Position = UDim2.new(0.5, -283/2, 0.5, -260/2)
 end
 gui.chatlogs = function()
	 if not chatLogsFrame.Visible then
		 chatLogsFrame.Visible = true
	 end
	 chatLogsFrame.Position = UDim2.new(0.5, -283/2+5, 0.5, -260/2+5)
 end
 
 gui.tween = function(obj, style, direction, duration, goal)
	 local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle[style], Enum.EasingDirection[direction])
	 local tween = TweenService:Create(obj, tweenInfo, goal)
	 tween:Play()
	 return tween
 end
 gui.mouseIn = function(guiObject, range)
	 local pos1, pos2 = guiObject.AbsolutePosition, guiObject.AbsolutePosition + guiObject.AbsoluteSize
	 local mX, mY = mouse.X, mouse.Y
	 if mX > pos1.X-range and mX < pos2.X+range and mY > pos1.Y-range and mY < pos2.Y+range then
		 return true
	 end
	 return false
 end
 gui.resizeable = function(ui, min, max)
	 local rgui = resizeFrame:Clone()
	 rgui.Parent = ui
	 
	 local mode
	 local UIPos
	 local lastSize
	 local lastPos = Vector2.new()
	 
	 local function update(delta)
		 local xy = resizeXY[(mode and mode.Name) or '']
		 if not mode or not xy then return end
		 local delta = (delta * xy[1]) or Vector2.new()
		 local newSize = Vector2.new(lastSize.X + delta.X, lastSize.Y + delta.Y)
		 newSize = Vector2.new(
			 math.clamp(newSize.X, min.X, max.X),
			 math.clamp(newSize.Y, min.Y, max.Y)
		 )
		 ui.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
		 ui.Position = UDim2.new(
			 UIPos.X.Scale, 
			 UIPos.X.Offset + (-(newSize.X - lastSize.X) * xy[2]).X, 
			 UIPos.Y.Scale, 
			 UIPos.Y.Offset + (delta * xy[2]).Y
		 )
	 end
	 
	 mouse.Move:Connect(function()
		 update(Vector2.new(mouse.X, mouse.Y) - lastPos)
	 end)
	 
	 for _, button in pairs(rgui:GetChildren()) do
		 local isIn = false
		 button.InputBegan:Connect(function(input)
			 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				 mode = button
				 lastPos = Vector2.new(mouse.X, mouse.Y)
				 lastSize = ui.AbsoluteSize
				 UIPos = ui.Position
			 end
		 end)
		 button.InputEnded:Connect(function(input)
			 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				 mode = nil
			 end
		 end)
		 button.MouseEnter:Connect(function()
			 mouse.Icon = resizeXY[button.Name][3]
		 end)
		 button.MouseLeave:Connect(function()
			 if mouse.Icon == resizeXY[button.Name][3] then
				 mouse.Icon = ""
			 end
		 end)
	 end
 end
 gui.draggable = function(ui, dragui)
	 if not dragui then dragui = ui end
	 local UserInputService = game:GetService("UserInputService")
	 
	 local dragging
	 local dragInput
	 local dragStart
	 local startPos
	 
	 local function update(input)
		 local delta = input.Position - dragStart
		 ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	 end
	 
	 dragui.InputBegan:Connect(function(input)
		 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			 dragging = true
			 dragStart = input.Position
			 startPos = ui.Position
			 
			 input.Changed:Connect(function()
				 if input.UserInputState == Enum.UserInputState.End then
					 dragging = false
				 end
			 end)
		 end
	 end)
	 
	 dragui.InputChanged:Connect(function(input)
		 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			 dragInput = input
		 end
	 end)
	 
	 UserInputService.InputChanged:Connect(function(input)
		 if input == dragInput and dragging then
			 update(input)
		 end
	 end)
 end
 gui.menuify = function(menu)
	 local exit = menu:FindFirstChild("Exit", true)
	 local mini = menu:FindFirstChild("Minimize", true)
	 local minimized = false
	 local sizeX, sizeY = Instance.new("IntValue", menu), Instance.new("IntValue", menu)
	 mini.MouseButton1Click:Connect(function()
		 minimized = not minimized
		 if minimized then
			 sizeX.Value = menu.Size.X.Offset
			 sizeY.Value = menu.Size.Y.Offset
			 gui.tween(menu, "Quart", "Out", 0.5, {Size = UDim2.new(0, 283, 0, 25)})
		 else
			 gui.tween(menu, "Quart", "Out", 0.5, {Size = UDim2.new(0, sizeX.Value, 0, sizeY.Value)})
		 end
	 end)
	 exit.MouseButton1Click:Connect(function()
		 menu.Visible = false
	 end)
	 gui.draggable(menu, menu.Topbar)
	 menu.Visible = false
 end


 gui.loadCommands = function()
	for i, v in pairs(cmdAutofill:GetChildren()) do
		if v.Name ~= "UIListLayout" then
			Destroy(v)
		end
	end
	local last = nil
	local i = 0
	for name, tbl in pairs(Commands) do
		local info = tbl[2]
		local btn = cmdExample:Clone()
		btn.Parent = cmdAutofill
		btn.Name = name
		btn.Input.Text = info[1]
		i = i + 1
		
		local size = btn.Size
		btn.Size = UDim2.new(0, 0, 0, 25)
		btn.Size = size
	end
end

	 gui.loadCommands()
  for i, v in ipairs(cmdAutofill:GetChildren()) do
		 if v:IsA("Frame") then
			 v.Visible = false
		 end
	 end
 gui.barSelect = function(speed)
	 centerBar.Visible = true
	 gui.tween(centerBar, "Sine", "Out", speed or 0.25, {Size = UDim2.new(0, 250, 1, 15)})
	 gui.tween(leftFill, "Quad", "Out", speed or 0.3, {Position = UDim2.new(0, 0, 0.5, 0)})
	 gui.tween(rightFill, "Quad", "Out", speed or 0.3, {Position = UDim2.new(1, 0, 0.5, 0)})
 end
 gui.barDeselect = function(speed)
	 gui.tween(centerBar, "Sine", "Out", speed or 0.25, {Size = UDim2.new(0, 250, 0, 0)})
	 gui.tween(leftFill, "Sine", "In", speed or 0.3, {Position = UDim2.new(-0.5, 100, 0.5, 0)})
	 gui.tween(rightFill, "Sine", "In", speed or 0.3, {Position = UDim2.new(1.5, -100, 0.5, 0)})
	 for i, v in ipairs(cmdAutofill:GetChildren()) do
		 if v:IsA("Frame") then
			 wrap(function()
				 wait(math.random(1, 200)/2000)
				 gui.tween(v, "Back", "In", 0.35, {Size = UDim2.new(0, 0, 0, 25)})
			 end)
		 end
	end
 end

 -- [[ AUTOFILL SEARCHER ]] --
 gui.searchCommands = function()
	local str = (cmdInput.Text:gsub(";", "")):lower()
	local index = 0
	local lastFrame
	for _, v in ipairs(cmdAutofill:GetChildren()) do
		if v:IsA("Frame") and index < 5 then
			local cmd = Commands[v.Name]
			local name = cmd and cmd[2][1] or ""
			v.Input.Text = str ~= "" and v.Name:find(str) == 1 and v.Name or name
			v.Visible = str == "" or v.Name:find(str)
			if v.Visible then
				index = index + 1
				local n = math.sqrt(index) * 125
				local yPos = (index - 1) * 28
				local newPos = UDim2.new(0.5, 0, 0, yPos)
				gui.tween(v, "Quint", "Out", 0.3, {
					Size = UDim2.new(0.5, n, 0, 25),
					Position = lastFrame and newPos or UDim2.new(0.5, 0, 0, yPos),
				})
				lastFrame = v
			end
		end
	end
end

 --[[ GUI FUNCTIONALITY ]]--

-- [[ OPEN THE COMMAND BAR ]] -- 
 mouse.KeyDown:Connect(function(k)
	 if k:lower() == opt.prefix then
		 gui.barSelect()
		 cmdInput.Text = ''
		 cmdInput:CaptureFocus()
				 wait(0.00005)
							 cmdInput.Text = ''
	 end
 end)

 -- [[ CLOSE THE COMMAND BAR ]] -- 
 cmdInput.FocusLost:Connect(function(enterPressed)
	 if enterPressed then
		 wrap(function()
			 lib.parseCommand(opt.prefix .. cmdInput.Text)
		 end)
	 end
	 gui.barDeselect()
	 end)
 
 cmdInput.Changed:Connect(function(p)
	 if p ~= "Text" then return end
	 gui.searchCommands()
 end)
 
 gui.barDeselect(0)
 cmdBar.Visible = true
 gui.menuify(chatLogsFrame)
 gui.menuify(commandsFrame)
 
 -- [[ GUI RESIZE FUNCTION ]] -- 

-- table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform()) | searches if the player is on mobile.
 if table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform()) then 
 else
 gui.resizeable(chatLogsFrame, Vector2.new(173,58), Vector2.new(1000,1000))
 gui.resizeable(commandsFrame, Vector2.new(184,84), Vector2.new(1000,1000))
 end
 
 -- [[ CMDS COMMANDS SEARCH FUNCTION ]] --
 commandsFilter.Changed:Connect(function(p)
	 if p ~= "Text" then return end
	 for i, v in pairs(commandsList:GetChildren()) do
		 if v:IsA("TextLabel") then
			 if v.Name:find(commandsFilter.Text:lower()) and v.Name:find(commandsFilter.Text:lower()) <= 2 then
				 v.Visible = true
			 else
				 v.Visible = false
			 end
		 end
	 end
 end)
 
 -- [[ CHAT TO USE COMMANDS ]] --
 local function bindToChat(plr, msg)
	 local chatMsg = chatExample:Clone()
	 for i, v in pairs(chatLogs:GetChildren()) do
		 if v:IsA("TextLabel") then
			 v.LayoutOrder = v.LayoutOrder + 1
		 end
	 end
	 chatMsg.Parent = chatLogs
	 chatMsg.Text = ("[%s]: %s"):format(plr.Name, msg)
	 
	 local txtSize = gui.txtSize(chatMsg, chatMsg.AbsoluteSize.X, 100)
	 chatMsg.Size = UDim2.new(1, -5, 0, txtSize.Y)
 end
 
 for i, plr in pairs(Players:GetPlayers()) do
	 plr.Chatted:Connect(function(msg)
		 bindToChat(plr, msg)
	 end)
 end
 Players.PlayerAdded:Connect(function(plr)
	 plr.Chatted:Connect(function(msg)
		 bindToChat(plr, msg)
	 end)
 end)
 
 mouse.Move:Connect(function()
	 description.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
	 local size = gui.txtSize(description, 200, 100)
	 description.Size = UDim2.new(0, size.X, 0, size.Y)
 end)
 
 RunService.Stepped:Connect(function()
	 chatLogs.CanvasSize = UDim2.new(0, 0, 0, chatLogs.UIListLayout.AbsoluteContentSize.Y)
	 commandsList.CanvasSize = UDim2.new(0, 0, 0, commandsList.UIListLayout.AbsoluteContentSize.Y)
 end)
 print([[

╭━╮╱╭╮╱╱╱╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╱╱╭━━━╮╱╭╮
┃┃╰╮┃┃╱╱╱╱╱╱╱╱┃┃╱╱╱╱╱╱╱╱╱╱┃╭━╮┃╱┃┃
┃╭╮╰╯┣━━┳╮╭┳━━┫┃╭━━┳━━┳━━╮┃┃╱┃┣━╯┣╮╭┳┳━╮
┃┃╰╮┃┃╭╮┃╰╯┃┃━┫┃┃┃━┫━━┫━━┫┃╰━╯┃╭╮┃╰╯┣┫╭╮╮
┃┃╱┃┃┃╭╮┃┃┃┃┃━┫╰┫┃━╋━━┣━━┃┃╭━╮┃╰╯┃┃┃┃┃┃┃┃
╰╯╱╰━┻╯╰┻┻┻┻━━┻━┻━━┻━━┻━━╯╰╯╱╰┻━━┻┻┻┻┻╯╰╯
]])
 
 -- never used this lol
 function Destroy(guiObject)
	 if not pcall(function()guiObject.Parent = game:GetService("CoreGui")end) then
		 guiObject.Parent = nil
	 end
 end
 
 wait(0.2)
 
 -- [[ COMMAND BAR BUTTON ]] --
 local ScreenGui = Instance.new("ScreenGui")
 local TextClickButton = Instance.new("TextButton")
 local UICorner = Instance.new("UICorner")
 
 ScreenGui.Parent = game.CoreGui
 ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 ScreenGui.ResetOnSpawn = true
 
 TextClickButton.Name = "NamelessAdminButton"
 TextClickButton.Parent = ScreenGui
 TextClickButton.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
 TextClickButton.BackgroundTransparency = 1.000
 TextClickButton.Position = UDim2.new(0.418, 0,0, 0)
 TextClickButton.Size = UDim2.new(0, 2, 0, 33)
 TextClickButton.Font = Enum.Font.SourceSansBold
 TextClickButton.Text = "Nameless Admin " .. currentversion .. ""
 TextClickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 TextClickButton.TextSize = 20.000
 TextClickButton.TextWrapped = true
 
 UICorner.CornerRadius = UDim.new(1, 0)
 UICorner.Parent = TextClickButton
 
 local function PZORYLB_fake_script() -- TextClickButton.LocalScript 
	 local script = Instance.new('LocalScript', TextClickButton)
	 textclickbutton = script.Parent
	 textclickbutton.Size = UDim2.new(0, 2,0, 33)
	 textclickbutton.BackgroundTransparency = 0.14
	 textclickbutton:TweenSize(UDim2.new(0, 251,0, 33), "Out", "Quint",1,true)
	 wait(2)
	 textclickbutton:TweenSize(UDim2.new(0, 32, 0, 33), "Out", "Quint",1,true)
	 textclickbutton:TweenPosition(UDim2.new(0.48909232, 0, 0, 0), "Out", "Quint",1,true)
	 wait(0.4)
	 textclickbutton.Text = "NA"
	 textclickbutton.Active = true
 gui.draggable(textclickbutton)
 end
 coroutine.wrap(PZORYLB_fake_script)()
 
 TextClickButton.MouseButton1Click:Connect(function()
	 gui.barSelect()
		 cmdInput.Text = ''
		 cmdInput:CaptureFocus()
 end)

 --[[
	End of the source code.
	Edited by cocof_word.
	Inspired by rob_dcg_yt.
--]]
