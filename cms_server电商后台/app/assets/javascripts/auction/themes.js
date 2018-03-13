function control(){
  var link_type = $("#auction_theme_theme_type").val()
  if (link_type == 2){
    $("#auction_theme_keyword").hide()
    $("#auction_theme_brand_id").hide()
    $("#auction_theme_target").hide()
    $("#auction_theme_unsold_count_gteq").hide()
    $("#auction_theme_category1_id").hide()
    $("#auction_theme_category2_id").hide()
    $("#auction_theme_category3_id").hide()
    $("#auction_theme_sort_key").hide()
    $("#auction_theme_sort_method").hide()
    $("#auction_theme_price_gt").hide()
    $("#auction_theme_price_lt").hide()
  }else {
    $("#auction_theme_keyword").show()
    $("#auction_theme_brand_id").show()
    $("#auction_theme_target").show()
    $("#auction_theme_unsold_count_gteq").show()
    $("#auction_theme_category1_id").show()
    $("#auction_theme_category2_id").show()
    $("#auction_theme_category3_id").show()
    $("#auction_theme_sort_key").show()
    $("#auction_theme_sort_method").show()
    $("#auction_theme_price_gt").show()
    $("#auction_theme_price_lt").show()
  }
}
