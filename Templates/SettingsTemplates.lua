DragonRiderColorSwatchSettingMixin = {};

function DragonRiderColorSwatchSettingMixin:OnLoad()
	SettingsListElementMixin.OnLoad(self);
end

function DragonRiderColorSwatchSettingMixin:Init(initializer)
	SettingsListElementMixin.Init(self, initializer);

	local data = initializer:GetData();
	local colorTable = data.setting:GetValue(); -- Gets the {r,g,b,a} table

	-- Fallback for invalid data to prevent errors
	if type(colorTable) ~= "table" then 
		colorTable = {r = 1, g = 1, b = 1, a = 1};
	end

	-- Create a color object from the RGBA table to set the swatch color
	local colorObj = CreateColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a);
	self.ColorSwatch:SetColor(colorObj);

	self.ColorSwatch:SetScript("OnClick", function()
		local info = {};
		local currentColorTable = data.setting:GetValue();
		if type(currentColorTable) ~= "table" then
			currentColorTable = {r = 1, g = 1, b = 1, a = 1};
		end

		-- Set the color picker's initial values from our table
		info.r, info.g, info.b, info.opacity = currentColorTable.r, currentColorTable.g, currentColorTable.b, currentColorTable.a;
		info.hasOpacity = true; -- Assuming all your colors use alpha

		-- This function runs when the color is changed
		info.swatchFunc = function()
			local r, g, b = ColorPickerFrame:GetColorRGB();
			local a = ColorPickerFrame:GetColorAlpha();
			self.ColorSwatch.Color:SetVertexColor(r, g, b, a);

			-- Get the original table and modify its values directly
			local savedColorTable = data.setting:GetValue();
			savedColorTable.r, savedColorTable.g, savedColorTable.b, savedColorTable.a = r, g, b, a;
			
			-- Save the modified table back. This also triggers the OnValueChanged callback.
			data.setting:SetValue(savedColorTable);
		end;

		-- This function runs if the user cancels
		info.cancelFunc = function ()
			local r, g, b, a = ColorPickerFrame:GetPreviousValues();
			self.ColorSwatch.Color:SetVertexColor(r, g, b, a);

			local savedColorTable = data.setting:GetValue();
			savedColorTable.r, savedColorTable.g, savedColorTable.b, savedColorTable.a = r, g, b, a;
			data.setting:SetValue(savedColorTable);
		end;

		ColorPickerFrame:SetupColorPickerAndShow(info);
	end);
end