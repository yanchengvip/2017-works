$(document).on('turbolinks:load', function () {
  $('#game_league_submit').on('click', function(){
    var league_begin = getDate($('#game_league_league_begin').val())
    var league_end = getDate($('#game_league_league_end').val())
    if(league_begin >= league_end){
      elert('联赛开始时间必须在联赛结束时间之后')
      return false
    }
  })
})

