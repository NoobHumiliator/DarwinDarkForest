
-- Health Bonus 对普通单位无效，用函数重写生命值
function AddHealthBonus(hUnit,nHealth)
	local hMaxHealth=hUnit:GetMaxHealth()
	local hCurrentHealth = hUnit:GetHealth()
	local flRatio=hCurrentHealth/hMaxHealth
	hUnit:SetBaseMaxHealth(hMaxHealth+nHealth)
	hUnit:SetMaxHealth(hMaxHealth+nHealth)
    hUnit:SetHealth(math.floor(flRatio* (hMaxHealth+nHealth)))
end


function RemoveHealthBonus(hUnit,nHealth)
	local hMaxHealth=hUnit:GetMaxHealth()
	local hCurrentHealth = hUnit:GetHealth()
	local flRatio=hCurrentHealth/hMaxHealth
	hUnit:SetBaseMaxHealth(hMaxHealth-nHealth)
	hUnit:SetMaxHealth(hMaxHealth-nHealth)
    hUnit:SetHealth(math.floor(flRatio* (hMaxHealth-nHealth)))
end