library(RedditExtractoR)


reddit_comments <- NULL


for (i in 1:nrow(reddit_data)){
  print(i)

  content <- reddit_content(paste(reddit_data$post_url[i]))

  r_comments <- data.frame(comment = content$comment)
  r_commenter <- data.frame(commenter = content$user)

  tmp_df <- data.frame(image = reddit_data$title[i],
                       comment = r_comments$comment,
                       commenter = r_commenter$commenter)

  reddit_comments <- rbind(reddit_comments, tmp_df)
  rm(tmp_df)

}


# 4. Text analysis --------------
r_text <- reddit_comments %>%
  unnest_tokens(word, comment) %>%
  anti_join(stop_words)

r_text <- data.frame(table(unlist(r_text$word)))

#order by number of favourites
r_text <- r_text[with(r_text, order(-Freq)),]

#keep top 100 to match reddit data
r_text <- r_text[1:100,]

r_text$Freq <- 1

set.seed(420024)
wordcloud2(r_text, size = .15,
           rotateRatio = 0)


f_text <- flickr_comments %>%
  unnest_tokens(word, comment) %>%
  anti_join(stop_words)

f_text <- data.frame(table(unlist(f_text$word)))

#order by number of favourites
f_text <- f_text[with(f_text, order(-Freq)),]

#keep top 100 to match reddit data
f_text <- f_text[1:100,]

f_text$Freq <- 1


set.seed(420024)
wordcloud2(f_text, size = .15,
           rotateRatio = 0)
