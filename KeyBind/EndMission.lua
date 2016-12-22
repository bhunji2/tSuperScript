-- End Mission
if not IsInGame() then return end
if not IsPlaying()then return end

managers.money:_add_to_total( _G.tSuperScriptSet["GiveMoney"] * 10000)

--https://www.unknowncheats.me/forum/payday-2-a/151239-instant-win.html
local num_winners = managers.network:session():amount_of_alive_players()
managers.network:session():send_to_peers("mission_ended", true, num_winners)
game_state_machine:change_state_by_name("victoryscreen", { num_winners = num_winners, personal_win = alive(managers.player:player_unit()) })