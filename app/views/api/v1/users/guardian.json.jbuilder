api_response.builder json do
  json.partial! '/api/v1/users/shared/guardian_verification', :user => @user

  json.guardian_url @user.guardian_url
  json.bungie_url @user.bungie_profile_path
  json.destiny_tracker_url @user.destiny_tracker_path

  if @user.guardian_exists?
    json.statistics do
      json.total_time (@user.guardian&.get_historical_stats_for_account&.mergedAllCharacters&.merged&.allTime&.secondsPlayed&.basic&.value || 0)
      json.time_pve (@user.guardian&.get_historical_stats_for_account&.mergedAllCharacters&.results&.allPvE&.allTime&.secondsPlayed&.basic&.value || 0)
      json.time_pvp (@user.guardian&.get_historical_stats_for_account&.mergedAllCharacters&.results&.allPvP&.allTime&.secondsPlayed&.basic&.value || 0)
      json.pve_kd @user.guardian.get_historical_stats_for_account.mergedAllCharacters.results.allPvE.allTime.killsDeathsRatio.basic.displayValue rescue 0
      json.pvp_kd @user.guardian.get_historical_stats_for_account.mergedAllCharacters.results.allPvP.allTime.killsDeathsRatio.basic.displayValue rescue 0
      json.max_light @user.guardian.get_historical_stats_for_account.mergedAllCharacters.merged.allTime.highestLightLevel.basic.displayValue rescue 0
      json.grimoire_score @user.guardian.get_bungie_account.destinyAccounts.first.grimoireScore rescue 0
    end
  else
    json.statistics Hash.new
  end
end
