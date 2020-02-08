--Terror from the Deep!
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)	
end
function s.flipconfilter(c)
	return c:IsFaceup() and c:IsCode(76634149)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--"cost" check
	if not (Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_ONFIELD,0,1,nil)) then return false end
	--condition
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,0,id|(1<<32))
	Duel.Hint(HINT_CARD,0,id)
	local c=e:GetHandler()
	--trap immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.etarget)
	e1:SetCondition(s.econ)
	e1:SetValue(s.efilter)
	Duel.RegisterEffect(e1,tp)
	--draw+reset
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabel(e1)
	e2:SetCondition(s.leavecon)
	e2:SetOperation(s.leaveop)
	Duel.RegisterEffect(e2,tp)
end
function s.etarget(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function s.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.efilter(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) 
end


function s.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsCode(76634149) and c:GetPreviousControler()==tp 
end
function s.leavecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,rp)
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,0,id|(2<<32))
	Duel.Draw(tp,2,REASON_EFFECT)
	e:GetLabelObject():Reset()
	e:Reset()
end