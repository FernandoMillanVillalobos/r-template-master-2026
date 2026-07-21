# Color palettes for data visualization

# Qualitative Color Scale: Primary
# qcs_primary_one_1 <- "#22577a"
# qcs_primary_two_1 <- "#f2ac18" 
# qcs_primary_three_1 <- "#b4ddd4"
# qcs_primary_four_1 <- "#df3340"
# qcs_primary_five_1 <- "#90b673"
# qcs_primary_six_1 <- "#b38677"
# 
# qcs_primary_one_2 <- "#4c718f"
# qcs_primary_two_2 <- "#fabc52"
# qcs_primary_three_2 <- "#cde8e2"
# qcs_primary_four_2 <- "#ec6462"
# qcs_primary_five_2 <- "#a5c48c"
# qcs_primary_six_2 <- "#be9689"
# 
# qcs_primary_one_3 <- "#6e8aa4"
# qcs_primary_two_3 <- "#ffca7a"
# qcs_primary_three_3 <- "#e2f2ee"
# qcs_primary_four_3 <- "#f8918a"
# qcs_primary_five_3 <- "#c5d8b4"
# qcs_primary_six_3 <- "#d1b2a8"  
# 
# qcs_primary_one_4 <- "#94a7bb"
# qcs_primary_two_4 <- "#ffdfae"
# qcs_primary_three_4 <- "#f5faf9"
# qcs_primary_four_4 <- "#ffbab4"
# qcs_primary_five_4 <- "#e0ebd7"
# qcs_primary_six_4 <- "#e3d0ca"

df_primary <- data.frame(name_color = c("qcs_primary_one_4", "qcs_primary_two_4", "qcs_primary_three_4"), hex = c("#94a7bb", "#ffdfae", "#f5faf9"))
df_gender <- data.frame(name_color = c("qcs_primary_four_4", "qcs_primary_five_4", "qcs_primary_six_4"), hex = c("#ffbab4", "#e0ebd7", "#e3d0ca"))

test_function <- function(scale, color_name) {
 if (scale == "primary") {
    v_temp_df <- df_primary
  } else {
    v_temp_df <- df_gender
  }
  v_temp_color <-  (filter(v_temp_df, name_color == color_name))
  return(v_temp_color[1, 2])
  #return(v_temp_color)
}