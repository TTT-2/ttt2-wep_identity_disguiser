local base = "pure_skin_target"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base
HUDELEMENT.icon = Material("vgui/ttt/icon_identity_disguised_hud")

if CLIENT then -- CLIENT

	function HUDELEMENT:PreInitialize()
		BaseClass.PreInitialize(self)

		huds.GetStored("pure_skin"):ForceElement(self.id)

		-- set as fallback default, other skins have to be set to true!
		self.disabledUnlessForced = false
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if HUDEditor.IsEditing then
			self:DrawComponent("- Disguiser Target -")
		elseif client:IsActive() and client:HasStoredDisguiserTarget() then
			local playerNick = {
				name = client:GetStoredDisguiserTarget():Nick()
			}

			if client:HasDisguiserTarget() then
				self:DrawComponent(LANG.GetParamTranslation("identity_disguiser_hud_active", playerNick))
			else
				self:DrawComponent(LANG.GetParamTranslation("identity_disguiser_hud", playerNick))
			end
		end
	end
end
