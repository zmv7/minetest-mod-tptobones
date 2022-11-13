lastdie = {}

core.register_on_dieplayer(function(player, reason)
	local pos = player and player:get_pos()
	local name = player and player:get_player_name()
	if not (pos and name) then return end
	lastdie[name] = vector.round(pos)
end)

core.register_privilege("tptobones","Allows to use /tptobones command")
core.register_chatcommand("tptobones", {
  description = "TP you or player to last death pos",
  params = "[playername]",
  privs = {tptobones=true},
  func = function(name, param)
	if not param or param == "" then
		param = name
	end
	if param ~= name and not core.check_player_privs(name, {bring=true}) then
		return false, "You need 'bring' priv to teleport other players"
	end
	local player = core.get_player_by_name(param)
	if not player then
		return false, "Invalid player"
	end
	local diepos = lastdie[param]
	if not diepos then
		return false, "Position of last death of "..param.." is not found"
	end
	player:set_pos(diepos)
	return true, param.." teleported to last death pos "..core.pos_to_string(diepos)
end})
