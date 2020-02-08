--Final Draw
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)	
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,0,id|(1<<32))
	Duel.Hint(HINT_CARD,0,id)
	local c=e:GetHandler()
	
	if Duel.GetFlagEffect(tp,id)==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PREDRAW)
		e2:SetCondition(s.searchcon)
		e2:SetTarget(s.searchtg)
		e2:SetOperation(s.searchop)
		Duel.RegisterEffect(e2,tp)
	end
	--1 flag = 1 counter
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Debug.Message(Duel.GetFlagEffect(tp,id))
end
function s.searchcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
		and Duel.GetFlagEffect(tp,id)>2
		and Duel.GetDrawCount(tp)>0
end
function s.searchfilter(c)
	return c:IsAbleToHand()
end
function s.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.searchop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--draw overwrite, credit to Edo and AlphaKretin
local ddr=Duel.Draw
Duel.Draw = function(...)
	local tb={...}
	local tp=tb[1]
	local count=tb[2]
  local count={...}[2]
  if (Duel.GetFlagEffect(tp,id)>2 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) ) then
    local g=Duel.SelectMatchingCard(tp,LOCATION_DECK,0,tp,count,count)
    Duel.SendToHand(g,tp,REASON_EFFECT)
  else
    ddr(...)
  end
end