#' Retrieve additional game information for major and minor league games via the MLB api \url{http://statsapi.mlb.com/api/}
#'
#' @param game_pk The unique game_pk identifier for the game
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr spread
#' @importFrom tibble tibble
#' @import dplyr
#' @return Returns a data frame that includes supplemental information, such as
#' weather, official scorer, attendance, etc., for the game_pk provided
#' 
#' @export
#'
#' @examples \dontrun{statsapi_gameinfo_pk(566001)}

statsapi_gameinfo_pk <- function(game_pk) {
  
  api_call <- paste0("http://statsapi.mlb.com/api/v1.1/game/", game_pk,"/feed/live")
  payload <- jsonlite::fromJSON(api_call)
  lookup_table <- payload$liveData$boxscore$info %>%
    as.data.frame() %>%
    tidyr::spread(label, value)
  
  year <- stringr::str_sub(payload$gameData$game$calendarEventID, -10, -7)
  
  
  game_table <- tibble::tibble(
    game_date = stringr::str_sub(payload$gameData$game$calendarEventID, -10, -1),
    game_pk = game_pk,
    venue_name = payload$gameData$venue$name,
    venue_id = payload$gameData$venue$id,
    temperature = payload$gameData$weather$temp,
    other_weather = payload$gameData$weather$condition,
    wind = payload$gameData$weather$wind,
    attendance = ifelse("Att" %in% names(lookup_table) == TRUE,
                        select(lookup_table, Att) %>%
                          pull %>%
                          gsub("\\.", "", .),
                        NA),
    start_time = select(lookup_table, `First pitch`) %>% pull %>% gsub("\\.", "", .),
    elapsed_time = select(lookup_table, T) %>% pull() %>%
      gsub("\\.", "", .),
    game_id = payload$gameData$game$id,
    game_type = payload$gameData$game$type,
    # home_sport_code = "mlb",
    official_scorer = payload$gameData$officialScorer$fullName,
    date = names(lookup_table)[1],
    status_ind = payload$gameData$status$statusCode,
    home_league_id = payload$gameData$teams$home$league$id,
    gameday_sw = payload$gameData$game$gamedayType)
  
  return(game_table)
}
