
-- https://www.unknowncheats.me/forum/payday-2-a/126335-unlock-community-items.html
function WINDLCManager:_check_dlc_data(dlc_data)
    if dlc_data.app_id then
        if dlc_data.no_install then
            --if Steam:is_product_owned(dlc_data.app_id) then
                return true
            --end
        elseif Steam:is_product_installed(dlc_data.app_id) then
            return true
        end
    elseif dlc_data.source_id then
        return true
    end
end

-- https://www.unknowncheats.me/forum/1070654-post2.html
if not GenericDLCManager then return end
function GenericDLCManager:has_pd2_clan() return true end