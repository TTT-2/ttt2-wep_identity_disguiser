local plymeta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString("TTT2UpdateDisguiserTarget")
	util.AddNetworkString("TTT2ToggleDisguiserTarget")

	function plymeta:UpdateStoredDisguiserTarget(target)
		self.storedDisguiserTarget = target

		net.Start("TTT2UpdateDisguiserTarget")
		net.WriteEntity(target)
		net.Send(self)

		if not IsValid(target) or not target:IsPlayer() then return end

		LANG.Msg(self, "identity_disguiser_new_target", {name = target:Nick()}, MSG_MSTACK_PLAIN)
	end

	function plymeta:ActivateDisguiserTarget()
		if not self:HasStoredDisguiserTarget() then return end

		self.disguiserTargetActivated = true
		self.disguiserTarget = self.storedDisguiserTarget

		self.disguiserDefaultModel = self:GetModel()

		self:SetModel(self.storedDisguiserTarget:GetModel())

		net.Start("TTT2ToggleDisguiserTarget")
		net.WriteBool(true)
		net.WriteEntity(self)
		net.WriteEntity(self.storedDisguiserTarget)
		net.Broadcast()
	end

	function plymeta:DeactivateDisguiserTarget()
		self.disguiserTargetActivated = false
		self.disguiserTarget = nil

		if self.disguiserDefaultModel then
			self:SetModel(self.disguiserDefaultModel)

			self.disguiserDefaultModel = nil
		end

		net.Start("TTT2ToggleDisguiserTarget")
		net.WriteBool(false)
		net.WriteEntity(self)
		net.Broadcast()
	end

	function plymeta:ToggleDisguiserTarget()
		if self.disguiserTargetActivated then
			self:DeactivateDisguiserTarget()
		else
			self:ActivateDisguiserTarget()
		end
	end
end

if CLIENT then
	net.Receive("TTT2UpdateDisguiserTarget", function()
		LocalPlayer().storedDisguiserTarget = net.ReadEntity()
	end)

	net.Receive("TTT2ToggleDisguiserTarget", function()
		local addDisguise = net.ReadBool()
		local owner = net.ReadEntity()

		if not IsValid(owner) then return end

		if addDisguise then
			owner.disguiserTarget = net.ReadEntity()
		else
			owner.disguiserTarget = nil
		end
	end)
end

function plymeta:HasDisguiserTarget()
	return IsValid(self.disguiserTarget)
end

function plymeta:HasStoredDisguiserTarget()
	return IsValid(self.storedDisguiserTarget)
end

function plymeta:GetDisguiserTarget()
	return self.disguiserTarget
end

function plymeta:GetStoredDisguiserTarget()
	return self.storedDisguiserTarget
end
