
-- Health Bonus 对普通单位无效，用函数重写生命值
function AddHealthBonus(hUnit,nHealth)
	local hMaxHealth=hUnit:GetMaxHealth()
	local hCurrentHealth = hUnit:GetHealth()
	local flRatio=hCurrentHealth/hMaxHealth
	hUnit:SetBaseMaxHealth(hMaxHealth+nHealth)
	hUnit:SetMaxHealth(hMaxHealth+nHealth)
    hUnit:SetHealth(math.floor(flRatio* (hMaxHealth+nHealth)))
end

-- 直接加血 不按比例（臂章）
function AddHealthBonusNoRatio(hUnit,nHealth)
	local hMaxHealth=hUnit:GetMaxHealth()
	local hCurrentHealth = hUnit:GetHealth()
	hUnit:SetBaseMaxHealth(hMaxHealth+nHealth)
	hUnit:SetMaxHealth(hMaxHealth+nHealth)
    hUnit:SetHealth(hCurrentHealth+nHealth)
end




function RemoveHealthBonus(hUnit,nHealth)
	local hMaxHealth=hUnit:GetMaxHealth()
	local hCurrentHealth = hUnit:GetHealth()
	local flRatio=hCurrentHealth/hMaxHealth

	hUnit:SetBaseMaxHealth(hMaxHealth-nHealth)
	hUnit:SetMaxHealth(hMaxHealth-nHealth)

	if hUnit:IsAlive() then
	    local flCurrentHealth=math.ceil( flRatio* (hMaxHealth-nHealth))
	    if flCurrentHealth <1 then
	        flCurrentHealth = 1  
	    end
	    hUnit:SetHealth(flCurrentHealth)
    end
end



-- 直接扣血 不按比例（臂章）
function RemoveHealthBonusNoRatio(hUnit,nHealth)

	local hMaxHealth=hUnit:GetMaxHealth()
	local nCurrentHealth = hUnit:GetHealth()

	hUnit:SetBaseMaxHealth(hMaxHealth-nHealth)
	hUnit:SetMaxHealth(hMaxHealth-nHealth)

	if hUnit:IsAlive() then 
	  local nNewHealth= nCurrentHealth-nHealth
	  if nNewHealth<1 then
         nNewHealth=1
	  end
      hUnit:SetHealth(nNewHealth)
    end
end

